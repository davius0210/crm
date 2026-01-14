import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/menu.dart' as mmenu;

void createTblMenu(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblMenu} (fdKodeMenu varchar(2) PRIMARY KEY, fdMenu varchar(50), fdUrutan int, fdMandatory int)');
  });
}

void createTblLogApps(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblLogApps} (fdName varchar(100), fdPackageName varchar(150), fdVersion varchar(50), fdVersionName varchar(250), fdKodeMD varchar(20), fdLastUpdate varchar(25))');
  });
}

Future<void> insertMenuBatch(List<mmenu.MenuMD> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblMenu}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeMenu': element.fdKodeMenu,
          'fdMenu': element.fdMenu,
          'fdUrutan': element.fdUrutan,
          'fdMandatory': element.fdMandatory,
        };

        batchTx.insert(mdbconfig.tblMenu, item,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mmenu.MenuMD>> getAllCustMenu() async {
  late Database db;
  List<mmenu.MenuMD> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results =
          await txn.rawQuery('SELECT fdKodeMenu, fdMenu, fdUrutan, fdMandatory '
              'FROM ${mdbconfig.tblMenu} '
              'ORDER BY fdUrutan');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mmenu.MenuMD.setData(element));
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
