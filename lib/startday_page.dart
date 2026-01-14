import 'dart:async';
import 'dart:io';
import 'dart:math';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_ce/device_info_ce.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'previewphoto_page.dart';
import 'package:path/path.dart' as cpath;
import 'controller/other_cont.dart' as cother;
import 'controller/salesman_cont.dart' as csales;
import 'controller/log_cont.dart' as clog;
import 'controller/api_cont.dart' as capi;
import 'controller/database_cont.dart' as cdb;
import 'controller/camera.dart' as ccam;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'models/logdevice.dart' as mlog;
import 'style/css.dart' as css;

Placemark? place;

class StartDayPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;

  const StartDayPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.startDayDate});

  @override
  State<StartDayPage> createState() => LayerStartDay();
}

class LayerStartDay extends State<StartDayPage> {
  final String startDayActivity = '01';
  bool isLoading = false;
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  TextEditingController txtKMControl = TextEditingController();
  bool isImgExist = false;
  bool bGPSstat = false;
  String kmImgPath = '';
  String startDayDate = '';
  int statusSent = 0;
  String addressLoc = '';
  String txtAfterConfirm = '';
  Position? posGPS =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
  final service = FlutterBackgroundService();
  final XFile? imageFile = null;
  Map<MarkerId, Marker> markers = {};
  CameraPosition _userLocation = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  bool isMapReady = false;
  List<mlog.Param> listParam = [];

