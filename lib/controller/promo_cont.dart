import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/database.dart' as mdbconfig;
import '../models/promo.dart' as mpro;
import '../models/globalparam.dart' as param;
import 'package:path/path.dart' as cpath;
import 'package:http/http.dart' as chttp;

void createTblPromo(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblPromo} (fdKodePromo varchar(30), fdDescription varchar(100), '
        'fdStartDate varchar(20),	fdEndDate varchar(20), fdKodeJenisPromo varchar(4), '
        'fdPhoto varchar(30), fdKodeStatus varchar(1), fdUpdateUserID varchar(15),	fdUpdateTS varchar(20) '
        ')');
  });
}

void createTblPromoBarang(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblPromoBarang} (fdKodePromo varchar(30), fdDescription varchar(100), '
        'fdStartDate varchar(20),	fdEndDate varchar(20), '
        'fdPhoto varchar(30), fdKodeBarang varchar(10), fdNamaBarang varchar(100), fdKodeStatus varchar(1), '
        'fdUpdateUserID varchar(15),	fdUpdateTS varchar(20) '
        ')');
  });
}

void createTblPromoGroupLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblPromoGroupLangganan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdKodePromo varchar(30), fdKodeGroupLangganan varchar(4) , fdKodeStatus varchar(1), '
        'fdLastUpdate varchar(25) '
        ')');
  });
}

void createTblPromoLangganan(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblPromoLangganan} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdKodePromo varchar(30), fdKodeLangganan varchar(10) , fdKodeStatus varchar(1), '
        'fdLastUpdate varchar(25) '
        ')');
  });
}

void createTblPromoActivity(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblPromoActivity} ( fdTanggal varchar(20), fdKodeBranch varchar(4), fdKodeSF varchar(10), fdNamaSF varchar(100), fdKodeLangganan varchar(10), '
        'fdKodeExternal varchar(10), fdNamaLangganan varchar(100),  fdKodeBarang varchar(10), fdNamaBarang varchar(100), fdKodePromo varchar(30), fdDescription varchar(100), '
        'fdStartDate varchar(20), fdEndDate varchar(20), fdKodeJenisPromo varchar(4), fdKetJenisPromo varchar(100), fdPromoStatus int, fdStatusSent int, fdUpdateTS varchar(20), '
        'fdUCW varchar(5) )');
  });
}

void createTblJenisPromo(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE ${mdbconfig.tblJenisPromo} ( fdKodeJenisPromo varchar(30), fdJenisPromo varchar(100), fdKodeStatus int, fdLastUpdate varchar(20) '
        ')');
  });
}

Future<List<mpro.PromoActivity>> getPromoInfo(
    String fdKodeLangganan, String fdGroupLangganan) async {
  late Database db;
  List<mpro.PromoActivity> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodePromo, a.fdDescription, '
          'a.fdStartDate,	a.fdEndDate, a.fdKodeJenisPromo, j.fdJenisPromo as fdKetJenisPromo, b.fdNamaBarang, b.fdKodeBarang '
          'FROM ${mdbconfig.tblPromo} a '
          'INNER JOIN ${mdbconfig.tblPromoBarang} b on a.fdKodePromo=b.fdKodePromo '
          'LEFT JOIN ${mdbconfig.tblJenisPromo} j on j.fdKodeJenisPromo=a.fdKodeJenisPromo '
          'INNER JOIN ${mdbconfig.tblPromoGroupLangganan} g on a.fdKodePromo=g.fdKodePromo '
          'WHERE g.fdKodeGroupLangganan=? AND a.fdKodePromo NOT IN (SELECT f.fdKodePromo FROM ${mdbconfig.tblPromoActivity} f WHERE f.fdKodeLangganan=? ) '
          'UNION '
          'SELECT a.fdKodePromo, a.fdDescription, '
          'a.fdStartDate,	a.fdEndDate, a.fdKodeJenisPromo, j.fdJenisPromo as fdKetJenisPromo, b.fdNamaBarang, b.fdKodeBarang '
          'FROM ${mdbconfig.tblPromo} a '
          'INNER JOIN ${mdbconfig.tblPromoBarang} b on a.fdKodePromo=b.fdKodePromo '
          'LEFT JOIN ${mdbconfig.tblJenisPromo} j on j.fdKodeJenisPromo=a.fdKodeJenisPromo '
          'INNER JOIN ${mdbconfig.tblPromoLangganan} g on a.fdKodePromo=g.fdKodePromo '
          'WHERE g.fdKodeLangganan=? AND a.fdKodePromo NOT IN (SELECT f.fdKodePromo FROM ${mdbconfig.tblPromoActivity} f WHERE f.fdKodeLangganan=? ) ',
          [
            fdGroupLangganan,
            fdKodeLangganan,
            fdKodeLangganan,
            fdKodeLangganan
          ]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpro.PromoActivity.setData(element));
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

