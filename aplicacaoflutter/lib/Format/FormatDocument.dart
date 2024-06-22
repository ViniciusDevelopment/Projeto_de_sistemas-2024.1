import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 14) {
      return oldValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    newText = newText.padLeft(11, '0');

    if (newText.length < 3) {
      return newValue;
    }

    String firstPart = newText.substring(0, 3);
    String secondPart = newText.substring(3, 6);
    String thirdPart = newText.substring(6, 9);
    String fourthPart = newText.substring(9, 11);

    return TextEditingValue(
      text: '$firstPart.$secondPart.$thirdPart-$fourthPart',
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}

class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 18) {
      return oldValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    newText = newText.padLeft(14, '0');

    if (newText.length < 3) {
      return newValue;
    }

    String firstPart = newText.substring(0, 2);
    String secondPart = newText.substring(2, 5);
    String thirdPart = newText.substring(5, 8);
    String fourthPart = newText.substring(8, 12);
    String fifthPart = newText.substring(12, 14);

    return TextEditingValue(
      text: '$firstPart.$secondPart.$thirdPart/$fourthPart-$fifthPart',
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}