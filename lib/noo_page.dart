import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/material.dart';
import 'nooform_page.dart';
import 'nooedit_page.dart';
import 'noo_cust_page.dart';
import 'controller/noo_cont.dart' as cnoo;
import 'controller/order_cont.dart' as codr;
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'noo_orderform_page.dart';
import 'noo_orderedit_page.dart';
import 'models/noo.dart';
import 'models/salesman.dart' as msf;
import 'package:path/path.dart' as cpath;
import 'models/database.dart' as cdbconfig;
import 'style/css.dart' as css;

List<viewNOO> _listNOO = [];

bool newValue = false;
late Database db;
String fdKodeNoo = '';
int stateDelete = 0;
String stsToko = '';

class NOOPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final bool isEndDay;
  final String startDayDate;

  const NOOPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<NOOPage> createState() => LayerNOO();
}

class LayerNOO extends State<NOOPage> {
  TextEditingController dateinput = TextEditingController();
  List<Map<String, dynamic>> resultMaps = [];
  bool isLoading = false;

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

      _listNOO.clear();
      await getListNOO();

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

  Future<List<viewNOO>> getListNOO() async {
    _listNOO.clear();

    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, cdbconfig.dbName);
    final db = await openDatabase(dbFullPath, version: 1);

    // resultMaps = await db.rawQuery(
    //     '''SELECT a.fdKodeNoo ,a.fdDepo ,a.fdKodeSF ,a.fdNamaToko ,a.fdAlamat
    // ,a.fdKelurahan ,a.fdLA ,a.fdLG ,a.fdTipeOutlet ,a.fdKelasOutlet ,a.fdKodeRute
    // ,a.fdTokoLuar1 ,a.fdNpwpImg ,a.fdTokoDalam1 ,a.fdKtpImg ,a.fdStatusSent ,
    // b.fdTipeOutlet as fdTipeOutletName, a.fdOwner, a.fdLimitKredit,
    // c.fdNoEntryOrder
    // FROM ${cdbconfig.tblNOO} a
    // INNER JOIN ${cdbconfig.tblTipeOutletMD} b ON a.fdTipeOutlet=b.fdKodeTipe
    // LEFT JOIN ${cdbconfig.tblOrder} c ON a.fdKodeNoo=c.fdKodeLangganan
    // ''');

    resultMaps = await db.rawQuery(
        '''SELECT a.fdKodeNoo ,a.fdDepo ,a.fdKodeSF ,a.fdNamaToko ,a.fdAlamat
    ,a.fdKelurahan ,a.fdLA ,a.fdLG ,a.fdTipeOutlet ,a.fdKelasOutlet ,a.fdKodeRute 
    ,a.fdTokoLuar1 ,a.fdNpwpImg ,a.fdTokoDalam1 ,a.fdKtpImg ,a.fdStatusSent , 
    b.fdTipeOutlet as fdTipeOutletName, a.fdOwner, a.fdLimitKredit 
    FROM ${cdbconfig.tblNOO} a 
    INNER JOIN ${cdbconfig.tblTipeOutletMD} b ON a.fdTipeOutlet=b.fdKodeTipe   
    ''');

