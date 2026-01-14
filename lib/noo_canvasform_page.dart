import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'noo_canvassummaryform_page.dart';
import 'main.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/order.dart' as modr;
import 'models/globalparam.dart' as param;
import 'models/logdevice.dart' as mlog;
import 'style/css.dart' as css;

class NooCanvasFormPage extends StatefulWidget {
  final String fdNoEntryOrder;
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;
  final String endTimeVisit;

  const NooCanvasFormPage(
      {super.key,
      required this.fdNoEntryOrder,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.endTimeVisit,
      required this.startDayDate});

  @override
  State<NooCanvasFormPage> createState() => LayerNooOrderForm();
}

class LayerNooOrderForm extends State<NooCanvasFormPage> {
  bool isLoading = false;
  List<mnoo.NOO> langganans = [];
  List<modr.Order> listOrder = [];
  List<mbrg.BarangStock> listBarangStock = [];
  List<mbrg.Satuan> listSatuan = [];
  List<mbrg.BarangSelected> listBarangSelected = [];
  List<mbrg.BarangSelected> tempBarangSelected = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mbrg.BarangSelected> listKeranjangJson = [];
  List<mlog.Param> listParam = [];
  List<mbrg.BarangSelected> fBarangExtra = [];
  List<mbrg.JsonBarangDiskon> JsonBarangDiskon = [];

  Map<String, List<mbrg.Satuan>> satuanPerBarang = {};
  Map<String, String?> satuanSelectedPerBarang = {};
  List<Map<String, dynamic>> konversiSatuanBarang = [];

