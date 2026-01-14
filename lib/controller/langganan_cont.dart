import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'database_cont.dart' as cdb;
import '../models/database.dart' as mdbconfig;
import '../models/langganan.dart' as mlgn;
import '../models/globalparam.dart' as param;

void createTblLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblLangganan} (fdKodeSF varchar(10), fdKodeDepo varchar(5), fdKodeLangganan varchar(20), fdBadanPerusahaan varchar(10), '
        'fdNamaLangganan varchar(100), fdOwner varchar(100), fdContactPerson varchar(100), fdPhone varchar(20), fdHandphone varchar(25), fdAlamat varchar(300), fdWilayah varchar(20), '
        'fdKodePos varchar(50), fdLA REAL, fdLG REAL, fdNPWP varchar(25), fdNamaNpwp varchar(100), fdAlamatNpwp varchar(300), fdNIK varchar(20), '
        'fdKodeKlas varchar(10), fdKodeTipeOutlet varchar(5), '
        'isRute int, fdKodeStatus int, '
        'fdKodeRute varchar(10), fdStatusSent int, fdLastUpdate varchar(20), '
        'fdKodeExternal varchar(10), fdKota varchar(20), fdKodeTipeLangganan varchar(5), fdTipeLangganan varchar(50), fdKodeDC varchar(4), fdDC varchar(50), '
        'fdAmountChiller int, fdGroupLangganan varchar(10), fdNamaGroupLangganan varchr(50), '
        'UNIQUE(fdKodeDepo, fdKodeLangganan))');
  });
}

// void createTblLangganan(Database db) async {
//   await db.transaction((txn) async {
//     await txn.execute(
//         'CREATE TABLE ${mdbconfig.tblLangganan} (fdKodeLangganan varchar(20), fdKodeDepo varchar(5), fdKodeSF varchar(10), '
//         'fdNamaLangganan varchar(100), fdContactPerson varchar(50), fdAlamat varchar(255), fdKota varchar(20), fdPhone varchar(20), '
//         'fdKodeTipeLangganan varchar(5), fdTipeLangganan varchar(50), fdKodeDC varchar(4), fdDC varchar(50), '
//         'fdAmountChiller int, fdGroupLangganan varchar(10), fdNamaGroupLangganan varchr(50), '
//         'fdNIK varchar(20), fdNPWP varchar(20), fdLA REAL, fdLG REAL, isRute int, fdKodeStatus int, '
//         'fdOwner varchar(10), fdKodeExternal varchar(10), fdKodeRute varchar(10), fdStatusSent int, fdLastUpdate varchar(20), '
//         'UNIQUE(fdKodeDepo, fdKodeLangganan))');
//   });
// }

void createTblLanggananActivity(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblLanggananActivity} (fdKodeLangganan varchar(20), fdKodeDepo varchar(2), fdKodeSF varchar(10), '
        'fdCategory varchar(10), fdKodeReason varchar(4), fdReason varchar(50), fdKeterangan varchar(250), fdPhoto varchar(250), fdStatusSent int, '
        'fdLastUpdate varchar(20), fdTanggal varchar(20), '
        'UNIQUE(fdKodeLangganan, fdKodeDepo, fdTanggal, fdKodeSF, fdCategory))');
  });
}

Future<void> createTblLanggananAlamat(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblLanggananAlamat} (fdKodeLangganan varchar(20), fdKodeDepo varchar(2), fdJenis varchar(2), '
        'fdNoUrut int, fdIdAlamat int, fdAlamat varchar(1000), fdLatitude REAL, fdLongitude REAL, '
        'fdStatusSent int, fdLastUpdate varchar(20) )');
  });
}

