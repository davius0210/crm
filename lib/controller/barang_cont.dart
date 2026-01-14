import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/barang.dart' as mbrg;

void createTblBarang(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblBarang} (fdKodeBarang varchar(10) Primary Key, fdNamaBarang varchar(100), '
        'fdKodeGroup varchar(4), fdSatuanK varchar(5), fdSatuanS varchar(5), fdSatuanB varchar(5), '
        'fdKonvS_K int, fdKonvB_S int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTblHargaJualBarang(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblHargaJualBarang} (fdKodeHarga varchar(4), fdKodeBarang varchar(100), '
        'fdHarga REAL, fdHargaQty REAL, fdHargaSatuan REAL, fdTermasukPPN varchar(5), fdKodeLangganan varchar(30), fdLastUpdate varchar(20))');
  });
}

void createTblGroupBarang(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblGroupBarang} (fdKodeGroup varchar(4) Primary Key, fdNamaGroup varchar(100), '
        'fdGroupInduk varchar(3), fdLastUpdate varchar(20))');
  });
}

void createTblBarangExtra(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblBarangExtra} (fdKodeBarang varchar(10) Primary Key, '
        'fdQtyExtra int,  fdLastUpdate varchar(20))');
  });
}

Future<void> createTblBarangSales(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblBarangSales} (fdID varchar(10) Primary Key, fdKodeSF varchar(30), fdKodeBarang varchar(30), '
        ' fdLastUpdate varchar(20))');
  });
}

Future<void> createTblHanger(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblHanger} (fdID int Primary Key, fdKodeBarang varchar(30), '
        'fdSatuanK varchar(50), fdSatuanS varchar(50), fdSatuanB varchar(50), fdKonvS_K int, fdKonvB_S int, '
        'fdKeterangan varchar(350), fdQtyKomersil int, fdQtyPromosi int, fdLastUpdate varchar(20))');
  });
}

Future<void> createTblHangerDetail(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblHangerDetail} (fdID int, fdKodeBarang varchar(30), '
        'fdPromosi varchar(5), fdQty int, fdKeterangan varchar(250), fdLastUpdate varchar(20))');
  });
}

Future<void> createTbllBarangTOP(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        'CREATE TABLE IF NOT EXISTS ${mdbconfig.tblBarangTOP} (fdID int,	fdKodeHarga varchar(10), '
        'fdKodeGroup varchar(2),	fdKodeBarang varchar(10),	fdTOP int,	fdStartDate varchar(30), '
        'fdEndDate varchar(30),	fdStatusRecord int, fdLastUpdate varchar(20))');
  });
}

