import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 950) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
  getMenu(BuildContext context, {required String type})async{
    List<Widget> _listMenu = [];
    switch (type) {
      case 'sales_act':
        _listMenu = [
          
        ];
        break;
      case 'store_act':

        break;
      case 'files':

        break;
      default:
    }
  }
}