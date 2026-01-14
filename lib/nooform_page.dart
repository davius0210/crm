import 'dart:async';
import 'dart:io';
import 'package:device_info_ce/device_info_ce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'previewphoto_page.dart';
import 'controller/camera.dart' as ccam;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/database_cont.dart' as cdb;
import 'controller/langganangroup_cont.dart' as cgrouplgn;
import 'controller/other_cont.dart' as cother;
import 'controller/provinsi_cont.dart' as cprov;
import 'controller/kabupaten_cont.dart' as ckab;
import 'controller/kecamatan_cont.dart' as ckec;
import 'controller/kelurahan_cont.dart' as ckel;
import 'controller/tipedetail_cont.dart' as cdetail;
import 'controller/tipeoutlet_cont.dart' as ctpoutlet;
import 'controller/salesman_cont.dart' as csales;
import 'controller/limitkredit_cont.dart' as clk;
import '../models/globalparam.dart' as param;
import 'style/css.dart' as css;
import 'package:sqflite/sqflite.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path/path.dart' as cpath;
import '../models/grouplangganan.dart' as mgrouplgn;
import '../models/distcenter.dart' as mdistcenter;
import '../models/provinsi.dart' as mprov;
import '../models/kabupaten.dart' as mkab;
import '../models/kecamatan.dart' as mkec;
import '../models/kelurahan.dart' as mkel;
import '../models/tipedetail.dart' as mdetail;
import '../models/tipeoutlet.dart' as mtpoutlet;
import '../models/salesman.dart' as msf;
import '../models/limitkredit.dart' as mlk;

List<Map<String, dynamic>> resultMaps = [];
List<mdistcenter.DistCenter> ListDistCenter = [];
List<mgrouplgn.GroupLangganan> ListGroupLangganan = [];
List<mtpoutlet.TipeOutlet> ListTipeOutlet = [];
List<mprov.Propinsi> ListProvinsi = [];
Map<dynamic, dynamic> TempListProvinsi = {};
List<mkab.Kabupaten> ListKabupaten = [];
List<mkec.Kecamatan> ListKecamatan = [];
List<mkel.Kelurahan> ListKelurahan = [];
List<mdetail.TipeDetail> ListBadanUsaha = [];
List<mdetail.TipeDetail> ListKelasOutlet = [];
List<mlk.LimitKredit> listLimitKredit = [];
Map<dynamic, dynamic> TempListKelurahan = {};
Map<dynamic, dynamic> arrImage = {};
bool isImgExist1 = false;
bool isImgExist2 = false;
bool isImgExist3 = false;
bool isSave = false;
bool isNooExists = false;
String _selectedPrefix = '';

List<MultiSelectItem> addMinggu = [
  MultiSelectItem(1, '1'),
  MultiSelectItem(2, '2'),
  MultiSelectItem(3, '3'),
  MultiSelectItem(4, '4'),
];
List<MultiSelectItem> arrHari = [
  MultiSelectItem<int>(1, 'Senin'),
  MultiSelectItem<int>(2, 'Selasa'),
  MultiSelectItem<int>(3, 'Rabu'),
  MultiSelectItem<int>(4, 'Kamis'),
  MultiSelectItem<int>(5, 'Jumat'),
  MultiSelectItem<int>(6, 'Sabtu'),
];

bool newValue = false;
late Database db;

class NooFormPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;

  const NooFormPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.startDayDate});

  @override
  State<NooFormPage> createState() => LayerNOOSave();
}

class LayerNOOSave extends State<NooFormPage> {
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  TextEditingController _namaToko = TextEditingController();
  TextEditingController _owner = TextEditingController();
  TextEditingController _contactPerson = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _mobilephone = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _provinsi = TextEditingController();
  TextEditingController _kabupaten = TextEditingController();
  TextEditingController _kecamatan = TextEditingController();
  TextEditingController _kelurahan = TextEditingController();
  TextEditingController _kodepos = TextEditingController();
  TextEditingController _patokan = TextEditingController();
  TextEditingController _limitKredit = TextEditingController();
  TextEditingController _npwp = TextEditingController();
  TextEditingController _npwpnama = TextEditingController();
  TextEditingController _npwpalamat = TextEditingController();
  TextEditingController _ktp = TextEditingController();

  var selectedMinggu = [];
  var selectedHari = [];
  int res = 0;
  bool isLoading = false;
  bool isLoadTokoLuar1 = false;
  bool isLoadKtp = false;
  bool isLoadNib = false;
  bool isLoadSkp = false;
  bool isLoadTokoDalam1 = false;
  bool isLoadSpesimen = false;
  bool islimitKredit = false;
  bool isLoadNpwp = false;
  bool isExistTokoLuar1 = false;
  bool isExistKtp = false;
  bool isExistNib = false;
  bool isExistSkp = false;
  bool isExistTokoDalam1 = false;
  bool isExistSpesimen = false;
  bool isExistLimitKredit = false;
  bool isExistNpwp = false;
  bool isExistRute = false;
  String npwpImgName = '';
  String tkluarImgName1 = '';
  String tkdalamImgName1 = '';
  String ktpImgName = '';
  String nibImgName = '';
  String skpImgName = '';
  String spesimenImgName = '';
  double doubleLA = 0;
  double doubleLG = 0;
  String fdLA = '0';
  String fdLG = '0';
  String LaLg = '';
  String? stateKodeGroup = '';
  String? stateKodeDC = '';
  String? stateKodeProvinsi = '';
  String? stateKodeKabupaten = '';
  String? stateKodeKecamatan = '';
  String? stateKodeKelurahan = '';
  String? stateKodeBadanUsaha = '';
  String? stateKodeKelasOutlet = '';
  String? stateTipeOutlet = '';
  String stringLimitKredit = '';
  double nilaiLimitKredit = 0;