Future<void> insertBarangBatch(List<mbrg.Barang> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblBarang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeBarang': element.fdKodeBarang,
          'fdNamaBarang': element.fdNamaBarang,
          'fdKodeGroup': element.fdKodeGroup,
          'fdSatuanK': element.fdSatuanK,
          'fdSatuanS': element.fdSatuanS,
          'fdSatuanB': element.fdSatuanB,
          'fdKonvS_K': element.fdKonvS_K,
          'fdKonvB_S': element.fdKonvB_S,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblBarang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertHargaJualBarangBatch(
    List<mbrg.HargaJualBarang> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblHargaJualBarang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeHarga': element.fdKodeHarga,
          'fdKodeBarang': element.fdKodeBarang,
          'fdHarga': element.fdHarga,
          'fdHargaQty': element.fdHargaQty,
          'fdHargaSatuan': element.fdHargaSatuan,
          'fdKodeLangganan': element.fdKodeLangganan,
          'fdTermasukPPN': element.fdTermasukPPN,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblHargaJualBarang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertBarangExtraBatch(List<mbrg.BarangExtra> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblHargaJualBarang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeBarang': element.fdKodeBarang,
          'fdQtyExtra': element.fdQtyExtra,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblHargaJualBarang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertGroupBarangBatch(List<mbrg.GroupBarang> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblGroupBarang}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeGroup': element.fdKodeGroup,
          'fdNamaGroup': element.fdDescription,
          'fdGroupInduk': element.fdGroupInduk,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblGroupBarang, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertHangerBatch(List<mbrg.Hanger> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblHanger}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdID': element.fdID,
          'fdKodeBarang': element.fdKodeBarang,
          'fdSatuanK': element.fdSatuanK,
          'fdSatuanS': element.fdSatuanS,
          'fdSatuanB': element.fdSatuanB,
          'fdKonvB_S': element.fdKonvB_S,
          'fdKonvS_K': element.fdKonvS_K,
          'fdQtyKomersil': element.fdQtyKomersil,
          'fdQtyPromosi': element.fdQtyPromosi,
          'fdKeterangan': element.fdKeterangan,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblHanger, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertHangerDetailBatch(List<mbrg.HangerDetail> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblHangerDetail}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdID': element.fdID,
          'fdKodeBarang': element.fdKodeBarang,
          'fdPromosi': element.fdPromosi,
          'fdQty': element.fdQty,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblHangerDetail, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertBarangSalesBatch(List<mbrg.BarangSales> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblBarangSales}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeSF': element.fdKodeSF,
          'fdKodeBarang': element.fdKodeBarang,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblBarangSales, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> insertBarangTOPBatch(List<mbrg.BarangTOP> items) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      Batch batchTx = txn.batch();

      batchTx.rawDelete('DELETE FROM ${mdbconfig.tblBarangTOP}');

      for (var element in items) {
        Map<String, dynamic> item = {
          'fdKodeHarga': element.fdKodeHarga,
          'fdKodeGroup': element.fdKodeGroup,
          'fdKodeBarang': element.fdKodeBarang,
          'fdTOP': element.fdTOP,
          'fdStartDate': element.fdStartDate,
          'fdEndDate': element.fdEndDate,
          'fdLastUpdate': element.fdLastUpdate,
        };

        batchTx.insert(mdbconfig.tblBarangTOP, item);
      }

      batchTx.commit(noResult: true);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<List<mbrg.GroupBarang>> getAllGroupBarang(String fdKompFlag) async {
  late Database db;
  List<mbrg.GroupBarang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.query(mdbconfig.tblGroupBarang,
          columns: ['fdKodeGroup', 'fdDescription'],
          distinct: true,
          where: fdKompFlag.isEmpty ? null : 'fdKompFlag = ?',
          whereArgs: fdKompFlag.isEmpty ? [] : [fdKompFlag],
          orderBy: 'fdKodeGroup');
      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.GroupBarang.setData(element));
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

Future<List<mbrg.GroupBarang>> getAllJenisBarang() async {
  late Database db;
  List<mbrg.GroupBarang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results =
          await txn.rawQuery('SELECT DISTINCT fdKompFlag, fdNamaKompFlag '
              'FROM ${mdbconfig.tblGroupBarang} '
              'ORDER BY fdNamaKompFlag');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.GroupBarang.setData(element));
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

Future<List<mbrg.Barang>> getAllBarang(
    String fdKodeLangganan, String fdKodeSF) async {
  late Database db;
  List<mbrg.Barang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> resultsBarangSales = [];
      List<Map<String, dynamic>> resultsStock = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
          ', g.fdHarga '
          'FROM ${mdbconfig.tblBarang} a '
          'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeLangganan =? '
          'ORDER BY a.fdNamaBarang',
          [fdKodeLangganan]);

      // if (results.isNotEmpty) {
      //   //CEK ADA STOCK
      //   resultsStock = resultsStock = await txn.rawQuery(
      //       'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
      //       ', g.fdHarga '
      //       'FROM ${mdbconfig.tblBarang} a '
      //       'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
      //       'INNER JOIN  ${mdbconfig.tblStock} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
      //       'ORDER BY a.fdNamaBarang',
      //       [fdKodeHarga, '0', fdKodeSF]);
      //   if (resultsStock.isNotEmpty) {
      //     //ADA STOCK
      //     //CEK ADA BARANG SALES
      //     resultsBarangSales = await txn.rawQuery(
      //         'SELECT * FROM ${mdbconfig.tblBarangSales} WHERE fdKodeSF =? ',
      //         [fdKodeSF]);
      //     if (resultsBarangSales.isNotEmpty) {
      //       for (var element in resultsBarangSales) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     } else {
      //       for (var element in resultsStock) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     }
      //   } else {
      //     //TIDAK ADA STOCK
      //     //CEK ADA BARANG SALES
      //     resultsBarangSales = await txn.rawQuery(
      //         'SELECT * FROM ${mdbconfig.tblBarangSales} WHERE fdKodeSF =? ',
      //         [fdKodeSF]);
      //     if (resultsBarangSales.isNotEmpty) {
      //       for (var element in resultsBarangSales) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     } else {
      //       for (var element in results) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     }
      //   }
      // }

      if (results.isNotEmpty) {
        //CEK ADA BARANG SALES
        resultsBarangSales = await txn.rawQuery(
            'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
            ', g.fdHarga '
            'FROM ${mdbconfig.tblBarang} a '
            'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeLangganan =? '
            'INNER JOIN  ${mdbconfig.tblBarangSales} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
            'ORDER BY a.fdNamaBarang',
            [fdKodeLangganan, fdKodeSF]);
        if (resultsBarangSales.isNotEmpty) {
          for (var element in resultsBarangSales) {
            items.add(mbrg.Barang.setData(element));
          }
        } else {
          for (var element in results) {
            items.add(mbrg.Barang.setData(element));
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

Future<List<mbrg.Barang>> getAllBarangNoo(
    String fdKodeHarga, String fdKodeSF) async {
  late Database db;
  List<mbrg.Barang> items = [];
  List<Map<String, dynamic>> resultsBarangSales = [];
  List<Map<String, dynamic>> resultsStock = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
          ', g.fdHarga '
          'FROM ${mdbconfig.tblBarang} a '
          'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
          'ORDER BY a.fdNamaBarang',
          [fdKodeHarga, '0']);

      // if (results.isNotEmpty) {
      //   //CEK ADA STOCK
      //   resultsStock = await txn.rawQuery(
      //       'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
      //       ', g.fdHarga '
      //       'FROM ${mdbconfig.tblBarang} a '
      //       'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
      //       'INNER JOIN  ${mdbconfig.tblStock} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
      //       'ORDER BY a.fdNamaBarang',
      //       [fdKodeHarga, '0', fdKodeSF]);
      //   if (resultsStock.isNotEmpty) {
      //     //ADA STOCK
      //     //CEK ADA BARANG SALES
      //     resultsBarangSales = await txn.rawQuery(
      //         'SELECT * FROM ${mdbconfig.tblBarangSales} WHERE fdKodeSF =? ',
      //         [fdKodeSF]);
      //     if (resultsBarangSales.isNotEmpty) {
      //       for (var element in resultsBarangSales) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     } else {
      //       for (var element in resultsStock) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     }
      //   } else {
      //     //TIDAK ADA STOCK
      //     //CEK ADA BARANG SALES
      //     resultsBarangSales = await txn.rawQuery(
      //         'SELECT * FROM ${mdbconfig.tblBarangSales} WHERE fdKodeSF =? ',
      //         [fdKodeSF]);
      //     if (resultsBarangSales.isNotEmpty) {
      //       for (var element in resultsBarangSales) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     } else {
      //       for (var element in results) {
      //         items.add(mbrg.Barang.setData(element));
      //       }
      //     }
      //   }
      // }

      if (results.isNotEmpty) {
        //CEK ADA BARANG SALES
        resultsBarangSales = await txn.rawQuery(
            'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
            ', g.fdHarga '
            'FROM ${mdbconfig.tblBarang} a '
            'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
            'INNER JOIN  ${mdbconfig.tblBarangSales} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
            'ORDER BY a.fdNamaBarang',
            [fdKodeHarga, '0', fdKodeSF]);
        if (resultsBarangSales.isNotEmpty) {
          for (var element in resultsBarangSales) {
            items.add(mbrg.Barang.setData(element));
          }
        } else {
          for (var element in results) {
            items.add(mbrg.Barang.setData(element));
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

Future<List<mbrg.Barang>> getAllBarangStock(String fdKodeSF) async {
  late Database db;
  List<mbrg.Barang> items = [];
  List<Map<String, dynamic>> resultsBarangSales = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
          'FROM ${mdbconfig.tblBarang} a '
          'ORDER BY a.fdNamaBarang');

      if (results.isNotEmpty) {
        //CEK ADA BARANG SALES
        resultsBarangSales = await txn.rawQuery(
            'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
            'FROM ${mdbconfig.tblBarang} a '
            'INNER JOIN  ${mdbconfig.tblBarangSales} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
            'ORDER BY a.fdNamaBarang',
            [fdKodeSF]);
        if (resultsBarangSales.isNotEmpty) {
          for (var element in resultsBarangSales) {
            items.add(mbrg.Barang.setData(element));
          }
        } else {
          for (var element in results) {
            items.add(mbrg.Barang.setData(element));
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

Future<List<mbrg.BarangStock>> getAllBarangStockCarry(
    String fdKodeLangganan, String fdKodeSF) async {
  late Database db;
  List<mbrg.BarangStock> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> resultsBarangSales = [];
      List<Map<String, dynamic>> resultsStock = [];

      results = await txn.rawQuery(
          'SELECT DISTINCT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
          ', g.fdHarga, s.fdQtyStock, s.fdQtyStockK '
          'FROM ${mdbconfig.tblBarang} a '
          'INNER JOIN ${mdbconfig.tblStockItemSum} s ON s.fdKodeBarang = a.fdKodeBarang '
          'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeLangganan =? '
          'ORDER BY a.fdNamaBarang',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        //CEK ADA BARANG SALES
        // resultsBarangSales = await txn.rawQuery(
        //     'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
        //     ', g.fdHarga '
        //     'FROM ${mdbconfig.tblBarang} a '
        //     'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeLangganan =? '
        //     'INNER JOIN  ${mdbconfig.tblBarangSales} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
        //     'ORDER BY a.fdNamaBarang',
        //     [fdKodeLangganan, fdKodeSF]);
        // if (resultsBarangSales.isNotEmpty) {
        //   for (var element in resultsBarangSales) {
        //     items.add(mbrg.Barang.setData(element));
        //   }
        // } else {
        for (var element in results) {
          items.add(mbrg.BarangStock.setData(element));
        }
        // }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mbrg.BarangStock>> getAllBarangNooStockCarry(
    String fdKodeHarga, String fdKodeSF) async {
  late Database db;
  List<mbrg.BarangStock> items = [];
  List<Map<String, dynamic>> resultsBarangSales = [];
  List<Map<String, dynamic>> resultsStock = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT DISTINCT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
          ', g.fdHarga, s.fdQtyStock, s.fdQtyStockK '
          'FROM ${mdbconfig.tblBarang} a '
          'INNER JOIN ${mdbconfig.tblStockItemSum} s ON s.fdKodeBarang = a.fdKodeBarang '
          'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
          'ORDER BY a.fdNamaBarang',
          [fdKodeHarga, '0']);

      if (results.isNotEmpty) {
        //CEK ADA BARANG SALES
        // resultsBarangSales = await txn.rawQuery(
        //     'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdSatuanK, a.fdSatuanS, a.fdSatuanB, a.fdKonvS_K, a.fdKonvB_S, a.fdLastUpdate '
        //     ', g.fdHarga '
        //     'FROM ${mdbconfig.tblBarang} a '
        //     'INNER JOIN ${mdbconfig.tblHargaJualBarang} g ON g.fdKodeBarang = a.fdKodeBarang AND g.fdKodeHarga =? AND g.fdKodeLangganan = ?  '
        //     'INNER JOIN  ${mdbconfig.tblBarangSales} b ON b.fdKodeBarang = a.fdKodeBarang WHERE b.fdKodeSF =? '
        //     'ORDER BY a.fdNamaBarang',
        //     [fdKodeHarga, '0', fdKodeSF]);
        // if (resultsBarangSales.isNotEmpty) {
        //   for (var element in resultsBarangSales) {
        //     items.add(mbrg.Barang.setData(element));
        //   }
        // } else {
        for (var element in results) {
          items.add(mbrg.BarangStock.setData(element));
        }
        // }
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mbrg.Barang>> getBarangByFdKodeBarang(String fdKodeBarang) async {
  late Database db;
  List<mbrg.Barang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdKodeGroup '
          'FROM ${mdbconfig.tblBarang} a '
          'WHERE fdKodeBarang = ? ',
          [fdKodeBarang]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.Barang.setData(element));
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

Future<List<mbrg.GroupBarang>> getGroupBarangByFdKodeBarang(
    String fdKodeGroup) async {
  late Database db;
  List<mbrg.GroupBarang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT DISTINCT fdKodeGroup, fdDescription '
          'FROM ${mdbconfig.tblGroupBarang} '
          'WHERE fdKodeGroup = ? ',
          [fdKodeGroup]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.GroupBarang.setData(element));
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

Future<List<mbrg.Barang>> getKodeGroupBarangByFdKodeBarang(
    String fdKodeBarang) async {
  late Database db;
  List<mbrg.Barang> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdNamaBarang, a.fdKodeGroup as fdKodeGroupBarang '
          'FROM ${mdbconfig.tblBarang} a '
          'WHERE fdKodeBarang = ? ',
          [fdKodeBarang]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.Barang.setData(element));
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

Future<List<mbrg.BarangSelected>> getAllBarangInputOrder(
    String fdNoEntryOrder) async {
  late Database db;
  List<mbrg.BarangSelected> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select a.fdNoEntryOrder, a.fdKodeBarang, b.fdNamaBarang, a.fdJenisSatuan, a.fdPromosi, "
          " a.fdDiscount, a.fdDiscountDetail, a.fdQty, a.fdUnitPrice, a.fdQtyK, a.fdUnitPriceK, "
          " case when a.isHanger=? then b.fdKonvS_K else IFNULL(c.fdKonvS_K,0) end as fdKonvS_K, "
          " case when a.isHanger=? then b.fdKonvB_S else IFNULL(c.fdKonvB_S,0) end as fdKonvB_S, "
          " a.isHanger, a.isShow, a.jnItem, a.urut, s.fdQtyStock, s.fdQtyStockK "
          "from  ${mdbconfig.tblOrderItem}  a "
          "inner join ${mdbconfig.tblBarang} b on a.fdKodeBarang=b.fdKodeBarang "
          "left join ${mdbconfig.tblHanger} c on a.fdKodeBarang=c.fdKodeBarang "
          "left join ${mdbconfig.tblStockItemSum} s on a.fdKodeBarang=s.fdKodeBarang "
          "where fdNoEntryOrder=?   "
          "ORDER BY a.fdKodeBarang ",
          ['0', '0', fdNoEntryOrder]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mbrg.BarangSelected.setData(element));
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

Future<double> getHargaJualBarangByFdKodeBarang(
    String fdKodeBarang,
    int? fdKodeSatuan,
    String fdKodeLangganan,
    int fdPPN,
    String ishanger) async {
  late Database db;
  double hargaJual = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> hanger = [];
      if (ishanger == '1') {
        hanger = await txn.rawQuery(
            '''SELECT a.fdKodeBarang, fdSatuanS, fdSatuanB, fdKonvB_S, a.fdKeterangan, b.fdPromosi, b.fdQty
          FROM ${mdbconfig.tblHanger} a
          inner join ${mdbconfig.tblHangerDetail} b on a.fdKodeBarang=b.fdKodeBarang and b.fdPromosi='T'
          WHERE a.fdKodeBarang=?   ''', [fdKodeBarang]);
        if (hanger.isNotEmpty) {
          results = await txn.rawQuery(
              "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND( (CASE WHEN LTRIM(RTRIM(H.fdTermasukPPN)) = ? THEN (H.fdHarga / NULLIF(H.fdHargaQty, 0)) * ((100 + ?) / 100.0) ELSE (H.fdHarga / NULLIF(H.fdHargaQty, 0)) END) * "
              "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN ? WHEN ? = 2 THEN ? * ? END), 4) AS fdHarga,CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END as tes "
              " , '1' as isHanger "
              "FROM ${mdbconfig.tblBarang} B "
              "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeLangganan = (select fdKodeLangganan from ${mdbconfig.tblLangganan} L where L.fdKodeLangganan=?)  "
              "where B.fdkodebarang=? ",
              [
                'E',
                fdPPN,
                fdKodeSatuan,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                hanger[0]['fdKonvB_S'] ?? 0,
                fdKodeSatuan,
                fdKodeSatuan,
                fdKodeSatuan,
                fdKodeLangganan,
                fdKodeBarang
              ]);
        }
      } else {
        results = await txn.rawQuery(
            "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND( (CASE WHEN LTRIM(RTRIM(H.fdTermasukPPN)) = ? THEN (H.fdHarga / NULLIF(H.fdHargaQty, 0)) * ((100 + ?) / 100.0) ELSE (H.fdHarga / NULLIF(H.fdHargaQty, 0)) END) * "
            "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END), 4) AS fdHarga,CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END as tes "
            " , '0' as isHanger "
            "FROM ${mdbconfig.tblBarang} B "
            "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeLangganan = (select fdKodeLangganan from ${mdbconfig.tblLangganan} L where L.fdKodeLangganan=?)  "
            "where B.fdkodebarang=? ",
            [
              'E',
              fdPPN,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeLangganan,
              fdKodeBarang
            ]);
      }
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdHarga'] ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<double> getHargaAsliByFdKodeBarang(String fdKodeBarang,
    int? fdKodeSatuan, String fdKodeLangganan, String ishanger) async {
  late Database db;
  double hargaJual = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> hanger = [];
      if (ishanger == '1') {
        hanger = await txn.rawQuery(
            '''SELECT a.fdKodeBarang, fdSatuanS, fdSatuanB, fdKonvB_S, a.fdKeterangan, b.fdPromosi, b.fdQty
          FROM ${mdbconfig.tblHanger} a
          inner join ${mdbconfig.tblHangerDetail} b on a.fdKodeBarang=b.fdKodeBarang and b.fdPromosi='T'
          WHERE a.fdKodeBarang=?   ''', [fdKodeBarang]);
        if (hanger.isNotEmpty) {
          results = await txn.rawQuery(
              "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND(H.fdHarga / NULLIF(H.fdHargaQty, 0) * "
              "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN ? WHEN ? = 2 THEN ? * ? END), 4) AS fdHarga,  "
              " '1' as isHanger "
              "FROM ${mdbconfig.tblBarang} B "
              "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeLangganan = (select fdKodeLangganan from ${mdbconfig.tblLangganan} L where L.fdKodeLangganan=?)  "
              "where B.fdkodebarang=? ",
              [
                fdKodeSatuan,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                hanger[0]['fdKonvB_S'] ?? 0,
                fdKodeLangganan,
                fdKodeBarang
              ]);
        }
      } else {
        results = await txn.rawQuery(
            "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND(H.fdHarga / NULLIF(H.fdHargaQty, 0) * "
            "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END), 4) AS fdHarga, "
            " '0' as isHanger "
            "FROM ${mdbconfig.tblBarang} B "
            "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeLangganan = (select fdKodeLangganan from ${mdbconfig.tblLangganan} L where L.fdKodeLangganan=?)  "
            "where B.fdkodebarang=? ",
            [
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeLangganan,
              fdKodeBarang
            ]);
      }
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdHarga'] ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<double> getHargaAsliByFdKodeBarangNOO(
    String fdKodeBarang,
    int? fdKodeSatuan,
    String fdKodeHarga,
    String fdKodeLangganan,
    String ishanger) async {
  late Database db;
  double hargaJual = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> hanger = [];
      if (ishanger == '1') {
        hanger = await txn.rawQuery(
            '''SELECT a.fdKodeBarang, fdSatuanS, fdSatuanB, fdKonvB_S, a.fdKeterangan, b.fdPromosi, b.fdQty
          FROM ${mdbconfig.tblHanger} a
          inner join ${mdbconfig.tblHangerDetail} b on a.fdKodeBarang=b.fdKodeBarang and b.fdPromosi='T'
          WHERE a.fdKodeBarang=?   ''', [fdKodeBarang]);
        if (hanger.isNotEmpty) {
          print(hanger);
          results = await txn.rawQuery(
              "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND(H.fdHarga / NULLIF(H.fdHargaQty, 0) * "
              "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN ? WHEN ? = 2 THEN ? * ? END), 4) AS fdHarga,  "
              " '1' as isHanger "
              "FROM ${mdbconfig.tblBarang} B "
              "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeHarga = ? and H.fdKodeLangganan = ?  "
              "where B.fdkodebarang=? ",
              [
                fdKodeSatuan,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                hanger[0]['fdKonvB_S'] ?? 0,
                fdKodeHarga,
                fdKodeLangganan,
                fdKodeBarang
              ]);
        }
      } else {
        results = await txn.rawQuery(
            "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND(H.fdHarga / NULLIF(H.fdHargaQty, 0) * "
            "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END), 4) AS fdHarga, "
            " '0' as isHanger "
            "FROM ${mdbconfig.tblBarang} B "
            "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang and H.fdKodeHarga = ? and H.fdKodeLangganan = ? "
            "where B.fdkodebarang=? ",
            [
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeHarga,
              fdKodeLangganan,
              fdKodeBarang
            ]);
      }
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdHarga'] ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<double> getHargaJualBarangByFdKodeBarangNoo(String fdKodeBarang,
    int? fdKodeSatuan, String fdKodeHarga, int fdPPN, String ishanger) async {
  late Database db;
  double hargaJual = 0;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> hanger = [];
      if (ishanger == '1') {
        hanger = await txn.rawQuery(
            '''SELECT a.fdKodeBarang, fdSatuanS, fdSatuanB, fdKonvB_S, a.fdKeterangan, b.fdPromosi, b.fdQty
          FROM ${mdbconfig.tblHanger} a
          inner join ${mdbconfig.tblHangerDetail} b on a.fdKodeBarang=b.fdKodeBarang and b.fdPromosi='T'
          WHERE a.fdKodeBarang=?   ''', [fdKodeBarang]);
        if (hanger.isNotEmpty) {
          results = await txn.rawQuery(
              "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND( (CASE WHEN LTRIM(RTRIM(H.fdTermasukPPN)) = ? THEN (H.fdHarga / NULLIF(H.fdHargaQty, 0)) * ((100 + ?) / 100.0) ELSE (H.fdHarga / NULLIF(H.fdHargaQty, 0)) END) * "
              "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN ? WHEN ? = 2 THEN ? * ? END), 4) AS fdHarga,CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END as tes "
              " , '1' as isHanger "
              "FROM ${mdbconfig.tblBarang} B "
              "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang  and H.fdKodeHarga = ?  and H.fdKodeLangganan = ?   "
              "where B.fdkodebarang=? ",
              [
                'E',
                fdPPN,
                fdKodeSatuan,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                fdKodeSatuan,
                hanger[0]['fdQty'] ?? 0,
                hanger[0]['fdKonvB_S'] ?? 0,
                fdKodeSatuan,
                fdKodeSatuan,
                fdKodeSatuan,
                fdKodeHarga,
                '0',
                fdKodeBarang
              ]);
        }
      } else {
        results = await txn.rawQuery(
            "select B.fdKodeBarang,B.fdKonvS_K,B.fdKonvB_S,H.fdTermasukPPN,H.fdHarga as fdPrice,H.fdHargaQty, ROUND( (CASE WHEN LTRIM(RTRIM(H.fdTermasukPPN)) = ? THEN (H.fdHarga / NULLIF(H.fdHargaQty, 0)) * ((100 + ?) / 100.0) ELSE (H.fdHarga / NULLIF(H.fdHargaQty, 0)) END) * "
            "(CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END), 4) AS fdHarga,CASE WHEN ? = 0 THEN 1 WHEN ? = 1 THEN B.fdKonvS_K WHEN ? = 2 THEN B.fdKonvB_S * B.fdKonvS_K END as tes "
            "FROM ${mdbconfig.tblBarang} B "
            "INNER JOIN ${mdbconfig.tblHargaJualBarang} H on B.fdkodeBarang = H.fdkodeBarang  and H.fdKodeHarga = ?  and H.fdKodeLangganan = ?  "
            "where B.fdkodebarang=? ",
            [
              'E',
              fdPPN,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeSatuan,
              fdKodeHarga,
              '0',
              fdKodeBarang
            ]);
      }
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdHarga'] ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<String> getKodeHarga(String fdKodeLangganan) async {
  late Database db;
  String hargaJual = '';
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select fdKodeHarga FROM ${mdbconfig.tblHargaJualBarang} WHERE fdKodeLangganan =  ? LIMIT 1 ",
          [fdKodeLangganan]);
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdKodeHarga'];
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<String> getKodeHargaByKelasOutlet(String fdKodeJenis) async {
  late Database db;
  String hargaJual = '';
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          "select fdKodeHarga FROM ${mdbconfig.tblTipeHarga} WHERE fdKodeJenis =  ? LIMIT 1 ",
          [fdKodeJenis]);
      print(results);
      if (results.isNotEmpty) {
        hargaJual = results[0]['fdKodeHarga'];
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return hargaJual;
}

Future<List<mbrg.Satuan>> getSatuanBarangByFdKodeBarang(
    String fdKodeBarang) async {
  late Database db;
  List<mbrg.Satuan> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan from ( 
           SELECT '0' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=? 
           UNION  
           SELECT '1' AS fdKodeSatuan, fdSatuanS AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=? 
           UNION  
           SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=? 
          )a group by fdNamaSatuan order by fdKodeSatuan ''',
          [fdKodeBarang, fdKodeBarang, fdKodeBarang]);

      if (results.isNotEmpty) {
        // print(results);
        for (var element in results) {
          // print(element);
          items.add(mbrg.Satuan.setData(element));
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

Future<Map<String, List<mbrg.Satuan>>> getSatuanBarangByFdKodeBarangMap(
    String fdKodeBarang) async {
  late Database db;
  Map<String, List<mbrg.Satuan>> items = {};

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> ifExists = [];
      List<Map<String, dynamic>> results = [];
      ifExists = await txn.rawQuery(
          '''SELECT * FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?   ''',
          [fdKodeBarang]);
      if (ifExists.isNotEmpty) {
        results = await txn.rawQuery(
            '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '1' as isHanger from (
         SELECT '1' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?
         UNION
         SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?
        )a group by fdNamaSatuan order by fdKodeSatuan ''',
            [fdKodeBarang, fdKodeBarang]);
      } else {
        results = await txn.rawQuery(
            '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '0' as isHanger from (
         SELECT '1' AS fdKodeSatuan, fdSatuanS AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
         UNION
         SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
        )a group by fdNamaSatuan order by fdKodeSatuan ''',
            [fdKodeBarang, fdKodeBarang]);
        // results = await txn.rawQuery(
        //     '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '0' as isHanger from (
        //    SELECT '0' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
        //    UNION
        //    SELECT '1' AS fdKodeSatuan, fdSatuanS AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
        //    UNION
        //    SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
        //   )a group by fdNamaSatuan order by fdKodeSatuan ''',
        //     [fdKodeBarang, fdKodeBarang, fdKodeBarang]);
      }
      if (results.isNotEmpty) {
        // print(results);
        for (var element in results) {
          // print(element);
          items
              .putIfAbsent(fdKodeBarang, () => [])
              .add(mbrg.Satuan.setData(element));
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

Future<Map<String, List<mbrg.Satuan>>> getSatuanBarangWithPcsByFdKodeBarangMap(
    String fdKodeBarang) async {
  late Database db;
  Map<String, List<mbrg.Satuan>> items = {};

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> ifExists = [];
      List<Map<String, dynamic>> results = [];
      ifExists = await txn.rawQuery(
          '''SELECT * FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?   ''',
          [fdKodeBarang]);
      if (ifExists.isNotEmpty) {
        results = await txn.rawQuery(
            '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '1' as isHanger from (
           SELECT '1' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?
           UNION
           SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?
           UNION
           SELECT '0' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
          )a group by fdNamaSatuan order by fdNamaSatuan ''',
            [fdKodeBarang, fdKodeBarang, fdKodeBarang]);
      } else {
        results = await txn.rawQuery(
            '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '0' as isHanger from (
           SELECT '0' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
           UNION
           SELECT '1' AS fdKodeSatuan, fdSatuanS AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
           UNION
           SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?
          )a group by fdNamaSatuan order by fdKodeSatuan ''',
            [fdKodeBarang, fdKodeBarang, fdKodeBarang]);
      }
      if (results.isNotEmpty) {
        // print(results);
        for (var element in results) {
          // print(element);
          items
              .putIfAbsent(fdKodeBarang, () => [])
              .add(mbrg.Satuan.setData(element));
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

Future<Map<String, List<mbrg.Satuan>>> getListSatuanBarangByFdKodeBarangMap(
    List<mbrg.BarangSelected> listBarangSelected) async {
  late Database db;
  Map<String, List<mbrg.Satuan>> items = {};

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      for (var barang in listBarangSelected) {
        String fdKodeBarang = barang.fdKodeBarang;
        List<Map<String, dynamic>> result = [];
        List<Map<String, dynamic>> ifExists = await txn.rawQuery(
            '''SELECT * FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?   ''',
            [fdKodeBarang]);
        if (ifExists.isNotEmpty) {
          result = await txn.rawQuery(
              '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '1' as isHanger from ( 
           SELECT '1' AS fdKodeSatuan, fdSatuanK AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=? 
           UNION  
           SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=? 
          )a group by fdNamaSatuan order by fdKodeSatuan ''',
              [fdKodeBarang, fdKodeBarang]);
        } else {
          result = await txn.rawQuery(
              '''SELECT min(fdKodeSatuan) as fdKodeSatuan, fdNamaSatuan, '0' as isHanger from ( 
         SELECT '1' AS fdKodeSatuan, fdSatuanS AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=? 
         UNION  
         SELECT '2' AS fdKodeSatuan, fdSatuanB AS fdNamaSatuan FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=? 
        )a group by fdNamaSatuan order by fdKodeSatuan ''',
              [fdKodeBarang, fdKodeBarang]);
        }
        if (result.isNotEmpty) {
          for (var element in result) {
            items
                .putIfAbsent(fdKodeBarang, () => [])
                .add(mbrg.Satuan.setData(element));
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

Future<double> getUnitPriceKonversiSatuan(
    String fdKodeBarang, String satuanOrder, double harga) async {
  late Database db;
  double unitPrice = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    if (satuanOrder != '0') {
      await db.transaction((txn) async {
        List<Map<String, dynamic>> results = [];

        results = await txn.rawQuery(
            "select case when '1'=? then ? / 12 when '2'=? then ? / fdKonvB_S / 12 end as unitPrice FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang =  ? LIMIT 1 ",
            [satuanOrder, harga, satuanOrder, harga, fdKodeBarang]);
        print(results);
        if (results.isNotEmpty) {
          unitPrice = results[0]['unitPrice'];
        }
      });
    } else {
      unitPrice = harga;
    }
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return unitPrice;
}

Future<Map<String, dynamic>> getKonversiSatuanDecimal(String fdKodeBarang,
    String satuanOrderAwal, double fdQty, String isHanger) async {
  late Database db;
  double quantity = 0;
  double fdQtyKomersil = 0;
  double fdQtyPromosi = 0;
  String satuanOrder = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    if (satuanOrderAwal != '0') {
      await db.transaction((txn) async {
        List<Map<String, dynamic>> results = [];
        if (isHanger == '0') {
          if (satuanOrderAwal == '2') {
            results = await txn.rawQuery(
                "select ? * fdKonvB_S as quantity FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang =  ? LIMIT 1 ",
                [fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              satuanOrder = '1';
              quantity = results[0]['quantity'];
              if (quantity % 1 != 0) {
                satuanOrder = '0';
                quantity = quantity * 12;
              }
            }
          }
          if (satuanOrderAwal == '1') {
            quantity = fdQty * 12;
            satuanOrder = '0';
          }
        } else {
          if (satuanOrderAwal == '2') {
            results = await txn.rawQuery(
                '''SELECT ? * fdKonvB_S  as quantity,fdKonvB_S,fdQtyKomersil, fdQtyPromosi
          FROM ${mdbconfig.tblHanger} a
          WHERE a.fdKodeBarang=?   ''', [fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              satuanOrder = '1'; // LUSIN HANGER
              quantity = results[0]['quantity'];
              fdQtyKomersil =
                  double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
              fdQtyPromosi =
                  double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
              if (quantity % 1 != 0) {
                results = await txn.rawQuery(
                    '''SELECT ? * (fdQtyKomersil + fdQtyPromosi) as quantity, ? * fdQtyKomersil as fdQtyKomersil, ? * fdQtyPromosi as fdQtyPromosi FROM ${mdbconfig.tblHanger} a WHERE a.fdKodeBarang=?   ''',
                    [quantity, quantity, quantity, fdKodeBarang]);
                if (results.isNotEmpty) {
                  quantity = results[0]['quantity'];
                  satuanOrder = '0';
                  fdQtyKomersil =
                      double.tryParse(results[0]['fdQtyKomersil'].toString()) ??
                          0;
                  fdQtyPromosi =
                      double.tryParse(results[0]['fdQtyPromosi'].toString()) ??
                          0;
                }
              }
            }
          }
          if (satuanOrderAwal == '1') {
            results = await txn.rawQuery(
                '''SELECT ? * (fdQtyKomersil + fdQtyPromosi) as quantity, ? * fdQtyKomersil as fdQtyKomersil, ? * fdQtyPromosi as fdQtyPromosi FROM ${mdbconfig.tblHanger} a WHERE a.fdKodeBarang=?   ''',
                [fdQty, fdQty, fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              quantity = results[0]['quantity'];
              satuanOrder = '0';
              fdQtyKomersil =
                  double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
              fdQtyPromosi =
                  double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
            }
          }
        }
      });
    } else {
      quantity = fdQty;
    }
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return {
    'quantity': quantity,
    'satuanOrder': satuanOrder,
    'fdQtyKomersil': fdQtyKomersil,
    'fdQtyPromosi': fdQtyPromosi,
  };
}

Future<Map<String, dynamic>> getKonversiSatuanPcs(String fdKodeBarang,
    String satuanOrderAwal, double fdQty, String isHanger) async {
  late Database db;
  double quantity = 0;
  double fdQtyKomersil = 0;
  double fdQtyPromosi = 0;
  String satuanOrder = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    if (satuanOrderAwal != '0') {
      await db.transaction((txn) async {
        List<Map<String, dynamic>> results = [];
        if (isHanger == '0') {
          if (satuanOrderAwal == '2') {
            results = await txn.rawQuery(
                "select ? * fdKonvB_S as quantity FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang =  ? LIMIT 1 ",
                [fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              satuanOrder = '1';
              quantity = results[0]['quantity'];
              if (quantity != 0) {
                satuanOrder = '0';
                quantity = quantity * 12;
              }
            }
          }
          if (satuanOrderAwal == '1') {
            quantity = fdQty * 12;
            satuanOrder = '0';
          }
        } else {
          if (satuanOrderAwal == '2') {
            results = await txn.rawQuery(
                '''SELECT ? * fdKonvB_S  as quantity,fdKonvB_S,fdQtyKomersil, fdQtyPromosi
          FROM ${mdbconfig.tblHanger} a
          WHERE a.fdKodeBarang=?   ''', [fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              satuanOrder = '1';
              quantity = results[0]['quantity'];
              fdQtyKomersil =
                  double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
              fdQtyPromosi =
                  double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
              if (quantity != 0) {
                results = await txn.rawQuery(
                    '''SELECT ? * (fdQtyKomersil + fdQtyPromosi) as quantity, ? * fdQtyKomersil as fdQtyKomersil, ? * fdQtyPromosi as fdQtyPromosi FROM ${mdbconfig.tblHanger} a WHERE a.fdKodeBarang=?   ''',
                    [quantity, quantity, quantity, fdKodeBarang]);
                if (results.isNotEmpty) {
                  quantity = results[0]['quantity'];
                  satuanOrder = '0';
                  fdQtyKomersil =
                      double.tryParse(results[0]['fdQtyKomersil'].toString()) ??
                          0;
                  fdQtyPromosi =
                      double.tryParse(results[0]['fdQtyPromosi'].toString()) ??
                          0;
                }
              }
            }
          }
          if (satuanOrderAwal == '1') {
            // kali komersil saja karena promosi di dapat dari barang extra
            results = await txn.rawQuery(
                '''SELECT ? * fdQtyKomersil as quantity, ? * fdQtyKomersil as fdQtyKomersil, ? * fdQtyPromosi as fdQtyPromosi FROM ${mdbconfig.tblHanger} a WHERE a.fdKodeBarang=?   ''',
                [fdQty, fdQty, fdQty, fdKodeBarang]);
            if (results.isNotEmpty) {
              quantity = results[0]['quantity'];
              satuanOrder = '0';
              fdQtyKomersil =
                  double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
              fdQtyPromosi =
                  double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
            }
          }
        }
      });
    } else {
      quantity = fdQty;
    }
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return {
    'quantity': quantity,
    'satuanOrder': satuanOrder,
    'fdQtyKomersil': fdQtyKomersil,
    'fdQtyPromosi': fdQtyPromosi,
  };
}

Future<List<Map<String, dynamic>>> getKonversiSatuanBarang(
    String fdKodeBarang) async {
  late Database db;
  List<Map<String, dynamic>> result = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> hanger = await txn.rawQuery(
          '''SELECT * FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?   ''',
          [fdKodeBarang]);
      if (hanger.isNotEmpty) {
        result = await txn.rawQuery(
            '''SELECT fdKonvB_S, fdKonvS_K FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?  ''',
            [fdKodeBarang]);
      } else {
        result = await txn.rawQuery(
            '''SELECT fdKonvB_S, fdKonvS_K FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang=?  ''',
            [fdKodeBarang]);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return result;
}

// Future<Map<String, dynamic>> getKonversiSatuanPcs(
//     String fdKodeBarang, String satuanOrderAwal, double fdQty, String isHanger,
//     {Transaction? txn}) async {
//   late Database db;
//   double quantity = 0;
//   double fdQtyKomersil = 0;
//   double fdQtyPromosi = 0;
//   String satuanOrder = '';

//   // Helper untuk jalankan query konversi
//   Future<void> doKonversi(Transaction activeTxn) async {
//     if (satuanOrderAwal != '0') {
//       List<Map<String, dynamic>> results = [];

//       if (isHanger == '0') {
//         // Barang biasa
//         if (satuanOrderAwal == '2') {
//           results = await activeTxn.rawQuery(
//               "SELECT ? * fdKonvB_S / 12 as quantity FROM ${mdbconfig.tblBarang} WHERE fdKodeBarang = ? LIMIT 1",
//               [fdQty, fdKodeBarang]);
//           if (results.isNotEmpty) {
//             satuanOrder = '1';
//             quantity = results[0]['quantity'];
//             satuanOrder = '0';
//             quantity = quantity * 12;
//           }
//         } else if (satuanOrderAwal == '1') {
//           quantity = fdQty * 12;
//           satuanOrder = '0';
//         }
//       } else {
//         // Barang hanger
//         if (satuanOrderAwal == '2') {
//           results = await activeTxn.rawQuery(
//               '''SELECT ? * fdKonvB_S as quantity, fdKonvB_S, fdQtyKomersil, fdQtyPromosi
//                  FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?''',
//               [fdQty, fdKodeBarang]);

//           if (results.isNotEmpty) {
//             satuanOrder = '1';
//             quantity = results[0]['quantity'];
//             fdQtyKomersil =
//                 double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
//             fdQtyPromosi =
//                 double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;

//             results = await activeTxn.rawQuery(
//                 '''SELECT ? * (fdQtyKomersil + fdQtyPromosi) as quantity,
//                           ? * fdQtyKomersil as fdQtyKomersil,
//                           ? * fdQtyPromosi as fdQtyPromosi
//                    FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?''',
//                 [quantity, quantity, quantity, fdKodeBarang]);

//             if (results.isNotEmpty) {
//               quantity = results[0]['quantity'];
//               satuanOrder = '0';
//               fdQtyKomersil =
//                   double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
//               fdQtyPromosi =
//                   double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
//             }
//           }
//         } else if (satuanOrderAwal == '1') {
//           results = await activeTxn.rawQuery(
//               '''SELECT ? * (fdQtyKomersil + fdQtyPromosi) as quantity,
//                         ? * fdQtyKomersil as fdQtyKomersil,
//                         ? * fdQtyPromosi as fdQtyPromosi
//                  FROM ${mdbconfig.tblHanger} WHERE fdKodeBarang=?''',
//               [fdQty, fdQty, fdQty, fdKodeBarang]);
//           if (results.isNotEmpty) {
//             quantity = results[0]['quantity'];
//             satuanOrder = '0';
//             fdQtyKomersil =
//                 double.tryParse(results[0]['fdQtyKomersil'].toString()) ?? 0;
//             fdQtyPromosi =
//                 double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
//           }
//         }
//       }
//     } else {
//       quantity = fdQty;
//     }
//   }

//   try {
//     if (txn != null) {
//       // Gunakan transaksi yang sudah ada
//       await doKonversi(txn);
//     } else {
//       // Buat transaksi baru
//       db = await openDatabase(mdbconfig.dbFullPath,
//           version: mdbconfig.dbVersion);
//       await db.transaction((newTxn) async {
//         await doKonversi(newTxn);
//       });
//     }
//   } catch (e) {
//     throw Exception(e);
//   } finally {
//     if (txn == null && db.isOpen) {
//       await db.close();
//     }
//   }

//   return {
//     'quantity': quantity,
//     'satuanOrder': satuanOrder,
//     'fdQtyKomersil': fdQtyKomersil,
//     'fdQtyPromosi': fdQtyPromosi,
//   };
// }

Future<double> getQtyPromosiHangerByFdKodeBarang(String fdKodeBarang) async {
  late Database db;
  double fdQtyPromosi = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT a.fdKodeBarang, a.fdQtyKomersil, a.fdQtyPromosi '
          'FROM ${mdbconfig.tblHanger} a '
          'WHERE fdKodeBarang = ? ',
          [fdKodeBarang]);

      if (results.isNotEmpty) {
        fdQtyPromosi =
            double.tryParse(results[0]['fdQtyPromosi'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdQtyPromosi;
}
