import 'dart:async';
import 'dart:io';
import 'noo_collectionallocate_page.dart';

import 'noo_collectionedit_page.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'cust_page.dart';
import 'piutang_page.dart';
import 'piutangedit_page.dart';
import 'controller/database_cont.dart' as cdb;
import 'controller/collection_cont.dart' as ccoll;
import 'controller/piutang_cont.dart' as cpiu;
import 'models/collection.dart' as mcoll;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

List<mcoll.CollectionDetail> _listCollection = [];

class NooCollectionPage extends StatefulWidget {
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String routeName;
  final String noentry;
  final String navpage;
  final String endTimeVisit;
  final String startDayDate;
  final bool isEndDay;
  final double totalCollection;
  final String? alamatSelected;
  final double orderExist;
  final double totalPromosiExtra;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;
  final String noFaktur;
  final String txtTanggalKirim;

  const NooCollectionPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.noentry,
      required this.navpage,
      required this.startDayDate,
      required this.endTimeVisit,
      required this.isEndDay,
      required this.totalCollection,
      required this.alamatSelected,
      required this.orderExist,
      required this.totalPromosiExtra,
      required this.totalDiscount,
      required this.totalPesanan,
      required this.listKeranjang,
      required this.noFaktur,
      required this.txtTanggalKirim});

  @override
  State<NooCollectionPage> createState() => LayerCollection();
}

class LayerCollection extends State<NooCollectionPage> {
  bool isLoading = false;
  bool bGPSstat = false;
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
  double totalCollection = 0;
  double collectionUsed = 0;

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
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: const Text('Lanjut hapus?')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    stateDelete = await ccoll.deleteCollection(
                        _listCollection[index].fdId, widget.lgn.fdKodeNoo!);

                    // delete image
                    if (stateDelete > 0) {
                      await File(_listCollection[index].fdBuktiImg)
                          .exists()
                          .then((isExist) async {
                        if (isExist) {
                          await File(_listCollection[index].fdBuktiImg)
                              .delete();
                        }
                      });
                    }

                    if (!mounted) return;

