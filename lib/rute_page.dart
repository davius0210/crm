import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:device_info_ce/device_info_ce.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'controller/api_cont.dart' as capi;
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_page.dart';
import 'cust_page.dart';
import 'custedit_page.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/camera.dart' as ccam;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/database.dart' as mdbconfig;
import 'models/langganan.dart' as mlgn;
import 'models/logdevice.dart' as mlog;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;

List<mlgn.Langganan> _listRute = [];
late Placemark placeGPS;
String? street = '';
String? subLocality = '';
String? subAdministrativeArea = '';
String? postalCode = '';

class RutePage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const RutePage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<RutePage> createState() => LayerRute();
}

class LayerRute extends State<RutePage> {
  List<mlgn.Langganan> _listRutePending = [];
  TextEditingController txtReasonLain = TextEditingController();
  bool isLoading = false;
  bool isLoadButton = false;
  List<mlgn.Reason> listReason = [];
  bool isFreeText = false;
  bool isReasonEmpty = false;
  String startVisitActivity = '03';
  bool bGPSstat = false;
  String imgReasonNotVisitPath = '';
  Position? posGPS =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);

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

    posGPS = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    bGPSstat = serviceEnabled;

    return true;
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> initLoadPage() async {
    late Database db;

    try {
      setState(() {
        isLoading = true;
      });
      await handlePermission();
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);
      await db.transaction((txn) async {
        listReason = await clgn.getListReasonInfo('1', txn);
        _listRute = await clgn.getAllLanggananInfo(
            txn, widget.user.fdKodeSF, widget.user.fdKodeDepo);
      });

      if (_listRute.isNotEmpty &&
          (_listRute[0].code != null && _listRute[0].code! > 0)) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${_listRute[0].message}')));
      } else if (_listRute.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Data rute kosong. Coba cek data rute / sync ulang')));
      } else {
        _listRutePending = _listRute
            .where((element) =>
                element.fdEndVisitDate!.isEmpty &&
                element.fdStartVisitDate!.isNotEmpty &&
                element.fdIsPaused == 0)
            .toList();
      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isLoadButton = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }

  Future<bool> checkGPS() async {
    bGPSstat = await handlePermission();

    if (bGPSstat) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation,
              timeLimit: Duration(seconds: param.gpsTimeOut))
          .then((value) => posGPS = value)
          .onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('error gps timeout')));

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
        return true;
      } else {
        if (!mounted) return false;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content:
                  Text('Mohon nyalakan GPS ulang dan tunggu beberapa detik')));

        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> sfaInsertSalesActivity(String fdKodeLangganan) async {
    try {
      await csales.insertSFActivity(
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          0,
          '',
          param.dateTimeFormatDB.format(DateTime.now()),
          '',
          0,
          0,
          startVisitActivity, //03
          fdKodeLangganan,
          0,
          1,
          widget.startDayDate,
          0,
          '100',
          '',
          '',
          '',
          '');
      return true;
    } catch (err) {
      throw Exception(err);
    }
    // bGPSstat = await handlePermission();
    // if (bGPSstat) {
    //   await Geolocator.getCurrentPosition(
    //           desiredAccuracy: LocationAccuracy.bestForNavigation,
    //           timeLimit: Duration(seconds: param.gpsTimeOut))
    //       .then((value) => posGPS = value)
    //       .onError((error, stackTrace) {
    //     ScaffoldMessenger.of(context)
    //       ..removeCurrentSnackBar()
    //       ..showSnackBar(const SnackBar(content: Text('error gps timeout')));

    //     posGPS = const Position(
    //         longitude: 0,
    //         latitude: 0,
    //         timestamp: null,
    //         accuracy: 0,
    //         altitude: 0,
    //         heading: 0,
    //         speed: 0,
    //         speedAccuracy: 0);

    //     return posGPS!;
    //   });

    //   if (posGPS!.latitude != 0 && posGPS!.longitude != 0) {
    //     //insert sales activity
    //     String outletFileName = '';

    //     try {
    //       await placemarkFromCoordinates(posGPS!.latitude, posGPS!.longitude)
    //           .then((value) {
    //             placeGPS = value.first;

    //             street = placeGPS.street;
    //             subLocality = placeGPS.subLocality;
    //             subAdministrativeArea = placeGPS.subAdministrativeArea;
    //             postalCode = placeGPS.postalCode;
    //           })
    //           .timeout(Duration(seconds: param.gpsTimeOut))
    //           .onError((error, stackTrace) {
    //             placeGPS = Placemark(
    //                 street: '',
    //                 subLocality: '',
    //                 subAdministrativeArea: '',
    //                 postalCode: '');
    //           });
    //     } on TimeoutException catch (e) {
    //       placeGPS = Placemark(
    //           street: '',
    //           subLocality: '',
    //           subAdministrativeArea: '',
    //           postalCode: '');
    //     } on Exception catch (e) {
    //       placeGPS = Placemark(
    //           street: '',
    //           subLocality: '',
    //           subAdministrativeArea: '',
    //           postalCode: '');
    //     }

    //     await csales.insertSFActivity(
    //         widget.user.fdKodeSF,
    //         widget.user.fdKodeDepo,
    //         0,
    //         outletFileName,
    //         param.dateTimeFormatDB.format(DateTime.now()),
    //         '',
    //         posGPS!.latitude,
    //         posGPS!.longitude,
    //         startVisitActivity,
    //         fdKodeLangganan,
    //         0,
    //         1,
    //         widget.startDayDate,
    //         0,
    //         (await BatteryInfoPlugin().androidBatteryInfo)!
    //             .batteryLevel
    //             .toString(),
    //         placeGPS.street,
    //         placeGPS.subLocality,
    //         placeGPS.subAdministrativeArea,
    //         placeGPS.postalCode);
    //     return true;
    //   } else {
    //     if (!mounted) return false;

    //     ScaffoldMessenger.of(context)
    //       ..removeCurrentSnackBar()
    //       ..showSnackBar(const SnackBar(
    //           content:
    //               Text('Mohon nyalakan GPS ulang dan tunggu beberapa detik')));

    //     return false;
    //   }
    // } else {
    //   return false;
    // }
  }

  Future<String> saveNotVisit(
      Function(Function()) setState,
      String? fdKodeLangganan,
      String? fdKodeReason,
      String? fdReason,
      int fdRute) async {
    try {
      setState(() {
        isLoading = true;
      });

      final statusAirPlaneMode = await AirplaneModeChecker.instance.checkAirplaneMode();

      if (statusAirPlaneMode == AirplaneModeStatus.off) {
        bool isGPSValid = await checkGPS();

        if (isGPSValid) {
          if (!posGPS!.isMocked) {
            bool isDateTimeSettingValid =
                await cother.dateTimeSettingValidation();

            if (isDateTimeSettingValid) {
              if (isFreeText && txtReasonLain.text.isEmpty) {
                setState(() {
                  isReasonEmpty = true;
                });
              } else {
                setState(() {
                  isReasonEmpty = false;
                });
              }

              if (!isReasonEmpty) {
                //Zip Folder langganan
                String dirCameraPath =
                    '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
                Directory dir = Directory('$dirCameraPath/$fdKodeLangganan');
                String zipPath =
                    '$dirCameraPath/$fdKodeLangganan.zip'; //path di luar folder kode langganan
                String errorMsg =
                    await cdb.createZipDirectory(dir.path, zipPath);

                if (errorMsg.isEmpty) {
                  late Database db;

                  try {
                    db = await openDatabase(mdbconfig.dbFullPath,
                        version: mdbconfig.dbVersion);
                    await db.transaction((txn) async {
                      String reasonFileName = '';
                      if (File(imgReasonNotVisitPath).existsSync()) {
                        reasonFileName = param.pathImgServer(
                            widget.user.fdKodeDepo,
                            widget.user.fdKodeSF,
                            widget.startDayDate,
                            '$fdKodeLangganan/${param.reasonNotVisitFileName(fdKodeLangganan!, widget.startDayDate)}');
                      }
                      try {
                        await placemarkFromCoordinates(
                          posGPS!.latitude,
                          posGPS!.longitude,
                        )
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

                      await clgn.insertSFAct_LanggananTransNotVisit(
                          widget.user.fdKodeSF,
                          widget.user.fdKodeDepo,
                          fdKodeLangganan,
                          widget.startDayDate,
                          fdKodeReason,
                          fdReason,
                          reasonFileName,
                          'NotVisit',
                          '',
                          startVisitActivity,
                          param.dateTimeFormatDB.format(DateTime.now()),
                          param.dateTimeFormatDB.format(DateTime.now()),
                          posGPS!.latitude,
                          posGPS!.longitude,
                          fdRute,
                         (await DeviceInfoCe.batteryInfo())
                                                      .level
                              .toString(),
                          placeGPS.street,
                          placeGPS.subLocality,
                          placeGPS.subAdministrativeArea,
                          placeGPS.postalCode,
                          txn);

                      _listRute = await clgn.getAllLanggananInfo(
                          txn, widget.user.fdKodeSF, widget.user.fdKodeDepo);
                    });

                    //Send all data to Server
                    await capi.sendLogDevicetoServer(
                        widget.user.fdKodeDepo,
                        widget.user.fdKodeSF,
                        widget.user.fdToken,
                        '',
                        param.dateTimeFormatDB.format(DateTime.now()));
                    String dirCameraPath =
                        '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
                    Map<String, dynamic> mapResult =
                        await capi.sendDataPendingToServer(
                            widget.user, dirCameraPath, widget.startDayDate);

                    if (mapResult['fdData'] == '401') {
                      await sessionExpired();
                    } else if (mapResult['fdMessage'].isNotEmpty) {
                      return mapResult['fdMessage'];
                    }

                    setState(() {});
                  } catch (e) {
                    return e.toString();
                  } finally {
                    db.isOpen ? await db.close() : null;
                  }

                  setState(() {
                    isLoading = false;
                  });

                  return '';
                } else {
                  setState(() {
                    isLoading = false;
                  });

                  return 'Error compress file: $errorMsg';
                }
              } else {
                setState(() {
                  isLoading = false;
                  isLoadButton = false;
                });

                return 'Keterangan harus diisi';
              }
            } else {
              setState(() {
                isLoading = false;
              });

              return 'Tanggal harus disetting otomatis';
            }
          } else {
            setState(() {
              isLoading = false;
            });

            return 'Fake GPS terdeteksi, warning sudah diberikan ke admin';
          }
        } else {
          setState(() {
            isLoading = false;
          });

          return 'GPS harus aktif dan mendapat sinyal';
        }
      } else {
        return 'Mohon matikan air plane mode';
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      return 'Error: $e';
    }
  }

  void checkNotVisitReasonResult(bool isFinish, String errMsg) async {
    if (isFinish) {
      if (errMsg.isEmpty) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Outlet selesai diproses')));

        initLoadPage();
      } else {
        if (!isReasonEmpty) {
          alertDialogForm(errMsg, context);
          initLoadPage();
        }
      }
    }
  }

  void reasonDialogForm(
      String? fdNamaLangganan, String? fdKodeLangganan, int fdRute) {
    mlgn.Reason? selectedReason;

    setState(() {
      isFreeText = false;
      isReasonEmpty = false;
    });

    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setStateDialog) {
        return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              title: Container(
                  color: css.titleDialogColor(),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Reason Not Visit'),
                      ),
                      isLoading
                          ? loadingProgress(ScaleSize.textScaleFactor(context))
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: IconButton(
                                  color: Colors.white,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size:
                                        18 * ScaleSize.textScaleFactor(context),
                                  )))
                    ],
                  )),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                    'Pilih alasan tidak melakukan kunjungan di $fdNamaLangganan ?'),
                const Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: listReason.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: RadioListTile(
                              selected: selectedReason == listReason[index],
                              selectedTileColor: css.tileSelectedColor(),
                              activeColor: css.textCheckSelectedColor(),
                              title: Text(
                                  '${listReason[index].fdReasonDescription}',
                                  style: css.textSmallSize(),
                                  softWrap: true),
                              value: listReason[index],
                              groupValue: selectedReason,
                              onChanged: (value) {
                                setStateDialog(() {
                                  selectedReason = value;
                                  isFreeText = selectedReason!.fdFreeTeks == 1;
                                  txtReasonLain.clear();
                                  isReasonEmpty = false;
                                });
                              }),
                        );
                      },
                    )),
                (isFreeText
                    ? Container(
                        color: Colors.white,
                        child: TextFormField(
                          maxLength: 50,
                          controller: txtReasonLain,
                          decoration: css.textInputStyleWithError(
                              'Keterangan',
                              null,
                              null,
                              isReasonEmpty,
                              'Please fill Keterangan',
                              null),
                          inputFormatters: [
                            FilteringTextInputFormatter(
                                RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                allow: true)
                          ],
                        ))
                    : const Padding(padding: EdgeInsets.all(0))),
                isLoading
                    ? loadingProgress(ScaleSize.textScaleFactor(context))
                    : isLoadButton
                        ? loadingProgress(ScaleSize.textScaleFactor(context))
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                if (selectedReason != null) {
                                  bool isFinish = false;
                                  String errMsg = '';

                                  setStateDialog(() {
                                    imgReasonNotVisitPath = '';
                                    isLoadButton = true;
                                  });

                                  if (selectedReason!.fdCamera == 1) {
                                    if (isFreeText &&
                                        txtReasonLain.text.isEmpty) {
                                      setState(() {
                                        isReasonEmpty = true;
                                        isLoadButton = false;
                                      });
                                    } else {
                                      setStateDialog(() {
                                        imgReasonNotVisitPath =
                                            '${param.appDir}/${param.imgPath}/${param.reasonNotVisitFullImgName(widget.user.fdKodeSF, fdKodeLangganan!, widget.startDayDate)}';
                                      });
                                      await ccam.pickCamera(
                                          context,
                                          widget.user.fdToken,
                                          'Take Photo',
                                          imgReasonNotVisitPath,
                                          widget.routeName,
                                          true);

                                      if (File(imgReasonNotVisitPath)
                                          .existsSync()) {
                                        errMsg = await saveNotVisit(
                                            setState,
                                            fdKodeLangganan,
                                            selectedReason!.fdKodeReason,
                                            isFreeText
                                                ? txtReasonLain.text
                                                : selectedReason!
                                                    .fdReasonDescription,
                                            fdRute);

                                        isFinish = true;

                                        checkNotVisitReasonResult(
                                            isFinish, errMsg);
                                      } else {
                                        setStateDialog(() {
                                          isLoadButton = false;
                                        });
                                      }
                                    }
                                  } else {
                                    errMsg = await saveNotVisit(
                                        setStateDialog,
                                        fdKodeLangganan,
                                        selectedReason!.fdKodeReason,
                                        isFreeText
                                            ? txtReasonLain.text
                                            : selectedReason!
                                                .fdReasonDescription,
                                        fdRute);
                                    errMsg = await saveNotVisit(
                                        setStateDialog,
                                        fdKodeLangganan,
                                        '1',
                                        'BY PHONE',
                                        fdRute);

                                    isFinish = true;

                                    if (!mounted) return;

                                    if (!isReasonEmpty) {
                                      Navigator.pop(context);
                                    }

                                    checkNotVisitReasonResult(isFinish, errMsg);
                                  } // if (selectedReason!.fdCamera == 1)
                                } // if (selectedReason != null)
                              } catch (e) {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                      SnackBar(content: Text('error: $e')));
                              }
                            },
                            child: const Text('Submit')),
              ],
            ));
      }),
    );
  }

  void visitLanggananPauseDialogForm(
      String fdKodeLangganan, String fdKodeExternal) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: Text('Visit Outlet ter-Pause: $fdKodeExternal?')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerPage(
                              fdKodeLangganan: fdKodeLangganan,
                              user: widget.user,
                              routeName: widget.routeName,
                              isEndDay: widget.isEndDay,
                              startDayDate: widget.startDayDate)));
                },
                child: const Text('Ya')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tidak'))
          ],
        );
      }),
    );
  }

  void alertScaffold(String msg) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: !isLoading
            ? () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(user: widget.user)),
                    (Route<dynamic> route) => false);

                return false;
              }
            : () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Rute Langganan'),
              leading: !isLoading
                  ? IconButton(
                      onPressed: () {
                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(user: widget.user)),
                            (Route<dynamic> route) => false);
                      },
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
                    )
                  : const Padding(padding: EdgeInsets.zero),
              actions: [
                !isLoading
                    ? IconButton(
                        onPressed: () {
                          initLoadPage();
                        },
                        icon: Icon(Icons.refresh_outlined,
                            size: 24 * ScaleSize.textScaleFactor(context)),
                        tooltip: 'Refresh',
                      )
                    : const Padding(padding: EdgeInsets.zero)
              ],
            ),
            body: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                backgroundColor: Colors.yellow,
                color: Colors.red,
                strokeWidth: 2,
                onRefresh: () async {
                  initLoadPage();

                  return Future.delayed(const Duration(milliseconds: 500));
                },
                child: isLoading
                    ? Center(
                        child:
                            loadingProgress(ScaleSize.textScaleFactor(context)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: _listRute.length,
                        itemBuilder: (BuildContext context, int index) {
                          mlgn.Langganan outletPending = mlgn.Langganan.empty();

                          //Get outlet pending karena apps di kill atau device ter-restart
                          if (_listRutePending.isNotEmpty) {
                            outletPending = _listRutePending.firstWhere(
                                (element) =>
                                    element.fdKodeLangganan ==
                                    _listRute[index].fdKodeLangganan,
                                orElse: () => mlgn.Langganan.empty());
                          }

                          return Card(
                              margin: const EdgeInsets.only(bottom: 15),
                              elevation: 3,
                              shadowColor: Colors.blue,
                              shape: css.boxStyle(),
                              color: (_listRute[index].fdEndVisitDate!.isEmpty
                                  ? Colors.white
                                  : _listRute[index].fdStatusSent == 1
                                      ? Colors.green[100]
                                      : Colors.yellow),
                              child: InkWell(
                                onTap: () {
                                  // sfaInsertSalesActivity(
                                  //     _listRute[index].fdKodeLangganan!);

                                  // if (!mounted) return;
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         settings: const RouteSettings(
                                  //             name: 'CustEdit'),
                                  //         builder: (context) => CustEditPage(
                                  //             fdKodeLangganan: _listRute[index]
                                  //                 .fdKodeLangganan!,
                                  //             user: widget.user,
                                  //             routeName: 'CustEdit',
                                  //             startDayDate:
                                  //                 widget.startDayDate))).then(
                                  //     (value) {
                                  //   initLoadPage();
                                  //   setState(() {});
                                  // });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('${index + 1}. '),
                                            _listRute[index].isRute == 1 &&
                                                    _listRute[index]
                                                            .fdKodeStatus ==
                                                        1
                                                ? const Padding(
                                                    padding: EdgeInsets.zero)
                                                : Icon(Icons.alt_route,
                                                    color: Colors.red,
                                                    size: 24 *
                                                        ScaleSize
                                                            .textScaleFactor(
                                                                context)),
                                            Expanded(
                                                child: Text(
                                                    '${_listRute[index].fdKodeLangganan} - ${_listRute[index].fdNamaLangganan}',
                                                    style: css.textNormalBold(),
                                                    softWrap: true)),
                                            _listRute[index].fdIsPaused == 0
                                                ? const Padding(
                                                    padding: EdgeInsets.zero)
                                                : IconButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.zero,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    icon: Icon(
                                                        Icons.pause_circle,
                                                        size: 24 *
                                                            ScaleSize
                                                                .textScaleFactor(
                                                                    context)),
                                                    tooltip: _listRute[index]
                                                        .fdPauseReason),
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.all(5)),
                                        // Row(children: [
                                        //   Text('${index + 1}. ',
                                        //       style: const TextStyle(
                                        //           color: Colors
                                        //               .transparent)), //mengakali spy ada spasi dengan baris sebelum
                                        //   Expanded(
                                        //       child: Text(
                                        //           '${_listRute[index].fdGroupLangganan} - ${_listRute[index].fdNamaGroupLangganan}'))
                                        // ]),
                                        // Row(children: [
                                        //   Text('${index + 1}. ',
                                        //       style: const TextStyle(
                                        //           color: Colors
                                        //               .transparent)), //mengakali spy ada spasi dengan baris sebelum
                                        //   Expanded(
                                        //       child: Text(
                                        //           '${_listRute[index].fdKodeTipeLangganan} - ${_listRute[index].fdTipeLangganan}'))
                                        // ]),
                                        // Row(children: [
                                        //   Text('${index + 1}. ',
                                        //       style: const TextStyle(
                                        //           color: Colors
                                        //               .transparent)), //mengakali spy ada spasi dengan baris sebelum
                                        //   Expanded(
                                        //       child: Text(
                                        //           '${_listRute[index].fdAmountChiller} chiller'))
                                        // ]),
                                        Row(children: [
                                          Text('${index + 1}. ',
                                              style: const TextStyle(
                                                  color: Colors
                                                      .transparent)), //mengakali spy ada spasi dengan baris sebelum
                                          Expanded(
                                              child: Text(
                                                  '${_listRute[index].fdAlamat}'))
                                        ]),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                //sugeng remark 10.06.2025 karena apps LaLg=0 sudah tidak pakai diversi lanjut, simpan di confirm visit
                                                // await sfaInsertSalesActivity(
                                                //     _listRute[index]
                                                //         .fdKodeLangganan!);
                                                //sugeng end remark

                                                if (!mounted) return;
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         settings:
                                                //             const RouteSettings(
                                                //                 name:
                                                //                     'CustEdit'),
                                                //         builder: (context) => CustEditPage(
                                                //             fdKodeLangganan:
                                                //                 _listRute[index]
                                                //                     .fdKodeLangganan!,
                                                //             user: widget.user,
                                                //             routeName:
                                                //                 'CustEdit',
                                                //             startDayDate: widget
                                                //                 .startDayDate))).then(
                                                //     (value) {
                                                //   initLoadPage();
                                                //   setState(() {});
                                                // });

                                                //Validasi toko pending (toko yang exit tanpa pause)
                                                if (_listRutePending.isEmpty ||
                                                    (_listRutePending
                                                            .isNotEmpty &&
                                                        outletPending
                                                            .fdKodeLangganan!
                                                            .isNotEmpty)) {
                                                  if (_listRute[index]
                                                          .fdEndVisitDate!
                                                          .isEmpty &&
                                                      _listRute[index]
                                                          .fdStartVisitDate!
                                                          .isEmpty &&
                                                      _listRute[index]
                                                              .fdIsPaused! ==
                                                          0) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            settings:
                                                                const RouteSettings(
                                                                    name:
                                                                        'visit'),
                                                            builder: (context) => VisitPage(
                                                                la: _listRute[index]
                                                                    .fdLA,
                                                                lg: _listRute[index]
                                                                    .fdLG,
                                                                fdKodeLangganan:
                                                                    _listRute[index]
                                                                        .fdKodeLangganan!,
                                                                user:
                                                                    widget.user,
                                                                routeName: widget
                                                                    .routeName,
                                                                routeVisitName:
                                                                    'visit',
                                                                isEndDay: widget
                                                                    .isEndDay,
                                                                startDayDate: widget
                                                                    .startDayDate,
                                                                fdRute: _listRute[
                                                                        index]
                                                                    .isRute)));
                                                  } else if (_listRute[index]
                                                              .fdIsPaused! ==
                                                          1 &&
                                                      _listRute[index]
                                                          .fdEndVisitDate!
                                                          .isEmpty) {
                                                    visitLanggananPauseDialogForm(
                                                        _listRute[index]
                                                            .fdKodeLangganan!,
                                                        _listRute[index]
                                                            .fdKodeExternal!);
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CustomerPage(
                                                                fdKodeLangganan:
                                                                    _listRute[index]
                                                                        .fdKodeLangganan!,
                                                                user:
                                                                    widget.user,
                                                                routeName: widget
                                                                    .routeName,
                                                                isEndDay: widget
                                                                    .isEndDay,
                                                                startDayDate: widget
                                                                    .startDayDate)));
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                    ..removeCurrentSnackBar()
                                                    ..showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Ada langganan yang perlu diselesaikan')));
                                                }
                                              },
                                              icon: Icon(Icons.create_outlined,
                                                  size: 30 *
                                                      ScaleSize.textScaleFactor(
                                                          context)),
                                              color: Colors.blueAccent,
                                              tooltip: 'Next',
                                            ),
                                            (_listRute[index]
                                                        .fdEndVisitDate!
                                                        .isEmpty &&
                                                    _listRute[index]
                                                        .fdStartVisitDate!
                                                        .isEmpty
                                                ? Expanded(
                                                    child: Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerEnd,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            if (_listRutePending
                                                                    .isEmpty ||
                                                                (_listRutePending
                                                                        .isNotEmpty &&
                                                                    outletPending
                                                                        .fdKodeLangganan!
                                                                        .isNotEmpty)) {
                                                              if (_listRute[
                                                                      index]
                                                                  .fdStartVisitDate!
                                                                  .isEmpty) {
                                                                reasonDialogForm(
                                                                    _listRute[
                                                                            index]
                                                                        .fdNamaLangganan,
                                                                    _listRute[
                                                                            index]
                                                                        .fdKodeLangganan,
                                                                    _listRute[
                                                                            index]
                                                                        .isRute);
                                                              }
                                                            } else {
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                ..removeCurrentSnackBar()
                                                                ..showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Ada langganan yang perlu diselesaikan')));
                                                            }
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .local_phone_rounded,
                                                              size: 24 *
                                                                  ScaleSize
                                                                      .textScaleFactor(
                                                                          context)),
                                                          color: Colors.green,
                                                          tooltip: 'By Phone',
                                                        )))
                                                : _listRute[index].fdCategory ==
                                                        'NotVisit'
                                                    ? Flexible(
                                                        child: Text(
                                                        _listRute[index]
                                                                .fdCancelVisitReason ??
                                                            '',
                                                        maxLines: 2,
                                                      ))
                                                    : Flexible(
                                                        child: Text(
                                                            _listRute[index]
                                                                    .fdNotVisitReason ??
                                                                '',
                                                            maxLines: 2,
                                                            style: css
                                                                .textExpandBold())))
                                          ],
                                        )
                                      ],
                                    )),
                              ));
                        }))));
  }
}

