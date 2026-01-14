import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'limitkreditformorder_page.dart';
import 'stockverification_page.dart';
import 'main.dart';
import 'controller/barang_cont.dart' as cbrg;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/stock_cont.dart' as cstk;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/salesman_cont.dart' as csf;
import 'controller/api_cont.dart' as capi;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/stock.dart' as mstoc;
import 'models/limitkredit.dart' as mlk;
import 'models/salesman.dart' as msf;
import 'models/stock.dart' as mstk;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

class StockVerificationDetail extends StatefulWidget {
  final msf.Salesman user;
  final String fdNoEntryStock;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const StockVerificationDetail(
      {super.key,
      required this.user,
      required this.fdNoEntryStock,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<StockVerificationDetail> createState() =>
      LayerStockVerificationDetailPage();
}

class LayerStockVerificationDetailPage extends State<StockVerificationDetail> {
  bool isLoading = false;
  List<mstoc.Stock> listStock = [];
  List<mstoc.Stock> listStockExist = [];
  List<mstoc.StockItem> listStockItem = [];
  List<mstoc.Stock> listGetDataOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mstoc.StockVerification> _liststockverification = [];
  // mlgn.Langganan? barangSelected;
  TextEditingController txtTanggalKirim = TextEditingController();
  TextEditingController stateTanggalKirim = TextEditingController();
  TextEditingController txtSisaOrder = TextEditingController();
  TextEditingController txtPesananBaru = TextEditingController();
  TextEditingController txtOverOrder = TextEditingController();
  TextEditingController txtPengajuanBaruLK = TextEditingController();
  ScrollController scrollControllerVerify = ScrollController();
  Map<String, TextEditingController> textQtyControllers = {};
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  double limitKredit = 0;
  double pengajuanBaru = 0;
  double totalPromosiExtra = 0;
  String noEntry = '';
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
  String kodeGudang = '';
  String kodeGudangSF = '';
  bool checkIsDataExist = false;
  List<mstk.StockItemSum> listBarangExist = [];

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
      _liststockverification = await capi.getDataStockVerificationDetail(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          'D',
          widget.user.fdKodeDepo,
          widget.fdNoEntryStock);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('error: $e')));
      }
    }
  }

  Future<void> saveStockRequest() async {
    try {
      setState(() {
        isLoading = true;
        if (widget.fdNoEntryStock.isNotEmpty) {
          noEntry = widget.fdNoEntryStock;
        } else {
          String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
          noEntry = tanggal;
        }
      });
      listStock = [
        mstoc.Stock(
          fdDepo: widget.user.fdKodeDepo,
          fdKodeLangganan: '0',
          fdTanggal: widget.startDayDate,
          fdNoEntryStock: noEntry,
          fdNoOrder: '',
          fdUnitPrice: 0, //item.fdUnitPrice,
          fdUnitPriceK: 0,
          fdDiscount: 0, //item.fdDiscount,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd MMM yyyy').parse(txtTanggalKirim.text)),
          fdAlamatKirim: '',
          fdKodeGudang: kodeGudang,
          fdKodeGudangSF: kodeGudangSF,
          fdLastUpdate: param.dtFormatDB.format(DateTime.now()),
        )
      ];

      Map<String, dynamic> mapResult = await capi.sendStockRequestToServer(
          noEntry, widget.user, widget.startDayDate, listStock, listStockItem);

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cstk.updateStatusSentStock(noEntry, widget.startDayDate);
      } else if (mapResult['fdMessage'].isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mapResult['fdMessage'])));
      }

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

  void yesNoDialogForm(int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColorGreen(),
              padding: const EdgeInsets.all(16),
              child: const Text('Verifikasi Stock')),
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
                      'Apakah data stock realisasi sudah sesuai dengan stock fisik?')),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    List<mstk.StockApi> stockApiList = [
                      mstk.StockApi(
                        fdNoEntryOrder:
                            _liststockverification[index].fdNoEntryOrder,
                        fdNoEntrySJ: _liststockverification[index].fdNoEntrySJ,
                        fdDepo: _liststockverification[index].fdDepo,
                        fdKodeLangganan:
                            _liststockverification[index].fdKodeLangganan,
                        fdNoEntryStock:
                            _liststockverification[index].fdNoEntryStock,
                        fdTanggal: _liststockverification[index].fdTanggal,
                        fdTotal: 0.0,
                        fdTotalK: 0,
                        fdTotalStock: 0,
                        fdTotalStockK: 0,
                        fdTanggalKirim:
                            _liststockverification[index].fdTanggalKirim,
                        fdAlamatKirim: '',
                        fdKodeGudang: '',
                        fdKodeGudangSF: '',
                        fdNoUrutStock: 0,
                        fdKodeBarang: '',
                        fdNamaBarang: '',
                        fdPromosi: '',
                        fdReplacement: '',
                        fdJenisSatuan: '',
                        fdQtyStock: double.tryParse(
                                _liststockverification[index]
                                    .fdQty!
                                    .toString()) ??
                            0,
                        fdQtyStockK: _liststockverification[index].fdQtyK!,
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
                        fdLastUpdate: '',
                      )
                    ];

                    mstk.StockApi result = await capi.sendStockVerification(
                        widget.user, '4', widget.startDayDate, stockApiList);

                    if (result.fdData != '0' &&
                        result.fdData != '401' &&
                        result.fdData != '500') {
                      listStock = [
                        mstoc.Stock(
                          fdDepo: widget.user.fdKodeDepo,
                          fdKodeLangganan: '0',
                          fdNoEntryStock:
                              _liststockverification[0].fdNoEntryStock,
                          fdNoOrder: _liststockverification[0].fdNoOrder,
                          fdTanggal: widget.startDayDate,
                          fdUnitPrice: 0,
                          fdUnitPriceK: 0,
                          fdDiscount: 0,
                          fdTotal: 0,
                          fdTotalK: 0,
                          fdQtyStock: _liststockverification[0].fdQtyReal!,
                          fdQtyStockK: _liststockverification[0].fdQtyK!,
                          fdTotalStock: 0,
                          fdTotalStockK: 0,
                          fdJenisSatuan: _liststockverification[0]
                              .fdJenisSatuanBS, //item.fdSatuan,
                          fdTanggalKirim:
                              _liststockverification[0].fdTanggalKirim!,
                          fdAlamatKirim: '',
                          fdKodeStatus: 0,
                          fdApproveAdmin: 1,
                          fdStatusSent: 0,
                          fdNoEntryOrder:
                              _liststockverification[0].fdNoEntryOrder,
                          fdNoEntrySJ: _liststockverification[0].fdNoEntrySJ,
                          fdKodeGudang: kodeGudang,
                          fdKodeGudangSF: kodeGudangSF,
                          fdLastUpdate: param.dtFormatDB.format(DateTime.now()),
                        )
                      ];
                      List<mstoc.Stock> header = listStock.toList();

                      var index = 0;
                      listStockItem = _liststockverification.map((item) {
                        return mstoc.StockItem(
                          fdNoEntryStock: item.fdNoEntryStock,
                          fdNoUrutStock: index++,
                          fdKodeBarang: item.fdKodeBarang,
                          fdNamaBarang: item.fdNamaBarang,
                          fdPromosi: '0',
                          fdReplacement: '',
                          fdJenisSatuan: item.fdJenisSatuan.toString(),
                          fdQtyStock: (double.tryParse(
                                      item.fdQtyReal?.toString() ?? '0')
                                  ?.toInt() ??
                              0), //item.fdQty,
                          fdQtyStockK: (double.tryParse(
                                      item.fdQtyRealK?.toString() ?? '0')
                                  ?.toInt() ??
                              0),
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
                          isHanger: '0',
                          isShow: '0',
                          urut: 0,
                          fdLastUpdate: param.dtFormatDB.format(DateTime.now()),
                        );
                      }).toList();
                      List<mstoc.StockItem> items = listStockItem.toList();

                      String noEntryStock =
                          DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
                      checkIsDataExist = await cstk.isStockRequestNotSent(
                          _liststockverification[0].fdNoEntryStock!,
                          widget.startDayDate);
                      if (checkIsDataExist) {
                        await cstk.updateStockBatch(header);
                        await cstk.updateStockItemBatch(items);
                      } else {
                        await cstk.insertStockBatch(header);
                        await cstk.insertStockItemBatch(items);
                      }
                      for (int i = 0; i < items.length; i++) {
                        listBarangExist =
                            await cstk.stockBarangExist(items[i].fdKodeBarang!);
                        if (listBarangExist.isEmpty) {
                          await cstk.insertStockItemSumBatch(
                              widget.user.fdKodeSF,
                              widget.user.fdKodeDepo,
                              noEntryStock,
                              widget.startDayDate,
                              kodeGudang,
                              kodeGudangSF,
                              [items[i]]);
                        } else {
                          await cstk.updateStockItemSumBatch(
                              widget.user.fdKodeSF,
                              widget.user.fdKodeDepo,
                              noEntryStock,
                              widget.startDayDate,
                              kodeGudang,
                              kodeGudangSF,
                              listBarangExist[0].fdQtyStock,
                              listBarangExist[0].fdQtyStockK,
                              [items[i]]);
                        }
                      }
                      initLoadPage();

                      if (!mounted) return;

                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else if (result.fdMessage!.isNotEmpty) {
                      setState(() {
                        isLoading = false;
                      });
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.fdMessage!)));
                    }
                  } catch (e) {
                    if (!mounted) return;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fdNoEntryStock),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Qty Real',
                                  ),

                                  // const Divider(thickness: 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_liststockverification.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _liststockverification.length,
                        itemBuilder: (context, index) {
                          final barang = _liststockverification[index];
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
                                        '${param.enNumberFormatQty.format(_liststockverification[index].fdQty)}/${param.enNumberFormatQty.format(_liststockverification[index].fdQtyS)}/${param.enNumberFormatQty.format(_liststockverification[index].fdQtyK)}',
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
                                        '${param.enNumberFormatQty.format(_liststockverification[index].fdQtyReal)}/${param.enNumberFormatQty.format(_liststockverification[index].fdQtyRealS)}/${param.enNumberFormatQty.format(_liststockverification[index].fdQtyRealK)}',
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
                child: const Text('Verify Stock'),
              ),
            ),
    );
  }
}
