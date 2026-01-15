import 'dart:io';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'previewphoto_page.dart';
import 'controller/camera.dart' as ccam;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/provinsi_cont.dart' as cprov;
import 'controller/kabupaten_cont.dart' as ckab;
import 'controller/kecamatan_cont.dart' as ckec;
import 'controller/kelurahan_cont.dart' as ckel;
import 'controller/tipedetail_cont.dart' as cdetail;
import 'controller/tipeoutlet_cont.dart' as ctpoutlet;
import 'controller/other_cont.dart' as cother;
import 'controller/limitkredit_cont.dart' as clk;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;
import 'package:sqflite/sqflite.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/tipeoutlet.dart' as mtoutlet;
import '../models/provinsi.dart' as mprov;
import '../models/kabupaten.dart' as mkab;
import '../models/kecamatan.dart' as mkec;
import '../models/kelurahan.dart' as mkel;
import '../models/tipedetail.dart' as mdetail;
import '../models/tipeoutlet.dart' as mtpoutlet;
import '../models/distcenter.dart' as mdistcenter;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path/path.dart' as cpath;
import 'models/database.dart' as cdbconfig;
import '../models/salesman.dart' as msf;
import '../models/limitkredit.dart' as mlk;

List<Map<String, dynamic>> resultMaps = [];
List<mdistcenter.DistCenter> ListDistCenter = [];
List<mtpoutlet.TipeOutlet> ListTipeOutlet = [];
// Map<dynamic, dynamic> ListTipeOutlet = {};
// Map<dynamic, dynamic> TempListTipeOutlet = {};
List<mprov.Propinsi> ListProvinsi = [];
Map<dynamic, dynamic> TempListProvinsi = {};
List<mkab.Kabupaten> ListKabupaten = [];
List<mkec.Kecamatan> ListKecamatan = [];
List<mkel.Kelurahan> ListKelurahan = [];
List<mdetail.TipeDetail> ListBadanUsaha = [];
List<mdetail.TipeDetail> ListKelasOutlet = [];
List<mlk.LimitKredit> listLimitKredit = [];
int res = 0;
String? stateKodeGroup = '';
String stateGroupLangganan = '';
String? stateKodeDC = '';
String stateDC = '';

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

bool isStatusSent = false;
bool newValue = false;
bool isSave = false;
late Database db;

class NOOEditPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String? noentry;
  final String startDayDate;

  const NOOEditPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.noentry,
      required this.startDayDate});

  @override
  State<NOOEditPage> createState() => LayerNOOEdit();
}

class LayerNOOEdit extends State<NOOEditPage> {
  TextEditingController _namaToko = TextEditingController();
  TextEditingController _owner = TextEditingController();
  TextEditingController _contactPerson = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _mobilephone = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _patokan = TextEditingController();
  TextEditingController _limitKredit = TextEditingController();
  TextEditingController _kodepos = TextEditingController();
  TextEditingController _npwp = TextEditingController();
  TextEditingController _npwpnama = TextEditingController();
  TextEditingController _npwpalamat = TextEditingController();
  TextEditingController _ktp = TextEditingController();

  bool isLoading = false;
  bool isLoadTokoLuar1 = false;
  bool isLoadKtp = false;
  bool isLoadTokoDalam1 = false;
  bool isLoadNpwp = false;
  bool isLoadNib = false;
  bool isLoadSkp = false;
  bool isLoadSpesimen = false;
  bool isExistTokoLuar1 = false;
  bool isExistKTP = false;
  bool isExistTokoDalam1 = false;
  bool isExistLimitKredit = false;
  bool isExistNPWP = false;
  bool isExistNib = false;
  bool isExistSkp = false;
  bool isExistSpesimen = false;
  bool isExistRute = false;
  String npwpImgName = '';
  String tkluarImgName1 = '';
  String tkdalamImgName1 = '';
  String ktpImgName = '';
  String nibImgName = '';
  String skpImgName = '';
  String spesimenImgName = '';
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

