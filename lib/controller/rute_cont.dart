import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/rencanarute.dart' as mrrute;
import '../models/globalparam.dart' as param;

Future<void> createTblRencanaRute(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblRencanaRute} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdKodeDepo varchar(10), fdNoRencanaRute varchar(30) UNIQUE, fdStartDate varchar(25), fdEndDate varchar(25),
          fdTanggal varchar(25), fdKodeSF varchar(20), fdKodeStatus int, 
          fdStatusSent int, fdLastUpdate varchar(25) )''');
  });
}

Future<void> createTblRencanaRuteLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblRencanaRuteLangganan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdNoRencanaRute varchar(30) , fdTanggalRencanaRute varchar(25) , fdKodeLangganan varchar(30) , 
          fdPekan varchar(3), fdHari varchar(3), fdLastUpdate varchar(25), UNIQUE(fdNoRencanaRute, fdTanggalRencanaRute, fdKodeLangganan))''');
  });
}

Future<void> createTblRencanaRuteFaktur(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblRencanaRuteFaktur} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdNoRencanaRute varchar(30), fdNoEntryFaktur varchar(10) UNIQUE, fdSisaNilaiInvoice REAL,
          fdKeterangan varchar(225), fdNoFaktur varchar(30), fdTanggalJT varchar(30), fdTanggalFaktur varchar(30), 
          fdKodeLangganan varchar(30), fdNamaLangganan varchar(300), fdLastUpdate varchar(25) )''');
  });
}

Future<void> createTblTempRencanaRuteLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblTempRencanaRuteLangganan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdNoRencanaRute varchar(30), fdTanggalRencanaRute varchar(25), fdKodeLangganan varchar(30), 
          fdPekan varchar(3), fdHari varchar(3), fdLastUpdate varchar(25) )''');
  });
}

Future<void> createTblSyncRencanaRute(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSyncRencanaRute} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdKodeDepo varchar(10), fdNoRencanaRute varchar(30), fdStartDate varchar(25), fdEndDate varchar(25),
          fdTanggal varchar(25), fdKodeSF varchar(20), fdKodeStatus int, 
          fdStatusSent int, fdLastUpdate varchar(25) )''');
  });
}

Future<void> createTblSyncRencanaRuteLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSyncRencanaRuteLangganan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdNoRencanaRute varchar(30), fdTanggalRencanaRute varchar(25), fdKodeLangganan varchar(30), fdNamaLangganan varchar(300), 
          fdPekan varchar(3), fdHari varchar(3), fdLastUpdate varchar(25) )''');
  });
}