  String selectedTipeOutlet = '';
  String selectedTipeHarga = '';
  String selectedKodeRute = '';
  String selectedProvinsi = '';
  String selectedKabupaten = '';
  String selectedKecamatan = '';
  String selectedKelurahan = '';

  String keyTipeOutlet = '';
  String keyToko = '';
  String keyProvinsi = '';
  String keyKabupaten = '';
  String keyKecamatan = '';
  String keyKelurahan = '';

  String generateNo = '';
  String noEntry = '';
  String fileName = '';
  String startInput = '';

  String? noSJ;
  late StateSetter internalSetter;

  Position? position =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    ListDistCenter.clear();
    ListGroupLangganan.clear();
    _namaToko.text = '';
    _alamat.text = '';
    _provinsi.text = '';
    _kabupaten.text = '';
    _kecamatan.text = '';
    _kelurahan.text = '';
    fdLA = '0';
    fdLG = '0';
    _limitKredit.text = '';
    _npwp.text = '';
    _npwpnama.text = '';
    _npwpalamat.text = '';
    _ktp.text = '';
    isSave = false;
    String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
    fileName = '9$tanggal';
    noEntry = fileName;
    startInput = param.dateTimeFormatDB.format(DateTime.now());
    initLoadPage();
    super.initState();
  }

  void initLoadPage() async {
    setState(() {
      isLoading = true;
      isLoadKtp = true;
      isLoadTokoLuar1 = true;
      isLoadTokoDalam1 = true;
      isLoadNpwp = true;
      isLoadNib = true;
      isLoadSkp = true;
      isLoadSpesimen = true;
    });

    getFilePath(fileName);

    // await getListTipeOutlet();
    ListGroupLangganan = await cgrouplgn.getAllGroupLangganan();
    await _getGeoLocationPosition();
    ListProvinsi = await cprov.getListProvinsi();
    ListBadanUsaha = await cdetail.getTipeBadanUsaha();
    ListKelasOutlet = await cdetail.getTipeKelasOutlet();
    ListTipeOutlet = await ctpoutlet.getTipeOutlet();

    setState(() {
      isLoading = false;
      isLoadKtp = false;
      isLoadTokoLuar1 = false;
      isLoadTokoDalam1 = false;
      isLoadNpwp = false;
      isLoadNib = false;
      isLoadSkp = false;
      isLoadSpesimen = false;
    });
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

  Future<void> getFilePath(String fileName) async {
    tkluarImgName1 =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
    npwpImgName =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(2, fileName, widget.user.fdKodeSF, 'NPWP', widget.startDayDate)}';
    tkdalamImgName1 =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
    ktpImgName =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(4, fileName, widget.user.fdKodeSF, 'KTP', widget.startDayDate)}';
    nibImgName =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(5, fileName, widget.user.fdKodeSF, 'NIB', widget.startDayDate)}';
    skpImgName =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(6, fileName, widget.user.fdKodeSF, 'SKP', widget.startDayDate)}';
    spesimenImgName =
        '${param.appDir}/${param.imgPath}/${param.nooImgName(7, fileName, widget.user.fdKodeSF, 'SPMN', widget.startDayDate)}';
  }

  Widget getImage(String imgPath, int index) {
    return !isSave && File(imgPath).existsSync()
        ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewPictureScreen(
                          imgBytes: File(imgPath).readAsBytesSync())));
            },
            child: Stack(
              children: [
                FadeInImage(
                    placeholder:
                        const AssetImage('assets/images/transparent.png'),
                    placeholderFit: BoxFit.scaleDown,
                    image: MemoryImage(File(imgPath).readAsBytesSync()),
                    fit: BoxFit.fitHeight,
                    width: 100,
                    height: 100),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.cancel_rounded,
                          size: 24 * ScaleSize.textScaleFactor(context)),
                      color: Colors.red,
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        yesNoDialogForm(imgPath, index);
                      },
                    )),
              ],
            ))
        : IconButton(
            icon: Icon(Icons.border_clear,
                color: Colors.grey[600],
                size: 30 * ScaleSize.textScaleFactor(context)),
            tooltip: '',
            onPressed: () {
              getFilePath(fileName);
              ccam
                  .pickCamera(context, widget.user.fdToken, ' ', tkluarImgName1,
                      widget.routeName, true)
                  .then((value) {
                initLoadPage();

                setState(() {});
              });
            },
          );
  }

  void yesNoDialogForm(String imgPath, int index) {
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
                    await deleteImage(imgPath, index);

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {
                      switch (index) {
                        case 1:
                          isExistTokoLuar1 = false;
                          break;
                        case 2:
                          isExistNpwp = false;
                          break;
                        case 3:
                          isExistTokoDalam1 = false;
                          break;
                        case 4:
                          isExistKtp = false;
                          break;
                        case 5:
                          isExistNib = false;
                          break;
                        case 6:
                          isExistSkp = false;
                          break;
                        case 7:
                          isExistSpesimen = false;
                          break;
                        default:
                          break;
                      }
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
                  Navigator.pop(context);
                },
                child: const Text('Tidak'))
          ],
        );
      }),
    );
  }

  Future<void> deleteImage(String filePath, int index) async {
    await File(filePath).exists().then((isExist) {
      if (isExist) {
        File(filePath).delete();
      }
    });
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getKodeRute() async {
    String sKodeRute = '';
    if (selectedMinggu.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Informasi"),
              content: const Text("Pekan minggu harus dipilih !"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      isExistRute = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else if (selectedHari.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Informasi"),
              content: const Text("Pekan hari harus dipilih !"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      isExistRute = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      sKodeRute = 'P';
      for (int j = 1; j <= 4; j++) {
        int week = 0;
        for (int i = 0; i < selectedMinggu.length; i++) {
          if (selectedMinggu[i] == j) {
            week = 1;
            sKodeRute = sKodeRute + selectedHari[0].toString();
          }
        }
        if (week == 0) {
          sKodeRute = sKodeRute + '0';
        }
      }
      setState(() {
        selectedKodeRute = sKodeRute;
        isExistRute = true;
      });
    }

    print(sKodeRute);
    return sKodeRute;
  }

  // Future<Map<dynamic, dynamic>> getListTipeOutlet() async {
  //   String dbPath = await getDatabasesPath();
  //   String dbFullPath = cpath.join(dbPath, cdbconfig.dbName);
  //   final db = await openDatabase(dbFullPath, version: 1);
  //   var result = await db.rawQuery(
  //       "SELECT * FROM ${cdbconfig.tblTipeOutletMD} order by fdTipeOutlet ");
  //   ListTipeOutlet.clear();
  //   TempListTipeOutlet.clear();
  //   for (var i = 0; i < result.length; i++) {
  //     TempListTipeOutlet[result[i]['fdKodeTipe']] = result[i]['fdTipeOutlet'];
  //   }
  //   setState(() {
  //     ListTipeOutlet = TempListTipeOutlet;
  //   });
  //   print(ListTipeOutlet);
  //   return ListTipeOutlet;
  // }

  void LoadImage() async {
    try {
      File(tkluarImgName1).exists().then((value) {
        setState(() {
          isExistTokoLuar1 = value;
        });
      });
      File(npwpImgName).exists().then((value) {
        setState(() {
          isExistNpwp = value;
        });
      });
      File(tkdalamImgName1).exists().then((value) {
        setState(() {
          isExistTokoDalam1 = value;
        });
      });
      File(ktpImgName).exists().then((value) {
        setState(() {
          isExistKtp = value;
        });
      });
      File(nibImgName).exists().then((value) {
        setState(() {
          isExistNib = value;
        });
      });
      File(skpImgName).exists().then((value) {
        setState(() {
          isExistSkp = value;
        });
      });
      File(spesimenImgName).exists().then((value) {
        setState(() {
          isExistSpesimen = value;
        });
      });
      setState(() {
        isLoading = false;
        isLoadTokoLuar1 = false;
        isLoadNpwp = false;
        isLoadTokoDalam1 = false;
        isLoadKtp = false;
        isLoadNib = false;
        isLoadSkp = false;
        isLoadSpesimen = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadTokoLuar1 = false;
        isLoadNpwp = false;
        isLoadTokoDalam1 = false;
        isLoadKtp = false;
        isLoadNib = false;
        isLoadSkp = false;
        isLoadSpesimen = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<void> _updateText() async {
    // if (_namaToko.text.isEmpty) {
    //   if (fdKodeBadanUsaha == '1') {
    //     _namaToko.text = 'PT. ';
    //   } else if (fdKodeBadanUsaha == '2') {
    //     _namaToko.text = 'CV. ';
    //   } else {}
    // }else{

    // }
    // setState(() {
    //   _namaToko.text = TempListTipeOutlet;
    // });

    final currentText = _namaToko.text;
    final currentText1 = currentText.replaceAll('PT. ', '');
    final currentText2 = currentText1.replaceAll('PT.', '');
    final currentText3 = currentText2.replaceAll('CV. ', '');
    final currentText4 = currentText3.replaceAll('CV.', '');
    final currentText5 = currentText4.replaceAll('UD. ', '');
    final currentText6 = currentText5.replaceAll('UD.', '');
    final regex = RegExp(r'^(PT\. |CV\. |UD\. )');
    final updatedText = _selectedPrefix + currentText6.replaceAll(regex, '');
    _namaToko.value = _namaToko.value.copyWith(
      text: updatedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: updatedText.length),
      ),
    );
  }

  Widget _customPopupItemBuilder(
      BuildContext context, dynamic item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 172, 217, 247),
                Color.fromARGB(255, 203, 228, 245)
              ]),
            ),
      child: ListTile(
        minLeadingWidth: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        selectedTileColor: Colors.orange[100],
        title: Text(item.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 102, 100, 100),
            )),
      ),
    );
  }

  Widget _customDropDownPrograms(BuildContext context, String? item) {
    return Container(
        child: (item == null)
            ? const ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text("Search Programs",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(235, 158, 158, 158))),
              )
            : const ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'item.title',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.5, color: Colors.black),
                )));
  }

  Widget _customDropDownText(BuildContext context, String? name) {
    return Container(
      child: Text(
        name.toString(),
        style: const TextStyle(fontSize: 13.5, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isExistTokoLuar1 ||
              isExistNpwp ||
              isExistTokoDalam1 ||
              isExistKtp ||
              isExistNib ||
              isExistSkp ||
              isExistSpesimen) {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Container(
                        color: css.titleDialogColor(),
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                            'Data dan foto akan terhapus jika belum klik simpan. Lanjut kembali?')),
                    titlePadding: EdgeInsets.zero,
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              isNooExists =
                                  await cnoo.isExistbyfdKodeNoo(noEntry);
                              if (!isNooExists) {
                                String dirCameraPath =
                                    '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}/NOO';
                                var dir = Directory(dirCameraPath);

                                if (await dir.exists()) {
                                  var listFile = dir.listSync(recursive: true);
                                  var listFileFiltered =
                                      listFile.where((element) {
                                    String fileName =
                                        cpath.basename(element.path);

                                    if (fileName.startsWith(
                                        '${param.nooPre}_$noEntry', 0)) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }).toList();

                                  for (var element in listFileFiltered) {
                                    File(element.path).deleteSync();
                                  }
                                }
                                setState(() {
                                  isSave = true;
                                });
                              }
                              if (!mounted) return;
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('error: $e')));
                            }
                          },
                          child: const Text('Ya')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            // Navigator.pop(context);
                          },
                          child: const Text('Tidak'))
                    ],
                  );
                });

            return value == true;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Registrasi Langganan Baru'),
          ),
          bottomNavigationBar: isLoading
              ? loadingProgress(ScaleSize.textScaleFactor(context))
              : Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: BottomAppBar(
                      height: 40 * ScaleSize.textScaleFactor(context),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            if (!mounted) return;

                            setState(() {
                              isLoading = true;
                            });

                            bool isDateTimeSettingValid =
                                await cother.dateTimeSettingValidation();

                            if (isDateTimeSettingValid) {
                              if (formInputKey.currentState!.validate()) {
                                if (isExistTokoLuar1 == true) {
                                  tkluarImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
                                } else {
                                  tkluarImgName1 = '';
                                }
                                if (isExistNpwp == true) {
                                  npwpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(2, fileName, widget.user.fdKodeSF, 'NPWP', widget.startDayDate)}';
                                } else {
                                  npwpImgName = '';
                                }
                                if (isExistTokoDalam1 == true) {
                                  tkdalamImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
                                } else {
                                  tkdalamImgName1 = '';
                                }
                                if (isExistKtp == true) {
                                  ktpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(4, fileName, widget.user.fdKodeSF, 'KTP', widget.startDayDate)}';
                                } else {
                                  ktpImgName = '';
                                }
                                if (isExistNib == true) {
                                  nibImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(5, fileName, widget.user.fdKodeSF, 'NIB', widget.startDayDate)}';
                                } else {
                                  nibImgName = '';
                                }
                                if (isExistSkp == true) {
                                  skpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(6, fileName, widget.user.fdKodeSF, 'SKP', widget.startDayDate)}';
                                } else {
                                  skpImgName = '';
                                }
                                if (isExistSpesimen == true) {
                                  spesimenImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(7, fileName, widget.user.fdKodeSF, 'SPMN', widget.startDayDate)}';
                                } else {
                                  spesimenImgName = '';
                                }

                                if (_telephone.text.length <= 6) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Nomor telepon harus benar !')));
                                  return;
                                }
                                if (_mobilephone.text.length < 9) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Nomor telepon seluler harus benar !')));
                                  return;
                                }
                                if (stateTipeOutlet == "") {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Tipe langganan harus diisi !')));
                                  return;
                                }
                                if (stateKodeKelasOutlet == "") {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Kategori langganan harus diisi !')));
                                  return;
                                }
                                if (fdLA == "0" && fdLG == "0") {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Lokasi toko harus dipilih !')));
                                  return;
                                }
                                if (_npwp.text == '' && _ktp.text == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'NPWP atau KTP harus diisi !')));
                                  return;
                                } else if (_npwp.text != '' &&
                                    _npwpnama.text == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Nama NPWP harus diisi !')));
                                  return;
                                } else if (_npwp.text != '' &&
                                    _npwpalamat.text == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Alamat NPWP harus diisi !')));
                                  return;
                                }

                                if (npwpImgName == '') {
                                  setState(() {
                                    isExistNpwp = false;
                                  });
                                }
                                if (ktpImgName == '') {
                                  setState(() {
                                    isExistKtp = false;
                                  });
                                }
                                if (nibImgName == '') {
                                  setState(() {
                                    isExistNib = false;
                                  });
                                }
                                if (skpImgName == '') {
                                  setState(() {
                                    isExistSkp = false;
                                  });
                                }
                                if (npwpImgName == '' && _npwp.text != '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Foto NPWP harus ada !')));

                                  return;
                                }
                                if (_ktp.text != '' && ktpImgName == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Foto KTP harus ada !')));
                                  return;
                                }
                                if (stateKodeBadanUsaha == '1' &&
                                    skpImgName == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Foto SKP harus ada !')));
                                  return;
                                }
                                if (npwpImgName == '' && ktpImgName == '') {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Foto KTP atau NPWP harus ada !')));
                                  return;
                                }
                                if (tkluarImgName1 == '') {
                                  tkluarImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Foto toko tampak luar harus ada !')));
                                  return;
                                }
                                if (tkdalamImgName1 == '') {
                                  tkdalamImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Foto toko tampak dalam harus ada !')));
                                  return;
                                }
                                if (tkluarImgName1 == '' &&
                                    npwpImgName == '' &&
                                    tkdalamImgName1 == '' &&
                                    ktpImgName == '') {
                                  tkluarImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
                                  npwpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(2, fileName, widget.user.fdKodeSF, 'NPWP', widget.startDayDate)}';
                                  tkdalamImgName1 =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
                                  ktpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(4, fileName, widget.user.fdKodeSF, 'KTP', widget.startDayDate)}';
                                  nibImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(5, fileName, widget.user.fdKodeSF, 'NIB', widget.startDayDate)}';
                                  skpImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(6, fileName, widget.user.fdKodeSF, 'SKP', widget.startDayDate)}';
                                  spesimenImgName =
                                      '${param.appDir}/${param.imgPath}/${param.nooImgName(7, fileName, widget.user.fdKodeSF, 'SPMN', widget.startDayDate)}';

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Foto belum ada !')));
                                  return;
                                } else {
                                  res = await cnoo.insertNOO(
                                      noEntry,
                                      fileName,
                                      widget.user,
                                      widget.startDayDate,
                                      stateKodeBadanUsaha,
                                      _namaToko.text,
                                      _owner.text,
                                      _contactPerson.text,
                                      _telephone.text,
                                      _mobilephone.text,
                                      _alamat.text,
                                      stateKodeKelurahan,
                                      _kodepos.text,
                                      fdLA,
                                      fdLG,
                                      _patokan.text,
                                      stateTipeOutlet,
                                      _limitKredit.text,
                                      _npwp.text,
                                      _npwpnama.text,
                                      _npwpalamat.text,
                                      _ktp.text,
                                      stateKodeKelasOutlet,
                                      tkluarImgName1,
                                      npwpImgName,
                                      tkdalamImgName1,
                                      ktpImgName,
                                      nibImgName,
                                      skpImgName,
                                      spesimenImgName,
                                      '',
                                      1);

                                  if (!mounted) return;
                                  if (res == 99) {
                                    setState(() {
                                      isSave = true;
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Berhasil di simpan !')));
                                  } else if (res == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Gagal di simpan !')));
                                  } else if (res == 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto Toko Luar 1 Gagal di simpan !')));
                                  } else if (res == 2) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto NPWP Gagal di simpan !')));
                                  } else if (res == 3) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto Toko Dalam 1 Gagal di simpan !')));
                                  } else if (res == 4) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto KTP Gagal di simpan !')));
                                  } else if (res == 11) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto NIB Gagal di simpan ke server !')));
                                  } else if (res == 12) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto SKP Gagal di simpan ke server !')));
                                  } else if (res == 13) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto Form Spesimen Gagal di simpan ke server !')));
                                  } else if (res == 5) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto Gagal di simpan ke server !')));
                                  } else if (res == 6) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto Gagal di simpan ke server !')));
                                  } else if (res == 7) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Data Gagal di simpan ke server !')));
                                  } else if (res == 401) {
                                    await sessionExpired();
                                  }

                                  //save limit kredit untuk NOO
                                  stringLimitKredit = _limitKredit.text;
                                  stringLimitKredit = stringLimitKredit
                                      .replaceAll(',', '')
                                      .replaceAll('.', '');
                                  nilaiLimitKredit =
                                      (double.tryParse(stringLimitKredit)
                                              ?.toDouble() ??
                                          0);
                                  if (nilaiLimitKredit > 10) {
                                    listLimitKredit = [
                                      mlk.LimitKredit(
                                        fdNoLimitKredit: noEntry,
                                        fdDepo: widget.user.fdKodeDepo,
                                        fdKodeLangganan: noEntry,
                                        fdSisaLimit: nilaiLimitKredit,
                                        fdPesananBaru: 0,
                                        fdOverLK: 0,
                                        fdTglStatus: param.dtFormatDB
                                            .format(DateTime.now()),
                                        fdTanggal: param.dtFormatDB
                                            .format(DateTime.now()),
                                        fdLimitKredit: nilaiLimitKredit,
                                        fdPengajuanLimitBaru: nilaiLimitKredit,
                                        fdKodeStatus: 1,
                                        fdStatusSent: 0,
                                        fdLastUpdate: param.dateTimeFormatDB
                                            .format(DateTime.now()),
                                      )
                                    ];
                                    List<mlk.LimitKredit> items =
                                        listLimitKredit.toList();
                                    await clk.insertLimitKreditBatch(items);
                                  }
                                  //save data sales activity untuk NOO
                                  await csales.insertSFActivity(
                                      widget.user.fdKodeSF,
                                      widget.user.fdKodeDepo,
                                      0,
                                      '',
                                      startInput,
                                      '',
                                      doubleLA,
                                      doubleLG,
                                      '03',
                                      noEntry,
                                      0,
                                      0,
                                      widget.startDayDate,
                                      0,
                                     (await DeviceInfoCe.batteryInfo())!
                                                      .level
                                          .toString(),
                                      placeGPS.street,
                                      placeGPS.subLocality,
                                      placeGPS.subAdministrativeArea,
                                      placeGPS.postalCode);

                                  //send data to server sales act
                                  // String fdDate = widget.startDayDate;
                                  // String fdDateTime = param.dateTimeFormatDB
                                  //     .format(DateTime.now());
                                  // Map<String, dynamic> result = {};
                                  // try {
                                  //   result = await capi.sendSalesActtoServer(
                                  //       widget.user,
                                  //       startInput,
                                  //       fdDateTime,
                                  //       noEntry,
                                  //       '03',
                                  //       0,
                                  //       '',
                                  //       doubleLA,
                                  //       doubleLG,
                                  //       (await BatteryInfoPlugin()
                                  //               .androidBatteryInfo)!
                                  //           .batteryLevel
                                  //           .toString(),
                                  //       placeGPS!.street,
                                  //       placeGPS!.subLocality,
                                  //       placeGPS!.subAdministrativeArea,
                                  //       placeGPS!.postalCode,
                                  //       fdDateTime,
                                  //       fdDate);
                                  // } catch (e) {
                                  //   result['fdData'] = '0';
                                  //   result['fdMessage'] = e;
                                  // }
                                  // if (result['fdData'] == '401') {
                                  //   return; //stop process
                                  // } else if (result['fdMessage'] == '500') {
                                  //   if (!mounted) return;

                                  //   ScaffoldMessenger.of(context)
                                  //     ..removeCurrentSnackBar()
                                  //     ..showSnackBar(const SnackBar(
                                  //         content: Text('Error timeout')));
                                  //   return;
                                  // } else if (result['fdData'] != '0' ||
                                  //     result['fdMessage'] ==
                                  //         'Tidak ada Data yg masuk ke Server') {
                                  // } else {
                                  //   if (!mounted) return;

                                  //   ScaffoldMessenger.of(context)
                                  //     ..removeCurrentSnackBar()
                                  //     ..showSnackBar(SnackBar(
                                  //         content: Text(result['fdMessage'])));

                                  //   return; //stop process
                                  // }
                                }
                              }
                            }
                          } catch (e) {
                            if (!mounted) return;

                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text('error: $e')));
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Text('Save'),
                      )),
                ),
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            backgroundColor: Colors.yellow,
            color: Colors.red,
            strokeWidth: 2,
            onRefresh: () async {
              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
                reverse: false,
                child: Center(
                    child: Form(
                  key: formInputKey,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              readOnly: true,
                              decoration: css.textInputStyle(
                                  'Plant',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Plant',
                                  null,
                                  null),
                              initialValue: widget.user.fdNamaDepo!,
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            DropdownSearch<mdetail.TipeDetail>(
                              itemAsString: (mdetail.TipeDetail item) =>
                                  '${item.fdNamaDetail}',
                              items: (String filter, LoadProps? loadProps) =>ListBadanUsaha,
                              selectedItem: (ListBadanUsaha.isNotEmpty &&
                                      stateKodeBadanUsaha!.isNotEmpty)
                                  ? ListBadanUsaha.firstWhere((entry) =>
                                      entry.fdKode == stateKodeBadanUsaha)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text('${item.fdNamaDetail}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Badan Perusahaan',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Badan Perusahaan',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                setState(() {
                                  stateKodeBadanUsaha = value!.fdKode;
                                });
                                var newValue = '';
                                if (stateKodeBadanUsaha == '1') {
                                  newValue = 'PT. ';
                                } else if (stateKodeBadanUsaha == '2') {
                                  newValue = 'CV. ';
                                } else if (stateKodeBadanUsaha == '5') {
                                  newValue = 'UD. ';
                                } else {
                                  newValue = '';
                                }
                                _selectedPrefix = newValue;
                                await _updateText();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _namaToko,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Nama Outlet',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Nama Outlet',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              onChanged: (text) {
                                if (!_namaToko.text
                                    .startsWith(_selectedPrefix)) {
                                  _updateText();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _owner,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Owner',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Owner',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _contactPerson,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Contact Person',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Contact Person',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _telephone,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Telpon',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Telpon',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _mobilephone,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Telpon Seluler',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Telpon Seluler',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _alamat,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Alamat',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Alamat',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mprov.Propinsi>(
                              itemAsString: (mprov.Propinsi item) =>
                                  '${item.fdKodePropinsi} - ${item.fdNamaPropinsi}',
                              items: (String filter, LoadProps? loadProps) =>ListProvinsi,
                              selectedItem: (ListProvinsi.isNotEmpty &&
                                      stateKodeProvinsi!.isNotEmpty)
                                  ? ListProvinsi.firstWhere((entry) =>
                                      entry.fdKodePropinsi == stateKodeProvinsi)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKodePropinsi} - ${item.fdNamaPropinsi}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Provinsi',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Provinsi',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                final kodeProvinsi = value!.fdKodePropinsi;
                                final templistKabupaten =
                                    await ckab.getListKabupaten(kodeProvinsi!);
                                setState(() {
                                  stateKodeKabupaten = '';
                                  stateKodeKecamatan = '';
                                  stateKodeKelurahan = '';
                                  stateKodeProvinsi = kodeProvinsi;
                                  ListKabupaten = templistKabupaten;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mkab.Kabupaten>(
                              itemAsString: (mkab.Kabupaten item) =>
                                  '${item.fdKodeKabupaten} - ${item.fdNamaKabupaten}',
                              items: (String filter, LoadProps? loadProps) =>ListKabupaten,
                              selectedItem: (ListKabupaten.isNotEmpty &&
                                      stateKodeKabupaten!.isNotEmpty)
                                  ? ListKabupaten.firstWhere((entry) =>
                                      entry.fdKodeKabupaten ==
                                      stateKodeKabupaten)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKodeKabupaten} - ${item.fdNamaKabupaten}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Kabupaten',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Kabupaten',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                final kodeKabupaten = value!.fdKodeKabupaten;
                                final templistKecamatan =
                                    await ckec.getListKecamatan(kodeKabupaten!);
                                setState(() {
                                  stateKodeKecamatan = '';
                                  stateKodeKelurahan = '';
                                  stateKodeKabupaten = kodeKabupaten;
                                  ListKecamatan = templistKecamatan;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mkec.Kecamatan>(
                              itemAsString: (mkec.Kecamatan item) =>
                                  '${item.fdKodeKecamatan} - ${item.fdNamaKecamatan}',
                              items: (String filter, LoadProps? loadProps) =>ListKecamatan,
                              selectedItem: (ListKecamatan.isNotEmpty &&
                                      stateKodeKecamatan!.isNotEmpty)
                                  ? ListKecamatan.firstWhere((entry) =>
                                      entry.fdKodeKecamatan ==
                                      stateKodeKecamatan)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKodeKecamatan} - ${item.fdNamaKecamatan}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Kecamatan',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Kecamatan',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                final kodeKecamatan = value!.fdKodeKecamatan;
                                final templistKelurahan =
                                    await ckel.getListKelurahan(kodeKecamatan!);
                                setState(() {
                                  stateKodeKelurahan = '';
                                  stateKodeKecamatan = kodeKecamatan;
                                  ListKelurahan = templistKelurahan;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mkel.Kelurahan>(
                              itemAsString: (mkel.Kelurahan item) =>
                                  '${item.fdKodeKelurahan} - ${item.fdNamaKelurahan}',
                              items: (String filter, LoadProps? loadProps) =>ListKelurahan,
                              selectedItem: (ListKelurahan.isNotEmpty &&
                                      stateKodeKelurahan!.isNotEmpty)
                                  ? ListKelurahan.firstWhere((entry) =>
                                      entry.fdKodeKelurahan ==
                                      stateKodeKelurahan)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKodeKelurahan} - ${item.fdNamaKelurahan}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Kelurahan',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Kelurahan',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                setState(() {
                                  stateKodeKelurahan = value!.fdKodeKelurahan;
                                });
                                _kodepos.text =
                                    await ckel.getKodePos(stateKodeKelurahan!);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _kodepos,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Kode Pos',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Kode Pos',
                                  null,
                                  null),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            isLoading
                                ? loadingProgress(
                                    ScaleSize.textScaleFactor(context))
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VisitPage(
                                                    routeName:
                                                        widget.routeName)));

                                        if (result != null) {
                                          if (!mounted) return;

                                          setState(() {
                                            doubleLA = result[0];
                                            doubleLG = result[1];
                                            fdLA = result[0].toString();
                                            fdLG = result[1].toString();

                                            LaLg = '$fdLA, $fdLG';
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.map,
                                        color: const Color.fromARGB(
                                            255, 252, 172, 0),
                                        size: 24 *
                                            ScaleSize.textScaleFactor(context),
                                      ),
                                      label: Text(
                                          LaLg == '' ? 'Lokasi Toko' : LaLg),
                                    )),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _patokan,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Keterangan/Patokan',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Keterangan/Patokan',
                                  null,
                                  null),
                              // keyboardType: TextInputType.number,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Harus diisi';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mdetail.TipeDetail>(
                              itemAsString: (mdetail.TipeDetail item) =>
                                  '${item.fdKode} - ${item.fdNamaDetail}',
                              items: (String filter, LoadProps? loadProps) =>ListKelasOutlet,
                              selectedItem: (ListKelasOutlet.isNotEmpty &&
                                      stateKodeKelasOutlet!.isNotEmpty)
                                  ? ListKelasOutlet.firstWhere((entry) =>
                                      entry.fdKode == stateKodeKelasOutlet)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKode} - ${item.fdNamaDetail}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Kategori Langganan',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Kategori Langganan',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                setState(() {
                                  stateKodeKelasOutlet = value!.fdKode;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            DropdownSearch<mtpoutlet.TipeOutlet>(
                              itemAsString: (mtpoutlet.TipeOutlet item) =>
                                  '${item.fdKodeTipe} - ${item.fdTipeOutlet}',
                              items: (String filter, LoadProps? loadProps) =>ListTipeOutlet,
                              selectedItem: (ListTipeOutlet.isNotEmpty &&
                                      stateTipeOutlet!.isNotEmpty)
                                  ? ListTipeOutlet.firstWhere((entry) =>
                                      entry.fdKodeTipe == stateTipeOutlet)
                                  : null,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text(
                                          '${item.fdKodeTipe} - ${item.fdTipeOutlet}',
                                          style: css.textSmallSizeBlack()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Tipe Langganan',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Tipe Langganan',
                                      null,
                                      null)),
                              onChanged: (value) async {
                                setState(() {
                                  stateTipeOutlet = value!.fdKodeTipe;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Harus dipilih";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _limitKredit,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Limit Kredit',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Limit Kredit',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                cother.EnThousandsSeparatorInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                }
                                // Remove thousands separator for parsing
                                final numericValue = int.tryParse(value
                                    .replaceAll('.', '')
                                    .replaceAll(',', ''));
                                if (numericValue == null) {
                                  return 'Angka tidak valid';
                                }
                                if (numericValue > 100000000) {
                                  return 'Maksimal 100.000.000';
                                }
                                return null;
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _npwp,
                              // autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'NPWP',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'NPWP',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.0-9, ]*'),
                                    allow: true)
                              ],
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Harus diisi';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _npwpnama,
                              // autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Nama Wajib Pajak',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Nama Wajib Pajak',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Harus diisi';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _npwpalamat,
                              // autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Alamat Pajak',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Alamat Pajak',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Harus diisi';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            TextFormField(
                              controller: _ktp,
                              // autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'KTP',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'KTP',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.0-9, ]*'),
                                    allow: true)
                              ],
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Harus diisi';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto KTP",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistKtp
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child:
                                                      getImage(ktpImgName, 4))
                                              : isLoadKtp
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip: 'Ambil Foto KTP',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadKtp = true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto KTP',
                                                                ktpImgName,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto NPWP",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistNpwp
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child:
                                                      getImage(npwpImgName, 2))
                                              : isLoadNpwp
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip:
                                                          'Ambil Foto NPWP',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadNpwp = true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto NPWP',
                                                                npwpImgName,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto NIB",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistNib
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child:
                                                      getImage(nibImgName, 5))
                                              : isLoadNib
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip: 'Ambil Foto NIB',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadNib = true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto NIB',
                                                                nibImgName,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto SKP",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistSkp
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child:
                                                      getImage(skpImgName, 6))
                                              : isLoadSkp
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip: 'Ambil Foto SKP',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadSkp = true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto KTP',
                                                                skpImgName,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Toko Tampak Luar",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistTokoLuar1
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child: getImage(
                                                      tkluarImgName1, 1))
                                              : isLoadTokoLuar1
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip:
                                                          'Ambil Foto Toko Luar',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadTokoLuar1 =
                                                              true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto Toko Luar',
                                                                tkluarImgName1,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                      // SizedBox(
                                      //     child: isExistTokoLuar2
                                      //         ? SizedBox(
                                      //             height: 130,
                                      //             width: 100,
                                      //             child: getImage(
                                      //                 npwpImgName, 2))
                                      //         : isLoadTokoLuar2
                                      //             ? loadingProgress(
                                      //                 ScaleSize.textScaleFactor(
                                      //                     context))
                                      //             : IconButton(
                                      //                 icon: Icon(
                                      //                     Icons.border_clear,
                                      //                     color:
                                      //                         Colors.grey[600],
                                      //                     size: 30 *
                                      //                         ScaleSize
                                      //                             .textScaleFactor(
                                      //                                 context)),
                                      //                 tooltip:
                                      //                     'Ambil Toko Luar (2)',
                                      //                 onPressed: () {
                                      //                   getFilePath(fileName);
                                      //                   setState(() {
                                      //                     isLoadTokoLuar2 =
                                      //                         true;
                                      //                   });
                                      //                   ccam
                                      //                       .pickCamera(
                                      //                           context,
                                      //                           widget.user
                                      //                               .fdToken,
                                      //                           'Foto Toko Luar (2)',
                                      //                           npwpImgName,
                                      //                           widget
                                      //                               .routeName,
                                      //                           true)
                                      //                       .then((value) {
                                      //                     LoadImage();

                                      //                     setState(() {});
                                      //                   });
                                      //                 },
                                      //               )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Toko Tampak Dalam",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ))),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistTokoDalam1
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child: isExistTokoDalam1
                                                      ? getImage(
                                                          tkdalamImgName1, 3)
                                                      : null)
                                              : isLoadTokoDalam1
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip:
                                                          'Ambil Foto Toko Dalam',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadTokoDalam1 =
                                                              true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto Toko Dalam',
                                                                tkdalamImgName1,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                      // SizedBox(
                                      //     child: isExistTokoDalam2
                                      //         ? SizedBox(
                                      //             height: 130,
                                      //             width: 100,
                                      //             child: isExistTokoDalam2
                                      //                 ? getImage(
                                      //                     ktpImgName, 4)
                                      //                 : null)
                                      //         : isLoadTokoDalam2
                                      //             ? loadingProgress(
                                      //                 ScaleSize.textScaleFactor(
                                      //                     context))
                                      //             : IconButton(
                                      //                 icon: Icon(
                                      //                     Icons.border_clear,
                                      //                     color:
                                      //                         Colors.grey[600],
                                      //                     size: 30 *
                                      //                         ScaleSize
                                      //                             .textScaleFactor(
                                      //                                 context)),
                                      //                 tooltip:
                                      //                     'Ambil Foto Toko Dalam (2)',
                                      //                 onPressed: () {
                                      //                   getFilePath(fileName);
                                      //                   setState(() {
                                      //                     isLoadTokoDalam2 =
                                      //                         true;
                                      //                   });
                                      //                   ccam
                                      //                       .pickCamera(
                                      //                           context,
                                      //                           widget.user
                                      //                               .fdToken,
                                      //                           'Foto Toko Dalam (2)',
                                      //                           ktpImgName,
                                      //                           widget
                                      //                               .routeName,
                                      //                           true)
                                      //                       .then((value) {
                                      //                     LoadImage();

                                      //                     setState(() {});
                                      //                   });
                                      //                 },
                                      //               )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto Form Spesimen",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          child: isExistSpesimen
                                              ? SizedBox(
                                                  height: 130,
                                                  width: 100,
                                                  child: getImage(
                                                      spesimenImgName, 7))
                                              : isLoadSpesimen
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.border_clear,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 30 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      tooltip:
                                                          'Ambil Foto Form Spesimen',
                                                      onPressed: () {
                                                        getFilePath(fileName);
                                                        setState(() {
                                                          isLoadSpesimen = true;
                                                        });
                                                        ccam
                                                            .pickCamera(
                                                                context,
                                                                widget.user
                                                                    .fdToken,
                                                                'Foto Form Spesimen',
                                                                spesimenImgName,
                                                                widget
                                                                    .routeName,
                                                                true)
                                                            .then((value) {
                                                          LoadImage();

                                                          setState(() {});
                                                        });
                                                      },
                                                    )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ));
                  }),
                ))),
          ),
        ));
  }
}

