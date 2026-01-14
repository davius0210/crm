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
import 'stockrequest_page.dart';
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
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

List<MultiSelectItem> listSatuan = [
  MultiSelectItem(0, 'Kecil'),
  MultiSelectItem(1, 'Sedang'),
  MultiSelectItem(2, 'Besar'),
];

class StockSummaryForm extends StatefulWidget {
  final msf.Salesman user;
  final String fdNoEntryStock;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;
  final double totalDiscount;
  final double totalStockRequest;
  final List listKeranjang;

  const StockSummaryForm(
      {super.key,
      required this.user,
      required this.fdNoEntryStock,
      required this.totalDiscount,
      required this.totalStockRequest,
      required this.listKeranjang,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<StockSummaryForm> createState() => LayerStockSummaryFormPage();
}

class LayerStockSummaryFormPage extends State<StockSummaryForm> {
  bool isLoading = false;
  List<mstoc.Stock> listOrder = [];
  List<mstoc.Stock> listOrderExist = [];
  List<mstoc.StockItem> listOrderItem = [];
  List<mstoc.Stock> listGetDataOrder = [];
  List<mbrg.Barang> listBarang = [];
  List<mbrg.BarangSelected> listKeranjang = [];
  List<mbrg.BarangSelected> tempBarangSelected = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  // List<mpro.ViewBarangPromo> barangs = [];
  List<msf.GudangSales> listGudang = [];
  String? gudangSelected;
  String? satuanSelected;

  // mlgn.Langganan? barangSelected;
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
  String kodeGudang = '';
  String kodeGudangSF = '';

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
      log('getdata: ${widget.listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan}, isHanger: ${item.isHanger})').toList()}');

      if (widget.fdNoEntryStock.isNotEmpty) {
        listGetDataOrder = await cstk
            .getDataStockRequestHeaderByNoEntry(widget.fdNoEntryStock);
        // gudangSelected = widget.user.fdKodeGudangSF;
        txtTanggalKirim.text = param.dtFormatViewMMM.format(
            param.dtFormatDB.parse(listGetDataOrder.first.fdTanggalKirim!));
      }
      listGudang = await csf.getListGudangSales();
      kodeGudang = listGudang[0].fdKodeGudang;
      kodeGudangSF = listGudang[0].fdKodeGudangSF;

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
        totalDiskon = widget.totalDiscount + totalPromosiExtra;
        grandTotal =
            widget.totalStockRequest - widget.totalDiscount - totalPromosiExtra;
      });
      listOrder = [
        mstoc.Stock(
          fdDepo: widget.user.fdKodeDepo,
          fdKodeLangganan: '0',
          fdTanggal: widget.startDayDate,
          fdNoEntryStock: noEntry,
          fdNoOrder: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: widget.listKeranjang.fold(
            0,
            (prev, item) =>
                prev +
                (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ?? 0),
          ),
          fdQtyStockK: widget.listKeranjang.fold(
            0,
            (prev, item) =>
                prev +
                (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          ),
          fdTotalStock: widget.totalStockRequest,
          fdTotalStockK: widget.totalStockRequest,
          fdJenisSatuan: '', //item.fdSatuan,
          fdTanggalKirim: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd MMM yyyy').parse(txtTanggalKirim.text)),
          fdAlamatKirim: '',
          fdKodeGudang: kodeGudang,
          fdKodeGudangSF: kodeGudangSF,
          fdLastUpdate: param.dtFormatDB.format(DateTime.now()),
        )
      ];
      List<mstoc.Stock> header = listOrder.toList();

      var index = 0;
      listOrderItem = widget.listKeranjang.map((item) {
        return mstoc.StockItem(
          fdNoEntryStock: noEntry,
          fdNoUrutStock: index++,
          fdKodeBarang: item.fdKodeBarang,
          fdNamaBarang: item.fdNamaBarang,
          fdPromosi: item.fdPromosi.toString(),
          fdReplacement: '',
          fdJenisSatuan: item.fdJenisSatuan.toString(),
          fdQtyStock:
              (double.tryParse(item.fdQty?.toString() ?? '0')?.toInt() ??
                  0), //item.fdQty,
          fdQtyStockK:
              (double.tryParse(item.fdQtyK?.toString() ?? '0')?.toInt() ?? 0),
          fdUnitPrice: item.fdUnitPrice,
          fdUnitPriceK: item.fdUnitPriceK,
          fdBrutto: item.fdTotalPrice,
          fdDiscount: 0, //item.fdPromosi.toDouble(),
          fdDiscountDetail: '', //0, //
          fdNetto: item.fdTotalPrice,
          fdNoPromosi: '',
          fdNotes: '',
          fdQtyPBE: 0,
          fdQtySJ: 0,
          isHanger: item.isHanger,
          isShow: item.isShow,
          urut: item.urut,
          fdLastUpdate: param.dtFormatDB.format(DateTime.now()),
        );
      }).toList();
      List<mstoc.StockItem> items = listOrderItem.toList();

      // if (widget.fdNoEntryStock.isNotEmpty) {
      //   await cstk.updateStockBatch(header);
      //   await cstk.updateStockItemBatch(items);
      // } else {
      //   await cstk.insertStockBatch(header);
      //   await cstk.insertStockItemBatch(items);
      // }

      Map<String, dynamic> mapResult = await capi.sendStockRequestToServer(
          noEntry, widget.user, widget.startDayDate, header, items);

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        // await cstk.updateStatusSentStock(noEntry, widget.startDayDate);
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data tersimpan')));
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
        title: const Text('Summary Pesanan'),
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
                    if (widget.listKeranjang.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.listKeranjang.length,
                        itemBuilder: (context, index) {
                          final barang = widget.listKeranjang[index];
                          return barang.isShow == '1'
                              ? Padding(
                                  padding: const EdgeInsets.all(
                                      5), //const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${barang.fdNamaBarang.trim()}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Nama barang
                                            Text(
                                              '${param.enNumberFormatQty.format(widget.listKeranjang[index].fdQty)} ${widget.listKeranjang[index].fdNamaJenisSatuan!}',
                                              style: TextStyle(
                                                  // fontStyle: FontStyle.italic,
                                                  color: widget
                                                              .listKeranjang[
                                                                  index]
                                                              .fdPromosi ==
                                                          '0'
                                                      ? Colors.black
                                                      : Colors.green[700]),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // const Divider(thickness: 1),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    const Divider(thickness: 2, color: Colors.orange),
                    const Padding(padding: EdgeInsets.all(5)),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: DropdownSearch<msf.GudangSales>(
                          items: (String filter, LoadProps? loadProps) =>listGudang,
                          selectedItem:
                              listGudang.isNotEmpty ? listGudang.first : null,
                          itemAsString: (msf.GudangSales? u) =>
                              u?.fdNamaGudangSF ?? '',
                          enabled: false,
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
                                  item.fdNamaGudangSF,
                                  style: css.textSmallSizeBlack(),
                                ),
                              );
                            },
                            menuProps:
                                MenuProps(shape: css.borderOutlineInputRound()),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: css.textInputStyle(
                              'Gudang',
                              const TextStyle(fontStyle: FontStyle.italic),
                              'Gudang',
                              null,
                              null,
                            ),
                          ),
                          onChanged: (msf.GudangSales? value) {
                            setState(() {
                              gudangSelected = value?.fdKodeGudangSF.trim();
                            });
                          },
                          filterFn: (item, String filter) {
                            return item.fdKodeGudangSF
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                item.fdNamaGudangSF
                                    .toLowerCase()
                                    .contains(filter.toLowerCase());
                          },
                        )),
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
                  if (txtTanggalKirim.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Tanggal Kirim tidak boleh kosong!'),
                    ));
                    return;
                  }
                  if (formInputKey.currentState!.validate()) {
                    // grandTotal = widget.totalStockRequest -
                    //     widget.totalDiscount -
                    //     totalPromosiExtra +
                    //     orderExist;
                    // print(
                    //     'widget.totalStockRequest: ${widget.totalStockRequest}');
                    // print('widget.totalDiscount: ${widget.totalDiscount}');
                    // print('orderExist: $orderExist');
                    // print('sisaLK: $sisaLK');
                    // print('Grand Total: $grandTotal');
                    // if (sisaLK < grandTotal) {
                    // } else {
                    //   await saveStockRequest();
                    // }
                    await saveStockRequest();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: const RouteSettings(name: 'stock'),
                                builder: (context) => StockRequestPage(
                                    user: widget.user,
                                    isEndDay: widget.isEndDay,
                                    routeName: 'stock',
                                    startDayDate: widget.startDayDate)))
                        .then((value) {
                      initLoadPage();

                      setState(() {});
                    });
                  }
                },
                child: const Text('Create Stock Request'),
              ),
            ),
    );
  }
}
