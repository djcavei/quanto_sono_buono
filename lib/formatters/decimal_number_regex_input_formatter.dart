import 'package:flutter/services.dart';

class DecimalNumberRegexInputFormatter extends TextInputFormatter {
  final RegExp _regex;

  DecimalNumberRegexInputFormatter.ofGoodsMeal(): _regex = RegExp(r'^[1-9]\d?(\.\d?)?$');
  DecimalNumberRegexInputFormatter.ofTotalAmount(): _regex = RegExp(r'^[1-9]\d{0,2}(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return _regex.hasMatch(newValue.text) || newValue.text == '' ? newValue : oldValue;
  }

}