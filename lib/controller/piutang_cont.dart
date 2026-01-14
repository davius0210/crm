import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as chttp;
import 'package:path/path.dart' as cpath;
import '../models/database.dart' as mdbconfig;
import '../models/piutang.dart' as mpiu;
import '../models/barang.dart' as mbrg;
import '../models/distcenter.dart' as mstokdc;
import '../models/globalparam.dart' as param;

Future<void> createtblPiuDagang(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblPiuDagang} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, fdTipePiutang varchar(3), '
        'fdNoEntryFaktur varchar(30), fdNoFaktur varchar(30), fdDepo varchar(3), '
        'fdTanggalFaktur varchar(30), fdTanggalJT varchar(30), fdKodeLangganan varchar(30), '
        'fdBayar REAL, fdGiro REAL, fdGiroTolak REAL, fdKodeStatus int, fdTglStatus varchar(30), fdStatusRecord int, '
        'fdNoUrutFaktur varchar(30), fdNoEntrySJ varchar(30), fdNoUrutSJ varchar(30), fdKodeBarang varchar(30), '
        'fdPromosi varchar(30), fdReplacement varchar(30), fdJenisSatuan varchar(30), fdSatuan int, '
        'fdQty REAL, fdUnitPrice REAL, fdUnitPricePPN REAL, fdBrutto REAL, fdDiscount REAL, fdNetto REAL, '
        'fdDPP REAL, fdPPN REAL, fdNamaBarang varchar(300), '
        'fdTanggalKirim varchar(30), fdNoEntryOrder varchar(30), fdNoOrder varchar(30), fdTanggalOrder varchar(30), '
        'fdLimitKredit REAL, fdKodeTransaksiFP varchar(30), '
        'fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createtblPayment(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblPayment} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
        fdNoEntryFaktur varchar(30), fdDepo varchar(3), fdTanggal varchar(30),
        fdIdCollection INTEGER, fdKodeLangganan varchar(30),
        fdAllocationAmount REAL, fdStatusSent int, fdLastUpdate varchar(20),
        UNIQUE(fdNoEntryFaktur, fdDepo, fdIdCollection, fdKodeLangganan))''');
  });
}

Future<void> createtblFileBuktiTransfer(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblFileBuktiTransfer} (fdNoEntry varchar(30), fdNoFaktur varchar(30), 
          fdNoEntryFaktur varchar(30), fdDepo varchar(4), fdKodeLangganan varchar(30), fdJenis varchar(10), 
          fdPath varchar(500), fdTanggal varchar(30), fdUrut INT, fdStatusSent INT, fdLastUpdate varchar(25) )''');
  });
}

Future<void> createtblFaktur(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblFaktur} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
          fdNoEntryFaktur varchar(30), fdDepo varchar(3), fdJenisFaktur varchar(3), fdNoFaktur varchar(30), 
          fdNoOrder varchar(30), fdTanggalOrder varchar(30), fdTanggalKirim varchar(30), isTagihan int,
          fdTanggalFaktur varchar(30), fdTOP int, fdTanggalJT varchar(30), fdKodeLangganan varchar(30),
          fdNoEntryProforma varchar(30), fdFPajak  varchar(1), fdPPH REAL, fdKeterangan varchar(300),
          fdMataUang varchar(5), fdKodeSF varchar(30), fdKodeAP1 varchar(30), fdKodeAP2 varchar(30),
          fdReasonNotApprove int, fdDisetujuiOleh varchar(50), fdKodeStatus int, fdTglStatus varchar(30),
          fdKodeGudang varchar(20), fdNoOrderSFA varchar(30), fdTglSFA varchar(30), fdStatusRecord int,
          fdStatusSent INT, fdLastUpdate varchar(25),
          UNIQUE(fdNoEntryFaktur) )''');
  });
}

Future<void> createtblFakturItem(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblFakturItem} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
          fdNoEntryFaktur varchar(30), fdNoUrutFaktur int, fdNoEntrySJ varchar(30), fdNoUrutSJ int, 
          fdNoEntryProforma varchar(30), fdNoUrutProforma int, fdKodeBarang varchar(30), fdPromosi varchar(3),
          fdReplacement int, fdJenisSatuan varchar(3), fdQty REAL, fdUnitPrice REAL, fdQtyK REAL, fdUnitPriceK REAL,
          fdBrutto REAL, fdDiscount REAL, fdDiscountDetail varchar(300), fdNetto REAL, fdDPP REAL, 
          fdPPN REAL, fdNoPromosi varchar(30), fdStatusRecord int,  
          fdStatusSent INT, fdLastUpdate varchar(25), fdHargaAsli REAL, 
          UNIQUE(fdNoEntryFaktur, fdNoUrutFaktur, fdNoEntrySJ, fdNoUrutSJ) )''');
  });
}

Future<void> createtblSuratJalan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSuratJalan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
          fdNoEntrySJ varchar(30), fdDepo varchar(5), fdJenisSJ varchar(2), fdNoSJ varchar(20), 
          fdTanggalSJ varchar(30), fdKodeLangganan varchar(30), fdKodeSF varchar(30), fdKodeAP1 varchar(30), 
          fdKodeAP2 varchar(30), fdKodeGudang varchar(12), fdKodeGudangTujuan varchar(12), 
          fdNoEntryProforma varchar(30), fdAlamatKirim varchar(350), fdKeterangan varchar(350), 
          fdNoPolisi varchar(12), fdKodeEkspedisi varchar(30), fdSupirNama varchar(50),
          fdSupirKTP varchar(20), fdArmada varchar(50), fdETD varchar(30), fdETA varchar(30),
          fdNoContainer varchar(50), fdNoSeal varchar(100), fdAktTglKirim varchar(30), fdAktTglTiba varchar(30),
          fdAktTglSerah varchar(30), fdKeteranganPengiriman varchar(100), fdIsFaktur int, fdKodeStatus int,
          fdTglStatus varchar(30), fdKodeStatusGit int, fdTanggalLPB varchar(30),
          fdNoLPB varchar(20), fdKeteranganLPB varchar(100), fdUserLPB varchar(15), fdNoEntryLama varchar(15),
          fdStatusRecord int, fdStatusSent INT, fdLastUpdate varchar(25) )''');
  });
}

Future<void> createtblSuratJalanItem(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSuratJalanItem} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
          fdNoEntrySJ varchar(30), fdNoUrutSJ int, fdNoEntryOrder varchar(30), fdNoUrutOrder int, 
          fdNoEntryProforma varchar(30), fdNoUrutProforma int, fdKodeBarang varchar(10), fdPromosi varchar(3), 
          fdReplacement int, fdJenisSatuan varchar(3), fdQty REAL, fdQtyK REAL, fdPalet REAL, fdDetailPalet varchar(500), 
          fdNetWeight REAL, fdGrossWeight REAL, fdVolume REAL, fdNotes varchar(50), 
          fdCartonNo varchar(50), fdQtyJual REAL, fdRusakB REAL, fdRusakS REAL, 
          fdRusakK REAL, fdSisaB REAL, fdSisaS REAL, fdSisaK REAL, 
          fdStatusRecord int, fdStatusSent INT, fdLastUpdate varchar(25) )''');
  });
}

