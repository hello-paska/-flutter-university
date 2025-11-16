import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<String> pizza = <String>[
  "Маргарита",
  "М'ясна",
  "Чотири сири",
];

final List<String> receptPizza = <String>[
  "Тісто, томатний соус, моцарела, базилік",
  "Бекон, мисливські ковбаски, шинка, сир",
  "Чеддер, моцарела, фета, рокфор",
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pizza App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Завдання 3"),
        ),
        body: ListDynamicPizza(),
      ),
    );
  }
}

class ListDynamicPizza extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: pizza.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: const Icon(Icons.local_pizza, size: 28),
          title: Text(
            pizza[index],
            style: const TextStyle(fontSize: 22),
          ),
          trailing: const Icon(Icons.arrow_right),
          subtitle: Text("Склад: ${receptPizza[index]}"),
          onTap: () {
            Fluttertoast.showToast(
              msg: "Ви обрали: ${pizza[index]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
        );
      },
    );
  }
}
