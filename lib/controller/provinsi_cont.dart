import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import 'package:path/path.dart' as cpath;
import '../models/provinsi.dart' as mprov;

void createTblPropinsi(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblPropinsi} (fdKodePropinsi varchar(20) Primary Key, 
          fdNamaPropinsi varchar(50), 
          fdKodeNegara varchar(10), 
          fdLastUpdate varchar(25) )''');
  });
}

Future<int> checkPropinsi_isExist(Database db, String? fdKodePropinsi) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblPropinsi} WHERE fdKodePropinsi = ?',
        [fdKodePropinsi]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertPropinsi(Database db, String? fdKodePropinsi,
    String? fdNamaPropinsi, String? fdKodeNegara, String? fdLastUpdate) async {
  int rowResult = 0;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  db.transaction((txn) async {
    rowResult = await txn.rawInsert(
        'INSERT INTO ${mdbconfig.tblPropinsi}(fdKodePropinsi, fdNamaPropinsi, fdKodeNegara,fdLastUpdate ) VALUES(?,?,?,? )',
        [fdKodePropinsi, fdNamaPropinsi, fdKodeNegara, fdLastUpdate]);
  });

  return rowResult;
}

Future<int> updatePropinsi(Database db, String? fdKodePropinsi,
    String? fdNamaPropinsi, String? fdKodeNegara, String? fdLastUpdate) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblPropinsi} SET fdNamaPropinsi = ?, fdKodeNegara =? fdLastUpdate =? WHERE fdKodePropinsi = ?',
        [fdNamaPropinsi, fdKodeNegara, fdLastUpdate, fdKodePropinsi]);
  });

  return rowResult;
}

Future<void> insertPropinsiBatch(List<mprov.Propinsi> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPropinsi}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodePropinsi': element.fdKodePropinsi,
          'fdNamaPropinsi': element.fdNamaPropinsi,
          'fdKodeNegara': element.fdKodeNegara,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblPropinsi, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mprov.Propinsi>> getListProvinsi() async {
  late Database db;
  List<mprov.Propinsi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblPropinsi} ORDER BY fdKodePropinsi');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mprov.Propinsi.setData(element));
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