  String? barangSelected;
  String? satuanSelected;
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
  double totalDiscount = 0;
  double totalPesanan = 0;
  double totalItem = 0;
  double? qty = 0;
  bool checkSave = false;
  bool stockCukup = true;
  String fdKodeHarga = '';
  double qtyGenapS = 0;
  double qtyGenapK = 0;
  double hargaSatuan = 0;
  String satuanOrderS = '';
  String satuanOrderK = '';
  String noEntry = '';
  String lkodeHarga = '';
  int isDecimal = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initLoadPage();
    if (widget.fdNoEntryOrder.isNotEmpty) {
      noEntry = widget.fdNoEntryOrder;
    } else {
      if (noEntry == '') {
        String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
        noEntry = tanggal;
      }
    }
    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
        totalDiscount = 0;
        totalPesanan = 0;
        isDecimal = 0;
      });
      listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      if (widget.lgn.fdKelasOutlet == '1') {
        fdKodeHarga = await cbrg.getKodeHargaByKelasOutlet('1');
      } else {
        fdKodeHarga = await cbrg.getKodeHargaByKelasOutlet('2');
      }
      listBarangStock = await cbrg.getAllBarangNooStockCarry(
          fdKodeHarga, widget.user.fdKodeSF);
      langganans = await cnoo.getAllNOObyfdKodeNoo(widget.lgn.fdKodeNoo!);
      lkodeHarga = langganans.first.fdKelasOutlet! == '1' ? 'VG' : 'RI';
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

  Widget createTextFormField(String fdKodeBarang) {
    String key = fdKodeBarang;
    String value = '';

    if (listOrder.isNotEmpty) {
      List<modr.Order> items =
          listOrder.where((element) => element.fdKodeLangganan == key).toList();

      if (items.isNotEmpty) {
        value = param.idNumberFormat.format(items.first.fdAlamatKirim);
      }
    }

    TextEditingController txtEdit = TextEditingController(text: value);
    textQtyControllers.putIfAbsent(key, () => txtEdit);

    return TextFormField(
      autocorrect: false,
      controller: textQtyControllers[key],
      decoration: css.textInputNoBorderStyle('Sell Out',
          const TextStyle(fontStyle: FontStyle.italic), 'Sell Out', null, null),
      maxLength: 13,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        cother.ThousandsSeparatorInputFormatter()
      ],
    );
  }

  Future<bool> saveOrder() async {
    try {
      setState(() {
        isDecimal = 0;
        stockCukup = true;
      });
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
        print(listBarangSelected);
      });

      tempBarangSelected.clear();
      tempBarangSelected = listBarangSelected.map((barang) {
        return mbrg.BarangSelected(
          fdKodeBarang: barang.fdKodeBarang,
          fdNamaBarang: barang.fdNamaBarang,
          fdQty: barang.fdQty,
          fdQtyK: 0,
          fdJenisSatuan: barang.fdJenisSatuan,
          fdNamaJenisSatuan: barang.fdNamaJenisSatuan,
          fdPromosi: barang.fdPromosi,
          fdHargaAsli: barang.fdHargaAsli,
          fdUnitPrice: barang.fdUnitPrice,
          fdUnitPriceK: barang.fdUnitPriceK,
          fdTotalPrice: barang.fdQty! * barang.fdUnitPrice!.toDouble(),
          fdTotalPriceK: 0,
          fdKonvB_S: barang.fdKonvB_S,
          fdKonvS_K: barang.fdKonvS_K,
          fdQtyStock: barang.fdQtyStock,
          fdQtyStockK: barang.fdQtyStockK,
          isHanger: barang.isHanger,
          isShow: barang.isShow,
          jnItem: barang.jnItem,
          urut: barang.urut,
        );
      }).toList();

      for (var barang in tempBarangSelected) {
        qtyGenapS = 0;
        qtyGenapK = 0;
        if (barang.fdQty != null && barang.fdQty! % 1 != 0) {
          if (barang.fdJenisSatuan == 2) {
            satuanOrderS = '1';
            qtyGenapS = barang.fdQty! * barang.fdKonvB_S!;

            satuanOrderK = '0';
            qtyGenapK = qtyGenapS * barang.fdKonvS_K!;
            if (qtyGenapS % 1 != 0) {
              setState(() {
                isDecimal = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Qty ${barang.fdNamaBarang} tidak boleh desimal'),
              ));
              setState(() {
                isLoading = false;
              });
              return false;
            } else {
              double unitPrice = 0;
              double unitPriceK = 0;
              double hargaAsli = 0;
              barang.fdQty = qtyGenapS;
              barang.fdQtyK = qtyGenapK;
              hargaAsli = await cbrg.getHargaAsliByFdKodeBarangNOO(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(satuanOrderS),
                  lkodeHarga,
                  '0',
                  barang.isHanger!);
              unitPrice = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(satuanOrderS),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  barang.isHanger!);
              unitPriceK = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(satuanOrderK),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  '0');
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanOrder
              // final satuanOrderKode = listDecimal['satuanOrder'].toString();
              final satuanOrderKode = satuanOrderS.toString();
              final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              final satuanMatch = satuanList.firstWhere(
                (s) => s.fdKodeSatuan.toString() == satuanOrderKode,
                orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              );
              barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              barang.fdJenisSatuan =
                  int.tryParse(satuanOrderS.toString()) ?? barang.fdJenisSatuan;

              barang.fdHargaAsli = hargaAsli;
              barang.fdUnitPrice = unitPrice;
              barang.fdUnitPriceK = unitPriceK;
              barang.fdTotalPriceK =
                  barang.fdQtyK! * barang.fdUnitPriceK!.toDouble();
            }
          } else {
            setState(() {
              isDecimal = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Qty ${barang.fdNamaBarang} tidak boleh desimal'),
            ));
            setState(() {
              isLoading = false;
            });
            return false;
          }
        } else {
          if (barang.fdJenisSatuan == 2) {
            satuanOrderS = '1';
            qtyGenapS = barang.fdQty! * barang.fdKonvB_S!;

            satuanOrderK = '0';
            qtyGenapK = qtyGenapS * barang.fdKonvS_K!;

            if (qtyGenapS % 1 != 0) {
              setState(() {
                isDecimal = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Qty ${barang.fdNamaBarang} tidak boleh desimal'),
              ));
              setState(() {
                isLoading = false;
              });
              return false;
            } else {
              String satuanAwal = barang.fdJenisSatuan.toString();
              double hargaAsli = 0;
              double unitPrice = 0;
              double unitPriceK = 0;
              double fdQtyPromosi = 0;

              // barang.fdQty = qtyGenapS;
              barang.fdQtyK = qtyGenapK;
              hargaAsli = await cbrg.getHargaAsliByFdKodeBarangNOO(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(barang.fdJenisSatuan.toString()),
                  lkodeHarga,
                  '0',
                  barang.isHanger!);
              unitPrice = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(barang.fdJenisSatuan.toString()),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  barang.isHanger!);
              unitPriceK = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(satuanOrderK),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  '0');
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanOrder
              // final satuanOrderKode = satuanOrderS.toString();
              // final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              // final satuanMatch = satuanList.firstWhere(
              //   (s) => s.fdKodeSatuan.toString() == satuanOrderKode,
              //   orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              // );
              // barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              // barang.fdJenisSatuan =
              //     int.tryParse(satuanOrderS.toString()) ?? barang.fdJenisSatuan;

              barang.fdHargaAsli = hargaAsli;
              barang.fdUnitPrice = unitPrice;
              barang.fdUnitPriceK = unitPriceK;
              barang.fdTotalPriceK =
                  barang.fdQtyK! * barang.fdUnitPriceK!.toDouble();
            }
          } else {
            satuanOrderK = '0';
            qtyGenapK = barang.fdQty! * barang.fdKonvS_K!;

            if (qtyGenapK % 1 != 0) {
              setState(() {
                isDecimal = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Qty ${barang.fdNamaBarang} tidak boleh desimal'),
              ));
              setState(() {
                isLoading = false;
              });
              return false;
            } else {
              double hargaAsli = 0;
              double unitPrice = 0;
              double unitPriceK = 0;

              // barang.fdQty = qtyGenapK;
              barang.fdQtyK = qtyGenapK;
              hargaAsli = await cbrg.getHargaAsliByFdKodeBarangNOO(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(barang.fdJenisSatuan.toString()),
                  lkodeHarga,
                  '0',
                  barang.isHanger!);
              unitPrice = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(barang.fdJenisSatuan.toString()),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  barang.isHanger!);
              unitPriceK = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(satuanOrderK),
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  '0');
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanOrder
              // final satuanOrderKode = satuanOrderK.toString();
              // final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              // final satuanMatch = satuanList.firstWhere(
              //   (s) => s.fdKodeSatuan.toString() == satuanOrderKode,
              //   orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              // );
              // barang.fdJenisSatuan = int.tryParse(satuanOrderK);
              // barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              // barang.fdJenisSatuan =
              //     int.tryParse(satuanOrderK.toString()) ?? barang.fdJenisSatuan;

              barang.fdUnitPrice = unitPrice;
              barang.fdUnitPriceK = unitPriceK;
              barang.fdTotalPriceK =
                  barang.fdQtyK! * barang.fdUnitPriceK!.toDouble();
            }
          }
        }
      }

      listKeranjang.clear();

      for (var item in tempBarangSelected) {
        final fdQtyK =
            (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0);
        final fdQtyStockK =
            (double.tryParse(item.fdQtyStockK?.toString() ?? '0')?.toInt() ??
                0);

        if (fdQtyStockK < fdQtyK && (fdQtyStockK - fdQtyK) > 0) {
          setState(() {
            stockCukup = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Stok tidak cukup untuk item ${item.fdNamaBarang} (Stok: $fdQtyStockK, Pesanan: $fdQtyK)'),
          ));
          setState(() {
            isLoading = false;
          });
          return false;
        }
      }

      listKeranjang = tempBarangSelected.map((barang) {
        return mbrg.BarangSelected(
          fdKodeBarang: barang.fdKodeBarang,
          fdNamaBarang: barang.fdNamaBarang,
          fdQty: barang.fdQty,
          fdQtyK: barang.fdQtyK,
          fdJenisSatuan: barang.fdJenisSatuan,
          fdNamaJenisSatuan: barang.fdNamaJenisSatuan,
          fdPromosi: barang.fdPromosi,
          fdHargaAsli: barang.fdHargaAsli,
          fdUnitPrice: barang.fdUnitPrice,
          fdUnitPriceK: barang.fdUnitPriceK,
          fdTotalPrice: barang.fdTotalPrice,
          fdTotalPriceK: barang.fdTotalPriceK,
          fdKonvB_S: barang.fdKonvB_S,
          fdKonvS_K: barang.fdKonvS_K,
          fdQtyStock: barang.fdQtyStock,
          fdQtyStockK: barang.fdQtyStockK,
          isHanger: barang.isHanger,
          isShow: barang.isShow,
          jnItem: barang.jnItem,
          urut: barang.urut,
        );
      }).toList();

      listKeranjangJson.clear();
      listKeranjangJson = tempBarangSelected.map((barang) {
        return mbrg.BarangSelected(
          fdKodeBarang: barang.fdKodeBarang,
          fdNamaBarang: barang.fdNamaBarang,
          fdQty: barang.fdQtyK,
          fdJenisSatuan: 0,
          fdNamaJenisSatuan: 'PCS',
          fdPromosi: barang.fdPromosi,
          fdUnitPrice: barang.fdUnitPriceK,
          fdTotalPrice: barang.fdTotalPriceK,
          isHanger: barang.isHanger,
        );
      }).toList();

      // cek setiap barang untuk promo hanger
      for (var barang in tempBarangSelected) {
        if (barang.isHanger == '1') {
          double hargaAsli = 0;
          double fdQtyPromo =
              await cbrg.getQtyPromosiHangerByFdKodeBarang(barang.fdKodeBarang);

          if (fdQtyPromo > 0) {
            if (barang.fdUnitPriceK == 0) {
              hargaAsli = await cbrg.getHargaAsliByFdKodeBarangNOO(
                  barang.fdKodeBarang.trim(),
                  int.tryParse(barang.fdJenisSatuan.toString()),
                  lkodeHarga,
                  '0',
                  barang.isHanger!);
              hargaSatuan = await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                  barang.fdKodeBarang.trim(),
                  0,
                  fdKodeHarga,
                  listParam[0].fdPPN,
                  '0');
            } else {
              hargaSatuan = barang.fdUnitPriceK!;
            }
            double qtyPromosi = barang.fdQtyK! / fdQtyPromo;
            listKeranjang.add(
              mbrg.BarangSelected(
                fdKodeBarang: barang.fdKodeBarang,
                fdNamaBarang: barang.fdNamaBarang,
                fdQty: qtyPromosi,
                fdQtyK: qtyPromosi,
                fdJenisSatuan: 0,
                fdNamaJenisSatuan: 'PCS',
                fdPromosi: '1',
                fdHargaAsli: hargaAsli,
                fdUnitPrice: hargaSatuan,
                fdUnitPriceK: hargaSatuan,
                fdTotalPrice: hargaSatuan * qtyPromosi,
                fdTotalPriceK: hargaSatuan * qtyPromosi,
                fdDiscount: 0,
                fdDiscountDetail: '',
                fdKonvB_S: barang.fdKonvB_S,
                fdKonvS_K: barang.fdKonvS_K,
                fdQtyStock: barang.fdQtyStock,
                fdQtyStockK: barang.fdQtyStockK,
                isHanger: '1',
                isShow: '0',
                jnItem: '1',
                urut: 1,
              ),
            );
          }
        }
      }

      log('getdata: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');
      log('listKeranjangJson: ${listKeranjangJson.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');

      // setState(() {
      //   isLoading = false;
      // });
      return true;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return false;
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
        title: const Text('Penjualan'),
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
                    '${widget.lgn.fdKodeNoo} - ${widget.lgn.fdNamaToko}',
                    style: css.textHeaderBold())),
            const Padding(padding: EdgeInsets.all(5)),
            Flexible(
                child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<mbrg.BarangStock>(
                          itemAsString: (mbrg.BarangStock item) =>
                              item.fdNamaBarang,
                          compareFn: (mbrg.BarangStock item,
                                  mbrg.BarangStock selectedItem) =>
                              item.fdKodeBarang == selectedItem.fdKodeBarang,
                          items: (String filter, LoadProps? loadProps) =>listBarangStock,
                          selectedItem: listBarangStock.firstWhere(
                            (item) =>
                                item.fdKodeBarang.trim() == barangSelected,
                            orElse: () => mbrg.BarangStock(
                                fdKodeBarang: '',
                                fdNamaBarang: '',
                                fdSatuanK: ''), // Default empty
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: css.textInputStyle(
                                'Search',
                                const TextStyle(fontStyle: FontStyle.italic),
                                null,
                                Icon(Icons.search,
                                    size: 24 *
                                        ScaleSize.textScaleFactor(context)),
                                null,
                              ),
                            ),
                            searchDelay: const Duration(milliseconds: 0),
                            itemBuilder: (context, item, isSelected,val) {
                              return ListTile(
                                title: Text(
                                  '[${item.fdKodeBarang.trim()}] ${item.fdNamaBarang.trim()}',
                                  style: css.textSmallSizeBlack(),
                                ),
                              );
                            },
                            menuProps:
                                MenuProps(shape: css.borderOutlineInputRound()),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: css.textInputStyle(
                              'Barang',
                              const TextStyle(fontStyle: FontStyle.italic),
                              'Barang',
                              null,
                              null,
                            ),
                          ),
                          onChanged: (mbrg.BarangStock? value) {
                            setState(() {
                              barangSelected = value?.fdKodeBarang.trim();
                            });
                          },
                          filterFn: (mbrg.BarangStock item, String filter) {
                            return item.fdNamaBarang
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                item.fdKodeBarang
                                    .toLowerCase()
                                    .contains(filter.toLowerCase());
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () async {
                            if (!listBarangSelected.any((item) =>
                                item.fdKodeBarang.trim() == barangSelected)) {
                              if (barangSelected != null) {
                                var satuan =
                                    await cbrg.getSatuanBarangByFdKodeBarangMap(
                                        barangSelected!);
                                setState(() {
                                  satuanPerBarang[barangSelected!] =
                                      satuan[barangSelected!] ?? [];
                                  listBarangSelected.add(mbrg.BarangSelected(
                                    fdKodeBarang: barangSelected!,
                                    fdNamaBarang: listBarangStock
                                        .firstWhere(
                                            (item) =>
                                                item.fdKodeBarang.trim() ==
                                                barangSelected,
                                            orElse: () => mbrg.BarangStock(
                                                fdKodeBarang: '',
                                                fdNamaBarang: '',
                                                fdSatuanK: ''))
                                        .fdNamaBarang,
                                    fdQty: double.tryParse(
                                        textQtyControllers[barangSelected]
                                                ?.text ??
                                            '0'),
                                    fdQtyStock: listBarangStock
                                        .firstWhere(
                                            (item) =>
                                                item.fdKodeBarang.trim() ==
                                                barangSelected,
                                            orElse: () => mbrg.BarangStock(
                                                fdKodeBarang: '',
                                                fdNamaBarang: '',
                                                fdQtyStock: 0,
                                                fdQtyStockK: 0,
                                                fdSatuanK: ''))
                                        .fdQtyStock,
                                    fdQtyStockK: listBarangStock
                                        .firstWhere(
                                            (item) =>
                                                item.fdKodeBarang.trim() ==
                                                barangSelected,
                                            orElse: () => mbrg.BarangStock(
                                                fdKodeBarang: '',
                                                fdNamaBarang: '',
                                                fdQtyStock: 0,
                                                fdQtyStockK: 0,
                                                fdSatuanK: ''))
                                        .fdQtyStockK,
                                    fdJenisSatuan:
                                        int.parse(satuanSelected ?? '9'),
                                    fdPromosi: '0',
                                    fdUnitPrice: 0,
                                    isHanger:
                                        (satuan[barangSelected!]?.isNotEmpty ??
                                                false)
                                            ? satuan[barangSelected!]!
                                                .first
                                                .isHanger
                                                .toString()
                                            : null,
                                    isShow: '1',
                                    jnItem: '1',
                                    urut: 1,
                                  ));
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Barang belum dipilih')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Barang sudah ada')));
                            }
                          },
                          child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.green,
                                shape: CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                  if (listBarangSelected.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: listBarangSelected.length,
                        itemBuilder: (context, index) {
                          final barang = listBarangSelected[index];
                          return barang.fdPromosi == '1'
                              ? const Padding(padding: EdgeInsets.all(0))
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(barang.fdNamaBarang.trim()),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: TextFormField(
                                            controller: textQtyControllers[
                                                    barang.fdKodeBarang
                                                        .trim()] ??=
                                                TextEditingController(),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*')),
                                              cother
                                                  .EnThousandsSeparatorInputFormatter(),
                                            ],
                                            decoration: css.textInputStyle(
                                              'Qty',
                                              const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                              'Qty',
                                              null,
                                              null,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                print(textQtyControllers[barang
                                                        .fdKodeBarang
                                                        .trim()]
                                                    ?.text);
                                                totalItem = textQtyControllers
                                                    .values
                                                    .map((controller) =>
                                                        int.tryParse(controller
                                                            .text
                                                            .replaceAll(
                                                                RegExp(r'[,]'),
                                                                '')) ??
                                                        0.0)
                                                    .fold(
                                                        0,
                                                        (prev, element) =>
                                                            prev + element);
                                                qty = double.tryParse(
                                                    textQtyControllers[barang
                                                                .fdKodeBarang
                                                                .trim()]
                                                            ?.text
                                                            .replaceAll(
                                                                RegExp(r'[,]'),
                                                                '') ??
                                                        '0.0');
                                                barang.fdQty = qty;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: DropdownSearch<mbrg.Satuan>(
                                          itemAsString: (mbrg.Satuan item) =>
                                              item.fdNamaSatuan!,
                                          compareFn: (mbrg.Satuan item,
                                                  mbrg.Satuan selectedItem) =>
                                              item.fdKodeSatuan ==
                                              selectedItem.fdKodeSatuan,
                                          items: (String filter, LoadProps? loadProps) =>satuanPerBarang[
                                                  barang.fdKodeBarang] ??
                                              [],
                                          selectedItem: (satuanPerBarang[
                                                      barang.fdKodeBarang] ??
                                                  [])
                                              .firstWhere(
                                            (item) =>
                                                item.fdKodeSatuan.trim() ==
                                                satuanSelectedPerBarang[
                                                    barang.fdKodeBarang],
                                            orElse: () => mbrg.Satuan(
                                                fdKodeSatuan: '',
                                                fdNamaSatuan: ''),
                                          ),
                                          popupProps: PopupProps.menu(
                                            showSearchBox: false,
                                            searchFieldProps: TextFieldProps(
                                              decoration: css.textInputStyle(
                                                'Search',
                                                const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                                null,
                                                Icon(Icons.search,
                                                    size: 24 *
                                                        ScaleSize
                                                            .textScaleFactor(
                                                                context)),
                                                null,
                                              ),
                                            ),
                                            searchDelay:
                                                const Duration(milliseconds: 0),
                                            itemBuilder:
                                                (context, item, isSelected,val) {
                                              return ListTile(
                                                title: Text(
                                                  item.fdNamaSatuan!.trim(),
                                                  style:
                                                      css.textSmallSizeBlack(),
                                                ),
                                              );
                                            },
                                            menuProps: MenuProps(
                                                shape: css
                                                    .borderOutlineInputRound()),
                                            constraints: const BoxConstraints(
                                                maxHeight: 210),
                                          ),
                                          decoratorProps:
                                              DropDownDecoratorProps(
                                            decoration:
                                                css.textInputStyle(
                                              'Satuan',
                                              const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                              'Satuan',
                                              null,
                                              null,
                                            ),
                                          ),
                                          dropdownBuilder:
                                              (context, selectedItem) {
                                            return Text(
                                              selectedItem?.fdNamaSatuan ?? '',
                                              style: css.textSmallSizeBlack(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            );
                                          },
                                          onChanged:
                                              (mbrg.Satuan? value) async {
                                            double unitPrice = 0;
                                            double unitPriceK = 0;
                                            double hargaAsli = 0;
                                            unitPrice = await cbrg
                                                .getHargaJualBarangByFdKodeBarangNoo(
                                                    barang.fdKodeBarang.trim(),
                                                    int.tryParse(value
                                                                ?.fdKodeSatuan ??
                                                            '0') ??
                                                        0,
                                                    fdKodeHarga,
                                                    listParam[0].fdPPN,
                                                    barang.isHanger!);
                                            unitPriceK = await cbrg
                                                .getHargaJualBarangByFdKodeBarangNoo(
                                                    barang.fdKodeBarang.trim(),
                                                    0,
                                                    fdKodeHarga,
                                                    listParam[0].fdPPN,
                                                    barang.isHanger!);
                                            hargaAsli = await cbrg
                                                .getHargaAsliByFdKodeBarangNOO(
                                                    barang.fdKodeBarang.trim(),
                                                    int.tryParse(value
                                                                ?.fdKodeSatuan ??
                                                            '0') ??
                                                        0,
                                                    lkodeHarga,
                                                    '0',
                                                    barang.isHanger!);
                                            konversiSatuanBarang = await cbrg
                                                .getKonversiSatuanBarang(
                                                    barang.fdKodeBarang.trim());
                                            setState(() {
                                              listBarangSelected[index]
                                                  .fdHargaAsli = hargaAsli;
                                              listBarangSelected[index]
                                                  .fdUnitPrice = unitPrice;
                                              listBarangSelected[index]
                                                  .fdUnitPriceK = unitPriceK;
                                              listBarangSelected[index]
                                                      .fdKonvB_S =
                                                  konversiSatuanBarang[0]
                                                      ['fdKonvB_S'];
                                              listBarangSelected[index]
                                                      .fdKonvS_K =
                                                  konversiSatuanBarang[0]
                                                      ['fdKonvS_K'];
                                              satuanSelectedPerBarang[
                                                      barang.fdKodeBarang] =
                                                  value?.fdKodeSatuan.trim();
                                              barang.fdJenisSatuan =
                                                  int.tryParse(
                                                          value?.fdKodeSatuan ??
                                                              '9') ??
                                                      9;
                                              listBarangSelected[index]
                                                      .fdNamaJenisSatuan =
                                                  value?.fdNamaSatuan;
                                              listBarangSelected[index]
                                                  .isHanger = barang.isHanger;
                                              listBarangSelected[index]
                                                      .fdQtyStock =
                                                  barang.fdQtyStock;
                                              listBarangSelected[index]
                                                      .fdQtyStockK =
                                                  barang.fdQtyStockK;
                                            });
                                          },
                                          filterFn: (mbrg.Satuan item,
                                              String filter) {
                                            return item.fdNamaSatuan!
                                                    .toLowerCase()
                                                    .contains(
                                                        filter.toLowerCase()) ||
                                                item.fdKodeSatuan
                                                    .toLowerCase()
                                                    .contains(
                                                        filter.toLowerCase());
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  listBarangSelected
                                                      .removeAt(index);
                                                  textQtyControllers[barang
                                                          .fdKodeBarang
                                                          .trim()]
                                                      ?.text = '';
                                                  totalItem = textQtyControllers
                                                      .values
                                                      .map((controller) =>
                                                          int.tryParse(controller
                                                              .text
                                                              .replaceAll(
                                                                  RegExp(
                                                                      r'[.,]'),
                                                                  '')) ??
                                                          0.0)
                                                      .fold(
                                                          0,
                                                          (prev, element) =>
                                                              prev + element);
                                                });
                                              },
                                              child: Ink(
                                                  decoration:
                                                      const ShapeDecoration(
                                                    color: Colors.red,
                                                    shape: CircleBorder(),
                                                  ),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
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
                  if (formInputKey.currentState!.validate()) {
                    checkSave = await saveOrder();
                    log('data: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, ${item.fdUnitPrice}, ${item.fdTotalPrice}, ${item.fdUnitPriceK}, ${item.fdTotalPriceK}, promosi:${item.fdPromosi}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan} ${item.fdDiscount} ${item.fdDiscountDetail}, jnItem: ${item.jnItem})').toList()}');

                    print(listKeranjang);
                    if (isDecimal == 0 && stockCukup) {
                      JsonBarangDiskon = await capi.getDataDiskonBarang(
                          widget.user.fdToken,
                          widget.lgn.fdKodeNoo!,
                          fdKodeHarga,
                          widget.user.fdKodeDepo,
                          widget.user.fdKodeSF,
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          listKeranjangJson.cast<mbrg.BarangSelected>());
                      //cek jika item.fdMessage tidak kosong
                      if (JsonBarangDiskon.isNotEmpty) {
                        if (JsonBarangDiskon[0].message!.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              JsonBarangDiskon[0].message.toString(),
                            ),
                          ));
                          return;
                        }
                      }
                      fBarangExtra = await capi.getDataDiskonBarangExtra(
                          widget.user.fdToken,
                          widget.lgn.fdKodeNoo!,
                          fdKodeHarga,
                          widget.user.fdKodeDepo,
                          widget.user.fdKodeSF,
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          listKeranjangJson);
                      if (fBarangExtra.isNotEmpty) {
                        if (fBarangExtra[0].message!.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              fBarangExtra[0].message.toString(),
                            ),
                          ));
                        }
                      }
                      log('fBarangExtra: ${fBarangExtra.map((item) => '(${item.fdKodeBarang},  Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}  ${item.fdNamaJenisSatuan} )').toList()}');
                      log('data: ${listKeranjangJson.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}  ${item.fdNamaJenisSatuan}, promosi: ${item.fdPromosi}, isHanger: ${item.isHanger})').toList()}');
                      for (var extra in fBarangExtra) {
                        // Cek apakah fdKodeBarang sudah ada di listKeranjang dengan promosi '1'
                        final exists = listKeranjang.any((item) =>
                            item.fdKodeBarang == extra.fdKodeBarang &&
                            item.fdPromosi == '1');
                        if (!exists) {
                          var konversiUnitPrice = 0.0;
                          var konversiHargaAsli = 0.0;
                          double unitPriceExtra = 0;
                          double hargaAsliExtra = 0;
                          hargaAsliExtra =
                              await cbrg.getHargaAsliByFdKodeBarangNOO(
                                  extra.fdKodeBarang,
                                  0,
                                  lkodeHarga,
                                  '0',
                                  extra.isHanger!);
                          unitPriceExtra =
                              await cbrg.getHargaJualBarangByFdKodeBarangNoo(
                                  extra.fdKodeBarang,
                                  0,
                                  fdKodeHarga,
                                  listParam[0].fdPPN,
                                  extra.isHanger!);
                          final match = listKeranjang.firstWhere(
                              (item) => item.fdKodeBarang == extra.fdKodeBarang,
                              orElse: () => mbrg.BarangSelected(
                                  fdKodeBarang: extra.fdKodeBarang,
                                  fdNamaBarang: extra.fdNamaBarang,
                                  fdQty: extra.fdQty,
                                  fdJenisSatuan: 0,
                                  fdNamaJenisSatuan: extra.fdNamaJenisSatuan,
                                  fdPromosi: '1',
                                  fdHargaAsli: hargaAsliExtra,
                                  fdUnitPrice: unitPriceExtra,
                                  fdTotalPrice: 0));
                          if (match.fdJenisSatuan.toString() != '0') {
                            konversiUnitPrice =
                                await cbrg.getUnitPriceKonversiSatuan(
                                    extra.fdKodeBarang,
                                    match.fdJenisSatuan.toString(),
                                    match.fdUnitPrice!);
                            konversiHargaAsli =
                                await cbrg.getUnitPriceKonversiSatuan(
                                    extra.fdKodeBarang,
                                    match.fdJenisSatuan.toString(),
                                    match.fdHargaAsli!);
                          } else {
                            konversiUnitPrice = match.fdUnitPrice!;
                            konversiHargaAsli = match.fdHargaAsli!;
                          }
                          // if (match.isHanger != '1') {
                          listKeranjang.add(
                            mbrg.BarangSelected(
                                fdKodeBarang: extra.fdKodeBarang,
                                fdNamaBarang: extra.fdNamaBarang,
                                fdQty: extra.fdQty,
                                fdQtyK: extra.fdQty,
                                fdJenisSatuan: 0, //extra.fdSatuan,
                                fdNamaJenisSatuan: extra.fdNamaJenisSatuan,
                                fdPromosi: '1',
                                fdHargaAsli: konversiHargaAsli,
                                fdUnitPrice: konversiUnitPrice,
                                fdUnitPriceK: konversiUnitPrice,
                                fdTotalPrice: extra.fdQty! * konversiUnitPrice,
                                fdTotalPriceK: extra.fdQty! * konversiUnitPrice,
                                fdDiscount: 0,
                                fdDiscountDetail: '',
                                isHanger: match.isHanger,
                                isShow: '1',
                                jnItem: 'X',
                                urut: 2),
                          );
                        }
                        // }
                      }
                      // listKeranjang.sort(
                      //     (a, b) => a.fdKodeBarang.compareTo(b.fdKodeBarang));
                      listKeranjang.sort((a, b) {
                        final kodeCompare =
                            a.fdKodeBarang.compareTo(b.fdKodeBarang);
                        if (kodeCompare != 0) {
                          return kodeCompare;
                        } else {
                          return a.fdPromosi!.compareTo(b.fdPromosi!);
                        }
                      });

                      log('new listKeranjang: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}, promosi: ${item.fdPromosi}, jnItem: ${item.jnItem})').toList()}');