    for (var element in resultMaps) {
      setState(() {
        _listNOO.add(viewNOO.fromJson(element));
      });
    }
    List<viewNOO> listNOO = List.generate(resultMaps.length, (i) {
      return viewNOO(
          fdNoEntryMobile: resultMaps[i]['fdNoEntryMobile'],
          fdKodeNoo: resultMaps[i]['fdKodeNoo'],
          fdDepo: resultMaps[i]['fdDepo'],
          fdKodeSF: resultMaps[i]['fdKodeSF'],
          fdNamaToko: resultMaps[i]['fdNamaToko'],
          fdAlamat: resultMaps[i]['fdAlamat'],
          fdCity: resultMaps[i]['fdCity'] ?? '',
          fdDC: resultMaps[i]['fdDC'] ?? '',
          fdLA: resultMaps[i]['fdLA'] ?? '',
          fdLG: resultMaps[i]['fdLG'] ?? '',
          fdLokasi: resultMaps[i]['fdLokasi'],
          fdTipeOutlet: resultMaps[i]['fdTipeOutlet'],
          fdTipeHarga: resultMaps[i]['fdTipeHarga'],
          fdGroupOutlet: resultMaps[i]['fdGroupOutlet'],
          fdKodeRute: resultMaps[i]['fdKodeRute'],
          fdKodeExternal: resultMaps[i]['fdKodeExternal'],
          fdChiller: resultMaps[i]['fdChiller'] ?? 0,
          fdTokoLuar1: resultMaps[i]['fdTokoLuar1'],
          fdTokoLuar2: resultMaps[i]['fdTokoLuar2'],
          fdTokoDalam1: resultMaps[i]['fdTokoDalam1'],
          fdTokoDalam2: resultMaps[i]['fdTokoDalam2'],
          fdStatusSent: resultMaps[i]['fdStatusSent'],
          fdLastproses: resultMaps[i]['fdLastproses'],
          fdGroupLangganan: resultMaps[i]['fdGroupLangganan'],
          fdTipeOutletName: resultMaps[i]['fdTipeOutletName'],
          fdNoEntryOrder: resultMaps[i]['fdNoEntryOrder'],
          fdLimitKredit: resultMaps[i]['fdLimitKredit'],
          fdKelasOutlet: resultMaps[i]['fdKelasOutlet'],
          fdContactPerson: resultMaps[i]['fdContactPerson'] ?? '',
          fdPhone: resultMaps[i]['fdPhone'] ?? '',
          fdIsPaused: resultMaps[i]['fdIsPaused'] ?? 0,
          fdTanggalActivity: resultMaps[i]['fdTanggalActivity'] ?? '',
          fdStartVisitDate: resultMaps[i]['fdStartVisitDate'] ?? '',
          fdEndVisitDate: resultMaps[i]['fdEndVisitDate'] ?? '',
          fdNotVisitReason: resultMaps[i]['fdNotVisitReason'] ?? '',
          fdKodeReason: resultMaps[i]['fdKodeReason'] ?? '',
          fdReason: resultMaps[i]['fdReason'] ?? '',
          fdCancelVisitReason: resultMaps[i]['fdCancelVisitReason'] ?? '',
          fdCreateDate: resultMaps[i]['fdCreateDate'],
          fdUpdateDate: resultMaps[i]['fdUpdateDate']);
    });
    return Future.value(listNOO);
  }

  void yesNoDialogForm(int index) {
      FunctionHelper.AlertDialogCip(
        context,
        DialogCip(
          title: 'Hapus',
          message: 'Lanjut hapus data langganan?',
          onOk: () async {
            try {
              // 1. Eksekusi proses penghapusan data NOO via API/Database
              stateDelete = await cnoo.deleteByNoEntry(
                widget.user.fdToken, 
                _listNOO[index].fdKodeNoo!,
              );

              // 2. Jika berhasil (state == 1), refresh halaman
              if (stateDelete == 1) {
                initLoadPage();
              }

              // 3. Safety check mounted sebelum navigasi
              if (!mounted) return;

              // 4. Tutup Dialog
              Navigator.pop(context);
              
            } catch (e) {
              // Handle error dengan SnackBar
              if (mounted) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('error: $e')));
              }
            }
          },
        ),
      );
  }

  void yesNoDialogFormOrder(String fdNoEntryOrder) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus data order?',
        onOk: () async {
          try {
            // 1. Eksekusi proses penghapusan data order
            stateDelete = await codr.deleteByNoEntry(
              widget.user.fdToken, 
              fdNoEntryOrder,
            );

            // 2. Jika berhasil dihapus (state == 1), refresh data halaman
            if (stateDelete == 1) {
              initLoadPage();
            }

            // 3. Safety check untuk memastikan widget masih terpasang
            if (!mounted) return;

            // 4. Tutup dialog
            Navigator.pop(context);

          } catch (e) {
            // Handle error dengan SnackBar
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('error: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Registrasi Langganan Baru'),
        ),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          backgroundColor: Colors.yellow,
          color: Colors.red,
          strokeWidth: 2,
          onRefresh: () async {
            initLoadPage();

            return Future.delayed(const Duration(milliseconds: 500));
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              isLoading
                  ? Center(
                      child:
                          loadingProgress(ScaleSize.textScaleFactor(context)))
                  : Flexible(
                      child: StatefulBuilder(builder: (context, setState) {
                      return ListView.builder(
                        key: UniqueKey(),
                        padding: const EdgeInsets.all(5),
                        itemCount: _listNOO.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: 'NOOEdit'),
                                        builder: (context) => NOOEditPage(
                                            user: widget.user,
                                            noentry: _listNOO[index].fdKodeNoo!,
                                            routeName: 'NOOEdit',
                                            startDayDate: widget
                                                .startDayDate))).then((value) {
                                  initLoadPage();

                                  setState(() {});
                                });
                              },
                              child: Card(
                                elevation: 3,
                                color: _listNOO[index].fdStatusSent == 1
                                    ? const Color.fromARGB(255, 7, 124, 23)
                                    : const Color.fromARGB(255, 255, 255, 255),
                                shadowColor: Colors.blue,
                                shape: css.boxStyle(),
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      _listNOO[index]
                                                          .fdKodeNoo!,
                                                      style: _listNOO[index]
                                                                  .fdStatusSent ==
                                                              1
                                                          ? css
                                                              .textHeaderNormal()
                                                          : null),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(3)),
                                                  Text(
                                                      '${_listNOO[index].fdNamaToko}',
                                                      style: _listNOO[index]
                                                                  .fdStatusSent ==
                                                              1
                                                          ? css.textHeaderBold()
                                                          : css
                                                              .textNormalBold()),
                                                  Text(
                                                      '${_listNOO[index].fdTipeOutlet} - ${_listNOO[index].fdTipeOutletName}',
                                                      style: _listNOO[index]
                                                                  .fdStatusSent ==
                                                              1
                                                          ? css
                                                              .textHeaderNormal()
                                                          : null),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(3)),
                                                  Text(
                                                      _listNOO[index].fdAlamat!,
                                                      style: _listNOO[index]
                                                                  .fdStatusSent ==
                                                              1
                                                          ? css
                                                              .textHeaderNormal()
                                                          : null),
                                                ]),
                                          ),
                                          _listNOO[index].fdStatusSent! == 0
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      yesNoDialogForm(index);
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        size: 24 *
                                                            ScaleSize
                                                                .textScaleFactor(
                                                                    context)),
                                                    color: Colors.red,
                                                    tooltip: 'Delete',
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         settings:
                                                      //             const RouteSettings(
                                                      //                 name:
                                                      //                     'NooOrderForm'),
                                                      //         builder: (context) => NooOrderFormPage(
                                                      //             fdNoEntryOrder:
                                                      //                 fdKodeNoo
                                                      //                     .toString(),
                                                      //             lgn: _listNOO[
                                                      //                 index],
                                                      //             user: widget
                                                      //                 .user,
                                                      //             isEndDay: widget
                                                      //                 .isEndDay,
                                                      //             routeName:
                                                      //                 'NooOrderForm',
                                                      //             startDayDate:
                                                      //                 widget
                                                      //                     .startDayDate))).then(
                                                      //     (value) {
                                                      //   initLoadPage();

                                                      //   setState(() {});
                                                      // });
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => NooCustomerPage(
                                                                  fdKodeLangganan:
                                                                      _listNOO[
                                                                              index]
                                                                          .fdKodeNoo!,
                                                                  user: widget
                                                                      .user,
                                                                  routeName: widget
                                                                      .routeName,
                                                                  isEndDay: widget
                                                                      .isEndDay,
                                                                  startDayDate:
                                                                      widget
                                                                          .startDayDate)));
                                                    },
                                                    icon: Icon(
                                                        Icons.location_history,
                                                        size: 24 *
                                                            ScaleSize
                                                                .textScaleFactor(
                                                                    context)),
                                                    color: Colors.white,
                                                    tooltip: 'Start Visit',
                                                  ),
                                                )
                                        ])),
                              ));
                        },
                      );
                    })),
            ]),
          ),
        ),
        floatingActionButton: isLoading
            ? const Padding(padding: EdgeInsets.zero)
            : !widget.isEndDay
                ? FloatingActionButton(
                    tooltip: 'New',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(name: 'nooForm'),
                              builder: (context) => NooFormPage(
                                  user: widget.user,
                                  routeName: 'nooForm',
                                  startDayDate: widget.startDayDate))).then(
                          (value) {
                        initLoadPage();

                        setState(() {});
                      });
                    },
                    child: Icon(Icons.add,
                        size: 24 * ScaleSize.textScaleFactor(context), color: Colors.white,),
                  )
                : null);
  }
}