Future<void> insertPromoBatch(List<mpro.Promo> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPromo}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodePromo': element.fdKodePromo,
          'fdDescription': element.fdDescription,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdKodeJenisPromo': element.fdKodeJenisPromo,
          'fdPhoto': element.fdPhoto,
          'fdKodeStatus': element.fdKodeStatus
        };

        batchTx.insert(mdbconfig.tblPromo, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertPromoBarangBatch(List<mpro.PromoBarang> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPromoBarang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodePromo': element.fdKodePromo,
          'fdDescription': element.fdDescription,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdPhoto': element.fdPhoto,
          'fdKodeBarang': element.fdKodeBarang,
          'fdNamaBarang': element.fdNamaBarang,
          'fdKodeStatus': element.fdKodeStatus
        };

        batchTx.insert(mdbconfig.tblPromoBarang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mpro.PromoBarang>> getPromoBarang(String fdKodePromo) async {
  late Database db;
  List<mpro.PromoBarang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT fdKodePromo,fdDescription,fdStartDate,fdEndDate,'
          'fdPhoto,fdKodeBarang,fdNamaBarang,fdKodeStatus '
          'FROM ${mdbconfig.tblPromoBarang} '
          'WHERE fdKodePromo=? ',
          [fdKodePromo]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpro.PromoBarang.setData(element));
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

Future<List<mpro.PromoActivityServer>> getAllPromoActivity(
    String fdKodeSF, String fdDate, String fdKodeLangganan) async {
  late Database db;
  List<mpro.PromoActivityServer> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT fdTanggal,fdKodeBranch,fdKodeSF,fdKodeLangganan,fdKodePromo,fdKodeBarang,fdPromoStatus '
          'FROM ${mdbconfig.tblPromoActivity} '
          'WHERE fdKodeSF=? AND fdTanggal=? AND fdKodeLangganan =? ',
          [fdKodeSF, fdDate, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpro.PromoActivityServer.setData(element));
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

Future<bool> isPromoActExist(String fdKodeLangganan) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblPromoActivity} a '
          'WHERE a.fdKodeLangganan = ?',
          [fdKodeLangganan]);

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

Future<bool> isPromoActNotSent(String fdKodeLangganan) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblPromoActivity} a '
          'WHERE a.fdKodeLangganan = ? AND fdStatusSent = 0',
          [fdKodeLangganan]);

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

Future<void> insertPromoActivityBatch(List<mpro.PromoActivity> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdTanggal': element.fdTanggal,
          'fdKodeBranch': element.fdKodeBranch,
          'fdKodeSF': element.fdKodeSF,
          'fdNamaSF': element.fdNamaSF,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeExternal': element.fdKodeExternal,
          'fdNamaLangganan': element.fdNamaLangganan,
          'fdKodeBarang': element.fdKodeBarang,
          'fdNamaBarang': element.fdNamaBarang,
          'fdKodePromo': element.fdKodePromo,
          'fdDescription': element.fdDescription,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdKodeJenisPromo': element.fdKodeJenisPromo,
          'fdKetJenisPromo': element.fdKetJenisPromo,
          'fdPromoStatus': element.fdPromoStatus,
          'fdStatusSent': 0,
          'fdUpdateTS': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblPromoActivity, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deletePromoActivityBatch(List<mpro.PromoActivity> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblPromoActivity} WHERE fdKodeLangganan = ? AND fdKodeSF = ? AND fdKodePromo = ? AND fdKodeBarang = ? AND fdStatusSent = 0',
          [
            items.elementAt(0).fdKodeLangganan.toString(),
            items.elementAt(0).fdKodeSF.toString(),
            items.elementAt(0).fdKodePromo.toString(),
            items.elementAt(0).fdKodeBarang.toString()
          ]);

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

// VALIDASI table sblm insert ke SERVER => melalui API
Future<String> validasiTable() async {
  late Database db;
  String errMessage = '';

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          '''SELECT * FROM ${mdbconfig.tblPromoActivity} WHERE fdKodeDepo is NULL or fdKodeSF is NULL 
          or fdKodeLangganan is NULL or fdKodeBarang is NULL or fdKodePromo is NULL or fdPromoStatus is NULL
          ''');
      if (results.isNotEmpty) {
        errMessage =
            'Data tidak lengkap kode cabang/ kode SF/ kode langganan/ kode barang /kode promo ';
      } else {
        errMessage = '';
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return errMessage;
}

