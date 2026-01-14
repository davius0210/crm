import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/grouplangganan.dart' as mgrouplgn;

void createTblGroupLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblGroupLangganan} (fdKodeGroupLangganan varchar(20), fdGroupLangganan varchar(50), '
        'fdProgramOSA int, fdDescription varchar(200), fdStatusSent int, fdLastUpdate varchar(20) )');
  });
}

Future<void> insertGroupLanggananBatch(
    List<mgrouplgn.GroupLangganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblGroupLangganan} ');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeGroupLangganan': element.fdKodeGroupLangganan,
          'fdGroupLangganan': element.fdGroupLangganan,
          'fdProgramOSA': element.fdProgramOSA,
          'fdDescription': element.fdDescription,
          'fdStatusSent': 0,
          'fdLastUpdate': ''
        };

        batchTx.insert(mdbconfig.tblGroupLangganan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mgrouplgn.GroupLangganan>> getAllGroupLangganan() async {
  late Database db;
  List<mgrouplgn.GroupLangganan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblGroupLangganan} ORDER BY fdGroupLangganan');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mgrouplgn.GroupLangganan.setData(element));
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
