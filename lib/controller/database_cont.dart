import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as cpath;
import '../controller/salesman_cont.dart' as csf;
import '../controller/langganangroup_cont.dart' as cgrouplgn;
import '../controller/langganan_cont.dart' as clgn;
import '../controller/barang_cont.dart' as cbrg;
import '../controller/noo_cont.dart' as cnoo;
import '../controller/tipeharga_cont.dart' as ctipeharga;
import '../controller/tipeoutlet_cont.dart' as ctipeoutlet;
import '../controller/branding_cont.dart' as cbr;
import '../controller/promo_cont.dart' as cpro;
import '../controller/menu_cont.dart' as cmenu;
import '../controller/log_cont.dart' as clog;
import '../controller/provinsi_cont.dart' as cprov;
import '../controller/kabupaten_cont.dart' as ckab;
import '../controller/kecamatan_cont.dart' as ckec;
import '../controller/kelurahan_cont.dart' as ckel;
import '../controller/tipedetail_cont.dart' as cdetail;
import '../controller/piutang_cont.dart' as cpiu;
import '../controller/collection_cont.dart' as ccoll;
import '../controller/limitkredit_cont.dart' as clk;
import '../controller/order_cont.dart' as cord;
import '../controller/diskon_cont.dart' as cdisc;
import '../controller/stock_cont.dart' as cstoc;
import '../controller/rute_cont.dart' as crute;
import '../models/database.dart' as mdbconfig;
import '../models/salesman.dart' as msf;
import '../models/globalparam.dart' as param;

Future<void> createDB() async {
  if (mdbconfig.dbFullPath.isEmpty) {
    String dbPath = await getDatabasesPath();
    mdbconfig.dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  }
}

Future<void> createDBLog() async {
  if (mdbconfig.logFullPath.isEmpty) {
    String dbPath = await getDatabasesPath();
    mdbconfig.logFullPath = cpath.join(dbPath, mdbconfig.dbName2);
  }
}