  LatLngBounds getMapBounds(Position startPos, Marker markerTarget) {
    double minLat = min(startPos.latitude, markerTarget.position.latitude);
    double minLng = min(startPos.longitude, markerTarget.position.longitude);
    double maxLat = max(startPos.latitude, markerTarget.position.latitude);
    double maxLng = max(startPos.longitude, markerTarget.position.longitude);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> sessionExpired() async {
    await cdb.logOut();
    service.invoke("stopService");

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Session expired')));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });

      await getImageFromDevice();
      await initData();
      await clog.setGlobalParamByKodeSf(widget.user.fdKodeSF);
      await handlePermission();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<void> getImageFromDevice() async {
    setState(() {
      kmImgPath =
          '${param.appDir}/${param.imgPath}/${param.kmStartFullImgName(widget.user.fdKodeSF, widget.startDayDate)}';
    });

    File(kmImgPath).exists().then((value) {
      setState(() {
        isImgExist = value;
      });
    });
  }

  Future<void> initData() async {
    try {
      setState(() {
        startDayDate = '';
        statusSent = 0;
      });

      msf.SalesActivity? sf = await csales.getStart_EndDayInfo(
          widget.user.fdKodeSF, widget.user.fdKodeDepo, startDayActivity);

      if (sf != null) {
        setState(() {
          //sugeng remark tidak input KM
          txtKMControl.text = param.idNumberFormat.format(sf.fdKM);
          startDayDate =
              param.dateTimeFormatView.format(DateTime.parse(sf.fdStartDate));
          statusSent = sf.fdStatusSent;
          posGPS = Position(
              longitude: sf.fdLG,
              latitude: sf.fdLA,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
        });

        setState(() {
          txtAfterConfirm = 'LA : ${sf.fdLA} \nLG : ${sf.fdLG}';
          addressLoc =
              'Jalan : ${sf.fdStreet == '' ? '-' : sf.fdStreet} \nKabupaten : ${sf.fdSubArea == '' ? '-' : sf.fdSubArea} \nKelurahan : ${sf.fdSubLocality == '' ? '-' : sf.fdSubLocality} \nKode pos : ${sf.fdPostalCode == '' ? '-' : sf.fdPostalCode}';
        });
      }

      setState(() {});
    } catch (e) {
      throw Exception(e);
    }
  }

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

    try {
      posGPS = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: param.gpsTimeOut));
    } on TimeoutException {
      if (!mounted) return false;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('error gps timeout')));
    }
    bGPSstat = serviceEnabled;

    return true;
  }

  void gMapInitializes(GoogleMapController controller) async {
    try {
      setState(() {
        isMapReady = false;
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: param.gpsTimeOut));
      if (position.latitude != 0 && position.longitude != 0) {
        listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);

        //sugeng remark hitung jarak titik GPS
        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, position.latitude, position.longitude);
        if (distanceInMeters > listParam[0].fdMaxDistance) {
          if (!mounted) return;

          alertDialogForm(
              'Titik visit anda tidak sesuai dengan titik GPS outlet', context);
        }
        //sugeng end remark
      }
      _userLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 18);

      //sugeng remark hanya tampil satu titik saja
      MarkerId markerId = const MarkerId('outlet1');
      Marker markerOutlet1 = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(position.latitude, position.longitude));
      markers[markerId] = markerOutlet1;

      LatLngBounds mapBounds = getMapBounds(position, markerOutlet1);
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(mapBounds, 20),
      );
      //sugeng end remark

      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 20),
      );

      setState(() {
        isMapReady = true;
      });
    } catch (e) {
      setState(() {
        isMapReady = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text(
                'error load Map: $e. Mohon mengaktifkan GPS dan mengulang start day dari halaman home')));
    }
  }

  void confirmStartDay() async {
    try {
      setState(() {
        isLoading = true;
      });

      // sugeng remark tidak kirim image
      if (isImgExist) {
        bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

        if (isDateTimeSettingValid) {
          final statusAirPlaneMode =
              await AirplaneModeChecker.instance.checkAirplaneMode();

          if (statusAirPlaneMode == AirplaneModeStatus.off) {
            bGPSstat = await handlePermission();

            if (bGPSstat) {
              await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.bestForNavigation,
                      timeLimit: Duration(seconds: param.gpsTimeOut))
                  .then((value) => posGPS = value)
                  .onError((error, stackTrace) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('error gps timeout')));

                posGPS =  Position(
                    longitude: 0,
                    latitude: 0,
                    timestamp: DateTime.now(),
                    accuracy: 0,
                    altitude: 0,
                    heading: 0,
                    speed: 0,
                    speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);

                return posGPS!;
              });

              if (posGPS!.latitude != 0 && posGPS!.longitude != 0) {
                if (!posGPS!.isMocked) {
                  String fdDate = widget.startDayDate;
                  String fdStartDateTime =
                      param.dateTimeFormatDB.format(DateTime.now());

                  try {
                    await placemarkFromCoordinates(
                            posGPS!.latitude, posGPS!.longitude)
                        .then((value) {
                          place = value.first;

                          addressLoc =
                              'Jalan : ${place!.street == '' ? '-' : place!.street} \nKabupaten : ${place!.subAdministrativeArea == '' ? '-' : place!.subAdministrativeArea} \nKelurahan : ${place!.subLocality == '' ? '-' : place!.subLocality} \nKode pos : ${place!.postalCode == '' ? '-' : place!.postalCode}';
                        })
                        .timeout(Duration(seconds: param.gpsTimeOut))
                        .onError((error, stackTrace) {
                          place = Placemark(
                              street: '',
                              subLocality: '',
                              subAdministrativeArea: '',
                              postalCode: '');
                        });
                  } on TimeoutException catch (e) {
                    place = Placemark(
                        street: '',
                        subLocality: '',
                        subAdministrativeArea: '',
                        postalCode: '');
                  } on Exception catch (e) {
                    place = Placemark(
                        street: '',
                        subLocality: '',
                        subAdministrativeArea: '',
                        postalCode: '');
                  }

                  print('pos2:${posGPS!.latitude} - ${posGPS!.longitude}');

                  // sugeng remark tidak simpan foto
                  String kmFileName = param.pathImgServer(
                      widget.user.fdKodeDepo,
                      widget.user.fdKodeSF,
                      fdDate,
                      param.kmStartFileName(widget.user.fdKodeSF, fdDate));

                  await csales.insertSFActivity(
                      widget.user.fdKodeSF,
                      widget.user.fdKodeDepo,
                      // sugeng remark tidak input KM
                      int.parse(txtKMControl.text
                          .replaceAll('.', '')
                          .replaceAll(',', '')),
                      kmFileName,
                      fdStartDateTime,
                      '',
                      posGPS!.latitude,
                      posGPS!.longitude,
                      startDayActivity,
                      '',
                      0,
                      0,
                      fdDate,
                      0,
                     (await DeviceInfoCe.batteryInfo())
                                                      .level
                          .toString(),
                      place!.street,
                      place!.subLocality,
                      place!.subAdministrativeArea,
                      place!.postalCode);

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final String? fdTanggal = prefs.getString('startDayDate');
                  await prefs.setDouble('fdLa', posGPS!.latitude);
                  await prefs.setDouble('fdLg', posGPS!.longitude);
                  await prefs.setString(
                      'fdJamStartDay',
                      param.timeFormatView.format(
                          param.dateTimeFormatDB.parse(fdStartDateTime)));
                  await prefs.setString('fdKmStartDay', kmFileName);
                  if (fdTanggal == null) {
                    await clog.insertGpsLog(
                        posGPS!.latitude.toString(),
                        posGPS!.longitude.toString(),
                        (await DeviceInfoCe.batteryInfo())
                                                      .level
                            .toString(),
                        place!.street,
                        place!.subLocality,
                        place!.subAdministrativeArea,
                        place!.postalCode,
                        'Start Day',
                        '',
                        '',
                        param.dtFormatDB
                            .format(DateTime.parse(fdStartDateTime)),
                        fdStartDateTime);
                  } else {
                    await clog.insertGpsLog(
                        posGPS!.latitude.toString(),
                        posGPS!.longitude.toString(),
                        (await DeviceInfoCe.batteryInfo())
                                                      .level
                            .toString(),
                        place!.street,
                        place!.subLocality,
                        place!.subAdministrativeArea,
                        place!.postalCode,
                        'Start Day',
                        '',
                        '',
                        fdTanggal,
                        fdStartDateTime);
                  }
                  startDayDate = param.dateTimeFormatView
                      .format(DateTime.parse(fdStartDateTime));

                  Map<String, dynamic> result = {};

                  try {
                    // sugeng remark tidak kirim foto
                    Map<String, dynamic> responseCode =
                        await sendImagetoServer(kmImgPath);

                    if (responseCode['code'] == 1) {
                      result = await capi.sendSalesActtoServer(
                          widget.user,
                          fdStartDateTime,
                          '',
                          '',
                          startDayActivity,
                          // sugeng remark tidak input KM
                          int.parse(txtKMControl.text
                              .replaceAll('.', '')
                              .replaceAll(',', '')),
                          kmFileName,
                          posGPS!.latitude,
                          posGPS!.longitude,
                          (await DeviceInfoCe.batteryInfo())
                                                      .level
                              .toString(),
                          place!.street,
                          place!.subLocality,
                          place!.subAdministrativeArea,
                          place!.postalCode,
                          fdStartDateTime,
                          fdDate);
                    } else if (responseCode['code'] == 401) {
                      result['fdData'] = '401';
                      result['fdMessage'] = 'error 401';
                    } else if (responseCode['code'] == 400) {
                      result['fdData'] = '0';
                      result['fdMessage'] =
                          'Terjadi timeout, mohon coba kembali';
                    } else if (responseCode['code'] == 900) {
                      result['fdData'] = '0';
                      result['fdMessage'] = responseCode['msg'];
                    } else {
                      result['fdData'] = '0';
                      result['fdMessage'] =
                          'Terjadi error kirim foto km start, mohon coba kembali';
                    }
                  } catch (e) {
                    result['fdData'] = '0';
                    result['fdMessage'] = e;
                  }

                  if (result['fdData'] == '401') {
                    await sessionExpired();
                    await csales.deleteSFActivity(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', startDayActivity);

                    addressLoc = '';
                    startDayDate = '';
                    statusSent = 0;
                    posGPS = null;

                    setState(() {});

                    return;
                  } else if (result['fdData'] != '0') {
                    await capi.sendLogDevicetoServer(
                        widget.user.fdKodeDepo,
                        widget.user.fdKodeSF,
                        widget.user.fdToken,
                        '',
                        fdStartDateTime);
                    await csales.updateStatusSentSFAct(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', startDayActivity);

                    await initData();
                  } else {
                    await csales.deleteSFActivity(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', startDayActivity);

                    addressLoc = '';
                    startDayDate = '';
                    statusSent = 0;
                    posGPS = null;

                    setState(() {});

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['fdMessage'])));

                    return;
                  }

                  FlutterBackgroundService().invoke("setAsBackground");
                  await initializeService();

                  setState(() {});
                } else {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text(
                            'Fake GPS terdeteksi, warning sudah diberikan ke admin')));
                }
              } else {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Mohon nyalakan GPS ulang dan tunggu beberapa detik')));
              }
            }
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Mohon matikan air plane mode')));
          }
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Mohon lakukan foto KM di kendaraan')));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> sendImagetoServer(String filePath) async {
    //Zip files
    Directory dir =
        Directory('${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}');
    List<File> files = [File(filePath)];
    String zipPath = '${dir.path}/${param.kmStartZipFileName}';
    String errorMsg = await cdb.createZipFile(dir.path, files, zipPath);

    if (errorMsg.isEmpty) {
      File fImg = File(zipPath);
      String fileName = cpath.basename(zipPath);
      int responseCode = await capi.uploadFile(
          fImg, fileName, widget.user, '', widget.startDayDate);

      return <String, dynamic>{'code': responseCode, 'msg': ''};
    } else {
      return <String, dynamic>{
        'code': 900,
        'msg': 'Error compress file: $errorMsg'
      };
    }
  }

  Widget getKMImage() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewPictureScreen(
                      imgBytes: File(kmImgPath).readAsBytesSync())));
        },
        child: FadeInImage(
            placeholder: const AssetImage('assets/images/transparent.png'),
            placeholderFit: BoxFit.scaleDown,
            image: MemoryImage(File(kmImgPath).readAsBytesSync()),
            fit: BoxFit.fitHeight,
            width: 100 * ScaleSize.textScaleFactor(context),
            height: 100 * ScaleSize.textScaleFactor(context)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Start Day'),
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(user: widget.user)),
                    (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
          ),
          bottomNavigationBar: isLoading
              ? const Padding(padding: EdgeInsets.zero)
              : startDayDate.isNotEmpty
                  ? null
                  : Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: BottomAppBar(
                        height: 40 * ScaleSize.textScaleFactor(context),
                        child: TextButton(
                          onPressed: (startDayDate.isNotEmpty
                              ? null
                              : () {
                                  // sugeng remark formInput
                                  if (formInputKey.currentState!.validate()) {
                                    confirmStartDay();
                                  }
                                }),
                          child: const Text('Confirm'),
                        ),
                      )),
          body: isLoading
              ? Center(
                  child: loadingProgress(ScaleSize.textScaleFactor(context)))
              : SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child:
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.5,
                      //   child: startDayDate.isNotEmpty
                      //       ? Padding(
                      //           padding: const EdgeInsets.all(10),
                      //           child: Text(
                      //               '${param.dateTimeFormatViewMMM.format(param.dateTimeFormatView.parse(startDayDate))}\n\n$txtAfterConfirm\n\n$addressLoc'))
                      //       : GoogleMap(
                      //           myLocationEnabled: true,
                      //           myLocationButtonEnabled: true,
                      //           mapType: MapType.normal,
                      //           markers: Set<Marker>.of(markers.values),
                      //           initialCameraPosition: _userLocation,
                      //           onMapCreated: gMapInitializes),
                      // ),
                      Form(
                    key: formInputKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                        children: [
                          Text(
                              'Lakukan foto KM odometer di kendaraan sebelum berangkat',
                              style: css.textExpandBold()),
                          const Padding(padding: EdgeInsets.all(5)),
                          TextFormField(
                            controller: txtKMControl,
                            decoration: css.textInputStyle(
                                null, null, 'KM Odometer', null, null),
                            maxLength: 11,
                            inputFormatters: [
                              cother.ThousandsSeparatorInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            enabled: startDayDate.isEmpty ? true : false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == 0) {
                                return 'Please fill KM';
                              }

                              return null;
                            },
                          ),
                          (startDayDate.isNotEmpty
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline,
                                            color: Colors.green),
                                        Text(startDayDate, softWrap: true)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(txtAfterConfirm),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(addressLoc),
                                      ],
                                    ),
                                  ],
                                )
                              : const Padding(padding: EdgeInsets.all(5))),
                          const Padding(padding: EdgeInsets.all(5)),
                          (startDayDate.isEmpty
                              ? IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    ccam
                                        .pickCamera(
                                            context,
                                            widget.user.fdToken,
                                            'Take Odometer',
                                            kmImgPath,
                                            widget.routeName,
                                            true)
                                        .then((value) {
                                      initLoadPage();

                                      setState(() {});
                                    });
                                  },
                                  icon: Icon(Icons.photo_camera_rounded,
                                      size: 36 *
                                          ScaleSize.textScaleFactor(context),
                                      color: Colors.orange,
                                      semanticLabel: 'Foto KM'),
                                  tooltip: 'Take photo',
                                )
                              : Icon(Icons.no_photography,
                                  size: 36 * ScaleSize.textScaleFactor(context),
                                  color: Colors.orange)),
                          const Padding(padding: EdgeInsets.all(5)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: isImgExist
                                  ? getKMImage()
                                  : Text('Lakukan foto KM di kendaraan',
                                      style: css.textExpandBold())),
                          const Padding(padding: EdgeInsets.all(15)),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