Future<void> createtblSuratJalanItemDetail(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSuratJalanItemDetail} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, 
          fdNoEntrySJ varchar(30), fdNoUrutSJ varchar(30), fdKodeBarang varchar(10), fdDateCode varchar(15) ,
          fdPromosi varchar(5), fdJenisSatuan int, fdQty REAL, fdQtyK REAL, 
          fdStatusRecord int, fdStatusSent INT, fdLastUpdate varchar(25) )''');
  });
}

Future<void> insertPiutangBatch(List<mpiu.Piutang> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPiuDagang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdTipePiutang': element.fdTipePiutang,
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdNoFaktur': element.fdNoFaktur,
          'fdDepo': element.fdDepo,
          'fdTanggalFaktur': element.fdTanggalFaktur,
          'fdTanggalJT': element.fdTanggalJT,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdBayar': element.fdBayar,
          'fdGiro': element.fdGiro,
          'fdGiroTolak': element.fdGiroTolak,
          'fdKodeStatus': element.fdKodeStatus,
          'fdTglStatus': element.fdTglStatus,
          'fdStatusRecord': element.fdStatusRecord,
          'fdNoUrutFaktur': element.fdNoUrutFaktur,
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdSatuan': element.fdSatuan,
          'fdQty': element.fdQty,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPricePPN': element.fdUnitPricePPN,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdNetto': element.fdNetto,
          'fdDPP': element.fdDPP,
          'fdPPN': element.fdPPN,
          'fdNamaBarang': element.fdNamaBarang,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdNoOrder': element.fdNoOrder,
          'fdTanggalOrder': element.fdTanggalOrder,
          'fdLimitKredit': element.fdLimitKredit,
          'fdKodeTransaksiFP': element.fdKodeTransaksiFP,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblPiuDagang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> savePaymentBatch(final items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPayment}');

      for (var element in items.values) {
        for (var elementDetail in element['detailAllocation']) {
          Map<String, dynamic> item = {
            'fdNoEntryFaktur': element['fdNoEntryFaktur'],
            'fdDepo': element['fdDepo'],
            'fdTanggal': element['fdTanggal'],
            'fdAllocationAmount': elementDetail['fdAllocationAmount'],
            'fdIdCollection': elementDetail['fdIdCollection'],
            'fdKodeLangganan': element['fdKodeLangganan'],
            'fdStatusSent': 0,
            'fdLastUpdate': param.dateTimeFormatDB.format(DateTime.now()),
          };

          batchTx.insert(mdbconfig.tblPayment, item);
        }
      }

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<double> getTotalTagihan(String fdKodeLangganan) async {
  late Database db;
  String kodeTransaksiFP = '';
  double totalJumlah = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan=? '
          'ORDER BY a.fdID',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          kodeTransaksiFP = element['fdKodeTransaksiFP'].toString();
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        if (kodeTransaksiFP == '07') {
          totalJumlah = totalDPP;
        } else {
          totalJumlah = totalDPP + totalPPN;
        }
        sisaTagihan = totalJumlah - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

// Future<double> getSisaLimitKredit(String fdKodeLangganan) async {
//   late Database db;
//   String kodeTransaksiFP = '';
//   double totalJumlah = 0;
//   double totalBayar = 0;
//   double totalDPP = 0;
//   double totalPPN = 0;
//   double sisaTagihan = 0;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       List<Map<String, dynamic>> results = [];
//       results = await txn.rawQuery(
//           'SELECT a.* '
//           'FROM ${mdbconfig.tblPiuDagang} a '
//           'WHERE a.fdKodeLangganan=? '
//           'ORDER BY a.fdID',
//           [fdKodeLangganan]);

//       if (results.isNotEmpty) {
//         for (var element in results) {
//           kodeTransaksiFP = element['fdKodeTransaksiFP'].toString();
//           totalBayar = element['fdBayar'];
//           totalDPP += element['fdDPP'];
//           totalPPN += element['fdPPN'];
//         }
//         if (kodeTransaksiFP == '07') {
//           totalJumlah = totalDPP;
//         } else {
//           totalJumlah = totalDPP + totalPPN;
//         }
//         sisaTagihan = totalJumlah - totalBayar;
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return sisaTagihan;
// }

Future<List<mpiu.Piutang>> getAllPiutang(String fdKodeLangganan) async {
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT fdNoEntryFaktur, fdNoOrder, fdNoFaktur, fdTanggalJT, fdKodeTransaksiFP, sum(fdNetto) as fdNetto, sum(fdBayar) as fdBayar '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan=? '
          'group by fdNoOrder, fdNoFaktur, fdTanggalJT, fdKodeTransaksiFP '
          'ORDER BY a.fdTanggalJT DESC ',
          [fdKodeLangganan]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mpiu.Piutang>> getAllDataPiutang(String fdKodeLangganan) async {
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('''SELECT 
              a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur, f.fdTanggalFaktur ,
              f.fdNetto, fdTanggalJT, fdKodeBarang  ,fdPromosi ,fdJenisSatuan ,fdQty ,
              fdUnitPrice ,fdUnitPricePPN ,fdBrutto ,fdDiscount ,fdNetto ,fdDPP ,fdPPN ,fdNoEntryOrder ,
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
            FROM ${mdbconfig.tblLangganan} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            INNER JOIN ${mdbconfig.tblPiuDagang} f on f.fdKodeLangganan = a.fdKodeLangganan 
            WHERE a.fdKodeLangganan=? ''', [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<bool> checkIsDoubleBon(
    String fdKodeLangganan, String startDayDate) async {
  late Database db;
  bool isExistsDoubleBon = false;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      // results = await txn.rawQuery(
      //     'SELECT * '
      //     'FROM ${mdbconfig.tblPiuDagang} a '
      //     'WHERE a.fdKodeLangganan=? and date(a.fdTanggalJT) < date(?) ',
      //     [fdKodeLangganan, startDayDate]);
      results = await txn.rawQuery('''SELECT 
              IFNULL((SUM(a.fdNetto) - SUM(a.fdBayar)),0) AS totalTagihan,
              IFNULL(SUM(b.fdAllocationAmount),0) AS fdAllocationAmount
          FROM ${mdbconfig.tblPiuDagang} a
          LEFT JOIN ${mdbconfig.tblPayment} b
              ON b.fdNoEntryFaktur = a.fdNoEntryFaktur
              AND b.fdDepo = a.fdDepo
              AND b.fdKodeLangganan = a.fdKodeLangganan
          WHERE a.fdKodeLangganan=? and date(a.fdTanggalJT) < date(?)
          ''', [fdKodeLangganan, startDayDate]);
      if (results.isNotEmpty) {
        if (results.first['totalTagihan'] >
            results.first['fdAllocationAmount']) {
          isExistsDoubleBon = true;
        } else {
          isExistsDoubleBon = false;
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return isExistsDoubleBon;
}

Future<List<mpiu.Payment>> getAllPaymentDetail(
    String fdKodeLangganan, String fdNoEntryFaktur, String fdMenu) async {
  late Database db;
  List<mpiu.Payment> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      if (fdMenu == 'noocanvas') {
        // results = await txn.rawQuery(
        //     'SELECT a.fdNoEntryFaktur, a.fdNoFaktur, a.fdDepo, a.fdTanggalFaktur, '
        //     ' a.fdTanggalJT, c.fdNetto, b.fdAllocationAmount, b.fdIdCollection '
        //     ' FROM ${mdbconfig.tblFaktur} a '
        //     ' LEFT JOIN ${mdbconfig.tblPayment} b ON b.fdNoEntryFaktur = a.fdNoEntryFaktur '
        //     ' INNER JOIN (SELECT fdNoEntryFaktur, sum(fdNetto) as fdNetto '
        //     ' FROM ${mdbconfig.tblFakturItem} g WHERE fdPromosi="0" '
        //     ' GROUP BY g.fdNoEntryFaktur ) c ON c.fdNoEntryFaktur = a.fdNoEntryFaktur '
        //     ' WHERE a.fdKodeLangganan=? '
        //     'ORDER BY a.fdTanggalJT DESC ',
        //     [fdKodeLangganan]);

        // results = await txn.rawQuery(
        //     'SELECT a.fdNoEntryFaktur, a.fdNoFaktur, a.fdDepo, a.fdTanggalFaktur, '
        //     ' a.fdTanggalJT, c.fdNetto, b.fdAllocationAmount, b.fdIdCollection '
        //     ' FROM ${mdbconfig.tblFaktur} a '
        //     ' LEFT JOIN ${mdbconfig.tblPayment} b ON b.fdNoEntryFaktur = a.fdNoEntryFaktur '
        //     ' INNER JOIN (SELECT fdNoEntryFaktur, sum(fdNetto) as fdNetto '
        //     ' FROM ${mdbconfig.tblFakturItem} g WHERE fdPromosi="0" and fdNoEntryFaktur=? '
        //     ' GROUP BY g.fdNoEntryFaktur ) c ON c.fdNoEntryFaktur = a.fdNoEntryFaktur '
        //     ' WHERE a.fdNoEntryFaktur=? '
        //     'ORDER BY a.fdTanggalJT DESC ',
        //     [fdNoEntryFaktur, fdNoEntryFaktur]);

        results = await txn.rawQuery('''SELECT 
    x.fdIdCollection,    
    x.fdNoEntryFaktur,
    x.fdNoFaktur,
    x.fdDepo,
    x.fdTanggalFaktur,
    x.fdTanggalJT,
    x.totalTagihan as fdNetto,
    IFNULL(SUM(x.fdAllocationAmount),0) AS fdAllocationAmount,
    (x.totalTagihan - IFNULL(SUM(x.fdAllocationAmount),0)) AS sisaTagihan
