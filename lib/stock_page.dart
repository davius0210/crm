import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crm_apps/stockverification_page.dart';
import 'package:crm_apps/stockunloading_page.dart';
import 'package:crm_apps/rute_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'custinfo_page.dart';
import 'main.dart';
import 'home_page.dart';
import 'stockrequest_page.dart';
import 'controller/database_cont.dart' as cdb;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/barang_cont.dart' as cbrg;
import 'controller/stock_cont.dart' as cstk;
import 'controller/other_cont.dart' as cother;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/stock.dart' as mstk;
import 'models/globalparam.dart' as param;
import 'models/database.dart' as mdbconfig;

class StockPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const StockPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<StockPage> createState() => LayerStock();
}

class LayerStock extends State<StockPage> {
  mlgn.Langganan lgn = mlgn.Langganan.empty();
  List<mstk.ViewStockItem> listStock = [];
  List<mstk.ViewStockItem> _filteredItems = [];
  List<mbrg.Barang> listBarang = [];
  List<mbrg.BarangSelected> listBarangSelected = [];
  Map<String, String?> satuanSelectedPerBarang = {};
  Map<String, List<mbrg.Satuan>> satuanPerBarang = {};
  Map<String, TextEditingController> textQtyControllers = {};
  List<Map<String, dynamic>> konversiSatuanBarang = [];
  bool isLoading = false;
  bool isLoadButton = false;
  String? barangSelected;
  String? satuanSelected;
  String errMessage = '';
  String startTimeVisit = '';
  String endTimeVisit = '';
  String pauseActivity = '03';
  String endVisitActivity = '03';
  String sNote = '';
  bool isPaused = false;
  bool isReasonEmpty = false;
  double? qty = 0;
  TextEditingController txtReasonLain = TextEditingController();
  TextEditingController txtCancelReasonLain = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  ScrollController scrollControllerNotes = ScrollController();
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();

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
      isPaused = lgn.fdIsPaused == 1 ? true : false;
      startTimeVisit = lgn.fdStartVisitDate!.isNotEmpty
          ? param.timeFormatView
              .format(param.dateTimeFormatDB.parse(lgn.fdStartVisitDate!))
          : '';
      endTimeVisit = lgn.fdEndVisitDate!.isNotEmpty
          ? param.timeFormatView
              .format(param.dateTimeFormatDB.parse(lgn.fdEndVisitDate!))
          : '';
      listStock = await cstk.infoStock();
      if (listStock.isNotEmpty) {
        _filteredItems = listStock;
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
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<Uint8List> getImageBytes(String assetImg) async {
    ByteData? data;
    await rootBundle.load(assetImg).then((value) {
      data = value;
    });

    return data!.buffer.asUint8List(data!.offsetInBytes, data!.lengthInBytes);
  }

  Future<bool> saveNote(String? fdKodeLangganan, String fdNote) async {
    try {
      await clgn.insertNoteLanggananAct(
          fdKodeLangganan!,
          widget.user.fdKodeDepo,
          widget.user.fdKodeSF,
          widget.startDayDate,
          '',
          '',
          'Note',
          fdNote);

      if (!mounted) return false;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Note tersimpan')));

      setState(() {});

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));

      return false;
    }
  }

  void _filterList(String searchText) {
    _filteredItems = [];

    setState(() {
      for (var element in listStock) {
        if (element.fdKodeBarang!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            element.fdNamaBarang!
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          _filteredItems.add(element);
        }
      }
    });
  }

  void alertScaffold(String msg) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: !isLoading
          ? () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(user: widget.user)),
                  (Route<dynamic> route) => false);

              return false;
            }
          : () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stock'),
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
                      '${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
                      style: css.textHeaderBold())),
              Flexible(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (text) {
                                _filterList(text);
                              },
                              autocorrect: false,
                              decoration: css.textInputStyle(
                                  'Search (barang dan group barang)',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  null,
                                  Icon(Icons.search,
                                      size: 24 *
                                          ScaleSize.textScaleFactor(context)),
                                  null),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      'Qty',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),

                                    // const Divider(thickness: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_filteredItems.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final barang = _filteredItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(barang.fdKodeBarang!.trim()),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(barang.fdNamaBarang!.trim()),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          '${param.enNumberFormatDec.format(barang.ktn)}/${param.enNumberFormatDec.format(barang.lsn)}/${param.enNumberFormatDec.format(barang.pcs)}'),
                                    ),
                                  ],
                                ),
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
            ? const Padding(padding: EdgeInsets.zero)
            : BottomAppBar(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                height: (150 * ScaleSize.textScaleFactor(context)),
                color: Colors.grey.shade300, // Colors.green[100],
                shape: const CircularNotchedRectangle(),
                clipBehavior: Clip.hardEdge,
                child:
                    // SingleChildScrollView(
                    //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: createMenu())),
                    Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  settings: const RouteSettings(
                                                      name: 'stockrequest'),
                                                  builder: (context) =>
                                                      StockRequestPage(
                                                          user: widget.user,
                                                          routeName:
                                                              'stockrequest',
                                                          isEndDay:
                                                              widget.isEndDay,
                                                          startDayDate: widget
                                                              .startDayDate))).then(
                                              (value) {
                                            initLoadPage();

                                            setState(() {});
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.orange,
                                                    width: 1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Image.asset(
                                                  'assets/images/stockRequest.png',
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Stock Request',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  settings: const RouteSettings(
                                                      name:
                                                          'stockverification'),
                                                  builder: (context) =>
                                                      StockVerificationPage(
                                                          user: widget.user,
                                                          routeName:
                                                              'stockverification',
                                                          isEndDay:
                                                              widget.isEndDay,
                                                          startDayDate: widget
                                                              .startDayDate))).then(
                                              (value) {
                                            initLoadPage();

                                            setState(() {});
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.orange,
                                                    width: 1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Image.asset(
                                                  'assets/images/stockVerification.png',
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Stock Verification',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  settings: const RouteSettings(
                                                      name: 'unloading'),
                                                  builder: (context) =>
                                                      StockUnloadingPage(
                                                          user: widget.user,
                                                          isEndDay:
                                                              widget.isEndDay,
                                                          routeName:
                                                              'unloading',
                                                          startDayDate: widget
                                                              .startDayDate))).then(
                                              (value) {
                                            initLoadPage();

                                            setState(() {});
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.orange,
                                                    width: 1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Image.asset(
                                                  'assets/images/unloadingStock.png',
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Unloading Stock',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
