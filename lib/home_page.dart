import 'dart:io';
import 'package:crm_apps/listinvoice_page.dart';
import 'package:crm_apps/new/component/custom_button_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:crm_apps/new/page/home/controller/home_controller.dart';
import 'package:crm_apps/new/page/home/view/home_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crm_apps/coveragearea_page.dart';
import 'package:crm_apps/limitkredit_page.dart';
import 'package:get/get.dart';
import 'backup_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart' as badges;
import 'main.dart';
import 'nonrute_page.dart';
import 'noo_page.dart';
import 'rute_page.dart';
import 'stock_page.dart';
import 'rencanarute_page.dart';
import 'startday_page.dart';
import 'endday_page.dart';
import 'sync_page.dart';
import 'pdf_lash_page.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/other_cont.dart' as cother;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/order_cont.dart' as codr;
import 'controller/rute_cont.dart' as crute;
import 'controller/stock_cont.dart' as cstock;
import 'controller/log_cont.dart' as clog;
import 'package:path/path.dart' as cpath;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;
import 'models/package.dart' as mpck;
import 'models/logdevice.dart' as mlog;
import 'style/css.dart' as css;

class HomePage extends StatefulWidget {
  final msf.Salesman user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => LayerHome();
}

class LayerHome extends State<HomePage> {
  HomeController cHome = Get.put(HomeController());
  bool isLoading = false;
  String startDayActivity = '01';
  String endDayActivity = '05';
  bool isStartDay = false;
  bool isEndDay = false;
  bool isNonRuteValid = false;
  bool isRencanaRuteExists = false;
  bool isStockVerifyExists = false;
  String startDayDate = '';
  String todayDate = '';
  String? fdJamStartDay = '';
  String? fdKmStartDay = '';
  String? fdJamEndDay = '';
  String? fdKmEndDay = '';
  String version = '';
  String zipNameBackup = '';
  Position? posGPS = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0);
  List<String> _arrBackup = [];
  List<String> _arrTemp = [];
  List<String> _arrDelete = [];
  List<mlog.Param> listParam = [];
  int maxBackup = 3;
  int countNoo = 0;
  int countCall = 0;
  int countOrderCZ = 0;
  int countOrderALK = 0;
  double totalOrderCZ = 0;
  double totalOrderALK = 0;
  double omzetLusinCZ = 0;
  double omzetKartonALK = 0;

  List<Map<dynamic, dynamic>> listNotif = [];
  Map<String, dynamic> mapSFSummary = {
    'rute': 0,
    'nonrute': 0,
    'ec': 0,
    'notvisit': 0,
    'call': 0
  };

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadPage();
    });
    super.initState();
  }

  Future<void> checkPackage() async {
    PackageInfo packInfo = await PackageInfo.fromPlatform();
    version = packInfo.version;
    try {
      mpck.Package latestPackage = await capi.getPackage(packInfo.appName);

      int iVersion = int.parse(version.replaceAll('.', ''));
      int iLatestVersion =
          int.parse(latestPackage.fdVersion.replaceAll('.', ''));

      if (iVersion < iLatestVersion) {
        await sessionExpired();
        if (!mounted) return;
        alertDialogForm('Ada update App terbaru', context);
      }
    } catch (e) {
      // Tidak balik return alert, masih bisa lanjut proses
    }
  }

  Future<void> deleteZip() async {
    _arrBackup = [];
    _arrTemp = [];
    _arrDelete = [];
    listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
    if (listParam.isNotEmpty) {
      maxBackup = listParam[0].fdMaxBackup;
      String filePath = '${param.appDir}/BACKUP';

      if (Directory(filePath).existsSync()) {
        var listZip = Directory(filePath).listSync().where((element) {
          if (cpath.extension(element.path) == '.zip') {
            return true;
          } else {
            return false;
          }
        });
        for (var element in listZip) {
          var pathfile = element.path.toString();
          var nmfile = cpath.basenameWithoutExtension(pathfile);
          var results = listZip.where((fileZip) {
            zipNameBackup = cpath.basenameWithoutExtension(fileZip.path);

            if (zipNameBackup == nmfile) {
              return true;
            } else {
              return false;
            }
          });

          if (results.isNotEmpty && zipNameBackup.isNotEmpty) {
            _arrTemp.add(zipNameBackup);
          }
        }
        _arrTemp.sort();
        _arrBackup.addAll(_arrTemp.reversed);

        for (var i = 0; i < _arrBackup.length; i++) {
          if (i >= maxBackup) {
            _arrDelete.add(_arrBackup[i]);
          }
        }

        for (var j = 0; j < _arrDelete.length; j++) {
          String filePath = '${param.appDir}/BACKUP/${_arrDelete[j]}.zip';
          if (File(filePath).existsSync()) {
            await File(filePath).delete();
          }
        }
      }
    }
  }

  Future<void> initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Initialize controller data dengan nilai default
      
      await clog.setGlobalParamByKodeSf(widget.user.fdKodeSF);
      countNoo = await cnoo.countNoo();
      countCall = await clgn.countCall();
      countOrderCZ = await codr.countOrderCZ();
      countOrderALK = await codr.countOrderALK();
      totalOrderCZ = await codr.totalOrderCZ();
      totalOrderALK = await codr.totalOrderALK();
      omzetLusinCZ = await codr.omzetLusinCZ();
      omzetKartonALK = await codr.omzetKartonALK();
      bool isJailBroken = false;
      bool isDeveloperMode = false;

      if (true) {
        isStartDay = false;
        isEndDay = false;
        isNonRuteValid = false;

        msf.SalesActivity? sfAct = await csales.getStart_EndDayInfo(
            widget.user.fdKodeSF, widget.user.fdKodeDepo, startDayActivity);

        if (sfAct != null) {
          isStartDay = true;
          startDayDate = param.dtFormatDB
              .format(param.dateTimeFormatDB.parse(sfAct.fdStartDate));
          todayDate = param.dtFormatView
              .format(param.dateTimeFormatDB.parse(sfAct.fdStartDate));

          if (startDayDate == param.dtFormatDB.format(DateTime.now())) {
            isNonRuteValid = true;
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await prefs.setString('startDayDate', startDayDate);
          await prefs.setString('fdKodeSF', widget.user.fdKodeSF);
          await prefs.setString('fdKodeDepo', widget.user.fdKodeDepo);
          await prefs.setString('fdToken', widget.user.fdToken);
          await prefs.setString(
              'fdJamStartDay',
              param.timeFormatView
                  .format(param.dateTimeFormatDB.parse(sfAct.fdStartDate)));
          await prefs.setString('fdKmStartDay', sfAct.fdKM.toString());
          if (posGPS!.latitude != 0 && posGPS!.longitude != 0) {
            await prefs.setDouble('fdLa', posGPS!.latitude);
            await prefs.setDouble('fdLg', posGPS!.longitude);
          } else {
            await prefs.setDouble('fdLa', 0);
            await prefs.setDouble('fdLg', 0);
          }
          msf.SalesActivity? sfActEnd = await csales.getStart_EndDayInfo(
              widget.user.fdKodeSF, widget.user.fdKodeDepo, endDayActivity);

          if (sfActEnd != null) {
            if (sfActEnd.fdStatusSent == 1) {
              await prefs.setString(
                  'fdJamEndDay',
                  param.timeFormatView.format(
                      param.dateTimeFormatDB.parse(sfActEnd.fdEndDate)));
              await prefs.setString('fdKmEndDay', sfActEnd.fdKM.toString());
            }
          }
          fdJamStartDay = prefs.getString('fdJamStartDay');
          fdKmStartDay = prefs.getString('fdKmStartDay');
          fdJamEndDay = prefs.getString('fdJamEndDay');
          fdKmEndDay = prefs.getString('fdKmEndDay');
          fdJamEndDay ??= '';
          fdKmEndDay ??= '';
        } else {
          startDayDate = param.dtFormatDB.format(DateTime.now());
          todayDate = param.dtFormatView.format(DateTime.now());
          isNonRuteValid = true;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await prefs.setString('startDayDate', startDayDate);
          await prefs.setString('fdKodeSF', widget.user.fdKodeSF);
          await prefs.setString('fdKodeDepo', widget.user.fdKodeDepo);
          await prefs.setString('fdToken', widget.user.fdToken);
          await prefs.setString('fdJamStartDay', '');
          await prefs.setString('fdJamEndDay', '');
          await prefs.setString('fdKmStartDay', '');
          await prefs.setString('fdKmEndDay', '');
          if (posGPS!.latitude != 0 && posGPS!.longitude != 0) {
            await prefs.setDouble('fdLa', posGPS!.latitude);
            await prefs.setDouble('fdLg', posGPS!.longitude);
          } else {
            await prefs.setDouble('fdLa', 0);
            await prefs.setDouble('fdLg', 0);
          }
          fdJamStartDay = prefs.getString('fdJamStartDay');
          fdKmStartDay = prefs.getString('fdKmStartDay');
          fdJamEndDay = prefs.getString('fdJamEndDay');
          fdKmEndDay = prefs.getString('fdKmEndDay');
          fdJamEndDay ??= '';
          fdKmEndDay ??= '';
        }

        msf.SalesActivity? sfEndDay = await csales.getStart_EndDayInfo(
            widget.user.fdKodeSF, widget.user.fdKodeDepo, endDayActivity);

        if (sfEndDay != null) {
          if (sfEndDay.fdStatusSent == 1) {
            isEndDay = true;
          }
        }

        mapSFSummary.addAll(await clgn.countSFSummary(
            widget.user.fdKodeSF, widget.user.fdKodeDepo));

        if (isStartDay && !isEndDay) {
          if (!await service.isRunning()) {
            Future.delayed(const Duration(seconds: 3))
                .then((value) => service.startService());
          }
        }
      } else {
        if (!mounted) return;

        flutterLocalNotificationsPlugin.show(
          99,
          'Alert',
          'Deteksi aplikasi error: J-$isJailBroken, D-$isDeveloperMode',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              channelDescription:
                  'This channel is used for important notifications.',
              channelShowBadge: true,
              category: AndroidNotificationCategory.message,
              styleInformation: BigTextStyleInformation(''),
            ),
          ),
        );

        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print('error: $e');

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }

    try {
      listNotif = await capi.getListNotif(
          widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);

      setState(() {
        listNotif = listNotif;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void endDayValidation() async {
    try {
      setState(() {
        isLoading = true;
      });

      int countLanggananNotComplete = await clgn.countLanggananNotComplete(
          widget.user.fdKodeSF, widget.user.fdKodeDepo);

      if (countLanggananNotComplete == 0) {
        bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

        if (isDateTimeSettingValid) {
          if (isStartDay) {
            if (!mounted) return;

            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: 'endday'),
                    builder: (context) => EndDayPage(
                        user: widget.user,
                        routeName: 'endday',
                        startDayDate: startDayDate)));
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content:
                      Text('End day tidak valid. Start day belum dilakukan')));
          }
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(
                  'Jumlah outlet belum selesai diproses: $countLanggananNotComplete')));
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

  Future<void> syncData(int syncTipe) async {
    try {
      setState(() {
        isLoading = true;
      });

      bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

      if (isDateTimeSettingValid) {
        int responseCode = 0;
        int checkPlano = 0;

        responseCode = await capi.validasiFMsSalesForce(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getPiutangDagang(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getPiutangDagangFaktur(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getDataHargaJualBarang(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getLanggananAlamat(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.setProvinsi(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.setKabupaten(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.setKecamatan(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.setKelurahan(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.getAllDataTipeDetail(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.getAllBarang(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getAllGroupBarang(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getAllDataDiskon(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getAllDataDiskonDetail(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getAllBarangSales(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.setTipeHarga(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.setTipeOutlet(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getAllReasonNotVisit(widget.user);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getMasterHanger(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        responseCode = await capi.getDetailMasterHanger(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
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

        responseCode = await capi.getFMsSaBarangTOP(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getFMsSaLanggananTOP(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }

        responseCode = await capi.getFmsBank(
            widget.user.fdToken, widget.user.fdKodeSF, widget.user.fdKodeDepo);
        if (responseCode == 401) {
          await sessionExpired();
        }
        if (widget.user.fdTipeSF == '1') {
          responseCode = await capi.getRuteLangganan(widget.user.fdToken,
              widget.user.fdKodeSF, widget.user.fdKodeDepo, startDayDate);
          if (responseCode == 401) {
            await sessionExpired();
          }
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

  void nextDay() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isStartDay && !isEndDay) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Sudah start day')));
      } else if ((isEndDay &&
              todayDate != param.dtFormatView.format(DateTime.now())) ||
          !isStartDay) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? fdTanggal = prefs.getString('startDayDate');

        await deleteZip();
        await capi.sendLogTransaction(widget.user, fdTanggal!);
        await cdb.deleteTransactionAndFiles();

        await prefs.clear();
        await prefs.setString(
            'startDayDate', param.dtFormatDB.format(DateTime.now()));

        await initLoadPage();

        service.invoke("stopService");

        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Sukses mulai hari berikut')));
      } else {
        service.invoke("stopService");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content:
                  Text('Hari ini sudah selesai aktifitas, tunggu besok hari')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _confirmSyncData() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                        if (!mounted) return;
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

  Future<void> confirmSendUnsentImages() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Container(
                color: css.titleDialogColor(),
                padding: const EdgeInsets.all(5),
                child: const Text('Lanjut kirim ulang file foto ke server?')),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    await sendUnsentImagetoServer();
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

  Future<void> confirmSendLog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Container(
                color: css.titleDialogColor(),
                padding: const EdgeInsets.all(5),
                child: const Text('Lanjut kirim log ke server?')),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    await sendLogtoServer();
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

  Future<void> sendUnsentImagetoServer() async {
    try {
      setState(() {
        isLoading = true;
      });

      String filePath =
          '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';

      List<msf.SalesActivity> userActs = await csales.getTransLanggananSent(
          widget.user.fdKodeSF, widget.user.fdKodeDepo);

      if (userActs.isNotEmpty) {
        var listZip = Directory(filePath).listSync().where((element) {
          if (cpath.extension(element.path) == '.zip') {
            return true;
          } else {
            return false;
          }
        });

        List<String> listLangganan = [];

        for (var element in userActs) {
          var results = listZip.where((fileZip) {
            String fdKodeLangganan =
                cpath.basenameWithoutExtension(fileZip.path);

            if (fdKodeLangganan == element.fdKodeLangganan) {
              return true;
            } else {
              return false;
            }
          });

          if (results.isEmpty && element.fdKodeLangganan.isNotEmpty) {
            listLangganan.add(element.fdKodeLangganan);
          }
        }

        for (var fdKodeLangganan in listLangganan) {
          String dirCameraPath = '$filePath/$fdKodeLangganan';

          Directory dir = Directory(dirCameraPath);
          String zipPath = '$filePath/$fdKodeLangganan.zip';
          String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

          if (errorMsg.isNotEmpty) {
            throw ('Error compress file outlet: $errorMsg');
          }
        }
      }

      String nOOPath = '$filePath/NOO';
      Directory dirNOO = Directory(nOOPath);

      if (dirNOO.existsSync()) {
        String errorResultNOO =
            await cdb.createZipDirectory(nOOPath, '$filePath/NOO.zip');

        if (errorResultNOO.isNotEmpty) {
          throw ('Error compress file NOO: $errorResultNOO');
        }
      }

      Map<String, dynamic> mapResult =
          await cdb.createZipMDAllZipFiles(widget.user.fdKodeSF, filePath);

      if (mapResult['fdData'] == 1) {
        String zipFilePath = mapResult['fdMessage'];
        int responseCode = await capi.sendBackuptoServer(
            zipFilePath, widget.user, '', startDayDate);

        if (responseCode == 401) {
          await sessionExpired();
        } else if (responseCode == 0) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Terjadi error kirim foto, mohon coba kembali')));
        } else if (responseCode == 400) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Terjadi timeout, mohon coba kembali')));
        } else {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Sukses kirim file foto ke server')));
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(mapResult['fdMessage'])));
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<void> sendLogtoServer() async {
    try {
      setState(() {
        isLoading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? fdTanggal = prefs.getString('startDayDate');
      await capi.sendLogTransaction(widget.user, fdTanggal!);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Sukses kirim log')));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              Text('CRM'),
            ],
          ),
          actions: [
            isLoading
                ? const Padding(padding: EdgeInsets.zero)
                : IconButton(
                    icon: Icon(Icons.notifications_none_rounded,
                        size: 24 * ScaleSize.textScaleFactor(context)),
                    tooltip: 'Notification',
                    onPressed: () async {
                      try {
                        listNotif = await capi.getListNotif(widget.user.fdToken,
                            widget.user.fdKodeSF, widget.user.fdKodeDepo);

                        setState(() {
                          listNotif = listNotif;
                        });
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    }),
            isLoading
                ? const Padding(padding: EdgeInsets.zero)
                : IconButton(
                    icon: Icon(Icons.refresh,
                        size: 24 * ScaleSize.textScaleFactor(context)),
                    tooltip: 'Sync Data',
                    onPressed: () async {
                      try {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings:
                                    const RouteSettings(name: 'synchronize'),
                                builder: (context) => SyncPage(
                                    user: widget.user,
                                    routeName: 'synchronize',
                                    startDayDate: startDayDate)));
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    }),
            isLoading
                ? const Padding(padding: EdgeInsets.zero)
                : IconButton(
                    onPressed: () async {
                      FunctionHelper.AlertDialogCip(
                          context,
                          DialogCip(
                              title: 'Logout?',
                              message: 'Apakah anda ingin logout?',
                              ok: 'Ya',
                              onOk: () async {
                                await cdb.logOut();

                                if (!mounted) return;

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (Route<dynamic> route) => false);
                              }));
                    },
                    icon: Icon(Icons.logout,
                        size: 24 * ScaleSize.textScaleFactor(context)),
                    tooltip: 'Logout',
                  ),
          ],
        ),
        body: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                backgroundColor: Colors.yellow,
                color: Colors.red,
                strokeWidth: 2,
                onRefresh: () async {
                  await initLoadPage();
                  return Future.delayed(const Duration(milliseconds: 500));
                },
                child: HomeView(
                  isStartDay: isStartDay,
                  confirmSendUnsentImages: confirmSendUnsentImages,
                  confirmSendLog: confirmSendLog,
                  user: widget.user,
                  todayDate: todayDate,
                  listNotif: listNotif,
                  mapSFSummary: mapSFSummary,
                  isNonRuteValid: isNonRuteValid,
                  startDayDate: startDayDate,
                  isEndDay: isEndDay,
                  countNoo: countNoo,
                  countCall: countCall,
                  countOrderALK: countOrderALK,
                  countOrderCZ: countOrderCZ,
                  omzetKartonALK: omzetKartonALK,
                  omzetLusinCZ: omzetLusinCZ,
                  totalOrderALK: totalOrderALK,
                  totalOrderCZ: totalOrderCZ,
                )),
        bottomNavigationBar: isLoading
            ? const SizedBox.shrink()
            : SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (widget.user.fdTipeSF == '1' &&
                                isStartDay == false) {
                              isRencanaRuteExists = await crute
                                  .checkRencanaRuteExists(
                                      param.dtFormatDB.format(DateTime.now()));
                              isStockVerifyExists = await cstock
                                  .checkStockVerifyExists(
                                      param.dtFormatDB.format(DateTime.now()));

                              if (!isRencanaRuteExists) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text(
                                          'Tidak bisa Start Day. Belum ada Rencana Rute untuk hari ini')));
                                return;
                              }
                              if (!isStockVerifyExists) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text(
                                          'Stock hari ini belum diverifikasi!')));
                                return;
                              }
                              int responseCode = 0;
                              responseCode = await capi.validasiSfaMsRencanaRute(
                                  widget.user.fdToken,
                                  widget.user.fdKodeSF,
                                  widget.user.fdKodeDepo,
                                  startDayDate,
                                  startDayDate,
                                  'S',
                                  startDayDate);
                              if (responseCode == 401) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Session expired')));
                                return;
                              } else if (responseCode == 0) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Rencana rute belum di approve')));
                                return;
                              } else if (responseCode == 408) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Error timeout')));
                                return;
                              }
                            }
                            setState(() {
                              isLoading = true;
                            });
                            bool isDateTimeSettingValid =
                                await cother.dateTimeSettingValidation();

                            if (isDateTimeSettingValid) {
                              if (!isStartDay) {
                                await syncData(0);
                              } else if ((isEndDay &&
                                      todayDate !=
                                          param.dtFormatView
                                              .format(DateTime.now())) ||
                                  !isStartDay) {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final String? fdTanggal =
                                    prefs.getString('startDayDate');

                                await deleteZip();
                                await capi.sendLogTransaction(
                                    widget.user, fdTanggal!);
                                await cdb.deleteTransactionAndFiles();

                                await prefs.clear();
                                await prefs.setString('startDayDate',
                                    param.dtFormatDB.format(DateTime.now()));

                                await syncData(0);
                                await initLoadPage();

                                service.invoke("stopService");

                                if (!mounted) return;

                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content:
                                          Text('Sukses mulai hari berikut')));
                              }

                              if (!mounted) return;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: const RouteSettings(
                                          name: 'startday'),
                                      builder: (context) => StartDayPage(
                                          user: widget.user,
                                          routeName: 'startday',
                                          startDayDate: startDayDate)));
                            }

                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });

                            if (!mounted) return;
                            if (e == 408) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Error timeout')));
                              await sessionExpired();
                            } else {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                    SnackBar(content: Text('error: $e')));
                            }
                          }
                        },
                        child: Ink(
                          height: double.infinity,
                          color: ColorHelper.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Icons.man_rounded,
                                  color: Colors.white,
                                  size:
                                      24 * ScaleSize.textScaleFactor(context)),
                              const Text('Start Day',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          endDayValidation();
                        },
                        child: Ink(
                          color: ColorHelper.secondary,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(Icons.airline_seat_recline_normal_rounded,
                                    color: Colors.white,
                                    size: 24 *
                                        ScaleSize.textScaleFactor(context)),
                                const Text('End Day',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
        floatingActionButton: isLoading ? const Padding(padding: EdgeInsets.zero) : null);
  }
}