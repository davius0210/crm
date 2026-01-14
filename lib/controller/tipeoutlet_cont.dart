import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/tipeoutlet.dart' as mtOutlet;

void createTblTipeOutlet(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblTipeOutletMD} (fdKodeTipe varchar(2), 
          fdTipeOutlet varchar(100), 
          fdKodeJenis varchar(50),
          fdLastUpdate  varchar(25) )''');
  });
}

Future<int> checkTipeOutlet_isExist(Database db, String? fdKodeTipe) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblTipeOutletMD} WHERE fdKodeTipe= ?',
        [fdKodeTipe]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertTipeOutlet(Database db, String? fdKodeTipe,
    String? fdTipeOutlet, String? fdKodeJenis, String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawInsert(
        'INSERT INTO ${mdbconfig.tblTipeOutletMD}(fdKodeTipe, fdTipeOutlet, fdKodeJenis, fdLastUpdate ) VALUES(?,?,?,?)',
        [fdKodeTipe, fdTipeOutlet, fdKodeJenis, fdLastproses]);
  });

  return rowResult;
}

Future<void> insertTipeOutletBatch(List<mtOutlet.TipeOutlet> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblTipeOutletMD}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeTipe': element.fdKodeTipe,
          'fdTipeOutlet': element.fdTipeOutlet,
          'fdKodeJenis': element.fdKodeJenis,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblTipeOutletMD, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> updateTipeOutlet(Database db, String? fdKodeTipe,
    String? fdTipeOutlet, String? fdKodeJenis, String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblTipeOutletMD} SET fdTipeOutlet = ?, fdKodeJenis = ?, fdLastUpdate =? WHERE fdKodeTipe= ?',
        [
          fdTipeOutlet,
          fdKodeJenis,
          fdLastproses,
          fdKodeTipe,
        ]);
  });

  return rowResult;
}

Future<List<mtOutlet.TipeOutlet>> getTipeOutlet() async {
  late Database db;
  List<mtOutlet.TipeOutlet> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * '
          'FROM ${mdbconfig.tblTipeOutletMD} order by fdKodeTipe ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mtOutlet.TipeOutlet.setData(element));
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
