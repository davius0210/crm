import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'database_cont.dart' as cdb;
import '../models/globalparam.dart' as param;
import '../models/logdevice.dart' as mlog;
import '../models/database.dart' as mdbconfig;
import 'package:path/path.dart' as cpath;
Database? _db;
Database? _dbLog;

Future<void> createTblGpsLog() async {
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  try {
    db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);
    await db2.transaction((txn) async {
      await txn.execute(
          '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblGpsLog} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdLA varchar(25),
          fdLG varchar(25),
          fdBattery varchar(3),
          fdstreet varchar(250),
          fdsubLocality varchar(250),
          fdsubArea varchar(250),
          fdpostalCode varchar(25),
          fdEvent varchar(20),
          fdKodeLangganan varchar(20),
          fdDepo varchar(5),
          fdTanggal varchar(25),
          fdStatusSent int,
          fdLastUpdate  varchar(25) )''');
      await txn.execute(
          'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblSF} (fdUsername varchar(20), fdName varchar(50), fdKodeSF varchar(10) Primary Key, '
          'fdNamaSF varchar(50), fdKodeDepo varchar(2), fdNamaDepo varchar(50), fdTipeSF varchar(4), fdToken varchar(500), '
          'fdLoginDate varchar(16))');
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }
}

void createTblParameter(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblParameter} (fdID INTEGER PRIMARY KEY AUTOINCREMENT,
          fdKodeSF varchar(10),
          fdType varchar(25),
          fdDuration int,
          fdDurationTrack int,
          fdMaxRute int,
          fdMaxPause int,
          fdMaxDistance int,
          fdMaxBackup int,
          fdTimeoutGps int,
          fdTimeoutApi int,
          fdLastUpdate  varchar(25) )''');
  });
}

