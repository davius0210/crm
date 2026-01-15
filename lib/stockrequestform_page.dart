import 'dart:developer';
import 'dart:io';
import 'package:crm_apps/new/component/custom_button_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'stockrequest_page.dart';
import 'stockrequestform_page.dart';
import 'stockrequestsummaryform_page.dart';
import 'main.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/stock_cont.dart' as cstoc;
import 'controller/other_cont.dart' as cother;
import 'controller/promo_cont.dart' as cpro;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/stock.dart' as mstoc;
import 'models/promo.dart' as mpro;
import 'models/globalparam.dart' as param;
import 'models/logdevice.dart' as mlog;
import 'style/css.dart' as css;

// List<MultiSelectItem> listSatuan = [
//   MultiSelectItem(0, 'Kecil'),
//   MultiSelectItem(1, 'Sedang'),
//   MultiSelectItem(2, 'Besar'),
// ];

class StockRequestFormPage extends StatefulWidget {
  final String fdNoEntryStockRequest;
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const StockRequestFormPage(
      {super.key,
      required this.fdNoEntryStockRequest,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<StockRequestFormPage> createState() => LayerStockRequestFormPage();
}

class LayerStockRequestFormPage extends State<StockRequestFormPage> {
  bool isLoading = false;
  List<mlgn.Langganan> langganans = [];
  List<mstoc.Stock> listStockRequest = [];
  List<mbrg.Barang> listBarang = [];
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

  // List<mpro.ViewBarangPromo> barangs = [];
  String? barangSelected;
  String? satuanSelected;
  // mlgn.Langganan? barangSelected;
  TextEditingController txtStockRequest = TextEditingController();
  TextEditingController txtSisaStockRequest = TextEditingController();
  TextEditingController txtStockRequestBaru = TextEditingController();
  TextEditingController txtOverStockRequest = TextEditingController();
  TextEditingController txtPengajuanBaruLK = TextEditingController();
  Map<String, TextEditingController> textQtyControllers = {};
  Map<String, TextEditingController> textHangerControllers = {};
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  double sisaLK = 0;
  double StockRequestBaru = 0;
  double overLK = 0;
  double totalDiscount = 0;
  double totalStockRequest = 0;
  double totalItem = 0;
  double? qty = 0;
  bool checkSave = false;
  String fdKodeHarga = '';
  double qtyGenapS = 0;
  double qtyGenapK = 0;
  String satuanStockRequestS = '';
  String satuanStockRequestK = '';
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

    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
        totalDiscount = 0;
        totalStockRequest = 0;
        isDecimal = 0;
      });
      listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      listBarang = await cbrg.getAllBarangStock(widget.user.fdKodeSF);

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

