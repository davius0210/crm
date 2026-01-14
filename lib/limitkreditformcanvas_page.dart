import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'limitkredit_page.dart';
import 'order_page.dart';
import 'main.dart';
import 'rute_page.dart';
import 'controller/langganan_cont.dart' as clgn;
import 'controller/limitkredit_cont.dart' as clk;
import 'controller/order_cont.dart' as codr;
import 'controller/other_cont.dart' as cother;
import 'controller/promo_cont.dart' as cpro;
import 'controller/piutang_cont.dart' as cpiu;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/limitkredit.dart' as mlk;
import 'models/order.dart' as modr;
import 'models/promo.dart' as mpro;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

class LimitKreditFormCanvasPage extends StatefulWidget {
  final String noLimitKredit;
  // final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const LimitKreditFormCanvasPage(
      {super.key,
      required this.noLimitKredit,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<LimitKreditFormCanvasPage> createState() => LayerLimitKreditFormOrder();
}

class LayerLimitKreditFormOrder extends State<LimitKreditFormCanvasPage> {
  bool isLoading = false;
  List<mlgn.Langganan> langganans = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  List<mlk.ListLimitKredit> listEditLimitKredit = [];
  List<mlgn.Langganan> listLangganan = [];
  List<mpro.ViewBarangPromo> barangs = [];
  List<modr.Order> listOrder = [];
  String langganansSelected = '';
  // mlgn.Langganan? langganansSelected;
  TextEditingController txtNoPengajuanLK = TextEditingController();
  TextEditingController txtLimitKredit = TextEditingController();
  TextEditingController txtSisaLimitKredit = TextEditingController();
  TextEditingController txtPesananBaru = TextEditingController();
  TextEditingController txtOverLimitKredit = TextEditingController();
  TextEditingController txtPengajuanBaruLK = TextEditingController();
  Map<String, TextEditingController> textEditingControllers = {};
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  double limitKredit = 0;
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  double pengajuanBaru = 0;
  int fdKodeStatus = 0;
  String noEntry = '';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initLoadPage();
    String tanggal = DateFormat('yyMMddHHmmssSSS').format(DateTime.now());
    noEntry = tanggal;
    txtNoPengajuanLK.text = noEntry;
    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      listLangganan = await clgn.getAllLanggananNonRute(
          widget.user.fdKodeSF, widget.user.fdKodeDepo);
      listLimitKredit =
          await clk.getDataLimitKreditByNoEntry(widget.noLimitKredit);

