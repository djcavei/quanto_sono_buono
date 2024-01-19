import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/goods_bag.dart';

class BestCombo extends StatelessWidget {

  final List<GoodsBag> bestCombo;

  const BestCombo({super.key, required this.bestCombo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Miglior combinazione")),
      body: Center(
        child: Row(
          children: _bestComboToText(),
        ),
      ),
    );
  }

  List<Text> _bestComboToText() {
    return bestCombo.map((e) => Text('\n     ${e.quantity} buoni da ${e.value}')).toList();
  }



}