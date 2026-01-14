import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'order_page.dart';
import 'ordercartform_page.dart';
import 'main.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/promo_cont.dart' as cpro;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/order.dart' as modr;
import 'models/promo.dart' as mpro;
import 'models/globalparam.dart' as param;
import 'models/logdevice.dart' as mlog;
import 'style/css.dart' as css;

// List<MultiSelectItem> listSatuan = [
//   MultiSelectItem(0, 'Kecil'),
//   MultiSelectItem(1, 'Sedang'),
//   MultiSelectItem(2, 'Besar'),
// ];

class OrderViewPage extends StatefulWidget {
  final String fdNoEntryOrder;
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;
  final String endTimeVisit;

  const OrderViewPage(
      {super.key,
      required this.fdNoEntryOrder,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate,
      required this.endTimeVisit});

  @override
  State<OrderViewPage> createState() => LayerOrderViewPage();
}

class LayerOrderViewPage extends State<OrderViewPage> {
  bool isLoading = false;
  List<mlgn.Langganan> langganans = [];
  List<modr.Order> listOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mbrg.Satuan> listSatuan = [];
  List<mbrg.BarangSelected> listBarangSelected = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mlog.Param> listParam = [];
  List<mbrg.BarangSelected> fBarangExtra = [];

  Map<String, List<mbrg.Satuan>> satuanPerBarang = {};
  Map<String, String?> satuanSelectedPerBarang = {};

  // List<mpro.ViewBarangPromo> barangs = [];
  String? barangSelected;
  String? satuanSelected;
  // mlgn.Langganan? barangSelected;
  TextEditingController txtOrder = TextEditingController();
  TextEditingController txtSisaOrder = TextEditingController();
  TextEditingController txtPesananBaru = TextEditingController();
  TextEditingController txtOverOrder = TextEditingController();
  TextEditingController txtPengajuanBaruLK = TextEditingController();
  Map<String, TextEditingController> textQtyControllers = {};
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  int totalItem = 0;
  int? qty = 0;
  bool checkSave = false;
  String fdKodeHarga = '';

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
      listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      listBarangSelected =
          await cbrg.getAllBarangInputOrder(widget.fdNoEntryOrder);
      satuanPerBarang =
          await cbrg.getListSatuanBarangByFdKodeBarangMap(listBarangSelected);
      fdKodeHarga = await cbrg.getKodeHarga(widget.lgn.fdKodeLangganan!);

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

  Future<bool> saveOrder() async {
    try {
      if (listBarangSelected.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Belum ada list barang')));
        return false;
      }
      for (var barang in listBarangSelected) {
        if (barang.fdJenisSatuan != 0 &&
            barang.fdJenisSatuan != 1 &&
            barang.fdJenisSatuan != 2) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Satuan barang ${barang.fdNamaBarang} harus dipilih')));
          return false;
        }
        if (barang.fdQty == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Quantity barang ${barang.fdNamaBarang} tidak boleh kosong')));
          return false;
        }
        if (barang.fdQty! <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Quantity barang ${barang.fdNamaBarang} tidak boleh kosong')));
          return false;
        }
      }
      setState(() {
        isLoading = true;
        for (int i = 0; i < listBarangSelected.length; i++) {
          listBarangSelected[i].fdNamaJenisSatuan =
              satuanPerBarang[listBarangSelected[i].fdKodeBarang]
                      ?.firstWhere(
                        (satuan) =>
                            satuan.fdKodeSatuan.trim() ==
                            listBarangSelected[i].fdJenisSatuan.toString(),
                        orElse: () =>
                            mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
                      )
                      .fdNamaSatuan ??
                  '';
        }
        log('sv listBarangSelected: ${listBarangSelected.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan}, promosi: ${item.fdPromosi})').toList()}');

        listKeranjang = listBarangSelected.map((barang) {
          return mbrg.BarangSelected(
            fdKodeBarang: barang.fdKodeBarang,
            fdNamaBarang: barang.fdNamaBarang,
            fdQty: barang.fdQty,
            fdJenisSatuan: barang.fdJenisSatuan,
            fdNamaJenisSatuan: barang.fdNamaJenisSatuan,
            fdPromosi: barang.fdPromosi,
            fdUnitPrice: barang.fdUnitPrice,
            fdTotalPrice: barang.fdQty! *
                barang.fdUnitPrice!.toDouble(), // barang.fdTotalPrice,
          );
        }).toList();
        log('sv listKeranjang: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan}, promosi: ${item.fdPromosi})').toList()}');
      });
      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
      return false;
    }
  }

  Future<void> showCalendar(TextEditingController txtEdit) async {
    DateTime? selectDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: Colors.black))),
          child: child!,
        );
      },
      context: context,
      initialDate: txtEdit.text.isEmpty
          ? DateTime.now()
          : param.dtFormatView.parse(txtEdit.text), //get today's date
      firstDate: DateTime(DateTime.now()
          .year), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2060),
    );

    if (selectDate != null) {
      setState(() {
        txtEdit.text = param.dtFormatView.format(selectDate);
      });
    }
  }

  IconButton clearDateIcon(TextEditingController txtEdit) {
    return IconButton(
        onPressed: () async {
          setState(() {
            txtEdit.text = '';
          });
        },
        icon: Icon(Icons.clear,
            color: Colors.red, size: 24 * ScaleSize.textScaleFactor(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),
      body: Form(
          key: formInputKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: css.boxDecorMenuHeader(),
                child: Text(
                    '${widget.lgn.fdKodeLangganan} - ${widget.lgn.fdNamaLangganan}',
                    style: css.textHeaderBold())),
            const Padding(padding: EdgeInsets.all(5)),
            Flexible(
                child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  if (listBarangSelected.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: listBarangSelected.length,
                        itemBuilder: (context, index) {
                          final barang = listBarangSelected[index];
                          return barang.isShow == '1'
                              ? Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(barang.fdNamaBarang.trim(),
                                            style: TextStyle(
                                                color: listBarangSelected[index]
                                                            .fdPromosi ==
                                                        '0'
                                                    ? Colors.black
                                                    : Colors.green[700])),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            param.enNumberFormatQty
                                                .format(barang.fdQty)
                                                .toString(),
                                            style: css
                                                .textInputStyle(
                                                  'Qty',
                                                  const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  'Qty',
                                                  null,
                                                  null,
                                                )
                                                .labelStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            (satuanPerBarang[barang
                                                            .fdKodeBarang] ??
                                                        [])
                                                    .firstWhere(
                                                      (satuan) =>
                                                          satuan.fdKodeSatuan
                                                              .trim() ==
                                                          barang.fdJenisSatuan
                                                              .toString(),
                                                      orElse: () => mbrg.Satuan(
                                                          fdKodeSatuan: '0',
                                                          fdNamaSatuan: 'PCS'),
                                                    )
                                                    .fdNamaSatuan
                                                    ?.trim() ??
                                                '',
                                            style: css
                                                .textInputStyle(
                                                  'Satuan',
                                                  const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  'Satuan',
                                                  null,
                                                  null,
                                                )
                                                .labelStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink();
                          ;
                        },
                      ),
                    ),
                ],
              ),
            )),
          ])),
      bottomNavigationBar: isLoading
          ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
          : BottomAppBar(
              height: 40 * ScaleSize.textScaleFactor(context),
              child: TextButton(
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Back'),
                // Text('Keranjang: ${param.enNumberFormat.format(totalItem = listBarangSelected.fold(0, (prev, item) => prev + (item.fdQty ?? 0))).toString()} items'),
              ),
            ),
    );
  }
}
