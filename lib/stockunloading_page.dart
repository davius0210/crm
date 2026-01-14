import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
import 'stock_page.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/camera.dart' as ccam;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/stock_cont.dart' as cstoc;
import 'controller/other_cont.dart' as cother;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/stock_cont.dart' as cstk;
import 'controller/log_cont.dart' as clog;
import 'models/database.dart' as mdbconfig;
import 'models/stock.dart' as mstoc;
import 'models/langganan.dart' as mlgn;
import 'models/barang.dart' as mbrg;
import 'models/limitkredit.dart' as mlk;
import 'models/logdevice.dart' as mlog;
import 'models/salesman.dart' as msf;
import '../models/stock.dart' as mstk;
import 'models/globalparam.dart' as param;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;

late Placemark placeGPS;
String? street = '';
String? subLocality = '';
String? subAdministrativeArea = '';
String? postalCode = '';

class StockUnloadingPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const StockUnloadingPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<StockUnloadingPage> createState() => Layerstockunloading();
}

class Layerstockunloading extends State<StockUnloadingPage> {
  List<mstoc.StockUnloading> _liststockunloadingPending = [];
  List<mstoc.Stock> _liststockunloading = [];
  List<mlk.LimitKredit> getLimitKredit = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  List<mbrg.Barang> listBarang = [];
  TextEditingController txtReasonLain = TextEditingController();
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
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
  double stockunloadingExist = 0;

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

