// Flutter App Development Example
// This example demonstrates using Flutter Code Guard during Flutter app development
//
// IMPORTANT: This is a template showing Flutter code structure.
// To use this example:
// 1. Create a new Flutter app: flutter create my_flutter_app
// 2. Replace lib/main.dart with this example code
// 3. Run: flutter_code_guard --watch
// 4. Make changes to see real-time code analysis feedback

// Example Flutter app structure (requires flutter dependencies in pubspec.yaml):
/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Guard Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Code Guard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/

// Simple Dart example that works with Flutter Code Guard:
void main() {
  final counter = Counter();

  print('Initial counter value: ${counter.value}');
  counter.increment();
  print('After increment: ${counter.value}');
  counter.decrement();
  print('After decrement: ${counter.value}');
}

class Counter {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
  }

  void decrement() {
    _value--;
  }

  void reset() {
    _value = 0;
  }
}