//hitung total diskon
                      //di taruh atas untuk cek dahulu pesan error drop size
                      // JsonBarangDiskon = await capi.getDataDiskonBarang(
                      //     widget.user.fdToken,
                      //     widget.lgn.fdKodeLangganan!,
                      //     fdKodeHarga,
                      //     widget.user.fdKodeDepo,
                      //     widget.user.fdKodeSF,
                      //     DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      //     listKeranjang.cast<mbrg.BarangSelected>());
                      log('data: ${JsonBarangDiskon.map((item) => '(${item.fdDiscount} )').toList()}');
                      if (JsonBarangDiskon.isEmpty) {
                        totalDiscount = 0;
                      } else if (JsonBarangDiskon[0].message!.isNotEmpty) {
                        totalDiscount = 0;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            JsonBarangDiskon[0].message.toString(),
                          ),
                        ));
                      } else {
                        totalDiscount =
                            JsonBarangDiskon.map((item) => item.fdDiscount)
                                .reduce((a, b) => a + b);
                        // Isi fdDiscountDetail pada listKeranjang dari JsonBarangDiskon
                        for (var keranjang in listKeranjang) {
                          final diskon = JsonBarangDiskon.firstWhere(
                            (d) => d.fdKodeBarang == keranjang.fdKodeBarang,
                            orElse: () => mbrg.JsonBarangDiskon(
                              fdKodeBarang: keranjang.fdKodeBarang,
                              fdDiscount: keranjang.fdDiscount ?? 0,
                              fdDiscountDetail: '',
                              fdQty: keranjang.fdQty ?? 0,
                              fdLastUpdate: DateTime.now().toIso8601String(),
                            ),
                          );
                          keranjang.fdDiscountDetail = diskon.fdDiscountDetail;
                          keranjang.fdDiscount = diskon.fdDiscount;
                        }
                      }
                      print(totalDiscount);
                      log('data: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, ${item.fdUnitPrice}, ${item.fdTotalPrice}, ${item.fdUnitPriceK}, ${item.fdTotalPriceK}, promosi:${item.fdPromosi}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan} disc:${item.fdDiscount} ${item.fdDiscountDetail})').toList()}');

