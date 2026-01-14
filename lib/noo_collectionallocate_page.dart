import 'noo_collection_page.dart';
import 'noo_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controller/other_cont.dart' as cother;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/collection_cont.dart' as ccoll;
import 'models/globalparam.dart' as param;
import 'models/piutang.dart' as mpiu;
import 'models/collection.dart' as mcoll;
import 'models/langganan.dart' as mlgn;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'main.dart';
import 'style/css.dart' as css;

class NooCollectionAllocationPage extends StatefulWidget {
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String routeName;
  final String noentry;
  final String navpage;
  final String startDayDate;
  final String endTimeVisit;
  final bool isEndDay;
  final double totalCollection;
  final String? alamatSelected;
  final double orderExist;
  final double totalPromosiExtra;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;
  final String noFaktur;
  final String txtTanggalKirim;

  const NooCollectionAllocationPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.noentry,
      required this.routeName,
      required this.navpage,
      required this.startDayDate,
      required this.endTimeVisit,
      required this.isEndDay,
      required this.totalCollection,
      required this.alamatSelected,
      required this.orderExist,
      required this.totalPromosiExtra,
      required this.totalDiscount,
      required this.totalPesanan,
      required this.listKeranjang,
      required this.noFaktur,
      required this.txtTanggalKirim});

  @override
  LayerCollectionAllocation createState() => LayerCollectionAllocation();
}