  String selectedKodeRute = '';
  String selectedTipeOutlet = '';
  String selectedTipeHarga = '';
  String selectedGroupOutlet = '';

  String stateGroupOutlet = '';

  String keyTipeOutlet = '';
  String keyTipeHarga = '';
  String keyGroupOutlet = '';
  String _selectedPrefix = '';

  String fileName = '';

  String? noSJ;
  late StateSetter internalSetter;
  @override
  void initState() {
    // ListGroupLangganan.clear();
    ListDistCenter.clear();
    _namaToko.text = '';
    _alamat.text = '';
    _ktp.text = '';
    _telephone.text = '';
    _limitKredit.text = '';

    setState(() {});

    initLoadPage();
    super.initState();
  }

  void initLoadPage() async {
    setState(() {
      isLoading = true;
      fileName = widget.noentry.toString();

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
    });

    // listTipeHarga = await ctoutlet.getTipeOutlet();

    // ListDistCenter = await cdistcenter.getListDistributionCenter();
    // ListGroupLangganan = await cgrouplgn.getAllGroupLangganan();

    ListProvinsi = await cprov.getListProvinsi();
    ListBadanUsaha = await cdetail.getTipeBadanUsaha();
    ListKelasOutlet = await cdetail.getTipeKelasOutlet();
    ListTipeOutlet = await ctpoutlet.getTipeOutlet();

    await getEditNOO();
    await getEditNOOfoto();
    await LoadImage();

    setState(() {
      isLoading = false;
    });
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
            // 1. Proses hapus file gambar berdasarkan path dan index
            await deleteImage(imgPath, index);

            // 2. Tutup dialog segera setelah proses hapus selesai
            if (!mounted) return;
            Navigator.pop(context);

            // 3. Update state spesifik berdasarkan index yang dipilih
            setState(() {
              switch (index) {
                case 1:
                  isExistTokoLuar1 = false;
                  break;
                case 2:
                  isExistNPWP = false;
                  break;
                case 3:
                  isExistTokoDalam1 = false;
                  break;
                case 4:
                  isExistKTP = false;
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

            // 4. Refresh data halaman
            initLoadPage();

          } catch (e) {
            // Handle error jika proses gagal
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
    });
  }

  Future<void> LoadImage() async {
    try {
      File(tkluarImgName1).exists().then((value) {
        setState(() {
          isExistTokoLuar1 = value;
        });
      });
      File(npwpImgName).exists().then((value) {
        setState(() {
          isExistNPWP = value;
        });
      });
      File(tkdalamImgName1).exists().then((value) {
        setState(() {
          isExistTokoDalam1 = value;
        });
      });
      File(ktpImgName).exists().then((value) {
        setState(() {
          isExistKTP = value;
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

  Future<List<dynamic>> setKodeRute(selectedKodeRute) async {
    selectedHari.clear();
    selectedMinggu.clear();
    initHari.clear();
    initMinggu.clear();
    int iHari = 0;
    for (int j = 1; j <= 4; j++) {
      print(selectedKodeRute[j]);
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
        isExistRute = true;
      });
    }

    print(sKodeRute);
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
        "SELECT * FROM ${cdbconfig.tblNOO} where fdKodeNoo=? ",
        [widget.noentry]);

    ListKelurahan =
        await ckel.getListKelurahanByKode(result[0]['fdKelurahan'].toString());
    kodeKecamatan = await ckel
        .getStringKecamatanByKelurahan(result[0]['fdKelurahan'].toString());
    ListKecamatan = await ckec.getListKecamatanByKode(kodeKecamatan);
    kodeKabupaten = await ckec.getStringKabupatenByKecamatan(kodeKecamatan);
    ListKabupaten = await ckab.getListKabupatenByKode(kodeKabupaten);
    kodeProvinsi = await ckab.getStringProvinsiByKabupaten(kodeKabupaten);
    ListProvinsi = await cprov.getListProvinsi();
    setState(() {
      stateKodeBadanUsaha = result[0]['fdBadanUsaha'] != null
          ? result[0]['fdBadanUsaha'].toString().trim()
          : '';
      _namaToko = result[0]['fdNamaToko'] != null
          ? TextEditingController(
              text: result[0]['fdNamaToko'].toString().trim())
          : TextEditingController();
      _owner = result[0]['fdOwner'] != null
          ? TextEditingController(text: result[0]['fdOwner'].toString().trim())
          : TextEditingController();
      _contactPerson = result[0]['fdContactPerson'] != null
          ? TextEditingController(
              text: result[0]['fdContactPerson'].toString().trim())
          : TextEditingController();

      _telephone = result[0]['fdPhone'] != null
          ? TextEditingController(text: result[0]['fdPhone'].toString().trim())
          : TextEditingController();
      _mobilephone = result[0]['fdMobilePhone'] != null
          ? TextEditingController(
              text: result[0]['fdMobilePhone'].toString().trim())
          : TextEditingController();
      _alamat = result[0]['fdAlamat'] != null
          ? TextEditingController(text: result[0]['fdAlamat'].toString().trim())
          : TextEditingController();
      stateKodeProvinsi = kodeProvinsi;
      stateKodeKabupaten = kodeKabupaten;
      stateKodeKecamatan = kodeKecamatan;
      stateKodeKelurahan = result[0]['fdKelurahan'].toString();
      _kodepos = result[0]['fdKodePos'] != null
          ? TextEditingController(
              text: result[0]['fdKodePos'].toString().trim())
          : TextEditingController();
      keyTipeOutlet = result[0]['fdTipeOutlet'] != null
          ? result[0]['fdTipeOutlet'].toString().trim()
          : '';
      stateTipeOutlet = result[0]['fdTipeOutlet'] != null
          ? result[0]['fdTipeOutlet'].toString().trim()
          : '';
      LaLg =
          '${result[0]['fdLA'].toString().trim()}, ${result[0]['fdLG'].toString().trim()}';
      fdLA = result[0]['fdLA'].toString();
      fdLG = result[0]['fdLG'].toString();

      _limitKredit = result[0]['fdLimitKredit'] != null
          ? TextEditingController(
              text: param.idNumberFormat
                      .format(result[0]['fdLimitKredit'] ?? 0)
                      ?.toString() ??
                  '')
          : TextEditingController();
      _npwp = result[0]['fdNPWP'] != null
          ? TextEditingController(text: result[0]['fdNPWP'].toString().trim())
          : TextEditingController();
      _npwpnama = result[0]['fdNamaNPWP'] != null
          ? TextEditingController(
              text: result[0]['fdNamaNPWP'].toString().trim())
          : TextEditingController();
      _npwpalamat = result[0]['fdAlamatNPWP'] != null
          ? TextEditingController(
              text: result[0]['fdAlamatNPWP'].toString().trim())
          : TextEditingController();
      _ktp = result[0]['fdNIK'] != null
          ? TextEditingController(text: result[0]['fdNIK'].toString().trim())
          : TextEditingController();
      stateKodeKelasOutlet = result[0]['fdKelasOutlet'] != null
          ? result[0]['fdKelasOutlet'].toString().trim()
          : '';
      // selectedKodeRute = result[0]['fdKodeRute'] != null
      //     ? result[0]['fdKodeRute'].toString().trim()
      //     : '';
      _patokan = result[0]['fdPatokan'] != null
          ? TextEditingController(
              text: result[0]['fdPatokan'].toString().trim())
          : TextEditingController();
      isStatusSent = result[0]['fdStatusSent'] == 1 ? true : false;
    });
    // await getListTipeOutlet();

    // ListTipeOutlet = await ctpoutlet.getTipeOutlet();
  }

  getEditNOOfoto() async {
    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, cdbconfig.dbName);
    final db = await openDatabase(dbFullPath, version: 1);

    try {
      var result = await db.rawQuery(
          "SELECT * FROM ${cdbconfig.tblNOOfoto} where fdKodeNoo=? ",
          [widget.noentry]);
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
      if (result[0]['fdJenis'] == 'NIB') {
        setState(() {
          nibImgName = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
      if (result[0]['fdJenis'] == 'SKP') {
        setState(() {
          skpImgName = result[0]['fdPath'] != ''
              ? result[0]['fdPath'].toString().trim()
              : '';
        });
      }
      if (result[0]['fdJenis'] == 'SPMN') {
        setState(() {
          spesimenImgName = result[0]['fdPath'] != ''
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
          if (!isExistTokoLuar1 &&
              !isExistNPWP &&
              !isExistTokoDalam1 &&
              !isExistKTP) {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Container(
                        color: css.titleDialogColor(),
                        padding: const EdgeInsets.all(5),
                        child: const Text('Foto harus ada')),
                    titlePadding: EdgeInsets.zero,
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('OK'))
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
            actions: [],
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

                                bool isDateTimeSettingValid =
                                    await cother.dateTimeSettingValidation();

                                if (isDateTimeSettingValid) {
                                  if (isExistTokoLuar1 == true) {
                                    tkluarImgName1 =
                                        '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
                                  } else {
                                    tkluarImgName1 = '';
                                  }
                                  if (isExistNPWP == true) {
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
                                  if (isExistKTP == true) {
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
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (_mobilephone.text.length < 9) {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Nomor telepon seluler harus benar !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (stateTipeOutlet == "") {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Tipe langganan harus diisi !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (stateKodeKelasOutlet == "") {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Kategori langganan harus diisi !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (fdLA == "0" && fdLG == "0") {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Lokasi toko harus dipilih !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (_npwp.text == '' && _ktp.text == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'NPWP atau KTP harus diisi !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  } else if (_npwp.text != '' &&
                                      _npwpnama.text == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Nama NPWP harus diisi !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  } else if (_npwp.text != '' &&
                                      _npwpalamat.text == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Alamat NPWP harus diisi !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }

                                  ///
                                  ///
                                  if (npwpImgName == '' && _npwp.text != '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Foto NPWP harus ada !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (_ktp.text != '' && ktpImgName == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Foto KTP harus ada !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (stateKodeBadanUsaha == '1' &&
                                      skpImgName == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Foto SKP harus ada !')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  if (npwpImgName == '' && ktpImgName == '') {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Foto KTP atau NPWP harus ada !')));
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                  } else {
                                    res = await cnoo.editNOO(
                                        widget.noentry,
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
                                        spesimenImgName);

                                    if (!mounted) return;
                                    if (res == 99) {
                                      //save limit kredit untuk NOO
                                      stringLimitKredit = _limitKredit.text;
                                      stringLimitKredit = stringLimitKredit
                                          .replaceAll(',', '')
                                          .replaceAll('.', '');
                                      nilaiLimitKredit =
                                          (double.tryParse(stringLimitKredit)
                                                  ?.toDouble() ??
                                              0);
                                      listLimitKredit = [
                                        mlk.LimitKredit(
                                          fdNoLimitKredit: widget.noentry,
                                          fdDepo: widget.user.fdKodeDepo,
                                          fdKodeLangganan: widget.noentry,
                                          fdSisaLimit: nilaiLimitKredit,
                                          fdPesananBaru: 0,
                                          fdOverLK: 0,
                                          fdTglStatus: param.dtFormatDB
                                              .format(DateTime.now()),
                                          fdTanggal: param.dtFormatDB
                                              .format(DateTime.now()),
                                          fdLimitKredit: nilaiLimitKredit,
                                          fdPengajuanLimitBaru:
                                              nilaiLimitKredit,
                                          fdKodeStatus: 1,
                                          fdStatusSent: 0,
                                          fdLastUpdate: param.dateTimeFormatDB
                                              .format(DateTime.now()),
                                        )
                                      ];
                                      List<mlk.LimitKredit> items =
                                          listLimitKredit.toList();
                                      await clk.insertLimitKreditBatch(items);

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Berhasil di simpan !')));
                                    } else if (res == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Gagal di simpan !')));
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
                                              content: Text('Error timeout')));
                                    }
                                  }
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
                child: Center(child: Form(
                  child: StatefulBuilder(builder: (context, setState) {
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(5)),
                            DropdownSearch<mdetail.TipeDetail>(
                              itemAsString: (mdetail.TipeDetail item) =>
                                  '${item.fdKode} - ${item.fdNamaDetail}',
                              items: (String filter, LoadProps? loadProps) =>ListBadanUsaha,
                              selectedItem: (ListBadanUsaha.isNotEmpty &&
                                      stateKodeBadanUsaha!.isNotEmpty)
                                  ? ListBadanUsaha.firstWhere((entry) =>
                                      entry.fdKode == stateKodeBadanUsaha)
                                  : null,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _alamat,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Alamat',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Alamat',
                                  null,
                                  null),
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                              enabled: isStatusSent ? false : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            DropdownSearch<mprov.Propinsi>(
                              itemAsString: (mprov.Propinsi item) =>
                                  '${item.fdKodePropinsi} - ${item.fdNamaPropinsi}',
                              items: (String filter, LoadProps? loadProps) =>ListProvinsi,
                              selectedItem: (ListProvinsi.isNotEmpty &&
                                      stateKodeProvinsi!.isNotEmpty)
                                  ? ListProvinsi.firstWhere((entry) =>
                                      entry.fdKodePropinsi == stateKodeProvinsi)
                                  : null,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _patokan,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Patokan',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Patokan',
                                  null,
                                  null),
                              enabled: isStatusSent ? false : true,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                    allow: true)
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            DropdownSearch<mtoutlet.TipeOutlet>(
                              itemAsString: (mtoutlet.TipeOutlet item) =>
                                  '${item.fdTipeOutlet}',
                              items: (String filter, LoadProps? loadProps) =>ListTipeOutlet,
                              selectedItem: (ListTipeOutlet.isNotEmpty &&
                                      stateTipeOutlet!.isNotEmpty)
                                  ? ListTipeOutlet.firstWhere((entry) =>
                                      entry.fdKodeTipe == stateTipeOutlet)
                                  : null,
                              enabled: isStatusSent ? false : true,
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: css.textInputStyle(
                                          'Search Tipe Outlet',
                                          null,
                                          null,
                                          Icon(Icons.search,
                                              size: 24 *
                                                  ScaleSize.textScaleFactor(
                                                      context)),
                                          null)),
                                  searchDelay: const Duration(milliseconds: 0),
                                  itemBuilder: (context, item, isSelected,val) {
                                    return ListTile(
                                      title: Text('${item.fdTipeOutlet}',
                                          style: css.textSmallSize()),
                                    );
                                  },
                                  menuProps: MenuProps(
                                      shape: css.borderOutlineInputRound())),
                              decoratorProps: DropDownDecoratorProps(
                                  decoration: css.textInputStyle(
                                      'Tipe Outlet',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Tipe Outlet',
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
                            const Padding(padding: EdgeInsets.all(5)),
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
                              enabled: isStatusSent ? false : true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                cother.ThousandsSeparatorInputFormatter()
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harus diisi';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _npwp,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'NPWP',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'NPWP',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _npwpnama,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Nama Wajib Pajak',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Nama Wajib Pajak',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _npwpalamat,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'Alamat Pajak',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'Alamat Pajak',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            TextFormField(
                              controller: _ktp,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: css.textInputStyle(
                                  'KTP',
                                  const TextStyle(fontStyle: FontStyle.italic),
                                  'KTP',
                                  null,
                                  null),
                              textCapitalization: TextCapitalization.characters,
                              enabled: isStatusSent ? false : true,
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
                            const Padding(padding: EdgeInsets.all(5)),
                            DropdownSearch<mdetail.TipeDetail>(
                              itemAsString: (mdetail.TipeDetail item) =>
                                  '${item.fdKode} - ${item.fdNamaDetail}',
                              items: (String filter, LoadProps? loadProps) =>ListKelasOutlet,
                              selectedItem: (ListKelasOutlet.isNotEmpty &&
                                      stateKodeKelasOutlet!.isNotEmpty)
                                  ? ListKelasOutlet.firstWhere((entry) =>
                                      entry.fdKode == stateKodeKelasOutlet)
                                  : null,
                              enabled: isStatusSent ? false : true,
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
                            // const Padding(padding: EdgeInsets.all(5)),
                            // DropdownSearch<mgrouplgn.GroupLangganan>(
                            //   itemAsString: (mgrouplgn.GroupLangganan item) =>
                            //       '${item.fdKodeGroupLangganan} - ${item.fdGroupLangganan}',
                            //   items: ListGroupLangganan,
                            //   selectedItem: (ListGroupLangganan.isNotEmpty &&
                            //           stateKodeGroup!.isNotEmpty)
                            //       ? ListGroupLangganan.firstWhere((entry) =>
                            //           entry.fdKodeGroupLangganan ==
                            //           stateKodeGroup)
                            //       : null,
                            //   enabled: isStatusSent ? false : true,
                            //   popupProps: PopupProps.menu(
                            //       showSearchBox: true,
                            //       searchFieldProps: TextFieldProps(
                            //           decoration: css.textInputStyle(
                            //               'Search Group Outlet',
                            //               null,
                            //               null,
                            //               Icon(Icons.search,
                            //                   size: 24 *
                            //                       ScaleSize.textScaleFactor(
                            //                           context)),
                            //               null)),
                            //       searchDelay: const Duration(milliseconds: 0),
                            //       itemBuilder: (context, item, isSelected) {
                            //         return ListTile(
                            //           title: Text(
                            //               '${item.fdKodeGroupLangganan} - ${item.fdGroupLangganan}',
                            //               style: css.textSmallSize()),
                            //         );
                            //       },
                            //       menuProps: MenuProps(
                            //           shape: css.borderOutlineInputRound())),
                            //   dropdownDecoratorProps: DropDownDecoratorProps(
                            //       dropdownSearchDecoration: css.textInputStyle(
                            //           'Group Outlet',
                            //           const TextStyle(
                            //               fontStyle: FontStyle.italic),
                            //           'Group Outlet',
                            //           null,
                            //           null)),
                            //   onChanged: (value) async {
                            //     setState(() {
                            //       stateKodeGroup = value!.fdKodeGroupLangganan;
                            //     });
                            //   },
                            //   validator: (value) {
                            //     if (value == null) {
                            //       return "Harus dipilih";
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.all(5)),
                            // TextFormField(
                            //   controller: _namaToko,
                            //   autovalidateMode: AutovalidateMode.always,
                            //   decoration: css.textInputStyle(
                            //       'Nama Outlet',
                            //       const TextStyle(fontStyle: FontStyle.italic),
                            //       'Nama Outlet',
                            //       null,
                            //       null),
                            //   inputFormatters: [
                            //     FilteringTextInputFormatter(
                            //         RegExp(r'^[\.a-zA-Z0-9, ]*'),
                            //         allow: true)
                            //   ],
                            //   enabled: isStatusSent ? false : true,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Harus diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.all(5)),
                            // TextFormField(
                            //   controller: _kelurahan,
                            //   autovalidateMode: AutovalidateMode.always,
                            //   decoration: css.textInputStyle(
                            //       'Kota',
                            //       const TextStyle(fontStyle: FontStyle.italic),
                            //       'Kota',
                            //       null,
                            //       null),
                            //   inputFormatters: [
                            //     FilteringTextInputFormatter(
                            //         RegExp(r'^[\.a-zA-Z0-9, ]*'),
                            //         allow: true)
                            //   ],
                            //   enabled: isStatusSent ? false : true,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Harus diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.all(5)),
                            // DropdownSearch<mdistcenter.DistCenter>(
                            //   itemAsString: (mdistcenter.DistCenter item) =>
                            //       '${item.fdKodeDC} - ${item.fdDC}',
                            //   items: ListDistCenter,
                            //   selectedItem: (ListDistCenter.isNotEmpty &&
                            //           stateKodeDC!.isNotEmpty)
                            //       ? ListDistCenter.firstWhere(
                            //           (entry) => entry.fdKodeDC == stateKodeDC)
                            //       : null,
                            //   enabled: isStatusSent ? false : true,
                            //   popupProps: PopupProps.menu(
                            //       showSearchBox: true,
                            //       searchFieldProps: TextFieldProps(
                            //           decoration: css.textInputStyle(
                            //               'Search DC',
                            //               null,
                            //               null,
                            //               Icon(Icons.search,
                            //                   size: 24 *
                            //                       ScaleSize.textScaleFactor(
                            //                           context)),
                            //               null)),
                            //       searchDelay: const Duration(milliseconds: 0),
                            //       itemBuilder: (context, item, isSelected) {
                            //         return ListTile(
                            //           title: Text(
                            //               '${item.fdKodeDC} - ${item.fdDC}',
                            //               style: css.textSmallSize()),
                            //         );
                            //       },
                            //       menuProps: MenuProps(
                            //           shape: css.borderOutlineInputRound())),
                            //   dropdownDecoratorProps: DropDownDecoratorProps(
                            //       dropdownSearchDecoration: css.textInputStyle(
                            //           'DC',
                            //           const TextStyle(
                            //               fontStyle: FontStyle.italic),
                            //           'DC',
                            //           null,
                            //           null)),
                            //   onChanged: (value) async {
                            //     setState(() {
                            //       stateKodeDC = value!.fdKodeDC;
                            //     });
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.all(5)),
                            // TextFormField(
                            //   controller: _kdExternal,
                            //   autovalidateMode: AutovalidateMode.always,
                            //   decoration: css.textInputStyle(
                            //       'Kode Outlet',
                            //       const TextStyle(fontStyle: FontStyle.italic),
                            //       'Kode Outlet',
                            //       null,
                            //       null),
                            //   enabled: isStatusSent ? false : true,
                            //   inputFormatters: [
                            //     FilteringTextInputFormatter(
                            //         RegExp(r'^[\.a-zA-Z0-9, ]*'),
                            //         allow: true)
                            //   ],
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Harus diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            // const Padding(padding: EdgeInsets.all(5)),
                            // TextFormField(
                            //   controller: _chiller,
                            //   autovalidateMode: AutovalidateMode.always,
                            //   keyboardType: TextInputType.number,
                            //   inputFormatters: [
                            //     cother.ThousandsSeparatorInputFormatter(),
                            //     FilteringTextInputFormatter(
                            //         RegExp(r'^[\.0-9]*$'),
                            //         allow: true)
                            //   ],
                            //   decoration: css.textInputStyle(
                            //       'Jumlah Chiller',
                            //       const TextStyle(fontStyle: FontStyle.italic),
                            //       'Jumlah Chiller',
                            //       null,
                            //       null),
                            //   enabled: isStatusSent ? false : true,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Harus diisi';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),

                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Foko KTP",
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
                                          child: isExistKTP
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          ktpImgName, 1))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          ktpImgName, 1))
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
                                                              'Ambil Foto Toko Luar (1)',
                                                          onPressed: () {
                                                            isExistKTP
                                                                ? null
                                                                : setState(() {
                                                                    isLoadKtp =
                                                                        true;
                                                                  });
                                                            if (ktpImgName ==
                                                                '') {
                                                              ktpImgName =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(4, fileName, widget.user.fdKodeSF, 'KTP', widget.startDayDate)}';
                                                            }
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
                                          child: isExistNPWP
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          npwpImgName, 1))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          npwpImgName, 1))
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
                                                              'Ambil Foto Toko Luar (1)',
                                                          onPressed: () {
                                                            isExistNPWP
                                                                ? null
                                                                : setState(() {
                                                                    isLoadNpwp =
                                                                        true;
                                                                  });
                                                            if (npwpImgName ==
                                                                '') {
                                                              npwpImgName =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(2, fileName, widget.user.fdKodeSF, 'NPWP', widget.startDayDate)}';
                                                            }
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
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          nibImgName, 5))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          nibImgName, 5))
                                              : !isStatusSent
                                                  ? isLoadNib
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
                                                              'Ambil Foto NIB',
                                                          onPressed: () {
                                                            isExistNib
                                                                ? null
                                                                : setState(() {
                                                                    isLoadNib =
                                                                        true;
                                                                  });
                                                            if (nibImgName ==
                                                                '') {
                                                              nibImgName =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(5, fileName, widget.user.fdKodeSF, 'NIB', widget.startDayDate)}';
                                                            }
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
                                                        )
                                                  : const Text('')),
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
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          skpImgName, 6))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          skpImgName, 6))
                                              : !isStatusSent
                                                  ? isLoadSkp
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
                                                              'Ambil Foto SKP',
                                                          onPressed: () {
                                                            isExistSkp
                                                                ? null
                                                                : setState(() {
                                                                    isLoadSkp =
                                                                        true;
                                                                  });
                                                            if (skpImgName ==
                                                                '') {
                                                              skpImgName =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(6, fileName, widget.user.fdKodeSF, 'SKP', widget.startDayDate)}';
                                                            }
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto SKP',
                                                                    skpImgName,
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
                                                              'Ambil Foto Toko Luar (1)',
                                                          onPressed: () {
                                                            isExistTokoLuar1
                                                                ? null
                                                                : setState(() {
                                                                    isLoadTokoLuar1 =
                                                                        true;
                                                                  });
                                                            if (tkluarImgName1 ==
                                                                '') {
                                                              tkluarImgName1 =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(1, fileName, widget.user.fdKodeSF, 'TL1', widget.startDayDate)}';
                                                            }
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto Toko Luar (1)',
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
                                                              'Ambil Foto Toko Dalam (1)',
                                                          onPressed: () {
                                                            isExistTokoDalam1
                                                                ? null
                                                                : setState(() {
                                                                    isLoadTokoDalam1 =
                                                                        true;
                                                                  });
                                                            if (tkdalamImgName1 ==
                                                                '') {
                                                              tkdalamImgName1 =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(3, fileName, widget.user.fdKodeSF, 'TD1', widget.startDayDate)}';
                                                            }
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto Toko Dalam (1)',
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
                                              ? isStatusSent
                                                  ? SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImageOnly(
                                                          spesimenImgName, 7))
                                                  : SizedBox(
                                                      height: 130,
                                                      width: 100,
                                                      child: getImage(
                                                          spesimenImgName, 7))
                                              : !isStatusSent
                                                  ? isLoadSpesimen
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
                                                              'Ambil Foto Stample',
                                                          onPressed: () {
                                                            isExistSpesimen
                                                                ? null
                                                                : setState(() {
                                                                    isLoadSpesimen =
                                                                        true;
                                                                  });
                                                            if (spesimenImgName ==
                                                                '') {
                                                              spesimenImgName =
                                                                  '${param.appDir}/${param.imgPath}/${param.nooImgName(7, fileName, widget.user.fdKodeSF, 'SPMN', widget.startDayDate)}';
                                                            }
                                                            ccam
                                                                .pickCamera(
                                                                    context,
                                                                    widget.user
                                                                        .fdToken,
                                                                    'Foto Stample',
                                                                    spesimenImgName,
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