  Future<bool> saveStockRequest() async {
    try {
      setState(() {
        isDecimal = 0;
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
//cek listBarangSelected jika ada decimal
      tempBarangSelected.clear();
      tempBarangSelected = listBarangSelected.map((barang) {
        return mbrg.BarangSelected(
          fdKodeBarang: barang.fdKodeBarang,
          fdNamaBarang: barang.fdNamaBarang,
          fdQty: barang.fdQty,
          fdQtyK: barang.fdQtyK,
          fdJenisSatuan: barang.fdJenisSatuan,
          fdNamaJenisSatuan: barang.fdNamaJenisSatuan,
          fdPromosi: barang.fdPromosi,
          fdUnitPrice: barang.fdUnitPrice,
          fdUnitPriceK: barang.fdUnitPriceK,
          fdTotalPrice: barang.fdQty! * barang.fdUnitPrice!.toDouble(),
          fdTotalPriceK: 0,
          fdKonvB_S: barang.fdKonvB_S,
          fdKonvS_K: barang.fdKonvS_K,
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
            satuanStockRequestS = '1';
            qtyGenapS = barang.fdQty! * barang.fdKonvB_S!;

            satuanStockRequestK = '0';
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
              barang.fdQty = qtyGenapS;
              barang.fdQtyK = qtyGenapK;
              unitPrice = 0;
              unitPriceK = 0;
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanStockRequest
              // final satuanStockRequestKode = listDecimal['satuanStockRequest'].toString();
              final satuanStockRequestKode = satuanStockRequestS.toString();
              final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              final satuanMatch = satuanList.firstWhere(
                (s) => s.fdKodeSatuan.toString() == satuanStockRequestKode,
                orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              );
              barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              barang.fdJenisSatuan =
                  int.tryParse(satuanStockRequestS.toString()) ??
                      barang.fdJenisSatuan;

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
            satuanStockRequestS = '1';
            qtyGenapS = barang.fdQty! * barang.fdKonvB_S!;

            satuanStockRequestK = '0';
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
              double unitPrice = 0;
              double unitPriceK = 0;
              double fdQtyPromosi = 0;

              // barang.fdQty = qtyGenapS;
              barang.fdQtyK = qtyGenapK;
              unitPrice = 0;
              unitPriceK = 0;
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanStockRequest
              // final satuanStockRequestKode = satuanStockRequestS.toString();
              // final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              // final satuanMatch = satuanList.firstWhere(
              //   (s) => s.fdKodeSatuan.toString() == satuanStockRequestKode,
              //   orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              // );
              // barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              // barang.fdJenisSatuan =
              //     int.tryParse(satuanStockRequestS.toString()) ?? barang.fdJenisSatuan;

              barang.fdUnitPrice = unitPrice;
              barang.fdUnitPriceK = unitPriceK;
              barang.fdTotalPriceK =
                  barang.fdQtyK! * barang.fdUnitPriceK!.toDouble();
            }
          } else {
            satuanStockRequestK = '0';
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
              double unitPrice = 0;
              double unitPriceK = 0;

              // barang.fdQty = qtyGenapK;
              barang.fdQtyK = qtyGenapK;
              unitPrice = 0;
              unitPriceK = 0;
              var satuan = await cbrg
                  .getSatuanBarangByFdKodeBarangMap(barang.fdKodeBarang.trim());
              // Cari fdNamaSatuan dari satuan berdasarkan satuanStockRequest
              // final satuanStockRequestKode = satuanStockRequestK.toString();
              // final satuanList = satuan[barang.fdKodeBarang.trim()] ?? [];
              // final satuanMatch = satuanList.firstWhere(
              //   (s) => s.fdKodeSatuan.toString() == satuanStockRequestKode,
              //   orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
              // );
              // barang.fdJenisSatuan = int.tryParse(satuanStockRequestK);
              // barang.fdNamaJenisSatuan = satuanMatch.fdNamaSatuan;
              // barang.fdJenisSatuan =
              //     int.tryParse(satuanStockRequestK.toString()) ?? barang.fdJenisSatuan;

              barang.fdUnitPrice = unitPrice;
              barang.fdUnitPriceK = unitPriceK;
              barang.fdTotalPriceK =
                  barang.fdQtyK! * barang.fdUnitPriceK!.toDouble();
            }
          }
        }
      }

      listKeranjang.clear();
      listKeranjang = tempBarangSelected.map((barang) {
        return mbrg.BarangSelected(
          fdKodeBarang: barang.fdKodeBarang,
          fdNamaBarang: barang.fdNamaBarang,
          fdQty: barang.fdQty,
          fdQtyK: barang.fdQtyK,
          fdJenisSatuan: barang.fdJenisSatuan,
          fdNamaJenisSatuan: barang.fdNamaJenisSatuan,
          fdPromosi: barang.fdPromosi,
          fdUnitPrice: barang.fdUnitPrice,
          fdUnitPriceK: barang.fdUnitPriceK,
          fdTotalPrice: barang.fdTotalPrice,
          fdTotalPriceK: barang.fdTotalPriceK,
          fdKonvB_S: barang.fdKonvB_S,
          fdKonvS_K: barang.fdKonvS_K,
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
      // for (var barang in tempBarangSelected) {
      //   if (barang.isHanger == '1') {
      //     double fdQtyPromo =
      //         await cbrg.getQtyPromosiHangerByFdKodeBarang(barang.fdKodeBarang);

      //     if (fdQtyPromo > 0) {
      //       if (barang.fdUnitPriceK == 0) {
      //         double hargaSatuan = 0;
      //       }
      //       double qtyPromosi = barang.fdQtyK! / fdQtyPromo;
      //       listKeranjang.add(
      //         mbrg.BarangSelected(
      //           fdKodeBarang: barang.fdKodeBarang,
      //           fdNamaBarang: barang.fdNamaBarang,
      //           fdQty: qtyPromosi,
      //           fdQtyK: qtyPromosi,
      //           fdJenisSatuan: 0,
      //           fdNamaJenisSatuan: 'PCS',
      //           fdPromosi: '1',
      //           fdUnitPrice: barang.fdUnitPriceK,
      //           fdUnitPriceK: barang.fdUnitPriceK,
      //           fdTotalPrice: barang.fdUnitPriceK! * qtyPromosi,
      //           fdTotalPriceK: barang.fdUnitPriceK! * qtyPromosi,
      //           fdDiscount: 0,
      //           fdDiscountDetail: '',
      //           fdKonvB_S: barang.fdKonvB_S,
      //           fdKonvS_K: barang.fdKonvS_K,
      //           isHanger: '1',
      //           isShow: '0',
      //           jnItem: '1',
      //           urut: 1,
      //         ),
      //       );
      //     }
      //   }
      // }

      log('getdata: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');
      log('listKeranjangJson: ${listKeranjangJson.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Price: ${item.fdUnitPrice}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');

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
        title: const Text('Stock Request'),
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
                child: Text('${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
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
                        child: DropdownSearch<mbrg.Barang>(
                          itemAsString: (mbrg.Barang item) => item.fdNamaBarang,
                          compareFn: (mbrg.Barang item,
                                  mbrg.Barang selectedItem) =>
                              item.fdKodeBarang == selectedItem.fdKodeBarang,
                          items: (String filter, LoadProps? loadProps) =>listBarang,
                          selectedItem: listBarang.firstWhere(
                            (item) =>
                                item.fdKodeBarang.trim() == barangSelected,
                            orElse: () => mbrg.Barang(
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
                          onChanged: (mbrg.Barang? value) {
                            setState(() {
                              barangSelected = value?.fdKodeBarang.trim();
                            });
                          },
                          filterFn: (mbrg.Barang item, String filter) {
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
                                    fdNamaBarang: listBarang
                                        .firstWhere(
                                            (item) =>
                                                item.fdKodeBarang.trim() ==
                                                barangSelected,
                                            orElse: () => mbrg.Barang(
                                                fdKodeBarang: '',
                                                fdNamaBarang: '',
                                                fdSatuanK: ''))
                                        .fdNamaBarang,
                                    fdQty: double.tryParse(
                                        textQtyControllers[barangSelected]
                                                ?.text
                                                .replaceAll(
                                                    RegExp(r'[,]'), '') ??
                                            '0'),
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

        // Jika promosi, jangan tampilkan apa-apa (lebih efisien pakai shrink)
        if (barang.fdPromosi == '1') return const SizedBox.shrink();
        
        return SelectedBarangItem(
          index: index,
          barang: barang,
          textQtyControllers: textQtyControllers, // Kirim variabelnya di sini
          satuanPerBarang: satuanPerBarang,
          satuanSelectedPerBarang: satuanSelectedPerBarang,
          onChanged: _updateTotalItems,
          onRemove: () {
            setState(() {
              listBarangSelected.removeAt(index);
              textQtyControllers[barang.fdKodeBarang.trim()]?.text = '';
              _updateTotalItems();
            });
          },
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
          : InkWell(
            onTap: ()async{
              if (formInputKey.currentState!.validate()) {
                      totalStockRequest = 0;
                      checkSave = await saveStockRequest();
                      if (isDecimal == 0) {
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
            
                        log('new listKeranjang: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}, promosi: ${item.fdPromosi})').toList()}');
            
                        log('data: ${JsonBarangDiskon.map((item) => '(${item.fdDiscount} )').toList()}');
                        // if (JsonBarangDiskon.isEmpty) {
                        //   totalDiscount = 0;
                        // } else if (JsonBarangDiskon[0].message!.isNotEmpty) {
                        //   totalDiscount = 0;
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //       JsonBarangDiskon[0].message.toString(),
                        //     ),
                        //   ));
                        // } else {
                        //   totalDiscount =
                        //       JsonBarangDiskon.map((item) => item.fdDiscount)
                        //           .reduce((a, b) => a + b);
                        //   // Isi fdDiscountDetail pada listKeranjang dari JsonBarangDiskon
                        //   for (var keranjang in listKeranjang) {
                        //     final diskon = JsonBarangDiskon.firstWhere(
                        //       (d) => d.fdKodeBarang == keranjang.fdKodeBarang,
                        //       orElse: () => mbrg.JsonBarangDiskon(
                        //         fdKodeBarang: keranjang.fdKodeBarang,
                        //         fdDiscount: keranjang.fdDiscount ?? 0,
                        //         fdDiscountDetail: '',
                        //         fdQty: keranjang.fdQty ?? 0,
                        //         fdLastUpdate: DateTime.now().toIso8601String(),
                        //       ),
                        //     );
                        //     keranjang.fdDiscountDetail = diskon.fdDiscountDetail;
                        //     keranjang.fdDiscount = diskon.fdDiscount;
                        //   }
                        // }
                        // print(totalDiscount);
                        log('data: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, promosi:${item.fdPromosi}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan} ${item.fdDiscount} ${item.fdDiscountDetail})').toList()}');
            
            //hitung total StockRequest
            
                        // for (int index = 0;
                        //     index < listKeranjang.length;
                        //     index++) {
                        //   totalStockRequest += listKeranjang[index].fdTotalPrice!;
                        //   totalDiscount += 0;
                        // }
            
                        if (checkSave) {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: const RouteSettings(
                                          name: 'StockRequestSummaryForm'),
                                      builder: (context) => StockSummaryForm(
                                          fdNoEntryStock:
                                              widget.fdNoEntryStockRequest,
                                          user: widget.user,
                                          totalStockRequest: totalStockRequest,
                                          totalDiscount: totalDiscount,
                                          listKeranjang: listKeranjang,
                                          isEndDay: widget.isEndDay,
                                          routeName: 'StockRequestCartForm',
                                          startDayDate: widget.startDayDate)))
                              .then((value) {
                            initLoadPage();
            
                            setState(() {});
                            print(listKeranjang);
                            log('data listBarangSelected back : ${listBarangSelected.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                            log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                          });
                        }
                      }
                    }
            },
            child: Ink(
              height: 70,
              color: ColorHelper.primary,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),),
                    Icon(Icons.skip_next, color: Colors.white,)
                  ],
                ),
              ),
            ),
          )
          
          
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: CustomButtonComponent(
          //     title: 'Next',
          //     onPressed: ()async{
          //       if (formInputKey.currentState!.validate()) {
          //             totalStockRequest = 0;
          //             checkSave = await saveStockRequest();
          //             if (isDecimal == 0) {
          //               // listKeranjang.sort(
          //               //     (a, b) => a.fdKodeBarang.compareTo(b.fdKodeBarang));
          //               listKeranjang.sort((a, b) {
          //                 final kodeCompare =
          //                     a.fdKodeBarang.compareTo(b.fdKodeBarang);
          //                 if (kodeCompare != 0) {
          //                   return kodeCompare;
          //                 } else {
          //                   return a.fdPromosi!.compareTo(b.fdPromosi!);
          //                 }
          //               });
            
          //               log('new listKeranjang: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}, promosi: ${item.fdPromosi})').toList()}');
            
          //               log('data: ${JsonBarangDiskon.map((item) => '(${item.fdDiscount} )').toList()}');
          //               // if (JsonBarangDiskon.isEmpty) {
          //               //   totalDiscount = 0;
          //               // } else if (JsonBarangDiskon[0].message!.isNotEmpty) {
          //               //   totalDiscount = 0;
          //               //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               //     content: Text(
          //               //       JsonBarangDiskon[0].message.toString(),
          //               //     ),
          //               //   ));
          //               // } else {
          //               //   totalDiscount =
          //               //       JsonBarangDiskon.map((item) => item.fdDiscount)
          //               //           .reduce((a, b) => a + b);
          //               //   // Isi fdDiscountDetail pada listKeranjang dari JsonBarangDiskon
          //               //   for (var keranjang in listKeranjang) {
          //               //     final diskon = JsonBarangDiskon.firstWhere(
          //               //       (d) => d.fdKodeBarang == keranjang.fdKodeBarang,
          //               //       orElse: () => mbrg.JsonBarangDiskon(
          //               //         fdKodeBarang: keranjang.fdKodeBarang,
          //               //         fdDiscount: keranjang.fdDiscount ?? 0,
          //               //         fdDiscountDetail: '',
          //               //         fdQty: keranjang.fdQty ?? 0,
          //               //         fdLastUpdate: DateTime.now().toIso8601String(),
          //               //       ),
          //               //     );
          //               //     keranjang.fdDiscountDetail = diskon.fdDiscountDetail;
          //               //     keranjang.fdDiscount = diskon.fdDiscount;
          //               //   }
          //               // }
          //               // print(totalDiscount);
          //               log('data: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, promosi:${item.fdPromosi}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan} ${item.fdNamaJenisSatuan} ${item.fdDiscount} ${item.fdDiscountDetail})').toList()}');
            
          //   //hitung total StockRequest
            
          //               // for (int index = 0;
          //               //     index < listKeranjang.length;
          //               //     index++) {
          //               //   totalStockRequest += listKeranjang[index].fdTotalPrice!;
          //               //   totalDiscount += 0;
          //               // }
            
          //               if (checkSave) {
          //                 Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             settings: const RouteSettings(
          //                                 name: 'StockRequestSummaryForm'),
          //                             builder: (context) => StockSummaryForm(
          //                                 fdNoEntryStock:
          //                                     widget.fdNoEntryStockRequest,
          //                                 user: widget.user,
          //                                 totalStockRequest: totalStockRequest,
          //                                 totalDiscount: totalDiscount,
          //                                 listKeranjang: listKeranjang,
          //                                 isEndDay: widget.isEndDay,
          //                                 routeName: 'StockRequestCartForm',
          //                                 startDayDate: widget.startDayDate)))
          //                     .then((value) {
          //                   initLoadPage();
            
          //                   setState(() {});
          //                   print(listKeranjang);
          //                   log('data listBarangSelected back : ${listBarangSelected.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
          //                   log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
          //                 });
          //               }
          //             }
          //           }
          //     },
          //   ),
          // )
    );
  }
  void _updateTotalItems() {
    setState(() {
      totalItem = textQtyControllers.values.fold(0.0, (prev, controller) {
        final value = controller.text.replaceAll(',', '');
        return prev + (double.tryParse(value) ?? 0.0);
      });
    });
  }
  
}
class SelectedBarangItem extends StatelessWidget {
  final int index;
  final dynamic barang;
  final Map<String, TextEditingController> textQtyControllers;
  final Map<String, List<mbrg.Satuan>> satuanPerBarang;
  final Map<String, String?> satuanSelectedPerBarang;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  const SelectedBarangItem({
    super.key,
    required this.index,
    required this.barang,
    required this.textQtyControllers,
    required this.satuanPerBarang,
    required this.satuanSelectedPerBarang,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final String kodeBarang = barang.fdKodeBarang.trim();
    
    return Container(
      margin: EdgeInsets.only(top: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: Nama Barang & Tombol Hapus
          Container(
            padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4, right: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    barang.fdNamaBarang.trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onRemove,
                  icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 22),
                ),
              ],
            ),
          ),

          // BODY: Input Qty & Dropdown Satuan
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Input Qty
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Jumlah", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: textQtyControllers[kodeBarang] ??= TextEditingController(),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          cother.EnThousandsSeparatorInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onChanged: (value) {
                          final cleanValue = value.replaceAll(',', '');
                          barang.fdQty = double.tryParse(cleanValue) ?? 0.0;
                          onChanged();
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),

                // Dropdown Satuan
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Satuan", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      DropdownSearch<mbrg.Satuan>(
                        items: (filter, props) => satuanPerBarang[kodeBarang] ?? [],
                        itemAsString: (item) => item.fdNamaSatuan!,
                        compareFn: (i, s) => i.fdKodeSatuan == s.fdKodeSatuan,
                        selectedItem: (satuanPerBarang[kodeBarang] ?? []).firstWhere(
                          (item) => item.fdKodeSatuan.trim() == satuanSelectedPerBarang[kodeBarang],
                          orElse: () => mbrg.Satuan(fdKodeSatuan: '', fdNamaSatuan: ''),
                        ),
                        onChanged: (value) async {
                          if (value == null) return;
                          var konv = await cbrg.getKonversiSatuanBarang(kodeBarang);
                          barang.fdKonvB_S = konv[0]['fdKonvB_S'];
                          barang.fdKonvS_K = konv[0]['fdKonvS_K'];
                          satuanSelectedPerBarang[kodeBarang] = value.fdKodeSatuan.trim();
                          barang.fdJenisSatuan = int.tryParse(value.fdKodeSatuan) ?? 9;
                          barang.fdNamaJenisSatuan = value.fdNamaSatuan;
                          onChanged();
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        dropdownBuilder: (context, selectedItem) => Text(
                          selectedItem?.fdNamaSatuan ?? '',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}