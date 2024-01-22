import 'package:flutter/material.dart';

import 'models/goods_bag.dart';

class BestCombo extends StatelessWidget {
  final List<GoodsBag> bestCombo;
  final double remainingAmount;

  const BestCombo({super.key, required this.bestCombo, required this.remainingAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Miglior combinazione")),
      body: Center(
        child: Column(
          children: _bestComboToText()
        ),
      ),
    );
  }

  List<Row> _bestComboToText() {
    var rowList = bestCombo.map((e) =>
        Row(
            children: [
              Text('${e.quantity} buoni da ${e.value}')]
        )).toList();
    rowList.add(Row(children: [Text('Restano da pagare $remainingAmount€')]));
    return rowList;
  }
}
