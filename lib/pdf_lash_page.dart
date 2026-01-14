import 'dart:io';
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
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'pdf_lash_page.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PreviewLashPage extends StatefulWidget {
  final msf.Salesman user;
  final String routeName;
  final String startDayDate;

  const PreviewLashPage({
    super.key,
    required this.user,
    required this.startDayDate,
    required this.routeName,
  });

  @override
  State<PreviewLashPage> createState() => LayerPreviewLashPageState();
}

class LayerPreviewLashPageState extends State<PreviewLashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autoDownloadPDF();
      
    });
  }

  Future<void> autoDownloadPDF() async {
    final bytes = await generateLashPdf();

    await savePdfAuto(bytes);
    await deleteOldPdfsByFileName(await getDownloadDirectory());
  }

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      }
    }
    return await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview PDF LASH")),
      body: PdfPreview(
        build: (format) => generateLashPdf(),
        canChangeOrientation: true,
        canChangePageFormat: true,
        pdfFileName:
            "Laporan_LASH_${widget.startDayDate.replaceAll('-', '')}.pdf",
        // onPrinted: (context) async {
        //   final bytes = await generateSalesReport();
        //   await savePdfAuto(bytes);
        // },
      ),
    );
  }

  Future<void> savePdfAuto(Uint8List bytes) async {
    // final dir = await getApplicationDocumentsDirectory();
    final dir = await getDownloadDirectory(); // ke folder download
    // final file = File("${param.appDir}/Laporan_LASH.pdf");
    
    final file = File(
        '${dir.path}/LASH_${widget.user.fdKodeSF}_${widget.startDayDate.replaceAll('-', '')}.pdf');
    await file.writeAsBytes(bytes);

    // auto buka file
    OpenFile.open(file.path);
  }
  Future<void> deleteOldPdfsByFileName(Directory dir) async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(Duration(days: 0));

    
      List<FileSystemEntity> files = dir.listSync();

      for (var entity in files) {
        if (entity is File && entity.path.contains('LASH_')) {
          String fileName = entity.path.split('/').last; 
          try {
            String datePartWithExt = fileName.split('_').last; 
            String dateString = datePartWithExt.split('.').first; 
            if (dateString.length == 8) {
              int year = int.parse(dateString.substring(0, 4));
              int month = int.parse(dateString.substring(4, 6));
              int day = int.parse(dateString.substring(6, 8));
              
              DateTime fileDate = DateTime(year, month, day);
              if (fileDate.isBefore(sevenDaysAgo) || fileDate.isAtSameMomentAs(sevenDaysAgo)) {
                await entity.delete();
                print("Berhasil menghapus file lama: $fileName");
              }
            }
          } catch (e) {
            
            continue;
          }
        }
      }
    } catch (e) {
      print("Error saat membersihkan file: $e");
    }
  }

  // ============================
  //  GENERATE PDF
  // ============================

  Future<Uint8List> generateLashPdf() async {
    final PdfDocument document = PdfDocument();
// final PdfPage page = document.pages.add();
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfPage page = document.pages.add();

    final PdfFont headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont boldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
    final PdfFont textBoldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
    final PdfFont textFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    // ========================= HEADER =========================
    page.graphics.drawString('PT. INTERNATIONAL CHEMICAL INDUSTRY', boldFont,
        bounds: const Rect.fromLTWH(0, 0, 0, 0));
    page.graphics.drawString(
        'KANTOR / DEPO : ${widget.user.fdNamaDepo}', textFont,
        bounds: const Rect.fromLTWH(0, 20, 0, 0));
    page.graphics.drawString(
        'SALES : ${widget.user.fdKodeSF} - ${widget.user.fdNamaSF}', textFont,
        bounds: const Rect.fromLTWH(0, 40, 0, 0));

    page.graphics.drawString('\n', textFont,
        bounds: const Rect.fromLTWH(350, 0, 200, 20));
    page.graphics.drawString(
        'No LASH : ${widget.user.fdKodeSF}${widget.startDayDate.replaceAll('-', '')}',
        textFont,
        bounds: const Rect.fromLTWH(350, 20, 200, 20));
    page.graphics.drawString(
        'TANGGAL : ${param.dtFormatViewMMM.format(param.dtFormatDB.parse(widget.startDayDate))}',
        textFont,
        bounds: const Rect.fromLTWH(350, 40, 200, 20));
    page.graphics.drawString(
        'Printed On : ${param.dateTimeFormatViewMMM.format(DateTime.now())}',
        textFont,
        bounds: const Rect.fromLTWH(600, 20, 200, 20));

    page.graphics.drawString('LAPORAN AKTIVITAS SALES HARIAN', headerFont,
        bounds: const Rect.fromLTWH(300, 60, 0, 0));

    // ========================= TABEL =========================
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 14);

    // AUTO FIT COLUMN WIDTH
    // for (int i = 0; i < grid.columns.count; i++) {
    //   grid.columns[i].width = double.nan; // Auto-fit column
    // }

    // --- HEADER ROW 1 (dengan MERGE) ---
    grid.headers.add(2);
    PdfGridRow h1 = grid.headers[0];
    PdfGridRow h2 = grid.headers[1];

    // Baris 1
    h1.cells[0].value = 'No';
    h1.cells[1].value = 'LANGGANAN';
    h1.cells[3].value = 'FAKTUR TAGIHAN';
    h1.cells[6].value = 'PENJUALAN';
    h1.cells[8].value = 'PEMBAYARAN';
    h1.cells[12].value = 'SALDO PIUTANG';
    h1.cells[13].value = 'Ket';

    // merge langganan (colspan 2)
    h1.cells[1].columnSpan = 2;

    // merge faktur tagihan (colspan 2)
    h1.cells[3].columnSpan = 3;

    // merge penjualan (colspan 2)
    h1.cells[6].columnSpan = 2;

    // merge pembayaran (colspan 4)
    h1.cells[8].columnSpan = 4;

    // merge rows untuk No, Saldo, Ket
    h1.cells[0].rowSpan = 2;
    h1.cells[12].rowSpan = 2;
    h1.cells[13].rowSpan = 2;

    // SET WIDTH COLUMN
    grid.columns[0].width = 20;
    grid.columns[1].width = 50;
    grid.columns[3].width = 50;
    grid.columns[4].width = 50;

    // SET ALIGNMENT COLUMN
    final PdfStringFormat centerStyle = PdfStringFormat(
      alignment: PdfTextAlignment.center, // Center horizontally
      lineAlignment: PdfVerticalAlignment.middle, // Center vertically
    );
    final PdfStringFormat rightStyle = PdfStringFormat(
      alignment: PdfTextAlignment.right, // Center horizontally
      lineAlignment: PdfVerticalAlignment.middle, // Center vertically
    );
    grid.columns[0].format = centerStyle;
    grid.columns[1].format = centerStyle;
    grid.columns[2].format = centerStyle;
    grid.columns[3].format = centerStyle;
    grid.columns[4].format = centerStyle;
    grid.columns[5].format = rightStyle;
    grid.columns[6].format = centerStyle;
    grid.columns[7].format = rightStyle;
    grid.columns[8].format = rightStyle;
    grid.columns[9].format = rightStyle;
    grid.columns[10].format = rightStyle;
    grid.columns[11].format = rightStyle;
    grid.columns[12].format = rightStyle;
    grid.columns[13].format = centerStyle;

    // --- HEADER ROW 2 ---
    List<String> subHeader = [
      "", // No (merged)
      "KODE",
      "NAMA",
      "TGL",
      "NOMOR",
      "JUMLAH",
      "NO.FAKTUR",
      "NILAI",
      "TUNAI Rp",
      "GIRO",
      "CHEQUE",
      "TRANSFER",
      "",
      "" // ket (merged)
    ];

    for (int i = 1; i < 14; i++) {
      h2.cells[i].value = subHeader[i];
    }

    // --- STYLE HEADER ---
    for (int r = 0; r < 2; r++) {
      PdfGridRow row = grid.headers[r];
      for (int i = 0; i < row.cells.count; i++) {
        row.cells[i].style = PdfGridCellStyle(
          font: boldFont,
          backgroundBrush: PdfBrushes.lightGray,
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle,
            wordWrap: PdfWordWrapType.word,
          ),
        );
      }
    }

    // ==== ISI TABEL ====
    List<mpiu.FakturApi> listLash = [];
    if (widget.user.fdTipeSF == '1') {
      listLash = await cpiu.getCetakanLash();
    } else {
      listLash = await cpiu.getCetakanLashTO();
    }
    int no = 0;
    double tTagihan = 0;
    double tSales = 0;
    double tTunai = 0;
    double tGiro = 0;
    double tCheque = 0;
    double tTransfer = 0;
    double tPiutang = 0;
    String stTagihan = '';
    String stSales = '';
    String stTunai = '';
    String stGiro = '';
    String stCheque = '';
    String stTransfer = '';

    String stPiutang = '';

    for (var item in listLash) {
      no++;

      final double tagihan = item.tagihan ?? 0;
      final double tunai = item.tunai ?? 0;
      final double giro = item.giro ?? 0;
      final double cheque = item.cheque ?? 0;
      final double transfer = item.transfer ?? 0;

      final double piutang =
          (tagihan + item.fdNetto) - (tunai + giro + cheque + transfer);

      PdfGridRow row = grid.rows.add();

      tTagihan += tagihan;
      tSales += item.fdNetto;
      tTunai += tunai;
      tGiro += giro;
      tCheque += cheque;
      tTransfer += transfer;
      tPiutang += piutang;

      row.cells[0].value = no.toString();
      row.cells[1].value = item.fdKodeLangganan ?? "";
      row.cells[2].value = item.fdNamaLangganan ?? "";
      row.cells[3].value = item.fdTanggalFaktur ?? "";
      row.cells[4].value = tagihan > 0 ? item.fdNoFaktur.toString() : "";
      row.cells[5].value =
          tagihan > 0 ? param.enNumberFormat.format(tagihan).toString() : "";
      row.cells[6].value = item.fdNetto > 0 ? item.fdNoFaktur.toString() : "";
      row.cells[7].value = item.fdNetto > 0
          ? param.enNumberFormat.format(item.fdNetto).toString()
          : "";
      row.cells[8].value =
          tunai > 0 ? param.enNumberFormat.format(tunai).toString() : "";
      row.cells[9].value =
          giro > 0 ? param.enNumberFormat.format(giro).toString() : "";
      row.cells[10].value =
          cheque > 0 ? param.enNumberFormat.format(cheque).toString() : "";
      row.cells[11].value =
          transfer > 0 ? param.enNumberFormat.format(transfer).toString() : "";
      row.cells[12].value =
          piutang > 0 ? param.enNumberFormat.format(piutang).toString() : "";
      row.cells[13].value = item.fdKeterangan ?? "";
    }

    // ================== BARIS TOTAL ==================
    PdfGridRow total = grid.rows.add();
    total.cells[0].value = "TOTAL";
    total.cells[0].columnSpan = 3;

    total.cells[3].value = "TAGIHAN";
    total.cells[3].columnSpan = 2;
    total.cells[6].value = "PENJUALAN";

    if (tTagihan > 0) {
      stTagihan = param.enNumberFormat.format(tTagihan).toString();
    } else {
      stTagihan = '';
    }
    if (tSales > 0) {
      stSales = param.enNumberFormat.format(tSales).toString();
    } else {
      stSales = '';
    }
    if (tTunai > 0) {
      stTunai = param.enNumberFormat.format(tTunai).toString();
    } else {
      stTunai = '';
    }
    if (tGiro > 0) {
      stGiro = param.enNumberFormat.format(tGiro).toString();
    } else {
      stGiro = '';
    }
    if (tCheque > 0) {
      stCheque = param.enNumberFormat.format(tCheque).toString();
    } else {
      stCheque = '';
    }
    if (tTransfer > 0) {
      stTransfer = param.enNumberFormat.format(tTransfer).toString();
    } else {
      stTransfer = '';
    }
    if (tPiutang > 0) {
      stPiutang = param.enNumberFormat.format(tPiutang).toString();
    } else {
      stPiutang = '';
    }
    total.cells[5].value = stTagihan;
    total.cells[7].value = stSales;
    total.cells[8].value = stTunai;
    total.cells[9].value = stGiro;
    total.cells[10].value = stCheque;
    total.cells[11].value = stTransfer;
    total.cells[12].value = stPiutang;

    for (int i = 0; i < 14; i++) {
      if (i == 0 || i == 3 || i == 6) {
        total.cells[i].style = PdfGridCellStyle(
          font: textBoldFont,
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle,
            wordWrap: PdfWordWrapType.word,
          ),
        );
      } else {
        total.cells[i].style = PdfGridCellStyle(
          font: textBoldFont,
          format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle,
            wordWrap: PdfWordWrapType.word,
          ),
        );
      }
    }

    // ================== DRAW TABLE ==================
    final PdfLayoutResult layout = grid.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 90, 0, 0),
      format: PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
        breakType: PdfLayoutBreakType.fitPage,
      ),
    )!;

    // ================== FOOTER TANDA TANGAN ==================
    double y = layout.bounds.bottom + 20;

    PdfGrid sign = PdfGrid();
    sign.columns.add(count: 4);
    sign.headers.add(1);

    PdfGridRow sh = sign.headers[0];
    sh.cells[0].value = "DIBUAT OLEH :";
    sh.cells[1].value = "DITERIMA OLEH :";
    sh.cells[3].value = "DIKETAHUI OLEH :";

    sign.columns[0].width = 240;
    sign.columns[1].width = 120;
    sign.columns[2].width = 120;
    sign.columns[3].width = 240;

    sh.cells[1].columnSpan = 2;

    for (int i = 0; i < 4; i++) {
      sh.cells[i].style = PdfGridCellStyle(
        font: boldFont,
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );
    }

    PdfGridRow sr = sign.rows.add();
    sr.cells[0].value = "\n\n\n\n\n\n\n${widget.user.fdNamaSF}";
    sr.cells[1].value = "\n\n\n\n\n\n\nADM";
    sr.cells[2].value = "\n\n\n\n\n\n\nKASIR";
    sr.cells[3].value = "\n\n\n\n\n\n\nATASAN";

    sign.columns[0].format = centerStyle;
    sign.columns[1].format = centerStyle;
    sign.columns[2].format = centerStyle;
    sign.columns[3].format = centerStyle;

    sign.draw(page: page, bounds: Rect.fromLTWH(40, y, 0, 0));

    // ================== SAVE ==================
    final bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }
}
