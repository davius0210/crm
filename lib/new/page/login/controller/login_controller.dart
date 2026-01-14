import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:crm_apps/controller/api_cont.dart' as capi;
import 'package:crm_apps/controller/database_cont.dart' as cdb;
import 'package:crm_apps/controller/other_cont.dart' as cother;
import 'package:crm_apps/controller/salesman_cont.dart' as csf;
import 'package:crm_apps/home_page.dart';
import 'package:crm_apps/new/helper/toast_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
   final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  var isLoading = false.obs;
  var version = ''.obs;
  initPage()async{
    PackageInfo packInfo = await PackageInfo.fromPlatform();
    version.value = packInfo.version;
  }
  fetchLogin(BuildContext context)async{
    try {
      if (formKey.currentState!.validate()) {
      var msgToken = await FirebaseMessaging.instance.getToken();
      const key = 'xlYh7659sagrASnn';
      
      final salt1 = key + passController.text;
      var bytesToHash1 = utf8.encode(salt1);
      var sha512Digest1 = sha512.convert(bytesToHash1);
      
      final salt2 = passController.text + key;
      var bytesToHash2 = utf8.encode(salt2);
      var sha512Digest2 = sha512.convert(bytesToHash2);
      
      final hashedPassword = sha512Digest1.toString() + passController.text + sha512Digest2.toString();
      var bytesToHash3 = utf8.encode(hashedPassword);
      var sha512Digest3 = sha512.convert(bytesToHash3);

     
      bool isDateTimeSettingValid = await cother
                                        .dateTimeSettingValidation();
      if (isDateTimeSettingValid) {
        isLoading.value = true;
        //
        bool isDoneUpdate = true;
        //await checkUpdate();

        if (isDoneUpdate) {
          PackageInfo packInfo =
              await PackageInfo.fromPlatform();
          var fLoginResult = await capi.loginMD(
              userController.text,
              passController.text,
              packInfo.version,
              msgToken!);
          if (fLoginResult!.fdAkses!) {
            // Map<String, dynamic> item =
            //     await capi.getKeyDevice(
            //         fLoginResult!.fdKodeSF);

            // if (item['data'].isEmpty) {
            AndroidId aid = const AndroidId();
            String? androidid =
                await aid.getId();
            if (!await MobileNumber.hasPhonePermission) {
              await MobileNumber.requestPhonePermission;
              return;
            }

            // if (true) {
           
            if ('idAndroid' ==
                fLoginResult!.fdKeyDevice) {
              // item['fdKeyDevice']) {
              // if (androidInfo.id ==
              //         item['fdKeyDevice'] &&
              //     mobileNumber ==
              //         item['fdSIM']) {
              print(
                  'token: ${fLoginResult!.fdToken.toString()}');
              // yang di return
              var msgChangeUser =
                  await csf.checkIsKodeMdExist(
                      fLoginResult!.fdKodeSF);
              if (msgChangeUser != '') {
                ToastHelper.show(context, message: msgChangeUser, icon: Icon(Icons.info, color: Colors.green,));
          
              } else {
                await cdb.initDB2(); //#LOG
                await cdb.initDB(fLoginResult!);

                await cdb.onUpdateAlter();

                //Go to home page
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      settings:
                          const RouteSettings(
                              name: 'home'),
                      builder: (context) =>
                          HomePage(
                              user:
                                  fLoginResult!)),
                  (Route<dynamic> route) =>
                      false);
                
              }
            } else {
             ToastHelper.show(context, message: 'Anda tidak dapat menggunakan device ini', icon: Icon(Icons.info, color: Colors.yellow,));
          

            }
            // } else if (item['data'] == '401') {
            //   await sessionExpired();
            // }
          } else {
            ToastHelper.show(context, message: ' ${fLoginResult.message}', icon: Icon(Icons.dangerous, color: Colors.red,));
          
           
          }
        }
      }
      //
        isLoading.value = false;
       
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
     
                  
  }
  @override
  void onInit() {
    super.onInit();
    initPage();
  }
}
