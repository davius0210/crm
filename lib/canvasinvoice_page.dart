import 'dart:io';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'collection_page.dart';
import 'collectionallocate_page.dart';
import 'canvas_page.dart';
import 'piutang_page.dart';
import 'previewphoto_page.dart';
import 'package:group_button/group_button.dart';
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/collection_cont.dart' as ccoll;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/log_cont.dart' as clog;
import 'models/globalparam.dart' as param;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/piutang.dart' as mpiu;
import 'models/collection.dart' as mcoll;
import 'style/css.dart' as css;

class CanvasInvoicePage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String noentry;
  final String navpage;
  final bool isEndDay;
  final String startDayDate;
  final String endTimeVisit;
  final String? alamatSelected;
  final double orderExist;
  final double totalPromosiExtra;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;
  final String noFaktur;
  final String txtTanggalKirim;

  const CanvasInvoicePage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.noentry,
      required this.navpage,
      required this.isEndDay,
      required this.startDayDate,
      required this.endTimeVisit,
      required this.routeName,
      required this.alamatSelected,
      required this.orderExist,
      required this.totalPromosiExtra,
      required this.totalDiscount,
      required this.totalPesanan,
      required this.listKeranjang,
      required this.noFaktur,
      required this.txtTanggalKirim});

  @override
  State<CanvasInvoicePage> createState() => LayerCanvasInvoicePage();
}

