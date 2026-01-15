// Belum selesai:
// 1. Penarikan daftar Bank dari DB, penurunan data ke Server
// 2. Tampilan dan inputan Bank belum sesuai dengan URD karena masih manual list bukan dari DB
// 3. Related dengan page collectionedit_page, collectionallocate_page
// 4. Icon collection masih di customer page, perlu dipindah ke invoice sesuai URD

import 'dart:io';
import 'package:crm_apps/new/helper/function_helper.dart';

import 'previewphoto_page.dart';
import 'noo_collection_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'main.dart';
import 'controller/collection_cont.dart' as ccoll;
import 'controller/other_cont.dart' as cother;
import 'controller/camera.dart' as ccam;
import 'controller/order_cont.dart' as codr;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/stock_cont.dart' as cstk;
import 'controller/langganan_cont.dart' as clgn;
import 'controller/log_cont.dart' as clog;
import 'controller/noo_cont.dart' as cnoo;
import 'models/langganan.dart' as mlgn;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/collection.dart' as mcoll;
import 'models/order.dart' as modr;
import 'models/piutang.dart' as mpiu;
import 'models/stock.dart' as mstk;
import 'models/globalparam.dart' as param;
import 'style/css.dart' as css;

class NooCollectionEditPage extends StatefulWidget {
  final int fdId; //0 = new collection, >0 = edit collection
  final mnoo.viewNOO lgn;
  final msf.Salesman user;
  final String noentry;
  final String routeName;
  final String navpage;
  final String startDayDate;
  final bool isEndDay;
  final String endTimeVisit;
  final int indexImg;
  final String? alamatSelected;
  final double orderExist;
  final double totalPromosiExtra;
  final double totalDiscount;
  final double totalPesanan;
  final List listKeranjang;
  final String noFaktur;
  final String txtTanggalKirim;
  final int isLockPage;

  const NooCollectionEditPage({
    super.key,
    required this.fdId,
    required this.lgn,
    required this.user,
    required this.noentry,
    required this.routeName,
    required this.navpage,
    required this.isEndDay,
    required this.startDayDate,
    required this.endTimeVisit,
    required this.indexImg,
    required this.alamatSelected,
    required this.orderExist,
    required this.totalPromosiExtra,
    required this.totalDiscount,
    required this.totalPesanan,
    required this.listKeranjang,
    required this.noFaktur,
    required this.txtTanggalKirim,
    required this.isLockPage,
  });

  @override
  State<NooCollectionEditPage> createState() => LayerNooCollectionEditPage();
}

class LayerNooCollectionEditPage extends State<NooCollectionEditPage> {
  bool isLoading = false;
  mcoll.CollectionDetail? collectionItem;

  List<mnoo.NOO> langganans = [];
  List<mlgn.Bank> listBank = [];
  List<modr.Order> listOrder = [];
  List<modr.Order> listOrderExist = [];
  List<modr.OrderItem> listOrderItem = [];
  List<mpiu.Faktur> listFaktur = [];
  List<mpiu.FakturItem> listFakturItem = [];
  List<mpiu.SuratJalan> listSuratJalan = [];
  List<mpiu.SuratJalanItem> listSuratJalanItem = [];
  List<mpiu.SuratJalanItemDetail> listSuratJalanItemDetail = [];
  List<modr.Order> listGetDataOrder = [];
  List<mstk.StockItem> listStockItem = [];
  List<mlgn.LanggananAlamat> listAlamatKirim = [];
  List<mcoll.CollectionDetail> listCollectionDetail = [];
  List<String> listTipeCollection = ['Tunai', 'Transfer', 'Giro', 'Cheque'];