FROM ( 
    SELECT 
        a.fdNoEntryFaktur,
        a.fdNoFaktur,
        a.fdDepo,
        a.fdTanggalFaktur,
        a.fdTanggalJT,
        (SUM(a.fdNetto) - SUM(a.fdBayar)) AS totalTagihan,
        b.fdAllocationAmount,
        b.fdIdCollection 
    FROM ${mdbconfig.tblPiuDagang} a
    LEFT JOIN ${mdbconfig.tblPayment} b
        ON b.fdNoEntryFaktur = a.fdNoEntryFaktur
        AND b.fdDepo = a.fdDepo
        AND b.fdKodeLangganan = a.fdKodeLangganan
    WHERE a.fdKodeLangganan = ?
    GROUP BY a.fdNoEntryFaktur, a.fdNoFaktur, a.fdDepo, a.fdTanggalFaktur, a.fdTanggalJT
    UNION ALL 
    SELECT 
        f.fdNoEntryFaktur,
        f.fdNoFaktur,
        f.fdDepo,
        f.fdTanggalFaktur,
        f.fdTanggalJT,
        SUM(i.fdNetto) AS totalTagihan,
        p.fdAllocationAmount,
        p.fdIdCollection 
    FROM ${mdbconfig.tblFaktur} f
    INNER JOIN ${mdbconfig.tblFakturItem} i
        ON i.fdNoEntryFaktur = f.fdNoEntryFaktur
        AND i.fdPromosi = '0'
    LEFT JOIN ${mdbconfig.tblPayment} p
        ON p.fdNoEntryFaktur = f.fdNoEntryFaktur
        AND p.fdDepo = f.fdDepo
        AND p.fdKodeLangganan = f.fdKodeLangganan
    WHERE f.fdKodeLangganan = ?
    GROUP BY f.fdNoEntryFaktur, f.fdNoFaktur, f.fdDepo, f.fdTanggalFaktur, f.fdTanggalJT
) x
GROUP BY 
    x.fdNoEntryFaktur,
    x.fdNoFaktur,
    x.fdDepo,
    x.fdTanggalFaktur,
    x.fdTanggalJT,
    x.totalTagihan