Future<bool> initDB(msf.Salesman user) async {
  bool isLoginNew = false;
  String dbPath = await getDatabasesPath();
  mdbconfig.dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  late Database db;

  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);
      int rowCount = await csf.checkIsSFExist(db, user.fdKodeSF);

      if (rowCount != 0) {
        isLoginNew = false;
        print('data SF sama dengan login');
        await csf.insertSFLogin(db, user);
        await clog.insertSFLogin(
            user.fdKodeSF,
            user.fdNamaSF,
            user.fdKodeDepo,
            user.fdNamaDepo,
            user.fdTipeSF,
            user.fdToken,
            user.fdAkses,
            user.message,
            user.fdLoginDate);
      } else {
        isLoginNew = true;
        print('SF lain login');
        //delete DB dan buat DB baru jika SF login dengan data SF existing berbeda
        await deleteDatabase(mdbconfig.dbFullPath);
        await deleteFiles();

        db = await openDatabase(mdbconfig.dbFullPath,
            version: mdbconfig.dbVersion, onCreate: (db, version) {
          createTable(db, version);
          //Insert data SF login sebagai acuan data yang akan ditarik dari server
          csf.insertSFLogin(db, user);
        });
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  } else {
    try {
      isLoginNew = true;
      print('open Database buat baru');
      await deleteFiles();

      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion, onCreate: (db, version) {
        createTable(db, version);
        //Insert data SF login sebagai acuan data yang akan ditarik dari server
        csf.insertSFLogin(db, user);
        clog.insertSFLogin(
            user.fdKodeSF,
            user.fdNamaSF,
            user.fdKodeDepo,
            user.fdNamaDepo,
            user.fdTipeSF,
            user.fdToken,
            user.fdAkses,
            user.message,
            user.fdLoginDate);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }

  return isLoginNew;
}

Future<bool> initDB2() async {
  bool isLoginNew = true;
  String dbPath = await getDatabasesPath();
  mdbconfig.logFullPath = cpath.join(dbPath, mdbconfig.dbName2);

  if (await databaseExists(mdbconfig.logFullPath) == false) {
    await createTableLog();
  }

  return isLoginNew;
}

void createTable(Database db, int version) async {
  cmenu.createTblMenu(db);
  cmenu.createTblLogApps(db);
  csf.createTblSFnSFActivity(db);
  clgn.createTblLangganan(db);
  cgrouplgn.createTblGroupLangganan(db);
  clgn.createTblLanggananActivity(db);
  clgn.createTblReason(db);
  cbrg.createTblBarang(db);
  cbrg.createTblGroupBarang(db);
  cbr.createTblBranding(db);
  cpro.createTblPromo(db);
  cpro.createTblPromoBarang(db);
  cpro.createTblPromoActivity(db);
  cnoo.createTblNOO(db);
  ctipeharga.createTblTipeHarga(db);
  ctipeoutlet.createTblTipeOutlet(db);
  cpro.createTblJenisPromo(db);
  cpro.createTblPromoGroupLangganan(db);
  cpro.createTblPromoLangganan(db);
  clog.createTblParameter(db);
  cprov.createTblPropinsi(db);
  ckab.createTblKabupaten(db);
  ckec.createTblKecamatan(db);
  ckel.createTblKelurahan(db);
  cdetail.createtblTipeDetail(db);
  cpiu.createtblPiuDagang(db);
  cord.createtblOrder(db);
  cord.createtblOrderItem(db);
  cord.createtblOrderItemKonversi(db);
  cbrg.createTblHargaJualBarang(db);
  clgn.createTblLanggananAlamat(db);
  cbrg.createTblBarangExtra(db);
  cdisc.createTblDiskon(db);
  cdisc.createTblDiskonDetail(db);
  cbrg.createTblHanger(db);
  cbrg.createTblHangerDetail(db);
  cbrg.createTblBarangSales(db);
  cstoc.createTblStock(db);
  cstoc.createTblStockItem(db);
  cstoc.createTblStockItemSum(db);
  clk.createtblLimitKredit(db);
  cpiu.createtblFileBuktiTransfer(db);
  csf.createTblGudangSF(db);
  crute.createTblRencanaRute(db);
  crute.createTblRencanaRuteLangganan(db);
  crute.createTblRencanaRuteFaktur(db);
  crute.createTblTempRencanaRuteLangganan(db);
  crute.createTblSyncRencanaRute(db);
  crute.createTblSyncRencanaRuteLangganan(db);
  ccoll.createtblCollection(db);
  cpiu.createtblPayment(db);
  cpiu.createtblFaktur(db);
  cpiu.createtblFakturItem(db);
  cpiu.createtblSuratJalan(db);
  cpiu.createtblSuratJalanItem(db);
  cpiu.createtblSuratJalanItemDetail(db);
  cbrg.createTbllBarangTOP(db);
  clgn.createTbllLanggananTOP(db);
  clgn.createTblBank(db);
}

Future<void> createTableLog() async {
  await clog.createTblGpsLog();
  await csf.alterTblSF();
}

Future<void> deleteFiles() async {
  String dirCameraPath = '${param.appDir}/${param.imgPath}';
  String dirPlanogramImagePath = '${param.appDir}/${param.imgPathPlano}';

  var dir = Directory(dirCameraPath);
  var dirPlano = Directory(dirPlanogramImagePath);

  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
}

Future<void> deleteTransactionAndFiles() async {
  late Database db;
  late Database dbLog;

  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      //delete tabel transaksi
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);

      await db.transaction((txn) async {
        Batch batchTx = txn.batch();

        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSFActivity}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblLanggananActivity}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblNOO}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblNOOfoto}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblLangganan}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblMenu}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPiuDagang}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblOrder}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblOrderItem}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblFaktur}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblFakturItem}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSuratJalan}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSuratJalanItem}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSuratJalanItemDetail}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblPayment}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblCollection}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblFileBuktiTransfer}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblLimitKredit}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRute}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRuteLangganan}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblRencanaRuteFaktur}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblTempRencanaRute}');
        batchTx
            .rawDelete('DELETE FROM ${mdbconfig.tblTempRencanaRuteLangganan}');
        batchTx.rawDelete('DELETE FROM ${mdbconfig.tblSyncRencanaRute}');
        batchTx
            .rawDelete('DELETE FROM ${mdbconfig.tblSyncRencanaRuteLangganan}');
        // STOCK TIDAK DI DELETE, DELETE MELALUI UNLOADING
        // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblStock}');
        // batchTx.rawDelete('DELETE FROM ${mdbconfig.tblStockItem}');

        batchTx.commit();
      });

      //delete all files
      await deleteFiles();
    } catch (e) {
      rethrow;
    } finally {
      db.isOpen ? await db.close() : null;
    }

    try {
      dbLog = await openDatabase(mdbconfig.logFullPath,
          version: mdbconfig.logVersion);

      await dbLog.transaction((txn) async {
        txn.rawDelete('DELETE FROM ${mdbconfig.tblGpsLog}');
      });
    } catch (e) {
      rethrow;
    } finally {
      dbLog.isOpen ? await dbLog.close() : null;
    }
  }
}

