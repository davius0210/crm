import 'dart:async';
import 'dart:io';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_ce/device_info_ce.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pdf_lash_page.dart';
import 'home_page.dart';
import 'main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';
import 'previewphoto_page.dart';
import 'package:path/path.dart' as cpath;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/salesman_cont.dart' as csales;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/rute_cont.dart' as crute;
import 'controller/log_cont.dart' as clog;
import 'controller/api_cont.dart' as capi;
import 'controller/database_cont.dart' as cdb;
import 'controller/camera.dart' as ccam;
import 'models/order.dart' as modr;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'models/logdevice.dart' as mlog;
import 'models/rencanarute.dart' as mrrute;
import 'style/css.dart' as css;

class EndDayPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;

  const EndDayPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.startDayDate});

  @override
  State<EndDayPage> createState() => LayerEndDay();
}

class LayerEndDay extends State<EndDayPage> {
  final String endDayActivity = '05';
  bool isLoading = false;
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  TextEditingController txtKMControl = TextEditingController();
  // int txtKMControl = 0;
  bool isImgExist = false;
  bool bGPSstat = false;
  bool isBackup = false;
  bool isRuteBiasa = false;
  bool isLastDayRute = false;
  String kmImgPath = '';
  String endDayDate = '';
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
  Map<MarkerId, Marker> markers = {};
  CameraPosition _userLocation = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  bool isMapReady = false;
  List<mlog.Param> listParam = [];
  List<String> _arrBackup = [];
  List<String> _arrTemp = [];
  List<String> _arrDelete = [];
  int maxBackup = 3;
  String zipNameBackup = '';
  final service = FlutterBackgroundService();

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

      getImageFromDevice();
      await initData();
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

