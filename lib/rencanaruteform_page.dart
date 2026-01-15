import 'dart:developer';
import 'dart:io';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:crm_apps/rencanarute_page.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:crm_apps/main.dart';
import 'viewrute_page.dart';
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

class RencanaRuteFormPage extends StatefulWidget {
  final msf.Salesman user;
  final String startDayDate;
  final String strStartDate;
  final String strEndDate;
  final String routeName;
  final String fdNoRencanaRute;
  final String fdAction;
  final bool isEndDay;

  const RencanaRuteFormPage(
      {super.key,
      required this.user,
      required this.startDayDate,
      required this.strStartDate,
      required this.strEndDate,
      required this.routeName,
      required this.fdNoRencanaRute,
      required this.fdAction,
      required this.isEndDay});

  @override
  State<RencanaRuteFormPage> createState() => LayerRencanaRuteForm();
}

class LayerRencanaRuteForm extends State<RencanaRuteFormPage> {
  List<mlgn.Langganan> listNonRute = [];
  List<mrrute.RencanaNonRuteLangganan> listRencanaRuteLangganan = [];
  List<mrrute.RencanaNonRuteLangganan> _filteredItems = [];
  bool isLoading = false;
  int _curNonRute = 0;
  int _maxNonRute = 0;
  TextEditingController txtTanggal = TextEditingController();
  TextEditingController stateTanggal = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? currentDate;
  bool isEdit = false;
  String errMessage = '';

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
    initLoadPage();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.strStartDate.isNotEmpty && widget.strEndDate.isNotEmpty) {
        startDate = DateTime.parse(widget.strStartDate);
        endDate = DateTime.parse(widget.strEndDate);

        currentDate = startDate;
        txtTanggal.text = DateFormat('dd MMM yyyy').format(currentDate!);
      }
      //check apa masih dapat di edit
      List<mrrute.RencanaRuteApi> listRencanaRuteApi =
          await crute.getDataRencanaRuteApi(widget.fdNoRencanaRute);
      if (listRencanaRuteApi.isNotEmpty) {
        mrrute.RencanaRuteApi result = await capi.sendRencanaRutetoServer(
            widget.user,
            widget.fdAction,
            widget.startDayDate,
            listRencanaRuteApi);

        if (result.fdData != '0' &&
            result.fdData != '401' &&
            result.fdData != '500' &&
            result.fdMessage == '') {
          setState(() {
            isEdit = true;
          });
        } else {
          setState(() {
            isEdit = false;
          });
          if (result.fdMessage!.isNotEmpty) {
            errMessage = result.fdMessage!;
          }
        }
      } else {
        setState(() {
          isEdit = true;
        });
      }
      //load data non rute langganan
      List<mrrute.RencanaNonRuteLangganan> listNonRuteSelected =
          await crute.getAllRencanaRuteLangganan(
              widget.user.fdKodeSF,
              widget.user.fdKodeDepo,
              DateFormat('yyyy-MM-dd').format(currentDate!));

      listRencanaRuteLangganan = await capi.getNonRuteLangganan(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          widget.startDayDate,
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

        // _filteredItems.addAll(listRencanaRuteLangganan);
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

  Future<void> refreshPage() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<mrrute.RencanaNonRuteLangganan> listNonRuteSelected =
          await crute.getAllRencanaRuteLangganan(
              widget.user.fdKodeSF,
              widget.user.fdKodeDepo,
              DateFormat('yyyy-MM-dd').format(currentDate!));

      listRencanaRuteLangganan = await capi.getNonRuteLangganan(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          widget.startDayDate,
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
        // _filteredItems.addAll(listRencanaRuteLangganan);
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

  Future<void> saveTempRencanaRute(String fdTanggalRencanaRute) async {
    try {
      List<mrrute.RencanaNonRuteLangganan> items = listRencanaRuteLangganan
          .where((element) => element.isCheck == true)
          .toList();

      await crute.insertTempRencanaRuteLanggananBatch(
          items, widget.fdNoRencanaRute, fdTanggalRencanaRute);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<void> saveRencanaRute() async {
    try {
      List<mrrute.RencanaNonRuteLangganan> items = listRencanaRuteLangganan
          .where((element) => element.isCheck == true)
          .toList();

      await crute.insertRencanaRuteLanggananBatch(
          items, widget.fdNoRencanaRute);

      if (!mounted) return;

      // ScaffoldMessenger.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(const SnackBar(content: Text('Sukses simpan')));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
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
          : param.dtFormatView.parse(txtEdit.text), //get today's date
      firstDate: DateTime(DateTime.now()
          .year), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2060),
    );

    if (selectDate != null) {
      setState(() {
        txtEdit.text = param.dtFormatView.format(selectDate);
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
                          enabled: false,
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
                              txtTanggal.text = DateFormat('dd MMM yyyy')
                                  .format(selectedDate);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextField(
                          onChanged: (text) {
                            _filterList(text);
                          },
                          autocorrect: false,
                          decoration: css.textInputStyle(
                              'Search (kode dan nama outlet)',
                              const TextStyle(fontStyle: FontStyle.italic),
                              null,
                              Icon(Icons.search,
                                  size:
                                      24 * ScaleSize.textScaleFactor(context)),
                              null),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(children: [
                                Text('Rencana Rute Tambahan (Non Rute)'),
                              ]),
                              TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: 'View Rute'),
                                          builder: (context) => ViewRutePage(
                                              user: widget.user,
                                              startDayDate: DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(DateFormat(
                                                          'dd MMM yyyy')
                                                      .parse(txtTanggal.text)),
                                              isEndDay: widget.isEndDay,
                                              routeName: 'ViewRute'))).then(
                                      (value) {
                                    initLoadPage();

                                    setState(() {});
                                    // log('data back: ${listKeranjang.map((item) => '(${item.fdKodeBarang}, ${item.fdNamaBarang}, Qty: ${item.fdQty}, Satuan: ${item.fdJenisSatuan})').toList()}');
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                child: const Text('View Rute'),
                              ),
                            ]),
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
                                color: _filteredItems[index].isLatePayment == 0
                                    ? Colors.white
                                    : Colors.orangeAccent,
                                elevation: 3,
                                shadowColor: Colors.blue,
                                child: CheckboxListTile(
                                    checkColor: css.checkColor(),
                                    checkboxShape: css.checkBoxShape(),
                                    contentPadding: const EdgeInsets.all(5),
                                    selected: _filteredItems[index].isCheck!,
                                    selectedTileColor: css.tileSelectedColor(),
                                    activeColor: css.textCheckSelectedColor(),
                                    side: css.checkBoxBorder(),
                                    shape: css.boxStyle(),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            (_filteredItems[index].isLocked == 1
                                                ? Icon(Icons.lock_outline,
                                                    color: Colors.yellow,
                                                    size: 24 *
                                                        ScaleSize
                                                            .textScaleFactor(
                                                                context))
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(0))),
                                            Expanded(
                                                child: Text(
                                              '${_filteredItems[index].fdKodeLangganan} - ${_filteredItems[index].fdNamaLangganan}',
                                              softWrap: true,
                                              style: _filteredItems[index]
                                                      .isCheck!
                                                  ? css.textSmallSizeWhiteBold()
                                                  : css
                                                      .textSmallSizeBlackBold(),
                                            ))
                                          ],
                                        ),
                                        const Divider(thickness: 1),
                                        Text(
                                            '${_filteredItems[index].fdAlamat} ',
                                            style:
                                                _filteredItems[index].isCheck!
                                                    ? css.textSmallSizeWhite()
                                                    : css.textSmallSizeBlack())
                                      ],
                                    ),
                                    value: _filteredItems[index].isCheck,
                                    onChanged: (valuex) {
                                      print(_filteredItems[index].isLocked);
                                      if (_filteredItems[index].isLocked == 0) {
                                        setState(() {
                                          if (valuex!) {
                                            _curNonRute++;
                                          } else {
                                            _curNonRute--;
                                          }
                                          //sugeng remark belum dibatasi maxNonRute
                                          // if (_curNonRute <= _maxNonRute) {
                                          _filteredItems[index].isCheck =
                                              valuex;
                                          // } else {
                                          //   //current non rute di set maksimal krn sudah lebih
                                          //   _curNonRute = _maxNonRute;
                                          // }
                                        });
                                      }
                                    })),
                          );
                        },
                      ))
                    ],
                  ))),
      bottomNavigationBar: (isLoading
          ? const Padding(padding: EdgeInsets.zero)
          : Ink(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (widget.isEndDay
                            ? null
                            : () async {
                                bool isDateTimeSettingValid =
                                    await cother.dateTimeSettingValidation();

                                if (isDateTimeSettingValid) {
                                  if (currentDate != null &&
                                      startDate != null) {
                                    if (currentDate!.isAfter(startDate!)) {
                                      if (isEdit) {
                                        await saveTempRencanaRute(
                                            DateFormat('yyyy-MM-dd')
                                                .format(currentDate!));
                                      }
                                      setState(() {
                                        currentDate = currentDate!
                                            .add(const Duration(days: -1));
                                        txtTanggal.text =
                                            DateFormat('dd MMM yyyy')
                                                .format(currentDate!);
                                      });
                                      await refreshPage();
                                    }
                                  }
                                }
                              }),
                    child: Ink(
                      height: MediaQuery.of(context).size.height,
                      color: widget.isEndDay ? ColorHelper.disable : ColorHelper.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text('Back', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (widget.isEndDay
                            ? null
                            : () async {
                                bool isDateTimeSettingValid =
                                    await cother.dateTimeSettingValidation();
                                print(DateFormat('yyyy-MM-dd')
                                    .format(currentDate!));
                                if (isDateTimeSettingValid) {
                                  if (currentDate != null && endDate != null) {
                                    if (currentDate!.isBefore(endDate!)) {
                                      if (isEdit) {
                                        await saveTempRencanaRute(
                                            DateFormat('yyyy-MM-dd')
                                                .format(currentDate!));
                                      }
                                      setState(() {
                                        currentDate = currentDate!
                                            .add(const Duration(days: 1));
                                        txtTanggal.text =
                                            DateFormat('dd MMM yyyy')
                                                .format(currentDate!);
                                      });
                                      await refreshPage();
                                    } else {
                                      if (isEdit) {
                                        await saveTempRencanaRute(
                                            DateFormat('yyyy-MM-dd')
                                                .format(currentDate!));
                                        List<mrrute.RencanaRuteApi>
                                            listRencanaRuteApi =
                                            await crute.getDataRencanaRuteApi(
                                                widget.fdNoRencanaRute);
                                        if (listRencanaRuteApi.isNotEmpty) {
                                          mrrute.RencanaRuteApi result =
                                              await capi
                                                  .sendRencanaRutetoServer(
                                                      widget.user,
                                                      '1', //widget.fdAction,
                                                      widget.startDayDate,
                                                      listRencanaRuteApi);

                                          if (result.fdData != '0' &&
                                              result.fdData != '401' &&
                                              result.fdData != '500' &&
                                              result.fdMessage == '') {
                                            await saveRencanaRute();
                                            if (!mounted) return;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    settings:
                                                        const RouteSettings(
                                                            name:
                                                                'rencanarute'),
                                                    builder: (context) =>
                                                        RencanaRutePage(
                                                            user: widget.user,
                                                            startDayDate: widget
                                                                .startDayDate,
                                                            isEndDay:
                                                                widget.isEndDay,
                                                            routeName:
                                                                'rencanarute'))).then(
                                                (value) {
                                              initLoadPage();

                                              setState(() {});
                                            });
                                          } else if (result
                                              .fdMessage!.isNotEmpty) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        result.fdMessage!)));
                                          }
                                        } else {
                                          if (!mounted) return;

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Langganan harus di pilih')));
                                        }
                                      } else {
                                        await refreshPage();
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (!mounted) return;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(errMessage)));
                                      }
                                    }
                                  }
                                }
                              }),
                    child: Ink(
                      height: MediaQuery.of(context).size.height,
                      color: ColorHelper.secondary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(currentDate!.isBefore(endDate!) ? 'Next' : 'Save', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                          SizedBox(width: 5,),
                          Icon(currentDate!.isBefore(endDate!) ? Icons.chevron_right : Icons.save, color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
          
      )
    );
  }
}