      setState(() {
        if (listLimitKredit.isNotEmpty) {
          txtNoPengajuanLK.text = listLimitKredit.first.fdNoLimitKredit!;
          langganansSelected = listLimitKredit.first.fdKodeLangganan!;
          txtLimitKredit.text = param.enNumberFormatQty
              .format(listLimitKredit.first.fdLimitKredit)
              .toString();
          txtSisaLimitKredit.text = param.enNumberFormatQty
              .format(listLimitKredit.first.fdSisaLimit)
              .toString();
          txtPesananBaru.text = param.enNumberFormatQty
              .format(listLimitKredit.first.fdPesananBaru)
              .toString();
          txtOverLimitKredit.text = param.enNumberFormatQty
              .format(listLimitKredit.first.fdOverLK)
              .toString();
          txtPengajuanBaruLK.text = param.enNumberFormatQty
              .format(listLimitKredit.first.fdPengajuanLimitBaru)
              .toString();
          fdKodeStatus = listLimitKredit.first.fdKodeStatus;
        }
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

  Future<void> changeListGroupBarang(String? fdKodeLangganan) async {
    try {
      langganans = await clgn.getLanggananByKodeLangganan(fdKodeLangganan!);
      listOrder = await codr.getDataOrderByKodeLangganan(fdKodeLangganan);

      setState(() {
        if (langganans.isNotEmpty) {
          txtLimitKredit.text = param.enNumberFormat
              .format(langganans.first.fdLimitKredit)
              .toString();
          limitKredit = langganans.first.fdLimitKredit!;
          txtSisaLimitKredit.text =
              param.enNumberFormat.format(50000).toString();
          sisaLK = 50000;
          txtPesananBaru.text = param.enNumberFormat
              .format(listOrder.first.fdTotalOrder)
              .toString();
          pesananBaru = listOrder.first.fdTotalOrder;
          overLK = pesananBaru - sisaLK;
          txtOverLimitKredit.text =
              param.enNumberFormat.format(overLK).toString();
          pengajuanBaru = limitKredit + overLK;
          txtPengajuanBaruLK.text =
              param.enNumberFormat.format(pengajuanBaru).toString();
        } else {
          txtLimitKredit.text = '';
          txtSisaLimitKredit.text = '';
        }

        langganansSelected = fdKodeLangganan;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void saveLimitKredit() async {
    try {
      setState(() {
        isLoading = true;
      });

      await clk.updateKodeStatusLimitKredit(
          widget.noLimitKredit,
          double.parse(
              txtPengajuanBaruLK.text.replaceAll('.', '').replaceAll(',', '')));

      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: 'limitkredit'),
              builder: (context) => LimitKreditPage(
                  user: widget.user,
                  startDayDate: widget.startDayDate,
                  isEndDay: widget.isEndDay,
                  routeName: 'limitkredit')));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Limit Kredit'),
          automaticallyImplyLeading: false,
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
              Flexible(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtNoPengajuanLK,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'No Pengajuan LK',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'No Pengajuan LK',
                            null,
                            null),
                        enabled: false,
                        readOnly: true,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: DropdownSearch<mlgn.Langganan>(
                        itemAsString: (mlgn.Langganan item) =>
                            item.fdNamaLangganan!,
                        compareFn: (mlgn.Langganan item,
                                mlgn.Langganan selectedItem) =>
                            item.fdKodeLangganan ==
                            selectedItem.fdKodeLangganan,
                        items: (String filter, LoadProps? loadProps) => listLangganan,
                        enabled: false,
                        selectedItem: listLangganan.firstWhere(
                          (item) =>
                              item.fdKodeLangganan!.trim() ==
                              langganansSelected,
                          orElse: () => mlgn.Langganan(
                              fdKodeLangganan: '',
                              fdNamaLangganan: '',
                              fdKodeDepo: '',
                              fdKodeSF: '',
                              fdBadanUsaha: '',
                              fdOwner: '',
                              fdContactPerson: '',
                              fdAlamat: '',
                              fdKelurahan: '',
                              fdKodePos: '',
                              fdLA: 0,
                              fdLG: 0,
                              fdTipeOutlet: '',
                              fdNPWP: '',
                              fdNamaNPWP: '',
                              fdAlamatNPWP: '',
                              fdNIK: '',
                              fdKelasOutlet: '',
                              fdKodeRute: '',
                              isRute: 0,
                              fdKodeStatus: 0,
                              isLocked: 0,
                              fdLimitKredit: 0,
                              isEditProfile: 0,
                              fdLastUpdate: '',
                              fdTanggalActivity: '',
                              fdStartVisitDate: '',
                              fdEndVisitDate: '',
                              fdNotVisitReason: '',
                              fdCancelVisitReason: '',
                              fdKodeHarga: ''), // Default empty
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: css.textInputStyle(
                              'Search',
                              const TextStyle(fontStyle: FontStyle.italic),
                              null,
                              Icon(Icons.search,
                                  size:
                                      24 * ScaleSize.textScaleFactor(context)),
                              null,
                            ),
                          ),
                          searchDelay: const Duration(milliseconds: 0),
                          itemBuilder: (context, item, isSelected,val) {
                            return ListTile(
                              title: Text(
                                '[${item.fdKodeLangganan!.trim()}] ${item.fdNamaLangganan!.trim()}',
                                style: css.textSmallSizeBlack(),
                              ),
                            );
                          },
                          menuProps:
                              MenuProps(shape: css.borderOutlineInputRound()),
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: css.textInputStyle(
                            'Langganan',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Langganan',
                            null,
                            null,
                          ),
                        ),
                        onChanged: (value) async {
                          langganansSelected =
                              value?.fdKodeLangganan?.toString() ?? '';
                          await changeListGroupBarang(langganansSelected);
                          setState(() {});
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtLimitKredit,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'Limit Kredit',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Limit Kredit',
                            null,
                            null),
                        enabled: false,
                        readOnly: true,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtSisaLimitKredit,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'Sisa Limit Kredit',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Sisa Limit Kredit',
                            null,
                            null),
                        enabled: false,
                        readOnly: true,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtPesananBaru,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'Nilai Transaksi Terakhir',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Nilai Transaksi Terakhir',
                            null,
                            null),
                        enabled: false,
                        readOnly: true,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtOverLimitKredit,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'Over LK',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Over LK',
                            null,
                            null),
                        enabled: false,
                        readOnly: true,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtPengajuanBaruLK,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          cother.ThousandsSeparatorInputFormatter()
                        ],
                        decoration: css.textInputStyle(
                            'Pengajuan Limit Kredit Baru (LK + Over LK)',
                            const TextStyle(fontStyle: FontStyle.italic),
                            'Pengajuan Limit Kredit Baru (LK + Over LK)',
                            null,
                            null),
                        enabled: fdKodeStatus == 0 ? true : false,
                        readOnly: false,
                      ),
                    ),
                  ],
                ),
              )),
            ])),
        bottomNavigationBar: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : fdKodeStatus == 1
                ? const Padding(padding: EdgeInsets.all(0))
                : BottomAppBar(
                    height: 40 * ScaleSize.textScaleFactor(context),
                    child: TextButton(
                      onPressed: () {
                        if (formInputKey.currentState!.validate()) {
                          saveLimitKredit();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
      ),
    );
  }
}
