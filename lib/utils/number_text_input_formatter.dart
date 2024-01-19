import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
      final StringBuffer newText = StringBuffer();
      final int newTextLength = newValue.text.length;
      int selectionIndex = newValue.selection.end;
      int usedSubstringIndex = 0;

      if (newTextLength >= 1) {
        newText.write('+');
        if (newValue.selection.end >= 1) selectionIndex++;
      }

      if (newTextLength >= 3) {
        newText.write('${newValue.text.substring(0, usedSubstringIndex = 2)} ');
        if (newValue.selection.end >= 2) selectionIndex += 1;
      }
      // Dump the rest.
      if (newTextLength >= usedSubstringIndex) {
        newText.write(newValue.text.substring(usedSubstringIndex));
      }
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
  }
}