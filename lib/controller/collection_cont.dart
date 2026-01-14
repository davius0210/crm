import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/collection.dart' as mcoll;

Future<void> createtblCollection(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblCollection} (fdId INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdNoEntryFaktur varchar(30), fdTipe varchar(10), fdKodeLangganan varchar(30), fdTanggal varchar(30), '
        'fdTotalCollection REAL, fdNoRekeningAsal varchar(20), fdFromBank varchar(50), fdToBank varchar(50), '
        'fdNoCollection varchar(30), fdTanggalCollection varchar(30), fdDueDateCollection varchar(30), '
        'fdTanggalTerima varchar(30), fdBuktiImg varchar(255), '
        'fdStatusSent int, fdLastUpdate varchar(30))');
  });
}

Future<List<mcoll.CollectionDetail>> getAllCollectionByLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<mcoll.CollectionDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdId, a.fdKodeLangganan, a.fdTipe, a.fdTanggal, '
          'a.fdTotalCollection, a.fdNoRekeningAsal, a.fdFromBank, a.fdToBank, '
          'a.fdNoCollection, a.fdTanggalCollection, a.fdDueDateCollection, '
          'a.fdTanggalTerima, a.fdBuktiImg, b.fdAllocationAmount, a.fdLastUpdate '
          'FROM ${mdbconfig.tblCollection} a '
          'LEFT JOIN '
          ' (SELECT fdIdCollection, fdKodeLangganan, SUM(fdAllocationAmount) as fdAllocationAmount '
          ' FROM ${mdbconfig.tblPayment} '
          ' GROUP BY fdIdCollection, fdKodeLangganan) b ON b.fdIdCollection = a.fdId '
          '   AND b.fdKodeLangganan = a.fdKodeLangganan '
          'WHERE a.fdKodeLangganan = ?',
          [fdKodeLangganan]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mcoll.CollectionDetail.setData(element));
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

Future<List<mcoll.CollectionDetail>> getAllCollectionByNoEntryFaktur(
    String fdNoEntryFaktur) async {
  late Database db;
  List<mcoll.CollectionDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdId, a.fdKodeLangganan, a.fdTipe, a.fdTanggal, '
          'a.fdTotalCollection, a.fdNoRekeningAsal, a.fdFromBank, a.fdToBank, '
          'a.fdNoCollection, a.fdTanggalCollection, a.fdDueDateCollection, '
          'a.fdTanggalTerima, a.fdBuktiImg, b.fdAllocationAmount, a.fdLastUpdate '
          'FROM ${mdbconfig.tblCollection} a '
          'LEFT JOIN '
          ' (SELECT fdIdCollection, fdKodeLangganan, SUM(fdAllocationAmount) as fdAllocationAmount '
          ' FROM ${mdbconfig.tblPayment} WHERE fdNoEntryFaktur = ? '
          ' GROUP BY fdIdCollection, fdKodeLangganan) b ON b.fdIdCollection = a.fdId '
          '   AND b.fdKodeLangganan = a.fdKodeLangganan '
          'WHERE a.fdNoEntryFaktur = ?',
          [fdNoEntryFaktur, fdNoEntryFaktur]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mcoll.CollectionDetail.setData(element));
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

Future<mcoll.CollectionDetail?> getCollectionById(
    int fdId, String fdKodeLangganan) async {
  late Database db;
  mcoll.CollectionDetail? item;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdId, a.fdKodeLangganan, a.fdTipe, a.fdTanggal, '
          'a.fdTotalCollection, a.fdNoRekeningAsal, a.fdFromBank, a.fdToBank, '
          'a.fdNoCollection, a.fdTanggalCollection, a.fdDueDateCollection, '
          'a.fdTanggalTerima, a.fdBuktiImg, a.fdLastUpdate '
          'FROM ${mdbconfig.tblCollection} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdId = ?',
          [fdKodeLangganan, fdId]);
      if (results.isNotEmpty) {
        item = mcoll.CollectionDetail.setData(results.first);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return item;
}

