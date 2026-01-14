import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'noo_page.dart';
import 'noo_canvas_page.dart';
import 'main.dart';
import 'limitkreditformorder_page.dart';
import 'noo_orderform_page.dart';
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csales;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/noo_cont.dart' as cnoo;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/order_cont.dart' as codr;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/api_cont.dart' as capi;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/order.dart' as modr;
import 'controller/camera.dart' as ccam;
import 'previewphoto_page.dart';
import 'style/css.dart' as css;
import 'models/langganan.dart' as mlgn;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/piutang.dart' as mpiu;
import 'models/limitkredit.dart' as mlk;
import 'models/logdevice.dart' as mlog;
import 'models/menu.dart' as mmenu;
import 'models/globalparam.dart' as param;
import 'models/database.dart' as mdbconfig;

class NooCustomerPage extends StatefulWidget {
  final msf.Salesman user;
  final String fdKodeLangganan;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const NooCustomerPage(
      {super.key,
      required this.fdKodeLangganan,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<NooCustomerPage> createState() => LayerCustomer();
}

class LayerCustomer extends State<NooCustomerPage> {
  // mlgn.Langganan lgn = mlgn.Langganan.empty();
  mnoo.viewNOO noo = mnoo.viewNOO.empty();
  List<mmenu.MenuMD> listMenu = [];
  List<mpiu.Piutang> listPiutang = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  bool isLoading = false;
  bool isLoadButton = false;
  String errMessage = '';
  String startTimeVisit = '';
  String endTimeVisit = '';
  String pauseActivity = '03';
  String endVisitActivity = '03';
  String sNote = '';
  bool isPaused = false;
  bool isCancel = false;
  bool isBuktiTagihExist = false;
  bool isOrderExist = false;
  bool isPlanoExist = false;
  bool isPKMExist = false;
  bool isSellOExist = false;
  bool isDSKompExist = false;
  bool isDSNonKompExist = false;
  bool isHETExist = false;
  bool isCompActExist = false;
  bool isOOSExist = false;
  bool isPromoActExist = false;
  bool isRakDispActExist = false;
  bool istransaksiPopPromoExist = false;
  String outletAbsenImgPath = '';
  String tokoDalam1ImgPath = '';
  String tokoLuar1ImgPath = '';
  bool isImgOutletAbsenExist = false;
  bool isImgTokoDalam1Exist = false;
  bool isImgTokoLuar1Exist = false;
  bool isOOScomplete = false;
  bool isHETComplete = false;
  String imgPausePath = '';
  String imgReasonCancelVisitPath = '';
  bool isMaxPause = false;
  bool isFreeText = false;
  bool isFreeTextCancel = false;
  bool isReasonEmpty = false;
  bool isTransaction = false;
  bool confirm = false;
  bool statusLimitKredit = false;
  double totalTagihan = 0;
  double totalTagihanJT = 0;
  double totalTagihanSebelumJT = 0;
  double sisaLimitKredit = 0;
  double qTotalPesanan = 0;
  TextEditingController txtReasonLain = TextEditingController();
  TextEditingController txtCancelReasonLain = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  ScrollController scrollControllerNotes = ScrollController();
  List<modr.Order> listOrder = [];
  List<modr.Order> listOrderDetail = [];
  List<modr.Order> listGetDataOrder = [];
  List<mlgn.Reason> listReason = [];
  List<mlgn.Reason> listReasonCancel = [];

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

      outletAbsenImgPath =
          '${param.appDir}/${param.imgPath}/${param.outletAbsenFullImgName(widget.user.fdKodeSF, widget.fdKodeLangganan, widget.startDayDate)}';

      if (await File(outletAbsenImgPath).exists()) {
        isImgOutletAbsenExist = true;
      } else {
        isImgOutletAbsenExist = false;
      }

      noo = await cnoo.getNOOActivitybyfdKodeNoo(widget.fdKodeLangganan);
      tokoDalam1ImgPath = noo.fdTokoDalam1!;
      // tokoDalam1ImgPath =
      //     '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}/NOO/NOO_${widget.fdKodeLangganan}_TD1_3.jpg';
      if (await File(tokoDalam1ImgPath).exists()) {
        isImgTokoDalam1Exist = true;
      } else {
        isImgTokoDalam1Exist = false;
      }

      tokoLuar1ImgPath = noo.fdTokoLuar1!;
      // tokoLuar1ImgPath =
      //     '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}/NOO/NOO_${widget.fdKodeLangganan}_TL1_1.jpg';
      if (await File(tokoLuar1ImgPath).exists()) {
        isImgTokoLuar1Exist = true;
      } else {
        isImgTokoLuar1Exist = false;
      }
      // List<mnoo.FotoNOO> listNooFoto =
      //     await cnoo.getAllFotoNoobyfdKodeNoo(noo.fdKodeNoo);
      // if (listNooFoto.isNotEmpty) {
      //   if (listNooFoto[0].fdJenis == 'TL') {
      //     tokoDalam1ImgPath =
      //         '${param.appDir}/${param.imgPath}/${param.nooImgName(3, listNooFoto[0].fdFileName!, widget.user.fdKodeSF, 'TD1', '')}';
      //     tokoDalam1ImgPath = noo.fdTokoDalam1!;
      //     if (await File(tokoDalam1ImgPath).exists()) {
      //       isImgTokoDalam1Exist = true;
      //     } else {
      //       isImgTokoDalam1Exist = false;
      //     }
      //   }
      //   if (listNooFoto[0].fdJenis == 'TD') {
      //     tokoLuar1ImgPath =
      //         '${param.appDir}/${param.imgPath}/${param.nooImgName(1, listNooFoto[0].fdFileName!, widget.user.fdKodeSF, 'TL1', '')}';
      //     // tokoLuar1ImgPath = noo.fdTokoLuar1!;

      //     if (await File(tokoLuar1ImgPath).exists()) {
      //       isImgTokoLuar1Exist = true;
      //     } else {
      //       isImgTokoLuar1Exist = false;
      //     }
      //   }
      // }

      // totalTagihan = await cpiu.getTotalTagihan(widget.fdKodeLangganan);
      // totalTagihanSebelumJT = await cpiu.getTotalTagihanSebelumJT(
      //     widget.fdKodeLangganan, widget.startDayDate);
      // totalTagihanJT = await cpiu.getTotalTagihanJT(
      //     widget.fdKodeLangganan, widget.startDayDate);
      // // sisaLimitKredit = await cpiu.getSisaLimitKredit(widget.fdKodeLangganan);
      // sisaLimitKredit = noo.fdLimitKredit! - totalTagihan;
      // listPiutang = await cpiu.getAllPiutang(widget.fdKodeLangganan);
      listGetDataOrder =
          await codr.getDataOrderByKodeLangganan(widget.fdKodeLangganan);
      for (var odr in listGetDataOrder) {
        qTotalPesanan += odr.fdTotalOrder;
      }
      if (noo.fdKodeNoo!.isEmpty) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Data kosong. Coba pilih langganan kembali / sync ulang')));
        });
      } else {
        isPaused = noo.fdIsPaused == 1 ? true : false;
        startTimeVisit = noo.fdStartVisitDate!.isNotEmpty
            ? param.timeFormatView
                .format(param.dateTimeFormatDB.parse(noo.fdStartVisitDate!))
            : '';
        endTimeVisit = noo.fdEndVisitDate!.isNotEmpty
            ? param.timeFormatView
                .format(param.dateTimeFormatDB.parse(noo.fdEndVisitDate!))
            : '';
        isCancel = await clgn.isCancelVisit(
            widget.user.fdKodeSF,
            widget.user.fdKodeDepo,
            widget.fdKodeLangganan,
            noo.fdStartVisitDate!);
        await notifyMenu();
        // listMenu = await cmenu.getAllCustMenu();
        // setMenuProperties();

        late Database db;

        try {
          db = await openDatabase(mdbconfig.dbFullPath,
              version: mdbconfig.dbVersion);
          await db.transaction((txn) async {
            listReason = await clgn.getListReasonInfo('2', txn);
          });
          await db.transaction((txn) async {
            listReasonCancel = await clgn.getListReasonCancel('1', txn);
          });
        } catch (e) {
          rethrow;
        } finally {
          db.isOpen ? await db.close() : null;
        }
      }
      statusLimitKredit = await clk.checkStatusLimitKredit(
          widget.startDayDate, widget.fdKodeLangganan);
      listLimitKredit = await clk.getAllLimitKreditTransaction(
          widget.fdKodeLangganan, widget.startDayDate);

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

  Future<void> notifyMenu() async {
    isBuktiTagihExist = await cpiu.checkIsBuktiTagihanExist(
        widget.fdKodeLangganan, widget.startDayDate);
    isOrderExist = await codr.checkIsOrderExist(
        widget.fdKodeLangganan, widget.startDayDate);

    if (isBuktiTagihExist || isOrderExist) {
      setState(() {
        isTransaction = true;
      });
    } else {
      setState(() {
        isTransaction = false;
      });
    }
  }

  createMenu() {
    List<Widget> contents = [];

    try {
      for (int i = 0; i < listMenu.length; i += 2) {
        contents.add(Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
          child: Column(
            children: createIconMenu(i),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }

    return contents;
  }

  createIconMenu(int index) {
    List<Widget> contents = [];

    for (int i = index; i <= index + 1; i++) {
      if (i < listMenu.length) {
        contents.add(Badge(
          isLabelVisible: listMenu[i].isExist! ? true : false,
          smallSize: 8 * ScaleSize.textScaleFactor(context),
          child: IconButton(
              color: const Color.fromARGB(255, 243, 66, 12),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: listMenu[i].fdMenu),
                            builder: (context) => listMenu[i].navigator!))
                    .then((value) {
                  initLoadPage();
                });
              },
              tooltip: listMenu[i].fdMenu,
              visualDensity: VisualDensity.compact,
              iconSize: 26 * ScaleSize.textScaleFactor(context),
              icon: listMenu[i].icon!),
        ));

        contents.add(SizedBox(
            width: 90 * ScaleSize.textScaleFactor(context),
            height: 28 * ScaleSize.textScaleFactor(context) + 5,
            child: Text(
              listMenu[i].fdMenu,
              maxLines: 2,
              textAlign: TextAlign.center,
              softWrap: true,
            )));

        contents.add(const SizedBox(height: 20));
      }
    }

    return contents;
  }

  Future<Uint8List> getImageBytes(String assetImg) async {
    ByteData? data;
    await rootBundle.load(assetImg).then((value) {
      data = value;
    });

    return data!.buffer.asUint8List(data!.offsetInBytes, data!.lengthInBytes);
  }

  Future<void> getNotes(String? fdKodeLangganan) async {
    sNote = await clgn.getNoteLanggananAct(widget.fdKodeLangganan,
        widget.user.fdKodeDepo, widget.user.fdKodeSF, widget.startDayDate);
    txtNote.text = sNote;
  }

  void noteDialogForm(String? fdKodeLangganan) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: const Text('Note')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Scrollbar(
                    controller: scrollControllerNotes,
                    thumbVisibility: true,
                    child: TextFormField(
                      scrollController: scrollControllerNotes,
                      maxLines: 5,
                      maxLength: 250,
                      controller: txtNote,
                      keyboardType: TextInputType.multiline,
                      readOnly: endTimeVisit.isEmpty ? false : true,
                      decoration: css.textInputStyle(
                          'Keterangan', null, null, null, null),
                      inputFormatters: [
                        FilteringTextInputFormatter(
                            RegExp(r'^[\.a-zA-Z0-9, \n]*'),
                            allow: true)
                      ],
                    ))),
            endTimeVisit.isEmpty
                ? ElevatedButton(
                    onPressed: () async {
                      try {
                        await saveNote(fdKodeLangganan, txtNote.text);

                        if (!mounted) return;

                        Navigator.pop(context);

                        setState(() {});
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    },
                    child: const Text('Submit'))
                : const Padding(padding: EdgeInsets.zero)
          ],
        );
      }),
    );
  }

  Future<bool> saveNote(String? fdKodeLangganan, String fdNote) async {
    try {
      await clgn.insertNoteLanggananAct(
          fdKodeLangganan!,
          widget.user.fdKodeDepo,
          widget.user.fdKodeSF,
          widget.startDayDate,
          '',
          '',
          'Note',
          fdNote);

      if (!mounted) return false;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Note tersimpan')));

      setState(() {});

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));

      return false;
    }
  }

  Future<void> alertLimitKredit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Container(
                color: css.titleDialogColor(),
                padding: const EdgeInsets.all(5),
                child: const Text(
                    'Ada limit kredit yang belum diproses. Proses sekarang?')),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      // print(listLimitKredit.first.fdNoLimitKredit);
                      await confirmEndVisitLimitKredit();
                      if (widget.user.fdTipeSF == '1') {
                        // CANVAS
                        String? sendNotif = await capi.sendNotifCanvas(
                            widget.user.fdToken,
                            widget.user.fdKodeSF,
                            widget.user.fdKodeDepo,
                            'Ada penjualan senilai Rp. ${param.enNumberFormatQty.format(qTotalPesanan).toString()} atas nama ${noo.fdNamaToko} oleh ${widget.user.fdNamaSF} - NOO');
                        if (sendNotif != '1') {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(sendNotif!)));
                        }
                      } else {
                        String? sendNotif = await capi.sendNotifOrder(
                            widget.user.fdToken,
                            widget.user.fdKodeSF,
                            widget.user.fdKodeDepo);
                        if (sendNotif != '1') {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(sendNotif!)));
                        }
                      }
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(
                                  name: 'LimitKreditFormOrder'),
                              builder: (context) => LimitKreditFormOrderPage(
                                  noLimitKredit:
                                      listLimitKredit.first.fdNoLimitKredit!,
                                  user: widget.user,
                                  isEndDay: widget.isEndDay,
                                  routeName: 'LimitKreditFormOrder',
                                  startDayDate: widget.startDayDate)),
                          ModalRoute.withName('LimitKreditFormOrder'));
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('error: $e')));
                      }
                    }
                  },
                  child: const Text('Ya')),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await confirmEndVisitLimitKredit();
                      if (widget.user.fdTipeSF == '1') {
                        // CANVAS
                        String? sendNotif = await capi.sendNotifCanvas(
                            widget.user.fdToken,
                            widget.user.fdKodeSF,
                            widget.user.fdKodeDepo,
                            'Ada penjualan senilai Rp. ${param.enNumberFormatQty.format(qTotalPesanan).toString()} atas nama ${noo.fdNamaToko} oleh ${widget.user.fdNamaSF} - NOO');
                        if (sendNotif != '1') {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(sendNotif!)));
                        }
                      } else {
                        String? sendNotif = await capi.sendNotifOrder(
                            widget.user.fdToken,
                            widget.user.fdKodeSF,
                            widget.user.fdKodeDepo);
                        if (sendNotif != '1') {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(sendNotif!)));
                        }
                      }
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: widget.routeName),
                              builder: (context) => NOOPage(
                                  user: widget.user,
                                  routeName: widget.routeName,
                                  isEndDay: widget.isEndDay,
                                  startDayDate: widget.startDayDate)),
                          ModalRoute.withName('home'));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         settings:
                      //             const RouteSettings(name: 'limitkredit'),
                      //         builder: (context) => LimitKreditPage(
                      //             user: widget.user,
                      //             startDayDate: widget.startDayDate,
                      //             isEndDay: widget.isEndDay,
                      //             routeName: 'limitkredit')));
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

  void checkReasonPauseResult(bool isFinish, String errMsg) {
    if (isFinish) {
      if (errMsg.isEmpty) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Langganan Pause')));

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: widget.routeName),
                builder: (context) => NOOPage(
                    user: widget.user,
                    routeName: widget.routeName,
                    isEndDay: widget.isEndDay,
                    startDayDate: widget.startDayDate)),
            ModalRoute.withName('home'));
      } else {
        if (!isReasonEmpty) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: widget.routeName),
                  builder: (context) => NOOPage(
                      user: widget.user,
                      routeName: widget.routeName,
                      isEndDay: widget.isEndDay,
                      startDayDate: widget.startDayDate)),
              ModalRoute.withName('home'));

          alertDialogForm(errMsg, context);
        }
      }
    }
  }

  void reasonDialogForm(String? fdKodeLangganan) {
    mlgn.Reason? selectedReason;
    isFreeText = false;
    isReasonEmpty = false;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setStateDialog) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: const Text('Pause')),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            const Text('Pilih alasan menunda kunjungan:'),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: listReason.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: RadioListTile(
                          selected: selectedReason == listReason[index],
                          selectedTileColor: css.tileSelectedColor(),
                          activeColor: css.textCheckSelectedColor(),
                          title: Text(
                              '${listReason[index].fdReasonDescription}',
                              style: css.textSmallSize(),
                              softWrap: true),
                          value: listReason[index],
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedReason = value;
                              isFreeText = selectedReason!.fdFreeTeks == 1;
                              txtReasonLain.clear();
                              isReasonEmpty = false;
                            });
                          }),
                    );
                  },
                )),
            (isFreeText
                ? Container(
                    color: Colors.white,
                    child: TextFormField(
                      maxLength: 50,
                      controller: txtReasonLain,
                      decoration: css.textInputStyleWithError(
                          'Keterangan',
                          null,
                          null,
                          isReasonEmpty,
                          'Please fill Keterangan',
                          null),
                    ))
                : const Padding(padding: EdgeInsets.all(0))),
            ElevatedButton(
                onPressed: () async {
                  try {
                    imgPausePath = '';
                    bool isDateTimeSettingValid =
                        await cother.dateTimeSettingValidation();

                    if (isDateTimeSettingValid) {
                      if (selectedReason != null) {
                        bool isFinish = false;
                        String errMsg = '';

                        if (selectedReason!.fdCamera == 1) {
                          imgPausePath =
                              '${param.appDir}/${param.imgPath}/${param.reasonPauseFullImgName(widget.user.fdKodeSF, fdKodeLangganan!, widget.startDayDate)}';

                          if (!mounted) return;
                          setState(() {
                            isLoading = true;
                          });
                          ccam
                              .pickCamera(
                                  context,
                                  widget.user.fdToken,
                                  'Take Photo',
                                  imgPausePath,
                                  widget.routeName,
                                  true)
                              .then((value) async {
                            if (File(imgPausePath).existsSync()) {
                              errMsg = await savePause(
                                  setState,
                                  fdKodeLangganan,
                                  isFreeText
                                      ? txtReasonLain.text
                                      : selectedReason!.fdReasonDescription);

                              isFinish = true;
                              checkReasonPauseResult(isFinish, errMsg);
                            }
                          });
                        } else {
                          errMsg = await savePause(
                              setStateDialog,
                              fdKodeLangganan,
                              isFreeText
                                  ? txtReasonLain.text
                                  : selectedReason!.fdReasonDescription);

                          isFinish = true;
                          checkReasonPauseResult(isFinish, errMsg);
                        }

                        if (!mounted) return;

                        setStateDialog(() {});
                      }
                    }
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('error: $e')));
                  }
                },
                child: const Text('Submit'))
          ],
        );
      }),
    );
  }

  Future<void> checkMaxLanggananPause() async {
    List<mlog.Param> listParam = [];

    listParam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
    var maxPause = listParam[0].fdMaxPause;
    var hitPause = await clgn.checkMaxLanggananPause(
        widget.user.fdKodeSF, widget.user.fdKodeDepo, widget.startDayDate);
    if (hitPause >= maxPause) {
      setState(() {
        isMaxPause = true;
      });
    } else {
      setState(() {
        isMaxPause = false;
      });
    }
  }

  void reasonCancelDialogForm(String? fdKodeLangganan) {
    mlgn.Reason? selectedReasonCancel;
    setState(() {
      isFreeText = false;
      isReasonEmpty = false;
    });
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setStateDialogCancel) {
        return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              title: Container(
                  color: css.titleDialogColor(),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Cancel Visit'),
                      ),
                      isLoading
                          ? loadingProgress(ScaleSize.textScaleFactor(context))
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: IconButton(
                                  color: Colors.white,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size:
                                        18 * ScaleSize.textScaleFactor(context),
                                  )))
                    ],
                  )),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                const Text('Pilih alasan batal kunjungan:'),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: listReasonCancel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: RadioListTile(
                              selected: selectedReasonCancel ==
                                  listReasonCancel[index],
                              selectedTileColor: css.tileSelectedColor(),
                              activeColor: css.textCheckSelectedColor(),
                              title: Text(
                                  '${listReasonCancel[index].fdReasonDescription}',
                                  style: css.textSmallSize(),
                                  softWrap: true),
                              value: listReasonCancel[index],
                              groupValue: selectedReasonCancel,
                              onChanged: (value) {
                                setStateDialogCancel(() {
                                  selectedReasonCancel = value;
                                  isFreeTextCancel =
                                      selectedReasonCancel!.fdFreeTeks == 1;
                                  txtReasonLain.clear();
                                  isReasonEmpty = false;
                                });
                              }),
                        );
                      },
                    )),
                (isFreeTextCancel
                    ? Container(
                        color: Colors.white,
                        child: TextFormField(
                          maxLength: 50,
                          controller: txtCancelReasonLain,
                          decoration: css.textInputStyleWithError(
                              'Keterangan',
                              null,
                              null,
                              isReasonEmpty,
                              'Please fill Keterangan',
                              null),
                          inputFormatters: [
                            FilteringTextInputFormatter(
                                RegExp(r'^[\.a-zA-Z0-9, ]*'),
                                allow: true)
                          ],
                        ))
                    : const Padding(padding: EdgeInsets.all(0))),
                isLoadButton
                    ? loadingProgress(ScaleSize.textScaleFactor(context))
                    : ElevatedButton(
                        onPressed: () async {
                          try {
                            imgPausePath = '';
                            bool isDateTimeSettingValid =
                                await cother.dateTimeSettingValidation();

                            if (isDateTimeSettingValid) {
                              if (selectedReasonCancel != null) {
                                bool isFinish = false;
                                String errMsg = '';

                                if (selectedReasonCancel!.fdCamera == 1) {
                                  imgReasonCancelVisitPath =
                                      '${param.appDir}/${param.imgPath}/${param.reasonNotVisitFullImgName(widget.user.fdKodeSF, fdKodeLangganan!, widget.startDayDate)}';

                                  if (!mounted) return;
                                  setStateDialogCancel(() {
                                    isLoadButton = true;
                                  });
                                  await ccam.pickCamera(
                                      context,
                                      widget.user.fdToken,
                                      'Take Photo',
                                      imgReasonCancelVisitPath,
                                      widget.routeName,
                                      true);
                                  if (File(imgReasonCancelVisitPath)
                                      .existsSync()) {
                                    errMsg = await saveCancel(
                                        setState,
                                        fdKodeLangganan,
                                        selectedReasonCancel!.fdKodeReason,
                                        isFreeTextCancel
                                            ? txtCancelReasonLain.text
                                            : selectedReasonCancel!
                                                .fdReasonDescription);

                                    isFinish = true;
                                    await checkReasonCancelResult(
                                        isFinish, errMsg);
                                  } else {
                                    setStateDialogCancel(() {
                                      isLoadButton = false;
                                    });
                                  }
                                } else {
                                  errMsg = await saveCancel(
                                      setStateDialogCancel,
                                      fdKodeLangganan,
                                      selectedReasonCancel!.fdKodeReason,
                                      isFreeTextCancel
                                          ? txtCancelReasonLain.text
                                          : selectedReasonCancel!
                                              .fdReasonDescription);

                                  isFinish = true;
                                  if (!mounted) return;

                                  if (!isReasonEmpty) {
                                    Navigator.pop(context);
                                  }
                                  await checkReasonCancelResult(
                                      isFinish, errMsg);
                                }
                              }
                            }
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text('error: $e')));
                          }
                        },
                        child: const Text('Submit'))
              ],
            ));
      }),
    );
  }

  void alertScaffold(String msg) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<String> savePause(Function(Function()) setState,
      String? fdKodeLangganan, String? fdReason) async {
    try {
      if (isFreeText && txtReasonLain.text.isEmpty) {
        setState(() {
          isReasonEmpty = true;
        });

        return 'Keterangan harus diisi';
      } else {
        setState(() {
          isReasonEmpty = false;
        });

        String pauseFileName = '';
        if (File(imgPausePath).existsSync()) {
          pauseFileName = param.pathImgServer(
              widget.user.fdKodeDepo,
              widget.user.fdKodeSF,
              widget.startDayDate,
              '${widget.fdKodeLangganan}/${param.reasonPauseFileName(widget.fdKodeLangganan, widget.startDayDate)}');
        }

        await csales.updatePauseSFAndLanggananActivity(
            widget.user.fdKodeSF,
            widget.user.fdKodeDepo,
            pauseActivity,
            fdKodeLangganan!,
            1,
            'Pause',
            fdReason!,
            pauseFileName,
            widget.startDayDate);

        setState(() {});

        return '';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> saveCancel(Function(Function()) setState,
      String? fdKodeLangganan, String? fdKodeReason, String? fdReason) async {
    try {
      if (isFreeTextCancel && txtCancelReasonLain.text.isEmpty) {
        setState(() {
          isReasonEmpty = true;
        });

        return 'Keterangan harus diisi';
      } else {
        setState(() {
          isReasonEmpty = false;
        });

        String cancelFileName = '';
        if (File(imgReasonCancelVisitPath).existsSync()) {
          cancelFileName = param.pathImgServer(
              widget.user.fdKodeDepo,
              widget.user.fdKodeSF,
              widget.startDayDate,
              '${widget.fdKodeLangganan}/${param.reasonNotVisitFileName(widget.fdKodeLangganan, widget.startDayDate)}');
        }

        await csales.updateCancelVisitSFAndLanggananActivity(
            widget.user.fdKodeSF,
            widget.user.fdKodeDepo,
            pauseActivity,
            fdKodeLangganan!,
            1,
            'NotVisit',
            fdKodeReason!,
            fdReason!,
            cancelFileName,
            widget.startDayDate);

        //delete foto visit
        await deleteImage(widget.user.fdKodeSF, widget.user.fdKodeDepo,
            fdKodeLangganan, widget.startDayDate);

        //Zip Folder langganan
        String dirCameraPath =
            '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';
        Directory dir = Directory('$dirCameraPath/${widget.fdKodeLangganan}');
        String zipPath =
            '$dirCameraPath/${widget.fdKodeLangganan}.zip'; //path di luar folder kode langganan
        String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

        if (errorMsg.isNotEmpty) {
          return 'Error compress file: $errorMsg';
        }

        setState(() {
          isImgOutletAbsenExist = false;
        });

        return '';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deleteImage(String fdKodeSF, String fdKodeDepo,
      String fdKodeLangganan, String startDayDate) async {
    String filePath = '';
    filePath =
        '${param.appDir}/${param.imgPath}/$fdKodeSF/$fdKodeLangganan/${param.outletAbsenFileName(widget.fdKodeLangganan, widget.startDayDate)}';

    await File(filePath).exists().then((isExist) {
      if (isExist) {
        File(filePath).delete();
      }
    });
  }

  Future<void> checkReasonCancelResult(bool isFinish, String errMsg) async {
    if (isFinish) {
      if (errMsg.isEmpty && mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Langganan Cancel Visit')));

        //sugeng 28.05.2025 remark
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         settings: RouteSettings(name: widget.routeName),
        //         builder: (context) => NOOPage(
        //             user: widget.user,
        //             routeName: widget.routeName,
        //             isEndDay: widget.isEndDay,
        //             startDayDate: widget.startDayDate)),
        //     ModalRoute.withName('home'));
        //sugeng 28.05.2025 end remark

        //sugeng 28.05.2025 tambahkan send data seperti end visit
        if (endTimeVisit.isEmpty && isFinish) {
          try {
            setState(() {
              isLoading = true;
            });

            bool isValid = true;

            List<mmenu.MenuMD> listMenuMandatory =
                listMenu.where((element) => element.fdMandatory == 1).toList();

            for (var element in listMenuMandatory) {
              switch (element.fdKodeMenu) {
                case 'M38':
                  isValid = isOOSExist;

                  break;
                case 'M34':
                  isValid = isRakDispActExist;

                  break;
                case 'M35':
                  isValid = isPromoActExist;

                  break;
                case 'M39':
                  isValid = istransaksiPopPromoExist;

                  break;
                case 'M12':
                  isValid = isCompActExist;

                  break;
                case 'M36':
                  isValid = isHETExist;

                  break;
                case 'M37':
                  isValid = isDSNonKompExist;

                  break;
                case 'M42':
                  isValid = isDSKompExist;

                  break;
                case 'M41':
                  isValid = isSellOExist;

                  break;
                case 'M43':
                  isValid = isPlanoExist;

                  break;
                case 'M44':
                  isValid = isPKMExist;

                  break;
                default:
                  isValid = true;
              }

              if (!isValid) {
                break;
              }
            }

            if (isValid) {
              isOOScomplete = true;
              // isOOScomplete = await coos.checkCompleteOOS(
              //     widget.fdKodeLangganan, widget.startDayDate);
              if (!isOOScomplete) {
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('Data OOS belum lengkap terisi')));
                return;
              }

              //Validasi HET harus input semua kode group barang
              // bool isHETComplete = await chet.isHETAllGroupFinish(
              //     widget.fdKodeLangganan, widget.startDayDate);
              isHETComplete = true;

              if (!isHETComplete) {
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('Data HET belum lengkap terisi')));
                return;
              }

              String dirCameraPath =
                  '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';

              //Zip Folder langganan
              Directory dir =
                  Directory('$dirCameraPath/${widget.fdKodeLangganan}');
              String zipPath =
                  '$dirCameraPath/${widget.fdKodeLangganan}.zip'; //path di luar folder kode langganan
              String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

              if (errorMsg.isEmpty) {
                await csales.endVisitSFActivity(
                    widget.user.fdKodeSF,
                    widget.user.fdKodeDepo,
                    param.dateTimeFormatDB.format(DateTime.now()),
                    endVisitActivity,
                    widget.fdKodeLangganan);

                try {
                  await capi.sendLogDevicetoServer(
                      widget.user.fdKodeDepo,
                      widget.user.fdKodeSF,
                      widget.user.fdToken,
                      '',
                      param.dateTimeFormatDB.format(DateTime.now()));

                  //send data to server
                  Map<String, dynamic> mapResult =
                      await capi.sendDataPendingToServer(
                          widget.user, dirCameraPath, widget.startDayDate);

                  if (mapResult['fdData'] == '401') {
                    await sessionExpired();

                    return; //stop process
                  } else if (mapResult['fdMessage'].isNotEmpty) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(mapResult['fdMessage'])));
                  }

                  //send pending LK to server
                  Map<String, dynamic> mapResultLK =
                      await capi.sendDataPendingLimitKreditToServer(
                          widget.user, dirCameraPath, widget.startDayDate);

                  if (mapResultLK['fdData'] == '401') {
                    await sessionExpired();

                    return; //stop process
                  } else if (mapResultLK['fdMessage'].isNotEmpty) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(mapResultLK['fdMessage'])));
                  }
                  //end sugeng send pending LK to server
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('error: $e')));
                }

                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: widget.routeName),
                        builder: (context) => NOOPage(
                            user: widget.user,
                            routeName: widget.routeName,
                            isEndDay: widget.isEndDay,
                            startDayDate: widget.startDayDate)),
                    ModalRoute.withName('home'));
              } else {
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text('Error compress file: $errorMsg')));
              }
            } else {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Data belum lengkap terisi')));
            }
          } catch (e) {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('error: $e')));
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: widget.routeName),
                  builder: (context) => NOOPage(
                      user: widget.user,
                      routeName: widget.routeName,
                      isEndDay: widget.isEndDay,
                      startDayDate: widget.startDayDate)),
              ModalRoute.withName('home'));
        }
        //sugeng 28.05.2025 end add tambahkan send data seperti end visit
      } else {
        if (!isReasonEmpty && mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: widget.routeName),
                  builder: (context) => NOOPage(
                      user: widget.user,
                      routeName: widget.routeName,
                      isEndDay: widget.isEndDay,
                      startDayDate: widget.startDayDate)),
              ModalRoute.withName('home'));

          alertDialogForm(errMsg, context);
        }
      }
    }
  }

  Future<void> confirmEndVisit() async {
    endTimeVisit.isEmpty
        ? await showDialog<bool>(
            context: context,
            builder: (context) => SimpleDialog(
                title: Container(
                    color: css.titleDialogColor(),
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                        'Jika sudah End Visit maka tidak dapat input pesanan/penjualan. Lanjut End Visit?')),
                titlePadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            confirm = true;
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text('error: $e')));
                          }
                        }
                      },
                      child: const Text('Ya')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          setState(() {
                            confirm = false;
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('error: $e')));
                        }
                      },
                      child: const Text('Tidak'))
                ]),
          )
        : setState(() {
            confirm = true;
          });

    if (confirm != true) return;

    bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

    if (isDateTimeSettingValid) {
      if (endTimeVisit.isEmpty) {
        try {
          setState(() {
            isLoading = true;
          });

          bool isValid = true;

          List<mmenu.MenuMD> listMenuMandatory =
              listMenu.where((element) => element.fdMandatory == 1).toList();

          for (var element in listMenuMandatory) {
            switch (element.fdKodeMenu) {
              case 'M38':
                isValid = isOOSExist;

                break;
              case 'M34':
                isValid = isRakDispActExist;

                break;
              case 'M35':
                isValid = isPromoActExist;

                break;
              case 'M39':
                isValid = istransaksiPopPromoExist;

                break;
              case 'M12':
                isValid = isCompActExist;

                break;
              case 'M36':
                isValid = isHETExist;

                break;
              case 'M37':
                isValid = isDSNonKompExist;

                break;
              case 'M42':
                isValid = isDSKompExist;

                break;
              case 'M41':
                isValid = isSellOExist;

                break;
              case 'M43':
                isValid = isPlanoExist;

                break;
              case 'M44':
                isValid = isPKMExist;

                break;
              default:
                isValid = true;
            }

            if (!isValid) {
              break;
            }
          }

          if (isValid) {
            isOOScomplete = true;
            // isOOScomplete = await coos.checkCompleteOOS(
            //     widget.fdKodeLangganan, widget.startDayDate);
            if (!isOOScomplete) {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Data OOS belum lengkap terisi')));
              return;
            }

            //Validasi HET harus input semua kode group barang
            // bool isHETComplete = await chet.isHETAllGroupFinish(
            //     widget.fdKodeLangganan, widget.startDayDate);
            isHETComplete = true;

            if (!isHETComplete) {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Data HET belum lengkap terisi')));
              return;
            }

            String dirCameraPath =
                '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';

            //Zip Folder langganan
            Directory dir =
                Directory('$dirCameraPath/${widget.fdKodeLangganan}');
            String zipPath =
                '$dirCameraPath/${widget.fdKodeLangganan}.zip'; //path di luar folder kode langganan
            String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

            if (errorMsg.isEmpty) {
              await csales.endVisitSFActivity(
                  widget.user.fdKodeSF,
                  widget.user.fdKodeDepo,
                  param.dateTimeFormatDB.format(DateTime.now()),
                  endVisitActivity,
                  widget.fdKodeLangganan);

              try {
                await capi.sendLogDevicetoServer(
                    widget.user.fdKodeDepo,
                    widget.user.fdKodeSF,
                    widget.user.fdToken,
                    '',
                    param.dateTimeFormatDB.format(DateTime.now()));

                //send data to server
                Map<String, dynamic> mapResult =
                    await capi.sendDataPendingToServer(
                        widget.user, dirCameraPath, widget.startDayDate);

                if (mapResult['fdData'] == '401') {
                  await sessionExpired();

                  return; //stop process
                } else if (mapResult['fdMessage'].isNotEmpty) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mapResult['fdMessage'])));
                }

                //send pending LK to server
                Map<String, dynamic> mapResultLK =
                    await capi.sendDataPendingLimitKreditToServer(
                        widget.user, dirCameraPath, widget.startDayDate);

                if (mapResultLK['fdData'] == '401') {
                  await sessionExpired();

                  return; //stop process
                } else if (mapResultLK['fdMessage'].isNotEmpty) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mapResultLK['fdMessage'])));
                }
                //end sugeng send pending LK to server

                String? sendNotif = await capi.sendNotifOrder(
                    widget.user.fdToken,
                    widget.user.fdKodeSF,
                    widget.user.fdKodeDepo);
                if (!mounted) return;
                if (sendNotif != '1') {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(sendNotif!)));
                }
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('error: $e')));
              }

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: widget.routeName),
                      builder: (context) => NOOPage(
                          user: widget.user,
                          routeName: widget.routeName,
                          isEndDay: widget.isEndDay,
                          startDayDate: widget.startDayDate)),
                  ModalRoute.withName('home'));
            } else {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text('Error compress file: $errorMsg')));
            }
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Data belum lengkap terisi')));
          }
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('error: $e')));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: widget.routeName),
                builder: (context) => NOOPage(
                    user: widget.user,
                    routeName: widget.routeName,
                    isEndDay: widget.isEndDay,
                    startDayDate: widget.startDayDate)),
            ModalRoute.withName('home'));
      }
    }
  }

  Future<void> confirmEndVisitLimitKredit() async {
    bool isDateTimeSettingValid = await cother.dateTimeSettingValidation();

    if (isDateTimeSettingValid) {
      if (endTimeVisit.isEmpty) {
        try {
          setState(() {
            isLoading = true;
          });

          bool isValid = true;

          List<mmenu.MenuMD> listMenuMandatory =
              listMenu.where((element) => element.fdMandatory == 1).toList();

          for (var element in listMenuMandatory) {
            switch (element.fdKodeMenu) {
              case 'M38':
                isValid = isOOSExist;

                break;
              case 'M34':
                isValid = isRakDispActExist;

                break;
              case 'M35':
                isValid = isPromoActExist;

                break;
              case 'M39':
                isValid = istransaksiPopPromoExist;

                break;
              case 'M12':
                isValid = isCompActExist;

                break;
              case 'M36':
                isValid = isHETExist;

                break;
              case 'M37':
                isValid = isDSNonKompExist;

                break;
              case 'M42':
                isValid = isDSKompExist;

                break;
              case 'M41':
                isValid = isSellOExist;

                break;
              case 'M43':
                isValid = isPlanoExist;

                break;
              case 'M44':
                isValid = isPKMExist;

                break;
              default:
                isValid = true;
            }

            if (!isValid) {
              break;
            }
          }

          if (isValid) {
            isOOScomplete = true;
            // isOOScomplete = await coos.checkCompleteOOS(
            //     widget.fdKodeLangganan, widget.startDayDate);
            if (!isOOScomplete) {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Data OOS belum lengkap terisi')));
              return;
            }

            //Validasi HET harus input semua kode group barang
            // bool isHETComplete = await chet.isHETAllGroupFinish(
            //     widget.fdKodeLangganan, widget.startDayDate);
            isHETComplete = true;

            if (!isHETComplete) {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Data HET belum lengkap terisi')));
              return;
            }

            String dirCameraPath =
                '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}';

            //Zip Folder langganan
            Directory dir =
                Directory('$dirCameraPath/${widget.fdKodeLangganan}');
            String zipPath =
                '$dirCameraPath/${widget.fdKodeLangganan}.zip'; //path di luar folder kode langganan
            String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

            if (errorMsg.isEmpty) {
              await csales.endVisitSFActivity(
                  widget.user.fdKodeSF,
                  widget.user.fdKodeDepo,
                  param.dateTimeFormatDB.format(DateTime.now()),
                  endVisitActivity,
                  widget.fdKodeLangganan);

              try {
                await capi.sendLogDevicetoServer(
                    widget.user.fdKodeDepo,
                    widget.user.fdKodeSF,
                    widget.user.fdToken,
                    '',
                    param.dateTimeFormatDB.format(DateTime.now()));

                //send data to server
                Map<String, dynamic> mapResult =
                    await capi.sendDataPendingToServer(
                        widget.user, dirCameraPath, widget.startDayDate);

                if (mapResult['fdData'] == '401') {
                  await sessionExpired();

                  return; //stop process
                } else if (mapResult['fdMessage'].isNotEmpty) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mapResult['fdMessage'])));
                }

                //sugeng send pending LK to server
                Map<String, dynamic> mapResultLK =
                    await capi.sendDataPendingLimitKreditToServer(
                        widget.user, dirCameraPath, widget.startDayDate);

                if (mapResultLK['fdData'] == '401') {
                  await sessionExpired();

                  return; //stop process
                } else if (mapResultLK['fdMessage'].isNotEmpty) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mapResultLK['fdMessage'])));
                }
                //end sugeng send pending LK to server
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('error: $e')));
              }

              if (!mounted) return;

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         settings: const RouteSettings(
              //             name: 'LimitKreditFormOrder'),
              //         builder: (context) => LimitKreditFormOrderPage(
              //             fdKodeLangganan: widget.fdKodeLangganan,
              //             user: widget.user,
              //             isEndDay: widget.isEndDay,
              //             routeName: 'LimitKreditFormOrder',
              //             startDayDate: widget.startDayDate))).then(
              //     (value) {
              //   initLoadPage();

              //   setState(() {});
              // });

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         settings: RouteSettings(name: widget.routeName),
              //         builder: (context) => NOOPage(
              //             user: widget.user,
              //             routeName: widget.routeName,
              //             isEndDay: widget.isEndDay,
              //             startDayDate: widget.startDayDate)),
              //     ModalRoute.withName('home'));
            } else {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text('Error compress file: $errorMsg')));
            }
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Data belum lengkap terisi')));
          }
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('error: $e')));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: widget.routeName),
                builder: (context) => NOOPage(
                    user: widget.user,
                    routeName: widget.routeName,
                    isEndDay: widget.isEndDay,
                    startDayDate: widget.startDayDate)),
            ModalRoute.withName('home'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Registrasi Langganan Baru'),
            automaticallyImplyLeading: false,
            actions: [
              isLoading
                  ? const Padding(padding: EdgeInsets.zero)
                  : endTimeVisit.isEmpty
                      ? IconButton(
                          onPressed: () async {
                            if (isTransaction) {
                              alertScaffold(
                                  'Ada input transaksi, tidak dapat cancel visit');
                            } else {
                              reasonCancelDialogForm(widget.fdKodeLangganan);
                            }
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 24 * ScaleSize.textScaleFactor(context),
                          ),
                          tooltip: 'Cancel Visit',
                        )
                      : const Padding(padding: EdgeInsets.zero),
              // isLoading
              //     ? const Padding(padding: EdgeInsets.zero)
              //     : const Padding(padding: EdgeInsets.all(5)),
              // IconButton(
              //   onPressed: () async {
              //     await getNotes(widget.fdKodeLangganan);
              //     noteDialogForm(widget.fdKodeLangganan);
              //   },
              //   icon: Icon(
              //     Icons.edit_document,
              //     color: Colors.white,
              //     size: 24 * ScaleSize.textScaleFactor(context),
              //   ),
              //   tooltip: 'Note',
              // ),
              isLoading
                  ? const Padding(padding: EdgeInsets.zero)
                  : const Padding(padding: EdgeInsets.all(5)),
              (endTimeVisit.isEmpty
                  ? IconButton(
                      onPressed: () async {
                        if (!isPaused) {
                          await checkMaxLanggananPause();
                          isMaxPause
                              ? alertScaffold(
                                  'Sudah mencapai limit pause per hari')
                              : reasonDialogForm(widget.fdKodeLangganan);
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content:
                                    Text('Langganan sudah pernah di-Pause')));
                        }
                      },
                      icon: isPaused
                          ? Icon(
                              Icons.stop_circle,
                              color: Colors.white,
                              size: 24 * ScaleSize.textScaleFactor(context),
                            )
                          : Icon(
                              Icons.pause_circle_filled,
                              color: Colors.white,
                              size: 24 * ScaleSize.textScaleFactor(context),
                            ),
                      tooltip: 'Pause',
                    )
                  : const Padding(padding: EdgeInsets.zero)),
              isLoading
                  ? const Padding(padding: EdgeInsets.zero)
                  : const Padding(padding: EdgeInsets.all(5)),
              IconButton(
                onPressed: () async {
                  print(statusLimitKredit);
                  if (statusLimitKredit) {
                    await alertLimitKredit();
                  } else {
                    await confirmEndVisit();
                  }
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 24 * ScaleSize.textScaleFactor(context),
                ),
                tooltip: 'End Visit',
              ),
            ],
          ),
          body: isLoading
              ? Center(
                  child: loadingProgress(ScaleSize.textScaleFactor(context)))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      decoration: css.boxDecorMenuHeader(),
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                                    '${noo.fdKodeNoo} - ${noo.fdNamaToko}',
                                    style: css.textHeaderBold())),
                            //sugeng remark label in out
                            // SizedBox(
                            //     width: MediaQuery.of(context).size.width * 0.2,
                            //     child: Align(
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           'In   : $startTimeVisit\nOut: $endTimeVisit',
                            //           style: css.textHeaderNormal(),
                            //         ))),
                            //sugeng end remark label in out
                          ])),
                  const Padding(padding: EdgeInsets.all(10)),
                  Flexible(
                      child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Nama Langganan',
                                  style: css.textNormalBold()),
                            ),
                            const Text(' : '),
                            Expanded(child: Text('${noo.fdNamaToko}'))
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Contact Person',
                                  style: css.textNormalBold()),
                            ),
                            const Text(' : '),
                            Expanded(child: Text('${noo.fdContactPerson}'))
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child:
                                  Text('Telepon', style: css.textNormalBold()),
                            ),
                            const Text(' : '),
                            Expanded(child: Text('${noo.fdPhone}'))
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child:
                                  Text('Alamat', style: css.textNormalBold()),
                            ),
                            const Text(' : '),
                            Expanded(child: Text(noo.fdAlamat!))
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text('Limit Kredit',
                                  style: css.textNormalBold()),
                            ),
                            const Text(' : '),
                            Expanded(
                                child: Text(
                                    'Rp. ${param.enNumberFormat.format(noo.fdLimitKredit).toString()}'))
                          ],
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     SizedBox(
                        //       width: 90,
                        //       child: Text('Kota', style: css.textNormalBold()),
                        //     ),
                        //     const Text(' : '),
                        //     Expanded(child: Text(lgn.fdKota!))
                        //   ],
                        // )
                      ],
                    ),
                  )),
                  const Padding(padding: EdgeInsets.all(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: isImgTokoLuar1Exist
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PreviewPictureScreen(
                                                        imgBytes: File(
                                                                tokoLuar1ImgPath)
                                                            .readAsBytesSync())));
                                      }
                                    : null,
                                child: isImgTokoLuar1Exist
                                    ? FadeInImage(
                                        placeholder: const AssetImage(
                                            'assets/images/transparent.png'),
                                        placeholderFit: BoxFit.scaleDown,
                                        image: MemoryImage(
                                            File(tokoLuar1ImgPath)
                                                .readAsBytesSync()),
                                        fit: BoxFit.fitHeight,
                                        width: 100 *
                                            ScaleSize.textScaleFactor(context),
                                        height: 100 *
                                            ScaleSize.textScaleFactor(context))
                                    : Icon(Icons.broken_image,
                                        size: 24 *
                                            ScaleSize.textScaleFactor(
                                                context))),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: isImgTokoDalam1Exist
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PreviewPictureScreen(
                                                        imgBytes: File(
                                                                tokoDalam1ImgPath)
                                                            .readAsBytesSync())));
                                      }
                                    : null,
                                child: isImgTokoDalam1Exist
                                    ? FadeInImage(
                                        placeholder: const AssetImage(
                                            'assets/images/transparent.png'),
                                        placeholderFit: BoxFit.scaleDown,
                                        image: MemoryImage(
                                            File(tokoDalam1ImgPath)
                                                .readAsBytesSync()),
                                        fit: BoxFit.fitHeight,
                                        width: 100 *
                                            ScaleSize.textScaleFactor(context),
                                        height: 100 *
                                            ScaleSize.textScaleFactor(context))
                                    : Icon(Icons.broken_image,
                                        size: 24 *
                                            ScaleSize.textScaleFactor(
                                                context))),
                          ]),
                    ],
                  )
                ]),
          //sugeng remark floating button end visit
          // floatingActionButton: isLoading
          //     ? const Padding(padding: EdgeInsets.zero)
          //     : FloatingActionButton(
          //         onPressed: () {
          //           confirmEndVisit();
          //         },
          //         tooltip: 'End Visit',
          //         child: Icon(
          //           Icons.exit_to_app,
          //           size: 24 * ScaleSize.textScaleFactor(context),
          //         ),
          //       ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniEndFloat,
          //sugeng end remark floating button end visit
          bottomNavigationBar: isLoading
              ? const Padding(padding: EdgeInsets.zero)
              : BottomAppBar(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  height: (300 * ScaleSize.textScaleFactor(context)),
                  color: Colors.grey.shade300, // Colors.green[100],
                  shape: const CircularNotchedRectangle(),
                  clipBehavior: Clip.hardEdge,
                  child:
                      // SingleChildScrollView(
                      //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      //     scrollDirection: Axis.horizontal,
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: createMenu())),
                      DefaultTabController(
                    length: 1,
                    child: Column(
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 239, 219, 166),
                          child: const TabBar(
                            indicatorColor: Colors.black,
                            indicator: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                                bottom: BorderSide(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                                left: BorderSide(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                                right: BorderSide(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                              ),
                              color: Color(0xFFfcba03),
                            ),
                            labelColor: Colors.black,
                            // dividerColor: Colors.orange,
                            unselectedLabelColor: Colors.black54,
                            tabs: <Widget>[
                              Tab(
                                text: 'Sales',
                                icon: Icon(Icons.luggage),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey.shade300,
                            child: TabBarView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          settings: const RouteSettings(
                                                              name: 'nooorder'),
                                                          builder: (context) =>
                                                              NooOrderFormPage(
                                                                  fdNoEntryOrder: noo
                                                                      .fdKodeNoo!,
                                                                  lgn: noo,
                                                                  user: widget
                                                                      .user,
                                                                  isEndDay: widget
                                                                      .isEndDay,
                                                                  routeName:
                                                                      'nooorder',
                                                                  // endTimeVisit:
                                                                  //     endTimeVisit,
                                                                  startDayDate:
                                                                      widget
                                                                          .startDayDate))).then(
                                                      (value) {
                                                    initLoadPage();

                                                    setState(() {});
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.orange,
                                                            width: 1),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Image.asset(
                                                          'assets/images/pesanan.jpg',
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Pesanan',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          settings:
                                                              const RouteSettings(
                                                                  name:
                                                                      'NooCanvas'),
                                                          builder: (context) =>
                                                              NooCanvasPage(
                                                                  lgn: noo,
                                                                  user: widget
                                                                      .user,
                                                                  isEndDay: widget
                                                                      .isEndDay,
                                                                  routeName:
                                                                      'NooCanvas',
                                                                  endTimeVisit:
                                                                      endTimeVisit,
                                                                  startDayDate:
                                                                      widget
                                                                          .startDayDate))).then(
                                                      (value) {
                                                    initLoadPage();

                                                    setState(() {});
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.orange,
                                                            width: 1),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Image.asset(
                                                          'assets/images/pesanan.jpg',
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Penjualan',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