  void getImageFromDevice() {
    setState(() {
      kmImgPath =
          '${param.appDir}/${param.imgPath}/${param.kmEndFullImgName(widget.user.fdKodeSF, widget.startDayDate)}';
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
        endDayDate = '';
        statusSent = 0;
      });
      isRuteBiasa = await crute.checkIsRuteBiasa(widget.startDayDate);
      msf.SalesActivity? sf = await csales.getStart_EndDayInfo(
          widget.user.fdKodeSF, widget.user.fdKodeDepo, endDayActivity);

      if (sf != null) {
        setState(() {
          //sugeng remark tidak input KM
          txtKMControl.text = param.idNumberFormat.format(sf.fdKM);
          endDayDate =
              param.dateTimeFormatView.format(DateTime.parse(sf.fdEndDate));
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
        // double distanceInMeters = Geolocator.distanceBetween(position.latitude,
        //     position.longitude, position.latitude, position.longitude);
        // if (distanceInMeters > listParam[0].fdMaxDistance) {
        //   if (!mounted) return;

        //   alertDialogForm(
        //       'Titik visit anda tidak sesuai dengan titik GPS outlet', context);
        // }
        //sugeng end remark
      }
      _userLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 18);

      //sugeng remark hanya tampil satu titik saja
      // MarkerId markerId = const MarkerId('outlet1');
      // Marker markerOutlet1 = Marker(
      //     markerId: markerId,
      //     icon: BitmapDescriptor.defaultMarker,
      //     position: LatLng(position.latitude, position.longitude));
      // markers[markerId] = markerOutlet1;

      // LatLngBounds mapBounds = getMapBounds(position, markerOutlet1);
      // controller.animateCamera(
      //   CameraUpdate.newLatLngBounds(mapBounds, 20),
      // );
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
                'error load Map: $e. Mohon mengaktifkan GPS dan mengulang end day dari halaman home')));
    }
  }

  Future<void> yesNoDialogFinish(int index) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColorGreen(),
              padding: const EdgeInsets.all(5),
              child: const Text(
                'Finish Rute Inap',
              )),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                      'Apakah Anda ingin menyelesaikan periode rute inap?')),
            ),
            isLoading
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                // UPDATE STATUS RUTE INAP JADI STOP
                                // await crute.updateStatusRuteInapToStop(
                                //     widget.user.fdKodeSF, widget.startDayDate);
                                String fdNoRencanaRute =
                                    await crute.getNoRencanaRuteByStartDayDate(
                                        widget.startDayDate);
                                List<mrrute.RencanaRuteApi> listRencanaRuteApi =
                                    await crute
                                        .getDataRencanaRuteApi(fdNoRencanaRute);
                                if (listRencanaRuteApi.isNotEmpty) {
                                  mrrute.RencanaRuteApi result =
                                      await capi.sendRencanaRutetoServer(
                                          widget.user,
                                          '3',
                                          widget.startDayDate,
                                          listRencanaRuteApi);
                                  if (result.fdData != '0' &&
                                      result.fdData != '401' &&
                                      result.fdData != '500' &&
                                      result.fdMessage == '') {
                                    await crute.updateStatusStopRencanaRute(
                                        fdNoRencanaRute);
                                    if (widget.user.fdTipeSF == '1') {
                                      await confirmEndDay();
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PreviewLashPage(
                                                  user: widget.user,
                                                  routeName: 'PreviewLashPage',
                                                  startDayDate:
                                                      widget.startDayDate,
                                                )),
                                      );
                                    }
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Gagal update stop rencana rute")));
                                    return;
                                  }
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Data rencana rute tidak ada")));
                                  return;
                                }
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('error: $e')));
                              }
                            },
                            child: const Text('Ya')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Tidak')),
                        const Padding(padding: EdgeInsets.all(5)),
                      ]),
          ],
        );
      }),
    );
  }

  Future<void> deleteZip() async {
    _arrBackup = [];
    _arrTemp = [];
    _arrDelete = [];
    listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
    if (listParam.isNotEmpty) {
      maxBackup = listParam[0].fdMaxBackup;
      String filePath = '${param.appDir}/BACKUP';

      if (Directory(filePath).existsSync()) {
        var listZip = Directory(filePath).listSync().where((element) {
          if (cpath.extension(element.path) == '.zip') {
            return true;
          } else {
            return false;
          }
        });
        for (var element in listZip) {
          var pathfile = element.path.toString();
          var nmfile = cpath.basenameWithoutExtension(pathfile);
          var results = listZip.where((fileZip) {
            zipNameBackup = cpath.basenameWithoutExtension(fileZip.path);

            if (zipNameBackup == nmfile) {
              return true;
            } else {
              return false;
            }
          });

          if (results.isNotEmpty && zipNameBackup.isNotEmpty) {
            _arrTemp.add(zipNameBackup);
          }
        }
        _arrTemp.sort();
        _arrBackup.addAll(_arrTemp.reversed);

        for (var i = 0; i < _arrBackup.length; i++) {
          if (i >= maxBackup) {
            _arrDelete.add(_arrBackup[i]);
          }
        }

        for (var j = 0; j < _arrDelete.length; j++) {
          String filePath = '${param.appDir}/BACKUP/${_arrDelete[j]}.zip';
          if (File(filePath).existsSync()) {
            await File(filePath).delete();
          }
        }
      }
    }
  }

  Future<void> confirmEndDay() async {
    try {
      setState(() {
        isLoading = true;
      });

      // sugeng remark tidak kirim image
      if (isImgExist) {
        final statusAirPlaneMode =
            await AirplaneModeChecker.instance.checkAirplaneMode();

        if (statusAirPlaneMode == AirplaneModeStatus.off) {
          bool isDateTimeSettingValid =
              await cother.dateTimeSettingValidation();

          if (isDateTimeSettingValid) {
            //sugeng add send data order NOO
            // tidak di dalam capi.sendDataPendingToServer agar tidak terkirim saat end visit
            // mencegah perubahan order di NOO sebelum end day
            Map<String, dynamic> mapResultNoo = {'fdData': '', 'fdMessage': ''};
            List<modr.Order> listOrderNOO = await codr.getDataOrderNOO();
            if (listOrderNOO.isNotEmpty) {
              for (var element in listOrderNOO) {
                mapResultNoo.addAll(await capi.sendOrderToServer(
                    element.fdKodeLangganan!,
                    widget.user,
                    widget.startDayDate,
                    1));

                if (mapResultNoo['fdData'] != '0' &&
                    mapResultNoo['fdData'] != '401' &&
                    mapResultNoo['fdData'] != '500') {
                  await codr.updateStatusSentOrder(
                      element.fdKodeLangganan!, widget.startDayDate);
                } else {
                  if (mapResultNoo['fdData'] == '401') {
                    await sessionExpired();

                    return; //stop process
                  } else if (mapResultNoo['fdMessage'].isNotEmpty) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(mapResultNoo['fdMessage'])));

                    return; //stop process
                  }
                }
              }
            }
            //sugeng end add send data order NOO

            //Send all data to Server
            String dirCameraPath =
                '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
            Map<String, dynamic> mapResult = await capi.sendDataPendingToServer(
                widget.user, dirCameraPath, widget.startDayDate);

            if (mapResult['fdData'] == '401') {
              await sessionExpired();

              return; //stop process
            } else if (mapResult['fdMessage'].isNotEmpty) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(mapResult['fdMessage'])));

              return; //stop process
            }

            //sugeng send pending LK to server
            Map<String, dynamic> mapResultLK =
                await capi.sendDataPendingLimitKreditToServer(
                    widget.user, dirCameraPath, widget.startDayDate);

            if (mapResultLK['fdData'] == '401') {
              await sessionExpired();

              return; //stop process
            } else if (mapResultLK['fdMessage'].isNotEmpty) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(mapResultLK['fdMessage'])));
            }
            //end sugeng add send pending LK

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
                  String fdEndDateTime =
                      param.dateTimeFormatDB.format(DateTime.now());
                  Placemark? place;

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

                  // String kmFileName = '';
                  //sugeng remark ga pake foto
                  String kmFileName = param.pathImgServer(
                      widget.user.fdKodeDepo,
                      widget.user.fdKodeSF,
                      fdDate,
                      param.kmEndFileName(widget.user.fdKodeSF, fdDate));

                  await csales.insertSFActivity(
                      widget.user.fdKodeSF,
                      widget.user.fdKodeDepo,
                      int.parse(txtKMControl.text
                          .replaceAll('.', '')
                          .replaceAll(',', '')),
                      kmFileName,
                      '',
                      fdEndDateTime,
                      posGPS!.latitude,
                      posGPS!.longitude,
                      endDayActivity,
                      '',
                      0,
                      0,
                      fdDate,
                      0,
                      (await DeviceInfoCe.batteryInfo())!
                                                      .level
                          .toString(),
                      place!.street,
                      place!.subLocality,
                      place!.subAdministrativeArea,
                      place!.postalCode);
                  //sugeng end remark

                  // await csales.insertSFActivity(
                  //     widget.user.fdKodeSF,
                  //     widget.user.fdKodeDepo,
                  //     txtKMControl,
                  //     kmFileName,
                  //     '',
                  //     fdEndDateTime,
                  //     posGPS!.latitude,
                  //     posGPS!.longitude,
                  //     endDayActivity,
                  //     '',
                  //     0,
                  //     0,
                  //     fdDate,
                  //     0,
                  //     (await BatteryInfoPlugin().androidBatteryInfo)!
                  //         .batteryLevel
                  //         .toString(),
                  //     place!.street,
                  //     place!.subLocality,
                  //     place!.subAdministrativeArea,
                  //     place!.postalCode);

                  endDayDate = param.dateTimeFormatView
                      .format(DateTime.parse(fdEndDateTime));

                  Map<String, dynamic> result = {};

                  try {
                    //sugeng remark tidak kirim foto
                    Map<String, dynamic> responseCode =
                        await sendImagetoServer(kmImgPath);

                    if (responseCode['code'] == 1) {
                      Map<String, dynamic> mapResult =
                          await cdb.createZipMDAllZipFiles(
                              widget.user.fdKodeSF, dirCameraPath);

                      if (mapResult['fdData'] != 1) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                              SnackBar(content: Text(mapResult['fdMessage'])));

                        return;
                      }

                      //sugeng remark tidak input KM
                      result = await capi.sendSalesActtoServer(
                          widget.user,
                          '',
                          fdEndDateTime,
                          '',
                          endDayActivity,
                          int.parse(txtKMControl.text
                              .replaceAll('.', '')
                              .replaceAll(',', '')),
                          kmFileName,
                          posGPS!.latitude,
                          posGPS!.longitude,
                         (await DeviceInfoCe.batteryInfo())!
                                                      .level
                              .toString(),
                          place!.street,
                          place!.subLocality,
                          place!.subAdministrativeArea,
                          place!.postalCode,
                          fdEndDateTime,
                          fdDate);
                      //sugeng end remark

                      // result = await capi.sendSalesActtoServer(
                      //     widget.user,
                      //     '',
                      //     fdEndDateTime,
                      //     '',
                      //     endDayActivity,
                      //     txtKMControl,
                      //     kmFileName,
                      //     posGPS!.latitude,
                      //     posGPS!.longitude,
                      //     (await BatteryInfoPlugin().androidBatteryInfo)!
                      //         .batteryLevel
                      //         .toString(),
                      //     place!.street,
                      //     place!.subLocality,
                      //     place!.subAdministrativeArea,
                      //     place!.postalCode,
                      //     fdEndDateTime,
                      //     fdDate);
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
                          'Terjadi error kirim foto km end, mohon coba kembali';
                    }
                    //sugeng end remark tidak kirim foto
                  } catch (e) {
                    result['fdData'] = '0';
                    result['fdMessage'] = e;
                  }

                  if (result['fdData'] == '401') {
                    await csales.deleteSFActivity(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', endDayActivity);
                    await sessionExpired();

                    return; //stop process
                  } else if (result['fdMessage'] == '500') {
                    await csales.deleteSFActivity(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', endDayActivity);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Error timeout')));
                    return;
                  } else if (result['fdData'] != '0' ||
                      result['fdMessage'] ==
                          'Tidak ada Data yg masuk ke Server') {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final String? fdTanggal = prefs.getString('startDayDate');

                    if (fdTanggal == null) {
                      await clog.insertGpsLog(
                          posGPS!.latitude.toString(),
                          posGPS!.longitude.toString(),
                         (await DeviceInfoCe.batteryInfo())!
                                                      .level
                              .toString(),
                          place!.street,
                          place!.subLocality,
                          place!.subAdministrativeArea,
                          place!.postalCode,
                          'End Day',
                          '',
                          '',
                          '',
                          fdEndDateTime);
                    } else {
                      await clog.insertGpsLog(
                          posGPS!.latitude.toString(),
                          posGPS!.longitude.toString(),
                         (await DeviceInfoCe.batteryInfo())!
                                                      .level
                              .toString(),
                          place!.street,
                          place!.subLocality,
                          place!.subAdministrativeArea,
                          place!.postalCode,
                          'End Day',
                          '',
                          '',
                          fdTanggal,
                          fdEndDateTime);
                    }
                    //Sudah pernah terinput
                    await capi.sendLogDevicetoServer(
                        widget.user.fdKodeDepo,
                        widget.user.fdKodeSF,
                        widget.user.fdToken,
                        '',
                        fdEndDateTime);

                    await capi.sendLogTransaction(
                        widget.user, widget.startDayDate);

                    await prefs.setString(
                        'fdJamEndDay',
                        param.timeFormatView.format(
                            param.dateTimeFormatDB.parse(fdEndDateTime)));
                    //sugeng remark tidak input KM
                    await prefs.setString(
                        'fdKmEndDay',
                        txtKMControl.text
                            .replaceAll('.', '')
                            .replaceAll(',', ''));
                    // sugeng end remark

                    // await prefs.setString('fdKmEndDay', txtKMControl.toString());

                    await csales.updateStatusSentSFAct(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', endDayActivity);

                    await initData();
                  } else {
                    await csales.deleteSFActivity(widget.user.fdKodeSF,
                        widget.user.fdKodeDepo, '', endDayActivity);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(result['fdMessage'])));

                    return; //stop process
                  }

                  service.invoke('stopService');

                  //Stop service lagi jika ternyata masih berjalan
                  if (await service.isRunning()) {
                    service.invoke('stopService');
                  }

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

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text(
                          'Mohon nyalakan GPS ulang dan tunggu beberapa detik')));
              }
            }
          }
        } else {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Mohon matikan air plane mode')));
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Mohon lakukan foto KM di kendaraan')));
      } //sugeng end remark tidak kirim image

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      await csales.deleteSFActivity(
          widget.user.fdKodeSF, widget.user.fdKodeDepo, '', endDayActivity);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> createBackup(String fdTanggal) async {
    String filePath = '${param.appDir}/BACKUP';
    String srcZipPath =
        '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
    String yyyyMMdd = fdTanggal.replaceAll('-', '');
    Directory dirBackup = Directory(filePath);
    dirBackup.create().then((Directory newDirectory) {
      print('Directory backup created: ${newDirectory.path}');
    }).catchError((e) => print('Error creating backup directory: $e'));

    Map<String, dynamic> mapResult =
        await cdb.backupZipMDAllZipFiles(yyyyMMdd, srcZipPath);

    return mapResult['fdData'] == 1 ? true : false;
  }

  Future<Map<String, dynamic>> sendImagetoServer(String filePath) async {
    //Zip files
    Directory dir =
        Directory('${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}');
    List<File> files = [File(filePath)];
    String zipPath = '${dir.path}/${param.kmEndZipFileName}';
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
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('End Day'),
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
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : endDayDate.isNotEmpty
                    ? null
                    : Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: BottomAppBar(
                          height: 40 * ScaleSize.textScaleFactor(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: (statusSent == 1
                                      ? null
                                      : () async {
                                          int countLanggananExist =
                                              await clgn.countLanggananExist(
                                                  widget.user.fdKodeSF,
                                                  widget.user.fdKodeDepo);
                                          isBackup = await createBackup(
                                              widget.startDayDate);
                                          if (countLanggananExist > 0) {
                                            isBackup = await createBackup(
                                                widget.startDayDate);
                                            print(isBackup);
                                            if (isBackup) {
                                              // sugeng remark formInput
                                              if (formInputKey.currentState!
                                                  .validate()) {
                                                if (widget.user.fdTipeSF !=
                                                    '1') {
                                                  //TO = 0
                                                  await confirmEndDay();

                                                  //send notification order
                                                  // capi.sendNotifOrder(
                                                  //     widget.user.fdToken,
                                                  //     widget.user.fdKodeSF,
                                                  //     widget.user.fdKodeDepo);
                                                  //end send notification order
                                                } else {
                                                  //CANVAS=1
                                                  await confirmEndDay();

                                                  String fdNoRencanaRute =
                                                      await crute
                                                          .getNoRencanaRuteByStartDayDate(
                                                              widget
                                                                  .startDayDate);
                                                  //cek jika rute hari terakhir maka update jadwal stop
                                                  isLastDayRute = await crute
                                                      .cekIsLastDayRencanaRute(
                                                          fdNoRencanaRute);
                                                  if (isLastDayRute) {
                                                    List<mrrute.RencanaRuteApi>
                                                        listRencanaRuteApi =
                                                        await crute
                                                            .getDataRencanaRuteApi(
                                                                fdNoRencanaRute);
                                                    if (listRencanaRuteApi
                                                        .isNotEmpty) {
                                                      mrrute.RencanaRuteApi
                                                          result =
                                                          await capi.sendRencanaRutetoServer(
                                                              widget.user,
                                                              '3',
                                                              widget
                                                                  .startDayDate,
                                                              listRencanaRuteApi);
                                                      if (result.fdData !=
                                                              '0' &&
                                                          result.fdData !=
                                                              '401' &&
                                                          result.fdData !=
                                                              '500' &&
                                                          result.fdMessage ==
                                                              '') {
                                                        await crute
                                                            .updateStatusStopRencanaRute(
                                                                fdNoRencanaRute);
                                                      }
                                                    }
                                                  }
                                                }
                                                //TO dan CANVAS kirim LASH
                                                if (!mounted) return;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PreviewLashPage(
                                                            user: widget.user,
                                                            routeName:
                                                                'PreviewLashPage',
                                                            startDayDate: widget
                                                                .startDayDate,
                                                          )),
                                                );
                                              }
                                            }
                                          } else {
                                            //jika tidak ada langganan bisa langsung end day
                                            await confirmEndDay();
                                          }
                                        }),
                                  child: Text(widget.user.fdTipeSF == '1'
                                      ? 'End Day'
                                      : 'Confirm'),
                                ),
                              ),
                              isRuteBiasa
                                  ? const Padding(padding: EdgeInsets.zero)
                                  : const VerticalDivider(
                                      width: 1,
                                      thickness: 1.5,
                                      color: Colors.grey,
                                    ),
                              isRuteBiasa
                                  ? const Padding(padding: EdgeInsets.zero)
                                  : Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          // CEK JIKA ADA JADWAL RENCANA RUTE BELUM TERAKHIR, MAKA END DAY TIDAK DELETE MASTER

                                          await yesNoDialogFinish(1);
                                        },
                                        child: const Text('Finish'),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
            body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                    key: formInputKey,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          children: [
                            Text(
                                'Lakukan foto KM odometer di kendaraan sebelum akhir hari',
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
                              enabled: statusSent == 0 ? true : false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == 0) {
                                  return 'Please fill KM';
                                }

                                return null;
                              },
                            ),
                            (statusSent == 1
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          Text(endDayDate, softWrap: true)
                                        ],
                                      ),
                                      Text(addressLoc, softWrap: true)
                                    ],
                                  )
                                : const Padding(padding: EdgeInsets.all(5))),
                            const Padding(padding: EdgeInsets.all(5)),
                            isLoading
                                ? const Padding(padding: EdgeInsets.zero)
                                : (statusSent == 0
                                    ? IconButton(
                                        onPressed: () {
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
                                        icon: isLoading
                                            ? const Padding(
                                                padding: EdgeInsets.zero)
                                            : Icon(Icons.photo_camera_rounded,
                                                size: 36 *
                                                    ScaleSize.textScaleFactor(
                                                        context),
                                                color: Colors.orange,
                                                semanticLabel: 'Foto KM'),
                                        tooltip: 'Take photo',
                                      )
                                    : Icon(Icons.no_photography,
                                        size: 36 *
                                            ScaleSize.textScaleFactor(context),
                                        color: Colors.orange)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                        ))))));
    // body: isLoading
    //     ? Center(
    //         child: loadingProgress(ScaleSize.textScaleFactor(context)))
    //     : SingleChildScrollView(
    //         keyboardDismissBehavior:
    //             ScrollViewKeyboardDismissBehavior.onDrag,
    //         child: SizedBox(
    //           height: MediaQuery.of(context).size.height * 0.5,
    //           child: endDayDate.isNotEmpty
    //               ? Padding(
    //                   padding: const EdgeInsets.all(10),
    //                   child: Text(
    //                       '${param.dateTimeFormatViewMMM.format(param.dateTimeFormatView.parse(endDayDate))}\n\n$txtAfterConfirm\n\n$addressLoc'))
    //               : GoogleMap(
    //                   myLocationEnabled: true,
    //                   myLocationButtonEnabled: true,
    //                   mapType: MapType.normal,
    //                   markers: Set<Marker>.of(markers.values),
    //                   initialCameraPosition: _userLocation,
    //                   onMapCreated: gMapInitializes),
    //         ),
    //       )));
  }
}
