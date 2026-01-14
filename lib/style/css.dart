import 'package:flutter/material.dart';

BoxDecoration boxDecorDrawerHeader() {
  return const BoxDecoration(
    //color: Color.fromARGB(255, 176, 255, 165),
    color: Color.fromARGB(255, 255, 191, 96),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
  );
}

BoxDecoration boxDecorMenuHeader() {
  return BoxDecoration(
      color: Colors.orange[600] //Color.fromARGB(255, 0, 138, 7),
      // shape: BoxShape.rectangle,
      // borderRadius: BorderRadius.all(Radius.circular(20)),
      );
}

BoxDecoration boxDecorTitle() {
  return BoxDecoration(
    color: Color.fromARGB(255, 1, 121, 111),
  );
}

ButtonStyle buttonRound() {
  return ButtonStyle(
      maximumSize: MaterialStateProperty.all(const Size(200, 44)),
      minimumSize: MaterialStateProperty.all(const Size(150, 44)),
      backgroundColor: const MaterialStatePropertyAll(Colors.blue),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
}

ButtonStyle buttonRoundSmallRed() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red),
      maximumSize: MaterialStateProperty.all(const Size(150, 32)),
      minimumSize: MaterialStateProperty.all(const Size(100, 32)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
}

ButtonStyle buttonRoundSmallGreen() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.green),
      maximumSize: MaterialStateProperty.all(const Size(150, 32)),
      minimumSize: MaterialStateProperty.all(const Size(100, 32)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
}

ButtonStyle buttonCheckRoundActive() {
  return ButtonStyle(
      maximumSize: MaterialStateProperty.all(const Size(150, 44)),
      minimumSize: MaterialStateProperty.all(const Size(100, 44)),
      backgroundColor: const MaterialStatePropertyAll(Colors.blue),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
}

ButtonStyle buttonCheckRound() {
  return ButtonStyle(
      maximumSize: MaterialStateProperty.all(const Size(150, 44)),
      minimumSize: MaterialStateProperty.all(const Size(100, 44)),
      backgroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.blue))));
}

OutlineInputBorder borderOutlineInputRound() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      borderSide:
          BorderSide(color: Color.fromARGB(255, 14, 64, 138), width: 2));
}

OutlineInputBorder borderModalRound() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25), topRight: Radius.circular(25)),
  );
}

BoxDecoration boxDecorDropdownStyle() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 243, 255, 241),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.grey[700]!),
  );
}

InputDecoration textInputStyle(String? hintTxt, TextStyle? txtStyle,
    String? labelTxt, Icon? preIcon, IconButton? postIcon) {
  return InputDecoration(
      fillColor: const Color.fromARGB(255, 243, 255, 241),
      filled: true,
      hintStyle: txtStyle,
      hintText: hintTxt,
      labelText: labelTxt,
      labelStyle: txtStyle,
      floatingLabelStyle: const TextStyle(fontStyle: FontStyle.normal),
      border: borderOutlineInputRound(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      prefixIcon: preIcon,
      suffixIcon: postIcon);
}

InputDecoration textCartInputStyle(String? hintTxt, TextStyle? txtStyle,
    String? labelTxt, Icon? preIcon, IconButton? postIcon, String promosi) {
  return InputDecoration(
      fillColor: const Color.fromARGB(255, 243, 255, 241),
      filled: true,
      hintStyle: txtStyle,
      hintText: hintTxt,
      labelText: labelTxt,
      labelStyle: txtStyle,
      floatingLabelStyle: TextStyle(
          fontStyle: FontStyle.normal,
          color: promosi == '0' ? null : Colors.green[700]),
      border: borderOutlineInputRound(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      prefixIcon: preIcon,
      suffixIcon: postIcon);
}

InputDecoration textInputNoBorderStyle(String? hintTxt, TextStyle? txtStyle,
    String? labelTxt, Icon? preIcon, IconButton? postIcon) {
  return InputDecoration(
      fillColor: const Color.fromARGB(255, 243, 255, 241),
      filled: true,
      hintStyle: txtStyle,
      hintText: hintTxt,
      labelText: labelTxt,
      labelStyle: txtStyle,
      floatingLabelStyle: const TextStyle(fontStyle: FontStyle.normal),
      // border: borderOutlineInputRound(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      prefixIcon: preIcon,
      suffixIcon: postIcon);
}

InputDecoration textInputStyleWithError(String? hintTxt, TextStyle? txtStyle,
    String? labelTxt, bool isError, String? errText, Icon? preIcon) {
  return InputDecoration(
      fillColor: const Color.fromARGB(255, 243, 255, 241),
      filled: true,
      hintStyle: txtStyle,
      hintText: hintTxt,
      errorText: isError ? errText : null,
      labelText: labelTxt,
      border: borderOutlineInputRound(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      prefixIcon: preIcon);
}

TextStyle textExpandBold() {
  return const TextStyle(
      color: Color.fromARGB(255, 196, 43, 43), fontWeight: FontWeight.w600);
}

TextStyle textHeaderBold() {
  return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

TextStyle textHeaderNormal() {
  return const TextStyle(color: Colors.white);
}

TextStyle textNormalBold() {
  return const TextStyle(fontWeight: FontWeight.bold);
}

TextStyle textSmallSize() {
  return const TextStyle(fontSize: 14);
}

TextStyle textSmallSizeBlack() {
  return const TextStyle(fontSize: 14, color: Colors.black);
}

TextStyle textSmallSizeGreen() {
  return const TextStyle(fontSize: 14, color: Colors.green);
}

TextStyle textSmallSizeWhite() {
  return const TextStyle(fontSize: 14, color: Colors.white);
}

TextStyle textSmallSizeBlackBold() {
  return const TextStyle(
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
}

TextStyle textSmallSizeWhiteBold() {
  return const TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
}

TextStyle textExtraSmallSizeBold() {
  return const TextStyle(
      fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
}

// TextStyle textExtraSmallSizeWithBackground() {
//   return TextStyle(fontSize: 12, backgroundColor: Colors.red[600], color: Colors.white);
// }

TextStyle textExtraSmallSizeError() {
  return TextStyle(fontSize: 12, color: Colors.red[800]);
}

RoundedRectangleBorder boxStyle() {
  return RoundedRectangleBorder(
      side: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10));
}

//Checkbox
RoundedRectangleBorder checkBoxShape() {
  return const RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(10)));
}

BorderSide checkBoxBorder() {
  return const BorderSide(color: Color.fromARGB(192, 240, 5, 5), width: 2);
}

// Color headerFormBox() {
//   return const Color.fromARGB(255, 0, 138, 7);
// }

Color checkColor() {
  return Colors.blue;
}

Color tileSelectedColor() {
  return Colors.blue;
}

Color textCheckSelectedColor() {
  return Colors.white;
}

Color titleDialogColor() {
  return Colors.orange;
}

Color titleDialogColorGreen() {
  return Color.fromARGB(255, 1, 121, 111);
}
