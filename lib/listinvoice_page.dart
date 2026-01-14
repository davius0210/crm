import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:crm_apps/listinvoicedetail_page.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as cpath;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'listinvoicedetail_page.dart';
import 'main.dart';
import 'home_page.dart';
import 'controller/api_cont.dart' as capi;
import 'controller/rute_cont.dart' as crute;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/globalparam.dart' as param;
import 'models/rencanarute.dart' as mrrute;
import 'style/css.dart' as css;

class ListInvoicePage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;
  final bool isEndDay;

  const ListInvoicePage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<ListInvoicePage> createState() => LayerListInvoicePage();
}

class LayerListInvoicePage extends State<ListInvoicePage> {
  bool isLoading = false;
  List<mrrute.ViewRencanaRuteFaktur> listRencanaRuteFaktur = [];

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

      listRencanaRuteFaktur = await crute.getAllRencanaRuteFaktur();

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
          title: const Text('List Invoice'),
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
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: listRencanaRuteFaktur.length,
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
                                        name: 'List Invoice Detail'),
                                    builder: (context) => ListInvoiceDetailPage(
                                        user: widget.user,
                                        fdNoRencanaRute:
                                            listRencanaRuteFaktur[index]
                                                .fdNoRencanaRute,
                                        fdTanggalRencanaRute:
                                            listRencanaRuteFaktur[index]
                                                .fdTanggalRencanaRute!,
                                        startDayDate: widget.startDayDate,
                                        isEndDay: widget.isEndDay,
                                        routeName: 'ListInvoiceDetail')))
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
                                      'No Serah Terima : ${listRencanaRuteFaktur[index].fdNoRencanaRute}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                    Text(
                                      'Periode : ${DateFormat('dd MMM yyyy').format(param.dtFormatDB.parse(listRencanaRuteFaktur[index].fdStartDate!))} - ${DateFormat('dd MMM yyyy').format(param.dtFormatDB.parse(listRencanaRuteFaktur[index].fdEndDate!))}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                    Text(
                                      'Tanggal : ${DateFormat('dd MMM yyyy').format(param.dtFormatDB.parse(listRencanaRuteFaktur[index].fdTanggalRencanaRute!))}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                    Text(
                                      'Jumlah Invoice : ${listRencanaRuteFaktur[index].fdCountInv}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                    Text(
                                      'Nominal Invoice : ${param.enNumberFormat.format(double.tryParse(listRencanaRuteFaktur[index].fdSisaNilaiInvoice?.toString() ?? '0') ?? 0)}',
                                      softWrap: true,
                                      style: css.textSmallSizeBlackBold(),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
            ])),
      ),
    );
  }
}
