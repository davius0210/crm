import 'dart:ui';

import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DialogCip {
  final String title;
  final String? message;
  final String? cancel;
  final String? ok;
  final bool? isHideCancel;
  final Widget? child;
  final double? width;
  final Function()? onOk;
  final Function()? onCancel;
  DialogCip(
      {this.child,
      required this.title,
      this.message,
      this.ok,
      this.cancel,
      this.isHideCancel = false,
      this.width, this.onOk, this.onCancel});
}


class FunctionHelper {
  static String shortText({required String text, int? max_length = 50}) {
    return text.length > max_length!
        ? text.substring(0, max_length + 1) + ' ...'
        : text;
  }

  static String dateFormat({String? tanggal}) {
    return (tanggal != null || tanggal != '')
        ? DateFormat('dd MMMM yyyy HH:mm').format(DateTime.parse(tanggal!))
        : '';
  }


  static void showDialogs(
    BuildContext context, {
    Function(bool result)? onResult,
    Widget? content,
    Widget? icon,
    String? title,
    Widget? footer,
    double? height,
  }) {
    showModalBottomSheet<void>(
      context: context,
      clipBehavior: Clip.none,
      builder: (BuildContext context) {
        return Container(
          height: height ?? 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (onResult != null) {
                              onResult(false);
                            }
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (icon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: icon,
                                  ),
                              ],
                            ),
                            if (content != null) content,
                          ],
                        ),
                      ],
                    ),
                  ),
                  footer ?? SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  static Future<bool?> AlertDialogCip(BuildContext context, DialogCip dialog) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            clipBehavior: Clip.none,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: dialog.width ?? 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(dialog.title,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: ColorHelper.primary),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 10,
                        ),
                        dialog.message != null
                            ? Column(
                                children: [
                                  Text(dialog.message!,
                                      style:
                                          TextStyle(color: ColorHelper.primary),
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        dialog.child ?? SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      dialog.isHideCancel == false
                          ? Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)),
                                  onTap: () {
                                    if(dialog.onCancel!=null){
                                      dialog.onCancel!();
                                    }
                                    Navigator.pop(context, false);

                                  },
                                  hoverColor: ColorHelper.blue,
                                  child: Ink(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(dialog.cancel ?? 'Batal',
                                          style: TextStyle(
                                              color: ColorHelper.primary,
                                              fontSize: 17),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: dialog.isHideCancel == false
                                  ? Radius.zero
                                  : Radius.circular(20),
                            ),
                            onTap: () {
                              if(dialog.onOk!=null){
                                      dialog.onOk!();
                                    }
                              Navigator.pop(context, true);
                            },
                            hoverColor: ColorHelper.secondary,
                            child: Ink(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: dialog.isHideCancel == false
                                      ? Radius.zero
                                      : Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dialog.ok ?? 'Hapus',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  
}