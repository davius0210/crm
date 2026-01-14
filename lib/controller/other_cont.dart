import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:datetime_setting/datetime_setting.dart';
import '../models/globalparam.dart' as param;

//Format angka saat ketik
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldVal = oldValue.text.replaceAll('.', '').replaceAll(',', '');
    String newVal = newValue.text.replaceAll('.', '').replaceAll(',', '');
    double? oldValueText = double.tryParse(oldVal) ?? 0;
    double? newValueText = double.tryParse(newVal) ?? 0;

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;

      String newString = param.idNumberFormat.format(newValueText);

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    return newValue;
  }
}

class LongThousandsSeparatorAnDecimalInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,##0.###", "en_US");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hilangkan semua koma sebelum proses
    String newText = newValue.text.replaceAll(',', '');

    // Kalau bukan angka valid, tetap return apa adanya
    if (newText.isEmpty || !RegExp(r'^\d+(\.\d+)?$').hasMatch(newText)) {
      return newValue;
    }

    // Format ulang dengan ribuan
    String newString = formatter.format(double.tryParse(newText) ?? 0);

    // Hitung posisi cursor
    int selectionIndex =
        newString.length - (newValue.text.length - newValue.selection.end);

    if (selectionIndex < 0) selectionIndex = 0;
    if (selectionIndex > newString.length) selectionIndex = newString.length;

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class ThousandsSeparatorAnDecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldVal = oldValue.text.replaceAll(',', '');
    String newVal = newValue.text.replaceAll(',', '');
    double? oldValueText = double.tryParse(oldVal) ?? 0;
    double? newValueText = double.tryParse(newVal) ?? 0;

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      String newString = param.enNumberFormat.format(newValueText);
      int selectionOffset = 0;
      if (newValue.selection.extentOffset > newString.length) {
        selectionOffset = newString.length;
      } else {
        selectionOffset = newValue.selection.extentOffset;
      }

      String oldString = param.enNumberFormat.format(oldValueText);
      int oldOffsetDifferent =
          oldString.length - oldValue.selection.extentOffset;
      int newOffsetDifferent =
          newString.length - newValue.selection.extentOffset;

      // adjust cursor when thousand or decimal separator be omitted
      if (oldOffsetDifferent != newOffsetDifferent && oldValueText > 0) {
        if (oldString.length > newString.length) {
          selectionOffset -= oldOffsetDifferent - newOffsetDifferent;
        } else {
          selectionOffset += newOffsetDifferent - oldOffsetDifferent;
        }
      }

      print(oldValue.selection.extentOffset);
      print(oldString.length);
      print(newValue.selection.extentOffset);
      print(newString.length);

      if (double.tryParse(newString) == 0) {
        newString = '';
        selectionOffset = 0;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(offset: selectionOffset),
      );
    }

    return newValue;
  }
}

class EnThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    // String oldVal = oldValue.text.replaceAll('.', '').replaceAll(',', '');
    // String newVal = newValue.text.replaceAll('.', '').replaceAll(',', '');
    String oldVal = oldValue.text.replaceAll(',', '');
    String newVal = newValue.text.replaceAll(',', '');
    double? oldValueText = double.tryParse(oldVal) ?? 0;
    double? newValueText = double.tryParse(newVal) ?? 0;

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      // Jika .0 maka gunakan param.enNumberFormatQty.format(newValueText)
      String newString = '';
      if (newValueText % 1 == 0) {
        newString = param.enNumberFormatQty.format(newValueText);
      } else {
        newString = param.enNumberFormatDec.format(newValueText);
      }
      int selectionOffset = newString.length - selectionIndex;
      if (selectionOffset < 0) selectionOffset = 0;
      if (selectionOffset > newString.length)
        selectionOffset = newString.length;

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: selectionOffset, //newString.length - selectionIndex,
        ),
      );
    }

    return newValue;
  }
}

Future<bool> dateTimeSettingValidation() async {
  //get date time device setting
  bool isTimeAuto = await DatetimeSetting.timeIsAuto();
  bool isTimeZoneAuto = await DatetimeSetting.timeZoneIsAuto();

  //validate date time device must automatic
  if (!isTimeAuto || !isTimeZoneAuto) {
    await DatetimeSetting.openSetting();

    return false;
  }
  {
    return true;
  }
}