ORDER BY x.fdTanggalJT DESC''', [fdKodeLangganan, fdKodeLangganan]);
      } else if (fdMenu == 'piutangedit') {
        results = await txn.rawQuery(
            'SELECT a.fdNoEntryFaktur, a.fdNoFaktur, a.fdDepo, a.fdTanggalFaktur, '
            ' a.fdTanggalJT, a.fdNetto, b.fdAllocationAmount, b.fdIdCollection '
            'FROM '
            ' (SELECT fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, '
            ' fdKodeLangganan, fdTanggalJT, (sum(fdNetto) - sum(fdBayar)) as fdNetto '
            ' FROM ${mdbconfig.tblPiuDagang} '
            ' WHERE fdKodeLangganan=? '
            ' GROUP BY fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, '
            ' fdKodeLangganan, fdTanggalJT) a '
            'LEFT JOIN ${mdbconfig.tblPayment} b '
            ' ON b.fdNoEntryFaktur = a.fdNoEntryFaktur '
            '   AND b.fdDepo = a.fdDepo '
            '   AND b.fdKodeLangganan = a.fdKodeLangganan '
            'ORDER BY a.fdTanggalJT DESC ',
            [fdKodeLangganan]);
      } else {
        results = await txn.rawQuery(
            'SELECT a.fdNoEntryFaktur, a.fdNoFaktur, a.fdDepo, a.fdTanggalFaktur, '
            ' a.fdTanggalJT, a.fdNetto, b.fdAllocationAmount, b.fdIdCollection '
            'FROM '
            ' (SELECT fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, '
            ' fdKodeLangganan, fdTanggalJT, (sum(fdNetto) - sum(fdBayar)) as fdNetto '
            ' FROM ${mdbconfig.tblPiuDagang} '
            ' WHERE fdKodeLangganan=? '
            ' GROUP BY fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, '
            ' fdKodeLangganan, fdTanggalJT) a '
            'LEFT JOIN ${mdbconfig.tblPayment} b '
            ' ON b.fdNoEntryFaktur = a.fdNoEntryFaktur '
            '   AND b.fdDepo = a.fdDepo '
            '   AND b.fdKodeLangganan = a.fdKodeLangganan '
            'ORDER BY a.fdTanggalJT DESC ',
            [fdKodeLangganan]);
      }
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Payment.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<double> getTotalAllocation(String fdKodeLangganan) async {
  late Database db;
  double totalAllocation = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
        'SELECT SUM(fdAllocationAmount) as total '
        'FROM ${mdbconfig.tblPayment} '
        'WHERE fdKodeLangganan = ?',
        [fdKodeLangganan],
      );
      if (results.isNotEmpty) {
        totalAllocation =
            double.tryParse(results.first['total'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return totalAllocation;
}

Future<double> getTotalAllocationByNoEntryFaktur(String fdNoEntryFaktur) async {
  late Database db;
  double totalAllocation = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
        'SELECT SUM(fdAllocationAmount) as total '
        'FROM ${mdbconfig.tblPayment} '
        'WHERE fdNoEntryFaktur = ?',
        [fdNoEntryFaktur],
      );
      if (results.isNotEmpty) {
        totalAllocation =
            double.tryParse(results.first['total'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return totalAllocation;
}

Future<double> getTotalTagihanSebelumJT(
    String fdKodeLangganan, String startDayDate) async {
  late Database db;
  String kodeTransaksiFP = '';
  double totalJumlah = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT >= ? '
          'ORDER BY a.fdID',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          kodeTransaksiFP = element['fdKodeTransaksiFP'].toString();
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        if (kodeTransaksiFP == '07') {
          totalJumlah = totalDPP;
        } else {
          totalJumlah = totalDPP + totalPPN;
        }
        sisaTagihan = totalJumlah - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

Future<double> getTotalTagihanJT(
    String fdKodeLangganan, String startDayDate) async {
  late Database db;
  String kodeTransaksiFP = '';
  double totalJumlah = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT < ? '
          'ORDER BY a.fdID',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          kodeTransaksiFP = element['fdKodeTransaksiFP'].toString();
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        if (kodeTransaksiFP == '07') {
          totalJumlah = totalDPP;
        } else {
          totalJumlah = totalDPP + totalPPN;
        }
        sisaTagihan = totalJumlah - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

Future<bool> isPiutangNotSent(String fdKodeLangganan) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan = ? AND fdStatusSent = 0',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mpiu.Piutang>> getDataByNoEntry(String fdNoEntryFaktur) async {
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT fdTipePiutang, fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, fdTanggalJT '
          ', fdKodeLangganan, fdBayar, fdGiro, fdGiroTolak '
          ', fdKodeStatus, fdTglStatus, fdStatusRecord '
          ', fdNoEntrySJ '
          ', fdKodeBarang,   fdReplacement '
          ', fdJenisSatuan '
          ', sum(fdQty) fdQty '
          ', fdUnitPrice '
          ', fdUnitPricePPN '
          ', sum(fdDPP) fdDPP '
          ', sum(fdPPN) fdPPN '
          ', fdNamaBarang, fdTanggalKirim, fdNoEntryOrder, fdNoOrder, fdTanggalOrder '
          ', fdSatuan '
          ', fdLimitKredit, fdKodeTransaksiFP '
          ', sum(fdDiscount) fdDiscount '
          ', sum(fdNetto) fdNetto '
          ', sum(fdBrutto) fdBrutto '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE fdNoEntryFaktur = ? '
          'group by fdTipePiutang, fdNoEntryFaktur, fdNoFaktur, fdDepo, fdTanggalFaktur, fdTanggalJT '
          '	, fdKodeLangganan, fdBayar, fdGiro, fdGiroTolak '
          '	, fdKodeStatus, fdTglStatus, fdStatusRecord '
          '	, fdNoEntrySJ'
          '	, fdKodeBarang,  fdReplacement '
          '	, fdJenisSatuan '
          '	, fdUnitPrice  '
          '	, fdUnitPricePPN '
          '	, fdNamaBarang, fdTanggalKirim, fdNoEntryOrder, fdNoOrder, fdTanggalOrder '
          '	, fdSatuan '
          '	, fdLimitKredit, fdKodeTransaksiFP '
          'ORDER BY a.fdID',
          [fdNoEntryFaktur]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<String> getNoEntry(String token, String? fdDepo, String? fdKodeSF,
    String? fdKodeLangganan) async {
  late Database db;
  int newFdKey = 0;
  String sNoSJ = '';

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);

  await db.transaction((txn) async {
    var cnt = await txn
        .rawQuery("SELECT count(*) as fdKey FROM ${mdbconfig.tblPiuDagang} ");
    newFdKey = int.parse(cnt[0]['fdKey'].toString()) + 1;
  });
  String formattedFdKey = newFdKey.toString().padLeft(4, '0');
  sNoSJ = '$fdDepo$fdKodeSF$fdKodeLangganan$formattedFdKey';

  return sNoSJ;
}

Future<int> deleteByNoEntry(String token, String fdNoEntry) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblPiuDagang} WHERE fdDocNo=? AND fdStatusSent = 0',
          [fdNoEntry]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<int> deleteFakturExt(String fdNoEntryFaktur) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblFileBuktiTransfer} WHERE fdNoEntryFaktur=? ',
          [fdNoEntryFaktur]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<int> updateDataByFdNoEntry(
    String stateIsGudang,
    String stateIsKomputer,
    int txtStockDC,
    int txtStdPiutang,
    int txtStockPajang,
    int txtStockGudang,
    int txtStockKomputer,
    String txtRootCause,
    String txtKeteranganRoot,
    String fdNoEntry) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE ${mdbconfig.tblPiuDagang} SET fdIsGudang=?, fdIsKomputer=?, fdQty=?, fdQtyPiutang=?, fdQtyPajang=?, fdQtyGudang=?, fdQtyKomputer=?, fdReason=?, fdRemark=?, fdLastUpdate=? WHERE fdDocNo=? ',
          [
            stateIsGudang,
            stateIsKomputer,
            txtStockDC,
            txtStdPiutang,
            txtStockPajang,
            txtStockGudang,
            txtStockKomputer,
            txtRootCause,
            txtKeteranganRoot,
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            fdNoEntry
          ]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<void> updateStatusSentPiutang(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblPiuDagang} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? ',
          [fdKodeLangganan]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mpiu.Piutang>> querySendDataPiutang(
    String fdKodeLangganan, String startDayDate) async {
  List<Map<String, dynamic>> results = [];
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblPiuDagang} WHERE fdKodeLangganan=? AND fdTanggal=? AND fdStatusSent =0 ',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
    return items;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<mpiu.Piutang> uploadPiutang(
    String token,
    String? fdDepo,
    String? fdKodeSF,
    String fdKodeLangganan,
    String startDayDate,
    String urlAPILiveMD) async {
  // int rowResult = 0;
  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  if (!db.isOpen) {
    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
    db = await openDatabase(dbFullPath, version: 1);
  }
  List<mpiu.Piutang> results = [];
  List<Map<String, dynamic>> fdData = [];
  results = await querySendDataPiutang(fdKodeLangganan, startDayDate);
  if (results.isNotEmpty) {
    for (var element in results) {
      Map<String, dynamic> item = mpiu.setJsonDataPiutang(
          element.fdTipePiutang,
          element.fdNoEntryFaktur,
          element.fdNoFaktur,
          element.fdDepo,
          element.fdTanggalFaktur,
          element.fdTanggalJT,
          element.fdKodeLangganan,
          element.fdBayar,
          element.fdGiro,
          element.fdGiroTolak,
          element.fdKodeStatus,
          element.fdTglStatus,
          element.fdStatusRecord,
          element.fdNoUrutFaktur,
          element.fdNoEntrySJ,
          element.fdNoUrutSJ,
          element.fdKodeBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQty,
          element.fdUnitPrice,
          element.fdBrutto,
          element.fdDiscount,
          element.fdNetto,
          element.fdDPP,
          element.fdPPN,
          element.fdNamaBarang,
          element.fdSatuan,
          element.fdTanggalKirim,
          element.fdNoOrder,
          element.fdLastUpdate);

      fdData.add(item);
    }
  }

  String jsonVal = jsonEncode(fdData);

  Map<String, dynamic> params = {
    "FdDepo": fdDepo,
    "FdKodeSF": fdKodeSF,
    "FdData": jsonVal,
    "FdAction": 1,
    "FdLastUpdate": ""
  };
  print(jsonEncode(params));
  print(jsonVal);
  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFtrPiutang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 500;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      List<dynamic> dataJson = jsonBody["FdData"];
      print(jsonBody);
      print(dataJson);

      if (dataJson.isNotEmpty) {
        mpiu.Piutang result = mpiu.Piutang.fromJson(dataJson.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody);

      return result;
    } else if (response.statusCode == 500) {
      Map<String, dynamic> jsonBody = {
        "fdData": "500",
        "fdMessage": "Error timeout"
      };

      mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    throw (e.toString());
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<bool> checkBarangAlreadyExists(
    String fdKodeBarang, String fdKodeLangganan, String startDayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdKodeBarang = ? AND a.fdTanggal=? ',
          [fdKodeLangganan, fdKodeBarang, startDayDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<String> getNoEntryBarangAlreadyExists(
    String fdKodeBarang, String fdKodeLangganan, String startDayDate) async {
  late Database db;
  String noEntry = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdDocNo '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdKodeBarang = ? AND a.fdTanggal=? ',
          [fdKodeLangganan, fdKodeBarang, startDayDate]);

      if (results.isNotEmpty) {
        noEntry = results[0]['fdDocNo'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return noEntry;
}

Future<List<mpiu.Piutang>> getDataByKodeBarang(
    String fdKodeBarang, String fdKodeLangganan) async {
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblPiuDagang} a '
          'WHERE fdKodeBarang = ? AND fdKodeLangganan=? '
          'ORDER BY a.fdID',
          [fdKodeBarang, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mbrg.BarangInputed>> getAllBarang(String fdKodeSF, String fdTanggal,
    String fdKodeLangganan, String fdKodeGroupBarang) async {
  late Database db;
  List<mbrg.BarangInputed> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select * "
          ",case when "
          "(select case when fdKodeBarang is not null then 1 else 0 end "
          "	from ${mdbconfig.tblPiuDagang} b "
          "	where fdKodeSF=? and fdTanggal = ? and a.fdKodeBarang=b.fdKodeBarang "
          "	and fdKodeLangganan=?) =1 then '1' else '0' end as input "
          "from  ${mdbconfig.tblBarang}  a "
          "where fdKodeGroup=? "
          "ORDER BY a.fdKodeBarang ",
          [fdKodeSF, fdTanggal, fdKodeLangganan, fdKodeGroupBarang]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.BarangInputed.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<int> updateFotoBuktiTransfer(
    String fdDepo,
    String? fdKodeLangganan,
    String fdFoto1,
    String fdStartDate,
    String fdNoEntry,
    String fdNoEntryFaktur,
    String fdNoFaktur,
    int fdUrut) async {
  late Database db;
  int rowResult = 0;

  String fdLastproses = param.dateTimeFormatDB.format(DateTime.now());
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblFileBuktiTransfer} WHERE fdNoEntry=? AND fdUrut=? ',
          [fdNoEntry, fdUrut]);
      await txn.execute(
          'INSERT INTO ${mdbconfig.tblFileBuktiTransfer} (fdNoEntry, fdNoEntryFaktur, fdNoFaktur, fdDepo, fdKodeLangganan, fdPath, fdTanggal, fdUrut, fdStatusSent, fdLastUpdate) values (?,?,?,?,?,?,?,?,?,?)  ',
          [
            fdNoEntry,
            fdNoEntryFaktur,
            fdNoFaktur,
            fdDepo,
            fdKodeLangganan,
            fdFoto1,
            fdStartDate,
            fdUrut,
            0,
            fdLastproses
          ]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<bool> isExistbyfdNoEntryFaktur(String? fdNoEntry) async {
  late Database db;
  bool exists = false;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblFileBuktiTransfer} WHERE fdNoEntry = ? ',
          [fdNoEntry]);

      if (results.isNotEmpty) {
        exists = true;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return exists;
}

Future<List<mpiu.FakturExt>> getAllFakturExtTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mpiu.FakturExt> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.*'
          'FROM ${mdbconfig.tblFileBuktiTransfer} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.FakturExt.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<void> updateStatusSentFakturExt(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblFileBuktiTransfer} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<bool> isFakturExtNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblFileBuktiTransfer} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<bool> checkIsBuktiTagihanExist(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblFileBuktiTransfer} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
        print('count ${results[0]['rowCount']}');
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<void> setFakturExt(String fdNoEntryFaktur, String fdPath) async {
  late Database db;
  List<mpiu.FakturExt> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      final check = await txn.rawQuery(
        'SELECT 1 FROM ${mdbconfig.tblFileBuktiTransfer} WHERE fdNoEntryFaktur = ?',
        [fdNoEntryFaktur],
      );

      if (check.isNotEmpty) {
        await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblFileBuktiTransfer} SET fdPath = ? WHERE fdNoEntryFaktur = ?',
          [fdPath, fdNoEntryFaktur],
        );
      } else {
        final results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblFaktur} WHERE fdNoEntryFaktur = ?',
          [fdNoEntryFaktur],
        );

        if (results.isNotEmpty) {
          for (var element in results) {
            items.add(mpiu.FakturExt.prepareInsert(element, fdPath));
          }

          await insertFakturExtBatch(items, txn: txn);
        }
      }
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteFakturBatch() async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblFaktur} WHERE isTagihan=? ', [1]);

      batchTx.commit();
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteFakturItemBatch() async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          '''DELETE FROM ${mdbconfig.tblFakturItem} WHERE fdNoEntryFaktur IN 
        (SELECT fdNoEntryFaktur FROM ${mdbconfig.tblFaktur} WHERE isTagihan = ? AND fdNoEntryFaktur IS NOT NULL ) ''',
          [1]);

      batchTx.commit();
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertFakturBatch(List<mpiu.Faktur> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete(
      //     'DELETE FROM ${mdbconfig.tblFaktur} WHERE isTagihan=? ', [1]);

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdDepo': element.fdDepo,
          'fdJenisFaktur': element.fdJenisFaktur,
          'fdNoFaktur': element.fdNoFaktur,
          'fdNoOrder': element.fdNoOrder,
          'fdTanggalOrder': element.fdTanggalOrder,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdTanggalFaktur': element.fdTanggalFaktur,
          'isTagihan': element.isTagihan,
          'fdTOP': element.fdTOP,
          'fdTanggalJT': element.fdTanggalJT,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdFPajak': element.fdFPajak,
          'fdPPH': element.fdPPH,
          'fdKeterangan': element.fdKeterangan,
          'fdMataUang': element.fdMataUang,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeAP1': element.fdKodeAP1,
          'fdKodeAP2': element.fdKodeAP2,
          'fdReasonNotApprove': element.fdReasonNotApprove,
          'fdDisetujuiOleh': element.fdDisetujuiOleh,
          'fdKodeStatus': element.fdKodeStatus,
          'fdTglStatus': element.fdTglStatus,
          'fdKodeGudang': element.fdKodeGudang,
          'fdNoOrderSFA': element.fdNoOrderSFA,
          'fdTglSFA': element.fdTglSFA,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };
        var cek = await txn.query(
          mdbconfig.tblFaktur,
          where: 'fdNoEntryFaktur = ?',
          whereArgs: [element.fdNoEntryFaktur],
        );

        if (cek.isEmpty) {
          batchTx.insert(mdbconfig.tblFaktur, item,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertFakturItemBatch(List<mpiu.FakturItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete(
      //     '''DELETE FROM ${mdbconfig.tblFakturItem} WHERE fdNoEntryFaktur IN
      //   (SELECT fdNoEntryFaktur FROM ${mdbconfig.tblFaktur} WHERE isTagihan = ? AND fdNoEntryFaktur IS NOT NULL ) ''',
      //     [1]);

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdNoUrutFaktur': element.fdNoUrutFaktur,
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdNoUrutProforma': element.fdNoUrutProforma,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdHargaAsli': element.fdHargaAsli,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdDPP': element.fdDPP,
          'fdPPN': element.fdPPN,
          'fdNoPromosi': element.fdNoPromosi,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };
        var cek = await txn.query(
          mdbconfig.tblFakturItem,
          where:
              'fdNoEntryFaktur = ? AND fdNoUrutFaktur = ? AND fdNoEntrySJ = ? AND fdNoUrutSJ = ? ',
          whereArgs: [
            element.fdNoEntryFaktur,
            element.fdNoUrutFaktur,
            element.fdNoEntrySJ,
            element.fdNoUrutSJ
          ],
        );

        if (cek.isEmpty) {
          batchTx.insert(mdbconfig.tblFakturItem, item,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertFakturExtBatch(List<mpiu.FakturExt> items,
    {Transaction? txn}) async {
  Database? db;
  bool externalTxn = txn != null;

  try {
    db = externalTxn
        ? null
        : await openDatabase(mdbconfig.dbFullPath,
            version: mdbconfig.dbVersion);
    final executor = txn ?? db!;
    final batch = executor.batch();

    for (var element in items) {
      batch.insert(
        mdbconfig.tblFileBuktiTransfer,
        {
          'fdNoEntry': element.fdNoEntryFaktur,
          'fdNoFaktur': element.fdNoFaktur,
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdDepo': element.fdDepo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdJenis': element.fdJenis,
          'fdPath': element.fdPath,
          'fdTanggal': element.fdTanggal,
          'fdUrut': 1,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  } catch (e) {
    rethrow;
  } finally {
    if (!externalTxn && db != null && db.isOpen) {
      await db.close();
    }
  }
}

// Future<void> insertFakturExtBatch(List<mpiu.FakturExt> items) async {
//   late Database db;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
//     await db.transaction((txn) async {
//       Batch batchTx = txn.batch();

//       for (var element in items) {
//         Map<String, dynamic> item = {
//           'fdNoEntry': element.fdNoEntryFaktur,
//           'fdNoFaktur': element.fdNoFaktur,
//           'fdNoEntryFaktur': element.fdNoEntryFaktur,
//           'fdDepo': element.fdDepo,
//           'fdKodeLangganan': element.fdKodeLangganan,
//           'fdJenis': element.fdJenis,
//           'fdPath': element.fdPath,
//           'fdTanggal': element.fdTanggal,
//           'fdUrut': 1,
//           'fdStatusSent': 0,
//           'fdLastUpdate': element.fdLastUpdate,
//         };

//         batchTx.insert(mdbconfig.tblFaktur, item);
//       }

//       batchTx.commit(noResult: true);
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }
// }

Future<void> insertSuratJalanBatch(List<mpiu.SuratJalan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdDepo': element.fdDepo,
          'fdJenisSJ': element.fdJenisSJ,
          'fdNoSJ': element.fdNoSJ,
          'fdTanggalSJ': element.fdTanggalSJ,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeAP1': element.fdKodeAP1,
          'fdKodeAP2': element.fdKodeAP2,
          'fdKodeGudang': element.fdKodeGudang,
          'fdKodeGudangTujuan': element.fdKodeGudangTujuan,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdKeterangan': element.fdKeterangan,
          'fdNoPolisi': element.fdNoPolisi,
          'fdKodeEkspedisi': element.fdKodeEkspedisi,
          'fdSupirNama': element.fdSupirNama,
          'fdSupirKTP': element.fdSupirKTP,
          'fdArmada': element.fdArmada,
          'fdETD': element.fdETD,
          'fdETA': element.fdETA,
          'fdNoContainer': element.fdNoContainer,
          'fdNoSeal': element.fdNoSeal,
          'fdAktTglKirim': element.fdAktTglKirim,
          'fdAktTglTiba': element.fdAktTglTiba,
          'fdAktTglSerah': element.fdAktTglSerah,
          'fdKeteranganPengiriman': element.fdKeteranganPengiriman,
          'fdIsFaktur': element.fdIsFaktur,
          'fdKodeStatus': element.fdTglStatus,
          'fdTglStatus': element.fdKodeStatus,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblSuratJalan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertSuratJalanItemBatch(List<mpiu.SuratJalanItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdNoUrutOrder': element.fdNoUrutOrder,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdNoUrutProforma': element.fdNoUrutProforma,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdPalet': element.fdPalet,
          'fdDetailPalet': element.fdDetailPalet,
          'fdNetWeight': element.fdNetWeight,
          'fdGrossWeight': element.fdGrossWeight,
          'fdVolume': element.fdVolume,
          'fdNotes': element.fdNotes,
          'fdCartonNo': element.fdCartonNo,
          'fdQtyJual': element.fdQtyJual,
          'fdRusakB': element.fdRusakB,
          'fdRusakS': element.fdRusakS,
          'fdRusakK': element.fdRusakK,
          'fdSisaB': element.fdSisaB,
          'fdSisaS': element.fdSisaS,
          'fdSisaK': element.fdSisaK,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblSuratJalanItem, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertSuratJalanItemDetailBatch(
    List<mpiu.SuratJalanItemDetail> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdKodeBarang': element.fdKodeBarang,
          'fdDateCode': element.fdDateCode,
          'fdPromosi': element.fdPromosi,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblSuratJalanItemDetail, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateSuratJalanBatch(List<mpiu.SuratJalan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdDepo': element.fdDepo,
          'fdJenisSJ': element.fdJenisSJ,
          'fdNoSJ': element.fdNoSJ,
          'fdTanggalSJ': element.fdTanggalSJ,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeAP1': element.fdKodeAP1,
          'fdKodeAP2': element.fdKodeAP2,
          'fdKodeGudang': element.fdKodeGudang,
          'fdKodeGudangTujuan': element.fdKodeGudangTujuan,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdKeterangan': element.fdKeterangan,
          'fdNoPolisi': element.fdNoPolisi,
          'fdKodeEkspedisi': element.fdKodeEkspedisi,
          'fdSupirNama': element.fdSupirNama,
          'fdSupirKTP': element.fdSupirKTP,
          'fdArmada': element.fdArmada,
          'fdETD': element.fdETD,
          'fdETA': element.fdETA,
          'fdNoContainer': element.fdNoContainer,
          'fdNoSeal': element.fdNoSeal,
          'fdAktTglKirim': element.fdAktTglKirim,
          'fdAktTglTiba': element.fdAktTglTiba,
          'fdAktTglSerah': element.fdAktTglSerah,
          'fdKeteranganPengiriman': element.fdKeteranganPengiriman,
          'fdIsFaktur': element.fdIsFaktur,
          'fdKodeStatus': element.fdTglStatus,
          'fdTglStatus': element.fdKodeStatus,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };
        batchTx.update(
          mdbconfig.tblSuratJalan,
          item,
          where: 'fdNoEntrySJ = ?',
          whereArgs: [element.fdNoEntrySJ],
        );
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateSuratJalanItemBatch(List<mpiu.SuratJalanItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdNoUrutOrder': element.fdNoUrutOrder,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdNoUrutProforma': element.fdNoUrutProforma,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdPalet': element.fdPalet,
          'fdDetailPalet': element.fdDetailPalet,
          'fdNetWeight': element.fdNetWeight,
          'fdGrossWeight': element.fdGrossWeight,
          'fdVolume': element.fdVolume,
          'fdNotes': element.fdNotes,
          'fdCartonNo': element.fdCartonNo,
          'fdQtyJual': element.fdQtyJual,
          'fdRusakB': element.fdRusakB,
          'fdRusakS': element.fdRusakS,
          'fdRusakK': element.fdRusakK,
          'fdSisaB': element.fdSisaB,
          'fdSisaS': element.fdSisaS,
          'fdSisaK': element.fdSisaK,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };
        batchTx.update(
          mdbconfig.tblSuratJalanItem,
          item,
          where: 'fdNoEntrySJ = ?',
          whereArgs: [element.fdNoEntrySJ],
        );
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateFakturBatch(List<mpiu.Faktur> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdDepo': element.fdDepo,
          'fdJenisFaktur': element.fdJenisFaktur,
          'fdNoFaktur': element.fdNoFaktur,
          'fdTanggalFaktur': element.fdTanggalFaktur,
          'fdTOP': element.fdTOP,
          'fdTanggalJT': element.fdTanggalJT,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdFPajak': element.fdFPajak,
          'fdPPH': element.fdPPH,
          'fdKeterangan': element.fdKeterangan,
          'fdMataUang': element.fdMataUang,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeAP1': element.fdKodeAP1,
          'fdKodeAP2': element.fdKodeAP2,
          'fdReasonNotApprove': element.fdReasonNotApprove,
          'fdDisetujuiOleh': element.fdDisetujuiOleh,
          'fdKodeStatus': element.fdKodeStatus,
          'fdTglStatus': element.fdTglStatus,
          'fdKodeGudang': element.fdKodeGudang,
          'fdNoOrderSFA': element.fdNoOrderSFA,
          'fdTglSFA': element.fdTglSFA,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblFaktur,
          item,
          where: 'fdNoEntryFaktur = ?',
          whereArgs: [element.fdNoEntryFaktur],
        );
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateFakturItemBatch(List<mpiu.FakturItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      if (items.isNotEmpty) {
        batchTx.delete(
          mdbconfig.tblFakturItem,
          where: 'fdNoEntryFaktur = ?',
          whereArgs: [items[0].fdNoEntryFaktur],
        );
      }

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdNoUrutFaktur': element.fdNoUrutFaktur,
          'fdNoEntrySJ': element.fdNoEntrySJ,
          'fdNoUrutSJ': element.fdNoUrutSJ,
          'fdNoEntryProforma': element.fdNoEntryProforma,
          'fdNoUrutProforma': element.fdNoUrutProforma,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdDPP': element.fdDPP,
          'fdPPN': element.fdPPN,
          'fdNoPromosi': element.fdNoPromosi,
          'fdStatusRecord': element.fdStatusRecord,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblFakturItem, item);
      }

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    if (db.isOpen) {
      await db.close();
    }
  }
}

Future<bool> isSaveFaktur(String noEntry) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblFaktur} a '
          'WHERE a.fdNoEntryFaktur = ? ',
          [noEntry]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<bool> isSaveSuratJalan(String noEntry) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblSuratJalan} a '
          'WHERE a.fdNoEntrySJ = ? ',
          [noEntry]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mpiu.Piutang>> getFakturByNoEntry(String fdNoEntryFaktur) async {
  late Database db;
  List<mpiu.Piutang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      // results = await txn.rawQuery(
      //     '''SELECT  a.fdNoEntryFaktur , fdDepo , fdJenisFaktur , a.fdNoFaktur ,
      //     fdTanggalFaktur , fdKodeLangganan, c.fdNamaBarang, b.fdQtyK as fdQty, b.fdKodeBarang, b.fdDiscount,
      //     '0' as fdJenisSatuan, 'PCS' as fdSatuan, b.fdUnitPriceK as fdUnitPrice
      //     FROM ${mdbconfig.tblFaktur} a
      //     INNER JOIN ${mdbconfig.tblFakturItem} b on a.fdNoEntryFaktur=b.fdNoEntryFaktur
      //     INNER JOIN ${mdbconfig.tblBarang} c on b.fdKodeBarang=c.fdKodeBarang
      //     WHERE a.fdNoEntryFaktur = ?
      //     ORDER BY a.fdID''', [fdNoEntryFaktur]);

      results = await txn.rawQuery(
          '''SELECT  a.fdNoEntryFaktur , fdDepo , fdJenisFaktur , a.fdNoFaktur , a.fdTanggalJT, 
          fdTanggalFaktur , fdKodeLangganan, c.fdNamaBarang, b.fdQty, b.fdQtyK, b.fdKodeBarang, b.fdDiscount, 
          b.fdJenisSatuan, b.fdPromosi, 
          case when h.fdKodeBarang IS NOT NULL then 
            case when b.fdJenisSatuan='0' then h.fdSatuanK 
            when b.fdJenisSatuan='1' then h.fdSatuanS 
            when b.fdJenisSatuan='2' then h.fdSatuanB end
          else
            case when b.fdJenisSatuan='0' then c.fdSatuanK 
            when b.fdJenisSatuan='1' then c.fdSatuanS 
            when b.fdJenisSatuan='2' then c.fdSatuanB end 
          end as fdSatuan, b.fdUnitPrice, b.fdUnitPriceK ,
          fdDPP, fdPPN, fdTanggalOrder, fdTanggalKirim, b.fdHargaAsli, b.fdBrutto, b.fdNetto
          FROM ${mdbconfig.tblFaktur} a 
          INNER JOIN ${mdbconfig.tblFakturItem} b on a.fdNoEntryFaktur=b.fdNoEntryFaktur 
          INNER JOIN ${mdbconfig.tblBarang} c on b.fdKodeBarang=c.fdKodeBarang 
          left join ${mdbconfig.tblHanger} h on b.fdKodeBarang=h.fdKodeBarang 
          WHERE a.fdNoEntryFaktur = ? 
          ORDER BY a.fdNoEntryFaktur, b.fdKodeBarang, b.fdPromosi ''',
          [fdNoEntryFaktur]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Piutang.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<bool> isFakturNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblFaktur} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggalFaktur = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mpiu.FakturApi>> getAllFakturTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mpiu.FakturApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          '''SELECT a.fdNoEntryFaktur, a.fdDepo , a.fdJenisFaktur, a.fdNoFaktur, a.fdTanggalFaktur , 
              a.fdTOP, a.fdTanggalJT , a.fdKodeLangganan , a.fdNoEntryProforma, a.fdFPajak , a.fdPPH , 
              a.fdKeterangan, a.fdMataUang , a.fdKodeSF, a.fdKodeAP1, a.fdKodeAP2, a.fdReasonNotApprove , 
              a.fdDisetujuiOleh , a.fdKodeStatus, a.fdTglStatus , a.fdKodeGudang , a.fdNoOrderSFA , 
              a.fdTglSFA , a.fdStatusRecord ,  
              b.fdNoUrutFaktur, b.fdNoEntrySJ, b.fdNoUrutSJ, b.fdNoUrutProforma, 
              b.fdKodeBarang, b.fdPromosi, b.fdReplacement , b.fdJenisSatuan , b.fdQty , b.fdQtyK , 
              b.fdUnitPrice, b.fdUnitPriceK, b.fdBrutto , b.fdDiscount , b.fdDiscountDetail , 
              b.fdNetto , b.fdDPP , b.fdPPN , b.fdNoPromosi  
            FROM ${mdbconfig.tblFaktur} a  
            INNER JOIN ${mdbconfig.tblFakturItem} b ON a.fdNoEntryFaktur = b.fdNoEntryFaktur  
            WHERE a.fdKodeLangganan = ? AND a.fdTanggalFaktur = ? ''',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.FakturApi.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<bool> isSuratJalanNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblSuratJalan} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggalSJ = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mpiu.SuratJalanApi>> getAllSuratJalanTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mpiu.SuratJalanApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          '''SELECT a.fdNoEntrySJ, a.fdDepo, a.fdJenisSJ, a.fdNoSJ, a.fdTanggalSJ, a.fdKodeLangganan, 
            a.fdKodeSF, a.fdKodeAP1, a.fdKodeAP2, a.fdKodeGudang, a.fdKodeGudangTujuan, 
            a.fdNoEntryProforma, a.fdAlamatKirim, a.fdKeterangan, a.fdNoPolisi, 
            a.fdKodeEkspedisi, a.fdSupirNama, a.fdSupirKTP, a.fdArmada, a.fdETD, a.fdETA, 
            a.fdNoContainer, a.fdNoSeal, a.fdAktTglKirim, a.fdAktTglTiba, a.fdAktTglSerah, a.fdKeteranganPengiriman, 
            a.fdIsFaktur, a.fdKodeStatus, a.fdTglStatus, a.fdStatusRecord, a.fdKodeStatusGit, a.fdTanggalLPB, 
            a.fdNoLPB, a.fdKeteranganLPB, a.fdUserLPB, a.fdNoEntryLama, b.fdNoUrutSJ, b.fdNoEntryOrder, 
            b.fdNoUrutOrder, b.fdNoUrutProforma, b.fdKodeBarang, b.fdPromosi, b.fdReplacement, b.fdJenisSatuan, 
            b.fdQty, b.fdQtyK, b.fdPalet, b.fdDetailPalet, b.fdNetWeight, b.fdGrossWeight, b.fdVolume, 
            b.fdNotes, b.fdCartonNo, b.fdQtyJual, b.fdRusakB, b.fdRusakS, b.fdRusakK, 
            b.fdSisaB, b.fdSisaS, b.fdSisaK 
            FROM ${mdbconfig.tblSuratJalan} a  
            INNER JOIN ${mdbconfig.tblSuratJalanItem} b ON a.fdNoEntrySJ = b.fdNoEntrySJ  
            WHERE a.fdKodeLangganan = ? AND a.fdTanggalSJ = ? ''',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.SuratJalanApi.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<bool> isPaymentNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblPayment} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mpiu.Payment>> getAllPaymentTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mpiu.Payment> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('''SELECT *
            FROM ${mdbconfig.tblPayment} a   
            WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? ''',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.Payment.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<void> updateStatusSentFaktur(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblFaktur} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggalFaktur = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentSuratJalan(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblSuratJalan} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggalSJ = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentPayment(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblPayment} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mpiu.FakturApi>> getCetakanLash() async {
  late Database db;
  List<mpiu.FakturApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      // var results = await txn.rawQuery('''SELECT
      //         c.fdNamaLangganan , c.fdKodeLangganan , a.fdNoEntryFaktur , a.fdNoFaktur , '' as fdTanggalFaktur ,
      //         0 as tagihan,
      //         (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Tunai') as tunai ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Giro') as giro ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Cheque') as cheque ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Transfer') as transfer
      //       FROM ${mdbconfig.tblFaktur} a
      //       INNER JOIN ${mdbconfig.tblLangganan} c ON a.fdKodeLangganan = c.fdKodeLangganan
      //       UNION
      //       SELECT
      //         n.fdNamaToko as fdNamaLangganan , n.fdKodeNOO as fdKodeLangganan , a.fdNoEntryFaktur , a.fdNoFaktur , '' as fdTanggalFaktur ,
      //         0 as tagihan,
      //         (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Tunai') as tunai ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Giro') as giro ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Cheque') as cheque ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Transfer') as transfer
      //       FROM ${mdbconfig.tblFaktur} a
      //       INNER JOIN ${mdbconfig.tblNOO} n ON a.fdKodeLangganan = n.fdKodeNOO
      //       UNION
      //       SELECT
      //         c.fdNamaLangganan , a.fdKodeLangganan , a.fdNoEntryFaktur , a.fdNoFaktur as fdNoInvoice, a.fdTanggalFaktur ,
      //         SUM(a.fdNetto) as tagihan,
      //         0 as fdNetto,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Tunai') as tunai ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Giro') as giro ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Cheque') as cheque ,
      //         (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = a.fdNoEntryFaktur and fdTipe='Transfer') as transfer
      //       FROM ${mdbconfig.tblPiuDagang} a
      //       INNER JOIN ${mdbconfig.tblLangganan} c ON a.fdKodeLangganan = c.fdKodeLangganan
      //       ''');
      var results = await txn.rawQuery('''SELECT 
              a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur , '' as fdTanggalFaktur ,
              '' as fdKeterangan, 0 as tagihan, 
              (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
            FROM ${mdbconfig.tblLangganan} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            LEFT JOIN ${mdbconfig.tblFaktur} f on f.fdKodeLangganan = a.fdKodeLangganan
            GROUP BY a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur
            UNION
            SELECT 
              a.fdNamaToko as fdNamaLangganan , a.fdKodeNOO as fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur , '' as fdTanggalFaktur ,
              'NOO' as fdKeterangan, 0 as tagihan, 
              (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
            FROM ${mdbconfig.tblNOO} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeNOO AND b.fdKodeDepo = a.fdDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeNOO AND c.fdKodeDepo = a.fdDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            INNER JOIN ${mdbconfig.tblFaktur} f on f.fdKodeLangganan = a.fdKodeNOO
            GROUP BY a.fdNamaToko , a.fdKodeNOO , f.fdNoEntryFaktur , f.fdNoFaktur
            UNION
            SELECT 
              a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur, f.fdTanggalFaktur ,
              'Tagihan' as fdKeterangan, SUM(f.fdNetto) as tagihan, 
              0 as fdNetto,  
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
           FROM ${mdbconfig.tblLangganan} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            INNER JOIN ${mdbconfig.tblPiuDagang} f on f.fdKodeLangganan = a.fdKodeLangganan
            GROUP BY a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryFaktur , f.fdNoFaktur, f.fdTanggalFaktur
            ''');
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.FakturApi.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mpiu.FakturApi>> getCetakanLashTO() async {
  late Database db;
  List<mpiu.FakturApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('''SELECT 
              a.fdNamaLangganan , a.fdKodeLangganan , f.fdNoEntryOrder as fdNoEntryFaktur , f.fdNoEntryOrder as fdNoFaktur , f.fdTanggal as fdTanggalFaktur ,
              '' as fdKeterangan, 0 as tagihan, 
              (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
            FROM ${mdbconfig.tblLangganan} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            LEFT JOIN ${mdbconfig.tblOrder} f on f.fdKodeLangganan = a.fdKodeLangganan
            UNION
            SELECT 
              a.fdNamaToko as fdNamaLangganan , a.fdKodeNOO as fdKodeLangganan , f.fdNoEntryOrder as fdNoEntryFaktur , f.fdNoEntryOrder as fdNoFaktur , f.fdTanggal as fdTanggalFaktur ,
              'NOO' as fdKeterangan, 0 as tagihan, 
              (select SUM(fdNetto) FROM ${mdbconfig.tblFakturItem} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdPromosi not in ('1')) as fdNetto ,
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Tunai') as tunai , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Giro') as giro , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Cheque') as cheque , 
              (select SUM(fdTotalCollection) FROM ${mdbconfig.tblCollection} g WHERE g.fdNoEntryFaktur = f.fdNoEntryFaktur and fdTipe='Transfer') as transfer  
            FROM ${mdbconfig.tblNOO} a  
            LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeNOO AND b.fdKodeDepo = a.fdDepo 
              AND b.fdCategory = 'NotVisit' 
            LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeNOO AND c.fdKodeDepo = a.fdDepo 
              AND c.fdJenisActivity = '03' 
            LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo 
              AND d.fdCategory = 'Pause'
            INNER JOIN ${mdbconfig.tblOrder} f on f.fdKodeLangganan = a.fdKodeNOO 
            ''');
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpiu.FakturApi.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}