void createTblReason(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblReason} (fdTipe varchar(2), fdDescription varchar(20), '
        'fdKodeReason varchar(4) Primary Key, fdReasonDescription varchar(50), '
        'fdCamera int, fdFreeTeks int, fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTbllLanggananTOP(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblLanggananTOP} (fdID int,	fdKodeLangganan varchar(30), '
        'fdKodeGroup varchar(2),	fdKodeBarang varchar(10),	fdTOP int, fdStatusRecord int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTblBank(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblBank} (fdKodeBank varchar(10), fdNamaBank varchar(50), '
        'fdNamaSingkat varchar(10), fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> alterTblLangganan(Database db) async {
  bool columnExists = await cdb.isColumnExistTblLangganan(
      db, mdbconfig.tblLangganan, 'fdLimitKredit');
  if (!columnExists) {
    await db.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblLangganan} ADD COLUMN fdLimitKredit REAL ''');
    });
  }
  bool fdKodeHargaExists = await cdb.isColumnExistTblLangganan(
      db, mdbconfig.tblLangganan, 'fdKodeHarga');
  if (!fdKodeHargaExists) {
    await db.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblLangganan} ADD COLUMN fdKodeHarga varchar(30) ''');
    });
  }
  bool isEditProfileExists = await cdb.isColumnExistTblLangganan(
      db, mdbconfig.tblLangganan, 'isEditProfile');
  if (!isEditProfileExists) {
    await db.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblLangganan} ADD COLUMN isEditProfile int ''');
    });
  }
}

Future<void> alterTblReason(Database db) async {
  bool columnExists = await cdb.isColumnExistTblReason(
      db, mdbconfig.tblReason, 'fdCancelVisit');
  if (!columnExists) {
    await db.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblReason} ADD COLUMN fdCancelVisit int ''');
    });
  }
}

