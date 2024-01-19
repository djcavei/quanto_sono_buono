import 'package:flutter/material.dart';
import 'package:quanto_sono_buono/models/goods_bag.dart';

import 'best_combo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quanto sono buono',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quanto sono buono Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoodsBag seven = GoodsBag(value: 7, quantity: 0);
  GoodsBag fourFive = GoodsBag(value: 4.5, quantity: 0);
  double amount = 0;
  final TextEditingController _controller = TextEditingController();

  void _increment7Goods() {
    setState(() {
      if (seven.quantity < 20) {
        ++seven.quantity;
      }
    });
  }

  void _decrement7Goods() {
    setState(() {
      if (seven.quantity > 0) {
        --seven.quantity;
      }
    });
  }

  void _increment4_5Goods() {
    setState(() {
      if (fourFive.quantity < 20) {
        ++fourFive.quantity;
      }
    });
  }

  void _decrement4_5Goods() {
    setState(() {
      if (fourFive.quantity > 0) {
        --fourFive.quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _calculate,
          tooltip: "Calcola",
          child: const Icon(Icons.calculate),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Quanto buono sono"),
        ),
        body: Column(children: [
          Row(
            children: <Widget>[
              const Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text("Quantità buoni da 7€",
                          style: TextStyle(color: Colors.black))
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: _decrement7Goods,
                              child:
                                  const Icon(Icons.remove, color: Colors.grey)),
                          Text('${seven.quantity}'),
                          TextButton(
                              onPressed: _increment7Goods,
                              child: const Icon(Icons.add,
                                  color: Colors.blueAccent)),
                        ],
                      )
                    ],
                  ))
            ],
          ),
          Row(
            children: <Widget>[
              const Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text("Quantità buoni da 4,5€",
                          style: TextStyle(color: Colors.black))
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: _decrement4_5Goods,
                              child:
                                  const Icon(Icons.remove, color: Colors.grey)),
                          Text('${fourFive.quantity}'),
                          TextButton(
                              onPressed: _increment4_5Goods,
                              child: const Icon(Icons.add,
                                  color: Colors.blueAccent)),
                        ],
                      )
                    ],
                  ))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(children: [
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tocca per importo spesa',
                      ),
                    )
                  ]))
            ],
          ),
        ]));
  }

  void _calculate() {
    double amount;
    try {
      amount = double.parse(_controller.text);
    } on Exception catch (_) {
      return;
    }
    double bestDiff = amount;
    List<GoodsBag> bestCombo = [];
    List<GoodsBag> myGoodsBag = [seven, fourFive];

    void calculateRec(int idx, double expense, List<GoodsBag> currentBag) {
      if(expense <= amount && amount - expense < bestDiff) {
        bestDiff = amount - expense;
        bestCombo = currentBag.map((e) => e.clone()).toList();
      }
      if(idx < myGoodsBag.length && expense <= amount) {
        if(myGoodsBag[idx].quantity > currentBag[idx].quantity) {
          ++currentBag[idx].quantity;
          calculateRec(idx, expense + myGoodsBag[idx].value, currentBag);
          --currentBag[idx].quantity;
        }
        calculateRec(idx + 1, expense, currentBag);
      }
    }

    calculateRec(0, 0, myGoodsBag.map((e) => GoodsBag(value: e.value, quantity: 0)).toList());
    Navigator.push(context, MaterialPageRoute(builder: (context) => BestCombo(bestCombo: bestCombo))).then((value) => setState((){}));

  }
}
