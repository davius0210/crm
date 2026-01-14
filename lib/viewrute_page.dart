import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:crm_apps/main.dart';
import 'style/css.dart' as css;
import 'controller/database_cont.dart' as cdb;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/rute_cont.dart' as crute;
import 'controller/api_cont.dart' as capi;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/logdevice.dart' as mlog;
import 'models/globalparam.dart' as param;
import 'models/rencanarute.dart' as mrrute;

class ViewRutePage extends StatefulWidget {
  final msf.Salesman user;
  final String startDayDate;
  final String routeName;
  final bool isEndDay;

  const ViewRutePage(
      {super.key,
      required this.user,
      required this.startDayDate,
      required this.routeName,
      required this.isEndDay});

  @override
  State<ViewRutePage> createState() => LayerViewRute();
}

class LayerViewRute extends State<ViewRutePage> {
  List<mlgn.Langganan> listNonRute = [];
  List<mrrute.RencanaRuteLangganan> listRencanaRuteLangganan = [];
  List<mrrute.RencanaRuteLangganan> _filteredItems = [];
  bool isLoading = false;
  int _curNonRute = 0;
  int _maxNonRute = 0;
  TextEditingController txtTanggal = TextEditingController();
  TextEditingController stateTanggal = TextEditingController();

  DateTime? currentDate;

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
    super.initState();
    currentDate = DateTime.parse(widget.startDayDate);
    initLoadPage();
  }

  Future<void> initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      txtTanggal.text = DateFormat('dd MMM yyyy').format(currentDate!);
      List<mrrute.RencanaRuteLangganan> listNonRuteSelected =
          await crute.getDataViewRencanaRuteLangganan(
              widget.user.fdKodeSF,
              widget.user.fdKodeDepo,
              DateFormat('yyyy-MM-dd').format(currentDate!));

      listRencanaRuteLangganan = await capi.getViewRute(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          DateFormat('yyyy-MM-dd').format(currentDate!),
          listNonRuteSelected);

      if (listRencanaRuteLangganan.first.code == 401) {
        await sessionExpired();
      } else if (listRencanaRuteLangganan.first.code == 99) {
        throw Exception(listRencanaRuteLangganan.first.message);
      }

      _curNonRute = listNonRuteSelected.length;

      List<mlog.Param> listParam =
          await clog.getDataParamByKodeSf(widget.user.fdKodeSF);

      if (listParam.isNotEmpty) {
        _maxNonRute = listParam[0].fdMaxRute;
      } else {
        _maxNonRute = 0;
      }

      setState(() {
        _filteredItems = [];
        _filteredItems = List.from(listRencanaRuteLangganan)
          ..sort((a, b) {
            final aVal = (a.isCheck ?? false) ? 1 : 0;
            final bVal = (b.isCheck ?? false) ? 1 : 0;

            if (aVal != bVal) {
              return bVal - aVal;
            }
            return (a.fdNamaLangganan ?? '').compareTo(b.fdNamaLangganan ?? '');
          });
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('error: $e')));
      });
    }
  }

  void _filterList(String searchText) {
    _filteredItems = [];

    setState(() {
      for (var element in listRencanaRuteLangganan) {
        if (element.fdKodeLangganan!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            element.fdNamaLangganan!
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
          : param.dtFormatViewMMM.parse(txtEdit.text), //get today's date
      firstDate: DateTime(DateTime.now()
          .year), //DateTime.now() - not to allow to choose before today.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Rute'),
        actions: [
          IconButton(
            onPressed: () {
              initLoadPage();
            },
            icon: Icon(Icons.refresh_outlined,
                size: 24 * ScaleSize.textScaleFactor(context)),
            tooltip: 'Refresh',
          )
        ],
      ),
      body: isLoading
          ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              backgroundColor: Colors.yellow,
              color: Colors.red,
              strokeWidth: 2,
              onRefresh: () async {
                initLoadPage();

                return Future.delayed(const Duration(milliseconds: 500));
              },
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          controller: txtTanggal,
                          readOnly: true,
                          decoration: css.textInputStyle(
                            'Periode',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Periode',
                            null,
                            null,
                          ),
                          onTap: () async {
                            stateTanggal = txtTanggal;
                            await showCalendar(stateTanggal);
                            if (txtTanggal.text.isNotEmpty) {
                              DateTime selectedDate =
                                  param.dtFormatViewMMM.parse(txtTanggal.text);
                              currentDate = DateTime.parse(
                                  DateFormat('yyyy-MM-dd')
                                      .format(selectedDate));
                              txtTanggal.text = DateFormat('dd MMM yyyy')
                                  .format(selectedDate);
                              await initLoadPage();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(
                                  'List Langganan Rute',
                                  softWrap: true,
                                  style: css.textSmallSizeBlackBold(),
                                ),
                              ]),
                            ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Divider(
                          height: 1,
                          thickness: 3,
                          color: Colors.orange,
                        ),
                      ),
                      Flexible(
                          child: ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Material(
                              shape: css.boxStyle(),
                              color: Colors.white,
                              elevation: 3,
                              shadowColor: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(padding: EdgeInsets.all(5)),
                                      Expanded(
                                          child: Text(
                                        '${_filteredItems[index].fdPekan}${_filteredItems[index].fdHari}',
                                        softWrap: true,
                                        style: css.textSmallSizeBlackBold(),
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(padding: EdgeInsets.all(5)),
                                      Expanded(
                                          child: Text(
                                        '${_filteredItems[index].fdKodeLangganan} - ${_filteredItems[index].fdNamaLangganan}',
                                        softWrap: true,
                                        style: css.textSmallSizeBlackBold(),
                                      ))
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Divider(thickness: 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      '${_filteredItems[index].fdAlamat} ',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ))),
    );
  }
}
