import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;
import '../models/globalparam.dart' as param;

bool bConnect = false;

Future<bool> checkBluetoothPrinter() async {
  bool bBluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;

  return bBluetoothOn;
}

Future<String> connect(String mac) async {
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    
    if (result) {
      bConnect = true;
      return '';
    } else {
      bConnect = false;
      return 'Gagal connect printer Bluetooth. Matikan dan nyalakan printer Bluetooth!';
    }
  }

  Future<String> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;

    bConnect = false;

    if (!status) {
      return 'Gagal disconnect printer Bluetooth. Matikan dan nyalakan printer Bluetooth!';
    } else {
      return '';
    }
  }

  Future<String> setPrintBody(String mac, String logoPath, String fdNamaSF, String fdNamaLangganan, 
    String fdKodeLangganan, String fdAlamat, List<dynamic> listKeranjang, double totalPesanan, 
    double totalDiscount, double totalPromosiExtra, int printNumber) async {
    // Check if Bluetooth is enabled
    final bool bBluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;
    
    if (bBluetoothOn) {
      if (bConnect) {
        String res = await disconnect();

        if (res.isNotEmpty) {
          return res;
        }
      } 

      String res = await connect(mac);
      if (res.isNotEmpty) {
        return res;
      }

      // Merge items with the same fdKodeBarang by summing their fdQty
      Map<String, dynamic> mergedKeranjang = {};
      for (var barang in listKeranjang) {
        String kodeBarang = barang.fdKodeBarang;
        if (mergedKeranjang.containsKey(kodeBarang)) {
          mergedKeranjang[kodeBarang].fdQty += barang.fdQty;
        } else {
          mergedKeranjang[kodeBarang] = barang;
        }
      }
      
      listKeranjang = mergedKeranjang.values.toList();

      List<int> bytes = [];
      // Using default profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      
      //bytes += generator.setGlobalFont(PosFontType.fontA);
      bytes += generator.reset();

      final ByteData data = await rootBundle.load(logoPath);
      final Uint8List bytesImg = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      img.Image? image = img.decodeImage(bytesImg);
      image = img.copyResize(image!, width: 100);
    
      DateTime now = DateTime.now();
      //Using `ESC *`
      // No Urut masih hardcode, nanti diubah kalau sudah ada no urut print
      bytes += generator.text('# $printNumber', styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontB));
      bytes += generator.image(image);
      bytes += generator.text('PT. International Chemical Industry', styles: const PosStyles(align: PosAlign.left, bold: true, fontType: PosFontType.fontB));
      bytes += generator.text('Jl. Daan Mogot km. 11, Cengkareng, Jakarta Barat, 11710', styles: const PosStyles(align: PosAlign.left, fontType: PosFontType.fontB));
      bytes += generator.feed(1);
      bytes += generator.text('TANDA TERIMA BARANG', styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);
      bytes += generator.text('No        : ${listKeranjang.first.fdNoEntryOrder?? ''}', styles: const PosStyles(fontType: PosFontType.fontB));
      bytes += generator.text('Tgl       : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(now)}');
      bytes += generator.text('Langganan : $fdNamaLangganan');
      bytes += generator.text('Alamat    : $fdAlamat');
      bytes += generator.text('No. Cust. : $fdKodeLangganan');
      bytes += generator.text('No. SJ    : (No SJ)'); 
      bytes += generator.text('Payment   : (Payment?)'); 

      bytes += generator.hr();
      
      // Loop di list item order
      for (int index = 0; index < listKeranjang.length; index++) {
        var barang = listKeranjang[index];

        bytes += generator.text('${barang.fdKodeBarang} - ${barang.fdNamaBarang}');
        bytes += generator.row([
          PosColumn(
            text: '${param.enNumberFormatQty.format(barang.fdQty)} ${barang.fdNamaJenisSatuan.toString().trimRight()} @${param.enNumberFormat.format(barang.fdUnitPrice)}',
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: param.enNumberFormat.format(barang.fdQty * barang.fdUnitPrice),
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          )
        ]);

        // bytes += generator.row([
        //   PosColumn(
        //     text: '@${param.enNumberFormat.format(barang.fdUnitPrice)}',
        //     width: 6,
        //     styles: const PosStyles(align: PosAlign.left),
        //   ),
        //   PosColumn(
        //     text: '',
        //     width: 6,
        //     styles: const PosStyles(align: PosAlign.right),
        //   )
        // ]);

        bytes += generator.feed(1);
      }

      bytes += generator.row([
        PosColumn(
          text: 'Sub Total:',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: param.enNumberFormat.format(totalPesanan),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        )
      ]);
      bytes += generator.row([
        PosColumn(
          text: 'Diskon:',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: param.enNumberFormat.format(totalDiscount + totalPromosiExtra),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        )
      ]);
      bytes += generator.row([
        PosColumn(
          text: 'Total:',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: param.enNumberFormat.format(totalPesanan - totalDiscount - totalPromosiExtra),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        )
      ]);
      
      bytes += generator.feed(1);
      bytes += generator.text('Tanda Tangan / Stempel', styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(5);
      bytes += generator.row([
        PosColumn(
          text: fdNamaSF,
          width: 5,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: '',
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: fdNamaLangganan,
          width: 5,
          styles: const PosStyles(align: PosAlign.center),
        )
      ]);
      
      bytes += generator.cut();

      bool bResult = await PrintBluetoothThermal.writeBytes(bytes);
      print('print result: $bResult');

      return  bResult? '' : 'Gagal print. Periksa koneksi printer Bluetooth!';
    } else {
      return 'Bluetooth tidak aktif. Aktifkan Bluetooth terlebih dahulu!';
    }
  }

  // // Print dengan Diskon per item
  // Future<String> setPrintBody_With_Diskon_Per_Item(String mac, String logoPath, String fdNamaLangganan, String fdKodeLangganan,
  //   String fdAlamat, List<dynamic> listKeranjang, double totalPesanan, double totalDiscount,
  //   double totalPromosiExtra) async {
  //   // Check if Bluetooth is enabled
  //   final bool bBluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;

  //   if (bBluetoothOn) {
  //     if (bConnect) {
  //       String res = await disconnect();

  //       if (res.isNotEmpty) {
  //         return res;
  //       }
  //     } 

  //     String res = await connect(mac);
  //     if (res.isNotEmpty) {
  //       return res;
  //     }

  //     List<int> bytes = [];
  //     // Using default profile
  //     final profile = await CapabilityProfile.load();
  //     final generator = Generator(PaperSize.mm58, profile);
      
  //     //bytes += generator.setGlobalFont(PosFontType.fontA);
  //     bytes += generator.reset();

  //     final ByteData data = await rootBundle.load(logoPath);
  //     final Uint8List bytesImg = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //     img.Image? image = img.decodeImage(bytesImg);
  //     image = img.copyResize(image!, width: 200);
  //     DateTime now = DateTime.now();
  //     //Using `ESC *`
  //     bytes += generator.text('# (1)', styles: const PosStyles(align: PosAlign.right)); // No Urut Print
  //     bytes += generator.image(image);
  //     bytes += generator.text('PT. International Chemical Industry', styles: const PosStyles(align: PosAlign.center, bold: true));
  //     bytes += generator.text('Jl. Daan Mogot km. 11, Cengkareng', styles: const PosStyles(align: PosAlign.center));
  //     bytes += generator.text('Jakarta Barat, 11710', styles: const PosStyles(align: PosAlign.center));
  //     bytes += generator.feed(1);
  //     bytes += generator.text('TANDA TERIMA BARANG', styles: const PosStyles(align: PosAlign.center, bold: true));
  //     bytes += generator.feed(1);
  //     bytes += generator.text('No        : (No Order)');
  //     bytes += generator.text('Tgl       : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(now)}');
  //     bytes += generator.text('Langganan : $fdNamaLangganan');
  //     bytes += generator.text('Alamat    : $fdAlamat');
  //     bytes += generator.text('No. Cust. : $fdKodeLangganan');
  //     bytes += generator.text('No. SJ    : (No SJ)'); 
  //     bytes += generator.text('Payment   : (Payment)'); 

  //     bytes += generator.hr();
      
  //     // Loop di list item order
  //     for (int index = 0; index < listKeranjang.length; index++) {
  //       var barang = listKeranjang[index];

  //       bytes += generator.text('${barang.fdKodeBarang} - ${barang.fdNamaBarang}${barang.fdPromosi =='1'? ' (PROMO)' : ''}');

  //       bytes += generator.row([
  //         PosColumn(
  //           text: '${param.enNumberFormatQty.format(barang.fdQty)} ${barang.fdNamaJenisSatuan.toString().trimRight()}',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.left),
  //         ),
  //         PosColumn(
  //           text: param.enNumberFormat.format(barang.fdQty * barang.fdUnitPrice),
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         )
  //       ]);

  //       bytes += generator.row([
  //         PosColumn(
  //           text: '@${param.enNumberFormat.format(barang.fdUnitPrice)}',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.left),
  //         ),
  //         PosColumn(
  //           text: '',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         )
  //       ]);

  //       bytes += generator.row([
  //         PosColumn(
  //           text: 'Diskon',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: '(${barang.fdPromosi == '0'? param.enNumberFormat.format(barang.fdDiscount) : param.enNumberFormat.format(barang.fdQty * barang.fdUnitPrice)})',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         )
  //       ]);

  //       bytes += generator.row([
  //         PosColumn(
  //           text: 'Netto',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: barang.fdPromosi =='0'? param.enNumberFormat.format((barang.fdUnitPrice * barang.fdQty) - barang.fdDiscount) : '0',
  //           width: 6,
  //           styles: const PosStyles(align: PosAlign.right),
  //         )
  //       ]);     

  //       bytes += generator.feed(1);
  //     }

  //     bytes += generator.hr();

  //     bytes += generator.row([
  //       PosColumn(
  //         text: 'Total Barang:',
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: param.enNumberFormatQty.format(listKeranjang.length),
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       )
  //     ]);
  //     bytes += generator.row([
  //       PosColumn(
  //         text: 'Total Bruto:',
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: param.enNumberFormat.format(totalPesanan),
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       )
  //     ]);
  //     bytes += generator.row([
  //       PosColumn(
  //         text: 'Diskon 1:',
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: param.enNumberFormat.format(totalDiscount),
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       )
  //     ]);
  //     bytes += generator.row([
  //       PosColumn(
  //         text: 'Diskon 2:',
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: param.enNumberFormat.format(totalPromosiExtra),
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       )
  //     ]);
  //     bytes += generator.row([
  //       PosColumn(
  //         text: 'Total Netto:',
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       ),
  //       PosColumn(
  //         text: param.enNumberFormat.format(totalPesanan - totalDiscount - totalPromosiExtra),
  //         width: 6,
  //         styles: const PosStyles(align: PosAlign.right),
  //       )
  //     ]);
      
  //     bytes += generator.feed(1);
  //     bytes += generator.cut();
  //     bool bResult = await PrintBluetoothThermal.writeBytes(bytes);
  //     print('print result: $bResult');

  //     return  bResult? '' : 'Gagal print. Periksa koneksi printer Bluetooth!';
  //   } else {
  //     return 'Bluetooth tidak aktif. Aktifkan Bluetooth terlebih dahulu!';
  //   }
  // }