Future<void> updateStatusSentPromoAct(String fdKodeLangganan) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblPromoActivity} SET fdStatusSent = 1 WHERE fdKodeLangganan = ?',
          [fdKodeLangganan]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

//Upload ke server => API
Future<mpro.PromoActivity> uploadPromoActivity(
    String token,
    String? fdDepo,
    String? fdKodeSF,
    String? fdKodeLangganan,
    String? fdAction,
    String urlAPILiveMD) async {
  late Database db;
  var item = {};
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  if (!db.isOpen) {
    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
    db = await openDatabase(dbFullPath, version: 1);
  }
  await db.transaction((txn) async {
    List<Map<String, dynamic>> results = [];
    results = await txn.rawQuery(
        'SELECT * FROM ${mdbconfig.tblPromoActivity} WHERE fdKodeLangganan=? ',
        [fdKodeLangganan]);

    if (results.isNotEmpty) {
      for (var element in results) {
        item = {
          'FdData': {
            'fdKodeLangganan': element['fdKodeLangganan'],
            'fdKodePromo': element['fdKodePromo'],
            'fdKodeBarang': element['fdKodeBarang'],
            'fdPromoStatus': element['fdPromoStatus'],
          }
        };
      }
    }
  });

  String jsonVal = jsonEncode(item);

  Map<String, dynamic> params = {
    "FdDepo": fdDepo,
    "FdKodeSF": fdKodeSF,
    "FdData": jsonVal,
    "FdAction": fdAction,
    "FdLastUpdate": ""
  };
  print(jsonEncode(params));
  print(jsonVal);
  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/CRUDFTrPromoActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      List<dynamic> dataJson = jsonBody["FdData"];
      print(jsonBody);
      print(dataJson);

      if (dataJson.isNotEmpty) {
        mpro.PromoActivity result = mpro.PromoActivity.fromJson(dataJson.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpro.PromoActivity result = mpro.PromoActivity.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpro.PromoActivity result = mpro.PromoActivity.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    throw (e.toString());
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mpro.JenisPromo>> getJenisPromo() async {
  late Database db;
  List<mpro.JenisPromo> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * FROM ${mdbconfig.tblJenisPromo} ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpro.JenisPromo.setData(element));
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

Future<void> insertJenisPromoBatch(List<mpro.JenisPromo> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblJenisPromo}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeJenisPromo': element.fdKodeJenisPromo,
          'fdJenisPromo': element.fdJenisPromo,
          'fdKodeStatus': element.fdStatus,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblJenisPromo, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertPromoGroupLanggananBatch(
    List<mpro.PromoGroupLangganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPromoGroupLangganan}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodePromo': element.fdKodePromo,
          'fdKodeGroupLangganan': element.fdKodeGroupLangganan,
          'fdKodeStatus': element.fdKodeStatus
        };

        batchTx.insert(mdbconfig.tblPromoGroupLangganan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertPromoLanggananBatch(List<mpro.PromoLangganan> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPromoLangganan}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodePromo': element.fdKodePromo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdKodeStatus': element.fdKodeStatus
        };

        batchTx.insert(mdbconfig.tblPromoLangganan, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mpro.ViewBarangPromo>> getBarangPromo(
    String fdKodeGroup, String startDayDate, String fdGroupLangganan) async {
  late Database db;
  List<mpro.ViewBarangPromo> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, b.fdKodeGroup fdKodeGroupBarang '
          ',j.fdKodePromo,j.fdDescription '
          'FROM ${mdbconfig.tblBarang} a '
          'INNER JOIN ${mdbconfig.tblGroupBarang} b ON b.fdKodeGroup = a.fdKodeGroup '
          'LEFT JOIN (select z.*,b.fdKodeBarang from ${mdbconfig.tblPromo} z '
          'left join ${mdbconfig.tblPromoBarang} b on z.fdKodePromo=b.fdKodePromo '
          'left join ${mdbconfig.tblPromoGroupLangganan} c on z.fdKodePromo=c.fdKodePromo '
          'left join ${mdbconfig.tblPromoLangganan} d on d.fdKodePromo=z.fdKodePromo '
          'where z.fdStartDate <= ? and z.fdEndDate >=? AND fdKodeGroupLangganan=? '
          ') j on j.fdKodeBarang=a.fdKodeBarang '
          'WHERE a.fdKodeGroup = ? '
          'ORDER BY a.fdKodeBarang',
          [startDayDate, startDayDate, fdGroupLangganan, fdKodeGroup]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mpro.ViewBarangPromo.setData(element));
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
