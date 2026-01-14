import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as cpath;
import '../models/database.dart' as mdbconfig;
import '../models/kelurahan.dart' as mkel;

void createTblKelurahan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblKelurahan} (fdKodeKelurahan varchar(20) Primary Key, 
          fdNamaKelurahan varchar(50), 
          fdKodeKecamatan varchar(10),
          fdKodePos varchar(10), 
          fdLastUpdate varchar(25) )''');
  });
}

Future<int> checkKelurahan_isExist(Database db, String? fdKodeKelurahan) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblKelurahan} WHERE fdKodeKelurahan = ?',
        [fdKodeKelurahan]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertKelurahan(
    Database db,
    String? fdKodeKelurahan,
    String? fdNamaKelurahan,
    String? fdKodeKecamatan,
    String? fdKodePos,
    String? fdLastUpdate) async {
  int rowResult = 0;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  await db.transaction((txn) async {
    rowResult = await txn.rawInsert(
        'INSERT INTO ${mdbconfig.tblKelurahan}(fdKodeKelurahan, fdNamaKelurahan, fdKodeKecamatan,fdKodePos,fdLastUpdate ) VALUES(?,?,?,?,?)',
        [
          fdKodeKelurahan,
          fdNamaKelurahan,
          fdKodeKecamatan,
          fdKodePos,
          fdLastUpdate
        ]);
  });

  return rowResult;
}

Future<int> updateKelurahan(
    Database db,
    String? fdKodeKelurahan,
    String? fdNamaKelurahan,
    String? fdKodeKecamatan,
    String? fdKodePos,
    String? fdLastUpdate) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblKelurahan} SET fdNamaKelurahan = ?, fdKodeKelurahan =?, fdKodePos?, fdLastUpdate =? WHERE fdKodeKelurahan = ?',
        [
          fdNamaKelurahan,
          fdKodeKelurahan,
          fdKodePos,
          fdLastUpdate,
          fdKodeKelurahan
        ]);
  });

  return rowResult;
}

Future<void> insertKelurahanBatch(List<mkel.Kelurahan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblKelurahan}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeKelurahan': element.fdKodeKelurahan,
          'fdNamaKelurahan': element.fdNamaKelurahan,
          'fdKodeKecamatan': element.fdKodeKecamatan,
          'fdKodePos': element.fdKodePos,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblKelurahan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mkel.Kelurahan>> getListKelurahan(String fdKodeKecamatan) async {
  late Database db;
  List<mkel.Kelurahan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKelurahan} where fdKodeKecamatan=? ORDER BY fdKodeKelurahan',
          [fdKodeKecamatan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkel.Kelurahan.setData(element));
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

Future<List<mkel.Kelurahan>> getListKelurahanByKode(
    String fdKodeKelurahan) async {
  late Database db;
  List<mkel.Kelurahan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKelurahan} where fdKodeKelurahan=? ORDER BY fdKodeKelurahan',
          [fdKodeKelurahan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkel.Kelurahan.setData(element));
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

Future<String> getKodePos(String fdKodeKelurahan) async {
  late Database db;
  String kodePos = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKelurahan} where fdKodeKelurahan=?  ',
          [fdKodeKelurahan]);

      if (results.isNotEmpty) {
        kodePos = results[0]['fdKodePos'];
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return kodePos;
}

Future<String> getStringKecamatanByKelurahan(String fdKodeKelurahan) async {
  late Database db;
  String kodeKecamatan = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKelurahan} where fdKodeKelurahan=? ORDER BY fdKodeKelurahan',
          [fdKodeKelurahan]);

      if (results.isNotEmpty) {
        kodeKecamatan = results[0]['fdKodeKecamatan'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return kodeKecamatan;
}
