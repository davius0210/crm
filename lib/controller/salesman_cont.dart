import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as cpath;
import 'database_cont.dart' as cdb;
import '../models/database.dart' as mdbconfig;
import '../models/salesman.dart' as msf;
import '../models/globalparam.dart' as param;

void createTblSFnSFActivity(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblSF} (fdUsername varchar(20), fdName varchar(50), fdKodeSF varchar(10) Primary Key, '
        'fdNamaSF varchar(50), fdKodeDepo varchar(2), fdNamaDepo varchar(50), fdTipeSF varchar(4), fdToken varchar(500), '
        'fdPass varchar(200), fdLoginDate varchar(16))');
  });

  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblSFActivity} (fdKodeSF varchar(10), fdKodeDepo varchar(2), fdKM int, fdPhoto varchar(250), '
        'fdKodeLangganan varchar(20), fdJenisActivity varchar(2), fdStartDate varchar(20), fdEndDate varchar(20), '
        'fdLA REAL, fdLG REAL, fdTanggal varchar(20), fdIsPaused int, fdRute int, fdStatusSent int, fdLastUpdate varchar(20), '
        'fdBattery varchar(3), fdStreet varchar(250), fdSubLocality varchar(250), fdSubArea varchar(250), fdPostalCode varchar(25),'
        'UNIQUE(fdKodeDepo, fdKodeSF, fdJenisActivity, fdKodeLangganan))');
  });
}

Future<void> createTblGudangSF(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblGudangSF} (fdKodeGudang varchar(20), fdNamaGudang varchar(50), '
        'fdKodeDepo varchar(2), fdKodeGudangSF varchar(20), fdNamaGudangSF varchar(50), fdLastUpdate varchar(20))');
  });
}