Future<void> insertLanggananBatch(List<mlgn.Langganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx
          .rawDelete('DELETE FROM ${mdbconfig.tblLangganan} WHERE isRute = 1');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeDepo': element.fdKodeDepo,
          'fdKodeSF': element.fdKodeSF,
          'fdNamaLangganan': element.fdNamaLangganan,
          'fdAlamat': element.fdAlamat,
          'fdKota': element.fdKota,
          'fdPhone': element.fdPhone,
          'fdContactPerson': element.fdContactPerson,
          'fdKodeTipeLangganan': element.fdKodeTipeLangganan,
          'fdTipeLangganan': element.fdTipeLangganan,
          'fdKodeDC': element.fdKodeDC,
          'fdDC': element.fdDC,
          'fdNIK': element.fdNIK,
          'fdNPWP': element.fdNPWP,
          'isRute': element.isRute,
          'fdKodeStatus': element.fdKodeStatus,
          'fdLa': element.fdLA,
          'fdLg': element.fdLG,
          'fdGroupLangganan': element.fdGroupLangganan,
          'fdNamaGroupLangganan': element.fdNamaGroupLangganan,
          'fdOwner': element.fdOwner,
          'fdKodeExternal': element.fdKodeExternal,
          'fdAmountChiller': element.fdAmountChiller,
          'fdKodeRute': element.fdKodeRute,
          'fdLimitKredit': element.fdLimitKredit,
          'isEditProfile': element.isEditProfile,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblLangganan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertLanggananAlamatBatch(
    List<mlgn.LanggananAlamat> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblLanggananAlamat} ');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdJenis': element.fdJenis,
          'fdNoUrut': element.fdNoUrut,
          'fdIdAlamat': element.fdIdAlamat,
          'fdAlamat': element.fdAlamat,
          'fdLatitude': element.fdLatitude,
          'fdLongitude': element.fdLongitude,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblLanggananAlamat, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertLanggananNonRuteBatch(List<mlgn.Langganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete(
      //     'DELETE FROM ${mdbconfig.tblLangganan} WHERE isRute = 0 OR (isRute = 1 AND fdKodeStatus=0) ');
      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblLangganan} WHERE isRute = 0  '); // yg nonrute saja boleh hapus

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeDepo': element.fdKodeDepo,
          'fdKodeSF': element.fdKodeSF,
          'fdNamaLangganan': element.fdNamaLangganan,
          'fdAlamat': element.fdAlamat,
          'fdKota': element.fdKota,
          'fdPhone': element.fdPhone,
          'fdContactPerson': element.fdContactPerson,
          'fdKodeTipeLangganan': element.fdKodeTipeLangganan,
          'fdTipeLangganan': element.fdTipeLangganan,
          'fdKodeDC': element.fdKodeDC,
          'fdDC': element.fdDC,
          'fdNIK': element.fdNIK,
          'fdNPWP': element.fdNPWP,
          'isRute': element.isRute,
          'fdKodeStatus': element.fdKodeStatus,
          'fdLa': element.fdLA,
          'fdLg': element.fdLG,
          'fdGroupLangganan': element.fdGroupLangganan,
          'fdNamaGroupLangganan': element.fdNamaGroupLangganan,
          'fdOwner': element.fdOwner,
          'fdKodeExternal': element.fdKodeExternal,
          'fdAmountChiller': element.fdAmountChiller,
          'fdLimitKredit': element.fdLimitKredit,
          'fdKodeRute': element.fdKodeRute,
          'fdKodeHarga': element.fdKodeHarga,
          'isEditProfile': element.isEditProfile,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblLangganan, item,
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteLanggananRuteExists() async {
  late Database db;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          ''' DELETE FROM ${mdbconfig.tblLangganan} WHERE isRute = 1 AND fdKodeStatus = 0 
          AND fdKodeLangganan NOT IN (SELECT a.fdKodeLangganan FROM ${mdbconfig.tblLangganan} a
           JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdJenisActivity = '03'
            WHERE c.fdStartDate IS NOT NULL AND c.fdStartDate <> ''  ) ''');

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertLanggananRuteBatch(List<mlgn.Langganan> items) async {
  late Database db;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        final existing = await txn.query(
          mdbconfig.tblLangganan,
          where: 'fdKodeLangganan = ?',
          whereArgs: [element.fdKodeLangganan],
        );

        if (existing.isEmpty) {
          Map<String, dynamic> item = {
            'fdKodeLangganan': element.fdKodeLangganan,
            'fdKodeDepo': element.fdKodeDepo,
            'fdKodeSF': element.fdKodeSF,
            'fdNamaLangganan': element.fdNamaLangganan,
            'fdAlamat': element.fdAlamat,
            'fdKota': element.fdKota,
            'fdPhone': element.fdPhone,
            'fdContactPerson': element.fdContactPerson,
            'fdKodeTipeLangganan': element.fdKodeTipeLangganan,
            'fdTipeLangganan': element.fdTipeLangganan,
            'fdKodeDC': element.fdKodeDC,
            'fdDC': element.fdDC,
            'fdNIK': element.fdNIK,
            'fdNPWP': element.fdNPWP,
            'isRute': element.isRute,
            'fdKodeStatus': element.fdKodeStatus,
            'fdLa': element.fdLA,
            'fdLg': element.fdLG,
            'fdGroupLangganan': element.fdGroupLangganan,
            'fdNamaGroupLangganan': element.fdNamaGroupLangganan,
            'fdOwner': element.fdOwner,
            'fdKodeExternal': element.fdKodeExternal,
            'fdAmountChiller': element.fdAmountChiller,
            'fdLimitKredit': element.fdLimitKredit,
            'fdKodeRute': element.fdKodeRute,
            'fdKodeHarga': element.fdKodeHarga,
            'isEditProfile': element.isEditProfile,
            'fdLastUpdate': element.fdLastUpdate
          };

          batchTx.insert(mdbconfig.tblLangganan, item,
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

Future<void> insertLanggananTOPBatch(List<mlgn.LanggananTOP> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblLanggananTOP} ');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeGroup': element.fdKodeGroup,
          'fdKodeBarang': element.fdKodeBarang,
          'fdTOP': element.fdTOP,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblLanggananTOP, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertBankBatch(List<mlgn.Bank> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblBank} ');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeBank': element.fdKodeBank,
          'fdNamaBank': element.fdNamaBank,
          'fdNamaSingkat': element.fdNamaSingkat,
        };

        batchTx.insert(mdbconfig.tblBank, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertSFAct_LanggananTransNotVisit(
    String fdKodeSF,
    String fdKodeDepo,
    String? fdKodeLangganan,
    String? fdTanggal,
    String? fdKodeReason,
    String? fdReason,
    String fdPhoto,
    String fdCategory,
    String fdKeterangan,
    String fdJenisActivity,
    String fdStartDate,
    String fdEndDate,
    double fdLA,
    double fdLG,
    int fdRute,
    String? fdBattery,
    String? fdStreet,
    String? fdSubLocality,
    String? fdSubArea,
    String? fdPostalCode,
    Transaction txn) async {
  Batch batchTx = txn.batch();

  batchTx.rawInsert(
      'INSERT OR IGNORE INTO ${mdbconfig.tblSFActivity}(fdKodeSF, fdKodeDepo, fdKM, fdPhoto, fdKodeLangganan, '
      'fdJenisActivity, fdStartDate, fdEndDate, fdLA, fdLG, fdIsPaused, fdRute, fdStatusSent, fdTanggal, fdLastUpdate, '
      'fdBattery, fdStreet, fdSubLocality, fdSubArea, fdPostalCode )'
      'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
      [
        fdKodeSF,
        fdKodeDepo,
        0,
        '',
        fdKodeLangganan,
        fdJenisActivity,
        fdStartDate,
        fdEndDate,
        fdLA,
        fdLG,
        0,
        fdRute,
        0,
        fdTanggal,
        param.dateTimeFormatDB.format(DateTime.now()),
        fdBattery,
        fdStreet,
        fdSubLocality,
        fdSubArea,
        fdPostalCode,
      ]);

  batchTx.rawInsert(
      'INSERT OR IGNORE INTO ${mdbconfig.tblLanggananActivity}(fdKodeDepo, fdKodeSF, fdKodeLangganan, fdTanggal, '
      'fdCategory, fdKodeReason, fdReason, fdPhoto, fdKeterangan, fdStatusSent, fdLastUpdate) '
      'VALUES(?,?,?,?,?,?,?,?,?,?,?) ',
      [
        fdKodeDepo,
        fdKodeSF,
        fdKodeLangganan,
        fdTanggal,
        fdCategory,
        fdKodeReason,
        fdReason,
        fdPhoto,
        fdKeterangan,
        0,
        param.dateTimeFormatDB.format(DateTime.now())
      ]);

  batchTx.commit(noResult: true);
}

Future<void> updateStatusSentLanggananAct(
    String fdKodeLangganan, String fdKodeDepo, String fdKodeSF) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblLanggananActivity} SET fdStatusSent = 1 '
          'WHERE fdKodeLangganan = ? AND fdKodeDepo = ? AND fdKodeSF = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdKodeDepo, fdKodeSF]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mlgn.Langganan>> getAllLanggananInfo(
    Transaction txn, String fdKodeSF, String fdKodeDepo) async {
  List<mlgn.Langganan> items = [];

  var results = await txn.rawQuery(
      'SELECT a.fdKodeDepo, a.fdKodeLangganan, a.fdKodeExternal, fdNamaLangganan, fdContactPerson, fdAlamat, '
      'fdKodeTipeLangganan, fdTipeLangganan, fdKodeDC, fdDC, fdGroupLangganan, fdNamaGroupLangganan, fdOwner, fdAmountChiller, '
      'fdNIK, fdNPWP, a.fdLA, a.fdLG, fdKota, fdPhone, '
      'c.fdStartDate fdStartVisitDate, c.fdEndDate fdEndVisitDate, b.fdReason fdNotVisitReason, a.IsRute, c.fdIsPaused, '
      'd.fdReason fdPauseReason, a.fdKodeStatus, c.fdPhoto , b.fdCategory, b.fdReason fdCancelVisitReason, c.fdStatusSent '
      'FROM ${mdbconfig.tblLangganan} a '
      'LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo '
      ' AND b.fdCategory = \'NotVisit\' '
      'LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo '
      ' AND c.fdJenisActivity = \'03\' '
      'LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo '
      ' AND d.fdCategory = \'Pause\' '
      'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? '
      'ORDER BY a.fdKodeExternal',
      [fdKodeSF, fdKodeDepo]);

  for (var element in results) {
    items.add(mlgn.Langganan.setData(element));
  }

  return items;
}

Future<List<mlgn.Langganan>> getAllLanggananCoverage(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<mlgn.Langganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    var results = await db.rawQuery(
        'SELECT a.fdKodeLangganan, a.fdKodeExternal, fdNamaLangganan, fdAlamat, '
        'a.fdLA, a.fdLG, a.IsRute '
        'FROM ${mdbconfig.tblLangganan} a '
        'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? '
        'ORDER BY a.fdKodeExternal',
        [fdKodeSF, fdKodeDepo]);

    for (var element in results) {
      items.add(mlgn.Langganan.setData(element));
    }
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<Map<String, dynamic>> countSFSummary(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  Map<String, dynamic> mapSFSummary = {};

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND a.isRute = 1 AND a.fdKodeStatus = 1',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        mapSFSummary.putIfAbsent('rute', () => results[0]['rowNo'] as int);
      }

      results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND a.isRute = 0 OR (a.isRute = 1 AND a.fdKodeStatus = 0) ',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        mapSFSummary.putIfAbsent('nonrute', () => results[0]['rowNo'] as int);
      }

      results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'INNER JOIN ${mdbconfig.tblSFActivity} b ON b.fdKodeDepo = a.fdKodeDepo AND b.fdKodeSF = a.fdKodeSF '
          ' AND b.fdKodeLangganan = a.fdKodeLangganan AND b.fdJenisActivity = \'03\' '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND b.fdEndDate IS NOT NULL AND b.fdEndDate <> \'\' '
          ' AND NOT EXISTS '
          '   (SELECT 1 FROM ${mdbconfig.tblLanggananActivity} c '
          '   WHERE c.fdKodeDepo = b.fdKodeDepo AND c.fdKodeSF = b.fdKodeSF '
          '     AND c.fdKodeLangganan = b.fdKodeLangganan AND c.fdCategory = \'NotVisit\')',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        mapSFSummary.putIfAbsent('ec', () => results[0]['rowNo'] as int);
      }

      results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'INNER JOIN ${mdbconfig.tblSFActivity} b ON b.fdKodeDepo = a.fdKodeDepo AND b.fdKodeSF = a.fdKodeSF '
          ' AND b.fdKodeLangganan = a.fdKodeLangganan AND b.fdJenisActivity = \'03\' '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND b.fdEndDate IS NOT NULL AND b.fdEndDate <> \'\' '
          ' AND NOT EXISTS '
          '   (SELECT 1 FROM ${mdbconfig.tblLanggananActivity} c '
          '   WHERE c.fdKodeDepo = b.fdKodeDepo AND c.fdKodeSF = b.fdKodeSF '
          '     AND c.fdKodeLangganan = b.fdKodeLangganan AND c.fdCategory = \'NotVisit\' '
          '     AND c.fdPhoto = \'\')',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        mapSFSummary.putIfAbsent('call', () => results[0]['rowNo'] as int);
      }

      results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'INNER JOIN ${mdbconfig.tblSFActivity} b ON b.fdKodeDepo = a.fdKodeDepo AND b.fdKodeSF = a.fdKodeSF '
          ' AND b.fdKodeLangganan = a.fdKodeLangganan AND b.fdJenisActivity = \'03\' '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND b.fdEndDate IS NOT NULL AND b.fdEndDate <> \'\' '
          ' AND EXISTS '
          '   (SELECT 1 FROM ${mdbconfig.tblLanggananActivity} c '
          '   WHERE c.fdKodeDepo = b.fdKodeDepo AND c.fdKodeSF = b.fdKodeSF '
          '     AND c.fdKodeLangganan = b.fdKodeLangganan AND c.fdCategory = \'NotVisit\' '
          '     AND c.fdPhoto = \'\')',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        mapSFSummary.putIfAbsent('notvisit', () => results[0]['rowNo'] as int);
      }
    });

    return mapSFSummary;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> countLanggananNotComplete(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  var rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo '
          ' AND c.fdJenisActivity = \'03\' '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND (c.fdEndDate IS NULL OR c.fdEndDate = \'\')',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        rowCount = results[0]['rowNo'] as int;
      }
    });

    return rowCount;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> countLanggananExist(String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  var rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowNo '
          'FROM ${mdbconfig.tblLangganan} a '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? ',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        rowCount = results[0]['rowNo'] as int;
      }
    });

    return rowCount;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<mlgn.Langganan> getLanggananInfo(
    String fdKodeLangganan, String fdKodeDepo) async {
  late Database db;
  mlgn.Langganan item = mlgn.Langganan.empty();

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      await txn.rawQuery(
          'SELECT a.fdKodeDepo, a.fdKodeLangganan, a.fdKodeExternal, fdNamaLangganan, fdContactPerson, fdAlamat, '
          'fdKodeTipeLangganan, fdTipeLangganan, fdKodeDC, fdDC, fdGroupLangganan, fdNamaGroupLangganan, fdOwner, fdAmountChiller, '
          'fdNIK, fdNPWP, a.fdLA, a.fdLG, fdKota, fdPhone, a.fdLimitKredit, a.fdKodeHarga, '
          'c.fdStartDate fdStartVisitDate, c.fdEndDate fdEndVisitDate, b.fdReason fdNotVisitReason, a.IsRute, '
          'c.fdIsPaused, d.fdReason fdPauseReason, a.isEditProfile '
          // 'SELECT * '
          'FROM ${mdbconfig.tblLangganan} a '
          'LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo '
          ' AND b.fdCategory = \'NotVisit\' '
          'LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdKodeDepo = a.fdKodeDepo '
          ' AND c.fdJenisActivity = \'03\' '
          'LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo '
          ' AND d.fdCategory = \'Pause\' '
          'WHERE a.fdKodeLangganan = ? AND a.fdKodeDepo = ?',
          [fdKodeLangganan, fdKodeDepo]).then((value) async {
        if (value.isNotEmpty) {
          item = mlgn.Langganan.setData(value.first);
        }
      });
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return item;
}