Future<void> initialData() async {
  if (await databaseExists(mdbconfig.dbFullPath)) {
    //Hapus DB dan DB Log
    await deleteDatabase(mdbconfig.dbFullPath);
    await deleteDatabase(mdbconfig.logFullPath);
  }

  //Hapus semua file di folder dan sub folder MD
  await deleteFiles();
}

Future<void> logOut() async {
  late Database db;
  late Database db2;
  if (await databaseExists(mdbconfig.dbFullPath)) {
    try {
      db = await openDatabase(mdbconfig.dbFullPath,
          version: mdbconfig.dbVersion);

      await db.transaction((txn) async {
        csf.logOut(txn);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      db.isOpen ? await db.close() : null;
    }
  }

  if (await databaseExists(mdbconfig.logFullPath)) {
    try {
      db2 = await openDatabase(mdbconfig.logFullPath,
          version: mdbconfig.logVersion);
    } catch (e) {
      throw Exception(e);
    } finally {
      db2.isOpen ? await db2.close() : null;
    }
  }
}

Future<void> alterTable(Database db, int version) async {
  await clgn.alterTblLangganan(db);
  await clgn.alterTblReason(db);
  await clog.alterTblParameter(db);
  await cnoo.alterTblNoo(db);
  await cord.alterTblOrder(db);
  await cord.alterTblOrderItem(db);
  await cpiu.createtblPiuDagang(db);
  await cpiu.createtblPayment(db);
  await cpiu.createtblFileBuktiTransfer(db);
  await clk.createtblLimitKredit(db);
  await cbrg.createTblBarangSales(db);

  await cord.createtblOrder(db);
  await cord.createtblOrderItem(db);
  await cord.createtblOrderItemKonversi(db);
  await cbrg.createTblHargaJualBarang(db);
  await clgn.createTblLanggananAlamat(db);
  await cbrg.createTblHanger(db);
  await cbrg.createTblHangerDetail(db);
  await cstoc.createTblStock(db);
  await cstoc.createTblStockItem(db);
  await cstoc.createTblStockItemSum(db);
  await csf.createTblGudangSF(db);
  await crute.createTblRencanaRute(db);
  await crute.createTblRencanaRuteLangganan(db);
  await crute.createTblRencanaRuteFaktur(db);
  await crute.createTblTempRencanaRuteLangganan(db);
  await crute.createTblSyncRencanaRute(db);
  await crute.createTblSyncRencanaRuteLangganan(db);
  await ccoll.createtblCollection(db);
  await cpiu.createtblFaktur(db);
  await cpiu.createtblFakturItem(db);
  await cpiu.createtblSuratJalan(db);
  await cpiu.createtblSuratJalanItem(db);
  await cpiu.createtblSuratJalanItemDetail(db);
  await cbrg.createTbllBarangTOP(db);
  await clgn.createTbllLanggananTOP(db);
  await clgn.createTblBank(db);
}

Future<void> onUpdateAlter() async {
  String dbPath = await getDatabasesPath();
  mdbconfig.dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  late Database db;
  db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
  await alterTable(db, mdbconfig.dbVersion);
}

Future<bool> isColumnExistTblSF(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblSF})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTblLangganan(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblLangganan})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTblReason(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblReason})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTblParameter(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblParameter})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTblNoo(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblNOO})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTableName(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( $tableName)');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<bool> isColumnExistTblOrderItem(
    Database db, String tableName, String columnName) async {
  List<Map<String, dynamic>> columns =
      await db.rawQuery('PRAGMA table_info( ${mdbconfig.tblOrderItem})');
  for (Map<String, dynamic> column in columns) {
    if (column['name'] == columnName) {
      return true;
    }
  }
  return false;
}

