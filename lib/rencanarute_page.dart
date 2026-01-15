import 'dart:developer';
import 'dart:io';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'rencanaruteform_page.dart';
import 'main.dart';
import 'home_page.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/rute_cont.dart' as crute;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/globalparam.dart' as param;
import 'models/rencanarute.dart' as mrrute;
import 'style/css.dart' as css;

class RencanaRutePage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const RencanaRutePage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<RencanaRutePage> createState() => LayerRencanaRutePage();
}

class LayerRencanaRutePage extends State<RencanaRutePage> {
  bool isLoading = false;
  List<mrrute.RencanaRute> listRencanaRute = [];

  Map<String, List<mbrg.Satuan>> satuanPerBarang = {};
  Map<String, String?> satuanSelectedPerBarang = {};
  List<Map<String, dynamic>> konversiSatuanBarang = [];

  TextEditingController txtTanggalAwal = TextEditingController();
  TextEditingController stateTanggalAwal = TextEditingController();
  TextEditingController txtTanggalAkhir = TextEditingController();
  TextEditingController stateTanggalAkhir = TextEditingController();
  TextEditingController txtStockRequest = TextEditingController();
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();

  bool checkSave = false;
  bool isDataExist = false;

  String strStartDate = '';
  String strEndDate = '';
  String ymdStartDate = '';
  String ymdEndDate = '';
  String fdNoRencanaRute = '';

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

      listRencanaRute = await crute.getAllRencanaRute();

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
          : param.dtFormatViewMMM.parse(txtEdit.text),
      firstDate: DateTime.now(),
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

