import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/branding.dart' as mbr;

void createTblBranding(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblBranding} (fdKodeBrand varchar(10), fdBranding varchar(50), '
        'fdCaptureBefore varchar(1), fdCaptureAfter varchar(1), fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<List<mbr.Branding>> getAllBranding() async {
  late Database db;
  List<mbr.Branding> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdKodeBrand, a.fdBranding, fdCaptureBefore, fdCaptureAfter '
          'FROM ${mdbconfig.tblBranding} a '
          'ORDER BY a.fdKodeBrand');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbr.Branding.setData(element));
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

Future<void> insertBrandingBatch(List<mbr.Branding> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblBranding}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeBrand': element.fdKodeBrand,
          'fdBranding': element.fdBranding,
          'fdCaptureBefore': element.fdCaptureBefore,
          'fdCaptureAfter': element.fdCaptureAfter,
        };

        batchTx.insert(mdbconfig.tblBranding, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}
