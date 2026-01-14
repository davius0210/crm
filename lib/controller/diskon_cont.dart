import 'dart:async';

import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/diskon.dart' as mdisc;

void createTblDiskon(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblDiskon} (fdNoEntryDiskon varchar(30)
          ,fdNoSurat varchar(30)
          ,fdNamaDiskon varchar(100)
          ,fdKodeHarga varchar(30)
          ,fdNamaHarga varchar(100)
          ,fdMataUang varchar(3)
          ,fdTipeDiskon varchar(30)
          ,fdNamaTipeDiskon varchar(50)
          ,fdMinOrder int
          ,fdStartDate date
          ,fdEndDate date
          ,fdDiscP1 REAL
          ,fdDiscP2 REAL
          ,fdDiscP3 REAL
          ,fdDiscV REAL
          ,fdQtyAkumulasi varchar(3)
          ,fdKelipatan varchar(3)
          ,fdMaxDiscV REAL
          ,fdBaseOn varchar(30)
          ,fdKodeBarangExtra varchar(30)
          ,fdQtyExtra int
          ,fdDescription varchar(300)
          ,fdLastUpdate  varchar(25) )''');
  });
}

void createTblDiskonDetail(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblDiskonDetail} (fdNoEntryDiskon varchar(30)
          ,fdKodeBarang varchar(30)
          ,fdNamaBarang varchar(200)
          ,fdRangeStart REAL
          ,fdRangeEnd REAL
          ,fdMandatory varchar(3)
          ,fdInclude varchar(3)
          ,fdStatusRecord varchar(3) 
          ,fdKodeGroup varchar(3) 
          ,fdNamaGroup varchar(30)
          ,fdLastUpdate  varchar(25) )''');
  });
}

Future<int> checkDiskon_isExist(Database db, String? fdKodeHarga) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblDiskon} WHERE fdKodeHarga= ?',
        [fdKodeHarga]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

// Future<int> insertDiskon(Database db, String? fdKodeTipe, String? fdDiskon,
//     String? fdKodeJenis, String? fdLastproses) async {
//   int rowResult = 0;

//   await db.transaction((txn) async {
//     rowResult = await txn.rawInsert(
//         'INSERT INTO ${mdbconfig.tblDiskon}(fdKodeTipe, fdDiskon, fdKodeJenis, fdLastUpdate ) VALUES(?,?,?,?)',
//         [fdKodeTipe, fdDiskon, fdKodeJenis, fdLastproses]);
//   });

//   return rowResult;
// }

Future<void> insertDiskonBatch(List<mdisc.Diskon> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblDiskon}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryDiskon': element.fdNoEntryDiskon,
          'fdNoSurat': element.fdNoSurat,
          'fdNamaDiskon': element.fdNamaDiskon,
          'fdKodeHarga': element.fdKodeHarga,
          'fdNamaHarga': element.fdNamaHarga,
          'fdMataUang': element.fdMataUang,
          'fdTipeDiskon': element.fdTipeDiskon,
          'fdNamaTipeDiskon': element.fdNamaTipeDiskon,
          'fdMinOrder': element.fdMinOrder,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdDiscP1': element.fdDiscP1,
          'fdDiscP2': element.fdDiscP2,
          'fdDiscP3': element.fdDiscP3,
          'fdDiscV': element.fdDiscV,
          'fdQtyAkumulasi': element.fdQtyAkumulasi,
          'fdKelipatan': element.fdKelipatan,
          'fdMaxDiscV': element.fdMaxDiscV,
          'fdBaseOn': element.fdBaseOn,
          'fdKodeBarangExtra': element.fdKodeBarangExtra,
          'fdQtyExtra': element.fdQtyExtra,
          'fdDescription': element.fdDescription,
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblDiskon, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertDiskonDetailBatch(List<mdisc.DiskonDetail> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblDiskonDetail}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryDiskon': element.fdNoEntryDiskon.toString(),
          'fdKodeBarang': element.fdKodeBarang,
          'fdNamaBarang': element.fdNamaBarang,
          'fdKodeGroup': element.fdKodeGroup,
          'fdNamaGroup': element.fdNamaGroup,
          'fdRangeStart': element.fdRangeStart,
          'fdRangeEnd': element.fdRangeEnd,
          'fdMandatory': element.fdMandatory,
          'fdInclude': element.fdInclude,
          'fdStatusRecord': element.fdStatusRecord.toString(),
          'fdLastUpdate': element.fdLastUpdate
        };

        batchTx.insert(mdbconfig.tblDiskonDetail, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> updateDiskon(Database db, String? fdKodeTipe, String? fdDiskon,
    String? fdKodeJenis, String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate(
        'UPDATE ${mdbconfig.tblDiskon} SET fdDiskon = ?, fdKodeJenis = ?, fdLastUpdate =? WHERE fdKodeTipe= ?',
        [
          fdDiskon,
          fdKodeJenis,
          fdLastproses,
          fdKodeTipe,
        ]);
  });

  return rowResult;
}

Future<List<mdisc.Diskon>> getDiskon(fdKodeHarga) async {
  late Database db;
  List<mdisc.Diskon> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblDiskon} where fdKodeHarga=? order by fdStartDate desc,fdTipeDiskon ',
          [fdKodeHarga]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mdisc.Diskon.setData(element));
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

Future<List<mdisc.DiskonDetail>> getDiskonDetail(String fdNoEntryDiskon) async {
  late Database db;
  List<mdisc.DiskonDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblDiskonDetail} a '
          'LEFT JOIN ${mdbconfig.tblBarang} b on a.fdKodeBarang=b.fdKodeBarang '
          'where fdNoEntryDiskon=? order by fdNamaBarang ',
          [fdNoEntryDiskon]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mdisc.DiskonDetail.setData(element));
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

Future<List<mdisc.KodeHarga>> getListKodeHarga(String fdKodeHarga) async {
  late Database db;
  List<mdisc.KodeHarga> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT distinct fdKodeHarga , fdNamaHarga '
          'FROM ${mdbconfig.tblDiskon} WHERE fdKodeHarga=? ',
          [fdKodeHarga]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mdisc.KodeHarga.setData(element));
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
