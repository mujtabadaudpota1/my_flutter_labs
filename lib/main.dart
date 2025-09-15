import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CST2335 Lab 1',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1) counter as double
  double _counter = 0.0;

  // 2) font size variable
  double _myFontSize = 30.0;

  // 3) increment but cap at 99
  void _incrementCounter() {
    setState(() {
      if (_counter < 99) {
        _counter += 1.0;
      }
    });
  }

  // 4) update font size via slider
  void _setNewValue(double newValue) {
    setState(() {
      _myFontSize = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: _myFontSize),
            ),
            const SizedBox(height: 24),
            Text(
              _counter.toStringAsFixed(0),
              style: TextStyle(
                fontSize: _myFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // slider controls font size
            Slider(
              value: _myFontSize,
              min: 12,
              max: 60,
              divisions: 48,
              label: _myFontSize.toStringAsFixed(0),
              onChanged: _setNewValue,
            ),
          ],
        ),
      ),
    );
  }
}
