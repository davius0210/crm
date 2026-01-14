import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as chttp;
import 'package:path/path.dart' as cpath;
import 'barang_cont.dart' as cbrg;
import 'database_cont.dart' as cdb;
import '../models/database.dart' as mdbconfig;
import '../models/stock.dart' as mstk;
import '../models/barang.dart' as mbrg;
import '../models/distcenter.dart' as mstokdc;
import '../models/globalparam.dart' as param;

Future<void> createTblStock(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblStock} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdDepo varchar(3), fdKodeLangganan varchar(30), fdNoEntryStock varchar(30), fdNoOrder varchar(50),  '
        'fdUnitPrice REAL, fdUnitPriceK REAL, fdDiscount REAL, fdTotal REAL, fdTotalK REAL, fdQtyStock int, fdQtyStockK int, fdTotalStock REAL, fdTotalStockK REAL, fdJenisSatuan varchar(5), '
        'fdTanggal varchar(30), fdTanggalKirim varchar(30), fdAlamatKirim varchar(500), fdKodeGudang varchar(30), fdKodeGudangSF varchar(30), fdKodeStatus int, '
        'fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTblStockItem(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblStockItem} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdNoEntryStock varchar(30), fdNoUrutStock int, fdKodeBarang varchar(30),  fdNamaBarang varchar(150), fdPromosi varchar(5), '
        'fdReplacement int, fdJenisSatuan varchar(5), fdQtyStock int, fdQtyStockK int, fdUnitPrice REAL, fdUnitPriceK REAL, fdBrutto REAL, fdDiscount REAL, '
        'fdDiscountDetail varchar(200), fdNetto REAL, fdNoPromosi REAL, fdNotes varchar(500), '
        'fdQtyPBE int, fdQtySJ int, isHanger VARCHAR(3), isShow varchar(3), urut int, fdStatusRecord int, fdKodeStatus int, fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTblStockItemSum(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblStockItemSum} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdKodeSF varchar(30), fdDepo varchar(3), fdNoEntryStock varchar(30), '
        'fdTanggal varchar(30), fdKodeGudang varchar(30), fdKodeGudangSF varchar(30), '
        'fdKodeBarang varchar(30),  fdNamaBarang varchar(150), fdPromosi varchar(5), '
        'fdReplacement int, fdJenisSatuan varchar(5), fdQtyStock int, fdQtyStockK int, fdUnitPrice REAL, fdUnitPriceK REAL, fdBrutto REAL, fdDiscount REAL, '
        'fdDiscountDetail varchar(200), fdNetto REAL, fdNoPromosi REAL, fdNotes varchar(500), '
        'fdQtyPBE int, fdQtySJ int, isHanger VARCHAR(3), isShow varchar(3), urut int, fdStatusRecord int, fdKodeStatus int, fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> insertStockBatch(List<mstk.Stock> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdDepo': element.fdDepo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdNoEntryStock': element.fdNoEntryStock,
          'fdNoOrder': element.fdNoOrder,
          'fdTanggal': element.fdTanggal,
          'fdUnitPrice': element.fdUnitPrice,
          'fdDiscount': element.fdDiscount,
          'fdTotal': element.fdTotal,
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdTotalStock': element.fdTotalStock,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdKodeGudang': element.fdKodeGudang,
          'fdKodeGudangSF': element.fdKodeGudangSF,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblStock, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStockBatch(List<mstk.Stock> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdDepo': element.fdDepo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdDiscount': element.fdDiscount,
          'fdTotal': element.fdTotal,
          'fdTotalK': element.fdTotalK,
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdTotalStock': element.fdTotalStock,
          'fdTotalStockK': element.fdTotalStockK,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdKodeGudang': element.fdKodeGudang,
          'fdKodeGudangSF': element.fdKodeGudangSF,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblStock,
          item,
          where: 'fdNoEntryStock = ?',
          whereArgs: [element.fdNoEntryStock],
        );
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertStockItemBatch(List<mstk.StockItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryStock': element.fdNoEntryStock,
          'fdNoUrutStock': element.fdNoUrutStock,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdNoPromosi': element.fdNoPromosi,
          'fdNotes': element.fdNotes,
          'fdQtyPBE': element.fdQtyPBE,
          'fdQtySJ': element.fdQtySJ,
          'isHanger': element.isHanger,
          'isShow': element.isShow,
          'urut': element.urut,
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblStockItem, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStockItemBatch(List<mstk.StockItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryStock': element.fdNoEntryStock,
          'fdNoUrutStock': element.fdNoUrutStock,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdUnitPrice': element.fdUnitPrice,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdNoPromosi': element.fdNoPromosi,
          'fdNotes': element.fdNotes,
          'fdQtyPBE': element.fdQtyPBE,
          'fdQtySJ': element.fdQtySJ,
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblStockItem,
          item,
          where: 'fdKodeBarang = ? and fdPromosi not in (?)',
          whereArgs: [element.fdKodeBarang, '1'],
        );
      }

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    if (db.isOpen) {
      await db.close();
    }
  }
}