class LayerCollectionAllocation extends State<NooCollectionAllocationPage> {
  bool isLoading = false;
  bool autoAllocate = false;
  double allocationUsed = 0.0;
  double totalPiutang = 0;
  List<mpiu.Payment> listPayment = [];
  Map<String, Map<String, dynamic>> listPiutangPayment = {};
  List<mcoll.CollectionDetail> _listCollection = [];
  Map<String, TextEditingController> textInvs = {};
  String endTimeVisit = '';

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
        allocationUsed = 0;
        totalPiutang = 0;
        listPiutangPayment.clear();
        textInvs.clear();
      });

      List<mpiu.Payment> listPaymentDetail = await cpiu.getAllPaymentDetail(
          widget.lgn.fdKodeNoo!, widget.noentry, 'noocanvas');

      for (var payment in listPaymentDetail) {
        listPiutangPayment.putIfAbsent(
            payment.fdNoEntryFaktur!,
            () => {
                  'fdNoEntryFaktur': payment.fdNoEntryFaktur,
                  'fdNoFaktur': payment.fdNoFaktur,
                  'fdDepo': payment.fdDepo,
                  'fdKodeLangganan': widget.lgn.fdKodeNoo,
                  'fdTanggal': widget.startDayDate,
                  'fdTanggalFaktur': payment.fdTanggalFaktur,
                  'fdTanggalJT': payment.fdTanggalJT,
                  'fdNetto': payment.fdNetto,
                  'fdTotalAllocation': 0.0,
                  'selected': false,
                  'detailAllocation': <Map<String, dynamic>>[]
                });

        if (payment.fdIdCollection > 0) {
          listPiutangPayment[payment.fdNoEntryFaktur!]!['detailAllocation']
              .add({
            'fdIdCollection': payment.fdIdCollection,
            'fdAllocationAmount': payment.fdAllocationAmount,
          });

          listPiutangPayment[payment.fdNoEntryFaktur!]!['fdTotalAllocation'] +=
              payment.fdAllocationAmount;
        }
      }

      allocationUsed = listPiutangPayment.values
          .fold(0.0, (sum, item) => sum + (item['fdTotalAllocation'] ?? 0.0));

      totalPiutang = listPiutangPayment.values
          .fold(0.0, (sum, item) => sum + (item['fdNetto'] ?? 0.0));

      initTextFormField();

      setState(() {
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

  void initTextFormField() {
    if (listPiutangPayment.isNotEmpty) {
      for (var item in listPiutangPayment.values) {
        String key = item['fdNoEntryFaktur'];
        String value = param.enNumberFormat.format(item['fdTotalAllocation']);

        TextEditingController txtEdit = TextEditingController(text: value);
        textInvs.putIfAbsent(key, () => txtEdit);

        item['selected'] = (item['fdTotalAllocation'] == item['fdNetto']);
      }
    }
  }

  void _toggleAutoAllocate(bool? value) {
    setState(() {
      autoAllocate = value ?? false;

      allocationUsed = 0;
      for (var item in listPiutangPayment.values) {
        TextEditingController? txtEdit = textInvs[item['fdNoEntryFaktur']];
        txtEdit!.text = '0';
        item['fdTotalAllocation'] = 0.0;
        item['selected'] = false;
      }

      if (autoAllocate && widget.totalCollection > 0) {
        _autoAllocateSelected();
      }
    });
  }

  void _toggleInvoiceSelected(int index, bool? value) {
    setState(() {
      final invoice = listPiutangPayment.values.elementAt(index);
      allocationUsed = listPiutangPayment.values
          .fold(0.0, (sum, item) => sum + (item['fdTotalAllocation'] ?? 0.0));
      allocationUsed -= invoice['fdTotalAllocation'];

      if (value == true) {
        double remainingAmount = widget.totalCollection - allocationUsed;
        double allocation = invoice['fdNetto'] <= remainingAmount
            ? invoice['fdNetto']
            : remainingAmount;

        if (allocation > 0) {
          // allocationUsed -= invoice['fdTotalAllocation'];
          TextEditingController? txtEdit = textInvs[invoice['fdNoEntryFaktur']];
          txtEdit!.text = param.enNumberFormat.format(allocation);
          listPiutangPayment.values.elementAt(index)['fdTotalAllocation'] =
              allocation;
          listPiutangPayment.values.elementAt(index)['selected'] =
              (allocation > 0);
          allocationUsed += allocation;
        }
      } else {
        // allocationUsed -= invoice['fdTotalAllocation'];
        listPiutangPayment.values.elementAt(index)['fdTotalAllocation'] = 0.0;
        TextEditingController? txtEdit = textInvs[invoice['fdNoEntryFaktur']];
        txtEdit!.text = '0';
        listPiutangPayment.values.elementAt(index)['selected'] = value ?? false;
      }
    });
  }

  void _autoAllocateSelected() {
    for (var item in listPiutangPayment.values) {
      TextEditingController? txtEdit = textInvs[item['fdNoEntryFaktur']];
      double remainingAmount = widget.totalCollection - allocationUsed;
      double allocation = item['fdNetto'] <= remainingAmount
          ? item['fdNetto']
          : remainingAmount;

      if (allocation > 0) {
        txtEdit!.text = param.enNumberFormat.format(allocation);
        item['fdTotalAllocation'] = allocation;
        item['selected'] = true;
        allocationUsed += allocation;
      } else {
        break; // stop looping if no remaining amount
      }
    }
  }

  void _updateInvoiceAllocation(final invoice, String val) {
    TextEditingController? txtEdit = textInvs[invoice['fdNoEntryFaktur']];
    double currentAllocated =
        listPiutangPayment[invoice['fdNoEntryFaktur']]!['fdTotalAllocation'];

    setState(() {
      double newAmount = double.tryParse(val.replaceAll(',', '')) ?? 0;
      double prevAmount = newAmount;

      if (newAmount >
          (widget.totalCollection - allocationUsed + currentAllocated)) {
        newAmount = widget.totalCollection - allocationUsed + currentAllocated;
      }

      if (newAmount > invoice['fdNetto']) {
        newAmount = invoice['fdNetto'];
      }

      if (newAmount != prevAmount) {
        txtEdit!.text = param.enNumberFormat.format(newAmount);
      }

      listPiutangPayment[invoice['fdNoEntryFaktur']]!['fdTotalAllocation'] =
          double.tryParse(txtEdit!.text.replaceAll(',', '')) ?? 0.0;
      listPiutangPayment[invoice['fdNoEntryFaktur']]!['selected'] =
          (listPiutangPayment[invoice['fdNoEntryFaktur']]![
                  'fdTotalAllocation'] ==
              invoice['fdNetto']);

      allocationUsed = textInvs.values.fold(0.0, (sum, controller) {
        double val = double.tryParse(controller.text.replaceAll(',', '')) ?? 0;
        return sum + val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print(widget.noentry);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NooInvoicePage(
                      user: widget.user,
                      lgn: widget.lgn,
                      noentry: widget.noentry,
                      navpage: '',
                      isEndDay: widget.isEndDay,
                      startDayDate: widget.startDayDate,
                      endTimeVisit: widget.endTimeVisit,
                      routeName: 'NooInvoicePage',
                      alamatSelected: widget.alamatSelected,
                      orderExist: widget.orderExist,
                      totalPromosiExtra: widget.totalPromosiExtra,
                      totalDiscount: widget.totalDiscount,
                      totalPesanan: widget.totalPesanan,
                      listKeranjang: widget.listKeranjang,
                      noFaktur: widget.noFaktur,
                      txtTanggalKirim: widget.txtTanggalKirim,
                    )));

        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Invoice Payment')),
          body: isLoading
              ? Center(
                  child: loadingProgress(ScaleSize.textScaleFactor(context)))
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
                            '${widget.lgn.fdKodeNoo} - ${widget.lgn.fdNamaToko}',
                            style: css.textHeaderBold())),
                    const Padding(padding: EdgeInsets.all(5)),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Total Tagihan')),
                            const SizedBox(width: 5),
                            const Text(':'),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Rp. ${param.enNumberFormat.format(totalPiutang)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Total Collection')),
                            const SizedBox(width: 5),
                            const Text(':'),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Rp. ${param.enNumberFormat.format(widget.totalCollection)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Available')),
                            const SizedBox(width: 5),
                            const Text(':'),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Rp. ${param.enNumberFormat.format(widget.totalCollection - allocationUsed)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Used')),
                            const SizedBox(width: 5),
                            const Text(':'),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Rp. ${param.enNumberFormat.format(allocationUsed)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 10),
                    // CheckboxListTile(
                    //   title: const Text('Auto Allocate'),
                    //   controlAffinity: ListTileControlAffinity.leading,
                    //   value: autoAllocate,
                    //   onChanged: _toggleAutoAllocate,
                    // ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listPiutangPayment.length,
                        itemBuilder: (context, index) {
                          final invoice =
                              listPiutangPayment.values.elementAt(index);

                          // return ListTile(
                          //   leading: Checkbox(
                          //     value: invoice['selected'],
                          //     onChanged: (value) => _toggleInvoiceSelected(index, value),
                          //   ),
                          //   title: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         TextSpan(
                          //           text: invoice['fdNoFaktur'],
                          //           style: const TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold
                          //           )
                          //         ),
                          //         TextSpan(
                          //           text: '\nTgl: ${param.dtFormatView.format(param.dtFormatDB.parse(invoice['fdTanggalFaktur']))} - '
                          //                 'JT: ${param.dtFormatView.format(param.dtFormatDB.parse(invoice['fdTanggalJT']))}',
                          //           style: const TextStyle(
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //         TextSpan(
                          //           text: '\nNominal: Rp. ${param.enNumberFormat.format(invoice['fdNetto'])}',
                          //           style: const TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold
                          //           )
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          //   subtitle: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       TextField(
                          //         enabled: !invoice['selected'],
                          //         onTap: () {
                          //           final txtEdit = textInvs[invoice['fdNoEntryFaktur']];
                          //           if (txtEdit != null && double.tryParse(txtEdit.text.replaceAll(',', '').replaceAll('.', '')) == 0) {
                          //             setState(() {
                          //               txtEdit.text = '';
                          //             });
                          //           }
                          //         },
                          //         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          //         decoration: const InputDecoration(
                          //             labelText: 'Allocation',
                          //         ),
                          //         controller: textInvs[invoice['fdNoEntryFaktur']],
                          //         inputFormatters: [cother.ThousandsSeparatorAnDecimalInputFormatter()],
                          //         onChanged: (value) => _updateInvoiceAllocation(invoice, value),
                          //       ),
                          //     ],
                          //   ),
                          // );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // ⬅️ biar semua sejajar tengah
                              children: [
                                // Checkbox di kiri
                                Checkbox(
                                  value: invoice['selected'],
                                  onChanged: (value) =>
                                      _toggleInvoiceSelected(index, value),
                                ),

                                // Info faktur (nomor faktur)
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // ⬅️ tinggi secukupnya
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        invoice['fdNoFaktur'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Nominal
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize.min, // ⬅️ ini juga
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rp. ${param.enNumberFormat.format(invoice['fdNetto'])}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // TextField allocation di kanan
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller:
                                        textInvs[invoice['fdNoEntryFaktur']],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d.]')),
                                      cother
                                          .LongThousandsSeparatorAnDecimalInputFormatter(),
                                    ],
                                    decoration: css.textInputStyle(
                                      'Allocation',
                                      const TextStyle(
                                          fontStyle: FontStyle.italic),
                                      'Allocation',
                                      null,
                                      null,
                                    ),
                                    enabled: !invoice['selected'],
                                    onTap: () {
                                      final txtEdit =
                                          textInvs[invoice['fdNoEntryFaktur']];
                                      if (txtEdit != null &&
                                          double.tryParse(txtEdit.text
                                                  .replaceAll(',', '')
                                                  .replaceAll('.', '')) ==
                                              0) {
                                        setState(() {
                                          txtEdit.text = '';
                                        });
                                      }
                                    },
                                    onChanged: (value) => print(0),
                                    // _updateInvoiceAllocation(invoice, value),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: isLoading
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : BottomAppBar(
                    height: 40 * ScaleSize.textScaleFactor(context),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          final listPaymentValid = Map.from(listPiutangPayment)
                            ..removeWhere((key, value) =>
                                (value['fdTotalAllocation'] ?? 0.0) <= 0.0);

                          if (listPaymentValid.isNotEmpty) {
                            _listCollection =
                                await ccoll.getAllCollectionByLangganan(
                                    widget.lgn.fdKodeNoo!);
                            _listCollection = _listCollection.map((e) {
                              e.fdAllocationAmount = 0;
                              return e;
                            }).toList();

                            for (var value in listPaymentValid.values) {
                              value['detailAllocation'] = [];
                              double totalAlloc =
                                  value['fdTotalAllocation'] ?? 0.0;

                              for (var element in _listCollection) {
                                double remainingCollection =
                                    element.fdTotalCollection -
                                        element.fdAllocationAmount;

                                if (remainingCollection > 0) {
                                  double allocation =
                                      totalAlloc <= remainingCollection
                                          ? totalAlloc
                                          : remainingCollection;

                                  if (allocation > 0) {
                                    value['detailAllocation'].add({
                                      'fdIdCollection': element.fdId,
                                      'fdAllocationAmount': allocation,
                                    });

                                    totalAlloc -= allocation;
                                    element.fdAllocationAmount += allocation;

                                    if (totalAlloc == 0) {
                                      break;
                                    }
                                  }
                                }
                              }
                            }
                          }

                          await cpiu.savePaymentBatch(listPaymentValid);

                          setState(() {
                            isLoading = false;
                          });

                          if (!mounted) return;
                          initLoadPage();

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         settings:
                          //             const RouteSettings(name: 'collection'),
                          //         builder: (context) => NooCollectionPage(
                          //               lgn: widget.lgn,
                          //               user: widget.user,
                          //               noentry: widget.noentry,
                          //               navpage: 'collectionallocate',
                          //               routeName: 'collection',
                          //               endTimeVisit: endTimeVisit,
                          //               startDayDate: widget.startDayDate,
                          //               isEndDay: widget.isEndDay,
                          //             ))).then((value) {
                          //   initLoadPage();

                          //   setState(() {});
                          // });
                        } catch (e) {
                          if (!mounted) return;

                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                SnackBar(content: Text('error: $e')));
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
          )),
    );
  }
}