  String sBuktiImg = '';
  String? sTipeCollectionSelected;
  String? sFromBankCollectionSelected;
  String? sToBankCollectionSelected;
  TextEditingController txtNoCollection = TextEditingController();
  TextEditingController txtJumlah = TextEditingController();
  TextEditingController txtTglCollection = TextEditingController();
  TextEditingController txtDueDateCollection = TextEditingController();
  TextEditingController txtTglTerima = TextEditingController();
  GlobalKey<FormState> formInputKey = GlobalKey<FormState>();
  bool checkSave = false;
  bool isImgExist = false;
  bool isLoadingImg = false;
  double sisaLK = 0;
  double totalPromosiExtra = 0;
  double orderExist = 0;
  String noEntry = '';
  String tanggalKirim = '';
  double totalTagihan = 0;
  double grandTotal = 0;
  double totalDiskon = 0;
  double sudahBayar = 0;
  double totalBayar = 0;
  double qTotalPesanan = 0;
  double qTotalDiskon = 0;
  int ppn = 0;
  double dblPPN = 0;

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
        isLoadingImg = true;
      });
      if (widget.isLockPage == 1) {
        listTipeCollection = ['Tunai', 'Transfer'];
      }
      final lparam = await clog.getDataParamByKodeSf(widget.user.fdKodeSF);
      ppn = lparam[0].fdPPN + 100;
      dblPPN = ppn / 100;
      totalPromosiExtra = widget.listKeranjang
          .where((item) => item.fdPromosi == '1')
          .fold(0, (sum, item) => sum + (item.fdUnitPrice * item.fdQty));

      listBank = await clgn.getBank();
      langganans = await cnoo.getAllNOObyfdKodeNoo(widget.lgn.fdKodeNoo!);

      totalTagihan = await cpiu.getTotalTagihan(widget.lgn.fdKodeNoo!);

      // listOrderExist =
      //     await codr.getDataOrderByKodeLangganan(widget.lgn.fdKodeLangganan!);

      listGetDataOrder = await codr.getDataOrderHeaderByNoEntry(widget.noentry);
      for (var odr in listGetDataOrder) {
        qTotalPesanan += odr.fdTotalOrder;
        qTotalDiskon += odr.fdDiscount!;
        tanggalKirim = odr.fdTanggalKirim!;
      }
      if (widget.fdId > 0) {
        collectionItem =
            await ccoll.getCollectionById(widget.fdId, widget.lgn.fdKodeNoo!);
        if (collectionItem != null) {
          sTipeCollectionSelected = collectionItem!.fdTipe;
          sFromBankCollectionSelected = collectionItem!.fdFromBank;
          sToBankCollectionSelected = collectionItem!.fdToBank;
          txtJumlah.text =
              param.enNumberFormat.format(collectionItem!.fdTotalCollection);
          sBuktiImg = collectionItem!.fdBuktiImg;
          txtNoCollection.text = collectionItem!.fdNoCollection;
          txtTglCollection.text = collectionItem!.fdTanggalCollection != ''
              ? param.dtFormatView.format(
                  param.dtFormatDB.parse(collectionItem!.fdTanggalCollection))
              : '';
          txtTglTerima.text = collectionItem!.fdTanggalTerima != ''
              ? param.dtFormatView.format(
                  param.dtFormatDB.parse(collectionItem!.fdTanggalTerima))
              : '';
          txtDueDateCollection.text = collectionItem!.fdDueDateCollection != ''
              ? param.dtFormatView.format(
                  param.dtFormatDB.parse(collectionItem!.fdDueDateCollection))
              : '';
        }
      } else {
        listCollectionDetail =
            await ccoll.getAllCollectionByLangganan(widget.lgn.fdKodeNoo!);
        if (listCollectionDetail.isNotEmpty) {
          for (var detail in listCollectionDetail) {
            sudahBayar += detail.fdTotalCollection;
          }
        }
        sTipeCollectionSelected = listTipeCollection.first;
        sFromBankCollectionSelected = listBank.first.fdKodeBank;
        sToBankCollectionSelected = listBank.first.fdKodeBank;

        getFileName();

        // delete the image if exist for new collection
        await deleteImage(sBuktiImg);
      }

      getImageFromDevice();

      setState(() {
        // orderExist = listOrderExist.isNotEmpty
        //     ? listOrderExist.first.fdTotalOrder ?? 0
        //     : 0;
        sisaLK = langganans.first.fdLimitKredit! - totalTagihan;
        if (listGetDataOrder.isNotEmpty) {
          // print(sisaLK);
          // print(qTotalPesanan);
          // print(qTotalDiskon);
          // print(totalPromosiExtra);
          // print(orderExist);
          grandTotal = qTotalPesanan - qTotalDiskon - totalPromosiExtra;
        } else {
          grandTotal = widget.totalPesanan -
              widget.totalDiscount -
              widget.totalPromosiExtra +
              widget.orderExist;
        }
        isLoading = false;
        isLoadingImg = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingImg = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void getFileName() {
    if (sTipeCollectionSelected == 'Transfer') {
      sBuktiImg =
          '${param.appDir}/${param.imgPath}/${param.buktiCollectionTransferImgName(widget.indexImg, widget.user.fdKodeSF, widget.lgn.fdKodeNoo!, widget.startDayDate)}';
    } else if (sTipeCollectionSelected == 'Giro') {
      sBuktiImg =
          '${param.appDir}/${param.imgPath}/${param.buktiCollectionGiroImgName(widget.indexImg, widget.user.fdKodeSF, widget.lgn.fdKodeNoo!, widget.startDayDate)}';
    } else if (sTipeCollectionSelected == 'Cheque') {
      sBuktiImg =
          '${param.appDir}/${param.imgPath}/${param.buktiCollectionChequeImgName(widget.indexImg, widget.user.fdKodeSF, widget.lgn.fdKodeNoo!, widget.startDayDate)}';
    }
  }

  void getImageFromDevice() async {
    await File(sBuktiImg).exists().then((value) {
      setState(() {
        isImgExist = value;
        isLoadingImg = false;
      });
    });
  }

  Future<bool> saveCollection() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (formInputKey.currentState!.validate()) {
        mcoll.CollectionDetail item = mcoll.CollectionDetail(
          fdId: widget.fdId,
          fdNoEntryFaktur: widget.noentry,
          fdTipe: sTipeCollectionSelected!,
          fdKodeLangganan: widget.lgn.fdKodeNoo!,
          fdTanggal: widget.startDayDate,
          fdTotalCollection:
              double.tryParse(txtJumlah.text.replaceAll(',', '')) ?? 0.0,
          fdFromBank:
              ['Transfer', 'Giro', 'Cheque'].contains(sTipeCollectionSelected)
                  ? sFromBankCollectionSelected!
                  : '',
          fdToBank:
              ['Transfer', 'Giro', 'Cheque'].contains(sTipeCollectionSelected)
                  ? sToBankCollectionSelected!
                  : '',
          fdNoCollection:
              ['Transfer', 'Giro', 'Cheque'].contains(sTipeCollectionSelected)
                  ? txtNoCollection.text
                  : '',
          fdTanggalCollection: ['Transfer', 'Giro', 'Cheque']
                  .contains(sTipeCollectionSelected)
              ? txtTglCollection.text != ''
                  ? param.dtFormatDB
                      .format(param.dtFormatView.parse(txtTglCollection.text))
                  : ''
              : '',
          fdDueDateCollection:
              ['Giro', 'Cheque'].contains(sTipeCollectionSelected)
                  ? txtDueDateCollection.text != ''
                      ? param.dtFormatDB.format(
                          param.dtFormatView.parse(txtDueDateCollection.text))
                      : ''
                  : '',
          fdTanggalTerima: sTipeCollectionSelected == 'Transfer'
              ? txtTglTerima.text != ''
                  ? param.dtFormatDB
                      .format(param.dtFormatView.parse(txtTglTerima.text))
                  : ''
              : '',
          fdBuktiImg: sBuktiImg,
          fdLastUpdate: param.dateTimeFormatDB.format(DateTime.now()),
        );

        if (widget.fdId > 0) {
          //update
          await ccoll.updateCollection(item);
        } else {
          //insert
          await ccoll.insertCollection(item);
        }
      }

      setState(() {
        isLoading = false;
      });

      return true;
    } catch (e) {
      if (!mounted) return false;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));

      return false;
    }
  }

  String replaceIndexImage(String fileName, int newIndex) {
    return fileName.replaceFirst(RegExp(r'_(\d+)(?=\.jpg$)'), '_$newIndex');
  }

  Widget getImage(String imgPath) {
    return File(imgPath).existsSync()
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
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.cancel_rounded,
                          size: 24 * ScaleSize.textScaleFactor(context)),
                      color: Colors.red,
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        yesNoDialogForm(imgPath);
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

  void yesNoDialogForm(String imgPath) {
    FunctionHelper.AlertDialogCip(
      context,
      DialogCip(
        title: 'Hapus',
        message: 'Lanjut hapus?',
        onOk: () async {
          try {
            // 1. Eksekusi proses hapus file gambar
            await deleteImage(imgPath);

            // 2. Safety check mounted sebelum navigasi
            if (!mounted) return;
            
            // 3. Tutup dialog
            Navigator.pop(context);

            // 4. Update state lokal untuk menghilangkan tampilan gambar
            setState(() {
              isImgExist = false;
              isLoadingImg = false;
            });

          } catch (e) {
            // Handle error dengan SnackBar
            if (mounted) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('error: $e')));
            }
          }
        },
      ),
    );
  }

  Future<void> deleteImage(String filePath) async {
    await File(filePath).exists().then((isExist) async {
      if (isExist) {
        await File(filePath).delete();
      }

      setState(() {
        isImgExist = false;
        isLoadingImg = false;
      });
    });
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
        onPressed: () {
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
      onWillPop: !isLoading
          ? () async {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => NooCollectionPage(
              //             lgn: widget.lgn,
              //             user: widget.user,
              //             noentry: widget.noentry,
              //             navpage: widget.navpage,
              //             routeName: 'collection',
              //             isEndDay: widget.isEndDay,
              //             endTimeVisit: widget.endTimeVisit,
              //             startDayDate: widget.startDayDate)));
              if (widget.navpage == 'pembayaran_penuh') {
                return false;
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NooCollectionPage(
                            lgn: widget.lgn,
                            user: widget.user,
                            noentry: widget.noentry,
                            navpage: widget.navpage,
                            routeName: 'collection',
                            startDayDate: widget.startDayDate,
                            endTimeVisit: widget.endTimeVisit,
                            isEndDay: widget.isEndDay,
                            totalCollection: 0,
                            alamatSelected: widget.alamatSelected,
                            orderExist: widget.orderExist,
                            totalPromosiExtra: widget.totalPromosiExtra,
                            totalDiscount: widget.totalDiscount,
                            totalPesanan: widget.totalPesanan,
                            listKeranjang: widget.listKeranjang,
                            noFaktur: widget.noFaktur,
                            txtTanggalKirim: widget.txtTanggalKirim)));
              }
              return false;
            }
          : () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Collection'),
          automaticallyImplyLeading: widget.isLockPage == 0 ? true : false,
        ),
        body: Column(
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
            Flexible(
              child: SingleChildScrollView(
                  reverse: true,
                  child: Form(
                      key: formInputKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.all(5)),
                            // Flexible(
                            // child:
                            Container(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    // Flexible(
                                    // child:
                                    DropdownSearch<String>(
                                      // itemAsString: (mbrg.Barang item) => item.fdNamaBarang,
                                      // compareFn: (mbrg.Barang item,
                                      //         mbrg.Barang selectedItem) =>
                                      //     item.fdKodeBarang == selectedItem.fdKodeBarang,
                                      items: (String filter, LoadProps? loadProps) =>listTipeCollection,
                                      selectedItem: sTipeCollectionSelected,
                                      // selectedItem: listBarang.firstWhere(
                                      //   (item) =>
                                      //       item.fdKodeBarang.trim() == barangSelected,
                                      //   orElse: () => mbrg.Barang(
                                      //       fdKodeBarang: '',
                                      //       fdNamaBarang: '',
                                      //       fdSatuanK: ''), // Default empty
                                      // ),
                                      enabled: widget.fdId == 0 ? true : false,
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: css.textInputStyle(
                                            'Search',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            null,
                                            Icon(Icons.search,
                                                size: 24 *
                                                    ScaleSize.textScaleFactor(
                                                        context)),
                                            null,
                                          ),
                                        ),
                                        searchDelay:
                                            const Duration(milliseconds: 0),
                                        itemBuilder:
                                            (context, item, isSelected,val) {
                                          return ListTile(
                                            title: Text(
                                              item,
                                              style: css.textSmallSizeBlack(),
                                            ),
                                          );
                                        },
                                        menuProps: MenuProps(
                                            shape:
                                                css.borderOutlineInputRound()),
                                      ),
                                      decoratorProps:
                                          DropDownDecoratorProps(
                                        decoration:
                                            css.textInputStyle(
                                          'Tipe',
                                          const TextStyle(
                                              fontStyle: FontStyle.italic),
                                          'Tipe',
                                          null,
                                          null,
                                        ),
                                      ),
                                      onChanged: (String? value) async {
                                        await deleteImage(sBuktiImg);

                                        sTipeCollectionSelected = value!.trim();
                                        getFileName();

                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select Tipe';
                                        }
                                        return null;
                                      },
                                      // filterFn: (mbrg.Barang item, String filter) {
                                      //   return item.fdNamaBarang
                                      //           .toLowerCase()
                                      //           .contains(filter.toLowerCase()) ||
                                      //       item.fdKodeBarang
                                      //           .toLowerCase()
                                      //           .contains(filter.toLowerCase());
                                      // },
                                    ),
                                    // ),
                                    if (['Transfer', 'Giro', 'Cheque']
                                        .contains(sTipeCollectionSelected)) ...[
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: txtNoCollection,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: css.textInputStyle(
                                            sTipeCollectionSelected ==
                                                    'Transfer'
                                                ? 'Transfer No.'
                                                : sTipeCollectionSelected ==
                                                        'Giro'
                                                    ? 'Giro No.'
                                                    : 'Cheque No.',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            sTipeCollectionSelected ==
                                                    'Transfer'
                                                ? 'Trans No.'
                                                : sTipeCollectionSelected ==
                                                        'Giro'
                                                    ? 'Giro No.'
                                                    : 'Cheque No.',
                                            null,
                                            null),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value == '0') {
                                            String labelTrans =
                                                sTipeCollectionSelected ==
                                                        'Transfer'
                                                    ? 'Trans No.'
                                                    : sTipeCollectionSelected ==
                                                            'Giro'
                                                        ? 'Giro No.'
                                                        : 'Cheque No.';

                                            return 'Please fill $labelTrans';
                                          }

                                          return null;
                                        },
                                      )
                                    ],
                                    if (['Transfer', 'Giro', 'Cheque']
                                        .contains(sTipeCollectionSelected)) ...[
                                      const SizedBox(height: 10),
                                      DropdownSearch<mlgn.Bank>(
                                        itemAsString: (mlgn.Bank item) =>
                                            item.fdNamaBank,
                                        compareFn: (mlgn.Bank item,
                                                mlgn.Bank selectedItem) =>
                                            item.fdKodeBank ==
                                            selectedItem.fdKodeBank,
                                        items: (String filter, LoadProps? loadProps) =>listBank,
                                        selectedItem: listBank.isNotEmpty
                                            ? listBank.firstWhere(
                                                (item) =>
                                                    item.fdKodeBank.trim() ==
                                                    (sFromBankCollectionSelected ??
                                                        ''),
                                                orElse: () => mlgn.Bank(
                                                    fdKodeBank: '',
                                                    fdNamaBank: '',
                                                    fdNamaSingkat: '',
                                                    fdLastUpdate: ''))
                                            : mlgn.Bank(
                                                fdKodeBank: '',
                                                fdNamaBank: '',
                                                fdNamaSingkat: '',
                                                fdLastUpdate: ''),
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: css.textInputStyle(
                                              'Search',
                                              const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                              null,
                                              Icon(Icons.search,
                                                  size: 24 *
                                                      ScaleSize.textScaleFactor(
                                                          context)),
                                              null,
                                            ),
                                          ),
                                          searchDelay:
                                              const Duration(milliseconds: 0),
                                          itemBuilder:
                                              (context, item, isSelected,val) {
                                            return ListTile(
                                              title: Text(
                                                '${item.fdNamaSingkat.trim()} - ${item.fdNamaBank.trim()}',
                                                style: css.textSmallSizeBlack(),
                                              ),
                                            );
                                          },
                                          menuProps: MenuProps(
                                              shape: css
                                                  .borderOutlineInputRound()),
                                        ),
                                        decoratorProps:
                                            DropDownDecoratorProps(
                                          decoration:
                                              css.textInputStyle(
                                            'From Bank',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            'From Bank',
                                            null,
                                            null,
                                          ),
                                        ),
                                        onChanged: (mlgn.Bank? value) {
                                          setState(() {
                                            sFromBankCollectionSelected =
                                                value?.fdKodeBank.trim();
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.fdKodeBank == null ||
                                              value.fdKodeBank.trim().isEmpty) {
                                            return 'Please select From Bank';
                                          }
                                          return null;
                                        },
                                        filterFn:
                                            (mlgn.Bank item, String filter) {
                                          return item.fdNamaSingkat
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase()) ||
                                              item.fdNamaBank
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase()) ||
                                              item.fdKodeBank
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase());
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownSearch<mlgn.Bank>(
                                        itemAsString: (mlgn.Bank item) =>
                                            item.fdNamaBank,
                                        compareFn: (mlgn.Bank item,
                                                mlgn.Bank selectedItem) =>
                                            item.fdKodeBank ==
                                            selectedItem.fdKodeBank,
                                        items: (String filter, LoadProps? loadProps) =>listBank,
                                        selectedItem: listBank.firstWhere(
                                          (item) =>
                                              item.fdKodeBank.trim() ==
                                              sToBankCollectionSelected,
                                          orElse: () => mlgn.Bank(
                                              fdKodeBank: '',
                                              fdNamaBank: '',
                                              fdNamaSingkat: '',
                                              fdLastUpdate: ''),
                                        ),
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: css.textInputStyle(
                                              'Search',
                                              const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                              null,
                                              Icon(Icons.search,
                                                  size: 24 *
                                                      ScaleSize.textScaleFactor(
                                                          context)),
                                              null,
                                            ),
                                          ),
                                          searchDelay:
                                              const Duration(milliseconds: 0),
                                          itemBuilder:
                                              (context, item, isSelected,val) {
                                            return ListTile(
                                              title: Text(
                                                '${item.fdNamaSingkat.trim()} - ${item.fdNamaBank.trim()}',
                                                style: css.textSmallSizeBlack(),
                                              ),
                                            );
                                          },
                                          menuProps: MenuProps(
                                              shape: css
                                                  .borderOutlineInputRound()),
                                        ),
                                        decoratorProps:
                                            DropDownDecoratorProps(
                                          decoration:
                                              css.textInputStyle(
                                            'To Bank',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            'To Bank',
                                            null,
                                            null,
                                          ),
                                        ),
                                        onChanged: (mlgn.Bank? value) {
                                          setState(() {
                                            sToBankCollectionSelected =
                                                value?.fdKodeBank.trim();
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.fdKodeBank == null ||
                                              value.fdKodeBank.trim().isEmpty) {
                                            return 'Please select To Bank';
                                          }
                                          return null;
                                        },
                                        filterFn:
                                            (mlgn.Bank item, String filter) {
                                          return item.fdNamaSingkat
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase()) ||
                                              item.fdNamaBank
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase()) ||
                                              item.fdKodeBank
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase());
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: txtTglCollection,
                                        decoration: css.textInputStyle(
                                            'Date',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            'Date',
                                            Icon(Icons.calendar_month,
                                                size: 24 *
                                                    ScaleSize.textScaleFactor(
                                                        context)),
                                            clearDateIcon(txtTglCollection)),
                                        readOnly: true,
                                        onTap: () async {
                                          await showCalendar(txtTglCollection);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please fill Date';
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    ],
                                    if (sTipeCollectionSelected ==
                                        'Transfer') ...[
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: txtTglTerima,
                                        decoration: css.textInputStyle(
                                            'Tgl. Terima',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            'Tgl. Terima',
                                            Icon(Icons.calendar_month,
                                                size: 24 *
                                                    ScaleSize.textScaleFactor(
                                                        context)),
                                            clearDateIcon(txtTglTerima)),
                                        readOnly: true,
                                        onTap: () async {
                                          await showCalendar(txtTglTerima);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please fill Tgl. Terima';
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    ],
                                    if (['Giro', 'Cheque']
                                        .contains(sTipeCollectionSelected)) ...[
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: txtDueDateCollection,
                                        decoration: css.textInputStyle(
                                            'Due Date',
                                            const TextStyle(
                                                fontStyle: FontStyle.italic),
                                            'Due Date',
                                            Icon(Icons.calendar_month,
                                                size: 24 *
                                                    ScaleSize.textScaleFactor(
                                                        context)),
                                            clearDateIcon(
                                                txtDueDateCollection)),
                                        readOnly: true,
                                        onTap: () async {
                                          await showCalendar(
                                              txtDueDateCollection);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please fill Due Date';
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    ],
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: txtJumlah,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        cother
                                            .EnThousandsSeparatorInputFormatter(),
                                      ],
                                      decoration: css.textInputStyle(
                                        'Nominal',
                                        const TextStyle(
                                            fontStyle: FontStyle.italic),
                                        'Nominal',
                                        null,
                                        null,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value == '0') {
                                          return 'Please fill Jumlah';
                                        }

                                        return null;
                                      },
                                    ),
                                    if (['Transfer', 'Giro', 'Cheque']
                                        .contains(sTipeCollectionSelected)) ...[
                                      // Expanded(
                                      // child:
                                      const SizedBox(height: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            isImgExist
                                                ? SizedBox(
                                                    height: 150,
                                                    width: 120,
                                                    child: getImage(sBuktiImg))
                                                : widget.endTimeVisit.isEmpty
                                                    ? IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            isLoadingImg = true;
                                                          });
                                                          ccam
                                                              .pickCamera(
                                                                  context,
                                                                  widget.user
                                                                      .fdToken,
                                                                  'Take Photo',
                                                                  sBuktiImg,
                                                                  widget
                                                                      .routeName,
                                                                  false)
                                                              .then((value) {
                                                            getImageFromDevice();

                                                            setState(() {
                                                              isLoadingImg =
                                                                  false;
                                                            });
                                                          });
                                                        },
                                                        icon: isLoadingImg
                                                            ? loadingProgress(
                                                                ScaleSize
                                                                    .textScaleFactor(
                                                                        context))
                                                            : Icon(
                                                                Icons
                                                                    .photo_camera_rounded,
                                                                size: 36 *
                                                                    ScaleSize.textScaleFactor(
                                                                        context),
                                                                color: Colors
                                                                    .orange,
                                                                semanticLabel:
                                                                    'Foto'),
                                                        tooltip: 'Take photo')
                                                    : IconButton(
                                                        onPressed: null,
                                                        icon: Icon(
                                                            Icons
                                                                .no_photography_rounded,
                                                            size: 36 *
                                                                ScaleSize
                                                                    .textScaleFactor(
                                                                        context),
                                                            color: Colors
                                                                .redAccent,
                                                            semanticLabel:
                                                                'Foto'),
                                                        tooltip:
                                                            'No Take photo'),
                                          ])
                                      // )
                                    ]
                                  ],
                                  // ),
                                )),
                          ]))),
            )
          ],
        ),
        bottomNavigationBar: isLoading
            ? Center(child: loadingProgress(ScaleSize.textScaleFactor(context)))
            : BottomAppBar(
                height: 40 * ScaleSize.textScaleFactor(context),
                child: TextButton(
                  onPressed: () async {
                    if (formInputKey.currentState!.validate()) {
                      checkSave = await saveCollection();

                      if (checkSave) {
                        if (!mounted) return;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings:
                                    const RouteSettings(name: 'collection'),
                                builder: (context) => NooCollectionPage(
                                    lgn: widget.lgn,
                                    user: widget.user,
                                    noentry: widget.noentry,
                                    navpage: 'collection',
                                    endTimeVisit: widget.endTimeVisit,
                                    routeName: 'collection',
                                    startDayDate: widget.startDayDate,
                                    isEndDay: widget.isEndDay,
                                    totalCollection: 0,
                                    alamatSelected: widget.alamatSelected,
                                    orderExist: widget.orderExist,
                                    totalPromosiExtra: widget.totalPromosiExtra,
                                    totalDiscount: widget.totalDiscount,
                                    totalPesanan: widget.totalPesanan,
                                    listKeranjang: widget.listKeranjang,
                                    noFaktur: widget.noFaktur,
                                    txtTanggalKirim:
                                        widget.txtTanggalKirim))).then((value) {
                          initLoadPage();

                          setState(() {});
                        });
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
      ),
    );
  }
}
