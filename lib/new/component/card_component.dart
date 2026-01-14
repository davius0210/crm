import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final Widget content;
  final Color? color;
  final List<BoxShadow>? shadow;
  const CardComponent({super.key, required this.content, this.color, this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: color ?? ColorHelper.primary,width: 3),
                          right: BorderSide(color: color ?? ColorHelper.primary,width: 3),
                        ),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: shadow,
                        color: Colors.white
                      ),
                      padding: EdgeInsets.all(10),
                      child: content);
  }
}