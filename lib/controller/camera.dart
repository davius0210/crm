import 'dart:io';
import 'dart:async';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crm_apps/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image/image.dart' as img;
import 'other_cont.dart' as cother;
import '../models/globalparam.dart' as param;

final ImagePicker _picker = ImagePicker();
bool bGPSstat = false;
Position? posGPS = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);

Future<void> saveImage(context, bool isLocSaved, XFile image, String filePath,
    String routeName) async {
  try {
    bool isJailBroken = false;
    bool isDeveloperMode = false;

    //Ed1 - 26/09/23 - comment selama develop
    if (true) {
      // if (!isJailBroken && !isDeveloperMode) {
      bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

      if (isDateTimeSettingValid) {
        final statusAirPlaneMode =
            await AirplaneModeChecker.instance.checkAirplaneMode();

        if (statusAirPlaneMode == AirplaneModeStatus.off) {
          bGPSstat = await handlePermission();

          if (bGPSstat) {
            String fdDate = param.dateTimeFormatView.format(DateTime.now());

            if (isLocSaved) {
              await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.bestForNavigation,
                      timeLimit: Duration(seconds: param.gpsTimeOut))
                  .then((value) {
                posGPS = value;
              }).onError((error, stackTrace) {
                print(error);
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('error gps timeout')));
              });

              if (!posGPS!.isMocked) {
                if (posGPS!.latitude != 0 && posGPS!.longitude != 0) {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setDouble('fdLa', posGPS!.latitude);
                  prefs.setDouble('fdLg', posGPS!.longitude);

                  try {
                    await placemarkFromCoordinates(
                            posGPS!.latitude, posGPS!.longitude)
                        .then((value) {
                          placeGPS = value.first;
                        })
                        .timeout(Duration(seconds: param.gpsTimeOut))
                        .onError((error, stackTrace) {
                          placeGPS = Placemark(
                              street: '',
                              subLocality: '',
                              subAdministrativeArea: '',
                              postalCode: '');
                        });
                  } on TimeoutException catch (e) {
                    placeGPS = Placemark(
                        street: '',
                        subLocality: '',
                        subAdministrativeArea: '',
                        postalCode: '');
                  } on Exception catch (e) {
                    placeGPS = Placemark(
                        street: '',
                        subLocality: '',
                        subAdministrativeArea: '',
                        postalCode: '');
                  }

                  File imageFile = File(image.path);
                  img.Image? imageCustom =
                      img.decodeImage(imageFile.readAsBytesSync());

                  img.drawString(
                    imageCustom!,
                    color: img.ColorRgb8(15, 228, 23),
                    '$fdDate\n${posGPS!.latitude},${posGPS!.longitude}\n${placeGPS.street}, ${placeGPS.subLocality}\n${placeGPS.subAdministrativeArea}, ${placeGPS.postalCode}',
                    font: img.arial48,
                    x: 10,
                    y: imageCustom.height - 225,
                    wrap: true,
                  );

                  imageFile.writeAsBytesSync(
                      img.encodeJpg(imageCustom, quality: 46));
                } else {
                  File imageFile = File(image.path);
                  img.Image? imageCustom =
                      img.decodeImage(imageFile.readAsBytesSync());

                  img.drawString(
                    imageCustom!,
                    color: img.ColorRgb8(15, 228, 23),
                    '$fdDate 0,0',
                    font: img.arial48,
                    x: 10,
                    y: imageCustom.height - 100,
                    wrap: true,
                  );

                  imageFile.writeAsBytesSync(
                      img.encodeJpg(imageCustom, quality: 46));
                }

                //Save Image
                File(filePath).createSync(recursive: true);
                await image.saveTo(filePath);

                Future.delayed(Duration.zero).then((value) {
                  Navigator.popUntil(context, ModalRoute.withName(routeName));
                });
              } else {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text(
                          'Fake GPS terdeteksi, warning sudah diberikan ke admin')));

                Navigator.pop(context);
              }
            } else {
              //tidak perlu simpan titik GPS
              File imageFile = File(image.path);
              img.Image? imageCustom =
                  img.decodeImage(imageFile.readAsBytesSync());

              img.drawString(
                imageCustom!,
                color: img.ColorRgb8(15, 228, 23),
                fdDate,
                font: img.arial48,
                x: 10,
                y: imageCustom.height - 100,
                wrap: true,
              );

              imageFile
                  .writeAsBytesSync(img.encodeJpg(imageCustom, quality: 46));

              //Save image
              File(filePath).createSync(recursive: true);
              await image.saveTo(filePath);

              Future.delayed(Duration.zero).then((value) {
                Navigator.popUntil(context, ModalRoute.withName(routeName));
              });
            }
          } else {
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Mohon matikan air plane mode')));

          Navigator.pop(context);
        }
      }
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text(
                'Deteksi aplikasi error: J-$isJailBroken, D-$isDeveloperMode')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('error: $e')));
  }
}

Future<void> pickCamera(context, String fdToken, String pageTitle,
    String filePath, String routeName, bool isLocSaved) async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1536, //1080,
      maxHeight: 2048, //1920,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      await saveImage(context, isLocSaved, image, filePath, routeName)
          .onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('error: ${error.toString()}')));
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('error: $e')));
  }
}
