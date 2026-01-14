import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'models/globalparam.dart' as param;
import 'package:sqflite/sqflite.dart';
import '../models/salesman.dart' as msf;

List<Map<String, dynamic>> resultMaps = [];
late Database db;

class CustInfoPage extends StatefulWidget {
  final msf.Salesman user;
  final String fdKodeLangganan;
  final double fdLimitKredit;
  final double totalTagihan;
  final double totalTagihanSebelumJT;
  final double totalTagihanJT;
  final double sisaLimitKredit;
  final String routeName;
  final String startDayDate;

  const CustInfoPage(
      {super.key,
      required this.user,
      required this.fdKodeLangganan,
      required this.fdLimitKredit,
      required this.totalTagihan,
      required this.totalTagihanSebelumJT,
      required this.totalTagihanJT,
      required this.sisaLimitKredit,
      required this.routeName,
      required this.startDayDate});

  @override
  State<CustInfoPage> createState() => LayerCustInfo();
}

class LayerCustInfo extends State<CustInfoPage> {
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  bool vertical = false;

  bool isLoading = false;

  String fileName = '';
  String noEntry = '';

  String? noSJ;
  late StateSetter internalSetter;
  @override
  void initState() {
    setState(() {});

    initLoadPage();
    super.initState();
  }

  void initLoadPage() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Info Langganan'),
            actions: const [],
          ),
          bottomNavigationBar: isLoading
              ? loadingProgress(ScaleSize.textScaleFactor(context))
              : const Text(''),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Limit Kredit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.fdLimitKredit == 0.0
                                      ? '0'
                                      : 'Rp. ${param.enNumberFormat.format(widget.fdLimitKredit).toString()}'),
                                ],
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sisa Limit Kredit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.sisaLimitKredit == 0.0
                                      ? '0'
                                      : 'Rp. ${param.enNumberFormat.format(widget.sisaLimitKredit).toString()}'),
                                ],
                              ),
                            ]),
                      ),
                      const Padding(padding: EdgeInsets.all(24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Tagihan Belum Dibayar',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.totalTagihan == 0.0
                                          ? '0'
                                          : 'Rp. ${param.enNumberFormat.format(widget.totalTagihan).toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '- Faktur Sebelum Jatuh Tempo :',
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.totalTagihanSebelumJT == 0.0
                                      ? '0'
                                      : 'Rp. ${param.enNumberFormat.format(widget.totalTagihanSebelumJT).toString()}'),
                                ],
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '- Faktur Jatuh Tempo :',
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.totalTagihanJT == 0.0
                                      ? '0'
                                      : 'Rp. ${param.enNumberFormat.format(widget.totalTagihanJT).toString()}'),
                                ],
                              ),
                            ]),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}
