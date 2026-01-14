import 'package:crm_apps/main.dart';
import 'package:crm_apps/new/component/empty_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GroupStatusModel {
  final String total;
  final String status_text;
  Key? key;
  GroupStatusModel(
      {
      required this.status_text,
      required this.total,
      this.key});
}

class GroupStatusWidget extends StatelessWidget {
  final List<GroupStatusModel> children;
  final Function()? onPressFilter;
  final String title;
  final Widget? footer;
  final IconData? iconButton;
  final bool? isLoading;
  final bool? isEmpty;
  final String? hintButton;
  final bool? isTv;
  final bool? isBlackTheme;
  final double? height_header;
  final double? height_footer;
  final Color? color;
  const GroupStatusWidget(
      {super.key,
      required this.children,
      this.footer,
      required this.title,
      this.onPressFilter,
      this.iconButton,
      this.isEmpty = false,
      this.isLoading = false,
      this.hintButton,
      this.isTv = false,
      this.isBlackTheme = false,
      this.height_header,
      this.height_footer, this.color});

  @override
  Widget build(BuildContext context) {
    Widget _child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(children.length, (index) {
        Color _color = color ?? Colors.transparent;
       
        if (index == children.length - 1) {
         
          return Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    children[index].total,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: _color),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    children[index].status_text,
                    style: TextStyle(color: ColorHelper.hint, fontSize: 15),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        } else {
          
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: ColorHelper.border, width: 1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    children[index].total,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: _color),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(children[index].status_text,
                      style:
                          TextStyle(color: ColorHelper.hint, fontSize: 15),
                      textAlign: TextAlign.center)
                ],
              ),
            ),
          );
        }
      }),
    );
    return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: height_header ?? 80,
              decoration: BoxDecoration(
                gradient: isBlackTheme!
                    ? ColorHelper.color_grad5
                                : ColorHelper.color_grad3,
                border: Border(bottom: BorderSide(color: ColorHelper.border)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: isBlackTheme! ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressFilter != null
                      ? Tooltip(
                          message: hintButton,
                          child: IconButton(
                              onPressed: onPressFilter,
                              icon: Icon(iconButton ?? Icons.filter)),
                        )
                      : SizedBox()
                ],
              ),
            ),
            Expanded(
              child: isLoading == true
                  ? Center(
                      child: loadingProgress(25),
                    )
                  : isEmpty == true
                      ? CustomEmptyWidget(title: 'Not Available Right Now')
                      : _child,
            ),
            isLoading == true
                ? SizedBox()
                : footer != null
                    ? Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: ColorHelper.divider)),
                            gradient: isBlackTheme!
                                ? ColorHelper.color_grad5
                                : ColorHelper.color_grad3,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: footer,
                      )
                    : SizedBox()
          ],
        ),
        height: height_footer ?? (footer != null ? 260 : 200),
        decoration: BoxDecoration(
            color: isBlackTheme! ? Colors.white.withOpacity(0.9) : Colors.white,
            border: Border.all(color: ColorHelper.divider),
            borderRadius: BorderRadius.circular(10)));
  }
}