//x
Future<void> insertTempRencanaRuteBatch(List<mrrute.RencanaRute> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRute}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeDepo': element.fdKodeDepo,
          'fdNoRencanaRute': element.fdNoRencanaRute,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdTanggal': element.fdTanggal,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeStatus': element.fdKodeStatus,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblRencanaRute, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertRencanaRuteLanggananBatch(
    List<mrrute.RencanaNonRuteLangganan> items, String fdNoRencanaRute) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRuteLangganan} ');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoRencanaRute': element.fdNoRencanaRute,
          'fdTanggalRencanaRute': element.fdTanggalRencanaRute,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdPekan': element.fdPekan,
          'fdHari': element.fdHari,
          'fdLastUpdate': element.fdLastUpdate
        };

        // batchTx.insert(mdbconfig.tblRencanaRuteLangganan, item);
        batchTx.insert(
          mdbconfig.tblRencanaRuteLangganan,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // UPSERT
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

Future<void> insertRencanaRuteFakturBatch(
    List<mrrute.RencanaRuteFaktur> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRuteFaktur}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoRencanaRute': element.fdNoRencanaRute,
          'fdNoEntryFaktur': element.fdNoEntryFaktur,
          'fdSisaNilaiInvoice': element.fdSisaNilaiInvoice,
          'fdNoFaktur': element.fdNoFaktur,
          'fdTanggalJT': element.fdTanggalJT,
          'fdTanggalFaktur': element.fdTanggalFaktur,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdNamaLangganan': element.fdNamaLangganan,
          'fdKeterangan': element.fdKeterangan,
          'fdLastUpdate': element.fdLastUpdate
        };

        // batchTx.insert(mdbconfig.tblRencanaRuteFaktur, item);
        batchTx.insert(
          mdbconfig.tblRencanaRuteFaktur,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // UPSERT
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

Future<void> insertSyncRencanaRuteBatch(List<mrrute.RencanaRute> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSyncRencanaRute}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeDepo': element.fdKodeDepo,
          'fdNoRencanaRute': element.fdNoRencanaRute,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdTanggal': element.fdTanggal,
          'fdKodeSF': element.fdKodeSF,
          'fdKodeStatus': element.fdKodeStatus,
          'fdLastUpdate': element.fdLastUpdate
        };

        // batchTx.insert(mdbconfig.tblSyncRencanaRute, item);
        batchTx.insert(
          mdbconfig.tblRencanaRute,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // UPSERT
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

Future<void> insertSyncRencanaRuteLanggananBatch(
    List<mrrute.RencanaRuteLangganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSyncRencanaRuteLangganan}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoRencanaRute': element.fdNoRencanaRute,
          'fdTanggalRencanaRute': DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(element.fdTanggalRencanaRute)),
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdPekan': element.fdPekan,
          'fdHari': element.fdHari,
          'fdLastUpdate': element.fdLastUpdate
        };

        // batchTx.insert(mdbconfig.tblSyncRencanaRuteLangganan, item);
        batchTx.insert(
          mdbconfig.tblRencanaRuteLangganan,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // UPSERT
        );
        batchTx.insert(
          mdbconfig.tblTempRencanaRuteLangganan,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // UPSERT
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

Future<void> insertRencanaRuteBatch(
    String fdKodeDepo,
    String fdNoRencanaRute,
    String fdStartDate,
    String fdEndDate,
    String fdTanggal,
    String fdKodeSF) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      Map<String, dynamic> item = {
        'fdKodeDepo': fdKodeDepo,
        'fdNoRencanaRute': fdNoRencanaRute,
        'fdStartDate': fdStartDate,
        'fdEndDate': fdEndDate,
        'fdTanggal': fdTanggal,
        'fdKodeSF': fdKodeSF,
        'fdKodeStatus': 0,
        'fdLastUpdate': param.dateTimeFormatDB.format(DateTime.now()),
      };

      batchTx.insert(mdbconfig.tblRencanaRute, item);

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertTempRencanaRuteLanggananBatch(
    List<mrrute.RencanaNonRuteLangganan> items,
    String fdNoRencanaRute,
    String fdTanggalRencanaRute) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblTempRencanaRuteLangganan} WHERE fdNoRencanaRute=? AND fdTanggalRencanaRute=? ',
          [fdNoRencanaRute, fdTanggalRencanaRute]);

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoRencanaRute': fdNoRencanaRute,
          'fdTanggalRencanaRute': fdTanggalRencanaRute,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdPekan': element.fdPekan,
          'fdHari': element.fdHari,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblTempRencanaRuteLangganan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteRencanaRuteBatch(String fdNoRencanaRute) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblRencanaRute} WHERE fdNoRencanaRute=? ',
          [fdNoRencanaRute]);
      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblTempRencanaRuteLangganan} WHERE fdNoRencanaRute=? ',
          [fdNoRencanaRute]);
      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblRencanaRuteLangganan} WHERE fdNoRencanaRute=? ',
          [fdNoRencanaRute]);

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusStopRencanaRute(String fdNoRencanaRute) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblRencanaRute} SET fdKodeStatus = ? '
          'WHERE fdNoRencanaRute = ?',
          [1, fdNoRencanaRute]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mrrute.RencanaRute>> getRencanaRute() async {
  late Database db;
  List<mrrute.RencanaRute> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * '
          'FROM ${mdbconfig.tblRencanaRute} order by fdKodeHarga ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaRute.setData(element));
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

Future<List<mrrute.RencanaRute>> getAllRencanaRute() async {
  late Database db;
  List<mrrute.RencanaRute> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results =
          await txn.rawQuery('SELECT a.* FROM ${mdbconfig.tblRencanaRute} a ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaRute.setData(element));
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

Future<List<mrrute.RencanaNonRuteLangganan>> getAllRencanaRuteLangganan(
    String fdKodeSF, String fdKodeDepo, String fdTanggalRencanaRute) async {
  late Database db;
  List<mrrute.RencanaNonRuteLangganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdNoRencanaRute, a.fdKodeLangganan, a.fdTanggalRencanaRute, 1 as isCheck  '
          'FROM ${mdbconfig.tblTempRencanaRuteLangganan} a '
          'WHERE a.fdTanggalRencanaRute=? ',
          [fdTanggalRencanaRute]);
      // var results = await txn.rawQuery(
      //     'SELECT a.fdNoRencanaRute, a.fdKodeLangganan, a.fdTanggalRencanaRute, 1 as isCheck  '
      //     'FROM ${mdbconfig.tblRencanaRuteLangganan} a '
      //     'WHERE a.fdTanggalRencanaRute=? ',
      //     [fdTanggalRencanaRute]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaNonRuteLangganan.setData(element));
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

Future<List<mrrute.ViewRencanaRuteFaktur>> getAllRencanaRuteFaktur() async {
  late Database db;
  List<mrrute.ViewRencanaRuteFaktur> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdNoRencanaRute ,b.fdStartDate, b.fdEndDate, c.fdTanggalRencanaRute, a.fdNoEntryFaktur, '
          'count(a.fdNoRencanaRute) as fdCountInv, sum(a.fdSisaNilaiInvoice) as fdSisaNilaiInvoice '
          'FROM ${mdbconfig.tblRencanaRuteFaktur} a '
          'inner join ${mdbconfig.tblRencanaRute} b on a.fdNoRencanaRute=b.fdNoRencanaRute '
          'inner join ${mdbconfig.tblRencanaRuteLangganan} c on c.fdNoRencanaRute=b.fdNoRencanaRute and a.fdKodeLangganan=c.fdKodeLangganan '
          'GROUP BY b.fdStartDate, b.fdEndDate, c.fdTanggalRencanaRute ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.ViewRencanaRuteFaktur.setData(element));
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

Future<List<mrrute.ViewDetailRencanaRuteFaktur>> getDataRencanaRuteFakturDetail(
    String fdNoRencanaRute, String fdTanggalRencanaRute) async {
  late Database db;
  List<mrrute.ViewDetailRencanaRuteFaktur> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdNoRencanaRute ,b.fdStartDate, b.fdEndDate, c.fdTanggalRencanaRute, a.fdTanggalJT, a.fdNoEntryFaktur, '
          'a.fdSisaNilaiInvoice, a.fdKodeLangganan, a.fdNamaLangganan, a.fdTanggalFaktur, a.fdNoFaktur '
          'FROM ${mdbconfig.tblRencanaRuteFaktur} a '
          'inner join ${mdbconfig.tblSyncRencanaRute} b on a.fdNoRencanaRute=b.fdNoRencanaRute '
          'inner join ${mdbconfig.tblSyncRencanaRuteLangganan} c on c.fdNoRencanaRute=b.fdNoRencanaRute and a.fdKodeLangganan=c.fdKodeLangganan '
          'WHERE a.fdNoRencanaRute=? AND c.fdTanggalRencanaRute=? ',
          [fdNoRencanaRute, fdTanggalRencanaRute]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.ViewDetailRencanaRuteFaktur.setData(element));
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

Future<List<mrrute.RencanaRuteLangganan>> getDataViewRencanaRuteLangganan(
    String fdKodeSF, String fdKodeDepo, String fdTanggalRencanaRute) async {
  late Database db;
  List<mrrute.RencanaRuteLangganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdNoRencanaRute, a.fdKodeLangganan, a.fdTanggalRencanaRute, a.fdPekan, a.fdHari, 1 as isCheck  '
          'FROM ${mdbconfig.tblTempRencanaRuteLangganan} a '
          'WHERE a.fdTanggalRencanaRute=? ',
          [fdTanggalRencanaRute]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaRuteLangganan.setData(element));
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

Future<List<mrrute.RencanaRuteApi>> getDataRencanaRuteApi(
    String fdNoRencanaRute) async {
  late Database db;
  List<mrrute.RencanaRuteApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT a.fdKodeDepo, a.fdNoRencanaRute, a.fdStartDate, a.fdEndDate, "
          "a.fdTanggal, a.fdKodeSF, a.fdKodeStatus, b.fdTanggalRencanaRute, "
          "b.fdKodeLangganan, '' fdNamaLangganan, '' fdAlamat, b.fdPekan, b.fdHari, a.fdLastUpdate "
          "FROM ${mdbconfig.tblRencanaRute} a "
          "inner join ${mdbconfig.tblTempRencanaRuteLangganan} b on a.fdNoRencanaRute=b.fdNoRencanaRute "
          "left join ${mdbconfig.tblLangganan} c on c.fdKodeLangganan=b.fdKodeLangganan "
          "WHERE a.fdNoRencanaRute=? ",
          [fdNoRencanaRute]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaRuteApi.setData(element));
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

Future<List<mrrute.RencanaRuteApi>> getDataDeleteRencanaRuteApi(
    String fdNoRencanaRute) async {
  late Database db;
  List<mrrute.RencanaRuteApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT a.fdKodeDepo, a.fdNoRencanaRute, a.fdStartDate, a.fdEndDate, "
          "a.fdTanggal, a.fdKodeSF, a.fdKodeStatus, '' fdTanggalRencanaRute, "
          "'' fdKodeLangganan, '' fdNamaLangganan, '' fdAlamat, '' fdPekan, '' fdHari, a.fdLastUpdate "
          "FROM ${mdbconfig.tblRencanaRute} a "
          "WHERE a.fdNoRencanaRute=? ",
          [fdNoRencanaRute]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mrrute.RencanaRuteApi.setData(element));
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

Future<String> getNoRencanaRuteByStartDayDate(String startDayDate) async {
  late Database db;
  String fdNoRencanaRute = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT a.fdNoRencanaRute "
          "FROM ${mdbconfig.tblRencanaRute} a "
          "WHERE ? BETWEEN strftime('%Y-%m-%d',a.fdStartDate) AND strftime('%Y-%m-%d',a.fdEndDate) ",
          [startDayDate]);

      if (results.isNotEmpty) {
        fdNoRencanaRute = results.first['fdNoRencanaRute'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdNoRencanaRute;
}

Future<bool> cekIsLastDayRencanaRute(String startDayDate) async {
  late Database db;
  bool isLastDay = false;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT a.fdNoRencanaRute "
          "FROM ${mdbconfig.tblRencanaRute} a "
          "WHERE strftime('%Y-%m-%d',a.fdEndDate)=? ",
          [startDayDate]);

      if (results.isNotEmpty) {
        isLastDay = true;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return isLastDay;
}

Future<bool> checkRencanaRuteExists(String todayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblRencanaRute} a '
          'WHERE date(?) BETWEEN date(a.fdStartDate) AND date(a.fdEndDate) ',
          [todayDate]);

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

Future<bool> checkIsRuteBiasa(String startDayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          '''SELECT  COUNT(0) rowCount FROM ${mdbconfig.tblRencanaRute} 
          WHERE fdStartDate=fdEndDate and fdStartDate=? ''', [startDayDate]);

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

Future<bool> checkPeriodRencanaRute(
    String ymdStartDate, String ymdEndDate) async {
  late Database db;
  bool isExist = false;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "SELECT a.fdNoRencanaRute "
          "FROM ${mdbconfig.tblRencanaRute} a "
          "WHERE (? BETWEEN strftime('%Y-%m-%d',a.fdStartDate) AND strftime('%Y-%m-%d',a.fdEndDate) OR "
          " ? BETWEEN strftime('%Y-%m-%d',a.fdStartDate) AND strftime('%Y-%m-%d',a.fdEndDate) ) ",
          [ymdStartDate, ymdEndDate]);

      if (results.isNotEmpty) {
        isExist = true;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return isExist;
}
