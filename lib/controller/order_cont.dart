import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as chttp;
import 'package:path/path.dart' as cpath;
import 'barang_cont.dart' as cbrg;
import 'database_cont.dart' as cdb;
import '../models/database.dart' as mdbconfig;
import '../models/order.dart' as modr;
import '../models/barang.dart' as mbrg;
import '../models/distcenter.dart' as mstokdc;
import '../models/globalparam.dart' as param;

Future<void> createtblOrder(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblOrder} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdDepo varchar(3), fdKodeLangganan varchar(30), fdNoEntryOrder varchar(30), '
        'fdUnitPrice REAL, fdDiscount REAL, fdTotal REAL, fdQty int, fdTotalOrder REAL, fdJenisSatuan varchar(5), '
        'fdTanggal varchar(30), fdTanggalKirim varchar(30), fdAlamatKirim varchar(500), fdKodeStatus int, '
        'fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createtblOrderItem(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblOrderItem} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdNoEntryOrder varchar(30), fdNoUrutOrder int, fdKodeBarang varchar(30),  fdNamaBarang varchar(150), fdPromosi varchar(5), '
        'fdReplacement int, fdJenisSatuan varchar(5), fdQty int, fdUnitPrice REAL, fdBrutto REAL, fdDiscount REAL, '
        'fdDiscountDetail varchar(200), fdNetto REAL, fdNoPromosi REAL, fdNotes varchar(500), '
        'fdQtyPBE int, fdQtySJ int, fdStatusRecord int, fdKodeStatus int, fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> createtblOrderItemKonversi(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblOrderItemKonversi} (fdID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'fdNoEntryOrder varchar(30), fdNoUrutOrder int, fdKodeBarang varchar(30),  fdNamaBarang varchar(150), fdPromosi varchar(5), '
        'fdReplacement int, fdJenisSatuan varchar(5), fdQty int, fdUnitPrice REAL, fdBrutto REAL, fdDiscount REAL, '
        'fdDiscountDetail varchar(200), fdNetto REAL, fdNoPromosi REAL, fdNotes varchar(500), '
        'fdQtyPBE int, fdQtySJ int, fdStatusRecord int, fdKodeStatus int, fdStatusSent int, fdLastUpdate varchar(20))');
  });
}

Future<void> alterTblOrder(Database db) async {
  bool columnExistsQtyK =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrder, 'fdQtyK');
  bool columnExistsUnitPriceK =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrder, 'fdUnitPriceK');
  bool columnExistsTotalOrderK =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrder, 'fdTotalOrderK');
  bool columnExistsTotalK =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrder, 'fdTotalK');

  await db.transaction((txn) async {
    if (!columnExistsQtyK) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrder} ADD COLUMN fdQtyK int ''',
      );
    }
    if (!columnExistsUnitPriceK) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrder} ADD COLUMN fdUnitPriceK REAL ''',
      );
    }
    if (!columnExistsTotalOrderK) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrder} ADD COLUMN fdTotalOrderK REAL ''',
      );
    }
    if (!columnExistsTotalK) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrder} ADD COLUMN fdTotalK REAL ''',
      );
    }
  });
}

