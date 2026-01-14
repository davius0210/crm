import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/kabupaten.dart' as mkab;
import 'package:path/path.dart' as cpath;

void createTblKabupaten(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblKabupaten} (fdKodeKabupaten varchar(20) Primary Key, 
          fdNamaKabupaten varchar(50), 
          fdKodePropinsi varchar(10), 
          fdLastUpdate varchar(25))''');
  });
}

Future<int> checkKabupaten_isExist(Database db, String? fdKodeKabupaten) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblKabupaten} WHERE fdKodeKabupaten = ?',
        [fdKodeKabupaten]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertKabupaten(
    Database db,
    String? fdKodeKabupaten,
    String? fdNamaKabupaten,
    String? fdKodePropinsi,
    String? fdLastUpdate) async {
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  var batch = db.batch();
  try {
    batch.insert(mdbconfig.tblKabupaten, {
      'fdKodeKabupaten': fdKodeKabupaten,
      'fdNamaKabupaten': fdNamaKabupaten,
      'fdKodePropinsi': fdKodePropinsi,
      'fdLastUpdate': fdLastUpdate
    });
    await batch.commit();
  } catch (e) {
    print("${e.toString()}");
  }

  return rowResult;
}

Future<int> updateKabupaten(
    Database db,
    String? fdKodePropinsi,
    String? fdNamaKabupaten,
    String? fdKodeKabupaten,
    String? fdLastUpdate) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblKabupaten} SET fdNamaKabupaten = ?, fdKodePropinsi =? fdLastUpdate =? WHERE fdKodeKabupaten = ?',
        [fdNamaKabupaten, fdKodePropinsi, fdLastUpdate, fdKodeKabupaten]);
  });

  return rowResult;
}

Future<void> insertKabupatenBatch(List<mkab.Kabupaten> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblKabupaten}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeKabupaten': element.fdKodeKabupaten,
          'fdNamaKabupaten': element.fdNamaKabupaten,
          'fdKodePropinsi': element.fdKodePropinsi,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblKabupaten, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mkab.Kabupaten>> getListKabupaten(String fdKodeProvinsi) async {
  late Database db;
  List<mkab.Kabupaten> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKabupaten} where fdKodePropinsi=? ORDER BY fdKodeKabupaten',
          [fdKodeProvinsi]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkab.Kabupaten.setData(element));
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

Future<List<mkab.Kabupaten>> getListKabupatenByKode(
    String fdKodeKabupaten) async {
  late Database db;
  List<mkab.Kabupaten> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKabupaten} where fdKodeKabupaten=? ORDER BY fdKodeKabupaten',
          [fdKodeKabupaten]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mkab.Kabupaten.setData(element));
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

Future<String> getStringProvinsiByKabupaten(String fdKodeKabupaten) async {
  late Database db;
  String kodeProvinsi = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblKabupaten} where fdKodeKabupaten=? ORDER BY fdKodePropinsi',
          [fdKodeKabupaten]);

      if (results.isNotEmpty) {
        kodeProvinsi = results[0]['fdKodePropinsi'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return kodeProvinsi;
}
