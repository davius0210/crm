import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/tipeharga.dart' as mtharga;

void createTblTipeHarga(Database db) async {
  await db.transaction((txn) async {
    await txn.execute('''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblTipeHarga} (
          fdKodeHarga varchar(30), fdKodeDivisi varchar(10), fdKeterangan varchar(255),
          fdKodeJenis varchar(2), fdLastUpdate  varchar(25) )''');
  });
}

Future<int> insertTipeHarga(
    Database db,
    String? fdKodeHarga,
    String? fdKodeDivisi,
    String? fdKeterangan,
    String? fdKodeJenis,
    String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawInsert(
        'INSERT INTO ${mdbconfig.tblTipeHarga}(fdKodeHarga, fdKodeDivisi, fdKeterangan, fdKodeJenis, fdLastUpdate ) VALUES(?,?,?,?,?)',
        [fdKodeHarga, fdKodeDivisi, fdKeterangan, fdKodeJenis, fdLastproses]);
  });

  return rowResult;
}

Future<void> insertTipeHargaBatch(List<mtharga.TipeHarga> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblTipeHarga}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeHarga': element.fdKodeHarga,
          'fdKodeDivisi': element.fdKodeDivisi,
          'fdKeterangan': element.fdKeterangan,
          'fdKodeJenis': element.fdKodeJenis,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblTipeHarga, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mtharga.TipeHarga>> getTipeHarga() async {
  late Database db;
  List<mtharga.TipeHarga> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * '
          'FROM ${mdbconfig.tblTipeHarga} order by fdKodeHarga ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mtharga.TipeHarga.setData(element));
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