Future<void> alterTblOrderItem(Database db) async {
  bool columnExists =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrderItem, 'isHanger');
  bool columnExistsQtyK =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrderItem, 'fdQtyK');
  bool columnExistsUnitPricePcs = await cdb.isColumnExistTableName(
      db, mdbconfig.tblOrderItem, 'fdUnitPriceK');
  bool columnExistsIsShow =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrderItem, 'isShow');
  bool columnExistsJnItem =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrderItem, 'jnItem');
  bool columnExistsUrut =
      await cdb.isColumnExistTableName(db, mdbconfig.tblOrderItem, 'urut');

  await db.transaction((txn) async {
    if (!columnExists) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN isHanger VARCHAR(3) ''',
      );
    }
    if (!columnExistsQtyK) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN fdQtyK int ''',
      );
    }
    if (!columnExistsUnitPricePcs) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN fdUnitPriceK REAL ''',
      );
    }
    if (!columnExistsIsShow) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN isShow varchar(3) ''',
      );
    }
    if (!columnExistsJnItem) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN jnItem varchar(3) ''',
      );
    }
    if (!columnExistsUrut) {
      await txn.execute(
        '''ALTER TABLE ${mdbconfig.tblOrderItem} ADD COLUMN urut int ''',
      );
    }
  });
}

Future<void> insertOrderBatch(List<modr.Order> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdDepo': element.fdDepo,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdTanggal': element.fdTanggal,
          'fdUnitPrice': element.fdUnitPrice,
          'fdUnitPriceK': element.fdUnitPriceK,
          'fdDiscount': element.fdDiscount,
          'fdTotal': element.fdTotal,
          'fdTotalK': element.fdTotalK,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdTotalOrder': element.fdTotalOrder,
          'fdTotalOrderK': element.fdTotalOrderK,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblOrder, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateOrderBatch(List<modr.Order> items) async {
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
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
          'fdTotalOrder': element.fdTotalOrder,
          'fdTotalOrderK': element.fdTotalOrderK,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdTanggalKirim': element.fdTanggalKirim,
          'fdAlamatKirim': element.fdAlamatKirim,
          'fdStatusSent': 0,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.update(
          mdbconfig.tblOrder,
          item,
          where: 'fdNoEntryOrder = ?',
          whereArgs: [element.fdNoEntryOrder],
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

Future<void> insertOrderItemBatch(List<modr.OrderItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdNoUrutOrder': element.fdNoUrutOrder,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
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
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'isHanger': element.isHanger,
          'isShow': element.isShow,
          'jnItem': element.jnItem,
          'urut': element.urut,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblOrderItem, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateOrderItemBatch(List<modr.OrderItem> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      if (items.isNotEmpty) {
        batchTx.delete(
          mdbconfig.tblOrderItem,
          where: 'fdNoEntryOrder = ?',
          whereArgs: [items[0].fdNoEntryOrder],
        );
      }

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdNoEntryOrder': element.fdNoEntryOrder,
          'fdNoUrutOrder': element.fdNoUrutOrder,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdReplacement': element.fdReplacement,
          'fdJenisSatuan': element.fdJenisSatuan,
          'fdQty': element.fdQty,
          'fdQtyK': element.fdQtyK,
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
          'fdStatusRecord': 0,
          'fdKodeStatus': 0,
          'fdStatusSent': 0,
          'isHanger': element.isHanger,
          'isShow': element.isShow,
          'jnItem': element.jnItem,
          'urut': element.urut,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblOrderItem, item);
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
          'FROM ${mdbconfig.tblOrder} a '
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

Future<List<modr.Order>> getAllOrderByKodeLangganan(
    String? fdKodeLangganan) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblOrder} WHERE fdKodeLangganan=? '
          'ORDER BY fdID',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<List<modr.Order>> getAllOrderCanvasByKodeLangganan(
    String? fdKodeLangganan) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.*, b.fdNoEntryFaktur, b.fdNoFaktur '
          'FROM ${mdbconfig.tblOrder} a '
          'LEFT JOIN ${mdbconfig.tblFaktur} b on a.fdNoEntryOrder=b.fdNoEntryFaktur '
          'WHERE a.fdKodeLangganan=? '
          'ORDER BY fdID',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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
          'SELECT a.fdNoEntryOrder, COUNT(DISTINCT b.fdKodeBarang) as totalProduk '
          'FROM ${mdbconfig.tblOrder} a '
          'INNER JOIN ${mdbconfig.tblOrderItem} b ON a.fdNoEntryOrder = b.fdNoEntryOrder '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ? GROUP BY a.fdNoEntryOrder',
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

Future<List<modr.OrderApi>> getAllOrderTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<modr.OrderApi> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      // var results = await txn.rawQuery(
      //     'SELECT a.fdDepo , a.fdKodeLangganan , a.fdNoEntryOrder , a.fdUnitPrice , a.fdDiscount , a.fdTotal , '
      //     ' a.fdQty , a.fdTotalOrder , a.fdJenisSatuan , a.fdTanggal , a.fdTanggalKirim , a.fdAlamatKirim , '
      //     ' a.fdTotalK, a.fdTotalOrderK, '
      //     ' a.fdKodeStatus, a.fdStatusSent, a.fdLastUpdate '
      //     'FROM ${mdbconfig.tblOrder} a '
      //     'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
      //     [fdKodeLangganan, fdDate]);
      var results = await txn.rawQuery(
          'SELECT a.fdDepo , a.fdKodeLangganan , a.fdNoEntryOrder , '
          ' a.fdTotal , a.fdTotalOrder , a.fdTotalK, a.fdTotalOrderK, '
          ' a.fdTanggal , a.fdTanggalKirim , a.fdAlamatKirim , '
          ' b.fdNoUrutOrder , b.fdKodeBarang , b.fdNamaBarang , b.fdPromosi , '
          ' b.fdReplacement , b.fdJenisSatuan , b.fdQty , b.fdUnitPrice , b.fdQtyK , b.fdUnitPriceK , '
          ' b.fdBrutto , b.fdDiscount , '
          ' b.fdDiscountDetail , b.fdNetto , b.fdNoPromosi , b.fdNotes , b.fdQtyPBE , b.fdQtySJ , b.fdStatusRecord , '
          ' a.fdKodeStatus, a.fdStatusSent, a.fdLastUpdate, b.isHanger '
          'FROM ${mdbconfig.tblOrder} a '
          'INNER JOIN ${mdbconfig.tblOrderItem} b ON a.fdNoEntryOrder = b.fdNoEntryOrder '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
      // for (var row in results) {
      //   double? qty = row['fdQty'] != null
      //       ? double.tryParse(row['fdQty'].toString())
      //       : null;
      //   // Buat salinan map agar bisa dimodifikasi
      //   final mutableRow = Map<String, dynamic>.from(row);
      //   if (qty != null) {
      //     var konversi = await cbrg.getKonversiSatuanPcs(
      //       row['fdKodeBarang'].toString(),
      //       row['fdJenisSatuan'].toString(),
      //       qty,
      //       row['isHanger'].toString(),
      //       txn: txn,
      //     );
      //     mutableRow['fdQty'] =
      //         int.tryParse(konversi['quantity'].toString()) ?? 0;
      //   }

      //   items.add(modr.OrderApi.setData(mutableRow));
      // }

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.OrderApi.setData(element));
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

Future<List<modr.OrderItem>> getAllOrderItemTransaction(
    String fdKodeLangganan, String fdDate) async {
  late Database db;
  List<modr.OrderItem> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT b.fdNoEntryOrder , b.fdNoUrutOrder , b.fdKodeBarang , b.fdNamaBarang , b.fdPromosi , '
          ' b.fdReplacement, b.fdJenisSatuan, b.fdQty, b.fdUnitPrice, b.fdQtyK, b.fdUnitPriceK, b.fdBrutto, b.fdDiscount , '
          ' b.fdDiscountDetail , b.fdNetto , b.fdNoPromosi , b.fdNotes , b.fdQtyPBE , b.fdQtySJ , b.fdStatusRecord , '
          ' b.fdKodeStatus, b.fdStatusSent, b.fdLastUpdate '
          'FROM ${mdbconfig.tblOrder} a '
          'INNER JOIN ${mdbconfig.tblOrderItem} b ON a.fdNoEntryOrder = b.fdNoEntryOrder '
          'WHERE a.fdKodeLangganan = ? AND a.fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.OrderItem.setData(element));
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
          'FROM ${mdbconfig.tblOrder} a '
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
          'FROM ${mdbconfig.tblOrder} a '
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

Future<bool> isOrderNotSent(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblOrder} a '
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

Future<List<modr.Order>> getDataOrderHeaderByNoEntry(
    String fdNoEntryFaktur) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblOrder} WHERE fdNoEntryOrder = ? ',
          [fdNoEntryFaktur]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<List<modr.OrderItem>> getDataOrderDetailByNoEntry(
    String fdNoEntryOrder) async {
  late Database db;
  List<modr.OrderItem> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn
          .rawQuery('''SELECT a.*, c.fdAlamatKirim, s.fdNoSJ, b.fdNamaBarang, 
          case when a.fdJenisSatuan='0' then b.fdSatuanK 
            when a.fdJenisSatuan='1' then b.fdSatuanS 
            when a.fdJenisSatuan='0' then b.fdSatuanK 
          end as fdNamaSatuan 
          FROM ${mdbconfig.tblOrderItem} a 
          INNER JOIN ${mdbconfig.tblBarang} b on a.fdKodeBarang=b.fdKodeBarang 
          INNER JOIN ${mdbconfig.tblOrder} c on c.fdNoEntryOrder=a.fdNoEntryOrder 
          LEFT JOIN ${mdbconfig.tblSuratJalan} s on s.fdNoEntrySJ=c.fdNoEntryOrder 
          WHERE a.fdNoEntryOrder=? ''', [fdNoEntryOrder]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.OrderItem.setData(element));
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
        .rawQuery("SELECT count(*) as fdKey FROM ${mdbconfig.tblOrder} ");
    newFdKey = int.parse(cnt[0]['fdKey'].toString()) + 1;
  });
  String formattedFdKey = newFdKey.toString().padLeft(4, '0');
  sNoSJ = '$fdDepo$fdKodeSF$fdKodeLangganan$formattedFdKey';

  return sNoSJ;
}

Future<int> deleteByNoEntry(String token, String fdNoEntryOrder) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblOrder} WHERE fdNoEntryOrder=?  ',
          [fdNoEntryOrder]);

      await txn.execute(
          'DELETE FROM ${mdbconfig.tblOrderItem} WHERE fdNoEntryOrder=?  ',
          [fdNoEntryOrder]);
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
    int txtStdOrder,
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
          'UPDATE ${mdbconfig.tblOrder} SET fdIsGudang=?, fdIsKomputer=?, fdQty=?, fdQtyOrder=?, fdQtyPajang=?, fdQtyGudang=?, fdQtyKomputer=?, fdReason=?, fdRemark=?, fdLastUpdate=? WHERE fdDocNo=? ',
          [
            stateIsGudang,
            stateIsKomputer,
            txtStockDC,
            txtStdOrder,
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

Future<void> updateStatusSentOrder(
    String fdKodeLangganan, String fdDate) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblOrder} SET fdStatusSent = 1 WHERE fdKodeLangganan = ? AND fdTanggal = ?',
          [fdKodeLangganan, fdDate]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<modr.Order>> querySendDataOrder(
    String fdKodeLangganan, String startDayDate) async {
  List<Map<String, dynamic>> results = [];
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblOrder} WHERE fdKodeLangganan=? AND fdTanggal=? AND fdStatusSent =0 ',
          [fdKodeLangganan, startDayDate]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<modr.Order> uploadOrder(String token, String? fdDepo, String? fdKodeSF,
    String fdKodeLangganan, String startDayDate, String urlAPILiveMD) async {
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
  List<modr.Order> results = [];
  List<Map<String, dynamic>> fdData = [];
  results = await querySendDataOrder(fdKodeLangganan, startDayDate);
  if (results.isNotEmpty) {
    for (var element in results) {
      Map<String, dynamic> item = modr.setJsonDataOrder(
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdNoEntryOrder,
          element.fdTanggal,
          element.fdUnitPrice,
          element.fdDiscount!.toDouble(),
          element.fdTotal,
          element.fdTotalK,
          element.fdQty,
          element.fdQtyK,
          element.fdTotalOrder,
          element.fdTotalOrderK,
          element.fdJenisSatuan,
          element.fdTanggalKirim,
          element.fdAlamatKirim,
          element.fdKodeStatus!.toInt(),
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
        .post(Uri.parse('$urlAPILiveMD/CRUDFtrOrder'),
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
        modr.Order result = modr.Order.fromJson(dataJson.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        modr.Order result = modr.Order.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      modr.Order result = modr.Order.fromJson(jsonBody);

      return result;
    } else if (response.statusCode == 500) {
      Map<String, dynamic> jsonBody = {
        "fdData": "500",
        "fdMessage": "Error timeout"
      };

      modr.Order result = modr.Order.fromJson(jsonBody);

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
          'FROM ${mdbconfig.tblOrder} a '
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
          'FROM ${mdbconfig.tblOrder} a '
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

Future<List<modr.Order>> getDataByKodeBarang(
    String fdKodeBarang, String fdKodeLangganan) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblOrder} a '
          'WHERE fdKodeBarang = ? AND fdKodeLangganan=? '
          'ORDER BY a.fdID',
          [fdKodeBarang, fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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
          "	from ${mdbconfig.tblOrder} b "
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

Future<List<modr.Order>> getDataOrderByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT sum(fdTotalOrder) as fdTotalOrder '
          'FROM ${mdbconfig.tblOrder} a '
          'WHERE fdKodeLangganan=? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<List<modr.Order>> getDataOrderDetailByKodeLangganan(
    String fdKodeLangganan) async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblOrder} a '
          'WHERE fdKodeLangganan=? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<List<modr.Order>> getDataOrderNOO() async {
  late Database db;
  List<modr.Order> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery('SELECT a.* '
          'FROM ${mdbconfig.tblOrder} a '
          'INNER JOIN ${mdbconfig.tblNOO} b on a.fdKodeLangganan = b.fdKodeNoo '
          'WHERE a.fdStatusSent = 0 ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(modr.Order.setData(element));
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

Future<bool> checkIsOrderExist(String fdKodeLangganan, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblOrder} a '
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

Future<int> countOrderCZ() async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(DISTINCT fdKodeLangganan) rowCount '
          'FROM ${mdbconfig.tblOrder} a '
          'inner join ${mdbconfig.tblOrderItem} b on a.fdNoEntryOrder=b.fdNoEntryOrder '
          'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
          'WHERE SUBSTR(fdKodeGroup, 1, 1) = ? ',
          ['1']);

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

  return rowCount;
}

Future<int> countOrderALK() async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(DISTINCT fdKodeLangganan) rowCount '
          'FROM ${mdbconfig.tblOrder} a '
          'inner join ${mdbconfig.tblOrderItem} b on a.fdNoEntryOrder=b.fdNoEntryOrder '
          'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
          'WHERE SUBSTR(fdKodeGroup, 1, 1) = ? ',
          ['2']);
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

  return rowCount;
}

Future<double> totalOrderCZ() async {
  late Database db;
  double fdTotal = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT b.fdNoEntryOrder, b.fdQty, b.fdUnitPrice, b.fdDiscount '
          'FROM ${mdbconfig.tblOrderItem} b '
          'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
          'WHERE SUBSTR(fdKodeGroup, 1, 1) = ?',
          ['1']);
      if (results.isNotEmpty) {
        for (var element in results) {
          double fdQty = 0;
          double fdUnitPrice = 0;
          double fdDiscount = 0;
          fdQty = double.tryParse(element['fdQty']?.toString() ?? '0') ?? 0;
          fdUnitPrice =
              double.tryParse(element['fdUnitPrice']?.toString() ?? '0') ?? 0;
          fdDiscount =
              double.tryParse(element['fdDiscount']?.toString() ?? '0') ?? 0;
          fdTotal += (fdQty * fdUnitPrice) - fdDiscount;
        }
      }

      // var results = await txn.rawQuery(
      //     'SELECT SUM(fdTotalOrder - fdDiscount) as rowCount '
      //     'FROM ${mdbconfig.tblOrder} '
      //     'WHERE fdNoEntryOrder IN ( '
      //     '  SELECT DISTINCT a.fdNoEntryOrder '
      //     '  FROM ${mdbconfig.tblOrder} a '
      //     '  INNER JOIN ${mdbconfig.tblOrderItem} b ON a.fdNoEntryOrder=b.fdNoEntryOrder '
      //     '  INNER JOIN ${mdbconfig.tblBarang} c ON c.fdKodeBarang=b.fdKodeBarang '
      //     '  WHERE SUBSTR(fdKodeGroup, 1, 1) = ? '
      //     ')',
      //     ['1']);
      // if (results.isNotEmpty) {
      //   rowCount = double.tryParse(results.first['rowCount'].toString()) ?? 0;
      //   print('count ${results[0]['rowCount']}');
      // }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdTotal;
}

Future<double> totalOrderALK() async {
  late Database db;
  double fdTotal = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT b.fdNoEntryOrder, b.fdQty, b.fdUnitPrice, b.fdDiscount '
          'FROM ${mdbconfig.tblOrderItem} b '
          'inner join ${mdbconfig.tblBarang} c on c.fdKodeBarang=b.fdKodeBarang '
          'WHERE SUBSTR(fdKodeGroup, 1, 1) = ?',
          ['2']);
      if (results.isNotEmpty) {
        for (var element in results) {
          double fdQty = 0;
          double fdUnitPrice = 0;
          double fdDiscount = 0;
          fdQty = double.tryParse(element['fdQty']?.toString() ?? '0') ?? 0;
          fdUnitPrice =
              double.tryParse(element['fdUnitPrice']?.toString() ?? '0') ?? 0;
          fdDiscount =
              double.tryParse(element['fdDiscount']?.toString() ?? '0') ?? 0;
          fdTotal += (fdQty * fdUnitPrice) - fdDiscount;
        }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdTotal;
}

Future<double> omzetLusinCZ() async {
  late Database db;
  double lusinCZ = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / C.fdQtyKomersil / C.fdKonvB_S WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 / C.fdKonvB_S WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0  END "
          " ELSE "
          "  CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / 12 WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0 * B.fdKonvB_S END "
          " END) as lusinCZ "
          "FROM ${mdbconfig.tblOrderItem} A "
          "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
          "left join ${mdbconfig.tblHanger} C on A.fdKodeBarang=C.fdKodeBarang "
          "WHERE SUBSTR(B.fdKodeGroup, 1, 1) = ? ",
          ['1']);
      print('Query result: $results');
      if (results.isNotEmpty) {
        lusinCZ = double.tryParse(results.first['lusinCZ'].toString()) ?? 0;
        print('count ${results[0]['lusinCZ']}');
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return lusinCZ;
}

Future<double> omzetKartonALK() async {
  late Database db;
  double kartonALK = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select "
          "SUM(case when C.fdKodeBarang IS NOT NULL then "
          "  CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / C.fdQtyKomersil / C.fdKonvB_S WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 / C.fdKonvB_S WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0  END "
          " ELSE "
          "  CASE WHEN A.fdJenisSatuan = 0 THEN A.fdQty * 1.0 / 12 / B.fdKonvB_S WHEN A.fdJenisSatuan = 1 THEN A.fdQty * 1.0 / B.fdKonvB_S WHEN A.fdJenisSatuan = 2 THEN A.fdQty * 1.0  END "
          " END) as kartonALK "
          "FROM ${mdbconfig.tblOrderItem} A "
          "inner join ${mdbconfig.tblBarang} B on A.fdKodeBarang=B.fdKodeBarang "
          "left join ${mdbconfig.tblHanger} C on A.fdKodeBarang=C.fdKodeBarang "
          "WHERE SUBSTR(B.fdKodeGroup, 1, 1) = ? ",
          ['2']);
      print('Query result: $results');
      if (results.isNotEmpty) {
        kartonALK = double.tryParse(results.first['kartonALK'].toString()) ?? 0;
        print('count ${results[0]['kartonALK']}');
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return kartonALK;
}

Future<bool> isSaveDraftPenjualan(String noEntry) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT count(0) rowCount '
          'FROM ${mdbconfig.tblOrder} a '
          'WHERE a.fdNoEntryOrder = ? ',
          [noEntry]);

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
