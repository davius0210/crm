import 'dart:io';
import 'package:flutter/material.dart';
import 'main.dart';
import 'previewphoto_page.dart';
import 'package:group_button/group_button.dart';
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/other_cont.dart' as cother;
import 'controller/camera.dart' as ccam;
import 'package:path/path.dart' as cpath;
import 'models/globalparam.dart' as param;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/barang.dart' as mbrg;
import 'models/piutang.dart' as mpiu;
import 'style/css.dart' as css;

class PaymentPage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String noentry;
  final String startDayDate;
  final String endTimeVisit;

  const PaymentPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.noentry,
      required this.startDayDate,
      required this.endTimeVisit,
      required this.routeName});

  @override
  State<PaymentPage> createState() => LayerPaymentPage();
}

class LayerPaymentPage extends State<PaymentPage> {
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
  double totalPenjualan = 0;
  double totalTagihan = 0;
  double totalJumlah = 0;
  double totalBayar = 0;
  double totalDiscount = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

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
        isLoadingImg1 = true;
        totalPenjualan = 0;
        totalDPP = 0;
        totalPPN = 0;
        totalDiscount = 0;
        totalTagihan = 0;
        totalBayar = 0;
        sisaTagihan = 0;
      });
      getImageFromDevice();
      listPiutang = await cpiu.getAllPiutang(widget.lgn.fdKodeLangganan!);

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

  void getImageFromDevice() async {
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
                    await deleteImage(imgPath, index);

                    if (!mounted) return;

                    Navigator.pop(context);

                    setState(() {
                      switch (index) {
                        case 1:
                          isImgExist1 = false;
                          break;
                        case 2:
                          isImgExist2 = false;
                          break;
                        case 3:
                          isImgExist3 = false;
                          break;
                        default:
                          break;
                      }
                    });

                    initLoadPage();
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
      onWillPop: () async {
        if (isImgExist1 || isImgExist2 || isImgExist3) {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Container(
                      color: css.titleDialogColor(),
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                          'Foto akan terhapus jika belum klik simpan. Lanjut kembali?')),
                  titlePadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            isDataExists = await cpiu
                                .isExistbyfdNoEntryFaktur(widget.noentry);
                            if (!isDataExists) {
                              String dirCameraPath =
                                  '${param.appDir}/${param.imgPath}/${widget.user.fdKodeSF}/${widget.lgn.fdKodeLangganan}';
                              var dir = Directory(dirCameraPath);

                              if (await dir.exists()) {
                                var listFile = dir.listSync(recursive: true);
                                var listFileFiltered =
                                    listFile.where((element) {
                                  String fileName =
                                      cpath.basename(element.path);

                                  if (fileName.startsWith(
                                      '${param.invPre}_$fdNoEntryFaktur', 0)) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                }).toList();

                                for (var element in listFileFiltered) {
                                  File(element.path).deleteSync();
                                }
                              }
                              setState(() {
                                isSave = true;
                              });
                            }
                            if (!mounted) return;
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $e')));
                          }
                        },
                        child: const Text('Ya')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          // Navigator.pop(context);
                        },
                        child: const Text('Tidak'))
                  ],
                );
              });

          return value == true;
        } else {
          return true;
        }
      },
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
                                  Text('Order ID / Invoice ID :',
                                      softWrap: true),
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
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('List Item', softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('[Produk]', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('[Qty]', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('[Total (Rp)]', softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (var item in listPiutang) ...[
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
                                        '${param.idNumberFormat.format(item.fdQty)} ${item.fdSatuan.toString()} x Rp. ${param.idNumberFormat.format(item.fdUnitPricePPN)}',
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
                                        param.idNumberFormat.format(
                                            item.fdQty * item.fdUnitPricePPN),
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
                        padding: EdgeInsets.all(8),
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
                                          param.idNumberFormat
                                              .format(totalPenjualan),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                          param.idNumberFormat
                                              .format(totalDiscount),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                  totalDPP == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormat.format(totalDPP),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                          param.idNumberFormat.format(totalPPN),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                          param.idNumberFormat
                                              .format(totalTagihan),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                  totalBayar == 0
                                      ? const Text('0')
                                      : Text(
                                          param.idNumberFormat
                                              .format(totalBayar),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
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
                                          param.idNumberFormat
                                              .format(sisaTagihan),
                                          softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Foto Bukti Transfer :', softWrap: true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isImgExist1
                                      ? SizedBox(
                                          height: 130,
                                          width: 100,
                                          child: getImage(selloutImg1, 1))
                                      : widget.endTimeVisit.isEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isLoadingImg1 = true;
                                                });
                                                ccam
                                                    .pickCamera(
                                                        context,
                                                        widget.user.fdToken,
                                                        'Take Photo',
                                                        selloutImg1,
                                                        widget.routeName,
                                                        false)
                                                    .then((value) {
                                                  initLoadPage();

                                                  setState(() {});
                                                });
                                              },
                                              icon: isLoadingImg1
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : Icon(
                                                      Icons
                                                          .photo_camera_rounded,
                                                      size: 36 *
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context),
                                                      color: Colors.orange,
                                                      semanticLabel: 'Foto'),
                                              tooltip: 'Take photo')
                                          : IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                  Icons.no_photography_rounded,
                                                  size: 36 *
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                  color: Colors.redAccent,
                                                  semanticLabel: 'Foto'),
                                              tooltip: 'No Take photo'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isImgExist2
                                      ? SizedBox(
                                          height: 130,
                                          width: 100,
                                          child: getImage(selloutImg2, 2))
                                      : widget.endTimeVisit.isEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isLoadingImg2 = true;
                                                });
                                                ccam
                                                    .pickCamera(
                                                        context,
                                                        widget.user.fdToken,
                                                        'Take Photo',
                                                        selloutImg2,
                                                        widget.routeName,
                                                        false)
                                                    .then((value) {
                                                  initLoadPage();

                                                  setState(() {});
                                                });
                                              },
                                              icon: isLoadingImg2
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : Icon(
                                                      Icons
                                                          .photo_camera_rounded,
                                                      size: 36 *
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context),
                                                      color: Colors.orange,
                                                      semanticLabel: 'Foto'),
                                              tooltip: 'Take photo')
                                          : IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                  Icons.no_photography_rounded,
                                                  size: 36 *
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                  color: Colors.redAccent,
                                                  semanticLabel: 'Foto'),
                                              tooltip: 'No Take photo'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isImgExist3
                                      ? SizedBox(
                                          height: 130,
                                          width: 100,
                                          child: getImage(selloutImg3, 3))
                                      : widget.endTimeVisit.isEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isLoadingImg3 = true;
                                                });
                                                ccam
                                                    .pickCamera(
                                                        context,
                                                        widget.user.fdToken,
                                                        'Take Photo',
                                                        selloutImg3,
                                                        widget.routeName,
                                                        false)
                                                    .then((value) {
                                                  initLoadPage();

                                                  setState(() {});
                                                });
                                              },
                                              icon: isLoadingImg3
                                                  ? loadingProgress(
                                                      ScaleSize.textScaleFactor(
                                                          context))
                                                  : Icon(
                                                      Icons
                                                          .photo_camera_rounded,
                                                      size: 36 *
                                                          ScaleSize
                                                              .textScaleFactor(
                                                                  context),
                                                      color: Colors.orange,
                                                      semanticLabel: 'Foto'),
                                              tooltip: 'Take photo')
                                          : IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                  Icons.no_photography_rounded,
                                                  size: 36 *
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                  color: Colors.redAccent,
                                                  semanticLabel: 'Foto'),
                                              tooltip: 'No Take photo'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))),
        bottomNavigationBar: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : widget.endTimeVisit.isEmpty
                ? (Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: BottomAppBar(
                      height: 40 * ScaleSize.textScaleFactor(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                if (formInputKey.currentState!.validate()) {
                                  bool isDateTimeSettingValid =
                                      await cother.dateTimeSettingValidation();

                                  if (isDateTimeSettingValid) {
                                    await updatePiutang();

                                    if (!mounted) return;

                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    )))
                : null,
      ),
    );
  }
}