Future<void> insertStockItemSumBatch(
    String fdKodeSF,
    String fdDepo,
    String fdNoEntryStock,
    String fdTanggal,
    String fdKodeGudang,
    String fdKodeGudangSF,
    List<mstk.StockItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeSF': fdKodeSF,
          'fdDepo': fdDepo,
          'fdNoEntryStock': fdNoEntryStock,
          'fdTanggal': fdTanggal,
          'fdKodeGudang': fdKodeGudang,
          'fdKodeGudangSF': fdKodeGudangSF,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdNoPromosi': element.fdNoPromosi,
          'fdNotes': element.fdNotes,
          'fdQtyPBE': element.fdQtyPBE,
          'fdQtySJ': element.fdQtySJ,
          'isHanger': element.isHanger,
          'isShow': element.isShow,
          'urut': element.urut,
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblStockItemSum, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStockItemSumBatch(
    String fdKodeSF,
    String fdDepo,
    String fdNoEntryStock,
    String fdTanggal,
    String fdKodeGudang,
    String fdKodeGudangSF,
    int fdQtyStock,
    int fdQtyStockK,
    List<mstk.StockItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeSF': fdKodeSF,
          'fdDepo': fdDepo,
          'fdNoEntryStock': fdNoEntryStock,
          'fdTanggal': fdTanggal,
          'fdKodeGudang': fdKodeGudang,
          'fdKodeGudangSF': fdKodeGudangSF,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQtyStock': (element.fdQtyStock + fdQtyStock),
          'fdQtyStockK': (element.fdQtyStockK + fdQtyStockK),
          'fdUnitPrice': element.fdUnitPrice,
          'fdBrutto': element.fdBrutto,
          'fdDiscount': element.fdDiscount,
          'fdDiscountDetail': element.fdDiscountDetail,
          'fdNetto': element.fdNetto,
          'fdNoPromosi': element.fdNoPromosi,
          'fdNotes': element.fdNotes,
          'fdQtyPBE': element.fdQtyPBE,
          'fdQtySJ': element.fdQtySJ,
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblStockItemSum,
          item,
          where: 'fdKodeBarang = ? ',
          whereArgs: [element.fdKodeBarang],
        );
      }

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    if (db.isOpen) {
      await db.close();
    }
  }
}

Future<void> kurangiStockItemSumBatch(List<mstk.StockItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdQtyStock': element.fdQtyStock,
          'fdQtyStockK': element.fdQtyStockK,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblStockItemSum,
          item,
          where: 'fdKodeBarang = ? AND fdPromosi =?',
          whereArgs: [element.fdKodeBarang, '0'],
        );
      }

      await batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    if (db.isOpen) {
      await db.close();
    }
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
          'FROM ${mdbconfig.tblStock} a '
          'WHERE a.fdKodeLangganan=? '
          'Stock BY a.fdID',
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

