import 'dart:io';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'camera_page.dart';
import 'previewphoto_page.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/database_cont.dart' as cdb;
import 'controller/camera.dart' as ccam;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/logdevice.dart' as mlog;
import 'models/globalparam.dart' as param;
import 'package:path/path.dart' as cpath;
import 'style/css.dart' as css;

class BackupPage extends StatefulWidget {
  final String routeName;
  final msf.Salesman user;
  final String startDayDate;

  const BackupPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.startDayDate});

  @override
  State<BackupPage> createState() => LayerBackup();
}

class LayerBackup extends State<BackupPage> {
  bool isLoading = false;
  List<String> _arrBackup = [];
  List<String> _arrTemp = [];
  List<mlog.Param> listParam = [];
  int maxBackup = 3;

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

      await listBackup();

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

  Future<void> deleteBackup(String nameZip) async {
    String filePath = '${param.appDir}/BACKUP/$nameZip.zip';
    if (File(filePath).existsSync()) {
      await File(filePath).delete();
    }
  }

  Future<void> createBackup(String fdTanggal) async {
    String filePath = '${param.appDir}/BACKUP';
    // String srcZipPath =
    //     '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
    // String yyyyMMdd = fdTanggal.replaceAll('-', '');
    Directory dirBackup = Directory(filePath);
    dirBackup.create().then((Directory newDirectory) {
      print('Directory backup created: ${newDirectory.path}');
    }).catchError((e) => print('Error creating backup directory: $e'));

    // Map<String, dynamic> mapResult =
    //     await cdb.createZipMDAllZipFiles('BACKUP/$yyyyMMdd', srcZipPath);
  }

  Future<List<String>> listBackup() async {
    _arrBackup = [];
    _arrTemp = [];
    String zipNameBackup = '';
    String filePath = '${param.appDir}/BACKUP';
    listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
    maxBackup = listParam[0].fdMaxBackup;

    Directory dirBackup = Directory(filePath);
    dirBackup.create().then((Directory newDirectory) {
      print('Directory backup created: ${newDirectory.path}');
    }).catchError((e) => print('Error creating backup directory: $e'));
    // if (dirNOO.existsSync()) {
    //   int resultNOO =
    //       await cdb.createZipDirectory(nOOPath, '$filePath/NOO.zip');

    //   if (resultNOO != 1) {
    //     throw ('Proses compress file foto NOO gagal');
    //   }
    // }

    //test
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fdTanggal = prefs.getString('startDayDate');

    // await createBackup(fdTanggal!);
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
    }
    return _arrBackup;
  }

  bool isDate(String input, String format) {
    try {
      final DateTime d = DateFormat(format).parseStrict(input);
      //print(d);
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  Future<void> sendBackup(nameZip) async {
    if (nameZip.length < 8) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Format nama file harus yyyyMMdd')));
    } else {
      String startDayDate = nameZip.substring(0, 4) +
          '-' +
          nameZip.substring(4, 6) +
          '-' +
          nameZip.substring(6);
      String zipFilePath = '${param.appDir}/BACKUP/$nameZip.zip';

      // DateTime cekformat = DateFormat("yyyy-MM-dd").parseStrict(startDayDate);

      if (isDate(startDayDate, "yyyy-MM-dd")) {
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
          ..showSnackBar(
              const SnackBar(content: Text('Format nama file harus yyyyMMdd')));
      }
    }
  }

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

                    // await sendUnsentImagetoServer();
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

  void yesNoDialogForm(String nameZip) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: const Text('Lanjut kirim ulang file foto ke server?')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            isLoading
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await sendBackup(nameZip);

                        if (!mounted) return;

                        Navigator.pop(context);

                        setState(() {
                          isLoading = false;
                        });

                        initLoadPage();
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    },
                    child: const Text('Ya')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Tidak'))
          ],
        );
      }),
    );
  }

  void deleteDialogForm(String nmFile) {
    FunctionHelper.AlertDialogCip(context, DialogCip(title: 'Hapus',
      message: 'Lanjut hapus?',
      onOk: ()async{
        try {
                    await deleteBackup(nmFile);

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {});

                    initLoadPage();
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('error: $e')));
                  }
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Backup'),
        ),
        body: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: css.boxDecorMenuHeader(),
                    child: Text('Backup Foto', style: css.textHeaderBold())),
                const Padding(padding: EdgeInsets.all(5)),
                Flexible(
                    child: ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: _arrBackup.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 3,
                        shadowColor: const Color.fromARGB(255, 217, 218, 220),
                        shape: css.boxStyle(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_arrBackup[index],
                                        style: css.textNormalBold()),
                                    const Padding(padding: EdgeInsets.all(3)),
                                  ]),
                            )),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            index >= maxBackup
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: IconButton(
                                      onPressed: () async {
                                        deleteDialogForm(_arrBackup[index]);
                                      },
                                      icon: Icon(Icons.delete,
                                          size: 24 *
                                              ScaleSize.textScaleFactor(
                                                  context)),
                                      color: Colors.red,
                                      tooltip: 'Delete',
                                    ),
                                  )
                                : const Text(''),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: IconButton(
                                onPressed: () async {
                                  yesNoDialogForm(_arrBackup[index]);
                                },
                                icon: Icon(Icons.send_sharp,
                                    size: 24 *
                                        ScaleSize.textScaleFactor(context)),
                                color: Colors.blue,
                                tooltip: 'Send',
                              ),
                            )
                          ],
                        ));
                  },
                )),
              ]));
  }
}
