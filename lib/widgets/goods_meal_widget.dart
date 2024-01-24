import 'package:flutter/material.dart';
import 'package:quanto_sono_buono/formatters/decimal_number_regex_input_formatter.dart';

class GoodsMealWidget extends StatefulWidget {
  final int index;
  const GoodsMealWidget({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => GoodsMealWidgetState();
}

class GoodsMealWidgetState extends State<GoodsMealWidget> {
  String _quantityDropdownButton = '0';
  String _value = '0';
  final DecimalNumberRegexInputFormatter _decimalNumberRegexInputFormatter =
      DecimalNumberRegexInputFormatter();
  final TextEditingController _controller = TextEditingController();
  final List<DropdownMenuItem<String>> _zeroToTwentyList =
      List<DropdownMenuItem<String>>.generate(
          21,
          (index) => DropdownMenuItem(
                value: "$index",
                child: Text("$index"),
              ));

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50)),
            height: 90,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Reset"),
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Quantità", style: TextStyle(fontSize: 18)),
                      Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                              value: _quantityDropdownButton,
                              dropdownColor: Theme.of(context).cardTheme.color,
                              items: _zeroToTwentyList,
                              onChanged: (s) => setState(() {
                                    _quantityDropdownButton = s!;
                                  })))
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Valore", style: TextStyle(fontSize: 18)),
                      ElevatedButton(
                          onPressed: () => _showPopup(context),
                          child: Text(
                            "$_value €",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  ))
            ]));
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Inserisci valore'),
          content: TextField(
            controller: _controller,
            inputFormatters: [_decimalNumberRegexInputFormatter],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                setState(() {
                  _value = _controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

/*void _calculate() {
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => BestCombo(bestCombo: bestCombo, remainingAmount: bestDiff))).then((value) => setState((){}));

  }*/

/*TextField(
  controller: _controller,
  inputFormatters: [_decimalNumberRegexInputFormatter],
  keyboardType: const TextInputType.numberWithOptions(
  decimal: true),
  )*/
}