Future<String> createZipFile(
    String sourceDirPath, List<File> files, String zipFilePath) async {
  //Zip files
  Directory dir = Directory(sourceDirPath);
  File zips = File(zipFilePath);

  try {
    if (zips.existsSync()) {
      zips.delete(recursive: true);
    }

    await ZipFile.createFromFiles(sourceDir: dir, files: files, zipFile: zips);
  } catch (e) {
    print('error: $e');
    return e.toString();
  }

  return '';
}

Future<String> createZipDirectory(String dirPath, String zipFilePath) async {
  //Zip files
  Directory dir = Directory(dirPath);
  File zips = File(zipFilePath);

  try {
    // Buat folder target untuk ZIP jika belum ada
    Directory zipParentDir = zips.parent;
    if (!zipParentDir.existsSync()) {
      zipParentDir.createSync(recursive: true);
    }

    if (zips.existsSync()) {
      // zips.delete(recursive: true);
      zips.deleteSync();
    }

    await ZipFile.createFromDirectory(sourceDir: dir, zipFile: zips);
  } catch (e) {
    print('error: $e');
    return e.toString();
  }

  return '';
}

Future<Map<String, dynamic>> createZipMDAllZipFiles(
    String fdKodeSF, String sourceDir) async {
  Map<String, dynamic> mapResult = {'fdData': 0, 'fdMessage': ''};

  //Zip Folder MD
  String zipFilePath =
      '${param.appDir}/${param.imgPath}/$fdKodeSF.zip'; //path di luar folder MD

  if (File(zipFilePath).existsSync()) {
    await File(zipFilePath).delete();
  }

  Directory dir = Directory(sourceDir);

  if (await dir.exists()) {
    var listFile = dir
        .listSync(recursive: false)
        .where((element) => cpath.extension(element.path) == '.zip')
        .toList();
    List<File> files = [];

    for (var element in listFile) {
      files.add(File(element.path));
    }

    if (listFile.isNotEmpty) {
      String errorMsg = await createZipFile(sourceDir, files, zipFilePath);

      if (errorMsg.isEmpty) {
        mapResult['fdData'] = 1;
        mapResult['fdMessage'] = zipFilePath;

        return mapResult;
      } else {
        mapResult['fdData'] = 0;
        mapResult['fdMessage'] = 'Error compress file: $errorMsg';

        return mapResult;
      }
    } else {
      mapResult['fdData'] = 0;
      mapResult['fdMessage'] =
          'Tidak ditemukan file foto yang sudah di-compress';

      return mapResult;
    }
  } else {
    mapResult['fdData'] = 0;
    mapResult['fdMessage'] = 'Path direktori MD tidak ditemukan';

    return mapResult;
  }
}

Future<Map<String, dynamic>> backupZipMDAllZipFiles(
    String fdKodeSF, String sourceDir) async {
  Map<String, dynamic> mapResult = {'fdData': 0, 'fdMessage': ''};

  //Zip Folder MD
  String zipFilePath =
      '${param.appDir}/BACKUP/$fdKodeSF.zip'; //path di luar folder MD

  if (File(zipFilePath).existsSync()) {
    await File(zipFilePath).delete();
  }

  Directory dir = Directory(sourceDir);

  if (await dir.exists()) {
    var listFile = dir
        .listSync(recursive: false)
        .where((element) => cpath.extension(element.path) == '.zip')
        .toList();
    List<File> files = [];

    for (var element in listFile) {
      files.add(File(element.path));
    }

    if (listFile.isNotEmpty) {
      String errorMsg = await createZipFile(sourceDir, files, zipFilePath);

      if (errorMsg.isEmpty) {
        mapResult['fdData'] = 1;
        mapResult['fdMessage'] = zipFilePath;

        return mapResult;
      } else {
        mapResult['fdData'] = 0;
        mapResult['fdMessage'] = 'Error compress file: $errorMsg';

        return mapResult;
      }
    } else {
      mapResult['fdData'] = 0;
      mapResult['fdMessage'] =
          'Tidak ditemukan file foto yang sudah di-compress';

      return mapResult;
    }
  } else {
    mapResult['fdData'] = 0;
    mapResult['fdMessage'] = 'Path direktori MD tidak ditemukan';

    return mapResult;
  }
}