Future<List<mlgn.Langganan>> getAllLanggananNonRute(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<mlgn.Langganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdKodeDepo, a.fdKodeLangganan, a.fdKodeExternal, a.fdNamaLangganan, a.fdContactPerson, '
          'a.fdKodeTipeLangganan, a.fdTipeLangganan, fdKodeDC, fdDC, fdGroupLangganan, fdNamaGroupLangganan, fdOwner, fdAmountChiller, '
          'a.fdNIK, a.fdNPWP, a.fdLA, a.fdLG, fdAlamat, fdKota, '
          'b.fdReason fdNotVisitReason, a.IsRute, '
          '(CASE WHEN c.fdKodeLangganan IS NOT NULL OR b.fdKodeLangganan IS NOT NULL THEN 1 ELSE 0 END) isLocked '
          'FROM ${mdbconfig.tblLangganan} a '
          'LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdKodeDepo = a.fdKodeDepo '
          ' AND b.fdCategory = \'NotVisit\' '
          'LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeLangganan AND c.fdJenisActivity = \'03\' '
          'WHERE a.IsRute = 0 or (a.IsRute = 1 AND a.fdKodeStatus = 0) ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlgn.Langganan.setData(element));
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

Future<List<mlgn.Langganan>> getLanggananActivity(
    String fdKodeLangganan, String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<mlgn.Langganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdKodeSF, a.fdKodeDepo, a.fdKodeLangganan, a.fdCategory, a.fdKodeReason, a.fdReason, a.fdKeterangan, a.fdPhoto, '
          ' b.fdIsPaused, a.fdLastUpdate, a.fdTanggal '
          'FROM ${mdbconfig.tblLanggananActivity} a '
          'LEFT JOIN ${mdbconfig.tblSFActivity} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdJenisActivity = \'03\' '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ? AND a.fdKodeLangganan = ? ',
          [fdKodeSF, fdKodeDepo, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlgn.Langganan.setData(element));
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

Future<List<mlgn.Reason>> getListReasonInfo(
    String fdTipe, Transaction txn) async {
  List<mlgn.Reason> items = [];

  //Tipe 1 = Not Visit
  var results = await txn.rawQuery(
      'SELECT fdKodeReason, fdReasonDescription, fdCamera, fdFreeTeks '
      'FROM ${mdbconfig.tblReason} '
      'WHERE fdTipe = ? '
      'ORDER BY fdKodeReason',
      [fdTipe]);

  for (var element in results) {
    items.add(mlgn.Reason.setData(element));
  }

  return items;
}

Future<bool> isLanggananActNotSent(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLanggananActivity} a '
          'WHERE fdStatusSent = 0 AND fdKodeLangganan = ? AND fdTanggal = ?',
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

Future<void> insertReasonBatch(List<mlgn.Reason> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblReason}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdTipe': element.fdTipe,
          'fdDescription': element.fdDescription,
          'fdKodeReason': element.fdKodeReason,
          'fdReasonDescription': element.fdReasonDescription,
          'fdCamera': element.fdCamera,
          'fdFreeTeks': element.fdFreeTeks,
          'fdCancelVisit': element.fdCancelVisit,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblReason, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertNoteLanggananAct(
    String fdKodeLangganan,
    String fdKodeDepo,
    String fdKodeSF,
    String? fdTanggal,
    String? fdReason,
    String fdPhoto,
    String fdCategory,
    String fdKeterangan) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();
      Map<String, dynamic> item = {
        'fdKodeDepo': fdKodeDepo,
        'fdKodeSF': fdKodeSF,
        'fdKodeLangganan': fdKodeLangganan,
        'fdTanggal': fdTanggal,
        'fdCategory': fdCategory,
        'fdReason': fdReason,
        'fdPhoto': fdPhoto,
        'fdKeterangan': fdKeterangan,
        'fdStatusSent': 0,
        'fdLastUpdate': param.dateTimeFormatDB.format(DateTime.now())
      };

      batchTx.insert(mdbconfig.tblLanggananActivity, item,
          conflictAlgorithm: ConflictAlgorithm.replace);

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<String> getNoteLanggananAct(String fdKodeLangganan, String fdKodeDepo,
    String fdKodeSF, String fdDate) async {
  late Database db;
  String sNote = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT fdKeterangan FROM ${mdbconfig.tblLanggananActivity} WHERE fdKodeLangganan = ? AND fdKodeDepo = ? AND fdKodeSF = ? "
          ' AND fdTanggal = ? AND fdCategory = \'Note\'',
          [fdKodeLangganan, fdKodeDepo, fdKodeSF, fdDate]);

      if (results.isNotEmpty) {
        sNote = results.first['fdKeterangan'].toString();
      }
    });
    return sNote;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertLanggananNonRuteNooBatch(
    String? noEntry,
    String? fileName,
    String? parKodeSF,
    String? parDepo,
    String? token,
    String? fdNamaToko,
    String? fdAlamat,
    String? fdCity,
    String? fdDC,
    String? fdLA,
    String? fdLG,
    String? fdTipeOutlet,
    String? fdTipeHarga,
    String? fdGroupOutlet,
    String? fdKodeExternal,
    int? fdChiller,
    String? fdKodeRute) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO ${mdbconfig.tblLangganan}(fdKodeLangganan , fdKodeDepo , fdKodeSF , '
          'fdNamaLangganan , fdContactPerson , fdAlamat , fdKota , fdPhone , '
          'fdKodeTipeLangganan , fdTipeLangganan, fdKodeDC , fdDC , '
          'fdAmountChiller , fdGroupLangganan , fdNamaGroupLangganan , '
          'fdNIK , fdNPWP , fdLA , fdLG , isRute , '
          'fdOwner, fdKodeExternal , fdKodeRute , fdStatusSent , fdLastUpdate) '
          'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
          [
            noEntry,
            parDepo,
            parKodeSF,
            fdNamaToko,
            '',
            fdAlamat,
            fdCity,
            '',
            fdTipeOutlet,
            '',
            fdDC,
            '',
            fdChiller,
            fdGroupOutlet,
            '',
            '',
            '',
            fdLA,
            fdLG,
            0,
            '',
            fdKodeExternal,
            fdKodeRute,
            0,
            DateFormat('dd-MM-yyyy').format(DateTime.now()),
          ]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> checkMaxLanggananPause(
    String fdKodeSF, String fdKodeDepo, String startDayDate) async {
  late Database db;
  int rowCount = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLanggananActivity} a '
          'WHERE a.fdKodeSF = ? AND a.fdKodeDepo = ?  AND a.fdTanggal = ? AND a.fdCategory = \'Pause\' ',
          [fdKodeSF, fdKodeDepo, startDayDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
    return rowCount;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mlgn.Reason>> getListReasonCancel(
    String fdTipe, Transaction txn) async {
  List<mlgn.Reason> items = [];

  //Tipe 1 = Not Visit
  var results = await txn.rawQuery(
      'SELECT fdKodeReason, fdReasonDescription, fdCamera, fdFreeTeks '
      'FROM ${mdbconfig.tblReason} '
      'WHERE fdTipe = ? AND fdCancelVisit=? '
      'ORDER BY fdKodeReason',
      [fdTipe, 1]);

  for (var element in results) {
    items.add(mlgn.Reason.setData(element));
  }

  return items;
}

Future<bool> isCancelVisit(String fdKodeSF, String fdKodeDepo,
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLanggananActivity} a '
          'WHERE fdStatusSent = 0 AND fdKodeSF = ? AND fdKodeDepo = ? AND  fdKodeLangganan = ? AND fdTanggal = ?',
          [fdKodeSF, fdKodeDepo, fdKodeLangganan, fdDate]);

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

Future<List<mlgn.Langganan>> getLanggananByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<mlgn.Langganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblLangganan} a '
          'WHERE a.fdKodeLangganan = ?  ',
          [fdKodeLangganan]);
      for (var element in results) {
        items.add(mlgn.Langganan.setData(element));
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mlgn.LanggananAlamat>> getAllLanggananAlamat(
    String fdKodeLangganan) async {
  late Database db;
  List<mlgn.LanggananAlamat> items = [];
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblLanggananAlamat} a '
          'WHERE a.fdKodeLangganan = ?  '
          'ORDER BY a.fdJenis, a.fdNoUrut ',
          [fdKodeLangganan]);

      for (var element in results) {
        items.add(mlgn.LanggananAlamat.setData(element));
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return items;
}

