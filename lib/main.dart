import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, // Keep "DEBUG" like your screenshot
      title: 'Flutter Demo Home Page',
      home: const FlutterDemoHomePage(),
    );
  }
}

class FlutterDemoHomePage extends StatefulWidget {
  const FlutterDemoHomePage({super.key});

  @override
  State<FlutterDemoHomePage> createState() => _FlutterDemoHomePageState();
}

class _FlutterDemoHomePageState extends State<FlutterDemoHomePage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final List<Map<String, dynamic>> _items = [];

  void _addItem() {
    final item = _itemController.text.trim();
    final qty = _quantityController.text.trim();

    if (item.isEmpty || qty.isEmpty) return;

    setState(() {
      _items.add({'item': item, 'qty': qty});
      _itemController.clear();
      _quantityController.clear();
    });
  }

  Future<void> _confirmDelete(int index) async {
    final item = _items[index];
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Item"),
        content: Text("Are you sure you want to delete ${item['item']}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("No")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Yes")),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbf4ff), // light purple/white background
      appBar: AppBar(
        backgroundColor: const Color(0xffd3b6ff), // purple header
        title: const Text(
          'Flutter Demo Home Page',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: 'Type the item here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      hintText: 'Type the quantity here',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff1e8ff),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  onPressed: _addItem,
                  child: const Text("Click here"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _items.isEmpty
                ? const Center(
              child: Text(
                "There are no items in the list",
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final entry = _items[index];
                return GestureDetector(
                  onLongPress: () => _confirmDelete(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Center(
                      child: Text(
                        "${index + 1}: ${entry['item']}  quantity: ${entry['qty']}",
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