  void yesNoDialogForm(int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColorGreen(),
              padding: const EdgeInsets.all(16),
              child: const Text('Konfirmasi Unloading Stock')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Padding(
                  padding: EdgeInsets.all(5), child: Text('Proses Unloading?')),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (_liststockunloadingPending.isNotEmpty) {
                      // List<mstk.StockApi> stockApiList = [
                      //   mstk.StockApi(
                      //     fdNoEntryOrder: '',
                      //     fdNoEntrySJ: '',
                      //     fdDepo: _liststockunloadingPending[index].fdDepo,
                      //     fdKodeLangganan:
                      //         _liststockunloadingPending[index].fdKodeLangganan,
                      //     fdNoEntryStock:
                      //         _liststockunloadingPending[index].fdNoEntryStock,
                      //     fdTanggal:
                      //         _liststockunloadingPending[index].fdTanggal,
                      //     fdTotal: 0.0,
                      //     fdTotalK: 0,
                      //     fdTotalStock: 0,
                      //     fdTotalStockK: 0,
                      //     fdTanggalKirim:
                      //         _liststockunloadingPending[index].fdTanggalKirim,
                      //     fdAlamatKirim: '',
                      //     fdKodeGudang:
                      //         _liststockunloadingPending[index].fdKodeGudangSF,
                      //     fdKodeGudangSF:
                      //         _liststockunloadingPending[index].fdKodeGudang,
                      //     fdNoUrutStock: 0,
                      //     fdKodeBarang:
                      //         _liststockunloadingPending[index].fdKodeBarang,
                      //     fdNamaBarang: '',
                      //     fdPromosi: '',
                      //     fdReplacement: '',
                      //     fdJenisSatuan:
                      //         _liststockunloadingPending[index].fdJenisSatuan,
                      //     fdQtyStock:
                      //         _liststockunloadingPending[index].fdQtyStock,
                      //     fdQtyStockK:
                      //         _liststockunloadingPending[index].fdQtyStockK,
                      //     fdUnitPrice: 0,
                      //     fdUnitPriceK: 0,
                      //     fdBrutto: 0,
                      //     fdDiscount: 0,
                      //     fdDiscountDetail: '',
                      //     fdNetto: 0,
                      //     fdNoPromosi: '',
                      //     fdNotes: '',
                      //     fdQtyPBE: 0,
                      //     fdQtySJ: 0,
                      //     fdStatusRecord: 0,
                      //     fdKodeStatus: 0,
                      //     fdStatusSent: 0,
                      //     fdLastUpdate: '',
                      //   )
                      // ];

                      List<mstk.StockApi> convertToLangganan(
                          List<mstk.StockUnloading> items) {
                        return items
                            .map((e) => mstk.StockApi(
                                fdNoEntryOrder: '',
                                fdNoEntrySJ: '',
                                fdDepo: e.fdDepo,
                                fdKodeLangganan: e.fdKodeLangganan,
                                fdNoEntryStock: e.fdNoEntryStock,
                                fdTanggal: e.fdTanggal,
                                fdTotal: 0.0,
                                fdTotalK: 0,
                                fdTotalStock: 0,
                                fdTotalStockK: 0,
                                fdTanggalKirim: e.fdTanggalKirim,
                                fdAlamatKirim: '',
                                fdKodeGudang: e.fdKodeGudangSF,
                                fdKodeGudangSF: e.fdKodeGudang,
                                fdNoUrutStock: 0,
                                fdKodeBarang: e.fdKodeBarang,
                                fdNamaBarang: '',
                                fdPromosi: '',
                                fdReplacement: '',
                                fdJenisSatuan: e.fdJenisSatuan,
                                fdQtyStock: e.fdQtyStock,
                                fdQtyStockK: e.fdQtyStockK,
                                fdUnitPrice: 0,
                                fdUnitPriceK: 0,
                                fdBrutto: 0,
                                fdDiscount: 0,
                                fdDiscountDetail: '',
                                fdNetto: 0,
                                fdNoPromosi: '',
                                fdNotes: '',
                                fdQtyPBE: 0,
                                fdQtySJ: 0,
                                fdStatusRecord: 0,
                                fdKodeStatus: 0,
                                fdStatusSent: 0,
                                fdLastUpdate: ''))
                            .toList();
                      }

                      List<mstk.StockApi> stockApiList =
                          convertToLangganan(_liststockunloadingPending);
                      mstk.StockApi result =
                          await capi.sendStockUnloadingtoServer(widget.user,
                              '0', widget.startDayDate, stockApiList, 0);

                      if (result.fdData != '0' &&
                          result.fdData != '401' &&
                          result.fdData != '500') {
                        // await cstk.updateStatusSentStockUnloading(
                        //     _liststockunloadingPending[index].fdNoEntryStock!,
                        //     widget.startDayDate);
                        await cstk.deleteStock(widget.startDayDate);
                        initLoadPage();
                        if (!mounted) return;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: const RouteSettings(name: 'stock'),
                                builder: (context) => StockPage(
                                    user: widget.user,
                                    startDayDate: widget.startDayDate,
                                    isEndDay: widget.isEndDay,
                                    routeName: 'stock'))).then((value) {
                          initLoadPage();

                          setState(() {});
                        });
                      } else if (result.fdMessage!.isNotEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.fdMessage!)));
                      }
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tidak ada data')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('error: $e')));
                  }
                },
                child: const Text('Ya')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tidak')),
            const Padding(padding: EdgeInsets.all(5)),
          ],
        );
      }),
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

      _liststockunloadingPending = await cstk.getAllStockRequestTransaction();
      if (_liststockunloadingPending.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Stock Unloading kosong')));
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

  void alertScaffold(String msg) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Unloading'),
      ),
      body: Form(
        key: formInputKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: css.boxDecorMenuHeader(),
              child: Text('${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
                  style: css.textHeaderBold())),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      color: Colors.orange,
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kode Barang',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Barang',
                                  ),

                                  // const Divider(thickness: 1),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Qty Req.',
                                  ),

                                  // const Divider(thickness: 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_liststockunloadingPending.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _liststockunloadingPending.length,
                        itemBuilder: (context, index) {
                          final barang = _liststockunloadingPending[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        barang.fdKodeBarang!.trim(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        barang.fdNamaBarang!.trim(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${param.enNumberFormatDec.format(_liststockunloadingPending[index].fdQtyStock)}/${param.enNumberFormatDec.format(_liststockunloadingPending[index].fdQtyStockS)}/${param.enNumberFormatDec.format(_liststockunloadingPending[index].fdQtyStockK)}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: isLoading
          ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
          : BottomAppBar(
              height: 40 * ScaleSize.textScaleFactor(context),
              child: TextButton(
                onPressed: () async {
                  yesNoDialogForm(0);
                },
                child: const Text('Unloading'),
              ),
            ),
    );
  }
}