Future<List<mlgn.Langganan>> getLanggananOrder(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<mlgn.Langganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT DISTINCT a.fdKodeDepo, a.fdKodeLangganan, a.fdKodeExternal, a.fdNamaLangganan, a.fdContactPerson, '
          'a.fdKodeTipeLangganan, a.fdTipeLangganan, fdKodeDC, fdDC, fdGroupLangganan, fdNamaGroupLangganan, fdOwner, fdAmountChiller, '
          'a.fdNIK, a.fdNPWP, a.fdLA, a.fdLG, fdAlamat, fdKota, '
          ' a.IsRute '
          'FROM ${mdbconfig.tblLangganan} a '
          'INNER JOIN ${mdbconfig.tblOrder} b ON b.fdKodeLangganan = a.fdKodeLangganan AND b.fdDepo = a.fdKodeDepo '
          'WHERE a.IsRute = 0 or (a.IsRute = 1 AND a.fdKodeStatus = 0) ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlgn.Langganan.setData(element));
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

Future<int> countCall() async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLangganan} a '
          'INNER JOIN ${mdbconfig.tblSFActivity} b ON b.fdKodeDepo = a.fdKodeDepo AND b.fdKodeSF = a.fdKodeSF '
          ' AND b.fdKodeLangganan = a.fdKodeLangganan AND b.fdJenisActivity = \'03\' ');

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount;
}

