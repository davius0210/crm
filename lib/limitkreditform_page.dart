import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'limitkredit_page.dart';
import 'main.dart';
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

class LimitKreditFormPage extends StatefulWidget {
  final String kodeLangganan;
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const LimitKreditFormPage(
      {super.key,
      required this.kodeLangganan,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<LimitKreditFormPage> createState() => LayerLimitKreditForm();
}

class LayerLimitKreditForm extends State<LimitKreditFormPage> {
  bool isLoading = false;
  List<mlgn.Langganan> langganans = [];
  List<mlk.LimitKredit> listLimitKredit = [];
  List<mlgn.Langganan> listLangganan = [];
  List<mpro.ViewBarangPromo> barangs = [];
  List<modr.Order> listOrder = [];
  List<modr.Order> listOrderDetail = [];
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
  double totalTagihan = 0;
  double limitKredit = 0;
  double sisaLK = 0;
  double pesananBaru = 0;
  double overLK = 0;
  double pengajuanBaru = 0;
  String noEntry = '';
  String tanggalPengajuanLk = '';

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

      listLangganan = await clgn.getLanggananOrder(
          widget.user.fdKodeSF, widget.user.fdKodeDepo);
      if (widget.kodeLangganan.isNotEmpty) {
        langganansSelected = widget.kodeLangganan;
        await changeListGroupBarang(langganansSelected);
      }
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

  Future<void> changeListGroupBarang(String? fdKodeLangganan) async {
    try {
      langganans = await clgn.getLanggananByKodeLangganan(fdKodeLangganan!);
      listOrder = await codr.getDataOrderByKodeLangganan(fdKodeLangganan);
      listOrderDetail =
          await codr.getDataOrderDetailByKodeLangganan(fdKodeLangganan);
      totalTagihan = await cpiu.getTotalTagihan(fdKodeLangganan);
      setState(() {
        if (langganans.isNotEmpty) {
          sisaLK = langganans.first.fdLimitKredit! - totalTagihan;
          txtLimitKredit.text = param.enNumberFormat
              .format(langganans.first.fdLimitKredit)
              .toString();
          limitKredit = langganans.first.fdLimitKredit!;
          txtSisaLimitKredit.text =
              param.enNumberFormat.format(sisaLK).toString();
          sisaLK = sisaLK;
          //langganans.first.fdLimitKredit!;
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
          tanggalPengajuanLk = listOrderDetail.first.fdTanggalKirim!;
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

      listLimitKredit = [
        mlk.LimitKredit(
          fdNoLimitKredit: noEntry,
          fdDepo: widget.user.fdKodeDepo,
          fdKodeLangganan: langganansSelected,
          fdSisaLimit: sisaLK,
          fdPesananBaru: pesananBaru,
          fdOverLK: overLK,
          fdTglStatus: param.dtFormatDB.format(DateTime.now()),
          fdTanggal:
              param.dtFormatDB.format(DateTime.parse(tanggalPengajuanLk)),
          fdLimitKredit: limitKredit,
          fdPengajuanLimitBaru: pengajuanBaru,
          fdKodeStatus: 1,
          fdStatusSent: 0,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        )
      ];
      List<mlk.LimitKredit> items = listLimitKredit.toList();
      await clk.insertLimitKreditBatch(items);

      // Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: 'limitkredit'),
              builder: (context) => LimitKreditPage(
                  user: widget.user,
                  startDayDate: widget.startDayDate,
                  isEndDay: widget.isEndDay,
                  routeName: 'limitkredit')));

      //  Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 settings: const RouteSettings(name: 'order'),
      //                 builder: (context) => OrderPage(
      //                     lgn: widget.lgn,
      //                     user: widget.user,
      //                     isEndDay: widget.isEndDay,
      //                     routeName: 'order',
      //                     endTimeVisit: widget.endTimeVisit,
      //                     startDayDate: widget.startDayDate)))
      //         .then((value) {
      //       initLoadPage();

      //       setState(() {});
      //     });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limit Kredit'),
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
                child: Text('${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
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
                    child:
                        // DropdownButton<String>(
                        //   borderRadius:
                        //       const BorderRadius.all(Radius.circular(30)),
                        //   dropdownColor: Colors.blue[50],
                        //   isExpanded: true,
                        //   underline: const Text(''),
                        //   value: langganansSelected.isEmpty
                        //       ? null
                        //       : langganansSelected,
                        //   items: listLangganan.map<DropdownMenuItem<String>>(
                        //       (mlgn.Langganan item) {
                        //     return DropdownMenuItem<String>(
                        //         value: item.fdKodeLangganan,
                        //         child: Text(item.fdNamaLangganan!));
                        //   }).toList(),
                        //   onChanged: (value) async {
                        //     langganansSelected = value!;
                        //     // await changeListGroupBarang(
                        //     //     langganansSelected!.fdKodeLangganan);
                        //     await changeListGroupBarang(langganansSelected);
                        //     setState(() {});
                        //   },
                        // ),
                        DropdownSearch<mlgn.Langganan>(
                      itemAsString: (mlgn.Langganan item) =>
                          item.fdNamaLangganan!,
                      compareFn: (mlgn.Langganan item,
                              mlgn.Langganan selectedItem) =>
                          item.fdKodeLangganan == selectedItem.fdKodeLangganan,
                      items: (String filter, LoadProps? loadProps) => listLangganan,
                      enabled: widget.kodeLangganan.isNotEmpty ? false : true,
                      selectedItem: listLangganan.firstWhere(
                        (item) =>
                            item.fdKodeLangganan!.trim() == langganansSelected,
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
                                size: 24 * ScaleSize.textScaleFactor(context)),
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
                        // await changeListGroupBarang(
                        //     langganansSelected!.fdKodeLangganan);
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
                          'Pesanan Baru',
                          const TextStyle(fontStyle: FontStyle.italic),
                          'Pesanan Baru',
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
                      enabled: true,
                      readOnly: false,
                    ),
                  ),
                ],
              ),
            )),
          ])),
      bottomNavigationBar: isLoading
          ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
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
    );
  }
}
