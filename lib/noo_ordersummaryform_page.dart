import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'limitkreditform_page.dart';
import 'noo_page.dart';
import 'main.dart';
import 'controller/barang_cont.dart' as cbrg;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/promo_cont.dart' as cpro;
import 'controller/salesman_cont.dart' as csales;
import 'models/langganan.dart' as mlgn;
import 'models/noo.dart' as mnoo;
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

class NooOrderSummaryForm extends StatefulWidget {
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String fdNoEntryOrder;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;

  const NooOrderSummaryForm(
      {super.key,
      required this.lgn,
      required this.user,
      required this.fdNoEntryOrder,
      required this.totalDiscount,
      required this.totalPesanan,
      required this.listKeranjang,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<NooOrderSummaryForm> createState() => LayerNooOrderSummaryForm();
}

class LayerNooOrderSummaryForm extends State<NooOrderSummaryForm> {
  bool isLoading = false;
  List<modr.Order> listOrder = [];
  List<modr.OrderItem> listOrderItem = [];
  List<modr.Order> listGetDataOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mbrg.BarangSelected> tempBarangSelected = [];
  String? satuanSelected;

  // mlgn.Langganan? barangSelected;
  TextEditingController txtAlamatKirim = TextEditingController();
  TextEditingController txtTanggalKirim = TextEditingController();
  TextEditingController stateTanggalKirim = TextEditingController();
  TextEditingController txtSisaOrder = TextEditingController();
  TextEditingController txtPesananBaru = TextEditingController();
  TextEditingController txtOverOrder = TextEditingController();
  TextEditingController txtPengajuanBaruLK = TextEditingController();
  Map<String, TextEditingController> textQtyControllers = {};
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  double limitKredit = 0;
  double totalPromosiExtra = 0;
  String noEntry = '';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initLoadPage();

    // String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
    // noEntry = tanggal;

    super.initState();
    for (int index = 0; index < widget.listKeranjang.length; index++) {
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
      log('sum: ${widget.listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');

      if (widget.fdNoEntryOrder.isNotEmpty) {
        listGetDataOrder =
            await codr.getDataOrderHeaderByNoEntry(widget.fdNoEntryOrder);
        txtTanggalKirim.text = param.dtFormatViewMMM.format(
            param.dtFormatDB.parse(listGetDataOrder.first.fdTanggalKirim!));
      }
      totalPromosiExtra = widget.listKeranjang
          .where((item) => item.fdPromosi == '1')
          .fold(0, (sum, item) => sum + (item.fdUnitPrice * item.fdQty));
      log('Total Promosi: $totalPromosiExtra');
      txtAlamatKirim.text = widget.lgn.fdAlamat!.trim();

      // listAlamatKirim = await clgn.getAllLanggananAlamat(widget.lgn.fdKodeNoo!);
      // langganans =
      //     await clgn.getLanggananByKodeLangganan(widget.lgn.fdKodeNoo!);

      setState(() {
        limitKredit = widget.lgn.fdLimitKredit!;
        sisaLK = limitKredit - widget.totalPesanan;
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

  Future<void> _confirmLimitKredit(String fdKodeGroup) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Container(
                color: css.titleDialogColor(),
                padding: const EdgeInsets.all(5),
                child: const Text(
                    'Pesanan Toko melebihi limit kredit. Apakah tetap ingin mengajukan approval Limit Kredit?')),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await saveOrder();
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: 'LimitKreditForm'),
                              builder: (context) => LimitKreditFormPage(
                                  kodeLangganan: widget.lgn.fdKodeNoo!,
                                  user: widget.user,
                                  isEndDay: widget.isEndDay,
                                  routeName: 'LimitKreditForm',
                                  startDayDate: widget.startDayDate))).then(
                          (value) {
                        initLoadPage();

                        setState(() {});
                      });
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    }
                  },
                  child: const Text('Ya')),
              ElevatedButton(
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('error: $e')));
                    }
                  },
                  child: const Text('Tidak'))
            ]);
      },
    );
  }

  Future<void> saveOrder() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.fdNoEntryOrder.isNotEmpty) {
        noEntry = widget.fdNoEntryOrder;
      } else {
        String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
        noEntry = tanggal;
      }
      listOrder = [
        modr.Order(
          fdDepo: widget.user.fdKodeDepo,
          fdKodeLangganan: widget.lgn.fdKodeNoo,
          fdTanggal: widget.startDayDate,
          fdNoEntryOrder: noEntry,
          fdUnitPrice: 0, //item.fdUnitPrice,
          fdUnitPriceK: 0,
          fdDiscount: widget.totalDiscount, //item.fdDiscount,
          fdTotal: widget.totalPesanan,
          fdTotalK: widget.totalPesanan,
          // fdQty: widget.listKeranjang
          //     .fold(0, (prev, item) => prev + ((item.fdQty ?? 0) as int)),
          // fdQtyK: widget.listKeranjang
          //     .fold(0, (prev, item) => prev + ((item.fdQtyK ?? 0) as int)),
          fdQty: widget.listKeranjang.fold(
            0,
            (prev, item) =>
                prev +
                (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          ),
          fdQtyK: widget.listKeranjang.fold(
            0,
            (prev, item) =>
                prev +
                (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          ),
          fdTotalOrder: widget.totalPesanan,
          fdTotalOrderK: widget.totalPesanan,
          fdJenisSatuan: '', //item.fdSatuan,
          fdTanggalKirim: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd MMM yyyy').parse(txtTanggalKirim.text)),
          fdAlamatKirim: txtAlamatKirim.text,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        )
      ];
      List<modr.Order> header = listOrder.toList();

      var index = 0;
      listOrderItem = widget.listKeranjang.map((item) {
        return modr.OrderItem(
          fdNoEntryOrder: noEntry,
          fdNoUrutOrder: index++,
          fdKodeBarang: item.fdKodeBarang,
          fdNamaBarang: item.fdNamaBarang,
          fdPromosi: item.fdPromosi.toString(),
          fdReplacement: '',
          fdJenisSatuan: item.fdJenisSatuan.toString(),
          // fdQty: item.fdQty,
          // fdQtyK: item.fdQtyK,
          fdQty: (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ??
              0), //item.fdQty,
          fdQtyK:
              (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          fdUnitPrice: item.fdUnitPrice,
          fdUnitPriceK: item.fdUnitPriceK,
          fdBrutto: item.fdTotalPrice,
          fdDiscount: item.fdDiscount, //widget.totalDiscount,
          fdDiscountDetail:
              item.fdDiscountDetail ?? '', //item.fdPromosi.toDouble(),
          fdNetto: item.fdTotalPrice - item.fdDiscount,
          fdNoPromosi: '',
          fdNotes: '',
          fdQtyPBE: 0,
          fdQtySJ: 0,
          isHanger: item.isHanger,
          isShow: item.isShow,
          jnItem: item.jnItem,
          urut: item.urut,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<modr.OrderItem> items = listOrderItem.toList();

      if (widget.fdNoEntryOrder.isNotEmpty) {
        await codr.updateOrderBatch(header);
        await codr.updateOrderItemBatch(items);
      } else {
        await codr.insertOrderBatch(header);
        await codr.insertOrderItemBatch(items);
      }

      //UPDATE end date ny
      await csales.endVisitSFActivity(
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          param.dateTimeFormatDB.format(DateTime.now()),
          '03',
          widget.lgn.fdKodeNoo!);

      if (!mounted) return;
      Navigator.popUntil(context, ModalRoute.withName('noo'));
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         settings: const RouteSettings(name: 'noo'),
      //         builder: (context) => NOOPage(
      //             user: widget.user,
      //             routeName: 'noo',
      //             isEndDay: widget.isEndDay,
      //             startDayDate: widget.startDayDate)),
      //     (Route<dynamic> route) => false).then((value) {
      //   initLoadPage();

      //   setState(() {});
      // });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
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
          : param.dtFormatViewMMM.parse(txtEdit.text), //get today's date
      firstDate: DateTime(DateTime.now()
          .year), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2060),
    );

    if (selectDate != null) {
      setState(() {
        txtEdit.text = param.dtFormatViewMMM.format(selectDate);
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
        title: const Text('Summary'),
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
              child: Text('${widget.lgn.fdKodeNoo} - ${widget.lgn.fdNamaToko}',
                  style: css.textHeaderBold())),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    if (widget.listKeranjang.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.listKeranjang.length,
                        itemBuilder: (context, index) {
                          final barang = widget.listKeranjang[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama barang
                                Text(
                                  barang.fdNamaBarang.trim() ?? '',
                                  style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      color: widget.listKeranjang[index]
                                                  .fdPromosi ==
                                              '0'
                                          ? Colors.black
                                          : Colors.green[700]),
                                ),

                                const SizedBox(height: 4),

                                // Qty x Harga = Total
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        '${param.enNumberFormatQty.format(widget.listKeranjang[index].fdQty)} ${widget.listKeranjang[index].fdNamaJenisSatuan!} x Rp. ${param.enNumberFormat.format(barang.fdUnitPrice).toString()}',
                                        style: TextStyle(
                                            color: widget.listKeranjang[index]
                                                        .fdPromosi ==
                                                    '0'
                                                ? Colors.black
                                                : Colors.green[700]),
                                      ),
                                    ),
                                    Text(
                                      'Rp. ${param.enNumberFormat.format(barang.fdUnitPrice * barang.fdQty).toString()}',
                                      style: TextStyle(
                                          color: widget.listKeranjang[index]
                                                      .fdPromosi ==
                                                  '0'
                                              ? Colors.black
                                              : Colors.green[700]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),

                                // Diskon
                                if (barang.fdDiscount > 0)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'POTONGAN',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      Text(
                                        'Rp. ${param.enNumberFormat.format(barang.fdDiscount).toString()}',
                                        style: const TextStyle(
                                            color: Colors.redAccent),
                                      ),
                                    ],
                                  ),

                                // const Divider(thickness: 1),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 3,
                              child: Text('Total Pesanan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(''),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                  'Rp. ${param.enNumberFormat.format(widget.totalPesanan).toString()}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 3,
                              child: Text('Total Potongan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(''),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                  'Rp. ${param.enNumberFormat.format(widget.totalDiscount + totalPromosiExtra).toString()}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Row(children: [
                        Text(
                          '**Harga dan diskon tidak mengikat dan dapat berubah sewaktu-waktu',
                          style: TextStyle(
                              fontSize: 8,
                              fontStyle: FontStyle.italic,
                              color: Colors.red),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 3,
                              child: Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(''),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                  'Rp. ${param.enNumberFormat.format(widget.totalPesanan - widget.totalDiscount - totalPromosiExtra).toString()}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text('Shipping',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 2, color: Colors.orange),
                    const Padding(padding: EdgeInsets.all(5)),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtAlamatKirim,
                        readOnly: true,
                        enabled: false,
                        decoration: css.textInputStyle(
                          'Alamat Kirim',
                          const TextStyle(fontStyle: FontStyle.italic),
                          'Alamat Kirim',
                          null,
                          null,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: txtTanggalKirim,
                              readOnly: true,
                              decoration: css.textInputStyle(
                                'Tanggal Kirim',
                                const TextStyle(fontStyle: FontStyle.italic),
                                'Tanggal Kirim',
                                null,
                                null,
                              ),
                              onTap: () async {
                                stateTanggalKirim = txtTanggalKirim;
                                await showCalendar(stateTanggalKirim);
                                if (txtTanggalKirim.text.isNotEmpty) {
                                  DateTime selectedDate = param.dtFormatViewMMM
                                      .parse(txtTanggalKirim.text);
                                  txtTanggalKirim.text =
                                      DateFormat('dd MMM yyyy')
                                          .format(selectedDate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
          : !widget.isEndDay
              ? BottomAppBar(
                  height: 40 * ScaleSize.textScaleFactor(context),
                  child: TextButton(
                    onPressed: () async {
                      if (txtAlamatKirim.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Alamat Kirim tidak boleh kosong!'),
                        ));
                        return;
                      }
                      if (txtTanggalKirim.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Tanggal Kirim tidak boleh kosong!'),
                        ));
                        return;
                      }
                      if (formInputKey.currentState!.validate()) {
                        // if (sisaLK < widget.totalPesanan) {
                        //   _confirmLimitKredit(widget.lgn.fdKodeNoo!);
                        // } else {
                        await saveOrder();
                        // }
                      }
                    },
                    child: const Text('Buat Pesanan'),
                  ),
                )
              : const Text(''),
    );
  }
}
