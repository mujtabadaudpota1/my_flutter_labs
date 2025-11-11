import 'package:flutter/material.dart';
import 'app_database.dart';
import 'todo_dao.dart';
import 'todo_item.dart';

// ---------- ENTRYPOINT ----------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 9 Responsive Layout',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: const MyShoppingPage(),
    );
  }
}
// --------------------------------

class MyShoppingPage extends StatefulWidget {
  const MyShoppingPage({super.key});
  @override
  State<MyShoppingPage> createState() => _MyShoppingPageState();
}

class _MyShoppingPageState extends State<MyShoppingPage> {
  late AppDatabase _db;
  late ToDoDao _dao;

  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  List<ToDoItem> _items = [];
  ToDoItem? _selected; // selected item for details view

  @override
  void initState() {
    super.initState();
    _openDb();
  }

  Future<void> _openDb() async {
    _db = await $FloorAppDatabase.databaseBuilder('week9.db').build();
    _dao = _db.todoDao;
    await _reload();
  }

  Future<void> _reload() async {
    _items = await _dao.findAll();
    setState(() {});
  }

  bool _isWideLandscape(BuildContext c) {
    final s = MediaQuery.of(c).size;
    return (s.width > s.height) && (s.width > 720);
  }

  Future<void> _addItem() async {
    final name = _nameCtrl.text.trim();
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    if (name.isEmpty) return;

    await _dao.insertItem(ToDoItem(name: name, quantity: qty));
    _nameCtrl.clear();
    _qtyCtrl.clear();
    _selected = null;
    await _reload();
  }

  Future<void> _deleteSelected() async {
    final it = _selected;
    if (it == null || it.id == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Delete "${it.name}" permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
        ],
      ),
    );
    if (ok == true) {
      await _dao.deleteById(it.id!);
      _selected = null;
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${it.name}"')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablet = _isWideLandscape(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            tooltip: 'Close details',
            onPressed: _selected == null ? null : () => setState(() => _selected = null),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: tablet
        // -------- Tablet / Landscape (equal split) --------
            ? Column(
          children: [
            _buildInputRow(),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left side: List
                  Expanded(flex: 1, child: _buildList()),

                  // Center divider (visible gray line)
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),

                  // Right side: Details
                  Expanded(flex: 1, child: _buildDetails()),
                ],
              ),
            ),
          ],
        )

        // -------- Phone / Portrait (stacked) --------
            : Column(
          children: [
            _buildInputRow(),
            const SizedBox(height: 12),
            Expanded(
              child: _selected == null ? _buildList() : _buildDetails(),
            ),
          ],
        ),
      ),
    );
  }

  // Row for adding items
  Widget _buildInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              hintText: 'Type the item here',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _qtyCtrl,
            decoration: const InputDecoration(
              hintText: 'Type the quantity here',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _addItem(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: _addItem, child: const Text('Add')),
      ],
    );
  }

  // List of items (tap to open details)
  Widget _buildList() {
    if (_items.isEmpty) {
      return const Center(
        child: Text('There are no items in the list', style: TextStyle(fontSize: 16)),
      );
    }
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = _items[i];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                  child: Text('${i + 1}: ${it.name}', style: const TextStyle(fontSize: 16))),
              Text('quantity: ${it.quantity}', style: const TextStyle(fontSize: 16)),
            ],
          ),
          subtitle: Text('ID: ${it.id ?? '-'}'),
          onTap: () => setState(() => _selected = it),
        );
      },
    );
  }

  // Details view for selected item
  Widget _buildDetails() {
    final it = _selected;
    if (it == null) {
      return const Center(
        child: Text(
          'Select an item to see details.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(it.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Quantity: ${it.quantity}'),
          Text('Database ID: ${it.id ?? '-'}'),
          const Spacer(),
          Row(
            children: [
              FilledButton(onPressed: _deleteSelected, child: const Text('Delete')),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: () => setState(() => _selected = null),
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}