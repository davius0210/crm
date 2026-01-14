import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'limitkreditform_page.dart';
import 'main.dart';
import 'noo_invoice_page.dart';
import 'controller/order_cont.dart' as codr;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/stock_cont.dart' as cstk;
import 'controller/salesman_cont.dart' as csales;
import 'controller/log_cont.dart' as clog;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/order.dart' as modr;
import 'models/piutang.dart' as mpiu;
import 'models/stock.dart' as mstk;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

class NooCanvasSummaryForm extends StatefulWidget {
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String fdNoEntryOrder;
  final String routeName;
  final String startDayDate;
  final String endTimeVisit;
  final bool isEndDay;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;

  const NooCanvasSummaryForm(
      {super.key,
      required this.lgn,
      required this.user,
      required this.fdNoEntryOrder,
      required this.totalDiscount,
      required this.totalPesanan,
      required this.listKeranjang,
      required this.routeName,
      required this.isEndDay,
      required this.endTimeVisit,
      required this.startDayDate});

  @override
  State<NooCanvasSummaryForm> createState() => LayerNooCanvasSummaryForm();
}

class LayerNooCanvasSummaryForm extends State<NooCanvasSummaryForm> {
  bool isLoading = false;
  List<mnoo.NOO> langganans = [];
  List<modr.Order> listOrder = [];
  List<modr.OrderItem> listOrderItem = [];
  List<mpiu.Faktur> listFaktur = [];
  List<mpiu.FakturItem> listFakturItem = [];
  List<mpiu.SuratJalan> listSuratJalan = [];
  List<mpiu.SuratJalanItem> listSuratJalanItem = [];
  List<mpiu.SuratJalanItemDetail> listSuratJalanItemDetail = [];
  List<modr.Order> listGetDataOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mstk.StockItem> listStockItem = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mbrg.BarangSelected> tempBarangSelected = [];
  String? alamatSelected;
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
  int ppn = 0;
  double dblPPN = 0;
  String tanggalKirim = '';
  String noFaktur = '';
  bool isSaved = false;

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
      log('sum: ${widget.listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, fdQtyStock: ${item.fdQtyStock}, fdQtyStockK: ${item.fdQtyStockK}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');
      noFaktur =
          '${widget.user.fdKodeSF}-${DateFormat('yyMMddmmss').format(DateTime.now())}';
      final lparam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      ppn = lparam[0].fdPPN + 100;
      dblPPN = ppn / 100;
      isSaved = await codr.isSaveDraftPenjualan(widget.fdNoEntryOrder);
      if (isSaved) {
        listGetDataOrder =
            await codr.getDataOrderHeaderByNoEntry(widget.fdNoEntryOrder);
        alamatSelected = listGetDataOrder.first.fdAlamatKirim;
        tanggalKirim = listGetDataOrder.first.fdTanggalKirim!;
        txtTanggalKirim.text = param.dtFormatViewMMM.format(
            param.dtFormatDB.parse(listGetDataOrder.first.fdTanggalKirim!));
      } else {
        DateTime selectedDate = DateTime.now();
        tanggalKirim = DateFormat('yyyy-MM-dd').format(DateTime.now());
        txtTanggalKirim.text = DateFormat('dd MMM yyyy').format(selectedDate);
      }
      totalPromosiExtra = widget.listKeranjang
          .where((item) => item.fdPromosi == '1')
          .fold(0, (sum, item) => sum + (item.fdUnitPrice * item.fdQty));
      log('Total Promosi: $totalPromosiExtra');
      txtAlamatKirim.text = widget.lgn.fdAlamat!.trim();

      // listAlamatKirim = await clgn.getAllLanggananAlamat(widget.lgn.fdKodeNoo!);

