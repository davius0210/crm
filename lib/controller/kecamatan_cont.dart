import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as cpath;
import '../models/database.dart' as mdbconfig;
import '../models/kecamatan.dart' as mkec;

void createTblKecamatan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblKecamatan} (fdKodeKecamatan varchar(20) Primary Key, 
          fdNamaKecamatan varchar(50), 
          fdKodeKabupaten varchar(10), 
          fdLastUpdate varchar(25) )''');
  });
}

Future<int> checkKecamatan_isExist(Database db, String? fdKodeKecamatan) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblKecamatan} WHERE fdKodeKecamatan = ?',
        [fdKodeKecamatan]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertKecamatan(
    Database db,
    String? fdKodeKecamatan,
    String? fdNamaKecamatan,
    String? fdKodeKabupaten,
    String? fdLastUpdate) async {
  int rowResult = 0;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  var batch = db.batch();
  try {
    batch.insert(mdbconfig.tblKecamatan, {
      'fdKodeKecamatan': fdKodeKecamatan,
      'fdNamaKecamatan': fdNamaKecamatan,
      'fdKodeKabupaten': fdKodeKabupaten,
      'fdLastUpdate': fdLastUpdate
    });
    await batch.commit();
  } catch (e) {
    print("${e.toString()}");
  }

  return rowResult;
}

Future<int> updateKecamatan(
    Database db,
    String? fdKodeKabupaten,
    String? fdNamaKecamatan,
    String? fdKodeKecamatan,
    String? fdLastUpdate) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblKecamatan} SET fdNamaKecamatan = ?, fdKodeKabupaten =? fdLastUpdate =? WHERE fdKodeKecamatan = ?',
        [fdNamaKecamatan, fdKodeKabupaten, fdLastUpdate, fdKodeKecamatan]);
  });

  return rowResult;
}

Future<void> insertKecamatanBatch(List<mkec.Kecamatan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblKecamatan}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeKecamatan': element.fdKodeKecamatan,
          'fdNamaKecamatan': element.fdNamaKecamatan,
          'fdKodeKabupaten': element.fdKodeKabupaten,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblKecamatan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mkec.Kecamatan>> getListKecamatan(String fdKodeKabupaten) async {
  late Database db;
  List<mkec.Kecamatan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKecamatan} where fdKodeKabupaten=? ORDER BY fdKodeKecamatan',
          [fdKodeKabupaten]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkec.Kecamatan.setData(element));
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

Future<List<mkec.Kecamatan>> getListKecamatanByKode(
    String fdKodeKecamatan) async {
  late Database db;
  List<mkec.Kecamatan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKecamatan} where fdKodeKecamatan=? ORDER BY fdKodeKecamatan',
          [fdKodeKecamatan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkec.Kecamatan.setData(element));
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

Future<String> getStringKabupatenByKecamatan(String fdKodeKecamatan) async {
  late Database db;
  String kodeKabupaten = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKecamatan} where fdKodeKecamatan=? ORDER BY fdKodeKecamatan',
          [fdKodeKecamatan]);

      if (results.isNotEmpty) {
        kodeKabupaten = results[0]['fdKodeKabupaten'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return kodeKabupaten;
}