class LayerCanvasInvoicePage extends State<CanvasInvoicePage> {
  bool isLoading = false;
  bool isLoadingImg1 = true;
  bool isLoadingImg2 = true;
  bool isLoadingImg3 = true;
  bool isGudang = false;
  bool isKomputer = false;
  String selloutImg1 = '';
  String selloutImg2 = '';
  String selloutImg3 = '';
  bool isSave = false;
  bool isDataExists = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.white;
  }

  List<mbrg.Barang> barangs = [];
  List<mpiu.Piutang> listPiutang = [];
  List<mpiu.Piutang> listPiutangPromosi = [];
  List<mpiu.Piutang> listPiutangJoinItem = [];
  List<mcoll.CollectionDetail> _listCollection = [];
  final txtOpsi = GroupButtonController();
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  TextEditingController txtStockDC = TextEditingController();
  TextEditingController txtStdPiutang = TextEditingController();
  TextEditingController txtStockPajang = TextEditingController();
  TextEditingController txtStockGudang = TextEditingController();
  TextEditingController txtStockKomputer = TextEditingController();
  TextEditingController txtRootCause = TextEditingController();
  TextEditingController txtKeteranganRoot = TextEditingController();
  Map<String, TextEditingController> textEditingControllers = {};
  bool isImgExist1 = false;
  bool isImgExist2 = false;
  bool isImgExist3 = false;
  bool isEdit = false;
  String stringID = '';
  String kodeTransaksiFP = '';
  String tglOrder = '';
  String tglKirim = '';
  String tglInvoice = '';
  String tglJatuhTempo = '';
  String fdNoFaktur = '';
  String fdNoEntryFaktur = '';
  int stateIsGudang = 0;
  int stateIsKomputer = 0;
  int stdPiutang = 0;
  int ppn = 0;
  int top = 0;
  double totalPenjualan = 0;
  double totalTagihan = 0;
  double totalJumlah = 0;
  double totalBayar = 0;
  double totalBayarNow = 0;
  double totalDiscount = 0;
  double totalDPP = 0;
  double totalPembalikanDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;
  double totalCollection = 0;
  double collectionUsed = 0;
  double totalCash = 0;
  double totalTransfer = 0;
  double totalGiro = 0;
  double totalCheque = 0;
  double totalAllPayment = 0;
  double totalNetto = 0;
  double totalBruto = 0;
  double totalBulatDisc = 0;
  double decimalDPP = 0;
  double tagihanSudahBayar = 0;

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
        isLoadingImg1 = true;
        totalPenjualan = 0;
        totalDPP = 0;
        totalPPN = 0;
        totalDiscount = 0;
        totalTagihan = 0;
        totalBayar = 0;
        totalBayarNow = 0;
        sisaTagihan = 0;
        totalCash = 0;
        totalTransfer = 0;
        totalGiro = 0;
        totalCheque = 0;
        ppn = 0;
        totalNetto = 0;
      });
      await getImageFromDevice();

      final lparam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      ppn = lparam[0].fdPPN + 100;
      // listPiutang = await cpiu.getDataByNoEntry(widget.noentry);
      totalBayarNow = await ccoll.getTotalBayarByNoFaktur(widget.noentry);
      listPiutang = await cpiu.getFakturByNoEntry(widget.noentry);
      listPiutangJoinItem = [];
      listPiutangPromosi = [];
      if (listPiutang.isNotEmpty) {
        for (var item in listPiutang) {
          if (item.fdPromosi == '1') {
            listPiutangPromosi.add(item);
          }
        }

        for (var item in listPiutang) {
          if (item.fdPromosi != '1') {
            // CARI BARANG PROMOSI DENGAN KODE BARANG SAMA
            var promosiItem = listPiutangPromosi
                .where((p) => p.fdKodeBarang == item.fdKodeBarang)
                .toList();

            double extraQtyK = 0;
            double totalQtyK = 0;
            double totalQty = 0;
            double hitungDiskon = 0;
            double brutoPromosi = 0;
            String fdJenisSatuan = '';
            String fdSatuan = '';

            if (promosiItem.isNotEmpty) {
              extraQtyK = promosiItem.fold(0, (sum, p) => sum + (p.fdQtyK));
              totalQtyK = item.fdQtyK + extraQtyK;
              brutoPromosi =
                  promosiItem.fold(0, (sum, p) => sum + (p.fdBrutto));
              //SESUAI CETAKAN FAKTUR GENAP KE LSN
              if (totalQtyK % 12 == 0) {
                hitungDiskon =
                    (promosiItem[0].fdHargaAsli * promosiItem[0].fdQtyK) +
                        item.fdDiscount;
                totalQty = totalQtyK / 12;
                fdJenisSatuan = '1';
                fdSatuan = 'LSN';
              } else {
                hitungDiskon = item.fdDiscount;
                totalQty = totalQtyK;
                fdJenisSatuan = '0';
                fdSatuan = 'PCS';
              }

              listPiutangJoinItem.add(mpiu.Piutang(
                  fdNoEntryFaktur: item.fdNoEntryFaktur,
                  fdNoFaktur: item.fdNoFaktur,
                  fdNoOrder: item.fdNoOrder,
                  fdTipePiutang: '',
                  fdDepo: item.fdDepo,
                  fdTanggalJT: item.fdTanggalJT,
                  fdKodeLangganan: item.fdKodeLangganan,
                  fdTanggalFaktur: item.fdTanggalFaktur,
                  fdTanggalOrder: item.fdTanggalOrder,
                  fdTanggalKirim: item.fdTanggalKirim,
                  fdKodeTransaksiFP: item.fdKodeTransaksiFP,
                  fdKodeBarang: item.fdKodeBarang,
                  fdNamaBarang: item.fdNamaBarang,
                  fdJenisSatuan: fdJenisSatuan,
                  fdSatuan: fdSatuan,
                  fdQty: totalQty,
                  fdQtyK: totalQtyK,
                  fdHargaAsli: item.fdHargaAsli,
                  fdUnitPrice: item.fdUnitPrice,
                  fdUnitPriceK: item.fdUnitPriceK,
                  fdUnitPricePPN: item.fdUnitPricePPN,
                  fdBrutto: item.fdBrutto,
                  fdBruttopromosi: item.fdBrutto + brutoPromosi,
                  fdDiscount: hitungDiskon,
                  fdDPP: item.fdDPP,
                  fdPPN: item.fdPPN,
                  fdBayar: item.fdBayar,
                  fdPromosi: item.fdPromosi,
                  fdGiro: 0,
                  fdGiroTolak: 0,
                  fdKodeStatus: 0,
                  fdLastUpdate: '',
                  fdTglStatus: '',
                  fdStatusRecord: 0,
                  fdNoUrutFaktur: item.fdNoUrutFaktur,
                  fdNoEntrySJ: item.fdNoEntryFaktur,
                  fdNoUrutSJ: item.fdNoUrutFaktur,
                  fdReplacement: '',
                  fdNetto: item.fdNetto,
                  fdLimitKredit: item.fdLimitKredit,
                  fdNoEntryOrder: item.fdNoEntryFaktur,
                  fdStatusSent: 0));
            } else {
              listPiutangJoinItem.add(mpiu.Piutang(
                  fdNoEntryFaktur: item.fdNoEntryFaktur,
                  fdNoFaktur: item.fdNoFaktur,
                  fdNoOrder: item.fdNoOrder,
                  fdTipePiutang: '',
                  fdDepo: item.fdDepo,
                  fdTanggalJT: item.fdTanggalJT,
                  fdKodeLangganan: item.fdKodeLangganan,
                  fdTanggalFaktur: item.fdTanggalFaktur,
                  fdTanggalOrder: item.fdTanggalOrder,
                  fdTanggalKirim: item.fdTanggalKirim,
                  fdKodeTransaksiFP: item.fdKodeTransaksiFP,
                  fdKodeBarang: item.fdKodeBarang,
                  fdNamaBarang: item.fdNamaBarang,
                  fdJenisSatuan: item.fdJenisSatuan,
                  fdSatuan: item.fdSatuan,
                  fdQty: item.fdQty,
                  fdQtyK: item.fdQtyK,
                  fdHargaAsli: item.fdHargaAsli,
                  fdUnitPrice: item.fdUnitPrice,
                  fdUnitPriceK: item.fdUnitPriceK,
                  fdUnitPricePPN: item.fdUnitPricePPN,
                  fdBrutto: item.fdBrutto,
                  fdBruttopromosi: item.fdBrutto,
                  fdDiscount: item.fdDiscount,
                  fdDPP: item.fdDPP,
                  fdPPN: item.fdPPN,
                  fdBayar: item.fdBayar,
                  fdPromosi: item.fdPromosi,
                  fdGiro: 0,
                  fdGiroTolak: 0,
                  fdKodeStatus: 0,
                  fdLastUpdate: '',
                  fdTglStatus: '',
                  fdStatusRecord: 0,
                  fdNoUrutFaktur: item.fdNoUrutFaktur,
                  fdNoEntrySJ: item.fdNoEntryFaktur,
                  fdNoUrutSJ: item.fdNoUrutFaktur,
                  fdReplacement: '',
                  fdNetto: item.fdNetto,
                  fdLimitKredit: item.fdLimitKredit,
                  fdNoEntryOrder: item.fdNoEntryFaktur,
                  fdStatusSent: 0));
            }
          }
        }

        for (var element in listPiutangJoinItem) {
          fdNoFaktur = element.fdNoFaktur.toString();
          fdNoEntryFaktur = element.fdNoEntryFaktur.toString();
          stringID = element.fdNoFaktur.toString();
          // '${element.fdNoOrder.toString()} / ${element.fdNoFaktur.toString()}';
          kodeTransaksiFP = element.fdKodeTransaksiFP.toString();
          tglOrder = element.fdTanggalOrder!.isNotEmpty
              ? param.dtFormatDB
                  .format(DateTime.parse(element.fdTanggalOrder.toString()))
              : param.dtFormatDB
                  .format(DateTime.parse(element.fdTanggalFaktur.toString()));
          tglKirim = element.fdTanggalKirim!.isNotEmpty
              ? param.dtFormatDB
                  .format(DateTime.parse(element.fdTanggalKirim.toString()))
              : param.dtFormatViewMMM
                  .format(DateTime.parse(element.fdTanggalFaktur.toString()));
          tglInvoice = param.dtFormatDB
              .format(DateTime.parse(element.fdTanggalFaktur.toString()));
          // if (element.fdTanggalJT == null || element.fdTanggalJT == '') {
          //   tglJatuhTempo = '';
          // } else {
          //   tglJatuhTempo = param.dtFormatDB
          //       .format(DateTime.parse(element.fdTanggalJT.toString()));
          // }
          // tglJatuhTempo = '';
          totalPenjualan += element.fdQty * element.fdHargaAsli;
          // element.fdUnitPricePPN;
          totalBayar += element.fdBayar;
          if (element.fdPromosi != '1') {
            totalDPP += element.fdDPP;
            totalPPN += element.fdPPN;
          }
          // totalPPN +=
          //     (totalPenjualan * ppn / 100) - totalPenjualan; //element.fdPPN;
          totalNetto += element.fdNetto;
          totalBruto += element.fdBrutto;
          decimalDPP = element.fdQty * element.fdHargaAsli;
          // totalBulatDisc += decimalDPP - element.fdDPP;

          if (element.fdPromosi == '0') {
            totalDiscount += element.fdDiscount;
            totalBulatDisc += double.parse(
                ((element.fdBruttopromosi / (ppn / 100)) - element.fdDPP)
                    .toStringAsFixed(2));
          } else {
            totalDiscount += element.fdHargaAsli * element.fdQty;
            totalBulatDisc += element.fdDPP;
          }

          // print('dpp ${element.fdDPP}');
          // print('ppn ${element.fdPPN}');
          // print('ppn hit ${(totalPenjualan * ppn / 100) - totalPenjualan}');
          // print('disc ${element.fdDiscount}');
          // print('bulat disc  $decimalDPP');
        }
        // print('t bulat disc $totalBulatDisc');
        // print('t netto 1 $totalNetto');
        // print('t bruto 1 $totalBruto');
        totalPPN = totalPPN.floorToDouble();
        totalPembalikanDPP = totalPPN * 100 / 12;
        // print('t disc $totalDiscount');
        totalDiscount = double.parse(totalBulatDisc.toStringAsFixed(2));
        totalNetto = totalPenjualan - totalDiscount;

        // print('t netto ${totalNetto.floorToDouble()}');
        // totalDPP = totalPenjualan - totalDiscount;
        // totalDPP = totalNetto / (ppn / 100);
        // print('t dpp $totalDPP');
        // print('t dpp $totalPembalikanDPP');
        // totalPPN = totalNetto - totalDPP;
        // print('t ppn $totalPPN');
        if (kodeTransaksiFP == '07') {
          // totalTagihan = totalDPP;
          totalTagihan = totalNetto;
        } else {
          // totalTagihan = totalDPP + totalPPN;
          totalTagihan = totalNetto + totalPPN;
        }
        sisaTagihan = totalTagihan - totalBayar - totalBayarNow;
        tagihanSudahBayar = totalBayar + totalBayarNow;
      }
      _listCollection =
          await ccoll.getAllCollectionByLangganan(widget.lgn.fdKodeLangganan!);
      // _listCollection =
      //     await ccoll.getAllCollectionByNoEntryFaktur(widget.noentry);
      totalCollection =
          _listCollection.fold(0, (sum, item) => sum + item.fdTotalCollection);

      top = await clgn.getJatuhTempo(widget.noentry);
      DateTime today = DateTime.now();
      DateTime tglJT = today.add(Duration(days: top));
      if (top == 0) {
        if (tglJatuhTempo.isEmpty) {
          tglJatuhTempo = tglInvoice;
        }
      } else {
        tglJatuhTempo =
            param.dtFormatViewMMM.format(DateTime.parse(tglJT.toString()));
      }

      totalCash = await ccoll.getCollectionByTipe(
          'Tunai', widget.lgn.fdKodeLangganan!, widget.noentry);
      totalTransfer = await ccoll.getCollectionByTipe(
          'Transfer', widget.lgn.fdKodeLangganan!, widget.noentry);
      totalGiro = await ccoll.getCollectionByTipe(
          'Giro', widget.lgn.fdKodeLangganan!, widget.noentry);
      totalCheque = await ccoll.getCollectionByTipe(
          'Cheque', widget.lgn.fdKodeLangganan!, widget.noentry);
      totalAllPayment = totalCash + totalTransfer + totalGiro + totalCheque;
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

  Future<void> getImageFromDevice() async {
    setState(() {
      selloutImg1 =
          '${param.appDir}/${param.imgPath}/${param.buktiTransferImgName(1, widget.user.fdKodeSF, widget.lgn.fdKodeLangganan!, widget.noentry, widget.startDayDate)}';
      selloutImg2 =
          '${param.appDir}/${param.imgPath}/${param.buktiTransferImgName(2, widget.user.fdKodeSF, widget.lgn.fdKodeLangganan!, widget.noentry, widget.startDayDate)}';
      selloutImg3 =
          '${param.appDir}/${param.imgPath}/${param.buktiTransferImgName(3, widget.user.fdKodeSF, widget.lgn.fdKodeLangganan!, widget.noentry, widget.startDayDate)}';
    });

    File(selloutImg1).exists().then((value) {
      setState(() {
        isImgExist1 = value;
        isLoadingImg1 = false;
      });
    });

    File(selloutImg2).exists().then((value) {
      setState(() {
        isImgExist2 = value;
        isLoadingImg2 = false;
      });
    });

    File(selloutImg3).exists().then((value) {
      setState(() {
        isImgExist3 = value;
        isLoadingImg3 = false;
      });
    });
  }

  Future<void> updatePiutang() async {
    int rowResult = 0;
    try {
      setState(() {
        isLoading = true;
      });

      if (isImgExist1) {
        await cpiu.updateFotoBuktiTransfer(
            widget.user.fdKodeDepo,
            widget.lgn.fdKodeLangganan,
            selloutImg1,
            widget.startDayDate,
            widget.noentry,
            fdNoEntryFaktur,
            fdNoFaktur,
            1);
      }
      if (isImgExist2) {
        await cpiu.updateFotoBuktiTransfer(
            widget.user.fdKodeDepo,
            widget.lgn.fdKodeLangganan,
            selloutImg2,
            widget.startDayDate,
            widget.noentry,
            fdNoEntryFaktur,
            fdNoFaktur,
            2);
      }
      if (isImgExist3) {
        await cpiu.updateFotoBuktiTransfer(
            widget.user.fdKodeDepo,
            widget.lgn.fdKodeLangganan,
            selloutImg3,
            widget.startDayDate,
            widget.noentry,
            fdNoEntryFaktur,
            fdNoFaktur,
            3);
      }

      if (rowResult == 1) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Sukses edit data')));
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
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Widget getImage(String imgPath, int index) {
    return !isSave && File(imgPath).existsSync()
        ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewPictureScreen(
                          imgBytes: File(imgPath).readAsBytesSync())));
            },
            child: Stack(
              children: [
                FadeInImage(
                    placeholder:
                        const AssetImage('assets/images/transparent.png'),
                    placeholderFit: BoxFit.scaleDown,
                    image: MemoryImage(File(imgPath).readAsBytesSync()),
                    fit: BoxFit.fitHeight,
                    width: 100,
                    height: 100),
                isEdit
                    ? const Padding(padding: EdgeInsets.all(0))
                    : Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.cancel_rounded,
                              size: 24 * ScaleSize.textScaleFactor(context)),
                          color: Colors.red,
                          tooltip: 'Delete',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            yesNoDialogForm(imgPath, index);
                          },
                        )),
              ],
            ))
        : IconButton(
            icon: Icon(Icons.border_clear,
                color: Colors.grey[600],
                size: 30 * ScaleSize.textScaleFactor(context)),
            tooltip: '',
            onPressed: () {
              // getFilePath(fileName);
              // ccam
              //     .pickCamera(context, widget.user.fdToken, ' ', tkluarImgName1,
              //         widget.routeName, true)
              //     .then((value) {
              //   initLoadPage();

              //   setState(() {});
              // });
            },
          );
  }

  void yesNoDialogForm(String imgPath, int index) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus?',
        onOk: () async {
          try {
            // 1. Proses hapus file gambar
            await deleteImage(imgPath, index);

            // 2. Safety check context
            if (!mounted) return;

            // 3. Tutup dialog terlebih dahulu
            Navigator.pop(context);

            // 4. Update state boolean keberadaan gambar
            setState(() {
              if (index == 1) isImgExist1 = false;
              else if (index == 2) isImgExist2 = false;
              else if (index == 3) isImgExist3 = false;
            });

            // 5. Refresh data atau halaman
            initLoadPage();
            
          } catch (e) {
            // Tampilkan pesan jika error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('error: $e')),
            );
          }
        },
      ),
    );
  }

  Future<void> deleteImage(String filePath, int index) async {
    await File(filePath).exists().then((isExist) {
      if (isExist) {
        File(filePath).delete();
      }
    });
  }

  Widget loadingProgress(double scaleFactor) {
    return SizedBox(
      width: 24 * scaleFactor,
      height: 24 * scaleFactor,
      child: const CircularProgressIndicator(),
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
                      settings: const RouteSettings(name: 'CanvasPage'),
                      builder: (context) => CanvasOrderPage(
                          lgn: widget.lgn,
                          user: widget.user,
                          isEndDay: widget.isEndDay,
                          routeName: 'CanvasPage',
                          endTimeVisit: widget.endTimeVisit,
                          startDayDate: widget.startDayDate))).then((value) {
                initLoadPage();

                setState(() {});
              });

              return false;
            }
          : () async => false,
      // onWillPop: !isLoading
      //     ? () async {
      //         // Navigator.push(
      //         //     context,
      //         //     MaterialPageRoute(
      //         //         builder: (context) => PiutangPage(
      //         //             user: widget.user,
      //         //             lgn: widget.lgn,
      //         //             isEndDay: widget.isEndDay,
      //         //             startDayDate: widget.startDayDate,
      //         //             // endTimeVisit: widget.endTimeVisit,
      //         //             routeName: 'PiutangEdit')));

      //         return false;
      //       }
      //     : () async => false,
      // onWillPop: () async {
      // if (isImgExist1 || isImgExist2 || isImgExist3) {
      //   final value = await showDialog<bool>(
      //       context: context,
      //       builder: (context) {
      //         return SimpleDialog(
      //           title: Container(
      //               color: css.titleDialogColor(),
      //               padding: const EdgeInsets.all(5),
      //               child: const Text(
      //                   'Foto akan terhapus jika belum klik simpan. Lanjut kembali?')),
      //           titlePadding: EdgeInsets.zero,
      //           contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      //           children: [
      //             ElevatedButton(
      //                 onPressed: () async {
      //                   try {
      //                     isDataExists = await cpiu
      //                         .isExistbyfdNoEntryFaktur(widget.noentry);
      //                     if (!isDataExists) {
      //                       String dirCameraPath =
      //                           '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}/${widget.lgn.fdKodeNoo}';
      //                       var dir = Directory(dirCameraPath);

      //                       if (await dir.exists()) {
      //                         var listFile = dir.listSync(recursive: true);
      //                         var listFileFiltered =
      //                             listFile.where((element) {
      //                           String fileName =
      //                               cpath.basename(element.path);

      //                           if (fileName.startsWith(
      //                               '${param.invPre}_$fdNoEntryFaktur', 0)) {
      //                             return true;
      //                           } else {
      //                             return false;
      //                           }
      //                         }).toList();

      //                         for (var element in listFileFiltered) {
      //                           File(element.path).deleteSync();
      //                         }
      //                       }
      //                       setState(() {
      //                         isSave = true;
      //                       });
      //                     }
      //                     if (!mounted) return;
      //                     Navigator.of(context).pop(true);
      //                   } catch (e) {
      //                     ScaffoldMessenger.of(context).showSnackBar(
      //                         SnackBar(content: Text('error: $e')));
      //                   }
      //                 },
      //                 child: const Text('Ya')),
      //             ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop(false);
      //                   // Navigator.pop(context);
      //                 },
      //                 child: const Text('Tidak'))
      //           ],
      //         );
      //       });

      //   return value == true;
      // } else {
      //   return true;
      // }
      // },
      // onWillPop: () async {
      //   return true;
      // },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Tagihan'),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Form(
                key: formInputKey,
                child: Column(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Invoice ID :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(stringID, softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Order :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tglOrder, softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Pengiriman :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tglKirim, softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Invoice :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tglInvoice, softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Jatuh Tempo :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tglJatuhTempo, softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          color: Colors.orange,
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Produk',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total (Rp)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      for (var item in listPiutangJoinItem) ...[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${item.fdKodeBarang!} \n${item.fdNamaBarang!}',
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${param.idNumberFormat.format(item.fdQty)} ${item.fdSatuan.toString()} x Rp. ${param.idNumberFormat.format(item.fdHargaAsli)}',
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        param.idNumberFormatDec.format(
                                            item.fdQty * item.fdHargaAsli),
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jumlah Penjualan', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalPenjualan == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(totalPenjualan),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Potongan', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalDiscount == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(totalDiscount),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DPP', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalPembalikanDPP == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(totalPembalikanDPP),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('PPN', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalPPN == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(totalPPN),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jumlah', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalTagihan == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(totalTagihan),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tagihan Sudah Dibayar', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  tagihanSudahBayar == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(tagihanSudahBayar),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sisa Tagihan', softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  sisaTagihan == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormatDec
                                              .format(sisaTagihan),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text('Invoice Payment',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 2, color: Colors.orange),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cash', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalCash == 0
                                      ? const Text('0')
                                      : Text(
                                          'Rp. ${param.enNumberFormat.format(totalCash)}',
                                          softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transfer', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalTransfer == 0
                                      ? const Text('0')
                                      : Text(
                                          'Rp. ${param.enNumberFormat.format(totalTransfer)}',
                                          softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Giro', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalGiro == 0
                                      ? const Text('0')
                                      : Text(
                                          'Rp. ${param.enNumberFormat.format(totalGiro)}',
                                          softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cheque', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  totalCheque == 0
                                      ? const Text('0')
                                      : Text(
                                          'Rp. ${param.enNumberFormat.format(totalCheque)}',
                                          softWrap: true),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(' ', softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Column(
                        children: [
                          Text(''),
                          SizedBox(height: 50),
                        ],
                      ),
                    ]))),
        floatingActionButton: isLoading
            ? const Padding(padding: EdgeInsets.zero)
            :
            // widget.endTimeVisit.isEmpty ?
            sisaTagihan > totalAllPayment
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'fab_inv_payment',
                        tooltip: 'Invoice Payment',
                        backgroundColor: Colors.green,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: const RouteSettings(
                                      name: 'CollectionAllocationPage'),
                                  builder: (context) =>
                                      CollectionAllocationPage(
                                          lgn: widget.lgn,
                                          user: widget.user,
                                          routeName: 'CollectionAllocationPage',
                                          navpage: widget.navpage,
                                          noentry: widget.noentry,
                                          startDayDate: widget.startDayDate,
                                          endTimeVisit: widget.endTimeVisit,
                                          isEndDay: widget.isEndDay,
                                          totalCollection: totalCollection,
                                          alamatSelected: widget.alamatSelected,
                                          orderExist: widget.orderExist,
                                          totalPromosiExtra:
                                              widget.totalPromosiExtra,
                                          totalDiscount: widget.totalDiscount,
                                          totalPesanan: widget.totalPesanan,
                                          listKeranjang: widget.listKeranjang,
                                          noFaktur: widget.noFaktur,
                                          txtTanggalKirim: widget
                                              .txtTanggalKirim))).then((value) {
                            initLoadPage();

                            setState(() {});
                          });
                        },
                        child: Icon(Icons.receipt_long_rounded,
                            size: 24 * ScaleSize.textScaleFactor(context)),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      FloatingActionButton(
                        heroTag: 'fab_collection',
                        tooltip: 'Collection',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: const RouteSettings(
                                      name: 'CollectionPage'),
                                  builder: (context) => CollectionPage(
                                      lgn: widget.lgn,
                                      user: widget.user,
                                      routeName: 'CollectionPage',
                                      noentry: widget.noentry,
                                      navpage: widget.navpage, //'piutangedit',
                                      isEndDay: widget.isEndDay,
                                      endTimeVisit: widget.endTimeVisit,
                                      startDayDate: widget.startDayDate,
                                      alamatSelected: widget.alamatSelected,
                                      orderExist: widget.orderExist,
                                      totalPromosiExtra:
                                          widget.totalPromosiExtra,
                                      totalDiscount: widget.totalDiscount,
                                      totalPesanan: widget.totalPesanan,
                                      listKeranjang: widget.listKeranjang,
                                      noFaktur: widget.noFaktur,
                                      txtTanggalKirim: widget
                                          .txtTanggalKirim))).then((value) {
                            initLoadPage();

                            setState(() {});
                          });
                        },
                        child: Icon(Icons.paid_rounded,
                            size: 24 * ScaleSize.textScaleFactor(context)),
                      ),
                    ],
                  )
                : const Padding(padding: EdgeInsets.zero),
        // : null,
        ////// REMARK bottomNavigationBar
        // bottomNavigationBar: isLoading
        //     ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
        //     : widget.endTimeVisit.isEmpty
        //         ? (Padding(
        //             padding: MediaQuery.of(context).viewInsets,
        //             child: BottomAppBar(
        //               height: 40 * ScaleSize.textScaleFactor(context),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   Expanded(
        //                     child: TextButton(
        //                       onPressed: () async {
        //                         if (formInputKey.currentState!.validate()) {
        //                           bool isDateTimeSettingValid =
        //                               await cother.dateTimeSettingValidation();

        //                           if (isDateTimeSettingValid) {
        //                             await updatePiutang();

        //                             if (!mounted) return;

        //                             Navigator.pop(context);
        //                           }
        //                         }
        //                       },
        //                       child: const Text('Save'),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )))
        // : null,
      ),
    );
  }
}
