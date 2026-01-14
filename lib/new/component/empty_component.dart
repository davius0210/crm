import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomEmptyWidget extends StatelessWidget {
  final Widget? child;
  final String title;
  final String? subtitle;
  final bool? availableButton;
  final String? titleButton;
  final Function()? onPress;
  const CustomEmptyWidget({
    super.key,
    this.child,
    required this.title,
    this.subtitle,
    this.availableButton = false,
    this.onPress,
    this.titleButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child ?? Image.asset('assets/images/empty.png', height: 50),
        SizedBox(height: 10),
        Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle != null
            ? Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 13, color: ColorHelper.hint),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : SizedBox(),
        availableButton == true
            ? Column(
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: onPress,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        titleButton!,
                        style: TextStyle(
                          color: ColorHelper.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }
}