class VisitPage extends StatefulWidget {
  final double la;
  final double lg;
  final String fdKodeLangganan;
  final msf.Salesman user;
  final String routeName;
  final String routeVisitName;
  final String startDayDate;
  final int fdRute;
  final bool isEndDay;

  const VisitPage(
      {super.key,
      required this.la,
      required this.lg,
      required this.fdKodeLangganan,
      required this.user,
      required this.routeName,
      required this.routeVisitName,
      required this.startDayDate,
      required this.isEndDay,
      required this.fdRute});

  @override
  State<VisitPage> createState() => LayerVisit();
}

class LayerVisit extends State<VisitPage> {
  bool isMapReady = false;
  bool isLoadPhoto = false;
  String startVisitActivity = '03';
  String outletAbsenImgPath = '';
  bool isImgExist = false;
  List<mlog.Param> listParam = [];

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = {};
  CameraPosition _userLocation = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      getImageFromDevice();
      setState(() {
        isLoadPhoto = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void getImageFromDevice() {
    setState(() {
      outletAbsenImgPath =
          '${param.appDir}/${param.imgPath}/${param.outletAbsenFullImgName(widget.user.fdKodeSF, widget.fdKodeLangganan, widget.startDayDate)}';
    });

    File(outletAbsenImgPath).exists().then((value) {
      setState(() {
        isImgExist = value;
      });
    });
  }

  Widget getOutletAbsenImage() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewPictureScreen(
                      imgBytes: File(outletAbsenImgPath).readAsBytesSync())));
        },
        child: FadeInImage(
            placeholder: const AssetImage('assets/images/transparent.png'),
            placeholderFit: BoxFit.scaleDown,
            image: MemoryImage(File(outletAbsenImgPath).readAsBytesSync()),
            fit: BoxFit.fitHeight,
            width: 100 * ScaleSize.textScaleFactor(context),
            height: 100 * ScaleSize.textScaleFactor(context)));
  }

  void gMapInitializes(GoogleMapController controller) async {
    try {
      setState(() {
        isMapReady = false;
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: param.gpsTimeOut));
      //sugeng add remark 22.01.2025 tidak hitung jarak titik GPS
      // if (widget.la != 0 && widget.lg != 0) {
      // listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);

      // double distanceInMeters = Geolocator.distanceBetween(
      //     widget.la, widget.lg, position!.latitude, position!.longitude);
      // if (distanceInMeters > listParam[0].fdMaxDistance) {
      //   if (!mounted) return;

      //   alertDialogForm(
      //       'Titik visit anda tidak sesuai dengan titik GPS outlet', context);
      // }
      // }
      //sugeng end remark 22.01.2025
      _userLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 18);

      //sugeng remark hanya tampil satu titik saja
      // MarkerId markerId = const MarkerId('outlet1');
      // Marker markerOutlet1 = Marker(
      //     markerId: markerId,
      //     icon: BitmapDescriptor.defaultMarker,
      //     position: LatLng(position.latitude, position.longitude));
      // // position: LatLng(widget.la, widget.lg));
      // markers[markerId] = markerOutlet1;

      // LatLngBounds mapBounds = getMapBounds(position, markerOutlet1);
      // controller.animateCamera(
      //   CameraUpdate.newLatLngBounds(mapBounds, 20),
      // );
      //edn remark

      //sugeng add 22.01.2025 untuk tampil map
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 20),
      );
      //sugeng end add

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
                'error load Map: $e. Mohon mengaktifkan GPS dan mengulang dari halaman rute')));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rute Outlet'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: _userLocation,
                  onMapCreated: gMapInitializes),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            //sugeng remark 22.01.2025 tidak pakai foto
            isMapReady
                ? isLoadPhoto
                    ? Center(
                        child:
                            loadingProgress(ScaleSize.textScaleFactor(context)))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isLoadPhoto = true;
                          });
                          ccam
                              .pickCamera(
                                  context,
                                  widget.user.fdToken,
                                  'Take Photo',
                                  outletAbsenImgPath,
                                  widget.routeVisitName,
                                  true)
                              .then((value) {
                            initLoadPage();

                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.photo_camera_rounded,
                            size: 36 * ScaleSize.textScaleFactor(context),
                            color: Colors.orange,
                            semanticLabel: 'Foto Langganan'),
                        tooltip: 'Take photo',
                      )
                : Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context))),
            const Padding(padding: EdgeInsets.all(5)),
            isMapReady
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: isImgExist
                        ? isLoadPhoto
                            ? const Padding(padding: EdgeInsets.zero)
                            : getOutletAbsenImage()
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Text('Foto Langganan',
                                style: css.textExpandBold())))
                : const Padding(padding: EdgeInsets.zero),
            //sugeng end remark
          ],
        ),
        bottomNavigationBar: isMapReady
            ? BottomAppBar(
                height: 40 * ScaleSize.textScaleFactor(context),
                child: TextButton(
                  onPressed: () async {
                    try {
                      //sugeng remark karena tidak ada foto
                      if (isImgExist) {
                        final statusAirPlaneMode =
                            await AirplaneModeChecker.instance.checkAirplaneMode();

                        if (statusAirPlaneMode == AirplaneModeStatus.off) {
                          bool isGPSMocked = true;

                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy:
                                      LocationAccuracy.bestForNavigation,
                                  timeLimit:
                                      Duration(seconds: param.gpsTimeOut));

                          // Position position =
                          //     await Geolocator.getCurrentPosition(
                          //             desiredAccuracy:
                          //                 LocationAccuracy.bestForNavigation,
                          //             timeLimit: const Duration(
                          //                 seconds: param.gpsTimeOut))
                          //         .onError((error, stackTrace) {
                          //   ScaffoldMessenger.of(context)
                          //     ..removeCurrentSnackBar()
                          //     ..showSnackBar(const SnackBar(
                          //         content: Text('error gps timeout')));

                          //   Position position = const Position(
                          //       longitude: 0,
                          //       latitude: 0,
                          //       timestamp: null,
                          //       accuracy: 0,
                          //       altitude: 0,
                          //       heading: 0,
                          //       speed: 0,
                          //       speedAccuracy: 0);

                          //   return position;
                          // });

                          isGPSMocked = position.isMocked;

                          if (!isGPSMocked) {
                            bool isDateTimeSettingValid =
                                await cother.dateTimeSettingValidation();

                            if (isDateTimeSettingValid) {
                              // sugeng remark tidak simpan foto
                              String outletFileName = param.pathImgServer(
                                  widget.user.fdKodeDepo,
                                  widget.user.fdKodeSF,
                                  widget.startDayDate,
                                  '${widget.fdKodeLangganan}/${param.outletAbsenFileName(widget.fdKodeLangganan, widget.startDayDate)}');
                              // String outletFileName = '';

                              try {
                                await placemarkFromCoordinates(
                                        position.latitude, position.longitude)
                                    .then((value) {
                                      placeGPS = value.first;

                                      street = placeGPS.street;
                                      subLocality = placeGPS.subLocality;
                                      subAdministrativeArea =
                                          placeGPS.subAdministrativeArea;
                                      postalCode = placeGPS.postalCode;
                                    })
                                    .timeout(
                                        Duration(seconds: param.gpsTimeOut))
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

                              await csales.insertSFActivity(
                                  widget.user.fdKodeSF,
                                  widget.user.fdKodeDepo,
                                  0,
                                  outletFileName,
                                  param.dateTimeFormatDB.format(DateTime.now()),
                                  '',
                                  position.latitude,
                                  position.longitude,
                                  startVisitActivity,
                                  widget.fdKodeLangganan,
                                  0,
                                  widget.fdRute,
                                  widget.startDayDate,
                                  0,
                                  (await DeviceInfoCe.batteryInfo())
                                                      .level
                                      .toString(),
                                  placeGPS.street,
                                  placeGPS.subLocality,
                                  placeGPS.subAdministrativeArea,
                                  placeGPS.postalCode);

                              if (!mounted) return;

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerPage(
                                          fdKodeLangganan:
                                              widget.fdKodeLangganan,
                                          user: widget.user,
                                          routeName: widget.routeName,
                                          isEndDay: widget.isEndDay,
                                          startDayDate: widget.startDayDate)));
                            }
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
                                content: Text('Mohon matikan air plane mode')));
                        }
                        //sugeng remark karena tidak ada foto
                      }
                    } on TimeoutException {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            const SnackBar(content: Text('error gps timeout')));
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text('error: $e')));
                    }
                  },
                  child: const Text('Visit'),
                ),
              )
            : const Padding(padding: EdgeInsets.zero));
  }
}
