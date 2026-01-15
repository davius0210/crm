import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:crm_apps/orderform_page.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
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
import 'orderform_page.dart';
import 'orderedit_page.dart';
import 'orderview_page.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/camera.dart' as ccam;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/log_cont.dart' as clog;
import 'models/database.dart' as mdbconfig;
import 'models/order.dart' as modr;
import 'models/langganan.dart' as mlgn;
import 'models/limitkredit.dart' as mlk;
import 'models/logdevice.dart' as mlog;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;

List<modr.Order> _listOrder = [];
late Placemark placeGPS;
String? street = '';
String? subLocality = '';
String? subAdministrativeArea = '';
String? postalCode = '';

class OrderPage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String endTimeVisit;
  final String startDayDate;
  final bool isEndDay;

  const OrderPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.endTimeVisit,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<OrderPage> createState() => LayerOrder();
}

class LayerOrder extends State<OrderPage> {
  List<modr.Order> _listOrderPending = [];
  List<modr.Order> listOrder = [];
  List<mlk.LimitKredit> getLimitKredit = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  TextEditingController txtReasonLain = TextEditingController();
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
  int stateDelete = 0;
  List<Map<String, dynamic>> totalProduk = [];
  String noEntry = '';
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  double limitKredit = 0;
  double pengajuanBaru = 0;
  double totalPromosiExtra = 0;
  double totalTagihan = 0;
  double grandTotal = 0;
  double totalDiskon = 0;
  double sumpengajuanBaru = 0;
  double sumpesananBaru = 0;
  double sumoverLK = 0;
  double gtpengajuanBaru = 0;
  double gtpesananBaru = 0;
  double gtoverLK = 0;
  double orderExist = 0;

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

