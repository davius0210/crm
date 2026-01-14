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
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
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
  Position? posGPS =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
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
    initLoadPage();

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
      //tidak balik return alert masih bisa lanjut proses
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
      await clog.setGlobalParamByKodeSf(widget.user.fdKodeSF);
      //await checkPackage();
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

      //sugeng remark GPS hanya event tertentu
      // await Geolocator.getCurrentPosition(
      //         desiredAccuracy: LocationAccuracy.high,
      //         timeLimit: Duration(seconds: param.gpsTimeOut))
      //     .then((value) {
      //   setState(() {
      //     posGPS = value;
      //   });
      // }).onError((error, stackTrace) {
      //   ScaffoldMessenger.of(context)
      //     ..removeCurrentSnackBar()
      //     ..showSnackBar(const SnackBar(content: Text('error gps timeout')));
      // });
      //sugeng end remark

      //Ed1 - 26/09/23 - comment selama develop
      if (true) {
        // if (!isJailBroken && !isDeveloperMode) {
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
              //End Day harus terkirim ke Core untuk dianggap selesai
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
            //End Day harus terkirim ke Core untuk dianggap selesai
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

    //load list notif
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

  // START : block code download image planogram from ftp server

  // //an auxiliary function that manage showed log to UI
  // Future<void> showlog(String log) async {
  //   print(log);
  //   await Future.delayed(const Duration(seconds: 1));
  // }

  // void showDownloadProgress(double p, int r, int fileSize) {
  //   print('downloaded :$r byte =========> $p%');
  // }

  // Future<int> getImagePlanogramFromFTP() async {
  //   bool ftpFileExists = false;

  //   const String ftpHost = '202.137.19.140';
  //   //const int ftpPort = 21;
  //   const String username = 'ftpmduser';
  //   const String password = 'Intercallin20230718*';
  //   const String ftpDirectory = '/home/ftpmduser/planogram';
  //   // ftpDirectory : path diserver, berisi file image planogram
  //   // belakang folder jangan pakai tanda (/)

  //   String localImagePath = '${param.appDir}/${param.imgPathPlano}';
  //   // localImagePath : path didevice utk tampung image planogram hasil download

  //   //String localDownloadFile = '2023-08-01_2023-08-31_SAT_REG_8_3.jpg';
  //   // mplano.PlanogramPeriode pro = mplano.PlanogramPeriode.empty();
  //   List<mplano.PlanogramPeriode> listPlanogramPeriode = [];

  //   try {
  //     listPlanogramPeriode = await cplano.getPlanogramPeriode(startDayDate);

  //     //1. check if directory exists
  //     // Get the documents directory using path_provider
  //     // Create a subdirectory within the documents directory
  //     Directory customDirectory = Directory(localImagePath);

  //     // Check if the directory already exists
  //     if (await customDirectory.exists()) {
  //       print('Directory already exists: ${customDirectory.path}');
  //     } else {
  //       // Create the directory
  //       customDirectory.create().then((Directory newDirectory) {
  //         print('Directory created: ${newDirectory.path}');
  //       }).catchError((e) => print('Error creating directory: $e'));
  //     }

  //     //2. trying conecting to server
  //     await showlog('Connecting to FTP ...');
  //     FTPConnect ftpConnect =
  //         FTPConnect(ftpHost, user: username, pass: password);
  //     await ftpConnect.connect();

  //     //3. set Binary mode to ensure that the files are transferred exactly as they are
  //     await ftpConnect.setTransferType(TransferType.binary);

  //     //4. check if source directory ftp server exists
  //     await ftpConnect.changeDirectory(ftpDirectory);
  //     String dircur = await ftpConnect.currentDirectory();
  //     if (dircur.isNotEmpty) {
  //       await showlog('Downloading ...');

  //       //5. copying file from ftp server to device
  //       // var i = 0;
  //       // while (i < listPlanogramPeriode.length) {
  //       //   String localDownloadFile =
  //       //       '${listPlanogramPeriode[i].fdStartDate.substring(0, 10)}_${listPlanogramPeriode[i].fdEndDate.substring(0, 10)}'
  //       //       '_RAKPLANOGRAM_${listPlanogramPeriode[i].fdKodeGroupLangganan}_${listPlanogramPeriode[i].fdKodeTipeLangganan}'
  //       //       '_${listPlanogramPeriode[i].fdAmountChiller}_${listPlanogramPeriode[i].fdNoImage}.jpg';

  //       //   ftpFileExists =
  //       //       await ftpConnect.existFile('$dircur/$localDownloadFile');
  //       //   if (ftpFileExists) {
  //       //     await ftpConnect.downloadFile(
  //       //         localDownloadFile, File('$localImagePath/$localDownloadFile'),
  //       //         onProgress: showDownloadProgress);
  //       //   }

  //       //   i++;
  //       // }

  //       String localDownloadFile = 'Plano.zip';
  //       ftpFileExists =
  //           await ftpConnect.existFile('$dircur/$localDownloadFile');
  //       if (ftpFileExists) {
  //         await ftpConnect.downloadFile(
  //             localDownloadFile, File('$localImagePath/$localDownloadFile'),
  //             onProgress: showDownloadProgress);
  //         try {
  //           ZipFile.extractToDirectory(
  //               zipFile: File('$localImagePath/$localDownloadFile'),
  //               destinationDir: Directory('$localImagePath/'));
  //         } catch (e) {
  //           print(e);
  //         }
  //       }
  //     } else {
  //       await showlog('Source directory not exists ');
  //       return 1;
  //     }

  //     await ftpConnect.disconnect();
  //     return 0;
  //   } catch (e) {
  //     await showlog('Downloading FAILED: ${e.toString()}');
  //     return 1;
  //   }
  // }
  // // END : block code download image planogram from ftp server

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
          // responseCode = await capi.getRencanaRuteLangganan(widget.user.fdToken,
          //     widget.user.fdKodeSF, widget.user.fdKodeDepo, startDayDate);
          // if (responseCode == 401) {
          //   await sessionExpired();
          // }
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
        //Tidak bisa next day karena masih hari H yang sudah end day, tunggu bsk hari
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
      barrierDismissible: false, // user must tap button!
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
      barrierDismissible: false, // user must tap button!
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

      //Create Zip semua langganan
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

        //compare file zip langganan vs data langganan di sqlite untuk validasi terbentuknya file zip langganan
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

          //insert langganan yang belum terbentuk file zip
          if (results.isEmpty && element.fdKodeLangganan.isNotEmpty) {
            listLangganan.add(element.fdKodeLangganan);
          }
        }

        //Buat file zip untuk langganan yang belum terbentuk file zip
        for (var fdKodeLangganan in listLangganan) {
          String dirCameraPath = '$filePath/$fdKodeLangganan';

          Directory dir = Directory(dirCameraPath);
          String zipPath =
              '$filePath/$fdKodeLangganan.zip'; //path di luar folder kode langganan
          String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

          if (errorMsg.isNotEmpty) {
            throw ('Error compress file outlet: $errorMsg');
          }
        }
      }

      //Create Zip NOO
      String nOOPath = '$filePath/NOO';
      Directory dirNOO = Directory(nOOPath);

      if (dirNOO.existsSync()) {
        String errorResultNOO =
            await cdb.createZipDirectory(nOOPath, '$filePath/NOO.zip');

        if (errorResultNOO.isNotEmpty) {
          throw ('Error compress file NOO: $errorResultNOO');
        }
      }

      //Create Zip KM Start
      //sugeng remark tidak input foto start KM
      // Directory dirKM = Directory(filePath);
      // String kmStartImgPath =
      //     '${param.appDir}/${param.imgPath}/${param.kmStartFullImgName(widget.user.fdKodeSF, startDayDate)}';

      // if (File(kmStartImgPath).existsSync()) {
      //   List<File> kmStartfiles = [File(kmStartImgPath)];
      //   String zipKMStartPath = '${dirKM.path}/${param.kmStartZipFileName}';
      //   String errorKMStart =
      //       await cdb.createZipFile(dirKM.path, kmStartfiles, zipKMStartPath);

      //   if (errorKMStart.isNotEmpty) {
      //     throw ('Error compress file KM Start: $errorKMStart');
      //   }
      // }

      //Create Zip KM End
      //sugeng remark tidak input foto end KM
      // String kmEndImgPath =
      //     '${param.appDir}/${param.imgPath}/${param.kmEndFullImgName(widget.user.fdKodeSF, startDayDate)}';

      // if (File(kmEndImgPath).existsSync()) {
      //   List<File> kmEndfiles = [File(kmEndImgPath)];
      //   String zipKMEndPath = '${dirKM.path}/${param.kmEndZipFileName}';
      //   String errorKMEnd =
      //       await cdb.createZipFile(dirKM.path, kmEndfiles, zipKMEndPath);

      //   if (errorKMEnd.isNotEmpty) {
      //     throw ('Error compress file KM End: $errorKMEnd');
      //   }
      // }

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
        // drawer: (isLoading
        //     ? const Padding(padding: EdgeInsets.zero)
        //     : SizedBox(
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: Drawer(
        //           shape: const RoundedRectangleBorder(
        //             borderRadius:
        //                 BorderRadius.only(topRight: Radius.circular(30)),
        //           ),
        //           child: ListView(
        //             padding: EdgeInsets.zero,
        //             children: [
                      
        //               DrawerHeader(
        //                   margin: EdgeInsets.zero,
        //                   padding: EdgeInsets.all(10),
        //                   decoration: css.boxDecorDrawerHeader(),
        //                   child: Row(
        //                     children: [
        //                       CircleAvatar(
        //                         backgroundColor: Colors.white,
        //                         child: Image.asset('assets/images/UserProfile.png'),radius: 50,),
        //                       SizedBox(width: 10,),
        //                       Flexible(
        //                           child: Text(
        //                         '${widget.user.fdKodeDepo} - ${widget.user.fdNamaDepo}\n${widget.user.fdKodeSF}\n${widget.user.fdNamaSF}',
        //                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //                       )),
        //                     ],
        //                   )), //

        //               // === Master Dropdown ===

        //               ExpansionTile(
        //                 leading: Icon(Icons.folder,
        //                     color: Colors.blue,
        //                     size: 24 * ScaleSize.textScaleFactor(context)),
        //                 title: const Text('Sales Activity'),
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('Stock'),
        //                       leading: Icon(Icons.download_rounded,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 settings:
        //                                     const RouteSettings(name: 'stock'),
        //                                 builder: (context) => StockPage(
        //                                     user: widget.user,
        //                                     startDayDate: startDayDate,
        //                                     isEndDay: isEndDay,
        //                                     routeName: 'stock')));
        //                       },
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('Rencana Rute'),
        //                       leading: Icon(Icons.route_outlined,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 settings: const RouteSettings(
        //                                     name: 'rencanarute'),
        //                                 builder: (context) => RencanaRutePage(
        //                                     user: widget.user,
        //                                     startDayDate: startDayDate,
        //                                     isEndDay: isEndDay,
        //                                     routeName: 'rencanarute')));
        //                       },
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('List Invoice'),
        //                       leading: Icon(Icons.list_alt_rounded,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 settings: const RouteSettings(
        //                                     name: 'listinvoice'),
        //                                 builder: (context) => ListInvoicePage(
        //                                     user: widget.user,
        //                                     startDayDate: startDayDate,
        //                                     isEndDay: isEndDay,
        //                                     routeName: 'listinvoice')));
        //                       },
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('Coverage Area'),
        //                       leading: Icon(Icons.place_rounded,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 settings: const RouteSettings(
        //                                     name: 'coveragearea'),
        //                                 builder: (context) => CoverageAreaPage(
        //                                     user: widget.user,
        //                                     startDayDate: startDayDate,
        //                                     routeName: 'coveragearea')));
        //                       },
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('Limit Kredit'),
        //                       leading: Icon(Icons.credit_card,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 settings: const RouteSettings(
        //                                     name: 'limitkredit'),
        //                                 builder: (context) => LimitKreditPage(
        //                                     user: widget.user,
        //                                     startDayDate: startDayDate,
        //                                     isEndDay: isEndDay,
        //                                     routeName: 'limitkredit')));
        //                       },
        //                     ),
        //                   ),
        //                 ],
        //               ),

        //               ExpansionTile(
        //                 leading: Icon(Icons.list_alt_rounded,
        //                     color: Colors.blue,
        //                     size: 24 * ScaleSize.textScaleFactor(context)),
        //                 title: const Text('Store Activity'),
        //                 children: [
        //                   widget.user.fdTipeSF == '1'
        //                       ? Padding(
        //                           padding: const EdgeInsets.only(left: 10),
        //                           child: ListTile(
        //                             title:
        //                                 const Text('Registrasi Langganan Baru'),
        //                             leading: Icon(Icons.store,
        //                                 color: Colors.blue,
        //                                 size: 24 *
        //                                     ScaleSize.textScaleFactor(context)),
        //                             textColor: isStartDay ? null : Colors.grey,
        //                             onTap: (isStartDay
        //                                 ? () {
        //                                     Navigator.pop(context);
        //                                     Navigator.push(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                             settings:
        //                                                 const RouteSettings(
        //                                                     name: 'noo'),
        //                                             builder: (context) =>
        //                                                 NOOPage(
        //                                                     user: widget.user,
        //                                                     routeName: 'noo',
        //                                                     isEndDay: isEndDay,
        //                                                     startDayDate:
        //                                                         startDayDate)));
        //                                   }
        //                                 : null),
        //                           ),
        //                         )
        //                       : Padding(
        //                           padding: const EdgeInsets.only(left: 10),
        //                           child: ListTile(
        //                             title:
        //                                 const Text('Registrasi Langganan Baru'),
        //                             leading: Icon(Icons.store,
        //                                 color: Colors.blue,
        //                                 size: 24 *
        //                                     ScaleSize.textScaleFactor(context)),
        //                             textColor: isStartDay ? null : Colors.grey,
        //                             onTap: (isStartDay
        //                                 ? () {
        //                                     Navigator.pop(context);
        //                                     Navigator.push(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                             settings:
        //                                                 const RouteSettings(
        //                                                     name: 'noo'),
        //                                             builder: (context) =>
        //                                                 NOOPage(
        //                                                     user: widget.user,
        //                                                     routeName: 'noo',
        //                                                     isEndDay: isEndDay,
        //                                                     startDayDate:
        //                                                         startDayDate)));
        //                                   }
        //                                 : null),
        //                           ),
        //                         ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                       title: const Text('Rute'),
        //                       leading: Icon(Icons.route_rounded,
        //                           color: Colors.blue,
        //                           size:
        //                               24 * ScaleSize.textScaleFactor(context)),
        //                       textColor: isStartDay ? null : Colors.grey,
        //                       onTap: (isStartDay
        //                           ? () {
        //                               Navigator.pop(context);
        //                               Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                       settings: const RouteSettings(
        //                                           name: 'rute'),
        //                                       builder: (context) => RutePage(
        //                                           user: widget.user,
        //                                           startDayDate: startDayDate,
        //                                           isEndDay: isEndDay,
        //                                           routeName: 'rute')));
        //                             }
        //                           : null),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                         title: const Text('Non Rute'),
        //                         leading: Icon(Icons.share_location,
        //                             color: Colors.blue,
        //                             size: 24 *
        //                                 ScaleSize.textScaleFactor(context)),
        //                         textColor: isNonRuteValid ? null : Colors.grey,
        //                         onTap: (isNonRuteValid
        //                             ? () {
        //                                 Navigator.pop(context);
        //                                 Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             NonRutePage(
        //                                                 user: widget.user,
        //                                                 startDayDate:
        //                                                     startDayDate,
        //                                                 isEndDay: isEndDay)));
        //                               }
        //                             : null)),
        //                   ),

        //                   // ListTile(
        //                   //     title: const Text('Standard Planogram'),
        //                   //     leading:
        //                   //         Icon(Icons.burst_mode_sharp, //burst_mode_outlined,
        //                   //             color: Colors.blue,
        //                   //             size: 24 * ScaleSize.textScaleFactor(context)),
        //                   //     textColor: isStartDay ? null : Colors.grey,
        //                   //     onTap: (isStartDay
        //                   //         ? () async {
        //                   //             List<String> imgList = [];
        //                   //             String localImagePath =
        //                   //                 '${param.appDir}/${param.imgPathStandardPlano}';

        //                   //             List<mplano.StandardPlano> items =
        //                   //                 await cplano.getStandardPlano();
        //                   //             for (var element in items) {
        //                   //               String namaFile =
        //                   //                   '/${element.fdNamaLangganan}_${element.fdTipe}_${element.fdNoUrut}.jpg';
        //                   //               imgList.add(
        //                   //                   localImagePath + namaFile.toString());
        //                   //             }

        //                   //             if (!mounted) return;

        //                   //             Navigator.pop(context);
        //                   //             Navigator.push(
        //                   //                 context,
        //                   //                 MaterialPageRoute(
        //                   //                     settings: const RouteSettings(
        //                   //                         name: 'stdplano'),
        //                   //                     builder: (context) => ImagesViewPage(
        //                   //                         user: widget.user,
        //                   //                         routeName: 'stdplano',
        //                   //                         imgList: imgList)));
        //                   //           }
        //                   //         : null)),
        //                 ],
        //               ),

        //               ExpansionTile(
        //                 leading: Icon(Icons.storage,
        //                     color: Colors.blue,
        //                     size: 24 * ScaleSize.textScaleFactor(context)),
        //                 title: const Text('File'),
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                         title: const Text('LASH'),
        //                         leading: Icon(Icons.file_download,
        //                             color: Colors.blue,
        //                             size: 24 *
        //                                 ScaleSize.textScaleFactor(context)),
        //                         textColor: isEndDay ? null : Colors.grey,
        //                         onTap: () {
                                 
        //                                 Navigator.pop(context);
        //                                 Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         settings: const RouteSettings(
        //                                             name: 'pdfLash'),
        //                                         builder: (context) =>
        //                                             PreviewLashPage(
        //                                                 user: widget.user,
        //                                                 routeName: 'pdfLash',
        //                                                 startDayDate:
        //                                                     startDayDate)));
        //                               }
        //                             ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                         title: const Text('Send Unsent Images'),
        //                         leading: Icon(
        //                             Icons.upload_file, //burst_mode_outlined,
        //                             color: Colors.blue,
        //                             size: 24 *
        //                                 ScaleSize.textScaleFactor(context)),
        //                         textColor: isStartDay ? null : Colors.grey,
        //                         onTap: (isStartDay
        //                             ? () async {
        //                                 await confirmSendUnsentImages();
        //                               }
        //                             : null)),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                         title: const Text('Send Log'),
        //                         leading: Icon(
        //                             Icons
        //                                 .send_and_archive_sharp, //burst_mode_outlined,
        //                             color: Colors.blue,
        //                             size: 24 *
        //                                 ScaleSize.textScaleFactor(context)),
        //                         textColor: isStartDay ? null : Colors.grey,
        //                         onTap: (isStartDay
        //                             ? () async {
        //                                 await confirmSendLog();
        //                               }
        //                             : null)),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: ListTile(
        //                         title: const Text('Send Backup Images'),
        //                         leading: Icon(
        //                             Icons.upload_file, //burst_mode_outlined,
        //                             color: Colors.blue,
        //                             size: 24 *
        //                                 ScaleSize.textScaleFactor(context)),
        //                         textColor: isStartDay ? null : Colors.grey,
        //                         onTap: (isStartDay
        //                             ? () {
        //                                 Navigator.pop(context);
        //                                 Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         settings: const RouteSettings(
        //                                             name: 'backup'),
        //                                         builder: (context) =>
        //                                             BackupPage(
        //                                                 user: widget.user,
        //                                                 startDayDate:
        //                                                     startDayDate,
        //                                                 routeName: 'backup')));
        //                               }
        //                             : null)),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       )),
        appBar: AppBar(
          title:  Column(
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
                      FunctionHelper.AlertDialogCip(context,
                       DialogCip(
                        title: 'Logout?',
                        message: 'Apakah anda ingin logout?',
                        ok: 'Ya',
                        onOk: ()async{
                          await cdb.logOut();

                          if (!mounted) return;

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false);
                        }

                      ));
                      
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
                  confirmSendUnsentImages:confirmSendUnsentImages,
                  confirmSendLog:confirmSendLog,
                  user: widget.user, todayDate: todayDate, listNotif: listNotif, mapSFSummary: mapSFSummary, isNonRuteValid: isNonRuteValid, startDayDate: startDayDate, isEndDay: isEndDay, countNoo: countNoo, countCall: countCall, countOrderALK: countOrderALK, countOrderCZ: countOrderCZ, omzetKartonALK: omzetKartonALK, omzetLusinCZ: omzetLusinCZ, totalOrderALK: totalOrderALK, totalOrderCZ: totalOrderCZ,)
                
                
                
                // Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Center(
                //           child: Text(
                //               '${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
                //               style: css.textNormalBold())),
                //       const Padding(padding: EdgeInsets.all(20)),
                //       RichText(
                //           textScaleFactor: ScaleSize.textScaleFactor(context),
                //           text: TextSpan(
                //               style: css.textSmallSizeBlack(),
                //               children: [
                //                 TextSpan(
                //                     text: 'Tanggal: ',
                //                     style: css.textNormalBold()),
                //                 TextSpan(
                //                     text: param.dtFormatViewMMM.format(
                //                         param.dtFormatView.parse(todayDate))),
                //               ])),
                //       const Divider(height: 20, thickness: 1),
                //       Expanded(
                //           child: SingleChildScrollView(
                //               physics: const AlwaysScrollableScrollPhysics(),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Container(
                //                       decoration: css.boxDecorTitle(),
                //                       padding: const EdgeInsets.all(5),
                //                       height: 50,
                //                       child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.start,
                //                           children: [
                //                             Expanded(
                //                                 child: Text('Notifikasi',
                //                                     style:
                //                                         css.textHeaderBold())),
                //                           ])),
                //                   if (listNotif.isNotEmpty)
                //                     ...listNotif.map((entry) {
                //                       return Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.start,
                //                         children: [
                //                           Padding(
                //                             padding: const EdgeInsets.only(
                //                                 left: 5, right: 5, bottom: 5),
                //                             child: SizedBox(
                //                               child: TextButton(
                //                                 onPressed: () async {
                //                                   final url = entry['fdUrl'];
                //                                   if (url != null &&
                //                                       await canLaunchUrl(
                //                                           Uri.parse(url))) {
                //                                     await launchUrl(
                //                                         Uri.parse(url));
                //                                   }
                //                                 },
                //                                 child: badges.Badge(
                //                                   position: badges.BadgePosition
                //                                       .topEnd(
                //                                           top: -3, end: -33),
                //                                   showBadge: true,
                //                                   badgeContent: Text(
                //                                     entry['fdBadges']
                //                                         .toString(),
                //                                     textAlign: TextAlign.center,
                //                                     style: const TextStyle(
                //                                         color: Colors.white),
                //                                   ),
                //                                   badgeAnimation: const badges
                //                                       .BadgeAnimation.rotation(
                //                                     animationDuration:
                //                                         Duration(seconds: 1),
                //                                     colorChangeAnimationDuration:
                //                                         Duration(seconds: 1),
                //                                     loopAnimation: false,
                //                                     curve: Curves.fastOutSlowIn,
                //                                     colorChangeAnimationCurve:
                //                                         Curves.easeInCubic,
                //                                   ),
                //                                   badgeStyle:
                //                                       const badges.BadgeStyle(
                //                                     shape: badges
                //                                         .BadgeShape.circle,
                //                                     badgeColor: Colors.red,
                //                                     padding: EdgeInsets.only(
                //                                         left: 5, right: 5),
                //                                     // borderRadius:
                //                                     //     BorderRadius.circular(
                //                                     //         1),
                //                                     // borderSide: BorderSide(
                //                                     //     color: Colors.white,
                //                                     //     width: 1),
                //                                     // borderGradient:
                //                                     //     badges.BadgeGradient
                //                                     //         .linear(colors: [
                //                                     //   Colors.red,
                //                                     //   Colors.black
                //                                     // ]),
                //                                     // badgeGradient: badges
                //                                     //     .BadgeGradient.linear(
                //                                     //   colors: [
                //                                     //     Colors.blue,
                //                                     //     Colors.yellow
                //                                     //   ],
                //                                     //   begin:
                //                                     //       Alignment.topCenter,
                //                                     //   end: Alignment
                //                                     //       .bottomCenter,
                //                                     // ),
                //                                     elevation: 0,
                //                                   ),
                //                                   child: Text(
                //                                     entry['fdLabel'] ?? '---',
                //                                     style: const TextStyle(
                //                                         color: Colors.blue),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       );
                //                     }).toList()
                //                   else
                //                     Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         Padding(
                //                           padding: const EdgeInsets.only(
                //                               left: 5, right: 5, bottom: 5),
                //                           child: Text(
                //                             'Tidak ada notifikasi',
                //                             style: TextStyle(
                //                                 color: Colors.grey[600]),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   Container(
                //                       decoration: css.boxDecorTitle(),
                //                       padding: const EdgeInsets.all(5),
                //                       height: 50,
                //                       child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.start,
                //                           children: [
                //                             Expanded(
                //                                 child: Text('Daily Summary',
                //                                     style:
                //                                         css.textHeaderBold())),
                //                           ])),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                           width: 120 *
                //                               ScaleSize.textScaleFactor(
                //                                   context),
                //                           child: Card(
                //                             elevation: 3,
                //                             shadowColor: Colors.blue,
                //                             shape: css.boxStyle(),
                //                             color: Colors.blue[50],
                //                             child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.all(10),
                //                                 child: Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.center,
                //                                   children: [
                //                                     const Row(
                //                                         mainAxisAlignment:
                //                                             MainAxisAlignment
                //                                                 .center,
                //                                         children: [
                //                                           Text('Plan Rute',
                //                                               style: TextStyle(
                //                                                 fontWeight:
                //                                                     FontWeight
                //                                                         .bold,
                //                                               ))
                //                                         ]),
                //                                     const Padding(
                //                                         padding:
                //                                             EdgeInsets.all(5)),
                //                                     Text(
                //                                       mapSFSummary['rute']
                //                                           .toString(),
                //                                     )
                //                                   ],
                //                                 )),
                //                           )),
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: GestureDetector(
                //                           onTap: () {
                //                             if (isNonRuteValid) {
                //                               // Navigator.pop(context);
                //                               Navigator.push(
                //                                 context,
                //                                 MaterialPageRoute(
                //                                   builder: (context) =>
                //                                       NonRutePage(
                //                                     user: widget.user,
                //                                     startDayDate: startDayDate,
                //                                     isEndDay: isEndDay,
                //                                   ),
                //                                 ),
                //                               );
                //                             } else {
                //                               null;
                //                             }
                //                           },
                //                           child: Card(
                //                             elevation: 3,
                //                             shadowColor: Colors.blue,
                //                             shape: css.boxStyle(),
                //                             color: Colors.blue[50],
                //                             child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.all(10),
                //                                 child: Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.center,
                //                                   children: [
                //                                     const Row(
                //                                         mainAxisAlignment:
                //                                             MainAxisAlignment
                //                                                 .center,
                //                                         children: [
                //                                           Text('Non Rute',
                //                                               style: TextStyle(
                //                                                   fontWeight:
                //                                                       FontWeight
                //                                                           .bold))
                //                                         ]),
                //                                     const Padding(
                //                                         padding:
                //                                             EdgeInsets.all(5)),
                //                                     Text(
                //                                       mapSFSummary['nonrute']
                //                                           .toString(),
                //                                     )
                //                                   ],
                //                                 )),
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(
                //                           width: 120 *
                //                               ScaleSize.textScaleFactor(
                //                                   context),
                //                           child: Card(
                //                             elevation: 3,
                //                             shadowColor: Colors.blue,
                //                             shape: css.boxStyle(),
                //                             color: Colors.blue[50],
                //                             child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.all(10),
                //                                 child: Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.center,
                //                                   children: [
                //                                     const Row(
                //                                         mainAxisAlignment:
                //                                             MainAxisAlignment
                //                                                 .center,
                //                                         children: [
                //                                           Text('Total Rute',
                //                                               style: TextStyle(
                //                                                 fontWeight:
                //                                                     FontWeight
                //                                                         .bold,
                //                                               ))
                //                                         ]),
                //                                     const Padding(
                //                                         padding:
                //                                             EdgeInsets.all(5)),
                //                                     Text(
                //                                       mapSFSummary['rute']
                //                                           .toString(),
                //                                     )
                //                                   ],
                //                                 )),
                //                           )),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Container(
                //                       decoration: css.boxDecorTitle(),
                //                       padding: const EdgeInsets.all(5),
                //                       height: 50,
                //                       child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.start,
                //                           children: [
                //                             Expanded(
                //                                 child: Text(
                //                                     'Target dan Realisasi',
                //                                     style:
                //                                         css.textHeaderBold())),
                //                           ])),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text(''),
                //                       ),
                //                       SizedBox(
                //                         width: 90 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Target Harian',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 90 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Realisasi Hari ini',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('NOO'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             '${countNoo.toString()} Toko',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Call'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             '${countCall.toString()} Toko',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Order CZ'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             ' ${countOrderCZ.toString()} Toko',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Omzet CZ (LSN)'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             '${param.idNumberFormatDec.format(omzetLusinCZ).toString()} LSN',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Total Rp CZ'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             'Rp. ${param.enNumberFormat.format(totalOrderCZ).toString()}',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Order ALK'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             '${countOrderALK.toString()} Toko',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Omzet ALK (CTN)'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             '${param.idNumberFormatDec.format(omzetKartonALK).toString()} CTN',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                   const Padding(padding: EdgeInsets.all(5)),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       SizedBox(
                //                         width: 120 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('Total Rp ALK'),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: const Text('0',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                       SizedBox(
                //                         width: 100 *
                //                             ScaleSize.textScaleFactor(context),
                //                         child: Text(
                //                             'Rp. ${param.enNumberFormat.format(totalOrderALK).toString()}',
                //                             textAlign: TextAlign.center),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ))),
                //     ],
                //   ),
                // ),
              ),
        // sugeng remark tidak pakain next day
        // floatingActionButton: isLoading
        //     ? const Padding(padding: EdgeInsets.zero)
        //     : FloatingActionButton(
        //         onPressed: () {
        //           nextDay();
        //         },
        //         tooltip: 'Next Day',
        //         child: Icon(
        //           Icons.next_plan,
        //           size: 24 * ScaleSize.textScaleFactor(context),
        //         ),
        //       ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // sugeng end remark
        bottomNavigationBar: isLoading ? SizedBox.shrink() :
        
        Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: ()async{
                    try {
                                  //JIKA TIPE CANVAS MAKA VALIDASI APA SUDAH INPUT STOCK DAN RENCANA RUTE
                      // param.dtFormatDB.format(DateTime.now())
                                  if (widget.user.fdTipeSF == '1' &&
                                      isStartDay == false) {
                                    isRencanaRuteExists = await crute
                                        .checkRencanaRuteExists(param.dtFormatDB
                                            .format(DateTime.now()));
                                    isStockVerifyExists = await cstock
                                        .checkStockVerifyExists(param.dtFormatDB
                                            .format(DateTime.now()));
                      
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
                                    responseCode =
                                        await capi.validasiSfaMsRencanaRute(
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
                                    //Code sent data transaksi di DB via API untuk log
                                    if (!isStartDay) {
                                      //jika belum start day
                                      await syncData(0);
                                      // await cdb.deleteTransactionAndFiles(false);
                                      //sugeng start add proses nextday
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
                                      await prefs.setString(
                                          'startDayDate',
                                          param.dtFormatDB
                                              .format(DateTime.now()));
                      
                                      await syncData(0);
                                      await initLoadPage();
                      
                                      service.invoke("stopService");
                      
                                      if (!mounted) return;
                      
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                            content: Text(
                                                'Sukses mulai hari berikut')));
                                    }
                                    //sugeng end add proses nextday
                      
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
                                  size: 24 * ScaleSize.textScaleFactor(context)),
                        Text('Start Day', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
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
                                    size: 24 * ScaleSize.textScaleFactor(context)),
                          Text('End Day', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
        
        // (isLoading
        //     ? const Padding(padding: EdgeInsets.zero)
        //     : BottomAppBar(
        //         notchMargin: 5,
        //         clipBehavior: Clip.hardEdge,
        //         shape: const CircularNotchedRectangle(),
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: CustomButtonComponent(
                      
        //                 onPressed: ()async{
        //                   try {
        //                           //JIKA TIPE CANVAS MAKA VALIDASI APA SUDAH INPUT STOCK DAN RENCANA RUTE
        //               // param.dtFormatDB.format(DateTime.now())
        //                           if (widget.user.fdTipeSF == '1' &&
        //                               isStartDay == false) {
        //                             isRencanaRuteExists = await crute
        //                                 .checkRencanaRuteExists(param.dtFormatDB
        //                                     .format(DateTime.now()));
        //                             isStockVerifyExists = await cstock
        //                                 .checkStockVerifyExists(param.dtFormatDB
        //                                     .format(DateTime.now()));
                      
        //                             if (!isRencanaRuteExists) {
        //                               if (!mounted) return;
        //                               ScaffoldMessenger.of(context)
        //                                 ..removeCurrentSnackBar()
        //                                 ..showSnackBar(const SnackBar(
        //                                     content: Text(
        //                                         'Tidak bisa Start Day. Belum ada Rencana Rute untuk hari ini')));
        //                               return;
        //                             }
        //                             if (!isStockVerifyExists) {
        //                               if (!mounted) return;
        //                               ScaffoldMessenger.of(context)
        //                                 ..removeCurrentSnackBar()
        //                                 ..showSnackBar(const SnackBar(
        //                                     content: Text(
        //                                         'Stock hari ini belum diverifikasi!')));
        //                               return;
        //                             }
        //                             int responseCode = 0;
        //                             responseCode =
        //                                 await capi.validasiSfaMsRencanaRute(
        //                                     widget.user.fdToken,
        //                                     widget.user.fdKodeSF,
        //                                     widget.user.fdKodeDepo,
        //                                     startDayDate,
        //                                     startDayDate,
        //                                     'S',
        //                                     startDayDate);
        //                             if (responseCode == 401) {
        //                               if (!mounted) return;
        //                               ScaffoldMessenger.of(context).showSnackBar(
        //                                   const SnackBar(
        //                                       content: Text('Session expired')));
        //                               return;
        //                             } else if (responseCode == 0) {
        //                               if (!mounted) return;
        //                               ScaffoldMessenger.of(context).showSnackBar(
        //                                   const SnackBar(
        //                                       content: Text(
        //                                           'Rencana rute belum di approve')));
        //                               return;
        //                             } else if (responseCode == 408) {
        //                               if (!mounted) return;
        //                               ScaffoldMessenger.of(context).showSnackBar(
        //                                   const SnackBar(
        //                                       content: Text('Error timeout')));
        //                               return;
        //                             }
        //                           }
        //                           setState(() {
        //                             isLoading = true;
        //                           });
        //                           bool isDateTimeSettingValid =
        //                               await cother.dateTimeSettingValidation();
                      
        //                           if (isDateTimeSettingValid) {
        //                             //Code sent data transaksi di DB via API untuk log
        //                             if (!isStartDay) {
        //                               //jika belum start day
        //                               await syncData(0);
        //                               // await cdb.deleteTransactionAndFiles(false);
        //                               //sugeng start add proses nextday
        //                             } else if ((isEndDay &&
        //                                     todayDate !=
        //                                         param.dtFormatView
        //                                             .format(DateTime.now())) ||
        //                                 !isStartDay) {
        //                               final SharedPreferences prefs =
        //                                   await SharedPreferences.getInstance();
        //                               final String? fdTanggal =
        //                                   prefs.getString('startDayDate');
                      
        //                               await deleteZip();
        //                               await capi.sendLogTransaction(
        //                                   widget.user, fdTanggal!);
        //                               await cdb.deleteTransactionAndFiles();
                      
        //                               await prefs.clear();
        //                               await prefs.setString(
        //                                   'startDayDate',
        //                                   param.dtFormatDB
        //                                       .format(DateTime.now()));
                      
        //                               await syncData(0);
        //                               await initLoadPage();
                      
        //                               service.invoke("stopService");
                      
        //                               if (!mounted) return;
                      
        //                               ScaffoldMessenger.of(context)
        //                                 ..removeCurrentSnackBar()
        //                                 ..showSnackBar(const SnackBar(
        //                                     content: Text(
        //                                         'Sukses mulai hari berikut')));
        //                             }
        //                             //sugeng end add proses nextday
                      
        //                             if (!mounted) return;
                      
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     settings: const RouteSettings(
        //                                         name: 'startday'),
        //                                     builder: (context) => StartDayPage(
        //                                         user: widget.user,
        //                                         routeName: 'startday',
        //                                         startDayDate: startDayDate)));
        //                           }
                      
        //                           setState(() {
        //                             isLoading = false;
        //                           });
        //                         } catch (e) {
        //                           setState(() {
        //                             isLoading = false;
        //                           });
                      
        //                           if (!mounted) return;
        //                           if (e == 408) {
        //                             ScaffoldMessenger.of(context).showSnackBar(
        //                                 const SnackBar(
        //                                     content: Text('Error timeout')));
        //                             await sessionExpired();
        //                           } else {
        //                             ScaffoldMessenger.of(context)
        //                               ..removeCurrentSnackBar()
        //                               ..showSnackBar(
        //                                   SnackBar(content: Text('error: $e')));
        //                           }
        //                         }
        //                 },
        //                 title: 'Start Day',
        //                 icon: Icon(Icons.man_rounded,
        //                 color: Colors.white,
        //                           size: 24 * ScaleSize.textScaleFactor(context)),
        //               ),
        //             ),
        //             SizedBox(width: 10,),
        //             Expanded(
        //               child: CustomButtonComponent(
        //                 onPressed: (){
        //                   endDayValidation();
        //                 },
                         
        //                 title: 'End Day',
        //                 icon: Icon(
        //                           Icons.airline_seat_recline_normal_rounded,
        //                           color: Colors.white,
        //                           size: 24 * ScaleSize.textScaleFactor(context)),
        //               ),
        //             ),



        //             // Expanded(
        //             //     child: TextButton.icon(
        //             //         style: TextButton.styleFrom(
        //             //             foregroundColor: Colors.amber[600]),
        //             //         onPressed: () async {
                              
        //             //         },
        //             //         icon: Icon(Icons.man_rounded,
        //             //             size: 24 * ScaleSize.textScaleFactor(context)),
        //             //         label: fdJamStartDay == ''
        //             //             ? const Text('Start Day')
        //             //             : Text(
        //             //                 // 'Start Day\n$fdJamStartDay KM $fdKmStartDay',
        //             //                 'Start Day\n$fdJamStartDay',
        //             //                 style: TextStyle(
        //             //                     fontSize: 10 *
        //             //                         ScaleSize.textScaleFactor(context)),
        //             //               ))),
        //             // Expanded(
        //             //     child: TextButton.icon(
        //             //         style: TextButton.styleFrom(
        //             //             foregroundColor: Colors.amber[600]),
        //             //         onPressed: () {
        //             //           endDayValidation();
        //             //         },
        //             //         icon: Icon(
        //             //             Icons.airline_seat_recline_normal_rounded,
        //             //             size: 24 * ScaleSize.textScaleFactor(context)),
        //             //         label: fdJamEndDay == ''
        //             //             ? const Text('End Day')
        //             //             : Text(
        //             //                 // 'End Day\n$fdJamEndDay KM $fdKmEndDay',
        //             //                 'End Day\n$fdJamEndDay',
        //             //                 style: TextStyle(
        //             //                     fontSize: 10 *
        //             //                         ScaleSize.textScaleFactor(context)),
        //             //               ))),
        //           ],
        //         ),
        //       )),
        floatingActionButton: isLoading
            ? const Padding(padding: EdgeInsets.zero)
            :
            //sugeng remark 23.04.2025
            // isEndDay
            //     ? FloatingActionButton(
            //         tooltip: 'New',
            //         onPressed: () {
            //           // Navigator.push(
            //           //     context,
            //           //     MaterialPageRoute(
            //           //         settings: const RouteSettings(name: 'LimitKreditForm'),
            //           //         builder: (context) => LimitKreditFormPage(
            //           //             user: widget.user,
            //           //             lgn: widget.lgn,
            //           //             routeName: 'LimitKreditForm',
            //           //             startDayDate: widget.startDayDate))).then(
            //           //     (value) {
            //           //   initLoadPage();

            //           //   setState(() {});
            //           // });
            //         },
            //         child: Icon(Icons.add,
            //             size: 24 * ScaleSize.textScaleFactor(context)),
            //       )
            //     :
            //sugeng end remark 23.04.2025
            null);
  }

  // Future<int> getImageStandardPlanoFromFTP() async {
  //   bool ftpFileExists = false;

  //   const String ftpHost = '202.137.19.140';
  //   //const int ftpPort = 21;
  //   const String username = 'ftpmduser';
  //   const String password = 'Intercallin20230718*';
  //   const String ftpDirectory = '/home/ftpmduser/standard_planogram';
  //   // ftpDirectory : path diserver, berisi file image planogram
  //   // belakang folder jangan pakai tanda (/)

  //   String localImagePath = '${param.appDir}/${param.imgPathStandardPlano}';
  //   // localImagePath : path didevice utk tampung image planogram hasil download

  //   //String localDownloadFile = '2023-08-01_2023-08-31_SAT_REG_8_3.jpg';
  //   // mplano.PlanogramPeriode pro = mplano.PlanogramPeriode.empty();

  //   List<mplano.StandardPlano> listStdPlano = [];

  //   try {
  //     listStdPlano = await cplano.getStandardPlano();

  //     //1. check if directory exists
  //     // Get the documents directory using path_provider
  //     // Create a subdirectory within the documents directory
  //     Directory customDirectory = Directory(localImagePath);

  //     // Check if the directory already exists
  //     if (await customDirectory.exists()) {
  //       print('Directory already exists: ${customDirectory.path}');
  //     } else {
  //       // Create the directory
  //       customDirectory.create().then((Directory newDirectory) {
  //         print('Directory created: ${newDirectory.path}');
  //       }).catchError((e) => print('Error creating directory: $e'));
  //     }

  //     //2. trying conecting to server
  //     await showlog('Connecting to FTP ...');
  //     FTPConnect ftpConnect =
  //         FTPConnect(ftpHost, user: username, pass: password);
  //     await ftpConnect.connect();

  //     //3. set Binary mode to ensure that the files are transferred exactly as they are
  //     await ftpConnect.setTransferType(TransferType.binary);

  //     //4. check if source directory ftp server exists
  //     await ftpConnect.changeDirectory(ftpDirectory);
  //     String dircur = await ftpConnect.currentDirectory();
  //     if (dircur.isNotEmpty) {
  //       await showlog('Downloading ...');

  //       //5. copying file from ftp server to device
  //       // var i = 0;
  //       // while (i < listStdPlano.length) {
  //       //   var localDownloadFile =
  //       //       '${listStdPlano[i].fdNamaLangganan}_${listStdPlano[i].fdTipe}_${listStdPlano[i].fdNoUrut}.jpg';

  //       //   ftpFileExists =
  //       //       await ftpConnect.existFile('$dircur/$localDownloadFile');
  //       //   if (ftpFileExists) {
  //       //     await ftpConnect.downloadFile(
  //       //         localDownloadFile, File('$localImagePath/$localDownloadFile'),
  //       //         onProgress: showDownloadProgress);
  //       //   }

  //       //   i++;
  //       // }

  //       String localDownloadFile = 'D.zip';
  //       ftpFileExists =
  //           await ftpConnect.existFile('$dircur/$localDownloadFile');
  //       if (ftpFileExists) {
  //         await ftpConnect.downloadFile(
  //             localDownloadFile, File('$localImagePath/$localDownloadFile'),
  //             onProgress: showDownloadProgress);
  //         try {
  //           ZipFile.extractToDirectory(
  //               zipFile: File('$localImagePath/$localDownloadFile'),
  //               destinationDir: Directory('$localImagePath/'));
  //         } catch (e) {
  //           print(e);
  //         }
  //       }
  //     } else {
  //       await showlog('Source directory not exists ');
  //       return 1;
  //     }

  //     await ftpConnect.disconnect();
  //     return 0;
  //   } catch (e) {
  //     await showlog('Downloading FAILED: ${e.toString()}');
  //     return 1;
  //   }
  // }
}
