import 'package:flutter/material.dart';
import 'app_database.dart';
import 'todo_dao.dart';
import 'todo_item.dart';

void main() => runApp(const ShoppingApp());

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List (Floor)',
      theme: ThemeData(useMaterial3: true),
      home: const ShoppingHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShoppingHome extends StatefulWidget {
  const ShoppingHome({super.key});

  @override
  State<ShoppingHome> createState() => _ShoppingHomeState();
}

class _ShoppingHomeState extends State<ShoppingHome> {
  late AppDatabase _db;
  late TodoDao _dao;

  final _itemCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  List<TodoItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initDbAndLoad();
  }

  Future<void> _initDbAndLoad() async {
    _db = await $FloorAppDatabase.databaseBuilder('shopping.db').build();
    _dao = _db.todoDao;
    final saved = await _dao.getAll();
    setState(() {
      _items = saved;
      _loading = false;
    });
  }

  Future<void> _addItem() async {
    final name = _itemCtrl.text.trim();
    final qty = int.tryParse(_qtyCtrl.text.trim());
    if (name.isEmpty || qty == null || qty <= 0) return;

    final newId = await _dao.insertOne(TodoItem(name: name, quantity: qty));
    setState(() {
      _items.add(TodoItem(id: newId, name: name, quantity: qty));
      _itemCtrl.clear();
      _qtyCtrl.clear();
    });
  }

  Future<void> _deleteItem(TodoItem item) async {
    await _dao.deleteOne(item);
    setState(() {
      _items.removeWhere((e) => e.id == item.id);
    });
  }

  Future<void> _confirmDelete(TodoItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Do you want to delete "${item.name}" (qty: ${item.quantity})?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
        ],
      ),
    );
    if (ok == true) {
      await _deleteItem(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item.name}" removed')),
        );
      }
    }
  }

  // Per instructions: create the list UI in a function that returns a widget.
  Widget ListPage() {
    return Column(
      children: [
        // One line: Item, Qty, Add
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _itemCtrl,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Qty',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addItem(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addItem, child: const Text('Add')),
          ],
        ),
        const SizedBox(height: 12),

        // Empty state or list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _items.isEmpty
              ? const Center(
            child: Text(
              'There are no items in the list',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          )
              : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final e = _items[index];
              return GestureDetector(
                onLongPress: () => _confirmDelete(e),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        // Left: row number + item name
                        Expanded(
                          child: Text(
                            '${index + 1}. ${e.name}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        // Right: quantity
                        Text(
                          '${e.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _itemCtrl.dispose();
    _qtyCtrl.dispose();
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List (Floor)')),
      body: Padding(padding: const EdgeInsets.all(12), child: ListPage()),
    );
  }
}