//hitung total pesanan

                      for (int index = 0;
                          index < listKeranjang.length;
                          index++) {
                        totalPesanan += listKeranjang[index].fdTotalPrice!;
                        totalDiscount += 0;
                        // var produk = listKeranjang[index];
                        // textQtyControllers[produk.fdKodeBarang.trim()] =
                        //     TextEditingController(text: produk.fdQty.toString());
                      }

                      log('getdata: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');
                      log('listKeranjangJson: ${listKeranjangJson.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');

                      if (checkSave) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         settings:
                        //             const RouteSettings(name: 'NooOrderCartForm'),
                        //         builder: (context) => NooOrderCartForm(
                        //             fdNoEntryOrder: '',
                        //             lgn: widget.lgn,
                        //             user: widget.user,
                        //             totalItem: totalItem,
                        //             listKeranjang: listKeranjang,
                        //             fdKodeHarga: fdKodeHarga,
                        //             isEndDay: widget.isEndDay,
                        //             routeName: 'NooOrderCartForm',
                        //             startDayDate: widget.startDayDate))).then(
                        //     (value) {
                        //   print(listKeranjang);

                        //   log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                        // });

                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: 'NooCanvasSummaryForm'),
                                    builder: (context) => NooCanvasSummaryForm(
                                        fdNoEntryOrder: noEntry,
                                        lgn: widget.lgn,
                                        user: widget.user,
                                        totalPesanan: totalPesanan,
                                        totalDiscount: totalDiscount,
                                        listKeranjang: listKeranjang,
                                        isEndDay: widget.isEndDay,
                                        endTimeVisit: widget.endTimeVisit,
                                        routeName: 'NooCanvasSummaryForm',
                                        startDayDate: widget.startDayDate)))
                            .then((value) {
                          initLoadPage();

                          setState(() {});
                          print(listKeranjang);

                          log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                        });
                      }
                    }
                  }
                },
                child: const Text('Next'),
                //  Text('Keranjang: ${param.idNumberFormat.format(totalItem).toString()} items'),
              ),
            ),
    );
  }
}