  void yesNoDialogForm(String fdNoRencanaRute) {
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
                    List<mrrute.RencanaRuteApi> listRencanaRuteApi = await crute
                        .getDataDeleteRencanaRuteApi(fdNoRencanaRute);
                    mrrute.RencanaRuteApi result =
                        await capi.sendRencanaRutetoServer(widget.user, '2',
                            widget.startDayDate, listRencanaRuteApi);

                    if (result.fdData != '0' &&
                        result.fdData != '401' &&
                        result.fdData != '500' &&
                        result.fdMessage == '') {
                      await crute.deleteRencanaRuteBatch(fdNoRencanaRute);
                      initLoadPage();
                      if (!mounted) return;
                    } else if (result.fdMessage!.isNotEmpty) {
                      setState(() {
                        isLoading = false;
                      });
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.fdMessage!)));
                    }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: !isLoading
          ? () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      settings: const RouteSettings(name: 'home'),
                      builder: (context) => HomePage(user: widget.user!)),
                  (Route<dynamic> route) => false);

              return false;
            }
          : () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rencana Rute'),
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
              const Padding(padding: EdgeInsets.all(5)),
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: txtTanggalAwal,
                              readOnly: true,
                              decoration: css.textInputStyle(
                                'Periode awal',
                                const TextStyle(fontStyle: FontStyle.italic),
                                'Periode awal',
                                null,
                                null,
                              ),
                              onTap: () async {
                                stateTanggalAwal = txtTanggalAwal;
                                await showCalendar(stateTanggalAwal);
                                if (txtTanggalAwal.text.isNotEmpty) {
                                  DateTime selectedStartDate = param
                                      .dtFormatViewMMM
                                      .parse(txtTanggalAwal.text);
                                  txtTanggalAwal.text =
                                      DateFormat('dd MMM yyyy')
                                          .format(selectedStartDate);
                                  strStartDate = selectedStartDate.toString();
                                  ymdStartDate = DateFormat('yyyy-MM-dd')
                                      .format(selectedStartDate);
                                }
                              },
                            ),
                          ),
                          const Text(' to '),
                          Expanded(
                            child: TextFormField(
                              controller: txtTanggalAkhir,
                              readOnly: true,
                              decoration: css.textInputStyle(
                                'Periode akhir',
                                const TextStyle(fontStyle: FontStyle.italic),
                                'Periode akhir',
                                null,
                                null,
                              ),
                              onTap: () async {
                                stateTanggalAkhir = txtTanggalAkhir;
                                await showCalendar(stateTanggalAkhir);
                                if (txtTanggalAkhir.text.isNotEmpty) {
                                  DateTime selectedEndDate = param
                                      .dtFormatViewMMM
                                      .parse(txtTanggalAkhir.text);
                                  strEndDate = selectedEndDate.toString();
                                  txtTanggalAkhir.text =
                                      DateFormat('dd MMM yyyy')
                                          .format(selectedEndDate);
                                  ymdEndDate = DateFormat('yyyy-MM-dd')
                                      .format(selectedEndDate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Divider(
                        height: 1,
                        thickness: 3,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: listRencanaRute.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 3,
                    shadowColor: Colors.blue,
                    shape: css.boxStyle(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: 'Rencana Rute Form'),
                                    builder: (context) => RencanaRuteFormPage(
                                        user: widget.user,
                                        startDayDate: widget.startDayDate,
                                        isEndDay: widget.isEndDay,
                                        strStartDate:
                                            listRencanaRute[index].fdStartDate!,
                                        strEndDate:
                                            listRencanaRute[index].fdEndDate!,
                                        fdNoRencanaRute: listRencanaRute[index]
                                            .fdNoRencanaRute,
                                        fdAction: '1',
                                        routeName: 'RencanaRuteForm')))
                            .then((value) {
                          initLoadPage();

                          setState(() {});
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No : ${listRencanaRute[index].fdNoRencanaRute}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                    Text(
                                      'Periode : ${DateFormat('dd MMM yyyy').format(param.dtFormatDB.parse(listRencanaRute[index].fdStartDate!))} - ${DateFormat('dd MMM yyyy').format(param.dtFormatDB.parse(listRencanaRute[index].fdEndDate!))}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: IconButton(
                                onPressed: () async {
                                  yesNoDialogForm(
                                      listRencanaRute[index].fdNoRencanaRute);
                                },
                                icon: Icon(Icons.delete,
                                    size: 24 *
                                        ScaleSize.textScaleFactor(context)),
                                color: Colors.red[400],
                                tooltip: 'Delete',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
            ])),
        bottomNavigationBar: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : InkWell(
              onTap: ()async{
                if (formInputKey.currentState!.validate()) {
                      if (strStartDate.isEmpty || strEndDate.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Periode harus diisi')));
                        return;
                      }

                      isDataExist = await crute.checkPeriodRencanaRute(
                          ymdStartDate, ymdEndDate);
                      if (isDataExist) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tanggal sudah terpakai')));
                        return;
                      } else {
                        int responseCode = 0;
                        responseCode = await capi.validasiSfaMsRencanaRute(
                            widget.user.fdToken,
                            widget.user.fdKodeSF,
                            widget.user.fdKodeDepo,
                            ymdStartDate,
                            ymdEndDate,
                            '',
                            '');
                        if (responseCode == 401) {
                          // await sessionExpired();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Session expired')));
                          return;
                        } else if (responseCode == 0) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Tanggal periode ada yang sudah terdaftar')));
                          return;
                        } else if (responseCode == 408) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error timeout')));
                          return;
                        } else {
                          fdNoRencanaRute = DateFormat('yyMMddHHmmssSSS')
                              .format(DateTime.now());
                          print(fdNoRencanaRute);
                          List<mrrute.RencanaRuteApi> listRencanaRuteApi = [];
                          listRencanaRuteApi.add(mrrute.RencanaRuteApi(
                            fdKodeDepo: widget.user.fdKodeDepo,
                            fdNoRencanaRute: fdNoRencanaRute,
                            fdStartDate: ymdStartDate,
                            fdEndDate: ymdEndDate,
                            fdTanggal: widget.startDayDate,
                            fdKodeSF: widget.user.fdKodeSF,
                            fdKodeStatus: '0',
                            fdTanggalRencanaRute: '',
                            fdKodeLangganan: '',
                            fdNamaLangganan: '',
                            fdAlamat: '',
                            fdPekan: '',
                            fdHari: '',
                            fdLastUpdate: '',
                          ));
                          mrrute.RencanaRuteApi result =
                              await capi.sendRencanaRutetoServer(widget.user,
                                  '0', widget.startDayDate, listRencanaRuteApi);

                          if (result.fdData != '0' &&
                              result.fdData != '401' &&
                              result.fdData != '500' &&
                              result.fdMessage == '') {
                            await crute.insertRencanaRuteBatch(
                                widget.user.fdKodeDepo,
                                fdNoRencanaRute,
                                ymdStartDate,
                                ymdEndDate,
                                widget.startDayDate,
                                widget.user.fdKodeSF);
                            if (!mounted) return;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: 'Rencana Rute Form'),
                                    builder: (context) => RencanaRuteFormPage(
                                        user: widget.user,
                                        startDayDate: widget.startDayDate,
                                        isEndDay: widget.isEndDay,
                                        strStartDate: strStartDate,
                                        strEndDate: strEndDate,
                                        fdNoRencanaRute: fdNoRencanaRute,
                                        fdAction: '0',
                                        routeName: 'RencanaRuteForm'))).then(
                                (value) {
                              initLoadPage();

                              setState(() {});
                            });
                          } else if (result.fdMessage!.isNotEmpty) {
                            setState(() {
                              isLoading = false;
                            });
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.fdMessage!)));
                          }
                        }
                      }
                    }
              },
              child: Ink(
                height: 70,
                color: ColorHelper.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Apply', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    Icon(Icons.check_circle, color: Colors.white,)
                  ],
                ),
              ),
            )
            
            
      ),
    );
  }
}
