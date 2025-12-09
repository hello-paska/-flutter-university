import 'package:flutter/material.dart';
import 'pizza.dart';
import 'pizza_detail.dart';

final List<Pizza> listReceptionPizza = [
  Pizza(
    "Маргарита",
    "Кукурудза, томати, сир, курка, ананнас",
    """Інгредієнти:
Основа піци: Борошно — 500 г, Дріжджі свіжі — 15 г, Олія — 50 мл, Вода — 320 мл, Сіль за смаком

Начинка:
Помідори — 6 шт., Часник — 2 зубчики, Олія — 50 мл, Твердий сир — 250 г, Зелень — за смаком, Сіль, перець — за смаком

Приготування:
1. Змішати дріжджі з просіяним борошном, розтерти пальцями до дрібних крихт. Додати олію і воду, замісити пружне тісто.
2. Накрити тісто серветкою і залишити підходити на 1 годину.
3. Розкачати тісто в тонкий пласт, викласти на присипане борошном деко.
4. Збити в блендері помідори з олією, часником, сіллю, перцем і зеленню, змастити тісто соусом.
5. Половиною сиру посипати корж, зверху викласти кружечки помідорів.
6. Посипати рештою сиру й випікати при 220°C 15–20 хвилин, доки краї не стануть золотистими.""",
    "pizza1.jpg",
  ),
  Pizza(
    "М'ясна",
    "Кукурудза, томати, сир, курка, ананнас",
    "Повний рецепт м'ясної піци. Тут може бути детальний опис інгредієнтів та приготування.",
    "pizza2.jpg",
  ),
  Pizza(
    "Чотири сири",
    "Кукурудза, томати, сир, курка, ананнас",
    "Повний рецепт піци «Чотири сири». Опис інгредієнтів і кроків приготування.",
    "pizza3.jpg",
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pizza App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Лабораторна 4")),
        body: ListDinamicPizza(listPizza: listReceptionPizza),
      ),
    );
  }
}

class ListDinamicPizza extends StatelessWidget {
  final List<Pizza> listPizza;

  const ListDinamicPizza({Key? key, required this.listPizza}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: listPizza.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final pizza = listPizza[index];

        return ListTile(
          title: Text(
            pizza.title,
            style: const TextStyle(fontSize: 22),
          ),
          leading: Image(
            image: AssetImage("assets/images/${pizza.url_img}"),
            width: 40,
          ),
          trailing: const Icon(Icons.arrow_right),
          subtitle: Text("Склад: ${pizza.description}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PizzaDetail(pizzaSelected: pizza),
              ),
            );
          },
        );
      },
    );
  }
}
