import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:crm_apps/orderform_page.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'controller/api_cont.dart' as capi;
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_page.dart';
import 'cust_page.dart';
import 'orderform_page.dart';
import 'orderedit_page.dart';
import 'orderview_page.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/camera.dart' as ccam;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/log_cont.dart' as clog;
import 'models/database.dart' as mdbconfig;
import 'models/order.dart' as modr;
import 'models/langganan.dart' as mlgn;
import 'models/limitkredit.dart' as mlk;
import 'models/logdevice.dart' as mlog;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;

bool stateSelectAll = false;
bool stateLangganan = false;
bool stateRute = false;
bool stateInvoice = false;
bool statePriceDiskon = false;
bool stateBarangStock = false;
bool stateHakAkses = false;

class SyncPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;

  const SyncPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.startDayDate});

  @override
  State<SyncPage> createState() => LayerSync();
}

class LayerSync extends State<SyncPage> {
  List<bool> selected = [false, false, false, false, false, false];
  bool selectAll = false;
  bool isLoading = false;
  bool isLoadButton = false;

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

  void yesNoDialogForm(int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: const Text('Lanjut hapus?')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (!mounted) return;

                    Navigator.pop(context);
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

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (int i = 0; i < selected.length; i++) {
        selected[i] = selectAll;
      }
    });
  }

  void toggleItem(int index, bool? value) {
    setState(() {
      selected[index] = value ?? false;
      selectAll = selected.every((item) => item); // update selectAll
      if (index == 0) {
        stateSelectAll = true;
      }
    });
  }

  Future<void> _confirmSyncData() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Container(
                color: css.titleDialogColor(),
                padding: const EdgeInsets.all(5),
                child: const Text('Lanjut sinkron data?')),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      Navigator.pop(context);

                      await syncData(1);
                      initLoadPage();
                    } catch (e) {
                      if (e == 408) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error timeout')));
                        await sessionExpired();
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('error: $e')));
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

  Future<void> syncData(int syncTipe) async {
    try {
      setState(() {
        isLoading = true;
        stateSelectAll = false;
        stateLangganan = false;
        stateRute = false;
        stateInvoice = false;
        statePriceDiskon = false;
        stateBarangStock = false;
        stateHakAkses = false;
      });

      bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

      if (isDateTimeSettingValid) {
        int responseCode = 0;
        int checkPlano = 0;
        final chosen = <String>[];
        for (int i = 0; i < selected.length; i++) {
          if (selected[i] == true) {
            if (i == 0) {
              setState(() {
                stateLangganan = true;
              });
            } else if (i == 1) {
              setState(() {
                stateRute = true;
              });
            } else if (i == 2) {
              setState(() {
                stateInvoice = true;
              });
            } else if (i == 3) {
              setState(() {
                statePriceDiskon = true;
              });
            } else if (i == 4) {
              setState(() {
                stateBarangStock = true;
              });
            } else if (i == 5) {
              setState(() {
                stateHakAkses = true;
              });
            }
          }
        }
        responseCode = await capi.validasiFMsSalesForce(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        if (stateLangganan == true) {
          responseCode = await capi.getLanggananAlamat(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.setProvinsi(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.setKabupaten(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.setKecamatan(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.setKelurahan(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.setTipeOutlet(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getAllReasonNotVisit(widget.user);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getFMsSaBarangTOP(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getFMsSaLanggananTOP(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getFmsBank(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getRuteLangganan(
              widget.user.fdToken,
              widget.user.fdKodeSF,
              widget.user.fdKodeDepo,
              widget.startDayDate);
          if (responseCode == 401) {
            await sessionExpired();
          }
        }

        responseCode = await capi.getAllDataTipeDetail(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        if (stateInvoice == true) {
          responseCode = await capi.getPiutangDagang(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getPiutangDagangFaktur(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getSyncRencanaRute(
              widget.user.fdToken,
              widget.user.fdKodeSF,
              '1',
              widget.user.fdKodeDepo,
              widget.startDayDate);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getSyncRencanaRuteLangganan(
              widget.user.fdToken,
              widget.user.fdKodeSF,
              '2',
              widget.user.fdKodeDepo,
              widget.startDayDate);
          if (responseCode == 401) {
            await sessionExpired();
          }
          // responseCode = await capi.getRencanaRuteLangganan(
          //     widget.user.fdToken,
          //     widget.user.fdKodeSF,
          //     widget.user.fdKodeDepo,
          //     widget.startDayDate);
          // if (responseCode == 401) {
          //   await sessionExpired();
          // }
          responseCode = await capi.getListInvoice(
              widget.user.fdToken,
              widget.user.fdKodeSF,
              '3',
              widget.user.fdKodeDepo,
              widget.startDayDate);
          if (responseCode == 401) {
            await sessionExpired();
          }
        }

        if (statePriceDiskon == true) {
          responseCode = await capi.getDataHargaJualBarang(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getAllDataDiskon(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getAllDataDiskonDetail(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.setTipeHarga(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
        }

        if (stateBarangStock == true) {
          responseCode = await capi.getAllBarang(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }

          responseCode = await capi.getAllGroupBarang(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getAllBarangSales(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getMasterHanger(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
          responseCode = await capi.getDetailMasterHanger(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo);
          if (responseCode == 401) {
            await sessionExpired();
          }
        }

        responseCode = await capi.getDataParam(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getDataGudangSales(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Sukses sync data')));
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      rethrow;
    }
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> initLoadPage() async {
    late Database db;

    try {
      setState(() {
        isLoading = true;
      });
      await handlePermission();
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isLoadButton = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    } finally {
      db.isOpen ? await db.close() : null;
    }
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
            title: const Text('Synchronize Data'),
            leading: !isLoading
                ? IconButton(
                    onPressed: () {
                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(user: widget.user)),
                          (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                  )
                : const Padding(padding: EdgeInsets.zero),
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
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            backgroundColor: Colors.yellow,
            color: Colors.red,
            strokeWidth: 2,
            onRefresh: () async {
              initLoadPage();

              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: isLoading
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: css.boxDecorMenuHeader(),
                          child: Text(
                              '${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
                              style: css.textHeaderBold())),
                      const Padding(padding: EdgeInsets.all(5)),
                      const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                              'Silahkan pilih yang ingin di sinkronisasi')),
                      CheckboxListTile(
                        title: const Text("Select All"),
                        value: selectAll,
                        onChanged: toggleSelectAll,
                      ),
                      CheckboxListTile(
                        title: const Text("Langganan"),
                        value: selected[0],
                        onChanged: (value) => toggleItem(0, value),
                      ),
                      CheckboxListTile(
                        title: const Text("Rute"),
                        value: selected[1],
                        onChanged: (value) => toggleItem(1, value),
                      ),
                      CheckboxListTile(
                        title: const Text("List Invoice"),
                        value: selected[2],
                        onChanged: (value) => toggleItem(2, value),
                      ),
                      CheckboxListTile(
                        title: const Text("Price List, Diskon dan Promo"),
                        value: selected[3],
                        onChanged: (value) => toggleItem(3, value),
                      ),
                      CheckboxListTile(
                        title: const Text("Master Barang dan Stock"),
                        value: selected[4],
                        onChanged: (value) => toggleItem(4, value),
                      ),
                      CheckboxListTile(
                        title: const Text("Hak Akses"),
                        value: selected[5],
                        onChanged: (value) => toggleItem(5, value),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: isLoading
              ? Center(
                  child: loadingProgress(ScaleSize.textScaleFactor(context)))
              : Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: BottomAppBar(
                    height: 40 * ScaleSize.textScaleFactor(context),
                    child: TextButton(
                      onPressed: (() async {
                        await _confirmSyncData();
                      }),
                      child: const Text('Synchronize'),
                    ),
                  ),
                )),
    );
  }
}
