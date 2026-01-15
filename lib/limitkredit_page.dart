import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:crm_apps/limitkreditform_page.dart';
import 'package:crm_apps/limitkreditedit_page.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:crm_apps/new/helper/function_helper.dart';
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
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/database.dart' as mdbconfig;
import 'models/langganan.dart' as mlgn;
import 'models/limitkredit.dart' as mlk;
import 'models/logdevice.dart' as mlog;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;

List<mlk.ListLimitKredit> _listLimitKredit = [];
late Placemark placeGPS;
String? street = '';
String? subLocality = '';
String? subAdministrativeArea = '';
String? postalCode = '';

class LimitKreditPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const LimitKreditPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<LimitKreditPage> createState() => LayerLimitKredit();
}

class LayerLimitKredit extends State<LimitKreditPage> {
  List<mlk.LimitKredit> _listLimitKreditPending = [];
  TextEditingController txtReasonLain = TextEditingController();
  int stateDelete = 0;
  bool isLoading = false;
  bool isLoadButton = false;
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
      // await handlePermission();
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);
      _listLimitKredit = await clk.getAllLimitKredit();
      if (_listLimitKredit.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Limit Kredit kosong')));
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

  void yesNoDialogForm(String fdNoLimitKredit) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus?',
        onOk: () async {
          try {
            // 1. Eksekusi proses hapus data Limit Kredit
            stateDelete = await clk.deleteByNoEntry(fdNoLimitKredit);

            // 2. Jika berhasil dihapus (state == 1), refresh halaman
            if (stateDelete == 1) {
              initLoadPage();
            }

            // 3. Safety check mounted sebelum Navigator
            if (!mounted) return;

            // 4. Tutup dialog
            Navigator.pop(context);
            
          } catch (e) {
            // Handle error dengan SnackBar
            if (mounted) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('error: $e')));
            }
          }
        },
      ),
    );
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
            title: const Text('Limit Kredit'),
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
                      itemCount: _listLimitKredit.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            margin: const EdgeInsets.only(bottom: 15),
                            elevation: 3,
                            shadowColor: Colors.blue,
                            shape: css.boxStyle(),
                            child: InkWell(
                              onTap: () {
                                _listLimitKredit[index].fdKodeStatus == 1
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            settings: const RouteSettings(
                                                name: 'LimitKreditEdit'),
                                            builder: (context) =>
                                                LimitKreditEditPage(
                                                    noLimitKredit:
                                                        _listLimitKredit[index]
                                                            .fdNoLimitKredit
                                                            .toString(),
                                                    user: widget.user,
                                                    isEndDay: widget.isEndDay,
                                                    routeName:
                                                        'LimitKreditEdit',
                                                    startDayDate: widget
                                                        .startDayDate))).then(
                                        (value) {
                                        initLoadPage();

                                        setState(() {});
                                      })
                                    : null;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '[${_listLimitKredit[index].fdKodeLangganan}] ${_listLimitKredit[index].fdNamaLangganan} ',
                                              style: css.textNormalBold(),
                                              softWrap: true),
                                          Text(
                                              'No Pengajuan LK : ${_listLimitKredit[index].fdNoLimitKredit} ',
                                              softWrap: true),
                                          Text(
                                              'Nilai Pesanan : ${param.idNumberFormat.format(_listLimitKredit[index].fdPesananBaru)} ',
                                              softWrap: true),
                                          Text(
                                              'LK : ${param.idNumberFormat.format(_listLimitKredit[index].fdLimitKredit)} ',
                                              softWrap: true),
                                          Text(
                                              'Sisa LK : ${param.idNumberFormat.format(_listLimitKredit[index].fdSisaLimit)} ',
                                              softWrap: true),
                                          Text(
                                              'Over LK : ${param.idNumberFormat.format(_listLimitKredit[index].fdOverLK)} ',
                                              softWrap: true),
                                          Text(
                                              'LK Baru : ${param.idNumberFormat.format(_listLimitKredit[index].fdPengajuanLimitBaru)} ',
                                              softWrap: true)
                                        ],
                                      ),
                                    ),
                                    _listLimitKredit[index].fdKodeStatus == 1
                                        ? const Text('')
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: IconButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings:
                                                            const RouteSettings(
                                                                name:
                                                                    'LimitKreditEdit'),
                                                        builder: (context) => LimitKreditEditPage(
                                                            noLimitKredit:
                                                                _listLimitKredit[
                                                                        index]
                                                                    .fdNoLimitKredit
                                                                    .toString(),
                                                            user: widget.user,
                                                            isEndDay:
                                                                widget.isEndDay,
                                                            routeName:
                                                                'LimitKreditEdit',
                                                            startDayDate: widget
                                                                .startDayDate))).then(
                                                    (value) {
                                                  initLoadPage();

                                                  setState(() {});
                                                });
                                              },
                                              icon: Icon(Icons.edit,
                                                  size: 24 *
                                                      ScaleSize.textScaleFactor(
                                                          context)),
                                              color: Colors.blue,
                                              tooltip: 'Edit',
                                            ),
                                          ),
                                    _listLimitKredit[index].fdKodeStatus == 1
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: IconButton(
                                              onPressed: () async {
                                                null;
                                              },
                                              icon: Icon(Icons.check_circle,
                                                  size: 24 *
                                                      ScaleSize.textScaleFactor(
                                                          context)),
                                              color: Colors.green,
                                              tooltip: 'OK',
                                            ),
                                          )
                                        : const Text(''),
                                    // SizedBox(
                                    //     width: MediaQuery.of(context)
                                    //             .size
                                    //             .width *
                                    //         0.1,
                                    //     child: IconButton(
                                    //       onPressed: () async {
                                    //         yesNoDialogForm(
                                    //             _listLimitKredit[index]
                                    //                 .fdNoLimitKredit
                                    //                 .toString());
                                    //       },
                                    //       icon: Icon(Icons.delete,
                                    //           size: 24 *
                                    //               ScaleSize
                                    //                   .textScaleFactor(
                                    //                       context)),
                                    //       color: Colors.red[400],
                                    //       tooltip: 'Delete',
                                    //     ),
                                    //   )
                                  ],
                                ),
                              ),
                              // Padding(
                              //     padding: const EdgeInsets.all(5),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(
                              //             children: [
                              //               Expanded(
                              //                   child: Text(
                              //                       '[${_listLimitKredit[index].fdKodeLangganan}] ${_listLimitKredit[index].fdNamaLangganan} ',
                              //                       style: css.textNormalBold(),
                              //                       softWrap: true)),
                              //             ],
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(
                              //             children: [
                              //               const Text('No Pengajuan LK : '),
                              //               Expanded(
                              //                   child: Text(
                              //                       '${_listLimitKredit[index].fdNoLimitKredit} ',
                              //                       softWrap: true)),
                              //               const Text('Nilai Pesanan : '),
                              //               Expanded(
                              //                   child: Text(
                              //                       '${_listLimitKredit[index].fdPesananBaru} ',
                              //                       softWrap: true)),
                              //             ],
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(children: [
                              //             const Text('LK : '),
                              //             Expanded(
                              //                 child: Text(
                              //                     '${_listLimitKredit[index].fdLimitKredit} ',
                              //                     softWrap: true)),
                              //             const Text('Sisa LK : '),
                              //             Expanded(
                              //                 child: Text(
                              //                     '${_listLimitKredit[index].fdSisaLimit} ',
                              //                     softWrap: true)),
                              //           ]),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(children: [
                              //             const Text('Over LK : '),
                              //             Expanded(
                              //                 child: Text(
                              //                     '${_listLimitKredit[index].fdOverLK} ',
                              //                     softWrap: true)),
                              //             const Text('LK Baru : '),
                              //             Expanded(
                              //                 child: Text(
                              //                     '${_listLimitKredit[index].fdOverLK} ',
                              //                     softWrap: true)),
                              //           ]),
                              //         ),
                              //         Row(
                              //           children: [
                              //             IconButton(
                              //               onPressed: () async {
                              //                 await sfaInsertSalesActivity(
                              //                     _listLimitKredit[index]
                              //                         .fdKodeLangganan!);

                              //                 if (!mounted) return;
                              //               },
                              //               icon: Icon(Icons.create_outlined,
                              //                   size: 30 *
                              //                       ScaleSize.textScaleFactor(
                              //                           context)),
                              //               color: Colors.blueAccent,
                              //               tooltip: 'Next',
                              //             ),
                              //           ],
                              //         )
                              //       ],
                              //     )),
                            ));
                      })),
          // floatingActionButton: isLoading
          //     ? const Padding(padding: EdgeInsets.zero)
          //     : widget.isEndDay
          //         ? null
          //         : FloatingActionButton(
          //             tooltip: 'New',
          //             onPressed: () {
          //               Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           settings: const RouteSettings(
          //                               name: 'LimitKreditForm'),
          //                           builder: (context) => LimitKreditFormPage(
          //                               kodeLangganan: '',
          //                               user: widget.user,
          //                               isEndDay: widget.isEndDay,
          //                               routeName: 'LimitKreditForm',
          //                               startDayDate: widget.startDayDate)))
          //                   .then((value) {
          //                 initLoadPage();

          //                 setState(() {});
          //               });
          //             },
          //             child: Icon(Icons.add,
          //                 size: 24 * ScaleSize.textScaleFactor(context)),
          //           ),
        ));
  }
}