Future<List<mstk.Stock>> getAllStockByKodeSF(String? fdKodeSF) async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT * '
          'FROM ${mdbconfig.tblStock} '
          'order BY fdID');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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

Future<List<Map<String, dynamic>>> getTotalProdukByKodeLangganan(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<Map<String, dynamic>> produkList = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdNoEntryStock, COUNT(DISTINCT b.fdKodeBarang) as totalProduk '
          'FROM ${mdbconfig.tblStock} a '
          'INNER JOIN ${mdbconfig.tblStockItem} b ON a.fdNoEntryStock = b.fdNoEntryStock '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? GROUP BY a.fdNoEntryStock',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        produkList = results;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return produkList;
}

Future<List<mstk.StockUnloading>> getAllStockRequestTransaction() async {
  late Database db;
  List<mstk.StockUnloading> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          "select A.fdKodeSF, A.fdDepo , A.fdNoEntryStock , A.fdTanggal, A.fdKodeBarang, B.fdNamaBarang, A.fdJenisSatuan, "
          " A.fdPromosi, A.fdReplacement, A.fdKodeGudang, A.fdKodeGudangSF, "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  A.fdQtyStockK * 1.0 "
          " ELSE "
          "  A.fdQtyStockK * 1.0 "
          " END) as fdQtyStockK, "
          "SUM(A.fdQtyStockK * 1.0 / 12 ) as fdQtyStockS, "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  A.fdQtyStockK * 1.0 / C.fdQtyKomersil / C.fdKonvB_S "
          " ELSE "
          "  A.fdQtyStockK * 1.0 / 12 / B.fdKonvB_S "
          " END) as fdQtyStock "
          "FROM ${mdbconfig.tblStockItemSum} A "
          "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
          "left join ${mdbconfig.tblHanger} C on A.fdKodeBarang=C.fdKodeBarang "
          " WHERE A.fdStatusSent NOT IN (2) GROUP BY A.fdKodeBarang, B.fdNamaBarang ");
      // await db.transaction((txn) async {
      //   var results = await txn.rawQuery(
      //       'SELECT b.fdKodeSF, b.fdDepo , b.fdNoEntryStock , b.fdTanggal ,  '
      //       ' b.fdKodeBarang , c.fdNamaBarang , b.fdPromosi , '
      //       ' b.fdReplacement , b.fdJenisSatuan , b.fdQtyStock , b.fdUnitPrice , b.fdQtyStockK , b.fdUnitPriceK , '
      //       ' b.fdBrutto , b.fdDiscount , '
      //       ' b.fdDiscountDetail , b.fdNetto , b.fdNoPromosi , b.fdNotes , b.fdQtyPBE , b.fdQtySJ , b.fdStatusRecord , '
      //       ' b.fdKodeGudang, b.fdKodeGudangSF, b.fdKodeStatus, b.fdStatusSent, b.fdLastUpdate, b.isHanger, '
      //       ' (b.fdQtyStockK * 1.0 / 12 ) as fdQtyStockS '
      //       ' FROM  ${mdbconfig.tblStockItemSum} b '
      //       ' INNER JOIN ${mdbconfig.tblBarang} c on b.fdKodeBarang=c.fdKodeBarang '
      //       ' LEFT JOIN ${mdbconfig.tblHanger} h on c.fdKodeBarang=h.fdKodeBarang '
      //       ' WHERE b.fdStatusSent NOT IN (2) ');
      if (results.isNotEmpty) {
        for (var element in results) {
          if ((element['fdNoEntryStock'] as String?)?.isNotEmpty ?? false) {
            items.add(mstk.StockUnloading.setData(element));
          }
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

Future<List<mstk.StockApi>> getStockRequestTransactionByNoEntry(
    String fdNoEntryStock, String fdDate) async {
  late Database db;
  List<mstk.StockApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT a.fdDepo , a.fdKodeLangganan , a.fdNoEntryStock , a.fdNoOrder , '
          ' a.fdTotal , a.fdTotalStock , a.fdTotalK, a.fdTotalStockK, '
          ' a.fdTanggal , a.fdTanggalKirim , a.fdAlamatKirim , '
          ' b.fdNoUrutStock , b.fdKodeBarang , b.fdNamaBarang , b.fdPromosi , '
          ' b.fdReplacement , b.fdJenisSatuan , b.fdQtyStock , b.fdUnitPrice , b.fdQtyStockK , b.fdUnitPriceK , '
          ' b.fdBrutto , b.fdDiscount , '
          ' b.fdDiscountDetail , b.fdNetto , b.fdNoPromosi , b.fdNotes , b.fdQtyPBE , b.fdQtySJ , b.fdStatusRecord , '
          ' a.fdKodeGudang, a.fdKodeGudangSF, a.fdKodeStatus, a.fdStatusSent, a.fdLastUpdate, b.isHanger '
          'FROM ${mdbconfig.tblStock} a '
          'INNER JOIN ${mdbconfig.tblStockItem} b ON a.fdNoEntryStock = b.fdNoEntryStock '
          'WHERE a.fdNoEntryStock = ? AND a.fdTanggal = ?',
          [fdNoEntryStock, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.StockApi.setData(element));
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

Future<List<mstk.StockItem>> getAllStockItemTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<mstk.StockItem> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT b.fdNoEntryStock , b.fdNoUrutStock , b.fdKodeBarang , b.fdNamaBarang , b.fdPromosi , '
          ' b.fdReplacement, b.fdJenisSatuan, b.fdQtyStock, b.fdUnitPrice, b.fdQtyStockK, b.fdUnitPriceK, b.fdBrutto, b.fdDiscount , '
          ' b.fdDiscountDetail , b.fdNetto , b.fdNoPromosi , b.fdNotes , b.fdQtyPBE , b.fdQtySJ , b.fdStatusRecord , '
          ' b.fdKodeStatus, b.fdStatusSent, b.fdLastUpdate '
          'FROM ${mdbconfig.tblStock} a '
          'INNER JOIN ${mdbconfig.tblStockItem} b ON a.fdNoEntryStock = b.fdNoEntryStock '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.StockItem.setData(element));
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
          'FROM ${mdbconfig.tblStock} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT >= ? '
          'Stock BY a.fdID',
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
          'FROM ${mdbconfig.tblStock} a '
          'WHERE a.fdKodeLangganan=? AND a.fdTanggalJT < ? '
          'Stock BY a.fdID',
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

Future<bool> isStockRequestNotSent(String fdNoEntryStock, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblStock} a '
          'WHERE a.fdNoEntryStock = ? AND a.fdTanggal = ? AND fdStatusSent = 0',
          [fdNoEntryStock, fdDate]);

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

Future<List<mstk.Stock>> getDataStockRequestHeaderByNoEntry(
    String fdNoEntryFaktur) async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblStock} WHERE fdNoEntryStock = ? ',
          [fdNoEntryFaktur]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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
        .rawQuery("SELECT count(*) as fdKey FROM ${mdbconfig.tblStock} ");
    newFdKey = int.parse(cnt[0]['fdKey'].toString()) + 1;
  });
  String formattedFdKey = newFdKey.toString().padLeft(4, '0');
  sNoSJ = '$fdDepo$fdKodeSF$fdKodeLangganan$formattedFdKey';

  return sNoSJ;
}