class BootcampDetails {}

//Visit Page open Map
class VisitPage extends StatefulWidget {
  final String routeName;

  const VisitPage({super.key, required this.routeName});

  @override
  State<VisitPage> createState() => LayerVisit();
}

class LayerVisit extends State<VisitPage> {
  bool isMapReady = false;
  String startVisitActivity = '03';

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  late GoogleMapController _gMapController;
  Map<MarkerId, Marker> markers = {};
  CameraPosition _userLocation = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _gMapController.dispose();

    super.dispose();
  }

  void gMapInitializes(GoogleMapController controller) async {
    setState(() {
      isMapReady = false;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: param.gpsTimeOut));
//sugeng add 10.06.2025
    try {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((value) {
            placeGPS = value.first;

            street = placeGPS.street;
            subLocality = placeGPS.subLocality;
            subAdministrativeArea = placeGPS.subAdministrativeArea;
            postalCode = placeGPS.postalCode;
          })
          .timeout(Duration(seconds: param.gpsTimeOut))
          .onError((error, stackTrace) {
            placeGPS = Placemark(
                street: '',
                subLocality: '',
                subAdministrativeArea: '',
                postalCode: '');
          });
    } on TimeoutException catch (e) {
      placeGPS = Placemark(
          street: '',
          subLocality: '',
          subAdministrativeArea: '',
          postalCode: '');
    } on Exception catch (e) {
      placeGPS = Placemark(
          street: '',
          subLocality: '',
          subAdministrativeArea: '',
          postalCode: '');
    }
    //sugeng end

    _userLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18);

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 18),
    );

    _gMapController = controller;

    setState(() {
      isMapReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lokasi Toko'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: _userLocation,
                  onMapCreated: gMapInitializes),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            (isMapReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, [
                        _userLocation.target.latitude,
                        _userLocation.target.longitude
                      ]);
                    },
                    child: const Text('OK'))
                : loadingProgress(ScaleSize.textScaleFactor(context)))
          ],
        ));
  }
}