Future<void> alterTblParameter(Database db) async {
  bool columnExists =
      await cdb.isColumnExistTblParameter(db, mdbconfig.tblParameter, 'fdPPN');
  if (!columnExists) {
    await db.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblParameter} ADD COLUMN fdPPN int ''');
    });
  }
}

Future<int> getTimerDuration(String trackType) async {
  int timerDuration = 0;
  late Database db;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName);
  try {
    db = await openDatabase(logFullPath, version: mdbconfig.logVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = await txn.rawQuery(
        'SELECT fdDuration, fdDurationTrack FROM ${mdbconfig.tblParameter} WHERE fdType=\'Timer\' ',
      );

      if (results.isNotEmpty) {
        if (trackType == 'on') {
          timerDuration = results.first['fdDurationTrack'];
        } else if (trackType == 'off') {
          timerDuration = results.first['fdDuration'];
        }
      } else {
        timerDuration = 60;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return timerDuration;
}

Future<int> updateTimerParameter(int fdDuration) async {
  int rowResult = 0;
  late Database db;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName);
  try {
    db = await openDatabase(logFullPath, version: mdbconfig.logVersion);

    await db.transaction((txn) async {
      rowResult = await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblParameter} SET fdDurationTrack=? WHERE fdType=\'Timer\' ',
          [fdDuration]);
    });
  } catch (e) {
    try {
      if (db.isOpen) {
        db.close();
        db = await openDatabase(logFullPath, version: mdbconfig.logVersion);
      } else {
        db = await openDatabase(logFullPath, version: mdbconfig.logVersion);
      }
      await db.transaction((txn) async {
        rowResult = await txn.rawUpdate(
            'UPDATE ${mdbconfig.tblParameter} SET fdDurationTrack=? WHERE fdType=\'Timer\' ',
            [fdDuration]);
      });
    } catch (err) {
      throw Exception(err);
    }
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<int> checkTblGpsLog() async {
  int rowResult = 0;
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  try {
    db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);

    await db2.transaction((txn) async {
      List<Map<String, dynamic>> result = await txn.rawQuery(
        'SELECT * FROM sqlite_master WHERE name =? and type=? ',
        [mdbconfig.tblGpsLog, 'table'],
      );

      if (result.isNotEmpty) {
        rowResult = 1;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }
  return rowResult;
}

Future<int> insertGpsLog(
    String? fdLA,
    String? fdLG,
    String? fdBattery,
    String? fdstreet,
    String? fdsubLocality,
    String? fdsubArea,
    String? fdpostalCode,
    String fdEvent,
    String fdKodeLangganan,
    String fdDepo,
    String fdTanggal,
    String? fdLastproses) async {
  int rowResult = 0;
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  try {
    db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);

    await db2.transaction((txn) async {
      //Hanya boleh simpan 1 data start day / end day per tanggal transaksi
      if (fdEvent == 'Start Day' || fdEvent == 'End Day') {
        await txn.rawDelete(
            'DELETE FROM ${mdbconfig.tblGpsLog} WHERE fdEvent = ?', [fdEvent]);
      }

      rowResult = await txn.rawInsert(
          'INSERT INTO ${mdbconfig.tblGpsLog}(fdLA, fdLG, fdBattery, fdstreet,fdsubLocality,fdsubArea,fdpostalCode, fdEvent, '
          'fdKodeLangganan, fdDepo, fdStatusSent, fdTanggal, fdLastUpdate ) '
          'VALUES(?,?,?,?,?,?,?,?,?,?,0,?,?)',
          [
            fdLA,
            fdLG,
            fdBattery,
            fdstreet,
            fdsubLocality,
            fdsubArea,
            fdpostalCode,
            fdEvent,
            fdKodeLangganan,
            fdDepo,
            fdTanggal,
            fdLastproses
          ]);
      print('insert log: $rowResult');
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }
  return rowResult;
}

Future<List<Map<String, dynamic>>> getLogDevice(
    String fdKodeLangganan, String fdDateTime) async {
  late Database db2;
  List<Map<String, dynamic>> results = [];

  try {
    db2 = await openDatabase(mdbconfig.logFullPath,
        version: mdbconfig.logVersion);

    await db2.transaction((txn) async {
      if (fdKodeLangganan.isEmpty) {
        results = await txn.rawQuery(
            'SELECT * '
            'FROM ${mdbconfig.tblGpsLog} WHERE fdStatusSent=0 AND fdLastUpdate <= ? '
            'ORDER BY fdID',
            [fdDateTime]);
      } else {
        results = await txn.rawQuery(
            'SELECT * '
            'FROM ${mdbconfig.tblGpsLog} WHERE fdStatusSent=0 AND fdKodeLangganan = ? AND fdLastUpdate <= ? '
            'ORDER BY fdID',
            [fdKodeLangganan, fdDateTime]);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }

  return results;
}

Future<int> updateFdStatusSentLogDevice(String fdDateTime) async {
  int rowResult = 0;
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  try {
    db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);

    await db2.transaction((txn) async {
      rowResult = await txn.rawInsert(
          'UPDATE ${mdbconfig.tblGpsLog} SET fdStatusSent=1 WHERE fdStatusSent=0 AND fdLastUpdate <= ?',
          [fdDateTime]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }
  return rowResult;
}

Future<List<dynamic>> getLanggananByTblMD(String tblName) async {
  late Database db;

  List<Map<String, dynamic>> results = [];
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      results = await txn.rawQuery('SELECT fdKodeLangganan FROM $tblName');
    });
    // }
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  List<dynamic> resultSet = List.from(results);
  return resultSet;
}

Future<List<Map<String, dynamic>>> getDataTblMD(
    String tblName, String kodeLangganan) async {
  late Database db;
  List<Map<String, dynamic>> results = [];
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    if (kodeLangganan != '') {
      await db.transaction((txn) async {
        if (tblName == 'FtrSaOrderItem') {
          results = await txn.rawQuery(
              'SELECT * FROM ${mdbconfig.tblOrder} a inner join  $tblName  b ON a.fdNoEntryOrder = b.fdNoEntryOrder WHERE a.fdKodeLangganan=?',
              [kodeLangganan]);
        } else {
          results = await txn.rawQuery(
              'SELECT * FROM $tblName WHERE fdKodeLangganan=?',
              [kodeLangganan]);
        }
      });
    } else {
      if (tblName == 'FtrSaSalesActivity') {
        await db.transaction((txn) async {
          results = await txn.rawQuery('SELECT * FROM $tblName');
        });
      }
    }
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return results;
}

Future<List<Map<String, dynamic>>> getALLDataTblMD(String tblName) async {
  late Database db;
  List<Map<String, dynamic>> results = [];
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      results = await txn.rawQuery('SELECT * FROM $tblName');
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return results;
}

Future<void> insertParamBatch(List<mlog.Param> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblParameter}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeSF': element.fdKodeSF,
          'fdType': element.fdType,
          'fdDuration': element.fdDuration,
          'fdDurationTrack': element.fdDuration,
          'fdMaxRute': element.fdMaxRute,
          'fdMaxPause': element.fdMaxPause,
          'fdMaxDistance': element.fdMaxDistance,
          'fdMaxBackup': element.fdMaxBackup,
          'fdTimeoutGps': element.fdTimeoutGps,
          'fdTimeoutApi': element.fdTimeoutApi,
          'fdPPN': element.fdPPN,
        };

        batchTx.insert(mdbconfig.tblParameter, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mlog.Param>> getDataParamByKodeSf(fdKodeSF) async {
  late Database db;
  List<mlog.Param> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblParameter} '
          'WHERE fdKodeSF=? ',
          [fdKodeSF]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlog.Param.setData(element));
        }
      } else {
        results = await txn.rawQuery('SELECT * '
            'FROM ${mdbconfig.tblParameter} '
            'WHERE fdKodeSF=\'DEFAULT\' ');
        if (results.isNotEmpty) {
          for (var element in results) {
            items.add(mlog.Param.setData(element));
          }
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

Future<mlog.Salesman?> getSFLogIn() async {
  mlog.Salesman? user;
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  if (await databaseExists(logFullPath)) {
    try {
      db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);
      await db2.transaction((txn) async {
        var result = await txn.rawQuery(
            'SELECT fdKodeSF, fdNamaSF, fdKodeDepo, fdNamaDepo, fdTipeSF, fdToken, fdLoginDate '
            'FROM ${mdbconfig.tblSF} WHERE fdToken <> \'\'');

        if (result.isNotEmpty) {
          user = mlog.Salesman.setData(result.first);
        }
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db2.isOpen ? await db2.close() : null;
    }
  }

  return user;
}

Future<int> insertSFLogin(
    String fdKodeSF,
    String fdNamaSF,
    String fdKodeDepo,
    String fdNamaDepo,
    String fdTipeSF,
    String fdToken,
    bool? fdAkses,
    String? message,
    String fdLoginDate) async {
  int rowResult = 0;
  late Database db2;

  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  if (await databaseExists(logFullPath)) {
    try {
      db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);
      await db2.transaction((txn) async {
        Batch batchTx = txn.batch();
        Map<String, dynamic> item = {
          'fdKodeSF': fdKodeSF,
          'fdNamaSF': fdNamaSF,
          'fdKodeDepo': fdKodeDepo,
          'fdNamaDepo': fdNamaDepo,
          'fdTipeSF': fdTipeSF,
          'fdToken': fdToken,
          'fdLoginDate': fdLoginDate
        };

        batchTx.insert(mdbconfig.tblSF, item,
            conflictAlgorithm: ConflictAlgorithm.replace);

        await batchTx.commit(noResult: true);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db2.isOpen ? await db2.close() : null;
    }
  }
  return rowResult;
}

Future<int> updateSFToken(String fdToken, String fdKodeSF) async {
  late Database db2;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);

  if (await databaseExists(logFullPath)) {
    try {
      db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);

      await db2.transaction((txn) async {
        rowResult = await txn.rawUpdate(
            'UPDATE ${mdbconfig.tblSF} SET fdToken = ? '
            'WHERE fdKodeSF = ?',
            [fdToken, fdKodeSF]);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db2.isOpen ? await db2.close() : null;
    }
  }

  return rowResult;
}

Future<void> setGlobalParamByKodeSf(fdKodeSF) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblParameter} '
          'WHERE fdKodeSF=? ',
          [fdKodeSF]);

      if (results.isNotEmpty) {
        if (results[0]['fdTimeoutGps'] != null) {
          param.gpsTimeOut = results[0]['fdTimeoutGps'];
        }
        if (results[0]['fdTimeoutApi'] != null) {
          param.minuteTimeout = results[0]['fdTimeoutApi'];
        }
      } else {
        results = await txn.rawQuery('SELECT * '
            'FROM ${mdbconfig.tblParameter} '
            'WHERE fdKodeSF=\'DEFAULT\' ');
        if (results.isNotEmpty) {
          if (results[0]['fdTimeoutGps'] != null) {
            param.gpsTimeOut = results[0]['fdTimeoutGps'];
          }
          if (results[0]['fdTimeoutApi'] != null) {
            param.minuteTimeout = results[0]['fdTimeoutApi'];
          }
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}