                    if (stateDelete == 1) {
                      initLoadPage();
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text('Gagal menghapus data. Coba lagi')));
                    }

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('error: $e')));
                  }
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
    try {
      setState(() {
        isLoading = true;
      });

      await handlePermission();

      _listCollection =
          await ccoll.getAllCollectionByLangganan(widget.lgn.fdKodeNoo!);
      totalCollection =
          _listCollection.fold(0, (sum, item) => sum + item.fdTotalCollection);
      collectionUsed = await cpiu.getTotalAllocation(widget.lgn.fdKodeNoo!);

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
    return WillPopScope(
        // onWillPop: !isLoading
        //     ? () async {
        //         print(widget.navpage);
        //         // if (widget.navpage == 'piutangedit') {
        //         //   Navigator.push(
        //         //       context,
        //         //       MaterialPageRoute(
        //         //           builder: (context) => PiutangEditPage(
        //         //               user: widget.user,
        //         //               lgn: widget.lgn,
        //         //               noentry: widget.noentry,
        //         //               navpage: '',
        //         //               isEndDay: widget.isEndDay,
        //         //               startDayDate: widget.startDayDate,
        //         //               endTimeVisit: widget.endTimeVisit,
        //         //               routeName: 'PiutangEdit')));
        //         // } else if (widget.navpage == 'piutangpage') {
        //         //   Navigator.push(
        //         //       context,
        //         //       MaterialPageRoute(
        //         //           settings: const RouteSettings(name: 'piutang'),
        //         //           builder: (context) => PiutangPage(
        //         //               lgn: widget.lgn,
        //         //               user: widget.user,
        //         //               routeName: 'piutang',
        //         //               isEndDay: widget.isEndDay,
        //         //               endTimeVisit: widget.endTimeVisit,
        //         //               startDayDate: widget.startDayDate)));
        //         // }
        //         return false;
        //       }
        //     : () async => false,
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Collection'),
              automaticallyImplyLeading: false,
              // leading: !isLoading
              //     ? IconButton(
              //         onPressed: () {
              //           if (!mounted) return;

              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => CustomerPage(
              //                       fdKodeLangganan:
              //                           widget.lgn.fdKodeLangganan!,
              //                       user: widget.user,
              //                       routeName: widget.routeName,
              //                       isEndDay: widget.isEndDay,
              //                       startDayDate: widget.startDayDate)));
              //         },
              //         icon: const Icon(Icons.arrow_back),
              //         tooltip: 'Back',
              //       )
              //     : const Padding(padding: EdgeInsets.zero),
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
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: css.boxDecorMenuHeader(),
                              child: Text(
                                  '${widget.lgn.fdKodeNoo} - ${widget.lgn.fdNamaToko}',
                                  style: css.textHeaderBold())),
                          const Padding(padding: EdgeInsets.all(5)),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Expanded(child: Text('Total Collection')),
                                const SizedBox(width: 5),
                                const Text(':'),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Rp. ${param.enNumberFormat.format(totalCollection)}',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('Available')),
                                  const SizedBox(width: 5),
                                  const Text(':'),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Rp. ${param.enNumberFormat.format(totalCollection - collectionUsed)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('Used')),
                                  const SizedBox(width: 5),
                                  const Text(':'),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Rp. ${param.enNumberFormat.format(collectionUsed)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(5),
                                itemCount: _listCollection.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    elevation: 3,
                                    shadowColor: Colors.blue,
                                    shape: css.boxStyle(),
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      _listCollection[index]
                                                          .fdTipe,
                                                      style:
                                                          css.textNormalBold(),
                                                      softWrap: true),
                                                  _listCollection[index]
                                                              .fdTipe ==
                                                          'Transfer'
                                                      ? Text(
                                                          'Trans No : ${_listCollection[index].fdNoCollection}',
                                                          softWrap: true)
                                                      : const SizedBox.shrink(),
                                                  _listCollection[index]
                                                              .fdTipe ==
                                                          'Giro'
                                                      ? Text(
                                                          'Giro No : ${_listCollection[index].fdNoCollection}',
                                                          softWrap: true)
                                                      : const SizedBox.shrink(),
                                                  _listCollection[index]
                                                              .fdTipe ==
                                                          'Cheque'
                                                      ? Text(
                                                          'Cheque No : ${_listCollection[index].fdNoCollection}',
                                                          softWrap: true)
                                                      : const SizedBox.shrink(),
                                                  if ([
                                                    'Transfer',
                                                    'Giro',
                                                    'Cheque'
                                                  ].contains(
                                                      _listCollection[index]
                                                          .fdTipe)) ...[
                                                    Text(
                                                        'From Bank : ${_listCollection[index].fdFromBank}',
                                                        softWrap: true),
                                                    Text(
                                                        'Date : ${param.dtFormatView.format(param.dtFormatDB.parse(_listCollection[index].fdTanggalCollection))}',
                                                        softWrap: true)
                                                  ],
                                                  _listCollection[index]
                                                              .fdTipe ==
                                                          'Transfer'
                                                      ? Text(
                                                          'Tgl. Terima : ${param.dtFormatView.format(param.dtFormatDB.parse(_listCollection[index].fdTanggalTerima))}',
                                                          softWrap: true)
                                                      : const Padding(
                                                          padding:
                                                              EdgeInsets.zero),
                                                  if (['Giro', 'Cheque']
                                                      .contains(
                                                          _listCollection[index]
                                                              .fdTipe)) ...[
                                                    Text(
                                                        'Due Date : ${param.dtFormatView.format(param.dtFormatDB.parse(_listCollection[index].fdDueDateCollection))}',
                                                        softWrap: true)
                                                  ],
                                                  RichText(
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            text:
                                                                'Nominal : Rp. ${param.enNumberFormat.format(_listCollection[index].fdTotalCollection)}'),
                                                        const TextSpan(
                                                            text: ' '),
                                                        TextSpan(
                                                          text:
                                                              '(${param.enNumberFormat.format(_listCollection[index].fdAllocationAmount)})',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const TextSpan(
                                                            text:
                                                                " and back to black."),
                                                      ],
                                                    ),
                                                  )
                                                  // _listCollection[index].fdNotes.isNotEmpty
                                                  //   ? Text(
                                                  //     'Notes : ${_listCollection[index].fdNotes}',
                                                  //     softWrap: true,
                                                  //     overflow: TextOverflow.ellipsis,
                                                  //     maxLines: 1,)
                                                  //   : const Padding(padding: EdgeInsets.zero),
                                                ],
                                              ),
                                            ),
                                            widget.endTimeVisit.isEmpty &&
                                                    _listCollection[index]
                                                            .fdAllocationAmount ==
                                                        0
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        settings: const RouteSettings(
                                                                            name:
                                                                                'NooCollectionEdit'),
                                                                        builder: (context) => NooCollectionEditPage(
                                                                            fdId: _listCollection[index]
                                                                                .fdId,
                                                                            lgn: widget
                                                                                .lgn,
                                                                            user: widget
                                                                                .user,
                                                                            isEndDay: widget
                                                                                .isEndDay,
                                                                            endTimeVisit: widget
                                                                                .endTimeVisit,
                                                                            routeName:
                                                                                'NooCollectionEdit',
                                                                            navpage: widget
                                                                                .navpage,
                                                                            noentry: widget
                                                                                .noentry,
                                                                            startDayDate: widget
                                                                                .startDayDate,
                                                                            indexImg: (_listCollection.length +
                                                                                1),
                                                                            alamatSelected:
                                                                                widget.alamatSelected,
                                                                            orderExist: widget.orderExist,
                                                                            totalPromosiExtra: widget.totalPromosiExtra,
                                                                            totalDiscount: widget.totalDiscount,
                                                                            totalPesanan: widget.totalPesanan,
                                                                            listKeranjang: widget.listKeranjang,
                                                                            noFaktur: widget.noFaktur,
                                                                            txtTanggalKirim: widget.txtTanggalKirim,
                                                                            isLockPage: 0))).then((value) {
                                                                  initLoadPage();

                                                                  setState(
                                                                      () {});
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit,
                                                                  size: 24 *
                                                                      ScaleSize
                                                                          .textScaleFactor(
                                                                              context)),
                                                              color:
                                                                  Colors.blue,
                                                              tooltip: 'Edit',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                yesNoDialogForm(
                                                                    index);
                                                              },
                                                              icon: Icon(
                                                                  Icons.delete,
                                                                  size: 24 *
                                                                      ScaleSize
                                                                          .textScaleFactor(
                                                                              context)),
                                                              color: Colors
                                                                  .red[400],
                                                              tooltip: 'Delete',
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : const Padding(
                                                    padding: EdgeInsets.zero),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      )),
            floatingActionButton: isLoading
                ? const Padding(padding: EdgeInsets.zero)
                : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    widget.endTimeVisit.isEmpty
                        ? FloatingActionButton(
                            tooltip: 'New',
                            heroTag: null,
                            onPressed: () {
                              print(widget.noentry);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: const RouteSettings(
                                          name: 'collectionedit'),
                                      builder: (context) =>
                                          NooCollectionEditPage(
                                              fdId: 0,
                                              lgn: widget.lgn,
                                              user: widget.user,
                                              isEndDay: widget.isEndDay,
                                              endTimeVisit: widget.endTimeVisit,
                                              noentry: widget.noentry,
                                              routeName: 'collectionedit',
                                              navpage: widget.navpage,
                                              startDayDate: widget.startDayDate,
                                              indexImg:
                                                  (_listCollection.length + 1),
                                              alamatSelected:
                                                  widget.alamatSelected,
                                              orderExist: widget.orderExist,
                                              totalPromosiExtra:
                                                  widget.totalPromosiExtra,
                                              totalDiscount:
                                                  widget.totalDiscount,
                                              totalPesanan: widget.totalPesanan,
                                              listKeranjang:
                                                  widget.listKeranjang,
                                              noFaktur: widget.noFaktur,
                                              txtTanggalKirim:
                                                  widget.txtTanggalKirim,
                                              isLockPage: 0))).then((value) {
                                initLoadPage();

                                setState(() {});
                              });
                            },
                            child: Icon(Icons.add,
                                size: 24 * ScaleSize.textScaleFactor(context)),
                          )
                        : const Text(''),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                        tooltip: 'Collection Allocation',
                        heroTag: null,
                        backgroundColor: Colors.green,
                        onPressed: () {
                          if (!mounted) return;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: const RouteSettings(
                                      name: 'collectionallocation'),
                                  builder: (context) =>
                                      NooCollectionAllocationPage(
                                          lgn: widget.lgn,
                                          user: widget.user,
                                          noentry: widget.noentry,
                                          navpage: widget.navpage,
                                          routeName: 'collectionallocation',
                                          startDayDate: widget.startDayDate,
                                          endTimeVisit: widget.endTimeVisit,
                                          isEndDay: widget.isEndDay,
                                          totalCollection: totalCollection,
                                          alamatSelected: widget.alamatSelected,
                                          orderExist: widget.orderExist,
                                          totalPromosiExtra:
                                              widget.totalPromosiExtra,
                                          totalDiscount: widget.totalDiscount,
                                          totalPesanan: widget.totalPesanan,
                                          listKeranjang: widget.listKeranjang,
                                          noFaktur: widget.noFaktur,
                                          txtTanggalKirim:
                                              widget.txtTanggalKirim)));
                        },
                        child: Icon(
                          Icons.receipt_long_rounded,
                          size: 24 * ScaleSize.textScaleFactor(context),
                        ))
                  ])));
  }
}
