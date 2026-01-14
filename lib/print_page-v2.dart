import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controller/order_cont.dart' as codr;
import 'controller/piutang_cont.dart' as cpiu;
import 'controller/collection_cont.dart' as ccol;
import 'models/order.dart' as modr;
import 'models/piutang.dart' as mpiu;
import 'models/noo.dart' as mnoo;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;

// void main() {
//   runApp(MaterialApp(
//     title: 'Print',
//     home: PrintPage(fdNoEntryOrder: ''),
//   ));
// }

class PrintPage extends StatefulWidget {
  final msf.Salesman user;
  final String kodeLangganan;
  final String namaLangganan;
  final String fdNoEntryOrder;
  final int cetakan;

  const PrintPage(
      {super.key,
      required this.user,
      required this.kodeLangganan,
      required this.namaLangganan,
      required this.fdNoEntryOrder,
      required this.cetakan});

  @override
  State<PrintPage> createState() => LayerPrint();
}

class LayerPrint extends State<PrintPage> {
  bool isLoading = false;
  String sDefaultMAC = '57:4C:54:00:5A:B0';
  bool? bConnect = false;
  String tips = 'no device connect';
  List<BluetoothInfo> items = [];
  List<modr.OrderItem> listGetDataOrderItem = [];
  List<mpiu.Piutang> listPiutang = [];
  List<mpiu.Piutang> listPiutangPromosi = [];
  List<mpiu.Piutang> listPiutangJoinItem = [];
  int jml = 0;
  double total = 0;
  double totalPesanan = 0;
  double totalTagihan = 0;
  double totalDiscount = 0;
  double totalPenjualan = 0;
  double totalPembalikanDPP = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double totalNetto = 0;
  double totalBruto = 0;
  double totalBulatDisc = 0;
  double decimalDPP = 0;
  String payment = '';
  String kodeTransaksiFP = '';
  // BluetoothDevice? _device;