Future<void> alterTblSF() async {
  late Database db2;
  String dbPath = await getDatabasesPath();
  String logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  try {
    db2 = await openDatabase(logFullPath, version: mdbconfig.logVersion);
    await db2.transaction((txn) async {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblGpsLog} ADD COLUMN fdKodeSF varchar(10) ''');
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db2.isOpen ? await db2.close() : null;
  }
}

Future<int> checkIsSFExist(Database db, String? fdKodeSF) async {
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblSF} WHERE fdKodeSF = ?',
        [fdKodeSF]).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<msf.Salesman?> getSFLogIn() async {
  msf.Salesman? user;
  late Database db;

  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);

      await db.transaction((txn) async {
        var result = await txn.rawQuery(
            'SELECT fdKodeSF, fdNamaSF, fdKodeDepo, fdNamaDepo, fdTipeSF, fdToken, fdPass, fdLoginDate '
            'FROM ${mdbconfig.tblSF}'); // WHERE fdToken <> \'\''); -> tidak perlu cek token

        if (result.isNotEmpty) {
          user = msf.Salesman.setData(result.first);
        }
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }

  return user;
}

Future<int> insertSFLogin(Database db, msf.Salesman user) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    Batch batchTx = txn.batch();
    Map<String, dynamic> item = {
      'fdKodeSF': user.fdKodeSF,
      'fdNamaSF': user.fdNamaSF,
      'fdKodeDepo': user.fdKodeDepo,
      'fdNamaDepo': user.fdNamaDepo,
      'fdTipeSF': user.fdTipeSF,
      'fdToken': user.fdToken,
      'fdPass': user.fdPass,
      'fdLoginDate': user.fdLoginDate
    };

    batchTx.insert(mdbconfig.tblSF, item,
        conflictAlgorithm: ConflictAlgorithm.replace);

    await batchTx.commit(noResult: true);
  });

  return rowResult;
}

Future<msf.Salesman?> updateSFToken(msf.Salesman user) async {
  late Database db;

  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);

      await db.transaction((txn) async {
        await txn.rawUpdate(
            'UPDATE ${mdbconfig.tblSF} SET fdToken = ? '
            'WHERE fdKodeSF = ?',
            [user.fdToken, user.fdKodeSF]);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }

  return user;
}

Future<msf.SalesActivity?> getStart_EndDayInfo(
    String fdKodeSF, String fdKodeDepo, String fdJenisActivity) async {
  late Database db;
  msf.SalesActivity? user;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdKM, fdStartDate, fdEndDate, fdPhoto, fdLA, fdLG, fdStatusSent, '
          ' fdStreet, fdSubLocality, fdSubArea, fdPostalCode FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdJenisActivity = ?',
          [fdKodeSF, fdKodeDepo, fdJenisActivity]);

      if (results.isNotEmpty) {
        user = msf.SalesActivity.setData(results.first);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return user;
}

Future<List<msf.SalesActivity>> getTransLanggananNotSent(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<msf.SalesActivity> userActs = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdKodeLangganan FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdJenisActivity = \'03\' '
          ' AND fdStatusSent = 0',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        for (var element in results) {
          userActs.add(msf.SalesActivity.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return userActs;
}

//Get langganan baik sudah terkirim / belum
Future<List<msf.SalesActivity>> getTransLanggananSent(
    String fdKodeSF, String fdKodeDepo) async {
  late Database db;
  List<msf.SalesActivity> userActs = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdKodeLangganan FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdJenisActivity IN (\'01\',\'03\',\'05\') ',
          [fdKodeSF, fdKodeDepo]);

      if (results.isNotEmpty) {
        for (var element in results) {
          userActs.add(msf.SalesActivity.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return userActs;
}

Future<List<msf.SalesActivity>> getSFActivityByTransLangganan(
    String fdKodeSF, String fdKodeDepo, String fdKodeLangganan) async {
  late Database db;
  List<msf.SalesActivity> listSFAct = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdKodeSF, fdKodeDepo, fdKodeLangganan, fdKM, fdJenisActivity, fdStartDate, fdEndDate, '
          ' fdPhoto, fdLA, fdLG, fdTanggal, fdRute, fdBattery,  fdStreet, fdSubLocality,  fdSubArea, fdPostalCode, fdLastUpdate '
          'FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdJenisActivity  in (\'03\', \'13\')  AND fdKodeLangganan = ? '
          ' AND fdStartDate <> \'\' AND fdEndDate <> \'\'',
          [fdKodeSF, fdKodeDepo, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          listSFAct.add(msf.SalesActivity.setData(element));
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return listSFAct;
}

Future<bool> isSalesActNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblSFActivity} a '
          'WHERE fdStatusSent = 0 AND fdKodeLangganan = ? AND fdTanggal = ?',
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

Future<void> insertSFActivity(
    String fdKodeSF,
    String fdKodeDepo,
    int fdKM,
    String fdPathImg,
    String fdStartDate,
    String fdEndDate,
    double fdLA,
    double fdLG,
    String fdJenisActivity,
    String fdKodeLangganan,
    int fdIsPaused,
    int fdRute,
    String fdTanggal,
    int fdStatusSent,
    String? fdBattery,
    String? fdStreet,
    String? fdSubLocality,
    String? fdSubArea,
    String? fdPostalCode) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT OR IGNORE INTO ${mdbconfig.tblSFActivity}(fdKodeSF, fdKodeDepo, fdKM, fdPhoto, fdKodeLangganan, '
          'fdJenisActivity, fdStartDate, fdEndDate, fdLA, fdLG, fdIsPaused, fdStatusSent, fdRute, fdTanggal, fdLastUpdate, '
          'fdBattery, fdStreet, fdSubLocality, fdSubArea, fdPostalCode) '
          'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
          [
            fdKodeSF,
            fdKodeDepo,
            fdKM,
            fdPathImg,
            fdKodeLangganan,
            fdJenisActivity,
            fdStartDate,
            fdEndDate,
            fdLA,
            fdLG,
            fdIsPaused,
            fdStatusSent,
            fdRute,
            fdTanggal,
            param.dateTimeFormatDB.format(DateTime.now()),
            fdBattery,
            fdStreet,
            fdSubLocality,
            fdSubArea,
            fdPostalCode
          ]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updatePauseSFAndLanggananActivity(
    String fdKodeSF,
    String fdKodeDepo,
    String fdJenisActivity,
    String fdKodeLangganan,
    int fdIsPaused,
    String fdCategory,
    String fdReason,
    String fdPhoto,
    String fdTanggal) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblSFActivity} SET fdIsPaused = ?, fdLastUpdate = ? '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdKodeLangganan = ? AND fdJenisActivity= ?',
          [
            fdIsPaused,
            param.dateTimeFormatDB.format(DateTime.now()),
            fdKodeSF,
            fdKodeDepo,
            fdKodeLangganan,
            fdJenisActivity
          ]);

      await txn.rawInsert(
          'INSERT OR IGNORE INTO ${mdbconfig.tblLanggananActivity}(fdKodeDepo, fdKodeSF, fdKodeLangganan, fdCategory, fdReason, fdPhoto, '
          'fdStatusSent, fdTanggal, fdLastUpdate) '
          'VALUES(?,?,?,?,?,?,?,?,?) ',
          [
            fdKodeDepo,
            fdKodeSF,
            fdKodeLangganan,
            fdCategory,
            fdReason,
            fdPhoto,
            0,
            fdTanggal,
            param.dateTimeFormatDB.format(DateTime.now())
          ]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateCancelVisitSFAndLanggananActivity(
    String fdKodeSF,
    String fdKodeDepo,
    String fdJenisActivity,
    String fdKodeLangganan,
    int fdIsPaused,
    String fdCategory,
    String fdKodeReason,
    String fdReason,
    String fdPhoto,
    String fdTanggal) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblSFActivity} SET fdPhoto = ?, fdEndDate = ?, fdLastUpdate = ? '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdKodeLangganan = ? AND fdJenisActivity= ?',
          [
            '',
            param.dateTimeFormatDB.format(DateTime.now()),
            param.dateTimeFormatDB.format(DateTime.now()),
            fdKodeSF,
            fdKodeDepo,
            fdKodeLangganan,
            fdJenisActivity
          ]);

      await txn.rawInsert(
          'INSERT OR IGNORE INTO ${mdbconfig.tblLanggananActivity}(fdKodeDepo, fdKodeSF, fdKodeLangganan, fdCategory, fdKodeReason, fdReason, fdPhoto, '
          'fdStatusSent, fdTanggal, fdLastUpdate) '
          'VALUES(?,?,?,?,?,?,?,?,?,?) ',
          [
            fdKodeDepo,
            fdKodeSF,
            fdKodeLangganan,
            fdCategory,
            fdKodeReason,
            fdReason,
            fdPhoto,
            0,
            fdTanggal,
            param.dateTimeFormatDB.format(DateTime.now())
          ]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> endVisitSFActivity(String fdKodeSF, String fdKodeDepo,
    String fdEndDate, String fdJenisActivity, String fdKodeLangganan) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE ${mdbconfig.tblSFActivity} SET fdEndDate = ?, fdLastUpdate = ? '
          'WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdKodeLangganan = ? AND fdJenisActivity = ? '
          ' AND fdEndDate = \'\'',
          [
            fdEndDate,
            param.dateTimeFormatDB.format(DateTime.now()),
            fdKodeSF,
            fdKodeDepo,
            fdKodeLangganan,
            fdJenisActivity
          ]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

//Update status sent all langganan spt visit / non langganan spt start day & end day
Future<void> updateStatusSentSFAct(String fdKodeSF, String fdKodeDepo,
    String fdKodeLangganan, String fdJenisActivity) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      if (fdJenisActivity.isNotEmpty) {
        txn.rawUpdate(
            'UPDATE ${mdbconfig.tblSFActivity} SET fdStatusSent = 1 '
            'WHERE fdKodeDepo = ? AND fdKodeSF = ? AND fdStatusSent = 0 AND fdJenisActivity = ? '
            ' AND fdKodeLangganan = ?',
            [fdKodeDepo, fdKodeSF, fdJenisActivity, fdKodeLangganan]);
      } else {
        txn.rawUpdate(
            'UPDATE ${mdbconfig.tblSFActivity} SET fdStatusSent = 1 '
            'WHERE fdKodeDepo = ? AND fdKodeSF = ? AND fdStatusSent = 0 AND fdKodeLangganan = ?',
            [fdKodeDepo, fdKodeSF, fdKodeLangganan]);
      }
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteSFActivity(String fdKodeSF, String fdKodeDepo,
    String fdKodeLangganan, String fdJenisActivity) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawDelete(
          'DELETE FROM ${mdbconfig.tblSFActivity} WHERE fdKodeSF = ? AND fdKodeDepo = ? AND fdJenisActivity = ? '
          ' AND fdKodeLangganan = ? AND fdStatusSent = 0',
          [fdKodeSF, fdKodeDepo, fdJenisActivity, fdKodeLangganan]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> logOut(Transaction txn) async {
  await txn.rawUpdate('UPDATE ${mdbconfig.tblSF} SET fdToken = \'\' ');
}

Future<String> getKodeMdBySFActivity() async {
  late Database db;
  String fdKodeMD = '';
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery('SELECT fdKodeSF '
          'FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdJenisActivity = \'01\' order by fdLastUpdate desc ');

      if (results.isNotEmpty) {
        fdKodeMD = results.first['fdKodeSF'].toString();
      }
    });
    return fdKodeMD;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<msf.SalesActivity?> checkEndDayByKodeMD(
    String fdKodeMD, String fdJenisActivity) async {
  late Database db;
  msf.SalesActivity? user;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdKM, fdStartDate, fdEndDate, fdPhoto, fdLA, fdLG, fdStatusSent FROM ${mdbconfig.tblSFActivity} '
          'WHERE fdKodeSF = ? AND fdJenisActivity = ?',
          [fdKodeMD, fdJenisActivity]);

      if (results.isNotEmpty) {
        user = msf.SalesActivity.setData(results.first);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return user;
}

Future<String> checkIsKodeMdExist(String? fdKodeSF) async {
  int rowCount = 0;
  String msg = '';
  String getKodeMD = '';
  String dbPath = await getDatabasesPath();
  mdbconfig.dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  late Database db;
  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);
      rowCount = await checkIsSFExist(db, fdKodeSF);
      if (rowCount != 0) {
        msg = '';
      } else {
        getKodeMD = await getKodeMdBySFActivity();
        if (getKodeMD != '') {
          if (getKodeMD != fdKodeSF) {
            msf.SalesActivity? isSfEndDay =
                await checkEndDayByKodeMD(getKodeMD, '05');

            if (isSfEndDay == null) {
              msg =
                  'User lain belum End Day, Anda tidak dapat menggunakan device ini';
            }
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }
  return msg;
}

Future<void> insertGudangSalesBatch(List<msf.GudangSales> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblGudangSF}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeGudang': element.fdKodeGudang,
          'fdNamaGudang': element.fdNamaGudang,
          'fdKodeGudangSF': element.fdKodeGudangSF,
          'fdNamaGudangSF': element.fdNamaGudangSF,
          'fdKodeDepo': element.fdKodeDepo,
        };

        batchTx.insert(mdbconfig.tblGudangSF, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<msf.GudangSales>> getListGudangSales() async {
  late Database db;
  List<msf.GudangSales> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * FROM ${mdbconfig.tblGudangSF}  ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(msf.GudangSales.setData(element));
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
