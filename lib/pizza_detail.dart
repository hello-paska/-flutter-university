import 'package:flutter/material.dart';
import 'pizza.dart';

class PizzaDetail extends StatelessWidget {
  const PizzaDetail({
    Key? key,
    required this.pizzaSelected,
  }) : super(key: key);

  final Pizza pizzaSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pizzaSelected.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pizzaSelected.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image(
                image: AssetImage("assets/images/${pizzaSelected.url_img}"),
                width: 120,
              ),
              const SizedBox(height: 16),
              Text(
                pizzaSelected.fullDescription,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_left),
      ),
    );
  }
}
