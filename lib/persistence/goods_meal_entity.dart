import 'package:flutter/cupertino.dart';

class GoodsMealEntity {
  final Key key;
  final int qty;
  final double value;

  const GoodsMealEntity({required this.qty,required this.key,required this.value});

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'qty': qty,
      'value': value
    };
  }

}