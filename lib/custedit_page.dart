import 'dart:async';
import 'dart:io';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_ce/device_info_ce.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'previewphoto_page.dart';
import 'controller/camera.dart' as ccam;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/salesman_cont.dart' as csales;
import 'controller/other_cont.dart' as cother;
import 'models/database.dart' as mdbconfig;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;
import 'package:sqflite/sqflite.dart';
import 'package:geolocator/geolocator.dart';
import '../models/provinsi.dart' as mprov;
import '../models/kabupaten.dart' as mkab;
import '../models/kecamatan.dart' as mkec;
import '../models/kelurahan.dart' as mkel;
import '../models/tipedetail.dart' as mdetail;
import '../models/tipeoutlet.dart' as mtpoutlet;
import '../models/distcenter.dart' as mdistcenter;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path/path.dart' as cpath;
import 'models/database.dart' as cdbconfig;
import '../models/salesman.dart' as msf;

List<Map<String, dynamic>> resultMaps = [];
List<mdistcenter.DistCenter> ListDistCenter = [];
List<mtpoutlet.TipeOutlet> ListTipeOutlet = [];
List<mprov.Propinsi> ListProvinsi = [];
Map<dynamic, dynamic> TempListProvinsi = {};
List<mkab.Kabupaten> ListKabupaten = [];
List<mkec.Kecamatan> ListKecamatan = [];
List<mkel.Kelurahan> ListKelurahan = [];
List<mdetail.TipeDetail> ListBadanUsaha = [];
List<mdetail.TipeDetail> ListKelasOutlet = [];
int res = 0;
String? stateKodeGroup = '';
String stateGroupLangganan = '';
String? stateKodeDC = '';
String stateDC = '';
String endVisitActivity = '03';
bool isEdit = false;
bool bGPSstat = false;
String imgReasonNotVisitPath = '';
Position? posGPS =  Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);

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
var selectedMinggu = [];
var selectedHari = [];

List<dynamic> setMinggu = [];
List<MultiSelectItem> initMinggu = [
  MultiSelectItem(3, '3'),
  MultiSelectItem(4, '4')
];

List<MultiSelectItem> initHari = [];
List<MultiSelectItem> setHari = [
  MultiSelectItem<int>(5, 'Jumat'),
  MultiSelectItem<int>(6, 'Sabtu'),
];
const List<Widget> statusAktif = <Widget>[Text('Ya'), Text('Tidak')];

bool isStatusSent = false;
bool newValue = false;
bool isSave = false;
late Database db;

class CustEditPage extends StatefulWidget {
  final msf.Salesman user;
  final String fdKodeLangganan;
  final String routeName;
  final String startDayDate;

  const CustEditPage(
      {super.key,
      required this.user,
      required this.fdKodeLangganan,
      required this.routeName,
      required this.startDayDate});

  @override
  State<CustEditPage> createState() => LayerCustEdit();
}

class LayerCustEdit extends State<CustEditPage> {
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  List<bool> _selectedStatusAktif = <bool>[true, false];
  bool vertical = false;
  TextEditingController _namaToko = TextEditingController();
  String _owner = '';
  String _contactPerson = '';
  String _telephone = '';
  String _mobilephone = '';
  String _alamat = '';
  String _kodepos = '';
  String _npwp = '';
  String _npwpnama = '';
  String _npwpalamat = '';
  String _ktp = '';

  bool isLoading = false;
  bool isLoadTokoLuar1 = false;
  bool isLoadKtp = false;
  bool isLoadTokoDalam1 = false;
  bool isLoadNpwp = false;
  bool isExistTokoLuar1 = false;
  bool isExistKTP = false;
  bool isExistTokoDalam1 = false;
  bool isExistNPWP = false;
  bool isExistRute = false;
  String npwpImgName = '';
  String tkluarImgName1 = '';
  String tkdalamImgName1 = '';
  String ktpImgName = '';
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
  String? _patokan = '';

  String selectedKodeRute = '';
  String selectedTipeOutlet = '';
  String selectedTipeHarga = '';
  String selectedGroupOutlet = '';

  String stateGroupOutlet = '';
  int stateStatusAktif = 1;

  String keyTipeOutlet = '';
  String keyTipeHarga = '';
  String keyGroupOutlet = '';
  String _selectedPrefix = '';

  String fileName = '';
  String noEntry = '';