  Future<void> calculateLimitKredit() async {
    try {
      // var dataLimitKredit = await clk
      //     .getAllLimitKreditTransaction(widget.lgn.fdKodeLangganan!);
      getLimitKredit = await clk.getAllLimitKreditTransaction(
          widget.lgn.fdKodeLangganan!, widget.startDayDate);
      listOrder =
          await codr.getDataOrderByKodeLangganan(widget.lgn.fdKodeLangganan!);
      if (getLimitKredit.isEmpty) {
        gtpesananBaru = listOrder.first.fdTotalOrder;
        sisaLK = getLimitKredit.first.fdSisaLimit ?? 0;
        limitKredit = getLimitKredit.first.fdLimitKredit ?? 0;

        overLK = gtpesananBaru - sisaLK;
        gtpengajuanBaru = limitKredit + overLK;
        gtoverLK = overLK;
      } else {
        pengajuanBaru = limitKredit + overLK;
        sumpengajuanBaru = (getLimitKredit.first.fdPengajuanLimitBaru ?? 0);
        sumpesananBaru = (getLimitKredit.first.fdPesananBaru ?? 0);
        sumoverLK = (getLimitKredit.first.fdOverLK ?? 0);

        gtpesananBaru = listOrder.first.fdTotalOrder;
        sisaLK = getLimitKredit.first.fdSisaLimit ?? 0;
        limitKredit = getLimitKredit.first.fdLimitKredit ?? 0;

        overLK = gtpesananBaru - sisaLK;
        gtpengajuanBaru = limitKredit + overLK;
        gtoverLK = overLK;
      }
      print('LK baru : ${gtpengajuanBaru}');
      if (gtpengajuanBaru > 0) {
        listLimitKredit = [
          mlk.LimitKredit(
            fdNoLimitKredit: noEntry.isNotEmpty
                ? noEntry
                : DateFormat('yyMMddHHmmssSSS').format(DateTime.now()),
            fdDepo: widget.user.fdKodeDepo,
            fdKodeLangganan: widget.lgn.fdKodeLangganan,
            fdSisaLimit: sisaLK,
            fdPesananBaru: gtpesananBaru,
            fdOverLK: gtoverLK,
            fdTglStatus: widget.startDayDate,
            fdTanggal: getLimitKredit.first.fdTglStatus!,
            fdLimitKredit: limitKredit,
            fdPengajuanLimitBaru: gtpengajuanBaru,
            fdKodeStatus: 0,
            fdStatusSent: 0,
            fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
          )
        ];

        List<mlk.LimitKredit> items = listLimitKredit.toList();
        await clk.insertLimitKreditBatch(items);
      } else {
        await clk.deleteLimitKreditBatch(widget.lgn.fdKodeLangganan!);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void yesNoDialogForm(int index) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus?',
        onOk: () async {
          try {
            // 1. Jalankan proses hapus data berdasarkan token dan NoEntryOrder
            stateDelete = await codr.deleteByNoEntry(
              widget.user.fdToken, 
              _listOrder[index].fdNoEntryOrder!,
            );

            // 2. Jika sukses (state 1), update limit kredit dan refresh list
            if (stateDelete == 1) {
              await calculateLimitKredit();
              initLoadPage();
            }

            // 3. Pastikan widget masih aktif sebelum menutup dialog
            if (!mounted) return;
            Navigator.pop(context);

          } catch (e) {
            // Tampilkan error jika terjadi kegagalan sistem/API
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('error: $e')),
              );
            }
          }
        },
      ),
    );
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
      _listOrder =
          await codr.getAllOrderByKodeLangganan(widget.lgn.fdKodeLangganan!);
      totalProduk = await codr.getTotalProdukByKodeLangganan(
          widget.lgn.fdKodeLangganan!, widget.startDayDate);
      if (_listOrder.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Data Order kosong')));
      } else {
        print('Total Produk: $totalProduk');
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
  }

  Future<String> saveNotVisit(
      Function(Function()) setState,
      String? fdKodeLangganan,
      String? fdKodeReason,
      String? fdReason,
      int fdOrder) async {
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
                // String dirCameraPath =
                //     '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
                // Directory dir = Directory('$dirCameraPath/$fdKodeLangganan');
                // String zipPath =
                //     '$dirCameraPath/$fdKodeLangganan.zip'; //path di luar folder kode langganan
                // String errorMsg =
                //     await cdb.createZipDirectory(dir.path, zipPath);

                // if (errorMsg.isEmpty) {
                late Database db;

                try {
                  db = await openDatabase(mdbconfig.dbFullPath,
                      version: mdbconfig.dbVersion);
                  await db.transaction((txn) async {
                    String reasonFileName = '';
                    // if (File(imgReasonNotVisitPath).existsSync()) {
                    //   reasonFileName = param.pathImgServer(
                    //       widget.user.fdKodeDepo,
                    //       widget.user.fdKodeSF,
                    //       widget.startDayDate,
                    //       '$fdKodeLangganan/${param.reasonNotVisitFileName(fdKodeLangganan!, widget.startDayDate)}');
                    // }
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

                    _listOrder = await codr.getAllOrderByKodeLangganan(
                        widget.lgn.fdKodeLangganan!);
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
                // } else {
                //   setState(() {
                //     isLoading = false;
                //   });

                //   return 'Error compress file: $errorMsg';
                // }
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerPage(
                            fdKodeLangganan: widget.lgn.fdKodeLangganan!,
                            user: widget.user,
                            routeName: widget.routeName,
                            isEndDay: widget.isEndDay,
                            startDayDate: widget.startDayDate)));

                return false;
              }
            : () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pesanan'),
            leading: !isLoading
                ? IconButton(
                    onPressed: () {
                      if (!mounted) return;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerPage(
                                  fdKodeLangganan: widget.lgn.fdKodeLangganan!,
                                  user: widget.user,
                                  routeName: widget.routeName,
                                  isEndDay: widget.isEndDay,
                                  startDayDate: widget.startDayDate)));
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
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: _listOrder.length,
                    itemBuilder: (BuildContext context, int index) {
                      modr.Order outletPending = modr.Order.empty();

                      //Get outlet pending karena apps di kill atau device ter-restart
                      if (_listOrderPending.isNotEmpty) {
                        outletPending = _listOrderPending.firstWhere(
                            (element) =>
                                element.fdKodeLangganan ==
                                _listOrder[index].fdKodeLangganan,
                            orElse: () => modr.Order.empty());
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 3,
                        shadowColor: Colors.blue,
                        shape: css.boxStyle(),
                        child: InkWell(
                          onTap: () async {
                            widget.endTimeVisit.isNotEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: 'OrderView'),
                                        builder: (context) => OrderViewPage(
                                            fdNoEntryOrder: _listOrder[index]
                                                .fdNoEntryOrder
                                                .toString(),
                                            lgn: widget.lgn,
                                            user: widget.user,
                                            isEndDay: widget.isEndDay,
                                            endTimeVisit: widget.endTimeVisit,
                                            routeName: 'OrderView',
                                            startDayDate: widget
                                                .startDayDate))).then((value) {
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
                                          'Order ID : ${_listOrder[index].fdNoEntryOrder}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                      Text(
                                          'Total Produk : ${param.idNumberFormat.format(totalProduk.firstWhere(
                                                (element) =>
                                                    element['fdNoEntryOrder'] ==
                                                    _listOrder[index]
                                                        .fdNoEntryOrder,
                                                orElse: () =>
                                                    {'totalProduk': 0},
                                              )['totalProduk'] ?? 0)}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                      Text(
                                          'Total Pesanan : Rp. ${param.enNumberFormat.format(_listOrder[index].fdTotalOrder)}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                      Text(
                                          'Diskon Harga : Rp. ${param.enNumberFormat.format(_listOrder[index].fdDiscount)}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                      Text(
                                          'Total Tagihan : Rp. ${param.enNumberFormat.format((_listOrder[index].fdTotalOrder) - (_listOrder[index].fdDiscount ?? 0))}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                      Text(
                                          'Tgl Kirim : ${_listOrder[index].fdTanggalKirim != null ? param.dtFormatViewMMM.format(DateTime.parse(_listOrder[index].fdTanggalKirim!)).toString() : 'Invalid Date'}',
                                          style: css.textNormalBold(),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                widget.endTimeVisit.isEmpty
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: IconButton(
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    settings:
                                                        const RouteSettings(
                                                            name: 'OrderEdit'),
                                                    builder: (context) =>
                                                        OrderEditPage(
                                                            fdNoEntryOrder:
                                                                _listOrder[
                                                                        index]
                                                                    .fdNoEntryOrder
                                                                    .toString(),
                                                            lgn: widget.lgn,
                                                            user: widget.user,
                                                            isEndDay:
                                                                widget.isEndDay,
                                                            endTimeVisit: widget
                                                                .endTimeVisit,
                                                            routeName:
                                                                'OrderEdit',
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
                                      )
                                    : const Padding(padding: EdgeInsets.zero),
                                widget.endTimeVisit.isEmpty
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: IconButton(
                                          onPressed: () async {
                                            yesNoDialogForm(index);
                                          },
                                          icon: Icon(Icons.delete,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          color: Colors.red[400],
                                          tooltip: 'Delete',
                                        ),
                                      )
                                    : const Padding(padding: EdgeInsets.zero)
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
          floatingActionButton: isLoading
              ? const Padding(padding: EdgeInsets.zero)
              : widget.endTimeVisit.isEmpty
                  ? FloatingActionButton(
                      tooltip: 'New',
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: 'OrderForm'),
                                    builder: (context) => OrderFormPage(
                                        fdNoEntryOrder: '',
                                        lgn: widget.lgn,
                                        user: widget.user,
                                        isEndDay: widget.isEndDay,
                                        endTimeVisit: widget.endTimeVisit,
                                        routeName: 'OrderForm',
                                        startDayDate: widget.startDayDate)))
                            .then((value) {
                          initLoadPage();

                          setState(() {});
                        });
                      },
                      child: Icon(Icons.add,
                          size: 24 * ScaleSize.textScaleFactor(context)),
                    )
                  : const Text(''),
        ));
  }
}