      setState(() {
        limitKredit = widget.lgn.fdLimitKredit!;
        sisaLK = limitKredit - 0;
        //widget.totalPesanan;
        isLoading = false;
      });
      log('Total limitKredit: $limitKredit');
      log('Total sisaLK: $sisaLK');
      log('Total totalPesanan: ${widget.totalPesanan}');
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
                color: css.titleDialogColorGreen(),
                padding: const EdgeInsets.all(5),
                child: const Text('Transaksi Anda melebihi limit kredit')),
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
                        'Apakah Anda ingin melanjutkan dengan pembayaran penuh?')),
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await saveOrder();
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
                      // if (mounted) {
                      //   Navigator.pop(context);
                      // }
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
        if (widget.fdNoEntryOrder.isNotEmpty) {
          noEntry = widget.fdNoEntryOrder;
        } else {
          String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
          noEntry = tanggal;
        }
        totalDiskon = widget.totalDiscount + totalPromosiExtra;
        grandTotal =
            widget.totalPesanan - widget.totalDiscount - totalPromosiExtra;
      });

      listOrder = [
        modr.Order(
          fdDepo: widget.user.fdKodeDepo,
          fdKodeLangganan: widget.lgn.fdKodeNoo,
          fdTanggal: widget.startDayDate,
          fdNoEntryOrder: widget.fdNoEntryOrder,
          fdUnitPrice: 0, //item.fdUnitPrice,
          fdUnitPriceK: 0,
          fdDiscount: totalDiskon, //item.fdDiscount,
          fdTotal: grandTotal,
          fdTotalK: grandTotal,
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
          fdTanggalKirim: tanggalKirim,
          fdAlamatKirim: txtAlamatKirim.text,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        )
      ];
      List<modr.Order> header = listOrder.toList();

      var index = 0;
      listOrderItem = widget.listKeranjang.map((item) {
        return modr.OrderItem(
          fdNoEntryOrder: widget.fdNoEntryOrder,
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

      isSaved = await codr.isSaveDraftPenjualan(widget.fdNoEntryOrder);
      if (isSaved) {
        await codr.updateOrderBatch(header);
        await codr.updateOrderItemBatch(items);
      } else {
        await codr.insertOrderBatch(header);
        await codr.insertOrderItemBatch(items);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Draft penjualan tersimpan')));

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

  Future<void> updateStock() async {
    try {
      setState(() {
        isLoading = true;
      });

      var index = 0;
      Map<String, List<mbrg.BarangSelected>> listKeranjangTotal = {};

      for (var item in widget.listKeranjang) {
        listKeranjangTotal.putIfAbsent(item.fdKodeBarang, () => []);
        listKeranjangTotal[item.fdKodeBarang]!.add(item);
      }

      listStockItem = listKeranjangTotal.entries
          .where((entry) => entry.value.first.fdPromosi.toString() == '0')
          .map((entry) {
        var items = entry.value;
        var first = items.first;

        int totalQtyStockK = items.fold(0, (sum, x) {
          return sum +
              ((double.tryParse(x.fdQtyStockK?.toString() ?? '0')?.toInt() ??
                      0) -
                  (double.tryParse(x.fdQtyK?.toString() ?? '0')?.toInt() ?? 0));
        });
        return mstk.StockItem(
          fdNoEntryStock: widget.fdNoEntryOrder,
          fdNoUrutStock: index++,
          fdKodeBarang: first.fdKodeBarang,
          fdNamaBarang: first.fdNamaBarang,
          fdPromosi: first.fdPromosi.toString(),
          fdReplacement: '',
          fdJenisSatuan: first.fdJenisSatuan.toString(),
          fdQtyStock: 0,
          fdQtyStockK: totalQtyStockK,
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
          isHanger: first.isHanger,
          isShow: first.isShow,
          urut: first.urut,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<mstk.StockItem> items = listStockItem.toList();

      await cstk.kurangiStockItemSumBatch(items);

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

  Future<void> saveFaktur() async {
    try {
      setState(() {
        isLoading = true;
      });

      listFaktur = [
        mpiu.Faktur(
          fdNoEntryFaktur: widget.fdNoEntryOrder,
          fdDepo: widget.user.fdKodeDepo,
          fdJenisFaktur: widget.user.fdTipeSF,
          fdNoFaktur: noFaktur,
          fdNoOrder: '',
          fdTanggalOrder: widget.startDayDate,
          fdTanggalKirim: tanggalKirim,
          isTagihan: 0,
          fdTanggalFaktur: widget.startDayDate,
          fdTOP: '',
          fdTanggalJT: '',
          fdKodeLangganan: widget.lgn.fdKodeNoo,
          fdNoEntryProforma: '',
          fdFPajak: '',
          fdPPH: '',
          fdKeterangan: '',
          fdMataUang: 'IDR',
          fdKodeSF: widget.user.fdKodeSF,
          fdKodeAP1: '',
          fdKodeAP2: '',
          fdReasonNotApprove: 0,
          fdDisetujuiOleh: '',
          fdKodeStatus: 0,
          fdTglStatus: '',
          fdKodeGudang: widget.user.fdKodeDepo,
          fdNoOrderSFA: widget.fdNoEntryOrder,
          fdTglSFA: widget.startDayDate,
          fdStatusRecord: 0,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        )
      ];
      List<mpiu.Faktur> header = listFaktur.toList();

      double iTotalPrice = 0;
      double iNetto = 0;
      var index = 1;
      listFakturItem = widget.listKeranjang.map((item) {
        iTotalPrice = double.parse(item.fdTotalPrice.toStringAsFixed(2));
        iNetto = iTotalPrice - item.fdDiscount;
        return mpiu.FakturItem(
          fdNoEntryFaktur: widget.fdNoEntryOrder,
          fdNoUrutFaktur: index++,
          fdNoEntrySJ: '',
          fdNoUrutSJ: 0,
          fdNoEntryProforma: '',
          fdNoUrutProforma: 0,
          fdKodeBarang: item.fdKodeBarang,
          fdPromosi: item.fdPromosi.toString(),
          fdReplacement: 0,
          fdJenisSatuan: item.fdJenisSatuan.toString(),
          fdQty: (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          fdQtyK:
              (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          fdHargaAsli: item.fdHargaAsli,
          fdUnitPrice: item.fdUnitPrice,
          fdUnitPriceK: item.fdUnitPriceK,
          fdBrutto: item.fdTotalPrice,
          fdDiscount: item.fdDiscount,
          fdDiscountDetail: item.fdDiscountDetail ?? '',
          fdNetto: iNetto,
          fdDPP: (double.parse((iNetto).toString()) /
                  (double.parse(dblPPN.toString()) * 1.0))
              .floorToDouble(), //((item.fdTotalPrice * 1.0) / (dblPPN * 1.0)).floor(),
          // fdPPN: item.fdTotalPrice -
          //     ((item.fdTotalPrice - item.fdDiscount) /
          //         (dblPPN * 1.0)), // bruto -DPP
          fdPPN: (item.fdTotalPrice -
              ((double.parse(item.fdTotalPrice.toString()) /
                      (double.parse(dblPPN.toString()) * 1.0)))
                  .floorToDouble()),
          fdNoPromosi: '',
          fdStatusRecord: 0,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<mpiu.FakturItem> items = listFakturItem.toList();

      isSaved = await cpiu.isSaveFaktur(widget.fdNoEntryOrder);
      if (isSaved) {
        // await cpiu.updateFakturBatch(header);
        // await cpiu.updateFakturItemBatch(items);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sudah ada faktur')));
      } else {
        await cpiu.insertFakturBatch(header);
        await cpiu.insertFakturItemBatch(items);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Faktur tersimpan')));
      }

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

  Future<void> saveSuratJalan() async {
    try {
      setState(() {
        isLoading = true;
      });

      listSuratJalan = [
        mpiu.SuratJalan(
          fdNoEntrySJ: widget.fdNoEntryOrder,
          fdDepo: widget.user.fdKodeDepo,
          fdJenisSJ: widget.user.fdTipeSF,
          fdNoSJ: noFaktur,
          fdTanggalSJ: widget.startDayDate,
          fdKodeLangganan: widget.lgn.fdKodeNoo,
          fdKodeSF: widget.user.fdKodeSF,
          fdKodeAP1: '',
          fdKodeAP2: '',
          fdKodeGudang: widget.user.fdKodeDepo,
          fdKodeGudangTujuan: '',
          fdNoEntryProforma: '',
          fdAlamatKirim: txtAlamatKirim.text,
          fdKeterangan: 'CRM CANVAS',
          fdNoPolisi: '',
          fdKodeEkspedisi: '0',
          fdSupirNama: '',
          fdSupirKTP: '',
          fdArmada: '',
          fdETD: '',
          fdETA: '',
          fdNoContainer: '',
          fdNoSeal: '',
          fdAktTglKirim: '',
          fdAktTglTiba: '',
          fdAktTglSerah: '',
          fdKeteranganPengiriman: '',
          fdIsFaktur: '',
          fdKodeStatus: 0,
          fdTglStatus: '',
          fdStatusRecord: 0,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        )
      ];
      List<mpiu.SuratJalan> header = listSuratJalan.toList();

      var index = 1;
      var indexOrder = 1;
      listSuratJalanItem = widget.listKeranjang.map((item) {
        return mpiu.SuratJalanItem(
          fdNoEntrySJ: widget.fdNoEntryOrder,
          fdNoUrutSJ: index++,
          fdNoEntryOrder: widget.fdNoEntryOrder,
          fdNoUrutOrder: indexOrder++,
          fdNoEntryProforma: '',
          fdNoUrutProforma: 0,
          fdKodeBarang: item.fdKodeBarang,
          fdPromosi: item.fdPromosi.toString(),
          fdReplacement: 0,
          fdJenisSatuan: item.fdJenisSatuan.toString(),
          fdQty: (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          fdQtyK:
              (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          fdPalet: 0,
          fdDetailPalet: '',
          fdNetWeight: 0,
          fdGrossWeight: 0,
          fdVolume: 0,
          fdNotes: '',
          fdCartonNo: '',
          fdQtyJual:
              (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          fdRusakB: 0,
          fdRusakS: 0,
          fdRusakK: 0,
          fdSisaB: 0,
          fdSisaS: 0,
          fdSisaK: 0,
          fdStatusRecord: 0,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<mpiu.SuratJalanItem> items = listSuratJalanItem.toList();

      index = 1;
      listSuratJalanItemDetail = widget.listKeranjang.map((item) {
        return mpiu.SuratJalanItemDetail(
          fdNoEntrySJ: widget.fdNoEntryOrder,
          fdNoUrutSJ: index++,
          fdKodeBarang: item.fdKodeBarang,
          fdDateCode: '',
          fdPromosi: item.fdPromosi.toString(),
          fdJenisSatuan: item.fdJenisSatuan.toString(),
          fdQty: (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          fdQtyK:
              (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          fdStatusRecord: 0,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<mpiu.SuratJalanItemDetail> details =
          listSuratJalanItemDetail.toList();

      isSaved = await cpiu.isSaveSuratJalan(widget.fdNoEntryOrder);
      if (isSaved) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sudah ada surat jalan')));
      } else {
        await cpiu.insertSuratJalanBatch(header);
        await cpiu.insertSuratJalanItemBatch(items);
        await cpiu.insertSuratJalanItemDetailBatch(details);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Surat Jalan tersimpan')));
      }

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

  void dialogGenerateInvoice() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColorGreen(),
              padding: const EdgeInsets.all(5),
              child: const Text('Generate Invoice')),
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
                      'Cek transaksi sudah sesuai.\nApakah Anda ingin generate invoice?')),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (sisaLK < widget.totalPesanan) {
                      _confirmLimitKredit(widget.lgn.fdKodeNoo!);
                    } else {
                      await saveOrder();
                      await updateStock();
                      await saveFaktur();
                      await saveSuratJalan();
                      if (!mounted) return;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NooInvoicePage(
                                  user: widget.user,
                                  lgn: widget.lgn,
                                  noentry: widget.fdNoEntryOrder,
                                  navpage: '',
                                  isEndDay: widget.isEndDay,
                                  startDayDate: widget.startDayDate,
                                  endTimeVisit: widget.endTimeVisit,
                                  routeName: 'NooInvoicePage',
                                  alamatSelected: alamatSelected,
                                  orderExist: orderExist,
                                  totalPromosiExtra: totalPromosiExtra,
                                  totalDiscount: widget.totalDiscount,
                                  totalPesanan: widget.totalPesanan,
                                  listKeranjang: widget.listKeranjang,
                                  noFaktur: noFaktur,
                                  txtTanggalKirim: txtTanggalKirim.text)));
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
                child: const Text('Tidak'))
          ],
        );
      }),
    );
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
        title: const Text('Summary Penjualan'),
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: const Text(
                                          'POTONGAN',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      Text(
                                        'Rp. ${param.enNumberFormat.format(barang.fdDiscount).toString()}',
                                        style:
                                            TextStyle(color: Colors.redAccent),
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
                              enabled: false,
                              decoration: css.textInputStyle(
                                'Tanggal Kirim',
                                const TextStyle(fontStyle: FontStyle.italic),
                                'Tanggal Kirim',
                                null,
                                null,
                              ),
                              onTap: () async {
                                stateTanggalKirim = txtTanggalKirim;
                                print(stateTanggalKirim);
                                print(stateTanggalKirim.text);
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
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              'Limit Kredit: Rp. ${param.enNumberFormat.format(limitKredit).toString()}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 196, 43, 43),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              'Sisa Limit Kredit: Rp. ${param.enNumberFormat.format(sisaLK).toString()}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 196, 43, 43),
                                  fontWeight: FontWeight.bold),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (txtAlamatKirim.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Alamat Kirim tidak boleh kosong!'),
                              ));
                              return;
                            }
                            if (txtTanggalKirim.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Tanggal Kirim tidak boleh kosong!'),
                              ));
                              return;
                            }
                            if (formInputKey.currentState!.validate()) {
                              if (sisaLK < widget.totalPesanan) {
                                _confirmLimitKredit(widget.lgn.fdKodeNoo!);
                              } else {
                                await saveOrder();
                              }
                            }
                          },
                          child: const Text('Simpan Draft'),
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            dialogGenerateInvoice();
                            // if (formInputKey.currentState!.validate()) {
                            //   grandTotal = widget.totalPesanan -
                            //       widget.totalDiscount -
                            //       totalPromosiExtra +
                            //       orderExist;
                            //   yesNoDialogForm(0);
                            // }
                          },
                          child: const Text('Generate Invoice'),
                        ),
                      ),
                    ],
                  ),
                )
              : const Text(''),
    );
  }
}
