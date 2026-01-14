import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../models/database.dart' as mdbconfig;
import '../models/noo.dart' as mnoo;
import '../models/salesman.dart' as msf;
import '../controller/api_cont.dart' as capi;
import '../controller/database_cont.dart' as cdb;
import '../models/globalparam.dart' as param;
import 'package:path/path.dart' as cpath;
import 'dart:io';

void createTblNOO(Database db) async {
  await db.transaction((txn) async {
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblNOO} (fdKodeNoo varchar(50), 
          fdDepo varchar(4), 
          fdKodeSF varchar(10), 
          fdBadanUsaha varchar(10), 
          fdNamaToko varchar(100),
          fdOwner varchar(100),
          fdContactPerson varchar(100), 
          fdPhone varchar(25),
          fdMobilePhone varchar(25),
          fdAlamat varchar(300), 
          fdKelurahan varchar(25), 
          fdKodePos varchar(25),
          fdLA varchar(25),
          fdLG varchar(25),
          fdPatokan varchar(350),
          fdTipeOutlet varchar(25),
          fdNPWP varchar(25), 
          fdNamaNPWP varchar(100), 
          fdAlamatNPWP varchar(300),
          fdNIK varchar(25),
          fdKelasOutlet varchar(25),
          fdTokoLuar1 varchar(250),
          fdNpwpImg varchar(250),
          fdTokoDalam1 varchar(250),
          fdKtpImg varchar(250),
          fdKodeRute varchar(25),
          fdKodeLangganan varchar(25),
          fdStatusSent INT,
          fdStatusAktif int, 
          fdLastUpdate varchar(25) )''');
    await txn.execute(
        '''CREATE TABLE IF NOT EXISTS ${mdbconfig.tblNOOfoto} (fdKodeNoo varchar(50), 
          fdDepo varchar(4), 
          fdKodeSF varchar(10), 
          fdJenis varchar(2),
          fdNamaJenis varchar(30),
          fdPath varchar(250),
          fdFileName varchar(250),
          fdStatusSent INT,
          fdLastUpdate varchar(25) )''');
  });
}

Future<void> alterTblNoo(Database db) async {
  bool columnExists =
      await cdb.isColumnExistTblNoo(db, mdbconfig.tblNOO, 'fdLimitKredit');

  await db.transaction((txn) async {
    if (!columnExists) {
      await txn.execute(
          '''ALTER TABLE ${mdbconfig.tblNOO} ADD COLUMN fdLimitKredit REAL ''');
    }
  });
}

Future<int> checkNOO_isExist(fdKodeNoo) async {
  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  int rowCount = 0;

  await db.transaction((txn) async {
    await txn.rawQuery(
        'SELECT COUNT(0) rowNo FROM ${mdbconfig.tblNOO} WHERE fdKodeNoo = ? and fdStatusSent=?',
        [fdKodeNoo, '1']).then((value) async {
      rowCount = value[0]['rowNo'] as int;
      print('count ${value[0]['rowNo']}');
    });
  });

  return rowCount;
}

Future<int> editNOO(
    String? fdKodeNoo,
    msf.Salesman user,
    String startDayDate,
    String? fdBadanPerusahaan,
    String? fdNamaToko,
    String? owner,
    String? contactPerson,
    String? fdPhone,
    String? fdMobilePhone,
    String? fdAlamat,
    String? fdKelurahan,
    String? fdKodePos,
    String? fdLA,
    String? fdLG,
    String? fdPatokan,
    String? fdTipeOutlet,
    String? fdLimitKredit,
    String? fdNPWP,
    String? fdNpwpNama,
    String? fdNpwpAlamat,
    String? fdKTP,
    String? kodeKelasOutlet,
    String? fdTokoLuar1,
    String? fdNpwpImg,
    String? fdTokoDalam1,
    String? fdKtpImg,
    String? fdNibImg,
    String? fdSkpImg,
    String? fdStampleImg) async {
  int rowResult = 0;
  String fdLastproses = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  int resTL1 = 0;
  int resTL2 = 0;
  int resTD1 = 0;
  int resTD2 = 0;
  int resNIB = 0;
  int resSKP = 0;
  int resStample = 0;

  db = await openDatabase(dbFullPath, version: 1);
  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate('''UPDATE ${mdbconfig.tblNOO} set 
            fdBadanUsaha =?,
            fdNamaToko =?,
            fdOwner =?,
            fdContactPerson =?,
            fdPhone =?,
            fdMobilePhone =?,
            fdAlamat =?,
            fdKelurahan =?,
            fdKodePos =?,
            fdLA =?,
            fdLG =?,
            fdPatokan =?,
            fdTipeOutlet =?,
            fdLimitKredit =?,
            fdNPWP =?,
            fdNamaNPWP =?,
            fdAlamatNPWP =?,
            fdNIK =?,
            fdKelasOutlet =?,
      fdLastUpdate =? WHERE fdKodeNoo =? ''', [
      fdBadanPerusahaan,
      fdNamaToko,
      owner,
      contactPerson,
      fdPhone,
      fdMobilePhone,
      fdAlamat,
      fdKelurahan,
      fdKodePos,
      fdLA,
      fdLG,
      fdPatokan,
      fdTipeOutlet,
      fdLimitKredit?.replaceAll(',', '').replaceAll('.', ''),
      fdNPWP,
      fdNpwpNama,
      fdNpwpAlamat,
      fdKTP,
      kodeKelasOutlet,
      fdLastproses,
      fdKodeNoo
    ]);
  });

  if (rowResult > 0) {
    if (fdTokoLuar1 != '') {
      resTL1 = await insertNOOfoto(fdKodeNoo, 'TL', 'TOKO LUAR', fdTokoLuar1,
          fdTokoLuar1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resTL1 = await deleteNOOfoto(fdKodeNoo, 'TL', 'TOKO LUAR', fdTokoLuar1,
          fdTokoLuar1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdNpwpImg != '') {
      resTL2 = await insertNOOfoto(fdKodeNoo, 'NPWP', 'NPWP', fdNpwpImg,
          fdNpwpImg, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resTL2 = await deleteNOOfoto(fdKodeNoo, 'NPWP', 'NPWP', fdNpwpImg,
          fdNpwpImg, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdTokoDalam1 != '') {
      resTD1 = await insertNOOfoto(fdKodeNoo, 'TD', 'TOKO DALAM', fdTokoDalam1,
          fdTokoDalam1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resTD1 = await deleteNOOfoto(fdKodeNoo, 'TD', 'TOKO DALAM', fdTokoDalam1,
          fdTokoDalam1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdKtpImg != '') {
      resTD2 = await insertNOOfoto(fdKodeNoo, 'KTP', 'KTP', fdKtpImg, fdKtpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resTD2 = await deleteNOOfoto(fdKodeNoo, 'KTP', 'KTP', fdKtpImg, fdKtpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdNibImg != '') {
      resNIB = await insertNOOfoto(fdKodeNoo, 'NIB', 'NIB', fdNibImg, fdNibImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resNIB = await deleteNOOfoto(fdKodeNoo, 'NIB', 'NIB', fdNibImg, fdNibImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdSkpImg != '') {
      resSKP = await insertNOOfoto(fdKodeNoo, 'SKP', 'SKP', fdSkpImg, fdSkpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    } else {
      resSKP = await deleteNOOfoto(fdKodeNoo, 'SKP', 'SKP', fdSkpImg, fdSkpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdStampleImg != '') {
      resStample = await insertNOOfoto(
          fdKodeNoo,
          'SPMN',
          'STAMPLE',
          fdStampleImg,
          fdStampleImg,
          user.fdToken,
          user.fdKodeDepo,
          user.fdKodeSF);
    } else {
      resStample = await deleteNOOfoto(
          fdKodeNoo,
          'SPMN',
          'STAMPLE',
          fdStampleImg,
          fdStampleImg,
          user.fdToken,
          user.fdKodeDepo,
          user.fdKodeSF);
    }

    //SEND FILE FOTO TO SERVER
    Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};
    String dirCameraPath = '${param.appDir}/${param.imgPath}/${user.fdKodeSF}';
    String dirNOO = '$dirCameraPath/NOO';
    var dir = Directory(dirNOO);
    var webPath = param.pathImgServer(
        user.fdKodeDepo, user.fdKodeSF, startDayDate, 'NOO/');

    if (await dir.exists()) {
      try {
        String zipPath = '$dirCameraPath/NOO.zip'; //path di luar folder NOO
        String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

        if (errorMsg.isEmpty) {
          int responseCode =
              await capi.sendImagetoServer(zipPath, user, 'NOO', startDayDate);

          if (responseCode == 401) {
            mapResult['fdData'] = '401';
            mapResult['fdMessage'] = '';

            return 5;
          } else if (responseCode == 0) {
            mapResult['fdData'] = '0';
            mapResult['fdMessage'] =
                'Terjadi error kirim foto NOO, mohon coba kembali';

            return 5;
          } else if (responseCode == 400) {
            mapResult['fdData'] = '0';
            mapResult['fdMessage'] = 'Terjadi timeout, mohon coba kembali';

            return 5;
          }
        } else {
          mapResult['fdData'] = '0';
          mapResult['fdMessage'] = 'Error compress file: $errorMsg';

          return 5;
        }
      } catch (e) {
        mapResult['fdData'] = '0';
        mapResult['fdMessage'] = 'Terjadi error: $e, mohon coba kembali';

        return 5;
      }
    }

    //SEND DATA FOTO TO SERVER
    try {
      List<mnoo.FotoNOO> listNooFoto =
          await getAllFotoNoobyfdKodeNoo(fdKodeNoo);
      Map<String, dynamic> result = await capi.sendFotoNooServer(
          user,
          fdKodeNoo!,
          '0',
          param.dateTimeFormatDB.format(DateTime.now()),
          listNooFoto,
          webPath);

      mapResult['fdData'] = result['fdData'];
      mapResult['fdMessage'] = result['fdMessage'];
      if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
        //SEND DATA TO SERVER
        try {
          List<mnoo.NOO> listNoo = await getAllNOObyfdKodeNoo(fdKodeNoo);

          Map<String, dynamic> result2 = await capi.setNOOtoServer(user, '0',
              param.dateTimeFormatDB.format(DateTime.now()), listNoo, webPath);

          mapResult['fdData'] = result2['fdData'];
          mapResult['fdMessage'] = result2['fdMessage'];
          if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
            await updateStatusSentNOO(fdKodeNoo!);
            return 99;
          } else {
            return 7;
          }
        } catch (e) {
          if (e == '500') {
            return 500;
          } else {
            return 0;
          }
        }
      } else {
        return 6;
      }
    } catch (e) {
      if (e == '500') {
        return 500;
      } else {
        return 0;
      }
    }
  } else {
    return 0;
  }
}

Future<String> generateNo() async {
  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  int newFdKey = 0;
  try {
    db = await openDatabase(dbFullPath, version: 1);
    await db.transaction((txn) async {
      var cnt = await txn
          .rawQuery("SELECT count(*) as fdKey FROM ${mdbconfig.tblNOO} ");
      newFdKey = int.parse(cnt[0]['fdKey'].toString()) + 1;
    });
    String fdKodeNoo = newFdKey.toString().padLeft(4, '0');
    return fdKodeNoo;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<int> insertNOO(
    String? noEntry,
    String? fileName,
    msf.Salesman user,
    String startDayDate,
    String? fdBadanPerusahaan,
    String? fdNamaToko,
    String? owner,
    String? contactPerson,
    String? fdPhone,
    String? fdMobilePhone,
    String? fdAlamat,
    String? fdKelurahan,
    String? fdKodePos,
    String? fdLA,
    String? fdLG,
    String? fdPatokan,
    String? fdTipeOutlet,
    String? fdLimitKredit,
    String? fdNPWP,
    String? fdNpwpNama,
    String? fdNpwpAlamat,
    String? fdKTP,
    String? kodeKelasOutlet,
    String? fdTokoLuar1,
    String? fdNpwpImg,
    String? fdTokoDalam1,
    String? fdKtpImg,
    String? fdNibImg,
    String? fdSkpImg,
    String? fdStampleImg,
    String? fdKodeLangganan,
    int fdStatusAktif) async {
  int rowResult = 0;
  int resTL1 = 0;
  int resTL2 = 0;
  int resTD1 = 0;
  int resTD2 = 0;
  int resNib = 0;
  int resSkp = 0;
  int resStample = 0;

  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  String fdStatusSent = '0';
  String fdLastproses =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  db = await openDatabase(dbFullPath, version: 1);
  await db.transaction((txn) async {
    var results = await txn.rawQuery(
        'SELECT * '
        'FROM ${mdbconfig.tblNOOfoto} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=?   ',
        [noEntry, user.fdKodeDepo, user.fdKodeSF]);

    if (results.isEmpty) {
      rowResult =
          await txn.rawInsert('''INSERT INTO ${mdbconfig.tblNOO}(fdKodeNoo,
            fdDepo, 
            fdKodeSF,  
            fdBadanUsaha,
            fdNamaToko,
            fdOwner,
            fdContactPerson,
            fdPhone,
            fdMobilePhone,
            fdAlamat,
            fdKelurahan,
            fdKodePos,
            fdLA,
            fdLG,
            fdPatokan,
            fdTipeOutlet,
            fdLimitKredit,
            fdNPWP,
            fdNamaNPWP,
            fdAlamatNPWP,
            fdNIK,
            fdKelasOutlet,
            fdTokoLuar1,
            fdNpwpImg,
            fdTokoDalam1,
            fdKtpImg, 
            fdStatusSent,
            fdLastUpdate, 
            fdKodeLangganan,
            fdStatusAktif ) VALUES(?,
            ?, 
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,  
            ?,
            ?,  
            ?  )''', [
        noEntry,
        user.fdKodeDepo,
        user.fdKodeSF,
        fdBadanPerusahaan,
        fdNamaToko,
        owner,
        contactPerson,
        fdPhone,
        fdMobilePhone,
        fdAlamat,
        fdKelurahan,
        fdKodePos,
        fdLA,
        fdLG,
        fdPatokan,
        fdTipeOutlet,
        fdLimitKredit!.replaceAll(',', '').replaceAll('.', ''),
        fdNPWP,
        fdNpwpNama,
        fdNpwpAlamat,
        fdKTP,
        kodeKelasOutlet,
        fdTokoLuar1,
        fdNpwpImg,
        fdTokoDalam1,
        fdKtpImg,
        fdStatusSent,
        fdLastproses,
        fdKodeLangganan,
        1
      ]);
    } else {
      rowResult = 1;
    }
  });
  if (rowResult > 0) {
    if (fdTokoLuar1 != '') {
      resTL1 = await insertNOOfoto(noEntry, 'TL', 'TOKO LUAR', fdTokoLuar1,
          fdTokoLuar1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdNpwpImg != '') {
      resTL2 = await insertNOOfoto(noEntry, 'NPWP', 'NPWP', fdNpwpImg,
          fdNpwpImg, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdTokoDalam1 != '') {
      resTD1 = await insertNOOfoto(noEntry, 'TD', 'TOKO DALAM', fdTokoDalam1,
          fdTokoDalam1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdKtpImg != '') {
      resTD2 = await insertNOOfoto(noEntry, 'KTP', 'KTP', fdKtpImg, fdKtpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdNibImg != '') {
      resNib = await insertNOOfoto(noEntry, 'NIB', 'NIB', fdNibImg, fdNibImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdSkpImg != '') {
      resSkp = await insertNOOfoto(noEntry, 'SKP', 'SKP', fdSkpImg, fdSkpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdStampleImg != '') {
      resStample = await insertNOOfoto(noEntry, 'SPMN', 'STAMPLE', fdStampleImg,
          fdStampleImg, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }

    if (fdTokoLuar1 != '' && resTL1 == 0) {
      return 1;
    } else if (fdNpwpImg != '' && resTL2 == 0) {
      return 2;
    } else if (fdTokoDalam1 != '' && resTD1 == 0) {
      return 3;
    } else if (fdKtpImg != '' && resTD2 == 0) {
      return 4;
    } else if (fdNibImg != '' && resNib == 0) {
      return 11;
    } else if (fdSkpImg != '' && resSkp == 0) {
      return 12;
    } else if (fdStampleImg != '' && resStample == 0) {
      return 13;
    } else {
      //SEND FILE FOTO TO SERVER
      Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};
      String dirCameraPath =
          '${param.appDir}/${param.imgPath}/${user.fdKodeSF}';
      String dirNOO = '$dirCameraPath/NOO';
      var dir = Directory(dirNOO);
      var webPath = param.pathImgServer(
          user.fdKodeDepo, user.fdKodeSF, startDayDate, 'NOO/');

      if (await dir.exists()) {
        try {
          String zipPath = '$dirCameraPath/NOO.zip'; //path di luar folder NOO
          String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

          if (errorMsg.isEmpty) {
            int responseCode = await capi.sendImagetoServer(
                zipPath, user, 'NOO', startDayDate);

            if (responseCode == 401) {
              mapResult['fdData'] = '401';
              mapResult['fdMessage'] = '';

              return 5;
            } else if (responseCode == 0) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] =
                  'Terjadi error kirim foto NOO, mohon coba kembali';

              return 5;
            } else if (responseCode == 400) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] = 'Terjadi timeout, mohon coba kembali';

              return 5;
            }
          } else {
            mapResult['fdData'] = '0';
            mapResult['fdMessage'] = 'Error compress file: $errorMsg';

            return 5;
          }
        } catch (e) {
          mapResult['fdData'] = '0';
          mapResult['fdMessage'] = 'Terjadi error: $e, mohon coba kembali';

          return 5;
        }
      }

      //SEND DATA FOTO TO SERVER
      try {
        List<mnoo.FotoNOO> listNooFoto =
            await getAllFotoNoobyfdKodeNoo(noEntry);

        Map<String, dynamic> result = await capi.sendFotoNooServer(
            user,
            '0',
            '0',
            param.dateTimeFormatDB.format(DateTime.now()),
            listNooFoto,
            webPath);

        mapResult['fdData'] = result['fdData'];
        mapResult['fdMessage'] = result['fdMessage'];
        if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
          //SEND DATA TO SERVER
          try {
            List<mnoo.NOO> listNoo = await getAllNOObyfdKodeNoo(noEntry);

            Map<String, dynamic> result2 = await capi.setNOOtoServer(
                user,
                '0',
                param.dateTimeFormatDB.format(DateTime.now()),
                listNoo,
                webPath);

            mapResult['fdData'] = result2['fdData'];
            mapResult['fdMessage'] = result2['fdMessage'];
            if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
              await updateStatusSentNOO(noEntry!);
              return 99;
            } else if (mapResult['fdData'] == '401') {
              return 401;
            } else {
              return 7;
            }
          } catch (e) {
            if (e == '500') {
              return 500;
            } else {
              return 0;
            }
          }
        } else {
          return 6;
        }
      } catch (e) {
        if (e == '500') {
          return 500;
        } else {
          return 0;
        }
      }
    }
  } else {
    return 0;
  }
}

Future<int> insertNOOfoto(
    String? fdKodeNOO,
    String? fdJenis,
    String? fdNamaJenis,
    String? fdPath,
    String? fdFileName,
    String? token,
    String? parDepo,
    String? parKodeSF) async {
  int rowResult = 0;

  late Database db;
  String? dbPath = await getDatabasesPath();
  String? dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  String fdStatusSent = '0';
  String fdLastproses =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  try {
    db = await openDatabase(dbFullPath, version: 1);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOOfoto} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=? AND fdJenis=? AND fdNamaJenis=? ',
          [fdKodeNOO, parDepo, parKodeSF, fdJenis, fdNamaJenis]);

      if (results.isEmpty) {
        String fileName = cpath.basename(fdPath!);
        rowResult = await txn
            .rawInsert('''INSERT INTO ${mdbconfig.tblNOOfoto}(fdKodeNoo, 
        fdDepo, 
        fdKodeSF, 
        fdJenis,
        fdNamaJenis,
        fdPath,
        fdFileName,
        fdStatusSent,
        fdLastUpdate ) VALUES(?,
        ?,
        ?,
        ?,
        ?, 
        ?,
        ?,
        ?,
        ? )''', [
          fdKodeNOO,
          parDepo,
          parKodeSF,
          fdJenis,
          fdNamaJenis,
          fdPath,
          fileName,
          fdStatusSent,
          fdLastproses
        ]);
      } else {
        rowResult = 1;
      }
    });
  } catch (e) {
    throw (e.toString());
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowResult;
}

Future<int> updateNOO(
    Database db,
    String? fdKodeNoo,
    String? fdNamaToko,
    String? fdAlamat,
    String? fdKota,
    String? fdLA,
    String? fdLG,
    String? fdTipeOutlet,
    String? fdTipeHarga,
    String? fdGroupOutlet,
    String? fdKodeExternal,
    int? fdChiller,
    String? fdKodeRute,
    String? fdTokoLuar1,
    String? fdLimitKredit,
    String? fdNpwp,
    String? fdTokoDalam1,
    String? fdKtp,
    String? fdLastproses) async {
  int rowResult = 0;

  await db.transaction((txn) async {
    rowResult = await txn.rawUpdate('''UPDATE ${mdbconfig.tblNOO} SET  
fdNamaToko=?,
fdAlamat=?,  
fdKota=?, 
fdLA=?,
fdLG=?, 
fdTipeOutlet=?,
fdTipeHarga=?,
fdGroupOutlet=?,
fdKodeExternal=?, 
fdChiller=?, 
fdKodeRute=?,
fdTokoLuar1=?,
fdLimitKredit=?
fdNpwp=?, fdLastproses =? WHERE fdKodeNoo = ? ''', [
      fdNamaToko,
      fdAlamat,
      fdKota,
      fdLA,
      fdLG,
      fdTipeOutlet,
      fdTipeHarga,
      fdGroupOutlet,
      fdKodeExternal,
      fdChiller,
      fdKodeRute,
      fdTokoLuar1,
      fdLimitKredit,
      fdNpwp,
      fdLastproses,
      fdKodeNoo
    ]);
  });

  return rowResult;
}

Future<int> deleteByNoEntry(String token, String fdNoEntry) async {
  late Database db;
  int rowResult = 0;

  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
  db = await openDatabase(dbFullPath, version: 1);
  try {
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblNOO} WHERE fdKodeNoo=? ', [fdNoEntry]);
    });
    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];
      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblNOOfoto} WHERE fdKodeNoo=? ',
          [fdNoEntry]);

      if (results.isNotEmpty) {
        for (var element in results) {
          File(element['fdPath']).exists().then((value) async {
            await File(element['fdPath']).delete();
          });
        }
      }
    });
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblNOOfoto} WHERE fdKodeNoo=? ',
          [fdNoEntry]);
    });
    await db.transaction((txn) async {
      await txn.execute(
          'DELETE FROM ${mdbconfig.tblSFActivity} WHERE fdKodeLangganan=? ',
          [fdNoEntry]);
    });
    rowResult = 1;
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }
  return rowResult;
}

Future<bool> isTransaksiNooNotSent() async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblNOO} a '
          'WHERE fdStatusSent = 0');

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

Future<List<mnoo.NOO>> getAllNOO(String fdDepo, String startDayDate) async {
  late Database db;
  List<mnoo.NOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results;

      results = await txn.rawQuery('SELECT * '
          'FROM ${mdbconfig.tblNOO} WHERE fdStatusSent = 0 ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.NOO.setData(element));
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

Future<void> updateStatusSentNOO(String noEntry) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblNOO} SET fdStatusSent = 1 WHERE fdKodeNoo=? AND fdStatusSent = 0 ',
          [noEntry]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentNOObyKodeLangganan(String fdKodeLangganan) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblNOO} SET fdStatusSent = 1 WHERE fdKodeLangganan=? AND fdStatusSent = 0 ',
          [fdKodeLangganan]);
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<void> updateStatusSentNOOFoto(String fdKodeDepo, String fdKodeSF) async {
  late Database db;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);
    await db.transaction((txn) async {
      txn.rawUpdate(
          'UPDATE ${mdbconfig.tblNOOfoto} SET fdStatusSent = 1 WHERE fdStatusSent = 0');
    });
  } catch (e) {
    rethrow;
  } finally {
    db.isOpen ? await db.close() : null;
  }
}

Future<bool> isFotoNooNotSent(String fdDepo, String fdDate) async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblNOOfoto}  '
          'WHERE fdStatusSent = 0');

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

Future<List<mnoo.FotoNOO>> getAllFotoNoo(
    String fdDepo, String? fdKodeLangganan, String startDayDate) async {
  late Database db;
  List<mnoo.FotoNOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblNOOfoto} WHERE fdStatusSent=0 ');

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.FotoNOO.setData(element));
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

Future<List<mnoo.NOO>> getAllNOObyfdKodeNoo(String? fdKodeNoo) async {
  late Database db;
  List<mnoo.NOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results;

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOO} WHERE fdKodeNoo = ? ',
          [fdKodeNoo]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.NOO.setData(element));
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

Future<mnoo.viewNOO> getNOOActivitybyfdKodeNoo(String? fdKodeNoo) async {
  late Database db;
  mnoo.viewNOO items = mnoo.viewNOO.empty();

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results;

      results = await txn.rawQuery(
          'SELECT a.*, '
          'c.fdStartDate fdStartVisitDate, c.fdEndDate fdEndVisitDate, b.fdReason fdNotVisitReason, '
          'c.fdIsPaused, d.fdReason fdPauseReason '
          'FROM ${mdbconfig.tblNOO} a '
          'LEFT JOIN ${mdbconfig.tblLanggananActivity} b ON b.fdKodeLangganan = a.fdKodeNOO AND b.fdKodeDepo = a.fdDepo '
          ' AND b.fdCategory = \'NotVisit\' '
          'LEFT JOIN ${mdbconfig.tblSFActivity} c ON c.fdKodeLangganan = a.fdKodeNOO AND c.fdKodeDepo = a.fdDepo '
          ' AND c.fdJenisActivity = \'03\' '
          'LEFT JOIN ${mdbconfig.tblLanggananActivity} d ON d.fdKodeLangganan = c.fdKodeLangganan AND d.fdKodeDepo = c.fdKodeDepo '
          ' AND d.fdCategory = \'Pause\' '
          'WHERE fdKodeNoo = ? ',
          [fdKodeNoo]);

      if (results.isNotEmpty) {
        items = mnoo.viewNOO.setData(results.first);
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return items;
}

Future<List<mnoo.FotoNOO>> getAllFotoNoobyfdKodeNoo(String? fdKodeNoo) async {
  late Database db;
  List<mnoo.FotoNOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblNOOfoto} WHERE fdKodeNoo = ? ',
          [fdKodeNoo]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.FotoNOO.setData(element));
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

Future<List<mnoo.FotoNOO>> getAllFotoNoobyfdKodeLangganan(
    String? fdKodeLangganan) async {
  late Database db;
  List<mnoo.FotoNOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      List<Map<String, dynamic>> results = [];

      results = await txn.rawQuery(
          'SELECT * FROM ${mdbconfig.tblNOOfoto} WHERE fdKodeLangganan = ? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.FotoNOO.setData(element));
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

Future<int> deleteNOOfoto(
    String? fdKodeNOO,
    String? fdJenis,
    String? fdNamaJenis,
    String? fdPath,
    String? fdFileName,
    String? token,
    String? parDepo,
    String? parKodeSF) async {
  int rowResult = 0;

  late Database db;
  String? dbPath = await getDatabasesPath();
  String? dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  try {
    db = await openDatabase(dbFullPath, version: 1);
    await db.transaction((txn) async {
      rowResult = await txn.rawDelete(
          '''DELETE from ${mdbconfig.tblNOOfoto} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=? AND fdJenis=?
        AND fdNamaJenis=? ''',
          [fdKodeNOO, parDepo, parKodeSF, fdJenis, fdNamaJenis]);
    });
  } catch (e) {
    throw (e.toString());
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowResult;
}

Future<bool> isExistbyfdKodeNoo(String? fdKodeNoo) async {
  late Database db;
  bool exists = false;
  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOO} WHERE fdKodeNoo = ? ',
          [fdKodeNoo]);

      if (results.isNotEmpty) {
        exists = true;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return exists;
}

Future<int> insertCust(
    String? noEntry,
    String? fileName,
    msf.Salesman user,
    String startDayDate,
    String? fdBadanPerusahaan,
    String? fdNamaToko,
    String? owner,
    String? contactPerson,
    String? fdPhone,
    String? fdMobilePhone,
    String? fdAlamat,
    String? fdKelurahan,
    String? fdKodePos,
    String? fdLA,
    String? fdLG,
    String? fdPatokan,
    String? fdTipeOutlet,
    String? fdNPWP,
    String? fdNpwpNama,
    String? fdNpwpAlamat,
    String? fdKTP,
    String? kodeKelasOutlet,
    String? fdTokoLuar1,
    String? fdNpwpImg,
    String? fdTokoDalam1,
    String? fdKtpImg,
    String? fdKodeLangganan,
    int? fdStatusAktif) async {
  int rowResult = 0;
  int rowDelete = 0;
  int resTL1 = 0;
  int resTL2 = 0;
  int resTD1 = 0;
  int resTD2 = 0;

  late Database db;
  String dbPath = await getDatabasesPath();
  String dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  String fdStatusSent = '0';
  String fdLastproses =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  db = await openDatabase(dbFullPath, version: 1);
  await db.transaction((txn) async {
    var results = await txn.rawQuery(
        'SELECT * '
        'FROM ${mdbconfig.tblNOOfoto} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=?   ',
        [noEntry, user.fdKodeDepo, user.fdKodeSF]);

    if (results.isEmpty) {
      rowResult =
          await txn.rawInsert('''INSERT INTO ${mdbconfig.tblNOO}(fdKodeNoo,
            fdDepo, 
            fdKodeSF,  
            fdBadanUsaha,
            fdNamaToko,
            fdOwner,
            fdContactPerson,
            fdPhone,
            fdMobilePhone,
            fdAlamat,
            fdKelurahan,
            fdKodePos,
            fdLA,
            fdLG,
            fdPatokan,
            fdTipeOutlet,
            fdNPWP,
            fdNamaNPWP,
            fdAlamatNPWP,
            fdNIK,
            fdKelasOutlet,
            fdTokoLuar1,
            fdNpwpImg,
            fdTokoDalam1,
            fdKtpImg,
            fdStatusSent,
            fdLastUpdate, 
            fdKodeLangganan,
            fdStatusAktif ) VALUES(?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?,  
            ?,  
            ?,  
            ?  )''', [
        noEntry,
        user.fdKodeDepo,
        user.fdKodeSF,
        fdBadanPerusahaan,
        fdNamaToko,
        owner,
        contactPerson,
        fdPhone,
        fdMobilePhone,
        fdAlamat,
        fdKelurahan,
        fdKodePos,
        fdLA,
        fdLG,
        fdPatokan,
        fdTipeOutlet,
        fdNPWP,
        fdNpwpNama,
        fdNpwpAlamat,
        fdKTP,
        kodeKelasOutlet,
        fdTokoLuar1,
        fdNpwpImg,
        fdTokoDalam1,
        fdKtpImg,
        fdStatusSent,
        fdLastproses,
        fdKodeLangganan,
        fdStatusAktif
      ]);
    } else {
      // rowResult = 1;

      rowDelete = await txn.rawDelete(
          '''DELETE FROM ${mdbconfig.tblNOO} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=? ''',
          [noEntry, user.fdKodeDepo, user.fdKodeSF]);
      rowResult =
          await txn.rawInsert('''INSERT INTO ${mdbconfig.tblNOO}(fdKodeNoo,
            fdDepo, 
            fdKodeSF,  
            fdBadanUsaha,
            fdNamaToko,
            fdOwner,
            fdContactPerson,
            fdPhone,
            fdMobilePhone,
            fdAlamat,
            fdKelurahan,
            fdKodePos,
            fdLA,
            fdLG,
            fdPatokan,
            fdTipeOutlet,
            fdNPWP,
            fdNamaNPWP,
            fdAlamatNPWP,
            fdNIK,
            fdKelasOutlet,
            fdTokoLuar1,
            fdNpwpImg,
            fdTokoDalam1,
            fdKtpImg,
            fdStatusSent,
            fdLastUpdate, 
            fdKodeLangganan,
            fdStatusAktif ) VALUES(?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?,
            ?,
            ?, 
            ?,
            ?,
            ?,
            ?,  
            ?,    
            ?,
            ?  )''', [
        noEntry,
        user.fdKodeDepo,
        user.fdKodeSF,
        fdBadanPerusahaan,
        fdNamaToko,
        owner,
        contactPerson,
        fdPhone,
        fdMobilePhone,
        fdAlamat,
        fdKelurahan,
        fdKodePos,
        fdLA,
        fdLG,
        fdPatokan,
        fdTipeOutlet,
        fdNPWP,
        fdNpwpNama,
        fdNpwpAlamat,
        fdKTP,
        kodeKelasOutlet,
        fdTokoLuar1,
        fdNpwpImg,
        fdTokoDalam1,
        fdKtpImg,
        fdStatusSent,
        fdLastproses,
        fdKodeLangganan,
        fdStatusAktif
      ]);
    }
  });
  if (rowResult > 0) {
    if (fdTokoLuar1 != '') {
      resTL1 = await insertNOOfoto(noEntry, 'TL', 'TOKO LUAR', fdTokoLuar1,
          fdTokoLuar1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdNpwpImg != '') {
      resTL2 = await insertNOOfoto(noEntry, 'NPWP', 'NPWP', fdNpwpImg,
          fdNpwpImg, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdTokoDalam1 != '') {
      resTD1 = await insertNOOfoto(noEntry, 'TD', 'TOKO DALAM', fdTokoDalam1,
          fdTokoDalam1, user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }
    if (fdKtpImg != '') {
      resTD2 = await insertNOOfoto(noEntry, 'KTP', 'KTP', fdKtpImg, fdKtpImg,
          user.fdToken, user.fdKodeDepo, user.fdKodeSF);
    }

    if (fdTokoLuar1 != '' && resTL1 == 0) {
      return 1;
    } else if (fdNpwpImg != '' && resTL2 == 0) {
      return 2;
    } else if (fdTokoDalam1 != '' && resTD1 == 0) {
      return 3;
    } else if (fdKtpImg != '' && resTD2 == 0) {
      return 4;
    } else {
      // return 99;
      //SEND FILE FOTO TO SERVER
      Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};
      String dirCameraPath =
          '${param.appDir}/${param.imgPath}/${user.fdKodeSF}';
      String dirNOO = '$dirCameraPath/$fdKodeLangganan';
      var dir = Directory(dirNOO);
      var webPath = param.pathImgServer(
          user.fdKodeDepo, user.fdKodeSF, startDayDate, '$fdKodeLangganan/');

      if (await dir.exists()) {
        try {
          String zipPath =
              '$dirCameraPath/$fdKodeLangganan.zip'; //path di luar folder NOO
          String errorMsg = await cdb.createZipDirectory(dir.path, zipPath);

          if (errorMsg.isEmpty) {
            int responseCode = await capi.sendImagetoServer(
                zipPath, user, fdKodeLangganan!, startDayDate);

            if (responseCode == 401) {
              mapResult['fdData'] = '401';
              mapResult['fdMessage'] = '';

              return 5;
            } else if (responseCode == 0) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] =
                  'Terjadi error kirim foto, mohon coba kembali';

              return 5;
            } else if (responseCode == 400) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] = 'Terjadi timeout, mohon coba kembali';

              return 5;
            }
          } else {
            mapResult['fdData'] = '0';
            mapResult['fdMessage'] = 'Error compress file: $errorMsg';

            return 5;
          }
        } catch (e) {
          mapResult['fdData'] = '0';
          mapResult['fdMessage'] = 'Terjadi error: $e, mohon coba kembali';

          return 5;
        }
      }

      //SEND DATA FOTO TO SERVER
      try {
        List<mnoo.FotoNOO> listNooFoto =
            await getAllFotoNoobyfdKodeNoo(noEntry);

        Map<String, dynamic> result = await capi.sendFotoNooServer(
            user,
            fdKodeLangganan!,
            '0',
            param.dateTimeFormatDB.format(DateTime.now()),
            listNooFoto,
            webPath);
        print(result['fdData']);
        mapResult['fdData'] = result['fdData'];
        mapResult['fdMessage'] = result['fdMessage'];
        print(mapResult['fdData']);
        if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
          //SEND DATA TO SERVER
          try {
            List<mnoo.NOO> listNoo = await getAllNOObyfdKodeNoo(noEntry);

            Map<String, dynamic> result2 = await capi.setNOOtoServer(
                user,
                '1',
                param.dateTimeFormatDB.format(DateTime.now()),
                listNoo,
                webPath);

            mapResult['fdData'] = result2['fdData'];
            mapResult['fdMessage'] = result2['fdMessage'];
            if (mapResult['fdData'] != '0' && mapResult['fdData'] != '401') {
              await updateStatusSentNOO(noEntry!);
              return 99;
            } else if (mapResult['fdData'] == '401') {
              return 401;
            } else {
              return 7;
            }
          } catch (e) {
            if (e == '500') {
              return 500;
            } else {
              return 0;
            }
          }
        } else {
          return 6;
        }
      } catch (e) {
        if (e == '500') {
          return 500;
        } else {
          return 0;
        }
      }
      //sugeng end remark
    }
  } else {
    return 0;
  }
}

Future<int> insertCustfoto(
    String? fdKodeNOO,
    String? fdJenis,
    String? fdNamaJenis,
    String? fdPath,
    String? fdFileName,
    String? token,
    String? parDepo,
    String? parKodeSF) async {
  int rowResult = 0;

  late Database db;
  String? dbPath = await getDatabasesPath();
  String? dbFullPath = cpath.join(dbPath, mdbconfig.dbName);

  String fdStatusSent = '0';
  String fdLastproses =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  try {
    db = await openDatabase(dbFullPath, version: 1);
    await db.transaction((txn) async {
      var results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOOfoto} where fdKodeNoo=? AND fdDepo=? AND fdKodeSF=? AND fdJenis=? AND fdNamaJenis=? ',
          [fdKodeNOO, parDepo, parKodeSF, fdJenis, fdNamaJenis]);

      if (results.isEmpty) {
        String fileName = cpath.basename(fdPath!);
        rowResult = await txn
            .rawInsert('''INSERT INTO ${mdbconfig.tblNOOfoto}(fdKodeNoo, 
        fdDepo, 
        fdKodeSF, 
        fdJenis,
        fdNamaJenis,
        fdPath,
        fdFileName,
        fdStatusSent,
        fdLastUpdate ) VALUES(?,
        ?,
        ?,
        ?,
        ?, 
        ?,
        ?,
        ?,
        ? )''', [
          fdKodeNOO,
          parDepo,
          parKodeSF,
          fdJenis,
          fdNamaJenis,
          fdPath,
          fileName,
          fdStatusSent,
          fdLastproses
        ]);
      } else {
        rowResult = 1;
      }
    });
  } catch (e) {
    throw (e.toString());
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowResult;
}

Future<List<mnoo.NOO>> getAllNOObyfdKodeLangganan(
    String? fdKodeLangganan) async {
  late Database db;
  List<mnoo.NOO> items = [];

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results;

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOO} WHERE fdKodeLangganan = ? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        for (var element in results) {
          items.add(mnoo.NOO.setData(element));
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

Future<String> getKodeNOObyfdKodeLangganan(String? fdKodeLangganan) async {
  late Database db;
  String fdKodeNoo = '';

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results;

      results = await txn.rawQuery(
          'SELECT * '
          'FROM ${mdbconfig.tblNOO} WHERE fdKodeLangganan = ? ',
          [fdKodeLangganan]);

      if (results.isNotEmpty) {
        fdKodeNoo = results[0]['fdKodeNoo'];
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return fdKodeNoo;
}

Future<int> countNoo() async {
  late Database db;
  int rowCount = 0;

  try {
    db = await openDatabase(mdbconfig.dbFullPath, version: mdbconfig.dbVersion);

    await db.transaction((txn) async {
      var results = await txn.rawQuery('SELECT COUNT(0) rowCount '
          'FROM ${mdbconfig.tblNOO} a ');

      if (results.isNotEmpty) {
        rowCount = int.tryParse(results.first['rowCount'].toString()) ?? 0;
      }
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.isOpen ? await db.close() : null;
  }

  return rowCount;
}
