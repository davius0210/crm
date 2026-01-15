import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:crm_apps/main.dart';
import 'style/css.dart' as css;
import 'controller/database_cont.dart' as cdb;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/api_cont.dart' as capi;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/logdevice.dart' as mlog;

class NonRutePage extends StatefulWidget {
  final msf.Salesman user;
  final String startDayDate;
  final bool isEndDay;

  const NonRutePage(
      {super.key,
      required this.user,
      required this.startDayDate,
      required this.isEndDay});

  @override
  State<NonRutePage> createState() => LayerNonRute();
}

class LayerNonRute extends State<NonRutePage> {
  List<mlgn.Langganan> listNonRute = [];
  List<mlgn.Langganan> _filteredItems = [];
  bool isLoading = false;
  int _curNonRute = 0;
  int _maxNonRute = 0;

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

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<mlgn.Langganan> listNonRuteSelected = await clgn
          .getAllLanggananNonRute(widget.user.fdKodeSF, widget.user.fdKodeDepo);

      listNonRute = await capi.getNonRuteLanggananInfo(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          widget.startDayDate,
          listNonRuteSelected);

      if (listNonRute.first.code == 401) {
        await sessionExpired();
      } else if (listNonRute.first.code == 99) {
        throw Exception(listNonRute.first.message);
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
        _filteredItems.addAll(listNonRute);
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

  void _filterList(String searchText) {
    _filteredItems = [];

    setState(() {
      for (var element in listNonRute) {
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

  void saveNonRute() async {
    try {
      List<mlgn.Langganan> items =
          listNonRute.where((element) => element.isCheck == true).toList();

      await clgn.insertLanggananNonRuteBatch(items);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Sukses simpan')));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Non Rute'),
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
        bottomNavigationBar: (isLoading
            ? const Padding(padding: EdgeInsets.zero)
            : InkWell(
              onTap: (widget.isEndDay
                      ? null
                      : () async {
                          bool isDateTimeSettingValid =
                              await cother.dateTimeSettingValidation();

                          if (isDateTimeSettingValid) {
                            saveNonRute();
                          }
                        }),
              child: Ink(
                  height: 70,
                  color: ColorHelper.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Confirm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                      SizedBox(width: 5,),
                      Icon(Icons.check_circle,color: Colors.white,)
                    ],
                  ),
              ),
            )),
            
            
            // BottomAppBar(
            //     height: 40 * ScaleSize.textScaleFactor(context),
            //     child: TextButton(
            //       onPressed: (widget.isEndDay
            //           ? null
            //           : () async {
            //               bool isDateTimeSettingValid =
            //                   await cother.dateTimeSettingValidation();

            //               if (isDateTimeSettingValid) {
            //                 saveNonRute();
            //               }
            //             }),
            //       child: const Text('Confirm'),
            //     ),
            //   )),
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
                        TextField(
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
                        const Padding(padding: EdgeInsets.all(5)),
                        Flexible(
                            child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Material(
                                  shape: css.boxStyle(),
                                  color:
                                      _filteredItems[index].isLatePayment == 0
                                          ? Colors.white
                                          : Colors.orangeAccent,
                                  elevation: 3,
                                  shadowColor: Colors.blue,
                                  child: CheckboxListTile(
                                      checkColor: css.checkColor(),
                                      checkboxShape: css.checkBoxShape(),
                                      contentPadding: const EdgeInsets.all(5),
                                      selected: _filteredItems[index].isCheck!,
                                      selectedTileColor:
                                          css.tileSelectedColor(),
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
                                              (_filteredItems[index].isLocked ==
                                                      1
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
                                                    ? css
                                                        .textSmallSizeWhiteBold()
                                                    : css
                                                        .textSmallSizeBlackBold(),
                                              ))
                                            ],
                                          ),
                                          const Divider(
                                              thickness:
                                                  1), //garis atau pembatas
                                          // Text(
                                          //     '${_filteredItems[index].fdKodeLangganan!} - ${_filteredItems[index].fdNamaLangganan}',
                                          //     style: _filteredItems[index]
                                          //             .isCheck!
                                          //         ? css.textSmallSizeWhite()
                                          //         : css.textSmallSizeBlack()),
                                          // Text(
                                          //     '${_filteredItems[index].fdKodeTipeLangganan!} - ${_filteredItems[index].fdTipeLangganan}',
                                          //     style: _filteredItems[index]
                                          //             .isCheck!
                                          //         ? css.textSmallSizeWhite()
                                          //         : css.textSmallSizeBlack()),
                                          Text(
                                              '${_filteredItems[index].fdAlamat} ',
                                              style: _filteredItems[index]
                                                      .isCheck!
                                                  ? css.textSmallSizeWhite()
                                                  : css.textSmallSizeBlack())
                                        ],
                                      ),
                                      value: _filteredItems[index].isCheck,
                                      onChanged: (valuex) {
                                        print(_filteredItems[index].isLocked);
                                        if (_filteredItems[index].isLocked ==
                                            0) {
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
                    ))));
  }
}