Future<int> deleteByNoEntry(String token, String fdNoEntryStock) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblStock} WHERE fdNoEntryStock=?  ',
          [fdNoEntryStock]);

      await txn.execute(
          'DELETE FROM ${mdbconfig.tblStockItem} WHERE fdNoEntryStock=?  ',
          [fdNoEntryStock]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

// Future<int> updateDataByFdNoEntry(
//     String stateIsGudang,
//     String stateIsKomputer,
//     int txtStockDC,
//     int txtStdStock,
//     int txtStockPajang,
//     int txtStockGudang,
//     int txtStockKomputer,
//     String txtRootCause,
//     String txtKeteranganRoot,
//     String fdNoEntry) async {
//   late Database db;
//   int rowResult = 0;

//   String dbPath = await getDatabasesPath();
//   String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
//   db = await openDatabase(dbFullPath, version: 1);
//   try {
//     await db.transaction((txn) async {
//       await txn.execute(
//           'UPDATE ${mdbconfig.tblStock} SET fdIsGudang=?, fdIsKomputer=?, fdQty=?, fdQtyStock=?, fdQtyPajang=?, fdQtyGudang=?, fdQtyKomputer=?, fdReason=?, fdRemark=?, fdLastUpdate=? WHERE fdDocNo=? ',
//           [
//             stateIsGudang,
//             stateIsKomputer,
//             txtStockDC,
//             txtStdStock,
//             txtStockPajang,
//             txtStockGudang,
//             txtStockKomputer,
//             txtRootCause,
//             txtKeteranganRoot,
//             DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
//             fdNoEntry
//           ]);
//     });
//     rowResult = 1;
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }
//   return rowResult;
// }

