import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'cust_page.dart';
import 'collection_page.dart';
import 'package:crm_apps/piutangedit_page.dart';
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/collection_cont.dart' as ccoll;
import 'models/collection.dart' as mcoll;
import 'models/globalparam.dart' as param;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/piutang.dart' as mpiu;
import 'style/css.dart' as css;

class PiutangPage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final bool isEndDay;
  final String endTimeVisit;
  final String startDayDate;

  const PiutangPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.isEndDay,
      required this.endTimeVisit,
      required this.startDayDate});

  @override
  State<PiutangPage> createState() => LayerPiutangPage();
}

class LayerPiutangPage extends State<PiutangPage> {
  bool isLoading = false;
  bool isComplete = false;
  List<mpiu.Piutang> listPiutang = [];
  List<mcoll.CollectionDetail> _listCollection = [];
  TextEditingController txtStartDate = TextEditingController();
  TextEditingController txtEndDate = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();
  Map<String, TextEditingController> textEditingControllers = {};
  String fdPiutang = '';
  String fdAktivitas = '';
  String stateKodeBarang = '';
  String stateKodeGroup = '';
  int stateDelete = 0;
  double totalTagihan = 0;
  double totalCollection = 0;
  double collectionUsed = 0;

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

      totalTagihan = await cpiu.getTotalTagihan(widget.lgn.fdKodeLangganan!);
      listPiutang = await cpiu.getAllPiutang(widget.lgn.fdKodeLangganan!);
      _listCollection =
          await ccoll.getAllCollectionByLangganan(widget.lgn.fdKodeLangganan!);
      totalCollection =
          _listCollection.fold(0, (sum, item) => sum + item.fdTotalCollection);
      collectionUsed =
          await cpiu.getTotalAllocation(widget.lgn.fdKodeLangganan!);

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

  void yesNoDialogForm(int index) {
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
                    stateDelete = await cpiu.deleteByNoEntry(
                        widget.user.fdToken, listPiutang[index].fdNoFaktur!);
                    if (stateDelete == 1) {
                      initLoadPage();
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerPage(
                          fdKodeLangganan: widget.lgn.fdKodeLangganan!,
                          user: widget.user,
                          routeName: widget.routeName,
                          isEndDay: widget.isEndDay,
                          startDayDate: widget.startDayDate)));

              return false;
            }
          : () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Tagihan'),
          ),
          body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              backgroundColor: Colors.yellow,
              color: Colors.red,
              strokeWidth: 2,
              onRefresh: () async {
                initLoadPage();

                return Future.delayed(const Duration(milliseconds: 500));
              },
              child: isLoading
                  ? Center(
                      child:
                          loadingProgress(ScaleSize.textScaleFactor(context)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(5),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: css.boxDecorMenuHeader(),
                              child: Text(
                                  '${widget.lgn.fdKodeLangganan} - ${widget.lgn.fdNamaLangganan}',
                                  style: css.textHeaderBold())),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Tagihan Belum Dibayar :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          '''Rp. ${param.idNumberFormat.format(totalTagihan)}''',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Collection :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          '''Rp. ${param.idNumberFormat.format(totalCollection)}''',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Available :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          '''Rp. ${param.idNumberFormat.format(totalCollection - collectionUsed)}''',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Used :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          '''Rp. ${param.idNumberFormat.format(collectionUsed)}''',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: ListView.builder(
                            padding: const EdgeInsets.all(5),
                            itemCount: listPiutang.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 3,
                                  shadowColor: Colors.blue,
                                  shape: css.boxStyle(),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  color: DateTime.now().isAfter(DateTime.parse(
                                          listPiutang[index].fdTanggalJT!))
                                      ? Colors.red.shade200
                                      : Colors.white,
                                  child: InkWell(
                                      onTap: () {
                                        print(listPiutang[index]
                                            .fdNoEntryFaktur!);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                settings: const RouteSettings(
                                                    name: 'PiutangEdit'),
                                                builder: (context) =>
                                                    PiutangEditPage(
                                                        user: widget.user,
                                                        lgn: widget.lgn,
                                                        noentry: listPiutang[
                                                                index]
                                                            .fdNoEntryFaktur!,
                                                        navpage: 'piutangedit',
                                                        isEndDay:
                                                            widget.isEndDay,
                                                        startDayDate:
                                                            widget.startDayDate,
                                                        endTimeVisit:
                                                            widget.endTimeVisit,
                                                        routeName:
                                                            'PiutangEdit'))).then(
                                            (value) {
                                          initLoadPage();

                                          setState(() {});
                                        });
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Invoice ${listPiutang[index].fdNoFaktur}',
                                                          softWrap: true,
                                                          style: css
                                                              .textNormalBold()),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3)),
                                                      Text(
                                                          '''Tanggal Jatuh Tempo : ${param.dtFormatViewMMM.format(DateTime.parse(listPiutang[index].fdTanggalJT!))}''',
                                                          softWrap: true),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3)),
                                                      Text(
                                                          '''Nilai Pesanan : Rp. ${param.idNumberFormat.format(listPiutang[index].fdNetto)}''',
                                                          softWrap: true),
                                                    ]),
                                              ),
                                            ],
                                          ))));
                            },
                          )),
                        ])),
          floatingActionButton: isLoading
              ? const Padding(padding: EdgeInsets.zero)
              : widget.endTimeVisit.isEmpty
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // FloatingActionButton(
                        //   tooltip: 'Collection',
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             settings:
                        //                 const RouteSettings(name: 'collection'),
                        //             builder: (context) => CollectionPage(
                        //                 lgn: widget.lgn,
                        //                 user: widget.user,
                        //                 noentry: '',
                        //                 navpage: 'piutangpage',
                        //                 routeName: 'collection',
                        //                 isEndDay: widget.isEndDay,
                        //                 endTimeVisit: widget.endTimeVisit,
                        //                 startDayDate: widget.startDayDate,
                        //                 alamatSelected: '',
                        //                 orderExist: 0,
                        //                 totalPromosiExtra: 0,
                        //                 totalDiscount: 0,
                        //                 totalPesanan: 0,
                        //                 listKeranjang: const [],
                        //                 noFaktur: '',
                        //                 txtTanggalKirim: ''))).then((value) {
                        //       initLoadPage();

                        //       setState(() {});
                        //     });
                        //   },
                        //   child: Icon(Icons.paid_rounded,
                        //       size: 24 * ScaleSize.textScaleFactor(context)),
                        // ),
                      ],
                    )
                  : null),
    );
  }
}