  @override
  void initState() {
    connectBluetooth();
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });
      payment = await ccol.getPaymentByKodeLangganan(widget.kodeLangganan!);
      listGetDataOrderItem =
          await codr.getDataOrderDetailByNoEntry(widget.fdNoEntryOrder);
      listPiutang = await cpiu.getFakturByNoEntry(widget.fdNoEntryOrder);
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
            double dppPromosi = 0;
            String fdJenisSatuan = '';
            String fdSatuan = '';

            if (promosiItem.isNotEmpty) {
              extraQtyK = promosiItem.fold(0, (sum, p) => sum + (p.fdQtyK));
              totalQtyK = item.fdQtyK + extraQtyK;
              dppPromosi = promosiItem.fold(0, (sum, p) => sum + (p.fdDPP));
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
                  fdBruttopromosi: item.fdBrutto + dppPromosi,
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
          kodeTransaksiFP = element.fdKodeTransaksiFP.toString();
          totalPenjualan += element.fdQty * element.fdHargaAsli;
          totalNetto += element.fdNetto;
          totalBruto += element.fdBrutto;
          decimalDPP = element.fdQty * element.fdHargaAsli;
          totalBulatDisc += decimalDPP - element.fdDPP;
          if (element.fdPromosi != '1') {
            totalDPP += element.fdDPP;
            totalPPN += element.fdPPN;
          }
          if (element.fdPromosi == '0') {
            totalDiscount += element.fdDiscount;
          } else {
            totalDiscount += element.fdHargaAsli * element.fdQty;
          }
        }
        totalPPN = totalPPN.floorToDouble();
        totalPembalikanDPP = totalPPN * 100 / 12;
        totalDiscount = double.parse(totalBulatDisc.toStringAsFixed(2));
        totalNetto = totalPenjualan - totalDiscount;
        if (kodeTransaksiFP == '07') {
          totalTagihan = totalNetto;
        } else {
          totalTagihan = totalNetto + totalPPN;
        }
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

  Future<void> connectBluetooth() async {
    final bool bBluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;

    if (bBluetoothOn) {
      String platformVersion = '';
      int poercentbatery = 0;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        platformVersion = await PrintBluetoothThermal.platformVersion;
        poercentbatery = await PrintBluetoothThermal.batteryLevel;
      } on PlatformException {
        platformVersion = 'Failed to get platform version.';
      }

      tips =
          '$platformVersion - $poercentbatery%. Bluetooth is on, scanning...';

      await getBluetooths();

      // Auto connect to default printer
      bConnect! ? await disconnect() : null;
      await connect(sDefaultMAC);
    } else {
      tips = 'Bluetooth is off';
    }

    setState(() {});
  }

  Future<void> getBluetooths() async {
    setState(() {
      items = [];
    });

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    if (listResult.isEmpty) {
      tips =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      tips = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      tips = 'connecting...';
      bConnect = false;
    });

    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    if (result) bConnect = true;

    setState(() {
      tips = bConnect! ? 'connected' : 'disconnected';
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      bConnect = false;
      tips = status ? 'disconnected' : 'disconnect failed';
    });
  }

  Future<List<int>> setPrintBody() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // final ByteData data = await rootBundle.load('assets/images/logo250abc.png');
    // final Uint8List bytesImg =
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // img.Image? image = img.decodeImage(bytesImg);
    // image = img.copyResize(image!, width: 200);

    //Using `ESC *`
    // bytes += generator.image(image);
    // bytes += generator.text('PT. Intercallin',
    //     styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.image(image);

    bytes += generator.text('# ${widget.cetakan}',
        styles: const PosStyles(
            align: PosAlign.right, fontType: PosFontType.fontB));
    bytes += generator.text('PT. International Chemical Industry',
        styles: const PosStyles(
            align: PosAlign.left, bold: true, fontType: PosFontType.fontB));
    bytes += generator.text(
        'Jl. Daan Mogot km. 11, Cengkareng, Jakarta Barat, 11710',
        styles:
            const PosStyles(align: PosAlign.left, fontType: PosFontType.fontB));
    bytes += generator.feed(1);
    bytes += generator.text('TANDA TERIMA BARANG',
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(1);
    bytes += generator.text('No        : ${widget.fdNoEntryOrder ?? ''}',
        styles: const PosStyles(fontType: PosFontType.fontB));
    bytes += generator.text(
        'Tgl       : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}');
    bytes += generator.text('Langganan : ${widget.namaLangganan}');
    bytes += generator
        .text('Alamat    : ${listGetDataOrderItem.first.fdAlamatKirim}');
    bytes += generator.text('No. Cust. : ${widget.kodeLangganan}');
    bytes += generator.text('No. SJ    : ${listGetDataOrderItem.first.fdNoSJ}');
    bytes += generator.text('Payment   : $payment');

    bytes += generator.hr();
    // bytes += generator.hr();
    // bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: const PosStyles(codeTable: 'CP1252'));
    // bytes += generator.text('Special 2: blåbærgrød', styles: const PosStyles(codeTable: 'CP1252'));

    // bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    // bytes += generator.text('Reverse text', styles: const PosStyles(reverse: true));
    // bytes += generator.text('Underlined text', styles: const PosStyles(underline: true), linesAfter: 1);
    // bytes += generator.text('Align left', styles: const PosStyles(align: PosAlign.left));
    // bytes += generator.text('Align center', styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right', styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
    jml = 0;
    for (int index = 0; index < listPiutangJoinItem.length; index++) {
      jml = jml + 1;
      total += listPiutangJoinItem[index].fdNetto;
      bytes += generator.text(
          '${listPiutangJoinItem[index].fdKodeBarang} - ${listPiutangJoinItem[index].fdNamaBarang}');
      bytes += generator.row([
        PosColumn(
          text:
              '${param.enNumberFormatQty.format(listPiutangJoinItem[index].fdQty)} ${listPiutangJoinItem[index].fdSatuan.toString().trimRight()} @${param.idNumberFormat.format(listPiutangJoinItem[index].fdHargaAsli)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: param.enNumberFormat.format(listPiutangJoinItem[index].fdQty *
              listPiutangJoinItem[index].fdHargaAsli),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        )
      ]);
//hitungan pindah ke atas
      // totalPenjualan += listPiutangJoinItem[index].fdQty *
      //     listPiutangJoinItem[index].fdHargaAsli;
      // if (listPiutangJoinItem[index].fdPromosi != '1') {
      //   totalDPP += listPiutangJoinItem[index].fdDPP;
      //   totalPPN += listPiutangJoinItem[index].fdPPN;
      // }
      // if (listPiutangJoinItem[index].fdPromosi == '0') {
      //   totalDiscount += listPiutangJoinItem[index].fdDiscount;
      // } else {
      //   totalDiscount += listPiutangJoinItem[index].fdHargaAsli *
      //       listPiutangJoinItem[index].fdQty;
      // }
      // kodeTransaksiFP = listPiutangJoinItem[index].fdKodeTransaksiFP.toString();

      // bytes += generator.row([
      //   PosColumn(
      //     text:
      //         '${listGetDataOrderItem[index].fdQty} ${listGetDataOrderItem[index].fdNamaSatuan} x ${param.enNumberFormatQty.format(listGetDataOrderItem[index].fdUnitPrice)}',
      //     width: 7,
      //     styles: const PosStyles(align: PosAlign.left),
      //   ),
      //   PosColumn(
      //     text: param.enNumberFormatQty
      //         .format(listGetDataOrderItem[index].fdBrutto),
      //     width: 5,
      //     styles: const PosStyles(align: PosAlign.right),
      //   )
      // ]);
      // bytes += generator.row([
      //   PosColumn(
      //     text: '(discount)',
      //     width: 7,
      //     styles: const PosStyles(align: PosAlign.left),
      //   ),
      //   PosColumn(
      //     text:
      //         '(${param.enNumberFormatQty.format(listGetDataOrderItem[index].fdDiscount)})',
      //     width: 5,
      //     styles: const PosStyles(align: PosAlign.right),
      //   )
      // ]);
      // bytes += generator.row([
      //   PosColumn(
      //     text: 'Sub Total',
      //     width: 7,
      //     styles: const PosStyles(align: PosAlign.right),
      //   ),
      //   PosColumn(
      //     text: param.enNumberFormatQty
      //         .format(listGetDataOrderItem[index].fdNetto),
      //     width: 5,
      //     styles: const PosStyles(align: PosAlign.right),
      //   )
      // ]);
      // bytes += generator.feed(1);
    }
    // totalPPN = totalPPN.floorToDouble();
    // totalPembalikanDPP = totalPPN * 100 / 12;
    // totalNetto = totalPenjualan - totalDiscount;
    // if (kodeTransaksiFP == '07') {
    //   totalTagihan = totalNetto;
    // } else {
    //   totalTagihan = totalNetto + totalPPN;
    // }
    // // bytes += generator.feed(1);
    // bytes += generator.text('Total barang: $jml');
    // bytes += generator.text('Total: Rp. ${param.enNumberFormat.format(total)}',
    //     styles: const PosStyles(bold: true));

    bytes += generator.row([
      PosColumn(
        text: 'Jumlah Penjualan:',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: param.enNumberFormat.format(totalPenjualan),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      )
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Potongan:',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: param.enNumberFormat.format(totalDiscount),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      )
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'DPP:',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: param.enNumberFormat.format(totalPembalikanDPP),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      )
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'PPN:',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: param.enNumberFormat.format(totalPPN),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      )
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Jumlah:',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: param.enNumberFormat.format(totalTagihan),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      )
    ]);

    bytes += generator.feed(1);
    bytes += generator.text('Tanda Tangan / Stempel',
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(5);
    bytes += generator.row([
      PosColumn(
        text: widget.user.fdNamaSF,
        width: 5,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 2,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: widget.namaLangganan,
        width: 5,
        styles: const PosStyles(align: PosAlign.center),
      )
    ]);

    bytes += generator.cut();

    //barcode

    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    // //QR code
    // bytes += generator.qrcode('example.com');

    // bytes += generator.text(
    //   'Text size 50%',
    //   styles: const PosStyles(
    //     fontType: PosFontType.fontB,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 100%',
    //   styles: const PosStyles(
    //     fontType: PosFontType.fontA,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 200%',
    //   styles: const PosStyles(
    //     height: PosTextSize.size2,
    //     width: PosTextSize.size2,
    //   ),
    // );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Do Print'),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        backgroundColor: Colors.yellow,
        color: Colors.red,
        strokeWidth: 2,
        onRefresh: () async {
          await connectBluetooth();

          return Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: items.isNotEmpty ? items.length : 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      String mac = items[index].macAdress;
                      bConnect! ? await disconnect() : null;
                      await connect(mac);
                    },
                    title: Text('Name: ${items[index].name}'),
                    subtitle: Text("macAddress: ${items[index].macAdress}"),
                  );
                },
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           OutlinedButton(
                    //             onPressed:  bConnect!?null:() async {
                    //               if(_device!=null && _device!.address !=null){
                    //                 setState(() {
                    //                   tips = 'connecting...';
                    //                 });
                    //                 await bluetoothPrint.connect(_device!);
                    //               }else{
                    //                 setState(() {
                    //                   tips = 'please select device';
                    //                 });
                    //                 print('please select device');
                    //               }
                    //             },
                    //             child: const Text('connect'),
                    //           ),
                    //           const SizedBox(width: 10.0),
                    //           OutlinedButton(
                    //             onPressed:  bConnect!?() async {
                    //               setState(() {
                    //                 tips = 'disconnecting...';
                    //               });
                    //               await bluetoothPrint.disconnect();
                    //             }:null,
                    //             child: const Text('disconnect'),
                    //           ),
                    //         ],
                    //       ),
                    //       const Divider(),
                    OutlinedButton(
                      onPressed: () async {
                        // Check if not connected must connect to default printer
                        print('bConnect: $bConnect');
                        !bConnect!
                            ? () async {
                                // Auto connect to default printer
                                bConnect! ? await disconnect() : null;
                                await connect(sDefaultMAC);
                              }
                            : null;

                        List<int> printBody = await setPrintBody();
                        bool bResult =
                            await PrintBluetoothThermal.writeBytes(printBody);
                        print('print result: $bResult');

                        setState(() {});
                      },
                      child: const Text('print'),
                    ),
                    //       OutlinedButton(
                    //         onPressed:  bConnect!?() async {
                    //           await bluetoothPrint.printTest();
                    //         }:null,
                    //         child: const Text('print selftest'),
                    //       )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
