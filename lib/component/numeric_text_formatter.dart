// 数字格式
// Created by vhsal.com
// Date: 2021-06-03

import 'package:flutter/services.dart';

// 只允许输入小数
class NumericTextInputFormatter extends TextInputFormatter {
  static const defaultValue = 0;
  static int strToInt(String str, [int defaultValue = defaultValue]) {
    try {
      return int.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
        value != defaultValue.toString() &&
        strToInt(value, defaultValue) == defaultValue) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
