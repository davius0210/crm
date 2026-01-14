import 'package:flutter/material.dart';

class MenuMD {
  final String fdKodeMenu;
  final String fdMenu;
  final int fdUrutan;
  final int fdMandatory;
  final int? code;
  final String? message;
  bool? isExist = false;
  Widget? navigator;
  Widget? icon;

  MenuMD({required this.fdKodeMenu, required this.fdMenu, required this.fdUrutan, required this.fdMandatory,
    this.isExist, this.navigator, this.icon, this.code, this.message});

  factory MenuMD.fromJson(Map<String, dynamic> json) {
    return MenuMD(
      fdKodeMenu: json['fdKodeMenu'] ?? '',
      fdMenu: json['fdMenu'] ?? '',
      fdUrutan: json['fdUrutan'] ?? 0,
      fdMandatory: json['fdMandatory'] ?? 0,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  factory MenuMD.setData(Map<String, dynamic> item) {
    return MenuMD(
      fdKodeMenu: item['fdKodeMenu'] ?? '',
      fdMenu: item['fdMenu'] ?? '',
      fdUrutan: item['fdUrutan'] ?? 0,
      fdMandatory: item['fdMandatory'] ?? 0,
    );
  }
}