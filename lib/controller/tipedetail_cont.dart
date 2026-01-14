import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/tipedetail.dart' as mdetail;

void createtblTipeDetail(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblTipeDetail} (fdKode varchar(5), 
          fdNamaDetail varchar(100), fdTipe varchar(5), fdSort varchar(2), fdSingkat varchar(10),
          fdLastUpdate  varchar(25) )''');
  });
}

Future<int> checkTipeDetail_isExist(Database db, String? fdKodeTipe) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblTipeDetail} WHERE fdKodeTipe= ?',
        [fdKodeTipe]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> insertTipeDetail(
    Database db,
    String? fdKode,
    String? fdNamaDetail,
    String? fdTipe,
    String? fdSort,
    String? fdSingkat,
    String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawInsert(
        'INSERT INTO ${mdbconfig.tblTipeDetail}(fdKode, fdNamaDetail, fdTipe, fdSort, fdSingkat, fdLastUpdate ) VALUES(?,?,?,?,?,?)',
        [fdKode, fdNamaDetail, fdTipe, fdSort, fdSingkat, fdLastproses]);
  });

  return rowResult;
}

Future<void> insertTipeDetailBatch(List<mdetail.TipeDetail> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblTipeDetail}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKode': element.fdKode,
          'fdNamaDetail': element.fdNamaDetail,
          'fdTipe': element.fdTipe,
          'fdSort': element.fdSort,
          'fdSingkat': element.fdSingkat,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblTipeDetail, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mdetail.TipeDetail>> getTipeBadanUsaha() async {
  late Database db;
  List<mdetail.TipeDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblTipeDetail} where fdTipe=? order by fdSort ',
          ['BPU']);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mdetail.TipeDetail.setData(element));
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

Future<List<mdetail.TipeDetail>> getTipeKelasOutlet() async {
  late Database db;
  List<mdetail.TipeDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblTipeDetail} where fdTipe=? order by fdKode ',
          ['KAL']);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mdetail.TipeDetail.setData(element));
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