  String? noSJ;
  late StateSetter internalSetter;
  @override
  void initState() {
    // ListGroupLangganan.clear();
    ListDistCenter.clear();
    _namaToko.text = '';

    String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
    fileName = '9$tanggal';

    setState(() {});

    initLoadPage();
    super.initState();
  }

  void initLoadPage() async {
    setState(() {
      isLoading = true;
    });
    await handlePermission();
    await getEditNOO();

    setState(() {
      isLoading = true;

      tkluarImgName1 =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(1, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TL1', widget.startDayDate)}';
      npwpImgName =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(2, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'NPWP', widget.startDayDate)}';
      tkdalamImgName1 =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(3, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TD1', widget.startDayDate)}';
      ktpImgName =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(4, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'KTP', widget.startDayDate)}';
    });
    // await getEditNOOfoto();
    await LoadImage();

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      return false;
    }

    //Request Permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    posGPS = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    bGPSstat = serviceEnabled;

    return true;
  }

  Widget getImage(String imgPath, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewPictureScreen(
                      imgBytes: File(imgPath).readAsBytesSync())));
        },
        child: Stack(
          children: [
            Ink.image(
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
        ));
  }

  Widget getImageOnly(String imgPath, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewPictureScreen(
                      imgBytes: File(imgPath).readAsBytesSync())));
        },
        child: Stack(
          children: [
            Ink.image(
                image: MemoryImage(File(imgPath).readAsBytesSync()),
                fit: BoxFit.fitHeight,
                width: 100,
                height: 100),
          ],
        ));
  }

  void yesNoDialogForm(String imgPath, int index) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus?',
        onOk: () async {
          try {
            // 1. Eksekusi proses hapus file gambar
            await deleteImage(imgPath, index);

            // 2. Safety check mounted sebelum Navigator
            if (!mounted) return;
            
            // 3. Tutup dialog
            Navigator.pop(context);

            // 4. Update state sesuai dengan jenis gambar yang dihapus
            setState(() {
              switch (index) {
                case 1:
                  isExistTokoLuar1 = false;
                  isLoadTokoLuar1 = false;
                  break;
                case 2:
                  isExistNPWP = false;
                  isLoadNpwp = false;
                  break;
                case 3:
                  isExistTokoDalam1 = false;
                  isLoadTokoDalam1 = false;
                  break;
                case 4:
                  isExistKTP = false;
                  isLoadKtp = false;
                  break;
                default:
                  break;
              }
            });

            // 5. Panggil initLoadPage jika diperlukan
            // initLoadPage();
            
          } catch (e) {
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

  Future<void> deleteImage(String filePath, int index) async {
    await File(filePath).exists().then((isExist) {
      if (isExist) {
        File(filePath).delete();
      }
      if (index == 1) {
        setState(() {
          isExistTokoLuar1 = false;
          isLoadTokoLuar1 = false;
        });
      } else if (index == 2) {
        setState(() {
          isExistNPWP = false;
          isLoadNpwp = false;
        });
      } else if (index == 3) {
        setState(() {
          isExistTokoDalam1 = false;
          isLoadTokoDalam1 = false;
        });
      } else if (index == 4) {
        setState(() {
          isExistKTP = false;
          isLoadKtp = false;
        });
      }
    });
  }

  Future<void> LoadImage() async {
    try {
      if (tkluarImgName1 != '') {
        File(tkluarImgName1).exists().then((value) {
          setState(() {
            isExistTokoLuar1 = value;
            isLoadTokoLuar1 = value;
          });
        });
      } else {
        tkluarImgName1 =
            '${param.appDir}/${param.imgPath}/${param.custEditImgName(1, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TL1', widget.startDayDate)}';
        File(tkluarImgName1).exists().then((value) {
          setState(() {
            isExistTokoLuar1 = value;
            isLoadTokoLuar1 = value;
          });
        });
      }
      if (npwpImgName != '') {
        File(npwpImgName).exists().then((value) {
          setState(() {
            isExistNPWP = value;
            isLoadNpwp = value;
          });
        });
      } else {
        npwpImgName =
            '${param.appDir}/${param.imgPath}/${param.custEditImgName(2, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'NPWP', widget.startDayDate)}';
        File(npwpImgName).exists().then((value) {
          setState(() {
            isExistNPWP = value;
            isLoadNpwp = value;
          });
        });
      }
      if (tkdalamImgName1 != '') {
        File(tkdalamImgName1).exists().then((value) {
          setState(() {
            isExistTokoDalam1 = value;
            isLoadTokoDalam1 = value;
          });
        });
      } else {
        tkdalamImgName1 =
            '${param.appDir}/${param.imgPath}/${param.custEditImgName(3, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TD1', widget.startDayDate)}';
        File(tkdalamImgName1).exists().then((value) {
          setState(() {
            isExistTokoDalam1 = value;
            isLoadTokoDalam1 = value;
          });
        });
      }
      if (ktpImgName != '') {
        File(ktpImgName).exists().then((value) {
          setState(() {
            isExistKTP = value;
            isLoadKtp = value;
          });
        });
      } else {
        ktpImgName =
            '${param.appDir}/${param.imgPath}/${param.custEditImgName(4, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'KTP', widget.startDayDate)}';
        File(ktpImgName).exists().then((value) {
          setState(() {
            isExistKTP = value;
            isLoadKtp = value;
          });
        });
      }
      // setState(() {
      //   isLoading = false;
      //   isLoadTokoLuar1 = false;
      //   isLoadNpwp = false;
      //   isLoadTokoDalam1 = false;
      //   isLoadKtp = false;
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadTokoLuar1 = false;
        isLoadNpwp = false;
        isLoadTokoDalam1 = false;
        isLoadKtp = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<List<dynamic>> setKodeRute(selectedKodeRute) async {
    selectedHari.clear();
    selectedMinggu.clear();
    initHari.clear();
    initMinggu.clear();
    int iHari = 0;
    for (int j = 1; j <= 4; j++) {
      if (int.parse(selectedKodeRute[j]) > 0) {
        selectedMinggu.add(int.parse(selectedKodeRute[j]));
        initMinggu.add(MultiSelectItem(j, '$j'));
        if (iHari == 0) {
          if (selectedKodeRute[j] == '1') {
            selectedHari.add(1);
            initHari.add(MultiSelectItem(1, 'Senin'));
          } else if (selectedKodeRute[j] == '2') {
            selectedHari.add(2);
            initHari.add(MultiSelectItem(2, 'Selasa'));
          } else if (selectedKodeRute[j] == '3') {
            selectedHari.add(3);
            initHari.add(MultiSelectItem(3, 'Rabu'));
          } else if (selectedKodeRute[j] == '4') {
            selectedHari.add(4);
            initHari.add(MultiSelectItem(4, 'Kamis'));
          } else if (selectedKodeRute[j] == '5') {
            selectedHari.add(5);
            initHari.add(MultiSelectItem(5, 'Jumat'));
          } else if (selectedKodeRute[j] == '6') {
            selectedHari.add(6);
            initHari.add(MultiSelectItem(6, 'Sabtu'));
          }
          iHari = 1;
        }
      }
    }
    return setMinggu;
  }

  Future<void> refreshImgPath() async {
    if (isExistTokoLuar1 == true) {
      tkluarImgName1 =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(1, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TL1', widget.startDayDate)}';
    }
    // else {
    //   tkluarImgName1 = '';
    // }
    if (isExistNPWP == true) {
      npwpImgName =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(2, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'NPWP', widget.startDayDate)}';
    }
    // else {
    //   npwpImgName = '';
    // }
    if (isExistTokoDalam1 == true) {
      tkdalamImgName1 =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(3, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TD1', widget.startDayDate)}';
    }
    // else {
    //   tkdalamImgName1 = '';
    // }
    if (isExistKTP == true) {
      ktpImgName =
          '${param.appDir}/${param.imgPath}/${param.custEditImgName(4, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'KTP', widget.startDayDate)}';
    }
    LoadImage();
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
          sKodeRute = '${sKodeRute}0';
        }
      }
      setState(() {
        isExistRute = true;
      });
    }

    return sKodeRute;
  }

  // Future<Map<dynamic, dynamic>> getListTipeOutlet() async {
  //   try {
  //     db = await openDatabase(mdbconfig.dbFullPath,
  //         version: mdbconfig.dbVersion);

  //     var result = await db.rawQuery(
  //         "SELECT * FROM ${cdbconfig.tblTipeOutletMD} order by fdTipeOutlet ");
  //     ListTipeOutlet.clear();
  //     TempListTipeOutlet.clear();
  //     for (var i = 0; i < result.length; i++) {
  //       TempListTipeOutlet[result[i]['fdKodeTipe']] = result[i]['fdTipeOutlet'];
  //     }
  //     setState(() {
  //       ListTipeOutlet = TempListTipeOutlet;
  //     });
  //     print(ListTipeOutlet);
  //     return ListTipeOutlet;
  //   } catch (e) {
  //     throw Exception(e);
  //   } finally {
  //     db.isOpen ? await db.close() : null;
  //   }
  // }

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
    final regex = RegExp(r'^(PT\. |CV\. )');
    final updatedText = _selectedPrefix + currentText4.replaceAll(regex, '');
    _namaToko.value = _namaToko.value.copyWith(
      text: updatedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: updatedText.length),
      ),
    );
  }

  getEditNOO() async {
    String kodeKecamatan = '';
    String kodeKabupaten = '';
    String kodeProvinsi = '';

    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, cdbconfig.dbName);
    final db = await openDatabase(dbFullPath, version: 1);
    var result = await db.rawQuery(
        'SELECT b.* FROM ${cdbconfig.tblLangganan} a '
        'INNER JOIN ${mdbconfig.tblNOO} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeSF = a.fdKodeSF '
        'where b.fdKodeLangganan=? ',
        [widget.fdKodeLangganan]);
    if (result.isNotEmpty) {
      //EDIT
      setState(() {
        isEdit = true;
        noEntry = result[0]['fdKodeNoo'].toString();
        fileName = noEntry;
        stateKodeBadanUsaha = result[0]['fdBadanUsaha'] != null
            ? result[0]['fdBadanUsaha'].toString().trim()
            : '';
        _namaToko = result[0]['fdNamaToko'] != null
            ? TextEditingController(
                text: result[0]['fdNamaToko'].toString().trim())
            : TextEditingController();
        _owner =
            result[0]['fdOwner'] != null ? result[0]['fdOwner'].toString() : '';
        _contactPerson = result[0]['fdContactPerson'] != null
            ? result[0]['fdContactPerson'].toString()
            : '';

        _telephone =
            result[0]['fdPhone'] != null ? result[0]['fdPhone'].toString() : '';
        _mobilephone = result[0]['fdMobilePhone'] != null
            ? result[0]['fdMobilePhone'].toString()
            : '';
        _alamat = result[0]['fdAlamat'] != null
            ? result[0]['fdAlamat'].toString()
            : '';
        stateKodeKelurahan = result[0]['fdKelurahan'].toString();
        _kodepos = result[0]['fdKodePos'] != null
            ? result[0]['fdKodePos'].toString()
            : '';
        _patokan = result[0]['fdPatokan'] != null
            ? result[0]['fdPatokan'].toString()
            : '';
        stateTipeOutlet = result[0]['fdTipeOutlet'] != null
            ? result[0]['fdTipeOutlet'].toString().trim()
            : '';
        LaLg =
            '${result[0]['fdLA'].toString().trim()}, ${result[0]['fdLG'].toString().trim()}';
        fdLA = result[0]['fdLA'].toString();
        fdLG = result[0]['fdLG'].toString();

        _npwp =
            result[0]['fdNPWP'] != null ? result[0]['fdNPWP'].toString() : '';
        _npwpnama = result[0]['fdNamaNPWP'] != null
            ? result[0]['fdNamaNPWP'].toString()
            : '';
        _npwpalamat = result[0]['fdAlamatNPWP'] != null
            ? result[0]['fdAlamatNPWP'].toString()
            : '';
        _ktp = result[0]['fdNIK'] != null ? result[0]['fdNIK'].toString() : '';
        stateKodeKelasOutlet = result[0]['fdKelasOutlet'] != null
            ? result[0]['fdKelasOutlet'].toString().trim()
            : '';
        isStatusSent = result[0]['fdStatusSent'] == 1 ? true : false;
        _selectedStatusAktif =
            result[0]['fdStatusAktif'] == 1 ? [true, false] : [false, true];
      });
    } else {
      //INSERT
      // String notanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
      String dbPath2 = await getDatabasesPath();
      String dbFullPath2 = cpath.join(dbPath2, cdbconfig.dbName);
      final db2 = await openDatabase(dbFullPath2, version: 1);
      var result = await db2.rawQuery(
          "SELECT * FROM ${cdbconfig.tblLangganan} where fdKodeLangganan=? ",
          [widget.fdKodeLangganan]);

      setState(() {
        isEdit = false;
        noEntry = fileName;
        //notanggal;
        stateKodeBadanUsaha = result[0]['fdBadanPerusahaan'] != null
            ? result[0]['fdBadanPerusahaan'].toString().trim()
            : '';
        _namaToko = result[0]['fdNamaLangganan'] != null
            ? TextEditingController(
                text: result[0]['fdNamaLangganan'].toString().trim())
            : TextEditingController();
        _owner =
            result[0]['fdOwner'] != null ? result[0]['fdOwner'].toString() : '';
        _contactPerson = result[0]['fdContactPerson'] != null
            ? result[0]['fdContactPerson'].toString()
            : '';

        _telephone =
            result[0]['fdPhone'] != null ? result[0]['fdPhone'].toString() : '';
        _mobilephone = result[0]['fdMobilePhone'] != null
            ? result[0]['fdMobilePhone'].toString()
            : '';
        _alamat = result[0]['fdAlamat'] != null
            ? result[0]['fdAlamat'].toString()
            : '';
        stateKodeKelurahan = result[0]['fdKelurahan'] != null
            ? result[0]['fdKelurahan'].toString()
            : '0';
        _kodepos = result[0]['fdKodePos'] != null
            ? result[0]['fdKodePos'].toString()
            : '';
        stateTipeOutlet = result[0]['fdKodeTipeOutlet'] != null
            ? result[0]['fdKodeTipeOutlet'].toString().trim()
            : '';
        LaLg =
            '${result[0]['fdLA'].toString().trim()}, ${result[0]['fdLG'].toString().trim()}';
        fdLA = result[0]['fdLA'].toString();
        fdLG = result[0]['fdLG'].toString();

        _npwp =
            result[0]['fdNPWP'] != null ? result[0]['fdNPWP'].toString() : '';
        _npwpnama = result[0]['fdNamaNPWP'] != null
            ? result[0]['fdNamaNPWP'].toString()
            : '';
        _npwpalamat = result[0]['fdAlamatNPWP'] != null
            ? result[0]['fdAlamatNPWP'].toString()
            : '';
        _ktp = result[0]['fdNIK'] != null ? result[0]['fdNIK'].toString() : '';
        stateKodeKelasOutlet = result[0]['fdKodeKlas'] != null
            ? result[0]['fdKodeKlas'].toString().trim()
            : '';
        isStatusSent = result[0]['fdStatusSent'] == 1 ? true : false;
        _selectedStatusAktif =
            result[0]['fdStatusAktif'] == 0 ? [false, true] : [true, false];
      });
    }
  }

  getEditNOOfoto() async {
    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, cdbconfig.dbName);
    final db = await openDatabase(dbFullPath, version: 1);

    try {
      var result = await db.rawQuery(
          "SELECT * FROM ${cdbconfig.tblNOOfoto} where fdKodeNoo=? ",
          [widget.fdKodeLangganan]);
      if (result[0]['fdJenis'] == 'TL') {
        setState(() {
          tkluarImgName1 = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
      if (result[0]['fdJenis'] == 'NPWP') {
        setState(() {
          npwpImgName = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
      if (result[0]['fdJenis'] == 'TD') {
        setState(() {
          tkdalamImgName1 = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
      if (result[0]['fdJenis'] == 'KTP') {
        setState(() {
          ktpImgName = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
    } catch (err) {
      throw Exception(err);
    } finally {
      db.isOpen ? await db.close() : null;
    }
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
        onTap: () {},
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
          return true;
          // if (!isExistTokoLuar1 &&
          //     !isExistNPWP &&
          //     !isExistTokoDalam1 &&
          //     !isExistKTP) {
          //   final value = await showDialog<bool>(
          //       context: context,
          //       builder: (context) {
          //         return SimpleDialog(
          //           title: Container(
          //               color: css.titleDialogColor(),
          //               padding: const EdgeInsets.all(5),
          //               child: const Text('Foto harus ada')),
          //           titlePadding: EdgeInsets.zero,
          //           contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          //           children: [
          //             ElevatedButton(
          //                 onPressed: () {
          //                   Navigator.of(context).pop(false);
          //                 },
          //                 child: const Text('OK'))
          //           ],
          //         );
          //       });

          //   return value == false;
          //   // true;
          // } else {
          //   return true;
          // }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Langganan'),
            actions: const <Widget>[],
          ),
          bottomNavigationBar: isLoading
              ? loadingProgress(ScaleSize.textScaleFactor(context))
              : isStatusSent
                  ? const Text('')
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

                                try {
                                  final statusAirPlaneMode =
                                      await AirplaneModeChecker.instance
                                          .checkAirplaneMode();

                                  if (statusAirPlaneMode ==
                                      AirplaneModeStatus.off) {
                                    bool isGPSMocked = true;

                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy: LocationAccuracy
                                                .bestForNavigation,
                                            timeLimit: Duration(
                                                seconds: param.gpsTimeOut));

                                    isGPSMocked = position.isMocked;

                                    if (!isGPSMocked) {
                                      bool isDateTimeSettingValid = await cother
                                          .dateTimeSettingValidation();

                                      if (isDateTimeSettingValid) {
                                        if (formInputKey.currentState!
                                            .validate()) {
                                          if (LaLg == '' ||
                                              LaLg == '0.0, 0.0' ||
                                              LaLg.isEmpty) {
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Titik GPS harus ada !')));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          }
                                          if (isExistTokoLuar1 == false) {
                                            tkluarImgName1 = '';
                                          }
                                          if (isExistNPWP == false) {
                                            npwpImgName = '';
                                          }
                                          if (isExistTokoDalam1 == false) {
                                            tkdalamImgName1 = '';
                                          }
                                          if (isExistKTP == false) {
                                            ktpImgName = '';
                                          }
                                          if (npwpImgName == '') {
                                            setState(() {
                                              isExistNPWP = false;
                                            });
                                          }
                                          if (ktpImgName == '') {
                                            setState(() {
                                              isExistKTP = false;
                                            });
                                          }
                                          if (npwpImgName == '' &&
                                              ktpImgName == '') {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Foto KTP atau NPWP harus ada !')));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await refreshImgPath();
                                            return;
                                          }
                                          if (tkluarImgName1 == '') {
                                            // tkluarImgName1 =
                                            //     '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';

                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Foto toko luar harus ada !')));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await refreshImgPath();
                                            return;
                                          }
                                          if (tkdalamImgName1 == '') {
                                            // tkdalamImgName1 =
                                            //     '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Foto toko dalam harus ada !')));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await refreshImgPath();
                                            return;
                                          }
                                          if (tkluarImgName1 == '' &&
                                              npwpImgName == '' &&
                                              tkdalamImgName1 == '' &&
                                              ktpImgName == '') {
                                            tkluarImgName1 =
                                                '${param.appDir}/${param.imgPath}/${param.custEditImgName(1, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TL1', widget.startDayDate)}';
                                            npwpImgName =
                                                '${param.appDir}/${param.imgPath}/${param.custEditImgName(2, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'NPWP', widget.startDayDate)}';
                                            tkdalamImgName1 =
                                                '${param.appDir}/${param.imgPath}/${param.custEditImgName(3, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'TD1', widget.startDayDate)}';
                                            ktpImgName =
                                                '${param.appDir}/${param.imgPath}/${param.custEditImgName(4, fileName, widget.user.fdKodeSF, widget.fdKodeLangganan, 'KTP', widget.startDayDate)}';

                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Foto belum ada !')));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          } else {
                                            //insert ke server pakai function insertCust fdAction = 1
                                            res = await cnoo.insertCust(
                                                noEntry,
                                                fileName,
                                                widget.user,
                                                widget.startDayDate,
                                                stateKodeBadanUsaha,
                                                _namaToko.text,
                                                _owner,
                                                _contactPerson,
                                                _telephone,
                                                _mobilephone,
                                                _alamat,
                                                stateKodeKelurahan,
                                                _kodepos,
                                                fdLA,
                                                fdLG,
                                                _patokan,
                                                stateTipeOutlet,
                                                _npwp,
                                                _npwpnama,
                                                _npwpalamat,
                                                _ktp,
                                                stateKodeKelasOutlet,
                                                tkluarImgName1,
                                                npwpImgName,
                                                tkdalamImgName1,
                                                ktpImgName,
                                                widget.fdKodeLangganan,
                                                stateStatusAktif);

                                            if (!mounted) return;
                                            if (res == 99) {
                                              // await csales
                                              //     .updateStatusSentSFAct(
                                              //         widget.user.fdKodeSF,
                                              //         widget.user.fdKodeDepo,
                                              //         widget.fdKodeLangganan,
                                              //         '');
                                              await csales.insertSFActivity(
                                                  widget.user.fdKodeSF,
                                                  widget.user.fdKodeDepo,
                                                  0,
                                                  '',
                                                  param.dateTimeFormatDB
                                                      .format(DateTime.now()),
                                                  param.dateTimeFormatDB
                                                      .format(DateTime.now()),
                                                  position.latitude,
                                                  position.longitude,
                                                  '13',
                                                  widget.fdKodeLangganan,
                                                  0,
                                                  0,
                                                  widget.startDayDate,
                                                  0,
                                                  (await DeviceInfoCe.batteryInfo())!
                                                      .level
                                                      .toString(),
                                                  placeGPS.street,
                                                  placeGPS.subLocality,
                                                  placeGPS
                                                      .subAdministrativeArea,
                                                  placeGPS.postalCode);
                                              if (!mounted) return;
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Berhasil di simpan !')));
                                            } else if (res == 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Gagal di simpan !')));
                                            } else if (res == 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Foto Toko Luar 1 Gagal di simpan !')));
                                            } else if (res == 2) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Foto Toko Luar 2 Gagal di simpan !')));
                                            } else if (res == 3) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Foto Toko Dalam 1 Gagal di simpan !')));
                                            } else if (res == 4) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Foto Toko Dalam 2 Gagal di simpan !')));
                                            } else if (res == 5) {
                                              Navigator.pop(
                                                  context); // gagal simpan tapi masih dapat lanjut transaksi
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Foto Gagal di simpan ke server !')));
                                            } else if (res == 6) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Data Foto Gagal di simpan ke server !')));
                                            } else if (res == 7) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Data Gagal di simpan ke server !')));
                                            } else if (res == 7) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Error timeout')));
                                            }
                                          }
                                        }
                                        if (!mounted) return;
                                      }
                                    } else {
                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                            content: Text(
                                                'Fake GPS terdeteksi, warning sudah diberikan ke admin')));
                                    }
                                  } else {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                          content: Text(
                                              'Mohon matikan air plane mode')));
                                  }
                                  //sugeng remark karena tidak ada foto
                                  // }
                                } on TimeoutException {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                        content: Text('error gps timeout')));
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        SnackBar(content: Text('error: $e')));
                                }
                                //sugeng##

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
                                  ..showSnackBar(
                                      SnackBar(content: Text('error: $e')));
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
                              controller: _namaToko,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Nama Langganan',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Nama Langganan',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              enabled: false,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              onChanged: (text) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            isLoading
                                ? loadingProgress(
                                    ScaleSize.textScaleFactor(context))
                                : isStatusSent
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton.icon(
                                          onPressed: () async {},
                                          icon: Icon(
                                            Icons.map,
                                            color: const Color.fromARGB(
                                                255, 252, 172, 0),
                                            size: 24 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                          ),
                                          label: Text(LaLg == ''
                                              ? 'Pilih Lokasi'
                                              : LaLg),
                                        ))
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            await handlePermission();
                                            Position position = await Geolocator
                                                .getCurrentPosition(
                                                    desiredAccuracy:
                                                        LocationAccuracy.high);
                                            setState(() {
                                              LaLg =
                                                  '${position.latitude.toString()}, ${position.longitude.toString()}';
                                              fdLA =
                                                  position.latitude.toString();
                                              fdLG =
                                                  position.longitude.toString();
                                            });

                                            if (!mounted) return;

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VisitPage(
                                                            la: position
                                                                .latitude,
                                                            lg: position
                                                                .longitude)));
                                          },
                                          icon: Icon(
                                            Icons.map,
                                            color: const Color.fromARGB(
                                                255, 252, 172, 0),
                                            size: 24 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                          ),
                                          label: Text(LaLg == ''
                                              ? 'Pilih Lokasi'
                                              : LaLg),
                                        )),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto NPWP",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          child: isExistNPWP
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          npwpImgName, 2))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          npwpImgName, 2))
                                              : !isStatusSent
                                                  ? isLoadNpwp
                                                      ? loadingProgress(
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context))
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .border_clear,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 30 *
                                                                  ScaleSize
                                                                      .textScaleFactor(
                                                                          context)),
                                                          tooltip:
                                                              'Ambil Foto NPWP',
                                                          onPressed: () {
                                                            isExistNPWP
                                                                ? null
                                                                : setState(() {
                                                                    isLoadNpwp =
                                                                        true;
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
                                                        )
                                                  : const Text('')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto KTP",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          child: isExistKTP
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          ktpImgName, 4))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          ktpImgName, 4))
                                              : !isStatusSent
                                                  ? isLoadKtp
                                                      ? loadingProgress(
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context))
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .border_clear,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 30 *
                                                                  ScaleSize
                                                                      .textScaleFactor(
                                                                          context)),
                                                          tooltip:
                                                              'Ambil Foto KTP',
                                                          onPressed: () {
                                                            isExistKTP
                                                                ? null
                                                                : setState(() {
                                                                    isLoadKtp =
                                                                        true;
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
                                                        )
                                                  : const Text('')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foto Tampak Luar",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          child: isExistTokoLuar1
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          tkluarImgName1, 1))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          tkluarImgName1, 1))
                                              : !isStatusSent
                                                  ? isLoadTokoLuar1
                                                      ? loadingProgress(
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context))
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .border_clear,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 30 *
                                                                  ScaleSize
                                                                      .textScaleFactor(
                                                                          context)),
                                                          tooltip:
                                                              'Ambil Foto Toko Tampak Luar',
                                                          onPressed: () {
                                                            isExistTokoLuar1
                                                                ? null
                                                                : setState(() {
                                                                    isLoadTokoLuar1 =
                                                                        true;
                                                                  });
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto Toko Tampak Luar',
                                                                    tkluarImgName1,
                                                                    widget
                                                                        .routeName,
                                                                    true)
                                                                .then((value) {
                                                              LoadImage();

                                                              setState(() {});
                                                            });
                                                          },
                                                        )
                                                  : const Text('')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Toko Tampak Dalam",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ))),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          child: isExistTokoDalam1
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          tkdalamImgName1, 3))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          tkdalamImgName1, 3))
                                              : !isStatusSent
                                                  ? isLoadTokoDalam1
                                                      ? loadingProgress(
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context))
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .border_clear,
                                                              color: Colors
                                                                  .grey[600],
                                                              size: 30 *
                                                                  ScaleSize
                                                                      .textScaleFactor(
                                                                          context)),
                                                          tooltip:
                                                              'Ambil Foto Toko Tampak Dalam',
                                                          onPressed: () {
                                                            isExistTokoDalam1
                                                                ? null
                                                                : setState(() {
                                                                    isLoadTokoDalam1 =
                                                                        true;
                                                                  });
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto Toko Tampak Dalam',
                                                                    tkdalamImgName1,
                                                                    widget
                                                                        .routeName,
                                                                    true)
                                                                .then((value) {
                                                              LoadImage();

                                                              setState(() {});
                                                            });
                                                          },
                                                        )
                                                  : const Text('')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Toko Aktif",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ))),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ToggleButtons(
                                      direction: vertical
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      onPressed: (int index) {
                                        setState(() {
                                          for (int i = 0;
                                              i < _selectedStatusAktif.length;
                                              i++) {
                                            _selectedStatusAktif[i] =
                                                i == index;
                                          }
                                          if (index == 0) {
                                            stateStatusAktif =
                                                1; //1 =aktif, 0 = draft, 2 = inactive
                                          } else {
                                            stateStatusAktif =
                                                3; //3 = void di master
                                          }
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      selectedBorderColor: Colors.blue,
                                      selectedColor: Colors.white,
                                      fillColor: Colors.blue,
                                      color: Colors.red[300],
                                      borderColor: Colors.blue,
                                      splashColor: Colors.blue[200],
                                      constraints: const BoxConstraints(
                                        minHeight: 40.0,
                                        minWidth: 80.0,
                                      ),
                                      isSelected: _selectedStatusAktif,
                                      children: statusAktif,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ));
                  }),
                ))),
          ),
        ));
  }
}

//Visit Page open Map
class VisitPage extends StatefulWidget {
  final double la;
  final double lg;

  const VisitPage({super.key, required this.la, required this.lg});

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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
          title: const Text('Pilih Lokasi'),
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
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
                : loadingProgress(ScaleSize.textScaleFactor(context)))
          ],
        ));
  }
}
