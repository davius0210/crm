import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'main.dart';
import 'package:image/image.dart' as img;
import 'models/globalparam.dart' as param;
import 'controller/other_cont.dart' as cother;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// A widget that displays the picture taken by the user.
class PreviewAndSavePictureScreen extends StatefulWidget {
  final String token;
  final String filePath;
  final XFile image;
  final String routeName;
  final bool isLocSaved;

  const PreviewAndSavePictureScreen(
      {super.key,
      required this.image,
      required this.token,
      required this.routeName,
      required this.filePath,
      required this.isLocSaved});

  @override
  State<PreviewAndSavePictureScreen> createState() =>
      LayerPreviewAndSavePictureScreen();
}

class LayerPreviewAndSavePictureScreen
    extends State<PreviewAndSavePictureScreen> {
  bool isLoading = false;
  late Placemark placeGPS;
  Position? posGPS =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
  bool bGPSstat = false;
  final XFile? imageFile = null;

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      return false;
    }

    //Request Permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    bGPSstat = serviceEnabled;

    return bGPSstat;
  }

  void initLoadPage() async {
    try {
      bool isValid = await handlePermission();

      if (!isValid) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void saveImage() async {
    try {
      setState(() {
        isLoading = true;
      });

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

              if (widget.isLocSaved) {
                await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.bestForNavigation,
                        timeLimit: Duration(seconds: param.gpsTimeOut))
                    .then((value) {
                  setState(() {
                    posGPS = value;
                  });
                }).onError((error, stackTrace) {
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

                    await placemarkFromCoordinates(
                            posGPS!.latitude, posGPS!.longitude)
                        .then((value) {
                      placeGPS = value.first;
                    }).onError((error, stackTrace) {
                      placeGPS = Placemark(
                          street: '',
                          subLocality: '',
                          subAdministrativeArea: '',
                          postalCode: '');
                    });

                    File imageFile = File(widget.image.path);
                    img.Image? imageCustom =
                        img.decodeImage(imageFile.readAsBytesSync());

                    img.drawString(
                      imageCustom!,
                      color: img.ColorRgb8(15, 228, 23),
                      '$fdDate ',
                      font: img.arial24,
                      x: 10,
                      y: imageCustom.height - 125,
                      wrap: true,
                    );

                    img.drawString(
                      imageCustom!,
                      color: img.ColorRgb8(15, 228, 23),
                      '${posGPS!.latitude},${posGPS!.longitude}',
                      font: img.arial24,
                      x: 10,
                      y: imageCustom.height - 100,
                      wrap: true,
                    );

                    img.drawString(
                      imageCustom,
                      color: img.ColorRgb8(15, 228, 23),
                      '${placeGPS.street}, ${placeGPS.subLocality}',
                      font: img.arial24,
                      x: 10,
                      y: imageCustom.height - 75,
                      wrap: true,
                    );

                    img.drawString(
                      imageCustom,
                      color: img.ColorRgb8(15, 228, 23),
                      '${placeGPS.subAdministrativeArea}, ${placeGPS.postalCode}',
                      font: img.arial24,
                      x: 10,
                      y: imageCustom.height - 50,
                      wrap: true,
                    );

                    imageFile.writeAsBytesSync(
                        img.encodeJpg(imageCustom, quality: 46));
                  } else {
                    File imageFile = File(widget.image.path);
                    img.Image? imageCustom =
                        img.decodeImage(imageFile.readAsBytesSync());

                    img.drawString(
                      imageCustom!,
                      color: img.ColorRgb8(15, 228, 23),
                      '$fdDate 0,0',
                      font: img.arial24,
                      x: 10,
                      y: imageCustom.height - 100,
                      wrap: true,
                    );

                    imageFile.writeAsBytesSync(
                        img.encodeJpg(imageCustom, quality: 46));
                  }

                  //Save Image
                  File(widget.filePath).createSync(recursive: true);
                  await widget.image.saveTo(widget.filePath);

                  Future.delayed(Duration.zero).then((value) {
                    Navigator.popUntil(
                        context, ModalRoute.withName(widget.routeName));
                  });
                } else {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text(
                            'Fake GPS terdeteksi, warning sudah diberikan ke admin')));

                  Navigator.pop(context);
                }
              } else {
                //tidak perlu simpan titik GPS
                File imageFile = File(widget.image.path);
                img.Image? imageCustom =
                    img.decodeImage(imageFile.readAsBytesSync());

                img.drawString(
                  imageCustom!,
                  color: img.ColorRgb8(15, 228, 23),
                  fdDate,
                  font: img.arial24,
                  x: 10,
                  y: imageCustom.height - 100,
                  wrap: true,
                );

                imageFile
                    .writeAsBytesSync(img.encodeJpg(imageCustom, quality: 46));

                //Save image
                File(widget.filePath).createSync(recursive: true);
                await widget.image.saveTo(widget.filePath);

                Future.delayed(Duration.zero).then((value) {
                  Navigator.popUntil(
                      context, ModalRoute.withName(widget.routeName));
                });
              }
            } else {
              if (!mounted) return;

              Navigator.pop(context);
            }
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Mohon matikan air plane mode')));

            Navigator.pop(context);
          }
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(
                  'Deteksi aplikasi error: J-$isJailBroken, D-$isDeveloperMode')));
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Image.file(File(widget.image.path))),
            isLoading
                ? loadingProgress(ScaleSize.textScaleFactor(context))
                : ElevatedButton.icon(
                    onPressed: () {
                      saveImage();
                    },
                    icon: Icon(Icons.save,
                        size: 24 * ScaleSize.textScaleFactor(context)),
                    label: const Text('Save'))
          ],
        ));
  }
}
