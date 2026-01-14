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
import 'ordersummaryform_page.dart';
import 'main.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/promo_cont.dart' as cpro;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/order.dart' as modr;
import 'models/promo.dart' as mpro;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

List<MultiSelectItem> listSatuan = [
  MultiSelectItem(0, 'Kecil'),
  MultiSelectItem(1, 'Sedang'),
  MultiSelectItem(2, 'Besar'),
];

class OrderCartForm extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String fdNoEntryOrder;
  final String routeName;
  final String startDayDate;
  final String endTimeVisit;
  final String fdKodeHarga;
  final bool isEndDay;
  final int totalItem;
  final List listKeranjang;

  const OrderCartForm(
      {super.key,
      required this.fdNoEntryOrder,
      required this.lgn,
      required this.user,
      required this.totalItem,
      required this.listKeranjang,
      required this.fdKodeHarga,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate,
      required this.endTimeVisit});

  @override
  State<OrderCartForm> createState() => LayerOrderCartForm();
}

class LayerOrderCartForm extends State<OrderCartForm> {
  bool isLoading = false;
  List<mlgn.Langganan> langganans = [];
  List<modr.Order> listOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mbrg.JsonBarangDiskon> JsonBarangDiskon = [];
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
  double totalPesanan = 0;
  double totalDiscount = 0;
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
    for (int index = 0; index < widget.listKeranjang.length; index++) {
      totalPesanan += widget.listKeranjang[index].fdTotalPrice;
      // if (widget.listKeranjang[index].fdPromosi == '0') {
      //   totalPesanan += widget.listKeranjang[index].fdTotalPrice;
      // } else {
      //   totalPesanan += 0;
      // }
      totalDiscount += 0;
      //widget.listKeranjang[index].fdPromosi;
      var barang = widget.listKeranjang[index];
      textQtyControllers[barang.fdKodeBarang.trim()] =
          TextEditingController(text: barang.fdQty.toString());
    }
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      log('getdata: ${widget.listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');

      // listBarang = await cbrg.getAllBarang('');
      fdKodeHarga = await cbrg.getKodeHarga(widget.lgn.fdKodeLangganan!);
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

  Future<bool> saveOrder() async {
    try {
      // if (listBarangSelected.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Belum ada list barang')));
      //   return false;
      // }
      // for (var barang in listBarangSelected) {
      //   if (barang.fdSatuan != 0 &&
      //       barang.fdSatuan != 1 &&
      //       barang.fdSatuan != 2) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content:
      //             Text('Satuan barang ${barang.fdNamaBarang} harus dipilih')));
      //     return false;
      //   }
      //   if (barang.fdQty == null) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text(
      //             'Quantity barang ${barang.fdNamaBarang} tidak boleh kosong')));
      //     return false;
      //   }
      //   if (barang.fdQty! < 1) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text(
      //             'Quantity barang ${barang.fdNamaBarang} tidak boleh kosong')));
      //     return false;
      //   }
      // }
      setState(() {
        isLoading = true;
        // listKeranjang = listBarangSelected.map((barang) {
        //   return mbrg.BarangSelected(
        //     fdKodeBarang: barang.fdKodeBarang,
        //     fdNamaBarang: barang.fdNamaBarang,
        //     fdQty: barang.fdQty,
        //     fdSatuan: barang.fdSatuan,
        //     fdPromosi: barang.fdPromosi,
        //     fdUnitPrice: barang.fdUnitPrice,
        //     fdTotalPrice: 0, // barang.fdTotalPrice,
        //   );
        // }).toList();
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
        title: const Text('Keranjang Pesanan'),
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
                  if (widget.listKeranjang.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.listKeranjang.length,
                        itemBuilder: (context, index) {
                          final barang = widget.listKeranjang[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(barang.fdNamaBarang.trim(),
                                      style: TextStyle(
                                          color: widget.listKeranjang[index]
                                                      .fdPromosi ==
                                                  '0'
                                              ? Colors.black
                                              : Colors.green[700])),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        param.enNumberFormatQty
                                            .format(barang.fdQty)
                                            .toString(),
                                        style: TextStyle(
                                            color: widget.listKeranjang[index]
                                                        .fdPromosi ==
                                                    '0'
                                                ? Colors.black
                                                : Colors.green[700])),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        widget.listKeranjang[index]
                                            .fdNamaJenisSatuan!,
                                        style: TextStyle(
                                            color: widget.listKeranjang[index]
                                                        .fdPromosi ==
                                                    '0'
                                                ? Colors.black
                                                : Colors.green[700])),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                          'Rp. ${param.enNumberFormat.format(barang.fdUnitPrice).toString()}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: widget.listKeranjang[index]
                                                          .fdPromosi ==
                                                      '0'
                                                  ? Colors.black
                                                  : Colors.green[700])),
                                    )),
                              ],
                            ),
                          );
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
                  checkSave = await saveOrder();

                  JsonBarangDiskon = await capi.getDataDiskonBarang(
                      widget.user.fdToken,
                      widget.lgn.fdKodeLangganan!,
                      fdKodeHarga,
                      widget.user.fdKodeDepo,
                      widget.user.fdKodeSF,
                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      widget.listKeranjang.cast<mbrg.BarangSelected>());
                  log('data: ${JsonBarangDiskon.map((item) => '(${item.fdDiscount} )').toList()}');
                  totalDiscount =
                      JsonBarangDiskon.map((item) => item.fdDiscount)
                          .reduce((a, b) => a + b);
                  print(totalDiscount);
                  log('data: ${widget.listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan})').toList()}');
                  if (checkSave) {
                    if (!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings:
                                const RouteSettings(name: 'OrderSummaryForm'),
                            builder: (context) => OrderSummaryForm(
                                fdNoEntryOrder: widget.fdNoEntryOrder,
                                lgn: widget.lgn,
                                user: widget.user,
                                totalPesanan: totalPesanan,
                                totalDiscount: totalDiscount,
                                listKeranjang: widget.listKeranjang,
                                isEndDay: widget.isEndDay,
                                endTimeVisit: widget.endTimeVisit,
                                routeName: 'OrderCartForm',
                                startDayDate: widget.startDayDate))).then(
                        (value) {
                      log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                    });
                  }
                },
                child: const Text('Next'),
                //  Text('Summary Pesanan: ${param.enNumberFormat.format(widget.totalItem).toString()} items Rp. ${param.enNumberFormat.format(totalPesanan).toString()}' ),
              ),
            ),
    );
  }
}