Future<void> updateStatusSentStock(String fdNoEntryStock, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblStock} SET fdStatusSent = 1 WHERE fdNoEntryStock = ? AND fdTanggal = ?',
          [fdNoEntryStock, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentStockUnloading(
    String fdNoEntryStock, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    // await db.transaction((txn) async {
    //   txn.rawUpdate(
    //       'UPDATE ${mdbconfig.tblStock} SET fdStatusSent = 2 WHERE fdNoEntryStock = ? AND fdTanggal = ?',
    //       [fdNoEntryStock, fdDate]);
    // });
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblStock} SET fdStatusSent = 2 WHERE fdTanggal = ?',
          [fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> deleteStock(String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      txn.rawDelete(
          'DELETE FROM ${mdbconfig.tblStockItem} WHERE fdNoEntryStock IN (SELECT fdNoEntryStock FROM  ${mdbconfig.tblStock} WHERE fdTanggal = ? ) ',
          [fdDate]);
      txn.rawDelete(
          'DELETE FROM ${mdbconfig.tblStock} WHERE fdTanggal = ?', [fdDate]);
      txn.rawDelete(
          'DELETE FROM ${mdbconfig.tblStockItemSum} WHERE fdTanggal = ?',
          [fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mstk.Stock>> querySendDataStock(
    String fdKodeLangganan, String startDayDate) async {
  List<Map<String, dynamic>> results = [];
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblStock} WHERE fdKodeLangganan=? AND fdTanggal=? AND fdStatusSent =0 ',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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

Future<bool> checkBarangAlreadyExists(
    String fdKodeBarang, String fdKodeLangganan, String startDayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblStock} a '
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
          'FROM ${mdbconfig.tblStock} a '
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

Future<List<mstk.Stock>> getDataByKodeBarang(
    String fdKodeBarang, String fdKodeLangganan) async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblStock} a '
          'WHERE fdKodeBarang = ? AND fdKodeLangganan=? '
          'Stock BY a.fdID',
          [fdKodeBarang, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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
          "select * "
          ",case when "
          "(select case when fdKodeBarang is not null then 1 else 0 end "
          "	from ${mdbconfig.tblStock} b "
          "	where fdKodeSF=? and fdTanggal = ? and a.fdKodeBarang=b.fdKodeBarang "
          "	and fdKodeLangganan=?) =1 then '1' else '0' end as input "
          "from  ${mdbconfig.tblBarang}  a "
          "where fdKodeGroup=? "
          "Stock BY a.fdKodeBarang ",
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

Future<List<mstk.Stock>> getDataStockByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT sum(fdTotalStock) as fdTotalStock '
          'FROM ${mdbconfig.tblStock} a '
          'WHERE fdKodeLangganan=? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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

Future<List<mstk.Stock>> getDataStockDetailByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblStock} a '
          'WHERE fdKodeLangganan=? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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

Future<List<mstk.Stock>> getDataStockNOO() async {
  late Database db;
  List<mstk.Stock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT a.* '
          'FROM ${mdbconfig.tblStock} a '
          'INNER JOIN ${mdbconfig.tblNOO} b on a.fdKodeLangganan = b.fdKodeNoo '
          'WHERE a.fdStatusSent = 0 ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.Stock.setData(element));
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

Future<bool> checkIsStockExist(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblStock} a '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
        print('count ${results[0]['rowCount']}');
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount >= 1 ? true : false;
}

Future<List<mstk.StockItemSum>> stockBarangExist(String fdKodeBarang) async {
  late Database db;
  List<mstk.StockItemSum> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblStockItemSum} a '
          'WHERE a.fdKodeBarang = ? ',
          [fdKodeBarang]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.StockItemSum.setData(element));
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

// Future<int> countStockCZ() async {
//   late Database db;
//   int rowCount = 0;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       var results = await txn.rawQuery(
//           'SELECT count(DISTINCT fdKodeLangganan) rowCount '
//           'FROM ${mdbconfig.tblStock} a '
//           'inner join ${mdbconfig.tblStockItem} b on a.fdNoEntryStock=b.fdNoEntryStock '
//           'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
//           'WHERE SUBSTR(fdKodeGroup, 1, 1) = ? ',
//           ['1']);

//       if (results.isNotEmpty) {
//         rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
//         print('count ${results[0]['rowCount']}');
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return rowCount;
// }

// Future<int> countStockALK() async {
//   late Database db;
//   int rowCount = 0;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       var results = await txn.rawQuery(
//           'SELECT count(DISTINCT fdKodeLangganan) rowCount '
//           'FROM ${mdbconfig.tblStock} a '
//           'inner join ${mdbconfig.tblStockItem} b on a.fdNoEntryStock=b.fdNoEntryStock '
//           'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
//           'WHERE SUBSTR(fdKodeGroup, 1, 1) = ? ',
//           ['2']);
//       if (results.isNotEmpty) {
//         rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
//         print('count ${results[0]['rowCount']}');
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return rowCount;
// }

// Future<double> totalStockCZ() async {
//   late Database db;
//   double fdTotal = 0;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       var results = await txn.rawQuery(
//           'SELECT b.fdNoEntryStock, b.fdQty, b.fdUnitPrice, b.fdDiscount '
//           'FROM ${mdbconfig.tblStockItem} b '
//           'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
//           'WHERE SUBSTR(fdKodeGroup, 1, 1) = ?',
//           ['1']);
//       if (results.isNotEmpty) {
//         for (var element in results) {
//           double fdQty = 0;
//           double fdUnitPrice = 0;
//           double fdDiscount = 0;
//           fdQty = double.tryParse(element['fdQty']?.toString() ?? '0') ?? 0;
//           fdUnitPrice =
//               double.tryParse(element['fdUnitPrice']?.toString() ?? '0') ?? 0;
//           fdDiscount =
//               double.tryParse(element['fdDiscount']?.toString() ?? '0') ?? 0;
//           fdTotal += (fdQty * fdUnitPrice) - fdDiscount;
//         }
//       }

//       // var results = await txn.rawQuery(
//       //     'SELECT SUM(fdTotalStock - fdDiscount) as rowCount '
//       //     'FROM ${mdbconfig.tblStock} '
//       //     'WHERE fdNoEntryStock IN ( '
//       //     '  SELECT DISTINCT a.fdNoEntryStock '
//       //     '  FROM ${mdbconfig.tblStock} a '
//       //     '  INNER JOIN ${mdbconfig.tblStockItem} b ON a.fdNoEntryStock=b.fdNoEntryStock '
//       //     '  INNER JOIN ${mdbconfig.tblBarang} c ON c.fdKodeBarang=b.fdKodeBarang '
//       //     '  WHERE SUBSTR(fdKodeGroup, 1, 1) = ? '
//       //     ')',
//       //     ['1']);
//       // if (results.isNotEmpty) {
//       //   rowCount = double.tryParse(results.first['rowCount'].toString()) ?? 0;
//       //   print('count ${results[0]['rowCount']}');
//       // }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return fdTotal;
// }

// Future<double> totalStockALK() async {
//   late Database db;
//   double fdTotal = 0;

//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       var results = await txn.rawQuery(
//           'SELECT b.fdNoEntryStock, b.fdQtyStock, b.fdUnitPrice, b.fdDiscount '
//           'FROM ${mdbconfig.tblStockItem} b '
//           'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
//           'WHERE SUBSTR(fdKodeGroup, 1, 1) = ?',
//           ['2']);
//       if (results.isNotEmpty) {
//         for (var element in results) {
//           double fdQty = 0;
//           double fdUnitPrice = 0;
//           double fdDiscount = 0;
//           fdQty = double.tryParse(element['fdQtyStock']?.toString() ?? '0') ?? 0;
//           fdUnitPrice =
//               double.tryParse(element['fdUnitPrice']?.toString() ?? '0') ?? 0;
//           fdDiscount =
//               double.tryParse(element['fdDiscount']?.toString() ?? '0') ?? 0;
//           fdTotal += (fdQty * fdUnitPrice) - fdDiscount;
//         }
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return fdTotal;
// }

// Future<double> omzetLusinCZ() async {
//   late Database db;
//   double lusinCZ = 0;
//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       List<Map<String, dynamic>> results = [];

//       results = await txn.rawQuery(
//           "select "
//           "ROUND(SUM(CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / 12 WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0 * B.fdKonvB_S END), 2) as lusinCZ "
//           "FROM ${mdbconfig.tblStockItem} A "
//           "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
//           "WHERE SUBSTR(B.fdKodeGroup, 1, 1) = ? ",
//           ['1']);
//       print('Query result: $results');
//       if (results.isNotEmpty) {
//         lusinCZ = double.tryParse(results.first['lusinCZ'].toString()) ?? 0;
//         print('count ${results[0]['lusinCZ']}');
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return lusinCZ;
// }

// Future<double> omzetKartonALK() async {
//   late Database db;
//   double kartonALK = 0;
//   try {
//     db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

//     await db.transaction((txn) async {
//       List<Map<String, dynamic>> results = [];

//       results = await txn.rawQuery(
//           "select "
//           "SUM(CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / 12 / B.fdKonvB_S WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 / B.fdKonvB_S WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0  END) as kartonALK "
//           "FROM ${mdbconfig.tblStockItem} A "
//           "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
//           "WHERE SUBSTR(B.fdKodeGroup, 1, 1) = ? ",
//           ['2']);
//       print('Query result: $results');
//       if (results.isNotEmpty) {
//         kartonALK = double.tryParse(results.first['kartonALK'].toString()) ?? 0;
//         print('count ${results[0]['kartonALK']}');
//       }
//     });
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     db.isOpen ? await db.close() : null;
//   }

//   return kartonALK;
// }

Future<List<mstk.ViewStockItem>> infoStock() async {
  late Database db;
  List<mstk.ViewStockItem> items = [];
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select A.fdKodeBarang, B.fdNamaBarang, A.fdJenisSatuan, "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  A.fdQtyStockK * 1.0 "
          " ELSE "
          "  A.fdQtyStockK * 1.0 "
          " END) as pcs, "
          "SUM(A.fdQtyStockK * 1.0 / 12 ) as lsn, "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  A.fdQtyStockK * 1.0 / C.fdQtyKomersil / C.fdKonvB_S "
          " ELSE "
          "  A.fdQtyStockK * 1.0 / 12 / B.fdKonvB_S "
          " END) as ktn "
          "FROM ${mdbconfig.tblStockItemSum} A "
          "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
          "left join ${mdbconfig.tblHanger} C on A.fdKodeBarang=C.fdKodeBarang "
          "GROUP BY A.fdKodeBarang, B.fdNamaBarang ");
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mstk.ViewStockItem.setData(element));
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

Future<bool> checkStockVerifyExists(String todayDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblStockItemSum} a '
          'WHERE a.fdTanggal = ?',
          [todayDate]);

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