Future<int> getJatuhTempo(String fdNoEntryFaktur) async {
  late Database db;
  // List<mlgn.LanggananTOP> items = [];
  int top = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select DISTINCT case when  LT.fdTOP IS NULL THEN "
          "	case when  LTG.fdTOP IS NULL THEN "
          "		case when  BT.fdTOP IS NULL THEN "
          "					BTB.fdTOP "
          "			else BT.fdTOP end "
          "	else LTG.fdTOP  end "
          "else LT.fdTOP end as fdTOP "
          "from ${mdbconfig.tblFaktur} O "
          "inner join ${mdbconfig.tblFakturItem} OI on OI.fdNoEntryFaktur = O.fdNoEntryFaktur "
          "inner join ${mdbconfig.tblBarang} B on OI.fdKodeBarang = B.fdKodeBarang "
          "LEFT JOIN ${mdbconfig.tblLangganan} L on L.fdKodeLangganan = O.fdKodeLangganan "
          "LEFT JOIN ${mdbconfig.tblLanggananTOP} LT on LT.fdKodeBarang = OI.fdKodeBarang and LT.fdKodeLangganan = O.fdKodeLangganan "
          "LEFT JOIN ${mdbconfig.tblLanggananTOP} LTG on LTG.fdKodeLangganan = O.fdKodeLangganan AND LTG.fdKodeGroup =B.fdKodeGroup "
          "LEFT join ${mdbconfig.tblBarangTOP} BT on BT.fdKodeGroup = B.fdKodeGroup and BT.fdKodeHarga = L.fdKodeHarga and BT.fdkodeBarang ='' "
          "LEFT JOIN ${mdbconfig.tblBarangTOP} BTB on BTB.fdKodeHarga = L.fdKodeHarga and BTB.fdKodeBarang = OI.fdKodeBarang "
          "where O.fdNoEntryFaktur = ? ",
          [fdNoEntryFaktur]);

      if (results.isNotEmpty) {
        top = results[0]['fdTOP'] ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return top;
}

Future<List<mlgn.Bank>> getBank() async {
  late Database db;
  List<mlgn.Bank> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          '''SELECT * FROM ${mdbconfig.tblBank} order by fdNamaSingkat ''');
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlgn.Bank.setData(element));
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
