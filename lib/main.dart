import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stateful Counter Widget",
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        backgroundColor: Colors.amber[300],
        appBar: AppBar(title: Text("Завдання 2")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HintLabel('Натисніть «-» для зменшення'),
              SizedBox(height: 8.0),
              CounterWidget(), // кастомний віджет
              SizedBox(height: 8.0),
              HintLabel('Натисніть «+» для збільшення'),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------
// Власний віджет HintLabel
// ----------------------------
class HintLabel extends StatelessWidget {
  final String text;

  const HintLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.amber[200]),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}

// ----------------------------
// Власний кастомний CounterWidget
// ----------------------------
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[600],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _decrement,
            icon: Icon(Icons.remove),
          ),
          Text(
            '$_count',
            style: TextStyle(fontSize: 40),
          ),
          IconButton(
            onPressed: _increment,
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
