import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as chttp;
import 'package:path/path.dart' as cpath;
import '../models/database.dart' as mdbconfig;
import '../models/limitkredit.dart' as mlk;
import '../models/barang.dart' as mbrg;
import '../models/distcenter.dart' as mstokdc;
import '../models/globalparam.dart' as param;

Future<void> createtblLimitKredit(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblLimitKredit} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdNoLimitKredit varchar(30), fdDepo varchar(3), fdKodeLangganan varchar(30), '
        'fdSisaLimit REAL, fdPesananBaru REAL, fdOverLK REAL, fdTglStatus varchar(30), '
        'fdTanggal varchar(30), fdLimitKredit REAL, fdPengajuanLimitBaru REAL, fdKodeStatus int, '
        'fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> insertLimitKreditBatch(List<mlk.LimitKredit> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblLimitKredit} WHERE fdKodeLangganan = ?',
          [items[0].fdKodeLangganan]);

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoLimitKredit': element.fdNoLimitKredit,
          'fdDepo': element.fdDepo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdSisaLimit': element.fdSisaLimit,
          'fdPesananBaru': element.fdPesananBaru,
          'fdOverLK': element.fdOverLK,
          'fdTglStatus': element.fdTglStatus,
          'fdTanggal': element.fdTanggal,
          'fdLimitKredit': element.fdLimitKredit,
          'fdPengajuanLimitBaru': element.fdPengajuanLimitBaru,
          'fdKodeStatus': element.fdKodeStatus,
          'fdStatusSent': element.fdStatusSent,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblLimitKredit, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteLimitKreditBatch(String fdKodeLangganan) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete(
          'DELETE FROM ${mdbconfig.tblLimitKredit} WHERE fdKodeLangganan = ?',
          [fdKodeLangganan]);

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<double> getTotalTagihan(String fdKodeLangganan) async {
  late Database db;
  double totalTagihan = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan=? '
          'ORDER BY a.fdID',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        totalTagihan = totalDPP + totalPPN;
        sisaTagihan = totalTagihan - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

Future<List<mlk.ListLimitKredit>> getAllLimitKredit() async {
  late Database db;
  List<mlk.ListLimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      // results = await txn.rawQuery(
      //     'SELECT a.fdId, a.fdNoLimitKredit, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, a.fdOverLK, '
      //     'a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, a.fdPengajuanLimitBaru, b.fdNamaLangganan, sum(fdTotalOrder) as fdTotalOrder, '
      //     'd.fdEndDate fdEndVisitDate, a.fdkodeStatus '
      //     'FROM ${mdbconfig.tblLimitKredit} a '
      //     'INNER JOIN ${mdbconfig.tblLangganan} b on a.fdKodeLangganan=b.fdKodeLangganan '
      //     'INNER JOIN ${mdbconfig.tblOrder} c on a.fdKodeLangganan=c.fdKodeLangganan '
      //     'LEFT JOIN ${mdbconfig.tblSFActivity} d ON d.fdKodeLangganan = a.fdKodeLangganan AND d.fdKodeDepo = a.fdDepo '
      //     ' AND d.fdJenisActivity = \'03\' '
      //     'GROUP BY a.fdId, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, '
      //     'a.fdOverLK, a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, b.fdNamaLangganan '
      //     'ORDER BY b.fdNamaLangganan ');

      results = await txn.rawQuery(
          'SELECT a.fdId, a.fdNoLimitKredit, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, a.fdOverLK, '
          'a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, a.fdPengajuanLimitBaru, b.fdNamaLangganan, sum(fdTotalOrder) as fdTotalOrder, '
          'd.fdEndDate fdEndVisitDate, a.fdkodeStatus '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'INNER JOIN ${mdbconfig.tblLangganan} b on a.fdKodeLangganan=b.fdKodeLangganan '
          'INNER JOIN ${mdbconfig.tblOrder} c on a.fdKodeLangganan=c.fdKodeLangganan '
          'LEFT JOIN ${mdbconfig.tblSFActivity} d ON d.fdKodeLangganan = a.fdKodeLangganan AND d.fdKodeDepo = a.fdDepo '
          ' AND d.fdJenisActivity = \'03\' '
          'GROUP BY a.fdId, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, '
          'a.fdOverLK, a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, b.fdNamaLangganan '
          'UNION ALL '
          'SELECT a.fdId, a.fdNoLimitKredit, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, a.fdOverLK, '
          'a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, a.fdPengajuanLimitBaru, b.fdNamaToko as fdNamaLangganan, sum(fdTotalOrder) as fdTotalOrder, '
          'd.fdEndDate fdEndVisitDate, a.fdkodeStatus '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'INNER JOIN ${mdbconfig.tblNOO} b on a.fdKodeLangganan=b.fdKodeNoo '
          'LEFT JOIN ${mdbconfig.tblOrder} c on a.fdKodeLangganan=c.fdKodeLangganan '
          'LEFT JOIN ${mdbconfig.tblSFActivity} d ON d.fdKodeLangganan = a.fdKodeLangganan AND d.fdKodeDepo = a.fdDepo '
          ' AND d.fdJenisActivity = \'03\' '
          'GROUP BY a.fdId, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, '
          'a.fdOverLK, a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, b.fdNamaToko '
          'ORDER BY fdNamaLangganan ');

      // results = await txn.rawQuery(
      //     'SELECT a.fdId, a.fdNoLimitKredit, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, a.fdOverLK, '
      //     'a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, a.fdPengajuanLimitBaru, b.fdNamaToko as fdNamaLangganan, sum(fdTotalOrder) as fdTotalOrder, '
      //     'd.fdEndDate fdEndVisitDate, a.fdkodeStatus '
      //     'FROM ${mdbconfig.tblLimitKredit} a '
      //     'INNER JOIN ${mdbconfig.tblNOO} b on a.fdKodeLangganan=b.fdKodeNoo '
      //     'LEFT JOIN ${mdbconfig.tblOrder} c on a.fdKodeLangganan=c.fdKodeLangganan '
      //     'LEFT JOIN ${mdbconfig.tblSFActivity} d ON d.fdKodeLangganan = a.fdKodeLangganan AND d.fdKodeDepo = a.fdDepo '
      //     ' AND d.fdJenisActivity = \'03\' '
      //     'GROUP BY a.fdId, a.fdDepo, a.fdKodeLangganan, a.fdSisaLimit, a.fdPesananBaru, '
      //     'a.fdOverLK, a.fdTglStatus, a.fdTanggal, a.fdLimitKredit, b.fdNamaToko '
      //     'ORDER BY fdNamaLangganan ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.ListLimitKredit.setData(element));
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

Future<double> getTotalTagihanSebelumJT(
    String fdKodeLangganan, String startDayDate) async {
  late Database db;
  double totalTagihan = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT >= ? '
          'ORDER BY a.fdID',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        totalTagihan = totalDPP + totalPPN;
        sisaTagihan = totalTagihan - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

Future<double> getTotalTagihanJT(
    String fdKodeLangganan, String startDayDate) async {
  late Database db;
  double totalTagihan = 0;
  double totalBayar = 0;
  double totalDPP = 0;
  double totalPPN = 0;
  double sisaTagihan = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT < ? '
          'ORDER BY a.fdID',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          totalBayar = element['fdBayar'];
          totalDPP += element['fdDPP'];
          totalPPN += element['fdPPN'];
        }
        totalTagihan = totalDPP + totalPPN;
        sisaTagihan = totalTagihan - totalBayar;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return sisaTagihan;
}

Future<bool> isLimitKreditNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTglStatus = ? AND fdStatusSent = 0',
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

Future<List<mlk.LimitKredit>> getDataLimitKreditByNoEntry(
    String fdNoLimitKredit) async {
  late Database db;
  List<mlk.LimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE fdNoLimitKredit = ? ',
          [fdNoLimitKredit]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.LimitKredit.setData(element));
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

Future<String> getNoEntry(String token, String? fdDepo, String? fdKodeSF,
    String? fdKodeLangganan) async {
  late Database db;
  int newFdKey = 0;
  String sNoSJ = '';

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);

  await db.transaction((txn) async {
    var cnt = await txn
        .rawQuery("SELECT count(*) as fdKey FROM ${mdbconfig.tblLimitKredit} ");
    newFdKey = int.parse(cnt[0]['fdKey'].toString()) + 1;
  });
  String formattedFdKey = newFdKey.toString().padLeft(4, '0');
  sNoSJ = '$fdDepo$fdKodeSF$fdKodeLangganan$formattedFdKey';

  return sNoSJ;
}

Future<int> deleteByNoEntry(String fdNoLimitKredit) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblLimitKredit} WHERE fdNoLimitKredit=? AND fdStatusSent = 0',
          [fdNoLimitKredit]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<int> updateDataByFdNoEntry(
    String stateIsGudang,
    String stateIsKomputer,
    int txtStockDC,
    int txtStdLimitKredit,
    int txtStockPajang,
    int txtStockGudang,
    int txtStockKomputer,
    String txtRootCause,
    String txtKeteranganRoot,
    String fdNoEntry) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE ${mdbconfig.tblLimitKredit} SET fdIsGudang=?, fdIsKomputer=?, fdQty=?, fdQtyLimitKredit=?, fdQtyPajang=?, fdQtyGudang=?, fdQtyKomputer=?, fdReason=?, fdRemark=?, fdLastUpdate=? WHERE fdDocNo=? ',
          [
            stateIsGudang,
            stateIsKomputer,
            txtStockDC,
            txtStdLimitKredit,
            txtStockPajang,
            txtStockGudang,
            txtStockKomputer,
            txtRootCause,
            txtKeteranganRoot,
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            fdNoEntry
          ]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<void> updateKodeStatusLimitKredit(
    String noLimitKredit, double txtPengajuanBaruLK) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblLimitKredit} SET fdKodeStatus = 1, fdPengajuanLimitBaru = ? WHERE fdNoLimitKredit = ?',
          [txtPengajuanBaruLK, noLimitKredit]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentLimitKredit(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblLimitKredit} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTglStatus = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mlk.LimitKredit>> querySendDataLimitKredit(
    String fdKodeLangganan, String startDayDate) async {
  List<Map<String, dynamic>> results = [];
  late Database db;
  List<mlk.LimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblLimitKredit} WHERE fdKodeLangganan=? AND fdTanggal=? AND fdStatusSent =0 ',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.LimitKredit.setData(element));
        }
      }
    });
    return items;
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<mlk.LimitKredit> uploadLimitKredit(
    String token,
    String? fdDepo,
    String? fdKodeSF,
    String fdKodeLangganan,
    String startDayDate,
    String urlAPILiveMD) async {
  // int rowResult = 0;
  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  if (!db.isOpen) {
    String dbPath = await getDatabasesPath();
    String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
    db = await openDatabase(dbFullPath, version: 1);
  }
  List<mlk.LimitKredit> results = [];
  List<Map<String, dynamic>> fdData = [];
  results = await querySendDataLimitKredit(fdKodeLangganan, startDayDate);
  if (results.isNotEmpty) {
    for (var element in results) {
      Map<String, dynamic> item = mlk.setJsonDataLimitKredit(
          element.fdNoLimitKredit,
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdSisaLimit,
          element.fdPesananBaru,
          element.fdOverLK,
          element.fdTglStatus,
          element.fdTanggal,
          element.fdLimitKredit,
          element.fdPengajuanLimitBaru,
          element.fdKodeStatus,
          element.fdStatusSent,
          element.fdLastUpdate);

      fdData.add(item);
    }
  }

  String jsonVal = jsonEncode(fdData);

  Map<String, dynamic> params = {
    "FdDepo": fdDepo,
    "FdKodeSF": fdKodeSF,
    "FdData": jsonVal,
    "FdAction": 1,
    "FdLastUpdate": ""
  };
  print(jsonEncode(params));
  print(jsonVal);
  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFtrLimitKredit'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 500;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      List<dynamic> dataJson = jsonBody["FdData"];
      print(jsonBody);
      print(dataJson);

      if (dataJson.isNotEmpty) {
        mlk.LimitKredit result = mlk.LimitKredit.fromJson(dataJson.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mlk.LimitKredit result = mlk.LimitKredit.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mlk.LimitKredit result = mlk.LimitKredit.fromJson(jsonBody);

      return result;
    } else if (response.statusCode == 500) {
      Map<String, dynamic> jsonBody = {
        "fdData": "500",
        "fdMessage": "Error timeout"
      };

      mlk.LimitKredit result = mlk.LimitKredit.fromJson(jsonBody);

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

Future<bool> checkBarangAlreadyExists(
    String fdKodeBarang, String fdKodeLangganan, String startDayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdKodeBarang = ? AND a.fdTanggal=? ',
          [fdKodeLangganan, fdKodeBarang, startDayDate]);

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

Future<String> getNoEntryBarangAlreadyExists(
    String fdKodeBarang, String fdKodeLangganan, String startDayDate) async {
  late Database db;
  String noEntry = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT fdDocNo '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdKodeBarang = ? AND a.fdTanggal=? ',
          [fdKodeLangganan, fdKodeBarang, startDayDate]);

      if (results.isNotEmpty) {
        noEntry = results[0]['fdDocNo'].toString();
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return noEntry;
}

Future<List<mlk.LimitKredit>> getDataByKodeBarang(
    String fdKodeBarang, String fdKodeLangganan) async {
  late Database db;
  List<mlk.LimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE fdKodeBarang = ? AND fdKodeLangganan=? '
          'ORDER BY a.fdID',
          [fdKodeBarang, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.LimitKredit.setData(element));
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

Future<List<mbrg.BarangInputed>> getAllBarang(String fdKodeSF, String fdTanggal,
    String fdKodeLangganan, String fdKodeGroupBarang) async {
  late Database db;
  List<mbrg.BarangInputed> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "SELECT * "
          ",case when "
          "(select case when fdKodeBarang is not null then 1 else 0 end "
          "	from ${mdbconfig.tblLimitKredit} b "
          "	where fdKodeSF=? and fdTanggal = ? and a.fdKodeBarang=b.fdKodeBarang "
          "	and fdKodeLangganan=?) =1 then '1' else '0' end as input "
          "from  ${mdbconfig.tblBarang}  a "
          "where fdKodeGroup=? "
          "ORDER BY a.fdKodeBarang ",
          [fdKodeSF, fdTanggal, fdKodeLangganan, fdKodeGroupBarang]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.BarangInputed.setData(element));
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

Future<int> updateFotoBuktiTransfer(String fdDepo, String? fdKodeLangganan,
    String fdFoto1, String fdStartDate, String fdNoEntry, int fdUrut) async {
  late Database db;
  int rowResult = 0;

  String fdLastproses = param.dateTimeFormatDB.format(DateTime.now());
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblFileBuktiTransfer} WHERE fdNoEntry=? AND fdUrut=? ',
          [fdNoEntry, fdUrut]);
      await txn.execute(
          'INSERT INTO ${mdbconfig.tblFileBuktiTransfer} (fdNoEntry, fdDepo, fdKodeLangganan, fdPath, fdTanggal, fdUrut, fdStatusSent, fdLastUpdate) values (?,?,?,?,?,?,?,?)  ',
          [
            fdNoEntry,
            fdDepo,
            fdKodeLangganan,
            fdFoto1,
            fdStartDate,
            fdUrut,
            0,
            fdLastproses
          ]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<Map<String, dynamic>> getDataLimitKreditByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  Map<String, dynamic> data = {
    'fdPesananBaru': 0.0,
    'fdPengajuanLimitBaru': 0.0,
    'overLK': 0.0,
  };
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT sum(fdPesananBaru) as fdPesananBaru, sum(fdPengajuanLimitBaru) as fdPengajuanLimitBaru, sum(fdOverLK) as fdOverLK '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE fdKodeLangganan = ? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        data = {
          'fdPesananBaru': results.first['fdPesananBaru'] ?? 0.0,
          'fdPengajuanLimitBaru': results.first['fdPengajuanLimitBaru'] ?? 0.0,
          'overLK': results.first['fdOverLK'] ?? 0.0,
        };
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return data;
}

Future<List<mlk.LimitKredit>> getAllLimitKreditTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mlk.LimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.* '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTglStatus = ?  ',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.LimitKredit.setData(element));
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

Future<bool> checkStatusLimitKredit(
    String startDayDate, String fdKodeLangganan) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblLimitKredit} a '
          'WHERE a.fdTglStatus=? AND a.fdKodeLangganan = ? AND a.fdKodeStatus = 0 ',
          [startDayDate, fdKodeLangganan]);

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

Future<List<mlk.ListLimitKredit>> getTransLanggananLimitKreditNotSent(
    String startDayDate) async {
  late Database db;
  List<mlk.ListLimitKredit> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'select * '
          ' FROM ${mdbconfig.tblLimitKredit} '
          ' WHERE fdTglStatus=? and fdKodeStatus =1 and fdStatusSent = 0 ',
          [startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mlk.ListLimitKredit.setData(element));
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