Future<double> getCollectionByTipe(
    String fdTipe, String fdKodeLangganan, String fdNoEntryFaktur) async {
  late Database db;
  double fdTotalCollection = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT SUM(a.fdTotalCollection) fdTotalCollection '
          'FROM ${mdbconfig.tblCollection} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTipe = ? AND a.fdNoEntryFaktur=? ',
          [fdKodeLangganan, fdTipe, fdNoEntryFaktur]);
      if (results.isNotEmpty) {
        fdTotalCollection =
            double.tryParse(results.first['fdTotalCollection'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdTotalCollection;
}

Future<double> getTotalBayarByNoFaktur(String fdNoEntryFaktur) async {
  late Database db;
  double fdTotalCollection = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      // var results = await txn.rawQuery(
      //     'SELECT SUM(a.fdTotalCollection) fdTotalCollection '
      //     'FROM ${mdbconfig.tblCollection} a '
      //     'WHERE  a.fdNoEntryFaktur=? ',
      //     [fdNoEntryFaktur]);
      var results = await txn.rawQuery(
          'SELECT SUM(a.fdAllocationAmount) fdTotalCollection '
          'FROM ${mdbconfig.tblPayment} a '
          'WHERE  a.fdNoEntryFaktur=? ',
          [fdNoEntryFaktur]);
      if (results.isNotEmpty) {
        fdTotalCollection =
            double.tryParse(results.first['fdTotalCollection'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdTotalCollection;
}

Future<void> insertCollection(mcoll.CollectionDetail element) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      Map<String, dynamic> item = {
        'fdKodeLangganan': element.fdKodeLangganan,
        'fdNoEntryFaktur': element.fdNoEntryFaktur,
        'fdTipe': element.fdTipe,
        'fdTanggal': element.fdTanggal,
        'fdTotalCollection': element.fdTotalCollection,
        'fdNoRekeningAsal': element.fdNoRekeningAsal,
        'fdFromBank': element.fdFromBank,
        'fdToBank': element.fdToBank,
        'fdNoCollection': element.fdNoCollection,
        'fdTanggalCollection': element.fdTanggalCollection,
        'fdDueDateCollection': element.fdDueDateCollection,
        'fdTanggalTerima': element.fdTanggalTerima,
        'fdBuktiImg': element.fdBuktiImg,
        'fdStatusSent': 0,
        'fdLastUpdate': element.fdLastUpdate,
      };

      batchTx.insert(mdbconfig.tblCollection, item);
      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateCollection(mcoll.CollectionDetail element) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      Map<String, dynamic> item = {
        'fdKodeLangganan': element.fdKodeLangganan,
        'fdNoEntryFaktur': element.fdNoEntryFaktur,
        'fdTipe': element.fdTipe,
        'fdTanggal': element.fdTanggal,
        'fdTotalCollection': element.fdTotalCollection,
        'fdNoRekeningAsal': element.fdNoRekeningAsal,
        'fdFromBank': element.fdFromBank,
        'fdToBank': element.fdToBank,
        'fdNoCollection': element.fdNoCollection,
        'fdTanggalCollection': element.fdTanggalCollection,
        'fdDueDateCollection': element.fdDueDateCollection,
        'fdTanggalTerima': element.fdTanggalTerima,
        'fdBuktiImg': element.fdBuktiImg,
        'fdLastUpdate': element.fdLastUpdate,
      };

      batchTx.update(
        mdbconfig.tblCollection,
        item,
        where: 'fdId = ?',
        whereArgs: [element.fdId],
      );

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> deleteCollection(int fdId, String fdKodeLangganan) async {
  late Database db;
  int delRows = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblCollection} '
          'WHERE fdId = ? AND fdKodeLangganan = ?',
          [fdId, fdKodeLangganan]);

      var res = await batchTx.commit();
      delRows = res.isNotEmpty ? res.first as int : 0;
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return delRows;
}

Future<String> getPaymentByKodeLangganan(String fdKodeLangganan) async {
  late Database db;
  String payment = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdId, a.fdKodeLangganan, a.fdTipe, a.fdTanggal, '
          'a.fdTotalCollection, a.fdNoRekeningAsal, a.fdFromBank, a.fdToBank, '
          'a.fdNoCollection, a.fdTanggalCollection, a.fdDueDateCollection, '
          'a.fdTanggalTerima, a.fdBuktiImg, a.fdLastUpdate '
          'FROM ${mdbconfig.tblCollection} a '
          'WHERE a.fdKodeLangganan = ? ',
          [fdKodeLangganan]);
      if (results.isNotEmpty) {
        for (var element in results) {
          payment += '${element['fdTipe']}, ';
        }
      }
      if (payment.endsWith(', ')) {
        payment = payment.substring(0, payment.length - 2);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return payment;
}

Future<bool> isCollectionNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblCollection} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? AND fdStatusSent = 0',
          [fdKodeLangganan, fdDate]);

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

Future<List<mcoll.CollectionDetail>> getAllCollectionTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mcoll.CollectionDetail> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('''SELECT *
            FROM ${mdbconfig.tblCollection} a   
            WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? ''',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mcoll.CollectionDetail.setData(element));
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

Future<void> updateStatusSentCollection(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblCollection} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}
