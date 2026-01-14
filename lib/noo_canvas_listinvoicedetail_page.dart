import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
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

class ListInvoiceDetailPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String fdNoRencanaRute;
  final String fdTanggalRencanaRute;
  final String startDayDate;
  final bool isEndDay;

  const ListInvoiceDetailPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.fdNoRencanaRute,
      required this.fdTanggalRencanaRute,
      required this.isEndDay,
      required this.startDayDate});

  @override
  State<ListInvoiceDetailPage> createState() => LayerListInvoiceDetailPage();
}

class LayerListInvoiceDetailPage extends State<ListInvoiceDetailPage> {
  bool isLoading = false;
  List<mrrute.ViewDetailRencanaRuteFaktur> listRencanaRuteFaktur = [];

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

      listRencanaRuteFaktur = await crute.getDataRencanaRuteFakturDetail(
          widget.fdNoRencanaRute, widget.fdTanggalRencanaRute);

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
    return Scaffold(
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
                child: Text('${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}',
                    style: css.textHeaderBold())),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [Text('Invoice List')],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(DateFormat('dd MMM yyyy').format(param.dtFormatDB
                              .parse((widget.fdTanggalRencanaRute))))
                        ],
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
            ]),
            const Column(children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Invoice No'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Langganan'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Amount',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Tgl Invoice'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Tgl Jatuh Tempo'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Paid',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.orange,
                ),
              ),
            ]),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: listRencanaRuteFaktur.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                '#${listRencanaRuteFaktur[index].fdNoFaktur!}'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                listRencanaRuteFaktur[index].fdNamaLangganan!),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                'Rp. ${param.enNumberFormat.format(
                                  double.tryParse(listRencanaRuteFaktur[index]
                                              .fdSisaNilaiInvoice
                                              ?.toString() ??
                                          '0') ??
                                      0,
                                )}',
                                textAlign: TextAlign.right),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(DateFormat('dd MMM yyyy').format(param
                                .dtFormatDB
                                .parse(listRencanaRuteFaktur[index]
                                    .fdTanggalFaktur!))),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(DateFormat('dd MMM yyyy').format(param
                                .dtFormatDB
                                .parse(listRencanaRuteFaktur[index]
                                    .fdTanggalJT!))),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                'Rp. ${param.enNumberFormat.format(double.tryParse(listRencanaRuteFaktur[index].fdSisaNilaiInvoice?.toString() ?? '0') ?? 0)}',
                                textAlign: TextAlign.right),
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
                ]);
              },
            )),
          ])),
    );
  }
}
