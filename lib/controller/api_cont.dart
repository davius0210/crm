import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path/path.dart' as cpath;
import 'package:http/http.dart' as chttp;
import 'langganan_cont.dart' as clgn;
import 'langganangroup_cont.dart' as cgrouplgn;
import 'Provinsi_cont.dart' as cprov;
import 'kabupaten_cont.dart' as ckab;
import 'kecamatan_cont.dart' as ckec;
import 'kelurahan_cont.dart' as ckel;
import 'tipeharga_cont.dart' as ctharga;
import 'tipeoutlet_cont.dart' as ctoutlet;
import 'tipedetail_cont.dart' as cdetail;
import 'collection_cont.dart' as ccoll;
import 'barang_cont.dart' as cbrg;
import 'branding_cont.dart' as cbr;
import 'promo_cont.dart' as cpro;
import 'salesman_cont.dart' as csf;
import 'order_cont.dart' as codr;
import 'noo_cont.dart' as cnoo;
import 'menu_cont.dart' as cmenu;
import 'log_cont.dart' as clog;
import 'piutang_cont.dart' as cpiu;
import 'diskon_cont.dart' as cdisc;
import 'limitkredit_cont.dart' as clk;
import 'notification_service.dart' as cnotif;
import 'stock_cont.dart' as cstk;
import 'rute_cont.dart' as crute;
import 'database_cont.dart' as cdb;
import '../models/menu.dart' as mmenu;
import '../models/salesman.dart' as msf;
import '../models/langganan.dart' as mlgn;
import '../models/barang.dart' as mbrg;
import '../models/branding.dart' as mbr;
import '../models/promo.dart' as mpro;
import '../models/package.dart' as mpck;
import '../models/grouplangganan.dart' as mgrouplgn;
import '../models/provinsi.dart' as mprov;
import '../models/kabupaten.dart' as mkab;
import '../models/kecamatan.dart' as mkec;
import '../models/kelurahan.dart' as mkel;
import '../models/tipeharga.dart' as mtharga;
import '../models/tipeoutlet.dart' as mtoutlet;
import '../models/tipedetail.dart' as mdetail;
import '../models/order.dart' as modr;
import '../models/noo.dart' as mnoo;
import '../models/database.dart' as mdbconfig;
import '../models/globalparam.dart' as param;
import '../models/logdevice.dart' as mlog;
import '../models/piutang.dart' as mpiu;
import '../models/diskon.dart' as mdisc;
import '../models/limitkredit.dart' as mlk;
import '../models/stock.dart' as mstk;
import '../models/rencanarute.dart' as mrrute;
import '../models/collection.dart' as mcoll;

// const String urlAPILiveMD = 'http://34.101.33.221:8018/SF'; //LIVE G.CLOUD
// const String urlAPILiveMD = 'http://202.137.24.172:8012/SF'; //DEV 222 X
const String urlAPILiveMD = 'http://202.137.24.172:6969/SF'; //DEV 222

Future<msf.Salesman?> loginMD(String fdUsername, String fdPassword,
    String fdVersion, String fdTokenMsg) async {
  print(fdTokenMsg);
  const key = 'xlYh7659sagrASnn';
  final salt1 = key + fdPassword;
  var bytesToHash1 = utf8.encode(salt1);
  var sha512Digest1 = sha512.convert(bytesToHash1);
  final salt2 = fdPassword + key;
  var bytesToHash2 = utf8.encode(salt2);
  var sha512Digest2 = sha512.convert(bytesToHash2);
  final hashed_password =
      sha512Digest1.toString() + fdPassword + sha512Digest2.toString();
  var bytesToHash3 = utf8.encode(hashed_password);
  var sha512Digest3 = sha512.convert(bytesToHash3);

  final response = await chttp
      .post(
        Uri.parse('$urlAPILiveMD/Login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'FdKodeSF': fdUsername,
          'FdPassword': sha512Digest3.toString(),
          'FdVersion': fdVersion.toString(),
          'FdTokenMsg': fdTokenMsg
        }),
      )
      .timeout(Duration(minutes: param.minuteTimeout));
  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return msf.Salesman.fromJson(jsonDecode(response.body));
  } else {
    return msf.Salesman.fromJson(jsonDecode(response.body));
  }
}

Future<msf.Salesman?> refreshToken(String fdUsername, String fdPassword,
    String fdTokenMsg, String fdVersion, String fdToken) async {
  try {
    Map<String, dynamic> params = {
      'FdKodeSF': fdUsername,
      'FdPassword': fdPassword,
      'FdVersion': fdVersion,
      'FdTokenMsg': fdTokenMsg
    };

    final response = await chttp.post(Uri.parse('$urlAPILiveMD/refresh-tok'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $fdToken'
        },
        body: jsonEncode(params));
    print('Bearer $fdToken');
    print('fdTokenMsg $fdTokenMsg');
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return msf.Salesman.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      Map<String, dynamic> result = {'FdAkses': false, 'FdMessage': '401'};

      return msf.Salesman.fromJson(result);
    } else {
      return msf.Salesman.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> uploadFile(File imageFile, String parImage, msf.Salesman user,
    String fdKodeLangganan, String fdDate) async {
  // string to uri
  var uri = Uri.parse('$urlAPILiveMD/uploadFile');
  // create multipart request
  var request = chttp.MultipartRequest("POST", uri);

  request.headers.addAll({'Authorization': 'Bearer ${user.fdToken}'});
  var multipartFile = chttp.MultipartFile.fromBytes(
      'file', await imageFile.readAsBytes(),
      filename: parImage);

  Map<String, String> params = {
    "FdDepo": user.fdKodeDepo,
    "FdKodeSF": user.fdKodeSF,
    "FdKodeLangganan": fdKodeLangganan,
    "FdTanggal": fdDate
  };

  // add file to multipart
  request.files.add(multipartFile);
  request.fields.addAll(params);

  // send
  try {
    var response = await request.send().timeout(
        Duration(minutes: param.minuteTimeout),
        onTimeout: () => chttp.StreamedResponse(const Stream.empty(), 400));
    print(response.statusCode);

    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    print(result);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 1;
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else if (response.statusCode == 400) {
      return response.statusCode;
    } else {
      //failed call API
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

Future<int> uploadBackupFile(File imageFile, String parImage, msf.Salesman user,
    String fdKodeLangganan, String fdDate) async {
  // string to uri
  var uri = Uri.parse('$urlAPILiveMD/uploadBackupFile');
  // create multipart request
  var request = chttp.MultipartRequest("POST", uri);

  request.headers.addAll({'Authorization': 'Bearer ${user.fdToken}'});
  var multipartFile = chttp.MultipartFile.fromBytes(
      'file', await imageFile.readAsBytes(),
      filename: parImage);

  Map<String, String> params = {
    "FdDepo": user.fdKodeDepo,
    "FdKodeSF": user.fdKodeSF,
    "FdKodeLangganan": fdKodeLangganan,
    "FdTanggal": fdDate
  };

  // add file to multipart
  request.files.add(multipartFile);
  request.fields.addAll(params);

  // send
  try {
    var response = await request.send().timeout(
        Duration(minutes: param.minuteTimeout),
        onTimeout: () => chttp.StreamedResponse(const Stream.empty(), 400));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 1;
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else if (response.statusCode == 400) {
      return response.statusCode;
    } else {
      //failed call API
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

Future<int> getRuteLanggananInfo(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mlgn.Langganan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlgn.Langganan.fromJson(element, 1));
        }
        print('jumlah ${items.length}');

        await clgn.insertLanggananBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<mlgn.Langganan>> getNonRuteLanggananInfo(
    String token,
    String fdKodeSF,
    String fdKodeDepo,
    String fdStartDayDate,
    List<mlgn.Langganan> listNonRuteSelected) async {
  List<mlgn.Langganan> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": fdStartDayDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataNonRuteLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mlgn.Langganan.fromJson(element, 0));

          var filterData = listNonRuteSelected.where((item) =>
              item.fdKodeLangganan ==
              listItem[listItem.length - 1].fdKodeLangganan);

          if (filterData.isNotEmpty) {
            listItem[listItem.length - 1].isCheck = true;
            listItem[listItem.length - 1].isLocked = filterData.first.isLocked;
          }
        }
        print('jumlah ${listItem.length}');
      } else {
        mlgn.Langganan item = mlgn.Langganan(
            fdKodeSF: '',
            fdKodeDepo: '',
            fdKodeLangganan: '',
            fdBadanUsaha: '',
            fdNamaLangganan: '',
            fdOwner: '',
            fdContactPerson: '',
            fdPhone: '',
            fdMobilePhone: '',
            fdAlamat: '',
            fdKelurahan: '',
            fdKodePos: '',
            fdLA: 0,
            fdLG: 0,
            fdTipeOutlet: '',
            fdNPWP: '',
            fdNamaNPWP: '',
            fdAlamatNPWP: '',
            fdNIK: '',
            fdKelasOutlet: '',
            fdKodeRute: '',
            fdIsPaused: 0,
            fdPauseReason: '',
            fdCategory: '',
            fdPhoto: '',
            fdKeterangan: '',
            isRute: 0,
            fdKodeStatus: 0,
            isLocked: 0,
            fdLimitKredit: 0,
            isEditProfile: 0,
            fdLastUpdate: '',
            fdTanggalActivity: '',
            fdStartVisitDate: '',
            fdEndVisitDate: '',
            fdNotVisitReason: '',
            fdKodeReason: '',
            fdReason: '',
            fdCancelVisitReason: '',
            fdKodeHarga: '',
            fdStatusSent: 0,
            code: 99,
            fdKodeExternal: '',
            isLatePayment: 0,
            message: 'Data outlet non rute tidak ada');

        listItem.add(item);
      }
    } else if (response.statusCode == 401) {
      mlgn.Langganan item = mlgn.Langganan(
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: response.statusCode,
          fdKodeExternal: '',
          isLatePayment: 0,
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mlgn.Langganan item = mlgn.Langganan(
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: 99,
          fdKodeExternal: '',
          isLatePayment: 0,
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mlgn.Langganan item = mlgn.Langganan(
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: 99,
          fdKodeExternal: '',
          isLatePayment: 0,
          message:
              'Gagal proses outlet non rute. Refresh ulang halaman non rute');

      listItem.add(item);
    }
  } catch (e) {
    mlgn.Langganan item = mlgn.Langganan(
        fdKodeSF: '',
        fdKodeDepo: '',
        fdKodeLangganan: '',
        fdBadanUsaha: '',
        fdNamaLangganan: '',
        fdOwner: '',
        fdContactPerson: '',
        fdPhone: '',
        fdMobilePhone: '',
        fdAlamat: '',
        fdKelurahan: '',
        fdKodePos: '',
        fdLA: 0,
        fdLG: 0,
        fdTipeOutlet: '',
        fdNPWP: '',
        fdNamaNPWP: '',
        fdAlamatNPWP: '',
        fdNIK: '',
        fdKelasOutlet: '',
        fdKodeRute: '',
        fdIsPaused: 0,
        fdPauseReason: '',
        fdCategory: '',
        fdPhoto: '',
        fdKeterangan: '',
        isRute: 0,
        fdKodeStatus: 0,
        isLocked: 0,
        fdLimitKredit: 0,
        isEditProfile: 0,
        fdLastUpdate: '',
        fdTanggalActivity: '',
        fdStartVisitDate: '',
        fdEndVisitDate: '',
        fdNotVisitReason: '',
        fdKodeReason: '',
        fdReason: '',
        fdCancelVisitReason: '',
        fdKodeHarga: '',
        fdStatusSent: 0,
        code: 99,
        fdKodeExternal: '',
        isLatePayment: 0,
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<List<mrrute.RencanaNonRuteLangganan>> getNonRuteLangganan(
    String token,
    String fdKodeSF,
    String fdKodeDepo,
    String fdStartDayDate,
    List<mrrute.RencanaNonRuteLangganan> listNonRuteSelected) async {
  List<mrrute.RencanaNonRuteLangganan> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": fdStartDayDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataNonRuteLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mrrute.RencanaNonRuteLangganan.fromJson(element, 0));

          var filterData = listNonRuteSelected.where((item) =>
              item.fdKodeLangganan ==
              listItem[listItem.length - 1].fdKodeLangganan);

          if (filterData.isNotEmpty) {
            listItem[listItem.length - 1].isCheck = true;
            listItem[listItem.length - 1].isLocked = filterData.first.isLocked;
          }
        }
        print('jumlah ${listItem.length}');
      } else {
        mrrute.RencanaNonRuteLangganan item = mrrute.RencanaNonRuteLangganan(
            fdNoRencanaRute: '',
            fdTanggalRencanaRute: '',
            fdKodeSF: '',
            fdKodeDepo: '',
            fdKodeLangganan: '',
            fdBadanUsaha: '',
            fdNamaLangganan: '',
            fdOwner: '',
            fdContactPerson: '',
            fdPhone: '',
            fdMobilePhone: '',
            fdAlamat: '',
            fdKelurahan: '',
            fdKodePos: '',
            fdLA: 0,
            fdLG: 0,
            fdTipeOutlet: '',
            fdNPWP: '',
            fdNamaNPWP: '',
            fdAlamatNPWP: '',
            fdNIK: '',
            fdKelasOutlet: '',
            fdKodeRute: '',
            fdIsPaused: 0,
            fdPauseReason: '',
            fdCategory: '',
            fdPhoto: '',
            fdKeterangan: '',
            isRute: 0,
            fdKodeStatus: 0,
            isLocked: 0,
            fdLimitKredit: 0,
            isEditProfile: 0,
            fdLastUpdate: '',
            fdTanggalActivity: '',
            fdStartVisitDate: '',
            fdEndVisitDate: '',
            fdNotVisitReason: '',
            fdKodeReason: '',
            fdReason: '',
            fdCancelVisitReason: '',
            fdKodeHarga: '',
            fdStatusSent: 0,
            code: 99,
            fdKodeExternal: '',
            isLatePayment: 0,
            message: 'Data outlet non rute tidak ada');

        listItem.add(item);
      }
    } else if (response.statusCode == 401) {
      mrrute.RencanaNonRuteLangganan item = mrrute.RencanaNonRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: response.statusCode,
          fdKodeExternal: '',
          isLatePayment: 0,
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mrrute.RencanaNonRuteLangganan item = mrrute.RencanaNonRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: 99,
          fdKodeExternal: '',
          isLatePayment: 0,
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mrrute.RencanaNonRuteLangganan item = mrrute.RencanaNonRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeSF: '',
          fdKodeDepo: '',
          fdKodeLangganan: '',
          fdBadanUsaha: '',
          fdNamaLangganan: '',
          fdOwner: '',
          fdContactPerson: '',
          fdPhone: '',
          fdMobilePhone: '',
          fdAlamat: '',
          fdKelurahan: '',
          fdKodePos: '',
          fdLA: 0,
          fdLG: 0,
          fdTipeOutlet: '',
          fdNPWP: '',
          fdNamaNPWP: '',
          fdAlamatNPWP: '',
          fdNIK: '',
          fdKelasOutlet: '',
          fdKodeRute: '',
          fdIsPaused: 0,
          fdPauseReason: '',
          fdCategory: '',
          fdPhoto: '',
          fdKeterangan: '',
          isRute: 0,
          fdKodeStatus: 0,
          isLocked: 0,
          fdLimitKredit: 0,
          isEditProfile: 0,
          fdLastUpdate: '',
          fdTanggalActivity: '',
          fdStartVisitDate: '',
          fdEndVisitDate: '',
          fdNotVisitReason: '',
          fdKodeReason: '',
          fdReason: '',
          fdCancelVisitReason: '',
          fdKodeHarga: '',
          fdStatusSent: 0,
          code: 99,
          fdKodeExternal: '',
          isLatePayment: 0,
          message:
              'Gagal proses outlet non rute. Refresh ulang halaman non rute');

      listItem.add(item);
    }
  } catch (e) {
    mrrute.RencanaNonRuteLangganan item = mrrute.RencanaNonRuteLangganan(
        fdNoRencanaRute: '',
        fdTanggalRencanaRute: '',
        fdKodeSF: '',
        fdKodeDepo: '',
        fdKodeLangganan: '',
        fdBadanUsaha: '',
        fdNamaLangganan: '',
        fdOwner: '',
        fdContactPerson: '',
        fdPhone: '',
        fdMobilePhone: '',
        fdAlamat: '',
        fdKelurahan: '',
        fdKodePos: '',
        fdLA: 0,
        fdLG: 0,
        fdTipeOutlet: '',
        fdNPWP: '',
        fdNamaNPWP: '',
        fdAlamatNPWP: '',
        fdNIK: '',
        fdKelasOutlet: '',
        fdKodeRute: '',
        fdIsPaused: 0,
        fdPauseReason: '',
        fdCategory: '',
        fdPhoto: '',
        fdKeterangan: '',
        isRute: 0,
        fdKodeStatus: 0,
        isLocked: 0,
        fdLimitKredit: 0,
        isEditProfile: 0,
        fdLastUpdate: '',
        fdTanggalActivity: '',
        fdStartVisitDate: '',
        fdEndVisitDate: '',
        fdNotVisitReason: '',
        fdKodeReason: '',
        fdReason: '',
        fdCancelVisitReason: '',
        fdKodeHarga: '',
        fdStatusSent: 0,
        code: 99,
        fdKodeExternal: '',
        isLatePayment: 0,
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<int> getRuteLangganan(
    String token, String fdKodeSF, String fdKodeDepo, String startDate) async {
  List<mrrute.RencanaNonRuteLangganan> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": startDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetRuteLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      if (jsonResult["FdData"] != null) {
        List<dynamic> jsonBody = jsonResult["FdData"];
        List<mrrute.RencanaNonRuteLangganan> items = [];
        List<mlgn.Langganan> convertToLangganan(
            List<mrrute.RencanaNonRuteLangganan> items) {
          return items
              .map((e) => mlgn.Langganan(
                  fdKodeSF: e.fdKodeSF,
                  fdKodeDepo: e.fdKodeDepo,
                  fdKodeLangganan: e.fdKodeLangganan,
                  fdBadanUsaha: e.fdBadanUsaha,
                  fdNamaLangganan: e.fdNamaLangganan,
                  fdOwner: e.fdOwner,
                  fdContactPerson: e.fdContactPerson,
                  fdPhone: e.fdPhone,
                  fdMobilePhone: e.fdMobilePhone,
                  fdAlamat: e.fdAlamat,
                  fdKelurahan: e.fdKelurahan,
                  fdKodePos: e.fdKodePos,
                  fdLA: double.tryParse(e.fdLA.toString()) != null ? e.fdLA : 0,
                  fdLG: double.tryParse(e.fdLG.toString()) != null ? e.fdLG : 0,
                  fdTipeOutlet: e.fdTipeOutlet,
                  fdNPWP: e.fdNPWP,
                  fdNamaNPWP: e.fdNamaNPWP,
                  fdAlamatNPWP: e.fdAlamatNPWP,
                  fdNIK: e.fdNIK,
                  fdKelasOutlet: e.fdKelasOutlet,
                  fdKodeRute: e.fdKodeRute,
                  fdIsPaused: e.fdIsPaused,
                  fdPauseReason: e.fdPauseReason,
                  fdCategory: e.fdCategory,
                  fdPhoto: e.fdPhoto,
                  fdKeterangan: e.fdKeterangan,
                  isRute: e.isRute,
                  fdKodeStatus: e.fdKodeStatus,
                  isLocked: e.isLocked,
                  fdLimitKredit:
                      double.tryParse(e.fdLimitKredit.toString()) != null
                          ? e.fdLimitKredit
                          : 0,
                  isEditProfile: e.isEditProfile,
                  fdLastUpdate: e.fdLastUpdate,
                  fdTanggalActivity: e.fdTanggalActivity,
                  fdStartVisitDate: e.fdStartVisitDate,
                  fdEndVisitDate: e.fdEndVisitDate,
                  fdNotVisitReason: e.fdNotVisitReason,
                  fdKodeReason: e.fdKodeReason,
                  fdReason: e.fdReason,
                  fdCancelVisitReason: e.fdCancelVisitReason,
                  fdKodeHarga: e.fdKodeHarga,
                  fdStatusSent: e.fdStatusSent,
                  isCheck: e.isCheck,
                  fdKodeExternal: e.fdKodeExternal,
                  isLatePayment: e.isLatePayment,
                  code: e.code,
                  message: e.message))
              .toList();
        }

        if (jsonBody.isNotEmpty) {
          for (var element in jsonBody) {
            items.add(mrrute.RencanaNonRuteLangganan.fromJson(element, 1));
          }
          List<mlgn.Langganan> lgnitems = convertToLangganan(items);
          await clgn.deleteLanggananRuteExists();
          await clgn.insertLanggananRuteBatch(lgnitems);

          return 1;
        } else {
          throw ('Data barang tidak ada');
        }
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getRencanaRuteLangganan(
    String token, String fdKodeSF, String fdKodeDepo, String startDate) async {
  List<mrrute.RencanaNonRuteLangganan> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": startDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetFMsRencanaRute'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      if (jsonResult["FdData"] != null) {
        List<dynamic> jsonBody = jsonResult["FdData"];
        List<mrrute.RencanaNonRuteLangganan> items = [];
        List<mlgn.Langganan> convertToLangganan(
            List<mrrute.RencanaNonRuteLangganan> items) {
          return items
              .map((e) => mlgn.Langganan(
                  fdKodeSF: e.fdKodeSF,
                  fdKodeDepo: e.fdKodeDepo,
                  fdKodeLangganan: e.fdKodeLangganan,
                  fdBadanUsaha: e.fdBadanUsaha,
                  fdNamaLangganan: e.fdNamaLangganan,
                  fdOwner: e.fdOwner,
                  fdContactPerson: e.fdContactPerson,
                  fdPhone: e.fdPhone,
                  fdMobilePhone: e.fdMobilePhone,
                  fdAlamat: e.fdAlamat,
                  fdKelurahan: e.fdKelurahan,
                  fdKodePos: e.fdKodePos,
                  fdLA: double.tryParse(e.fdLA.toString()) != null ? e.fdLA : 0,
                  fdLG: double.tryParse(e.fdLG.toString()) != null ? e.fdLG : 0,
                  fdTipeOutlet: e.fdTipeOutlet,
                  fdNPWP: e.fdNPWP,
                  fdNamaNPWP: e.fdNamaNPWP,
                  fdAlamatNPWP: e.fdAlamatNPWP,
                  fdNIK: e.fdNIK,
                  fdKelasOutlet: e.fdKelasOutlet,
                  fdKodeRute: e.fdKodeRute,
                  fdIsPaused: e.fdIsPaused,
                  fdPauseReason: e.fdPauseReason,
                  fdCategory: e.fdCategory,
                  fdPhoto: e.fdPhoto,
                  fdKeterangan: e.fdKeterangan,
                  isRute: e.isRute,
                  fdKodeStatus: e.fdKodeStatus,
                  isLocked: e.isLocked,
                  fdLimitKredit:
                      double.tryParse(e.fdLimitKredit.toString()) != null
                          ? e.fdLimitKredit
                          : 0,
                  isEditProfile: e.isEditProfile,
                  fdLastUpdate: e.fdLastUpdate,
                  fdTanggalActivity: e.fdTanggalActivity,
                  fdStartVisitDate: e.fdStartVisitDate,
                  fdEndVisitDate: e.fdEndVisitDate,
                  fdNotVisitReason: e.fdNotVisitReason,
                  fdKodeReason: e.fdKodeReason,
                  fdReason: e.fdReason,
                  fdCancelVisitReason: e.fdCancelVisitReason,
                  fdKodeHarga: e.fdKodeHarga,
                  fdStatusSent: e.fdStatusSent,
                  isCheck: e.isCheck,
                  fdKodeExternal: e.fdKodeExternal,
                  isLatePayment: e.isLatePayment,
                  code: e.code,
                  message: e.message))
              .toList();
        }

        if (jsonBody.isNotEmpty) {
          for (var element in jsonBody) {
            items.add(mrrute.RencanaNonRuteLangganan.fromJson(element, 1));
          }
          List<mlgn.Langganan> lgnitems = convertToLangganan(items);
          await clgn.deleteLanggananRuteExists();
          await clgn.insertLanggananRuteBatch(lgnitems);

          return 1;
        } else {
          throw ('Data barang tidak ada');
        }
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<mrrute.RencanaRuteLangganan>> getViewRute(
    String token,
    String fdKodeSF,
    String fdKodeDepo,
    String fdStartDayDate,
    List<mrrute.RencanaRuteLangganan> listNonRuteSelected) async {
  List<mrrute.RencanaRuteLangganan> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": fdStartDayDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetViewRute'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    print('json:${jsonEncode(params)}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mrrute.RencanaRuteLangganan.fromJson(element));

          var filterData = listNonRuteSelected.where((item) =>
              item.fdKodeLangganan ==
              listItem[listItem.length - 1].fdKodeLangganan);

          if (filterData.isNotEmpty) {
            listItem[listItem.length - 1].isCheck = true;
          }
        }
        print('jumlah ${listItem.length}');
      } else {
        mrrute.RencanaRuteLangganan item = mrrute.RencanaRuteLangganan(
            fdNoRencanaRute: '',
            fdTanggalRencanaRute: '',
            fdKodeLangganan: '',
            fdNamaLangganan: '',
            fdAlamat: '',
            fdPekan: '',
            fdHari: '',
            fdLastUpdate: '',
            code: 99,
            message: 'Data outlet non rute tidak ada');

        listItem.add(item);
      }
    } else if (response.statusCode == 401) {
      mrrute.RencanaRuteLangganan item = mrrute.RencanaRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeLangganan: '',
          fdNamaLangganan: '',
          fdAlamat: '',
          fdPekan: '',
          fdHari: '',
          fdLastUpdate: '',
          code: response.statusCode,
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mrrute.RencanaRuteLangganan item = mrrute.RencanaRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeLangganan: '',
          fdNamaLangganan: '',
          fdAlamat: '',
          fdPekan: '',
          fdHari: '',
          fdLastUpdate: '',
          code: 99,
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mrrute.RencanaRuteLangganan item = mrrute.RencanaRuteLangganan(
          fdNoRencanaRute: '',
          fdTanggalRencanaRute: '',
          fdKodeLangganan: '',
          fdNamaLangganan: '',
          fdAlamat: '',
          fdPekan: '',
          fdHari: '',
          fdLastUpdate: '',
          code: 99,
          message: 'Error view rute');

      listItem.add(item);
    }
  } catch (e) {
    mrrute.RencanaRuteLangganan item = mrrute.RencanaRuteLangganan(
        fdNoRencanaRute: '',
        fdTanggalRencanaRute: '',
        fdKodeLangganan: '',
        fdNamaLangganan: '',
        fdAlamat: '',
        fdPekan: '',
        fdHari: '',
        fdLastUpdate: '',
        code: 99,
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<int> getAllCustMenu(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataMenu'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mmenu.MenuMD> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mmenu.MenuMD.fromJson(element));
        }

        await cmenu.insertMenuBatch(items);

        return 1;
      } else {
        throw ('Data menu tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getLanggananAlamat(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    debugPrint(jsonEncode(params));
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetLanggananAlamat'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mlgn.LanggananAlamat> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlgn.LanggananAlamat.fromJson(element));
        }

        await clgn.insertLanggananAlamatBatch(items);

        return 1;
      } else {
        throw ('Data Langganan Alamat tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllBarang(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataBarang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.Barang> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.Barang.fromJson(element));
        }

        await cbrg.insertBarangBatch(items);

        return 1;
      } else {
        throw ('Data barang tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getFMsSaBarangTOP(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetFMsSaBarangTOP'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.BarangTOP> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.BarangTOP.fromJson(element));
        }

        await cbrg.insertBarangTOPBatch(items);

        return 1;
      } else {
        throw ('Data barang tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getFMsSaLanggananTOP(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetFMsSaLanggananTOP'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mlgn.LanggananTOP> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlgn.LanggananTOP.fromJson(element));
        }

        await clgn.insertLanggananTOPBatch(items);

        return 1;
      } else {
        throw ('Data barang tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getFmsBank(String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetFmsBank'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mlgn.Bank> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlgn.Bank.fromJson(element));
        }

        await clgn.insertBankBatch(items);

        return 1;
      } else {
        throw ('Data bank tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDataHargaJualBarang(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataHargaJualBarang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.HargaJualBarang> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.HargaJualBarang.fromJson(element));
        }

        await cbrg.insertHargaJualBarangBatch(items);

        return 1;
      } else {
        throw ('Data barang tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<mbrg.BarangSelected>> getDataDiskonBarangExtra(
    String token,
    String fdKodeLangganan,
    String fdKodeHarga,
    String fdKodeDepo,
    String fdKodeSF,
    String fdTanggal,
    List<mbrg.BarangSelected> listKeranjang) async {
  try {
    // List<Map<String, dynamic>> fdData = [];

    // for (var element in listKeranjang) {
    //   var barangExtra = mbrg.JsonBarangExtra(
    //     fdKodeDepo: fdKodeDepo,
    //     fdKodeSF: fdKodeSF,
    //     fdPromisi: 1,
    //     fdKodeBarang: element.fdKodeBarang,
    //     fdQtyInput: element.fdQty?.toDouble() ?? 0.0,
    //     fdSatuan: element.fdJenisSatuan ?? 0,
    //     fdLastUpdate: '',
    //   );

    //   fdData.add(barangExtra.toJson());
    // }
    List<Map<String, dynamic>> detailList = [];

    for (var barang in listKeranjang) {
      var fdPromosi = barang.fdPromosi.toString() == '0' ? 'T' : 'Y';
      detailList.add({
        "fdKodeBarang": barang.fdKodeBarang,
        "fdQty": (barang.fdQty ?? 0).toString(),
        "fdJenisSatuan": (barang.fdJenisSatuan ?? 0).toString(),
        "fdPromosi": fdPromosi,
        "fdUnitPrice": barang.fdUnitPrice?.toString() ?? "0",
        "fdTotalPrice": "0",
      });
    }

    Map<String, dynamic> fdData = {
      "header": {
        "fdKodeLangganan": fdKodeLangganan,
        "fdKodeHarga": fdKodeHarga,
        "fdKodeDepo": fdKodeDepo,
        "fdKodeSF": fdKodeSF,
        "fdTanggal": fdTanggal,
        "detail": detailList
      }
    };

    String jsonVal = jsonEncode(fdData);

    Map<String, dynamic> params = {
      "FdTable": 'sfa',
      "FdNoOrder": '',
      "FdData": jsonVal
    };

    print(jsonVal);
    print(params);
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataDiskonBarangExtra'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    debugPrint(jsonVal);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mbrg.BarangSelected> items = [];
      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.BarangSelected.setDataBarangExtra(element));
        }

        return items;
      } else {
        List<mbrg.BarangSelected> items = [];
        return items;
        // throw ('Data barang extra tidak ada');
      }
    } else if (response.statusCode == 401) {
      List<mbrg.BarangSelected> items = [];
      return items;
    } else {
      List<mbrg.BarangSelected> items = [];
      return items;
      // throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    List<mbrg.BarangSelected> items = [
      mbrg.BarangSelected(
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdQty: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdJenisSatuan: 0,
        fdNamaJenisSatuan: '',
        fdPromosi: '1',
        fdUnitPrice: 0,
        fdTotalPrice: 0,
        fdLastUpdate: '',
        message: '$e , Barang Extra tidak dapat dicek',
      )
    ];
    return items;
  }
}

Future<List<mbrg.JsonBarangDiskon>> getDataDiskonBarang(
    String token,
    String fdKodeLangganan,
    String fdKodeHarga,
    String fdKodeDepo,
    String fdKodeSF,
    String fdTanggal,
    List<mbrg.BarangSelected> listKeranjang) async {
  try {
    List<Map<String, dynamic>> detailList = [];

    for (var barang in listKeranjang) {
      var fdPromosi = barang.fdPromosi.toString() == '0' ? 'T' : 'Y';
      detailList.add({
        "fdKodeBarang": barang.fdKodeBarang,
        "fdQty": (barang.fdQty ?? 0).toString(),
        "fdJenisSatuan": (barang.fdJenisSatuan ?? 0).toString(),
        "fdPromosi": fdPromosi,
        "fdUnitPrice": barang.fdUnitPrice?.toString() ?? "0",
        "fdTotalPrice": "0",
      });
    }

    Map<String, dynamic> fdData = {
      "header": {
        "fdKodeLangganan": fdKodeLangganan,
        "fdKodeHarga": fdKodeHarga,
        "fdKodeDepo": fdKodeDepo,
        "fdKodeSF": fdKodeSF,
        "fdTanggal": fdTanggal,
        "detail": detailList
      }
    };

    String jsonVal = jsonEncode(fdData);
    print('1');
    print(jsonVal);
    Map<String, dynamic> params = {
      "FdTable": 'sfa',
      "FdNoOrder": '',
      "FdData": jsonVal
    };
    print(params);
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataDiskonBarang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mbrg.JsonBarangDiskon> items = [];
      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.JsonBarangDiskon.setData(element));
        }

        return items;
      } else {
        List<mbrg.JsonBarangDiskon> items = [];
        return items;
        // throw ('Data barang extra tidak ada');
      }
    } else if (response.statusCode == 401) {
      List<mbrg.JsonBarangDiskon> items = [];
      return items;
    } else {
      List<mbrg.JsonBarangDiskon> items = [];
      return items;
      // throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    List<mbrg.JsonBarangDiskon> items = [
      mbrg.JsonBarangDiskon(
        fdKodeBarang: '',
        fdQty: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdLastUpdate: '',
        message: '$e , Barang Diskon tidak dapat dicek',
      )
    ];
    return items;
  }
}

Future<int> getAllGroupBarang(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataGroupBarang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.GroupBarang> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.GroupBarang.fromJson(element));
        }

        await cbrg.insertGroupBarangBatch(items);

        return 1;
      } else {
        throw ('Data group barang tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllBarangSales(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataBarangSales'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      if (jsonResult["FdData"] == null) {
        return 1;
      } else {
        List<dynamic> jsonBody = jsonResult["FdData"];
        List<mbrg.BarangSales> items = [];

        if (jsonBody.isNotEmpty) {
          for (var element in jsonBody) {
            items.add(mbrg.BarangSales.fromJson(element));
          }

          await cbrg.insertBarangSalesBatch(items);

          return 1;
        } else {
          throw ('Data barang sales tidak ada');
        }
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDataGudangSales(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataGudangSales'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      if (jsonResult["FdData"] == null) {
        return 1;
      } else {
        List<dynamic> jsonBody = jsonResult["FdData"];
        List<msf.GudangSales> items = [];

        if (jsonBody.isNotEmpty) {
          for (var element in jsonBody) {
            items.add(msf.GudangSales.fromJson(element));
          }

          await csf.insertGudangSalesBatch(items);

          return 1;
        } else {
          throw ('Data barang sales tidak ada');
        }
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllBranding(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataBranding'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbr.Branding> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbr.Branding.fromJson(element));
        }

        await cbr.insertBrandingBatch(items);

        return 1;
      } else {
        throw ('Data branding tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllPromo(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataPromo'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpro.Promo> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpro.Promo.fromJson(element, 1));
        }
        print('jumlah ${items.length}');

        await cpro.insertPromoBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllPromoBarang(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataPromoBarang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpro.PromoBarang> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpro.PromoBarang.fromJson(element, 1));
        }
        print('jumlah ${items.length}');

        await cpro.insertPromoBarangBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllDataDiskon(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetAllDataDiskon'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mdisc.Diskon> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mdisc.Diskon.fromJson(element));
        }

        await cdisc.insertDiskonBatch(items);

        return 1;
      } else {
        throw ('Data Diskon tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllDataDiskonDetail(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetAllDataDiskonDetail'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mdisc.DiskonDetail> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mdisc.DiskonDetail.fromJson(element));
        }

        await cdisc.insertDiskonDetailBatch(items);

        return 1;
      } else {
        throw ('Data Diskon Detail tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getListNotif(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF, //'412040',
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetListNotif'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);

      if (jsonResult["FdData"] != null &&
          (jsonResult["FdData"] as List).isNotEmpty) {
        List<dynamic> jsonBody = jsonResult["FdData"];
        return List<Map<String, dynamic>>.from(jsonBody);
      } else {
        return [];
      }
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendSalesActtoServer(
    msf.Salesman user,
    String fdStartDate,
    String fdEndDate,
    String fdKodeLangganan,
    String fdJenisActivity,
    int fdKM,
    String fdPhoto,
    double fdLA,
    double fdLG,
    String? fdBattery,
    String? fdStreet,
    String? fdSubLocality,
    String? fdSubArea,
    String? fdPostalCode,
    String fdLastUpdate,
    String fdTanggal) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    Map<String, dynamic> item = {
      "fdDepo": user.fdKodeDepo,
      "fdKodeSF": user.fdKodeSF,
      "fdKodeLangganan": fdKodeLangganan,
      "fdJenisActivity": fdJenisActivity,
      "fdKM": fdKM,
      "fdPhoto": fdPhoto,
      "fdStartDate": fdStartDate,
      "fdEndDate": fdEndDate,
      "fdLA": fdLA,
      "fdLG": fdLG,
      "fdBattery": fdBattery,
      "fdStreet": fdStreet,
      "fdSubLocality": fdSubLocality,
      "fdSubArea": fdSubArea,
      "fdPostalCode": fdPostalCode,
      'fdTanggal': fdTanggal
    };

    fdData.add(item);

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": '0',
      "FdLastUpdate": fdLastUpdate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrSalesActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendAllSalesActToServer(
    msf.Salesman user, List<msf.SalesActivity> items, String fdDate) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = msf.setJsonData(
          element.fdKodeSF,
          element.fdKodeLangganan,
          element.fdKodeDepo,
          element.fdKM,
          element.fdPhoto,
          element.fdJenisActivity,
          element.fdStartDate,
          element.fdEndDate,
          element.fdLA,
          element.fdLG,
          element.fdTanggal,
          element.fdRute,
          element.fdBattery,
          element.fdStreet,
          element.fdSubLocality,
          element.fdSubArea,
          element.fdPostalCode,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": '0',
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrSalesActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> validasiFMsSalesForce(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/ValidasiFMsSalesForce'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.BarangSales> items = [];

      if (jsonBody.isNotEmpty) {
        if (jsonBody[0]["fdMessage"].toString() == '') {
          return 1;
        } else {
          throw (jsonBody[0]["fdMessage"].toString());
        }
      } else {
        throw ('Data barang sales tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> validasiSfaMsRencanaRute(
    String token,
    String fdKodeSF,
    String fdKodeDepo,
    String startDate,
    String endDate,
    String fdAction,
    String fdLastUpdate) async {
  try {
    List<Map<String, dynamic>> fdData = [];
    Map<String, dynamic> item = {
      "fdStartDate": startDate,
      "fdEndDate": endDate,
    };

    fdData.add(item);

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdLastUpdate
    };

    print('json:${jsonEncode(params)}');
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/ValidasiSfaMsRencanaRute'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        if (jsonBody[0]["fdMessage"].toString() == '') {
          return 1;
        } else {
          return 0;
          // throw (jsonBody[0]["fdMessage"].toString());
        }
      } else {
        throw ('Data rencana rute tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendLanggananActToServer(
    msf.Salesman user, List<mlgn.Langganan> items, String fdDate) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = {
        "fdKodeDepo": user.fdKodeDepo,
        "fdKodeSF": user.fdKodeSF,
        "fdKodeLangganan": element.fdKodeLangganan,
        "fdCategory": element.fdCategory,
        "fdKodeReason": element.fdKodeReason,
        "fdReason": element.fdReason,
        "fdKeterangan": element.fdKeterangan,
        "fdPhoto": element.fdPhoto,
        "fdIsPaused": element.fdIsPaused,
        "fdStatusSent": 1,
        "fdLastUpdate": element.fdLastUpdate,
        "fdTanggal": element.fdTanggalActivity
      };

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": '0',
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrLanggananActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<modr.Order> sendOrdertoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<modr.OrderApi> items,
    // List<modr.OrderItem> details,
    int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = modr.setJsonDataOrderApi(
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdNoEntryOrder,
          element.fdTanggal,
          element.fdTotal,
          element.fdTotalK,
          element.fdTotalOrder,
          element.fdTotalOrderK,
          element.fdTanggalKirim,
          element.fdAlamatKirim,
          element.fdNoUrutOrder,
          element.fdKodeBarang,
          element.fdNamaBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQty,
          element.fdQtyK,
          element.fdUnitPrice,
          element.fdUnitPriceK,
          element.fdBrutto,
          element.fdDiscount,
          element.fdDiscountDetail,
          element.fdNetto,
          element.fdNoPromosi,
          element.fdNotes,
          element.fdQtyPBE,
          element.fdQtySJ,
          element.fdStatusRecord,
          element.fdKodeStatus ?? 0,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    // for (var element in items) {
    //   Map<String, dynamic> item = modr.setJsonDataOrder(
    //       element.fdDepo,
    //       element.fdKodeLangganan,
    //       element.fdNoEntryOrder,
    //       element.fdUnitPrice,
    //       element.fdDiscount!,
    //       element.fdTotal,
    //       element.fdQty,
    //       element.fdTotalOrder,
    //       element.fdJenisSatuan,
    //       element.fdTanggalKirim,
    //       element.fdAlamatKirim,
    //       element.fdKodeStatus!,
    //       element.fdLastUpdate);

    //   fdData.add(item);
    // }

    // String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrOrder'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        modr.Order result = modr.Order.fromJson(jsonBody.first);

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
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpiu.FakturApi> sendFakturtoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mpiu.FakturApi> items,
    // List<modr.OrderItem> details,
    int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mpiu.setJsonDataFakturApi(
          element.fdNoEntryFaktur,
          element.fdDepo,
          element.fdJenisFaktur,
          element.fdNoFaktur,
          element.fdTanggalFaktur,
          element.fdTOP,
          element.fdTanggalJT,
          element.fdKodeLangganan,
          element.fdNoEntryProforma,
          element.fdFPajak,
          element.fdPPH,
          element.fdKeterangan,
          element.fdMataUang,
          element.fdKodeSF,
          element.fdKodeAP1,
          element.fdKodeAP2,
          element.fdReasonNotApprove,
          element.fdDisetujuiOleh,
          element.fdKodeStatus ?? 0,
          element.fdTglStatus,
          element.fdKodeGudang,
          element.fdNoOrderSFA,
          element.fdTglSFA,
          element.fdStatusRecord,
          element.fdCreateUserID,
          element.fdCreateTS,
          element.fdUpdateUserID,
          element.fdUpdateTS,
          element.fdNoEntryLama,
          element.fdNoUrutFaktur,
          element.fdNoEntrySJ,
          element.fdNoUrutSJ,
          element.fdNoUrutProforma,
          element.fdKodeBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQty,
          element.fdQtyK,
          element.fdUnitPrice,
          element.fdUnitPriceK,
          element.fdBrutto,
          element.fdDiscount,
          element.fdDiscountDetail,
          element.fdNetto,
          element.fdDPP ?? 0,
          element.fdPPN ?? 0,
          element.fdNoPromosi,
          element.fdStatusSent ?? 0,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrFaktur'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mpiu.FakturApi result = mpiu.FakturApi.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.FakturApi result = mpiu.FakturApi.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.FakturApi result = mpiu.FakturApi.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpiu.SuratJalanApi> sendSuratJalantoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mpiu.SuratJalanApi> items,
    int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mpiu.setJsonDataSuratJalanApi(
          element.fdNoEntrySJ,
          element.fdDepo,
          element.fdJenisSJ,
          element.fdNoSJ,
          element.fdTanggalSJ,
          element.fdKodeLangganan,
          element.fdKodeSF,
          element.fdKodeAP1,
          element.fdKodeAP2,
          element.fdKodeGudang,
          element.fdKodeGudangTujuan,
          element.fdNoEntryProforma,
          element.fdAlamatKirim,
          element.fdKeterangan,
          element.fdNoPolisi,
          element.fdKodeEkspedisi,
          element.fdSupirNama,
          element.fdSupirKTP,
          element.fdArmada,
          element.fdETD,
          element.fdETA,
          element.fdNoContainer,
          element.fdNoSeal,
          element.fdAktTglKirim,
          element.fdAktTglTiba,
          element.fdAktTglSerah,
          element.fdKeteranganPengiriman,
          element.fdIsFaktur,
          element.fdKodeStatus,
          element.fdTglStatus,
          element.fdStatusRecord,
          element.fdKodeStatusGit,
          element.fdTanggalLPB,
          element.fdNoLPB,
          element.fdKeteranganLPB,
          element.fdUserLPB,
          element.fdCreateUserID,
          element.fdCreateTS,
          element.fdUpdateUserID,
          element.fdUpdateTS,
          element.fdNoEntryLama,
          //DETAIL
          element.fdNoUrutSJ,
          element.fdNoEntryOrder,
          element.fdNoUrutOrder,
          element.fdNoUrutProforma,
          element.fdKodeBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQty,
          element.fdQtyK,
          element.fdPalet,
          element.fdDetailPalet,
          element.fdNetWeight,
          element.fdGrossWeight,
          element.fdVolume,
          element.fdNotes,
          element.fdCartonNo,
          element.fdQtyJual,
          element.fdRusakB,
          element.fdRusakS,
          element.fdRusakK,
          element.fdSisaB,
          element.fdSisaS,
          element.fdSisaK,
          element.fdStatusSent ?? 0,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrSuratJalan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mpiu.SuratJalanApi result = mpiu.SuratJalanApi.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.SuratJalanApi result = mpiu.SuratJalanApi.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.SuratJalanApi result = mpiu.SuratJalanApi.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpiu.Payment> sendPaymenttoServer(msf.Salesman user, String fdAction,
    String fdDate, List<mpiu.Payment> items, int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mpiu.setJsonDataPaymentApi(
          element.fdNoEntryFaktur,
          element.fdDepo,
          element.fdTanggal,
          element.fdIdCollection,
          element.fdKodeLangganan,
          element.fdAllocationAmount,
          element.fdStatusSent,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrPayment'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mpiu.Payment result = mpiu.Payment.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.Payment result = mpiu.Payment.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.Payment result = mpiu.Payment.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mcoll.CollectionDetail> sendCollectiontoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mcoll.CollectionDetail> items,
    int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mcoll.setJsonDataCollectionApi(
          element.fdNoEntryFaktur,
          element.fdId.toString(),
          element.fdTipe,
          element.fdKodeLangganan,
          element.fdTanggal,
          element.fdTotalCollection,
          element.fdNoRekeningAsal,
          element.fdFromBank,
          element.fdToBank,
          element.fdNoCollection,
          element.fdTanggalCollection,
          element.fdDueDateCollection,
          element.fdTanggalTerima,
          element.fdBuktiImg,
          element.fdAllocationAmount,
          element.fdStatusSent,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrCollection'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mcoll.CollectionDetail result =
            mcoll.CollectionDetail.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mcoll.CollectionDetail result =
            mcoll.CollectionDetail.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mcoll.CollectionDetail result = mcoll.CollectionDetail.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendStockRequestToServer(
    String fdNoEntryStock,
    msf.Salesman user,
    String startDayDate,
    List<mstk.Stock> header,
    List<mstk.StockItem> items) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    // bool notSent = await cstk.isStockRequestNotSent(
    //     fdNoEntryStock, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    // if (notSent) {
    mstk.StockApi result = await sendStockRequesttoServer(user, '0',
        param.dateTimeFormatDB.format(DateTime.now()), header, items);

    mapResult['fdData'] = result.fdData;
    mapResult['fdMessage'] = result.fdMessage;
    // }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<mstk.StockApi> sendStockRequesttoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mstk.Stock> header,
    List<mstk.StockItem> items) async {
  try {
    List<Map<String, dynamic>> fdDataH = [];
    List<Map<String, dynamic>> fdData = [];

    for (var element in header) {
      Map<String, dynamic> item = mstk.setJsonDataStock(
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdNoEntryStock,
          element.fdNoOrder,
          element.fdTanggal,
          element.fdUnitPrice,
          element.fdDiscount!,
          element.fdTotal,
          element.fdTotalK,
          element.fdQtyStock,
          element.fdQtyStockK,
          element.fdTotalStock,
          element.fdTotalStockK,
          element.fdJenisSatuan,
          element.fdTanggalKirim,
          element.fdAlamatKirim,
          element.fdKodeGudang,
          element.fdKodeGudangSF,
          element.fdKodeStatus ?? 0,
          element.fdNoEntryOrder,
          element.fdNoEntrySJ,
          element.fdLastUpdate);

      fdDataH.add(item);
    }
    for (var element in items) {
      Map<String, dynamic> item = mstk.setJsonDataStockItem(
          element.fdNoEntryStock,
          element.fdNoUrutStock,
          element.fdKodeBarang,
          element.fdNamaBarang,
          element.fdPromosi.toString(),
          element.fdReplacement,
          element.fdJenisSatuan.toString(),
          element.fdQtyStock,
          element.fdQtyStockK,
          element.fdUnitPrice,
          element.fdUnitPriceK,
          element.fdBrutto,
          element.fdDiscount,
          element.fdDiscountDetail,
          element.fdNetto,
          element.fdNoPromosi,
          element.fdNotes,
          element.fdQtyPBE,
          element.fdQtySJ,
          element.fdStatusRecord,
          element.fdKodeStatus,
          element.isHanger,
          element.isShow,
          element.urut,
          element.fdLastUpdate);

      fdData.add(item);
    }
    String jsonValH = jsonEncode(fdDataH);
    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdDataH": jsonValH,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonValH);
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrStockRequest'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mstk.StockApi result = mstk.StockApi.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mstk.StockApi result = mstk.StockApi.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mstk.StockApi result = mstk.StockApi.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<mstk.Stock>> getDataStockRequest(String token, String fdKodeSF,
    String fdKodeDepo, String fdStartDayDate) async {
  List<mstk.Stock> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": fdStartDayDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataStockRequest'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mstk.Stock.fromJson(element));
        }
      }
    } else if (response.statusCode == 401) {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message:
              'Gagal proses outlet non rute. Refresh ulang halaman non rute');

      listItem.add(item);
    }
  } catch (e) {
    mstk.Stock item = mstk.Stock(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdDiscount: 0,
        fdTotal: 0,
        fdTotalK: 0,
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdTotalStock: 0,
        fdTotalStockK: 0,
        fdJenisSatuan: '',
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdLastUpdate: '',
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<List<mstk.Stock>> getDataStockVerification(String token, String fdKodeSF,
    String fdAction, String fdKodeDepo, String fdStartDayDate) async {
  List<mstk.Stock> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdAction": fdAction,
      "FdLastUpdate": fdStartDayDate
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataStockVerification'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mstk.Stock.fromJson(element));
        }
      }
    } else if (response.statusCode == 401) {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mstk.Stock item = mstk.Stock(
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdUnitPrice: 0,
          fdUnitPriceK: 0,
          fdDiscount: 0,
          fdTotal: 0,
          fdTotalK: 0,
          fdQtyStock: 0,
          fdQtyStockK: 0,
          fdTotalStock: 0,
          fdTotalStockK: 0,
          fdJenisSatuan: '',
          fdTanggalKirim: '',
          fdAlamatKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdKodeGudang: '',
          fdKodeGudangSF: '',
          fdLastUpdate: '',
          message:
              'Gagal proses outlet non rute. Refresh ulang halaman non rute');

      listItem.add(item);
    }
  } catch (e) {
    mstk.Stock item = mstk.Stock(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdDiscount: 0,
        fdTotal: 0,
        fdTotalK: 0,
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdTotalStock: 0,
        fdTotalStockK: 0,
        fdJenisSatuan: '',
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdLastUpdate: '',
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<List<mstk.StockVerification>> getDataStockVerificationDetail(
    String token,
    String fdKodeSF,
    String fdAction,
    String fdKodeDepo,
    String fdNoOrderSFA) async {
  List<mstk.StockVerification> listItem = [];
  listItem.clear();

  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdAction": fdAction,
      "FdLastUpdate": fdNoOrderSFA
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataStockVerification'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(seconds: param.minuteTimeout),
            onTimeout: () => chttp.Response('', 400));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          listItem.add(mstk.StockVerification.fromJson(element));
        }
      }
    } else if (response.statusCode == 401) {
      mstk.StockVerification item = mstk.StockVerification(
          fdNoEntryOrder: '',
          fdNoEntrySJ: '',
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdKodeBarang: '',
          fdNamaBarang: '',
          fdQty: 0,
          fdQtyS: 0,
          fdQtyK: 0,
          fdQtyReal: 0,
          fdQtyRealS: 0,
          fdQtyRealK: 0,
          fdJenisSatuan: '',
          fdNamaJenisSatuan: '',
          fdJenisSatuanBS: '',
          fdTanggalKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdLastUpdate: '',
          message: 'Session Expired');

      listItem.add(item);
    } else if (response.statusCode == 400) {
      mstk.StockVerification item = mstk.StockVerification(
          fdNoEntryOrder: '',
          fdNoEntrySJ: '',
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdKodeBarang: '',
          fdNamaBarang: '',
          fdQty: 0,
          fdQtyS: 0,
          fdQtyK: 0,
          fdQtyReal: 0,
          fdQtyRealS: 0,
          fdQtyRealK: 0,
          fdJenisSatuan: '',
          fdNamaJenisSatuan: '',
          fdJenisSatuanBS: '',
          fdTanggalKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdLastUpdate: '',
          message: 'Terjadi timeout, mohon refresh ulang');

      listItem.add(item);
    } else {
      mstk.StockVerification item = mstk.StockVerification(
          fdNoEntryOrder: '',
          fdNoEntrySJ: '',
          fdDepo: '',
          fdKodeLangganan: '',
          fdNoEntryStock: '',
          fdNoOrder: '',
          fdTanggal: '',
          fdKodeBarang: '',
          fdNamaBarang: '',
          fdQty: 0,
          fdQtyS: 0,
          fdQtyK: 0,
          fdQtyReal: 0,
          fdQtyRealS: 0,
          fdQtyRealK: 0,
          fdJenisSatuan: '',
          fdNamaJenisSatuan: '',
          fdJenisSatuanBS: '',
          fdTanggalKirim: '',
          fdKodeStatus: 0,
          fdStatusSent: 0,
          fdLastUpdate: '',
          message:
              'Gagal proses outlet non rute. Refresh ulang halaman non rute');

      listItem.add(item);
    }
  } catch (e) {
    mstk.StockVerification item = mstk.StockVerification(
        fdNoEntryOrder: '',
        fdNoEntrySJ: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdQty: 0,
        fdQtyS: 0,
        fdQtyK: 0,
        fdQtyReal: 0,
        fdQtyRealS: 0,
        fdQtyRealK: 0,
        fdJenisSatuan: '',
        fdNamaJenisSatuan: '',
        fdJenisSatuanBS: '',
        fdTanggalKirim: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: e.toString());

    listItem.add(item);
  }

  return listItem;
}

Future<mstk.StockApi> sendStockVerification(msf.Salesman user, String fdAction,
    String fdDate, List<mstk.StockApi> listitem) async {
  try {
    List<Map<String, dynamic>> detailList = [];

    for (var item in listitem) {
      detailList.add({
        "fdNoEntrySJ": item.fdNoEntrySJ,
      });
    }

    Map<String, dynamic> fdData = {
      "header": {
        "fdDetail": detailList,
        "fdKodeStatusGit": "4",
        "fdTanggalLPB": fdDate,
        "fdKeteranganLPB": "",
        "fdUserID": user.fdKodeSF,
        "fdAction": 1,
      }
    };

    String jsonVal = jsonEncode(fdData);

    Map<String, dynamic> params = {"FdData": jsonVal, "fdAction": '1'};

    print(jsonVal);
    print(params);
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDStockVerification'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    debugPrint(jsonVal);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      if (jsonBody.isNotEmpty) {
        mstk.StockApi items = mstk.StockApi.setData(jsonBody.first);

        return items;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mstk.StockApi items = mstk.StockApi.fromJson(jsonBody);

        return items;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mstk.StockApi items = mstk.StockApi.fromJson(jsonBody);

      return items;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mstk.StockApi> sendStockUnloadingtoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mstk.StockApi> items,
    int isNOO) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mstk.setJsonDataStockApi(
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdNoEntryStock,
          element.fdTanggal,
          element.fdTotal,
          element.fdTotalK,
          element.fdTotalStock,
          element.fdTotalStockK,
          element.fdTanggalKirim,
          element.fdAlamatKirim,
          element.fdKodeGudang,
          element.fdKodeGudangSF,
          element.fdNoUrutStock,
          element.fdKodeBarang,
          element.fdNamaBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQtyStock,
          element.fdQtyStockK,
          element.fdUnitPrice,
          element.fdUnitPriceK,
          element.fdBrutto,
          element.fdDiscount,
          element.fdDiscountDetail,
          element.fdNetto,
          element.fdNoPromosi,
          element.fdNotes,
          element.fdQtyPBE,
          element.fdQtySJ,
          element.fdStatusRecord,
          element.fdKodeStatus ?? 0,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrStockUnloading'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mstk.StockApi result = mstk.StockApi.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mstk.StockApi result = mstk.StockApi.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mstk.StockApi result = mstk.StockApi.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mrrute.RencanaRuteApi> sendRencanaRutetoServer(msf.Salesman user,
    String fdAction, String fdDate, List<mrrute.RencanaRuteApi> items) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mrrute.setJsonDataRencanaRuteApi(
          element.fdKodeDepo,
          element.fdNoRencanaRute,
          element.fdStartDate,
          element.fdEndDate,
          element.fdTanggal,
          element.fdKodeSF,
          element.fdKodeStatus,
          element.fdTanggalRencanaRute,
          element.fdKodeLangganan,
          element.fdNamaLangganan,
          element.fdAlamat,
          element.fdPekan,
          element.fdHari,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };
    print(jsonVal);
    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDMsRencanaRute'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mrrute.RencanaRuteApi result =
            mrrute.RencanaRuteApi.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mrrute.RencanaRuteApi result = mrrute.RencanaRuteApi.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mrrute.RencanaRuteApi result = mrrute.RencanaRuteApi.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpro.PromoActivityServer> sendAllPromoActivitytoServer(
    msf.Salesman user,
    String fdAction,
    String fdDate,
    List<mpro.PromoActivityServer> items) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mpro.setJsonDataPromoActivity(
          element.fdTanggal,
          element.fdKodeBranch,
          element.fdKodeSF,
          element.fdKodeLangganan,
          element.fdKodePromo,
          element.fdKodeBarang,
          element.fdPromoStatus);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrPromoActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        mpro.PromoActivityServer result =
            mpro.PromoActivityServer.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpro.PromoActivityServer result =
            mpro.PromoActivityServer.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpro.PromoActivityServer result =
          mpro.PromoActivityServer.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpiu.FakturExt> sendFakturExttoServer(msf.Salesman user, String fdAction,
    String fdDate, List<mpiu.FakturExt> items, String webPath) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      var fdPath = '';
      if (element.fdPath!.isNotEmpty) {
        var nmfile = element.fdPath.toString();
        var namefile = nmfile.split("/").last;
        fdPath = webPath + namefile;
      }
      Map<String, dynamic> item = mpiu.setJsonDataFakturExt(
          element.fdNoEntry,
          element.fdNoEntryFaktur,
          element.fdNoFaktur,
          element.fdDepo,
          element.fdKodeLangganan,
          element.fdJenis,
          fdPath,
          element.fdTanggal,
          element.fdUrut,
          element.fdStatusSent,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFTrFakturExt'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mpiu.FakturExt result = mpiu.FakturExt.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.FakturExt result = mpiu.FakturExt.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.FakturExt result = mpiu.FakturExt.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpiu.Piutang> sendPiutangtoServer(msf.Salesman user, String fdAction,
    String fdDate, List<mpiu.Piutang> items) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      Map<String, dynamic> item = mpiu.setJsonDataPiutang(
          element.fdTipePiutang,
          element.fdNoEntryFaktur,
          element.fdNoFaktur,
          element.fdDepo,
          element.fdTanggalFaktur,
          element.fdTanggalJT,
          element.fdKodeLangganan,
          element.fdBayar,
          element.fdGiro,
          element.fdGiroTolak,
          element.fdKodeStatus,
          element.fdTglStatus,
          element.fdStatusRecord,
          element.fdNoUrutFaktur,
          element.fdNoEntrySJ,
          element.fdNoUrutSJ,
          element.fdKodeBarang,
          element.fdPromosi,
          element.fdReplacement,
          element.fdJenisSatuan,
          element.fdQty,
          element.fdUnitPrice,
          element.fdBrutto,
          element.fdDiscount,
          element.fdNetto,
          element.fdDPP,
          element.fdPPN,
          element.fdNamaBarang,
          element.fdSatuan,
          element.fdTanggalKirim,
          element.fdNoOrder,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDsfaTrPiuDagang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody.first);

        return result;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody);

        return result;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      mpiu.Piutang result = mpiu.Piutang.fromJson(jsonBody);

      return result;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mlk.LimitKredit> sendLimitKredittoServer(msf.Salesman user,
    String fdAction, String fdDate, List<mlk.LimitKredit> items) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
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

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDFtrLimitKredit'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        print(jsonBody.first);
        mlk.LimitKredit result = mlk.LimitKredit.fromJson(jsonBody.first);

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
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<mpck.Package> getPackage(String appName) async {
  try {
    var params = {
      "FdDepo": '',
      "FdKodeSF": '',
      "FdData": appName,
      "FdLastUpdate": ''
    };

    final response = await chttp.post(Uri.parse('$urlAPILiveMD/GetPackage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(params));

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        mpck.Package result = mpck.Package.fromJson(jsonBody.first);

        return result;
      } else {
        throw Exception('Data tidak ada');
      }
    } else {
      throw Exception('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> getAllReasonNotVisit(msf.Salesman user) async {
  try {
    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdLastUpdate": ''
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetReasonNotVisit'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mlgn.Reason> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlgn.Reason.fromJson(element));
        }
        print('jumlah ${items.length}');

        await clgn.insertReasonBatch(items);

        return 1;
      } else {
        throw Exception('Data rute tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw Exception('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> setGroupLangganan(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataGroupLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mgrouplgn.GroupLangganan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mgrouplgn.GroupLangganan.fromJson(element));
        }
        print('jumlah ${items.length}');

        await cgrouplgn.insertGroupLanggananBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getPiutangDagang(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetPiuDagang'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpiu.Piutang> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpiu.Piutang.fromJson(element));
        }
        print('jumlah ${items.length}');

        await cpiu.insertPiutangBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getPiutangDagangFaktur(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetPiuDagangFaktur'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpiu.Faktur> items = [];
      List<mpiu.FakturItem> detail = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpiu.Faktur.fromJson(element));
          detail.add(mpiu.FakturItem.fromJson(element));
        }
        print('jumlah ${items.length}');

        await cpiu.deleteFakturItemBatch();
        await cpiu.insertFakturItemBatch(detail);
        await cpiu.deleteFakturBatch();
        await cpiu.insertFakturBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getSyncRencanaRute(String token, String? fdKodeSF, String? fdAction,
    String? fdKodeDepo, String? startDayDate) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdAction": fdAction,
    "FdLastUpdate": startDayDate
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetListInvoice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mrrute.RencanaRute> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mrrute.RencanaRute.fromJson(element));
        }
        print('jumlah ${items.length}');

        await crute.insertSyncRencanaRuteBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getSyncRencanaRuteLangganan(String token, String? fdKodeSF,
    String? fdAction, String? fdKodeDepo, String? startDayDate) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdAction": fdAction,
    "FdLastUpdate": startDayDate
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetListInvoice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mrrute.RencanaRuteLangganan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mrrute.RencanaRuteLangganan.fromJson(element));
        }
        print('jumlah ${items.length}');

        await crute.insertSyncRencanaRuteLanggananBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getListInvoice(String token, String? fdKodeSF, String? fdAction,
    String? fdKodeDepo, String? startDayDate) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdAction": fdAction,
    "FdLastUpdate": startDayDate
  };

  try {
    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetListInvoice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mrrute.RencanaRuteFaktur> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mrrute.RencanaRuteFaktur.fromJson(element));
        }
        print('jumlah ${items.length}');

        await crute.insertRencanaRuteFakturBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> setProvinsi(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataPropinsi'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mprov.Propinsi> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mprov.Propinsi.fromJson(element));
        }
        print('jumlah ${items.length}');

        await cprov.insertPropinsiBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> setKabupaten(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataKabupaten'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mkab.Kabupaten> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mkab.Kabupaten.fromJson(element));
        }
        print('jumlah ${items.length}');

        await ckab.insertKabupatenBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> setKecamatan(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataKecamatan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mkec.Kecamatan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mkec.Kecamatan.fromJson(element));
        }
        print('jumlah ${items.length}');

        await ckec.insertKecamatanBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> setKelurahan(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataKelurahan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mkel.Kelurahan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mkel.Kelurahan.fromJson(element));
        }
        print('jumlah ${items.length}');

        await ckel.insertKelurahanBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> setPropinsi(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataPropinsi'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mprov.Propinsi> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mprov.Propinsi.fromJson(element));
        }
        print('jumlah ${items.length}');

        await cprov.insertPropinsiBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> getJenisPromo(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataJenisPromo'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpro.JenisPromo> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpro.JenisPromo.setData(element));
        }
        print('jumlah ${items.length}');

        await cpro.insertJenisPromoBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendLogDevicetoServer(
    String fdKodeDepo,
    String fdKodeSF,
    String fdToken,
    String fdKodeLangganan,
    String fdDateTime) async {
  try {
    List<Map<String, dynamic>> fdData = [];
    List<Map<String, dynamic>> items = [];
    items = await clog.getLogDevice(fdKodeLangganan, fdDateTime);
    for (var element in items) {
      Map<String, dynamic> item = {
        "fdKodeLangganan": fdKodeLangganan,
        "fdLA": element['fdLA'],
        "fdLG": element['fdLG'],
        "fdBattery": element['fdBattery'],
        "fdstreet": element['fdstreet'],
        "fdsubLocality": element['fdsubLocality'],
        "fdsubArea": element['fdsubArea'],
        "fdpostalCode": element['fdpostalCode'],
        "fdEvent": element['fdEvent'],
        "fdTanggal": element['fdTanggal'],
        "fdLastUpdate": element['fdLastUpdate']
      };
      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);
    var params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdData": jsonVal,
      "FdAction": '0',
      "FdLastUpdate": ''
    };

    print('json log:${jsonEncode(params)}');

    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/CRUDFTrLogDevice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $fdToken'
            },
            body: jsonEncode(params));

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        await clog.updateFdStatusSentLogDevice(fdDateTime);
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };
      return jsonBody;
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> sendLogTransaksiByLangganan(
    msf.Salesman user, String tblName, String fdTanggal) async {
  int rowResult = 0;
  List<Map<String, dynamic>> datavalue = [];
  List<dynamic> arrKodeLangganan = [];
  List<String> arrTblName = [];
  List<Map<String, dynamic>> fdData = [];
  Map<String, dynamic> params = {
    "FdDepo": "",
    "FdKodeSF": "",
    "FdData": [],
    "FdAction": 0,
    "FdLastUpdate": ""
  };

  arrTblName.add(mdbconfig.tblSFActivity);
  arrTblName.add(mdbconfig.tblLangganan);
  arrTblName.add(mdbconfig.tblOrder);
  arrTblName.add(mdbconfig.tblOrderItem);
  arrTblName.add(mdbconfig.tblLimitKredit);

  arrKodeLangganan = await clog.getLanggananByTblMD(tblName);

  if (arrKodeLangganan.isNotEmpty) {
    fdData.clear();
    for (var j = 0; j < arrTblName.length; j++) {
      for (var i = 0; i < arrKodeLangganan.length; i++) {
        datavalue = await clog.getDataTblMD(
            arrTblName[j], arrKodeLangganan[i]['fdKodeLangganan']);
        if (datavalue.isNotEmpty) {
          Map<String, dynamic> item = {
            "fdKodeLangganan": arrKodeLangganan[i]['fdKodeLangganan'],
            "fdJson": jsonEncode(datavalue),
            "fdTable": arrTblName[j],
            "fdTanggal": fdTanggal,
            "FdLastUpdate": ""
          };
          fdData.add(item);
          String jsonVal = jsonEncode(fdData);
          print(jsonVal);
          params = {
            "FdDepo": user.fdKodeDepo,
            "FdKodeSF": user.fdKodeSF,
            "FdData": jsonVal,
            "FdAction": 0,
            "FdLastUpdate": ""
          };
        }
      }
    }
    print(params);
    try {
      final response = await chttp
          .post(Uri.parse('$urlAPILiveMD/CRUDFTrLogTransaksi'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${user.fdToken}'
              },
              body: jsonEncode(params))
          .timeout(Duration(seconds: param.minuteTimeout),
              onTimeout: () => chttp.Response('', 400));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonBody = json.decode(response.body);
        List<dynamic> dataJson = jsonBody["FdData"];

        if (dataJson.isNotEmpty) {
          rowResult = 1;
        }
      } else if (response.statusCode == 401) {
        throw ('Permintaan tidak bisa diautentikasi');
      } else if (response.statusCode == 400) {
        throw ('Kirim log transaksi terjadi timeout, mohon coba kembali');
      } else {
        throw ('Terjadi error, mohon coba kembali');
      }
    } catch (e) {
      throw e.toString();
    }
  }
  return rowResult;
}

Future<int> setTipeHarga(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetAllDataTipeHarga'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mtharga.TipeHarga> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mtharga.TipeHarga.setData(element));
        }
        print('jumlah ${items.length}');

        await ctharga.insertTipeHargaBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<void> sendLogTransaction(msf.Salesman user, String fdTanggal) async {
  await sendLogTransaksiByLangganan(user, mdbconfig.tblSFActivity, fdTanggal);
}

Future<int> sendImagetoServer(String filePath, msf.Salesman user,
    String fdKodeLangganan, String fdDate) async {
  File fImg = File(filePath);
  String fileName = cpath.basename(filePath);
  int responseCode =
      await uploadFile(fImg, fileName, user, fdKodeLangganan, fdDate);

  return responseCode;
}

Future<int> sendBackuptoServer(String filePath, msf.Salesman user,
    String fdKodeLangganan, String fdDate) async {
  File fImg = File(filePath);
  String fileName = cpath.basename(filePath);
  int responseCode =
      await uploadBackupFile(fImg, fileName, user, fdKodeLangganan, fdDate);

  return responseCode;
}

Future<Map<String, dynamic>> sendOrderToServer(String fdKodeLangganan,
    msf.Salesman user, String startDayDate, int isNOO) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await codr.isOrderNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<modr.OrderApi> listOrder = await codr.getAllOrderTransaction(
          fdKodeLangganan,
          param.dtFormatDB.format(DateTime.parse(startDayDate)));
      // List<modr.OrderItem> listOrderItem =
      //     await codr.getAllOrderItemTransaction(fdKodeLangganan,
      //         param.dtFormatDB.format(DateTime.parse(startDayDate)));
      modr.Order result = await sendOrdertoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listOrder, isNOO);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendFakturExtToServer(
    String fdKodeLangganan, msf.Salesman user, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await cpiu.isFakturExtNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mpiu.FakturExt> listFakturExt =
          await cpiu.getAllFakturExtTransaction(fdKodeLangganan,
              param.dtFormatDB.format(DateTime.parse(startDayDate)));
      String webPath = param.pathImgServer(
          user.fdKodeDepo, user.fdKodeSF, startDayDate, '$fdKodeLangganan/');
      mpiu.FakturExt result = await sendFakturExttoServer(
          user,
          '0',
          param.dateTimeFormatDB.format(DateTime.now()),
          listFakturExt,
          webPath);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendPiuDagangToServer(
    String fdKodeLangganan, msf.Salesman user, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await cpiu.isPiutangNotSent(fdKodeLangganan);

    if (notSent) {
      //insert ke server => API Server
      List<mpiu.Piutang> listPiuDagang =
          await cpiu.getAllDataPiutang(fdKodeLangganan);
      mpiu.Piutang result = await sendPiutangtoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listPiuDagang);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendLimitKreditToServer(
    String fdKodeLangganan, msf.Salesman user, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await clk.isLimitKreditNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mlk.LimitKredit> listLimitKredit =
          await clk.getAllLimitKreditTransaction(fdKodeLangganan,
              param.dtFormatDB.format(DateTime.parse(startDayDate)));
      mlk.LimitKredit result = await sendLimitKredittoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listLimitKredit);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendFakturToServer(String fdKodeLangganan,
    msf.Salesman user, String startDayDate, int isNOO) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await cpiu.isFakturNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mpiu.FakturApi> listFaktur = await cpiu.getAllFakturTransaction(
          fdKodeLangganan,
          param.dtFormatDB.format(DateTime.parse(startDayDate)));
      mpiu.FakturApi result = await sendFakturtoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listFaktur, isNOO);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendSuratJalanToServer(String fdKodeLangganan,
    msf.Salesman user, String startDayDate, int isNOO) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await cpiu.isSuratJalanNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mpiu.SuratJalanApi> listSuratJalan =
          await cpiu.getAllSuratJalanTransaction(fdKodeLangganan,
              param.dtFormatDB.format(DateTime.parse(startDayDate)));
      mpiu.SuratJalanApi result = await sendSuratJalantoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listSuratJalan, isNOO);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendPaymentToServer(String fdKodeLangganan,
    msf.Salesman user, String startDayDate, int isNOO) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await cpiu.isPaymentNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mpiu.Payment> listPayment = await cpiu.getAllPaymentTransaction(
          fdKodeLangganan,
          param.dtFormatDB.format(DateTime.parse(startDayDate)));
      mpiu.Payment result = await sendPaymenttoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listPayment, isNOO);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendCollectionToServer(String fdKodeLangganan,
    msf.Salesman user, String startDayDate, int isNOO) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await ccoll.isCollectionNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //insert ke server => API Server
      List<mcoll.CollectionDetail> listCollection =
          await ccoll.getAllCollectionTransaction(fdKodeLangganan,
              param.dtFormatDB.format(DateTime.parse(startDayDate)));
      mcoll.CollectionDetail result = await sendCollectiontoServer(user, '0',
          param.dateTimeFormatDB.format(DateTime.now()), listCollection, isNOO);

      mapResult['fdData'] = result.fdData;
      mapResult['fdMessage'] = result.fdMessage;
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendSFActivityToServer(String fdKodeLangganan,
    msf.Salesman user, String dirCameraPath, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await csf.isSalesActNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //send data to server
      List<msf.SalesActivity> listSFAct =
          await csf.getSFActivityByTransLangganan(
              user.fdKodeSF, user.fdKodeDepo, fdKodeLangganan);
      if (listSFAct.isNotEmpty) {
        Map<String, dynamic> result = await sendAllSalesActToServer(
            user, listSFAct, param.dateTimeFormatDB.format(DateTime.now()));

        mapResult['fdData'] = result['fdData'];
        mapResult['fdMessage'] = result['fdMessage'];
      } else {
        mapResult['fdData'] = "2";
        mapResult['fdMessage'] = "";
      }
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendLanggananActivityToServer(
    String fdKodeLangganan,
    msf.Salesman user,
    String dirCameraPath,
    String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  try {
    bool notSent = await clgn.isLanggananActNotSent(
        fdKodeLangganan, param.dtFormatDB.format(DateTime.parse(startDayDate)));

    if (notSent) {
      //send data to server
      List<mlgn.Langganan> listLgnAct = await clgn.getLanggananActivity(
          fdKodeLangganan, user.fdKodeSF, user.fdKodeDepo);
      Map<String, dynamic> result = await sendLanggananActToServer(
          user, listLgnAct, param.dateTimeFormatDB.format(DateTime.now()));

      mapResult['fdData'] = result['fdData'];
      mapResult['fdMessage'] = result['fdMessage'];
    }
  } catch (e) {
    if (e == '500') {
      mapResult['fdData'] = e;
      mapResult['fdMessage'] = 'Error timeout';
    } else {
      mapResult['fdData'] = '0';
      mapResult['fdMessage'] = e;
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendDataPendingToServer(
    msf.Salesman user, String filePath, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  List<msf.SalesActivity> userActs =
      await csf.getTransLanggananNotSent(user.fdKodeSF, user.fdKodeDepo);

  if (userActs.isNotEmpty) {
    for (var element in userActs) {
      //Path photo per kode langganan
      String dirCameraPath = '$filePath/${element.fdKodeLangganan}';

      mapResult.addAll(await sendNOOToServer(
          element.fdKodeLangganan, user, dirCameraPath, startDayDate));
      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cnoo.updateStatusSentNOObyKodeLangganan(element.fdKodeLangganan);
      } else {
        return mapResult;
      }
      //send data foto
      var fdKodeNoo =
          await cnoo.getKodeNOObyfdKodeLangganan(element.fdKodeLangganan);
      List<mnoo.FotoNOO> listNooFoto =
          await cnoo.getAllFotoNoobyfdKodeNoo(fdKodeNoo);
      var webPath = param.pathImgServer(user.fdKodeDepo, user.fdKodeSF,
          startDayDate, '${element.fdKodeLangganan}/');
      mapResult.addAll(await sendFotoNooServer(
          user,
          element.fdKodeLangganan,
          '0',
          param.dateTimeFormatDB.format(DateTime.now()),
          listNooFoto,
          webPath));
      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cnoo.updateStatusSentNOObyKodeLangganan(element.fdKodeLangganan);
      } else {
        return mapResult;
      }

      //sugeng add send data order
      mapResult.addAll(await sendOrderToServer(
          element.fdKodeLangganan, user, startDayDate, 0));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await codr.updateStatusSentOrder(element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }
      //sugeng end add send data order

      mapResult.addAll(await sendFakturToServer(
          element.fdKodeLangganan, user, startDayDate, 0));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cpiu.updateStatusSentFaktur(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }

      mapResult.addAll(await sendSuratJalanToServer(
          element.fdKodeLangganan, user, startDayDate, 0));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cpiu.updateStatusSentSuratJalan(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }

      mapResult.addAll(await sendPaymentToServer(
          element.fdKodeLangganan, user, startDayDate, 0));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cpiu.updateStatusSentPayment(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }

      mapResult.addAll(await sendCollectionToServer(
          element.fdKodeLangganan, user, startDayDate, 0));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await ccoll.updateStatusSentCollection(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }

      //sugeng add send data faktur
      mapResult.addAll(await sendFakturExtToServer(
          element.fdKodeLangganan, user, startDayDate));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cpiu.updateStatusSentFakturExt(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }
      //sugeng end add send data faktur

      //sugeng add send data piudagang
      mapResult.addAll(await sendPiuDagangToServer(
          element.fdKodeLangganan, user, startDayDate));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await cpiu.updateStatusSentPiutang(
            element.fdKodeLangganan, startDayDate);
      } else {
        return mapResult;
      }
      //sugeng end add send data piudagang

      //Send file foto zip per langganan ke server
      try {
        String zipFilePath = '$filePath/${element.fdKodeLangganan}.zip';
        var dir = Directory(dirCameraPath);

        if (await dir.exists()) {
          if (!File(zipFilePath).existsSync()) {
            //create zip ulang jika belum ada
            //Zip Folder langganan
            Directory dir = Directory(dirCameraPath);
            String errorMsg =
                await cdb.createZipDirectory(dir.path, zipFilePath);

            if (errorMsg.isNotEmpty) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] =
                  'Error compress file ${element.fdKodeLangganan}: $errorMsg';

              return mapResult;
            }
          }

          int responseCode = await sendImagetoServer(
              zipFilePath, user, element.fdKodeLangganan, startDayDate);

          if (responseCode != 1) {
            if (responseCode == 401) {
              mapResult['fdData'] = '401';
              mapResult['fdMessage'] = '';

              return mapResult;
            } else if (responseCode == 400) {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] = 'Terjadi timeout, mohon coba kembali';

              return mapResult;
            } else {
              mapResult['fdData'] = '0';
              mapResult['fdMessage'] =
                  'Terjadi error kirim foto compress langganan ${element.fdKodeLangganan}, mohon coba kembali';

              return mapResult;
            }
          }
        }
      } catch (e) {
        mapResult['fdData'] = '0';
        mapResult['fdMessage'] = 'Terjadi error: $e, mohon coba kembali';

        return mapResult;
      }

      mapResult.addAll(await sendLanggananActivityToServer(
          element.fdKodeLangganan, user, dirCameraPath, startDayDate));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await clgn.updateStatusSentLanggananAct(
            element.fdKodeLangganan, user.fdKodeDepo, user.fdKodeSF);
      } else {
        return mapResult;
      }

      mapResult.addAll(await sendSFActivityToServer(
          element.fdKodeLangganan, user, dirCameraPath, startDayDate));

      if (mapResult['fdData'] == '2') {
        print(mapResult['fdMessage']);
      } else if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await csf.updateStatusSentSFAct(
            user.fdKodeSF, user.fdKodeDepo, element.fdKodeLangganan, '');
      } else {
        return mapResult;
      }
    }
  }

  return mapResult;
}

Future<Map<String, dynamic>> sendDataPendingLimitKreditToServer(
    msf.Salesman user, String filePath, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};

  //sugeng add send data limit kredit cek yg belum terkirim
  List<mlk.ListLimitKredit> userActsLK =
      await clk.getTransLanggananLimitKreditNotSent(startDayDate);
  if (userActsLK.isNotEmpty) {
    for (var element in userActsLK) {
      //sugeng add send data limit kredit
      mapResult.addAll(await sendLimitKreditToServer(
          element.fdKodeLangganan!, user, startDayDate));

      if (mapResult['fdData'] != '0' &&
          mapResult['fdData'] != '401' &&
          mapResult['fdData'] != '500') {
        await clk.updateStatusSentLimitKredit(
            element.fdKodeLangganan!, startDayDate);
      } else {
        return mapResult;
      }
      //sugeng end add send data limit kredit
    }
  }
  //end sugeng add send data limit kredit cek yg belum terkirim

  return mapResult;
}

Future<Map<String, dynamic>> sendNOOToServer(String fdKodeLangganan,
    msf.Salesman user, String dirCameraPath, String startDayDate) async {
  Map<String, dynamic> mapResult = {'fdData': '', 'fdMessage': ''};
  bool notSent = await cnoo.isTransaksiNooNotSent();

  if (notSent) {
    //insert data
    List<mnoo.NOO> listNoo = await cnoo.getAllNOO(
        user.fdKodeSF, param.dtFormatDB.format(DateTime.parse(startDayDate)));
    String webPath = param.pathImgServer(
        user.fdKodeDepo, user.fdKodeSF, startDayDate, '$fdKodeLangganan/');
    Map<String, dynamic> result = await setNOOtoServer(user, '0',
        param.dateTimeFormatDB.format(DateTime.now()), listNoo, webPath);

    mapResult['fdData'] = result['fdData'];
    mapResult['fdMessage'] = result['fdMessage'];
  }

  return mapResult;
}

Future<Map<String, dynamic>> setNOOtoServer(msf.Salesman user, String fdAction,
    String fdDate, List<mnoo.NOO> items, String webPath) async {
  try {
    List<Map<String, dynamic>> fdData = [];
    String fdFotoNPWP = '';
    String fdFotoKTP = '';
    String fdFotoLuar = '';
    String fdFotoDalam = '';

    for (var element in items) {
      fdFotoNPWP = '';
      fdFotoKTP = '';
      fdFotoLuar = '';
      fdFotoDalam = '';
      if (element.fdNpwpImg!.isNotEmpty) {
        var nmfile = element.fdNpwpImg.toString();
        var namefile = nmfile.split("/").last;
        fdFotoNPWP = webPath + namefile;
      }
      if (element.fdKtpImg!.isNotEmpty) {
        var nmfile = element.fdKtpImg.toString();
        var namefile = nmfile.split("/").last;
        fdFotoKTP = webPath + namefile;
      }
      if (element.fdTokoLuar1!.isNotEmpty) {
        var nmfile = element.fdTokoLuar1.toString();
        var namefile = nmfile.split("/").last;
        fdFotoLuar = webPath + namefile;
      }
      if (element.fdTokoDalam1!.isNotEmpty) {
        var nmfile = element.fdTokoDalam1.toString();
        var namefile = nmfile.split("/").last;
        fdFotoDalam = webPath + namefile;
      }
      Map<String, dynamic> item = mnoo.setJsonData(
          element.fdNoEntryMobile!,
          element.fdKodeNoo!,
          element.fdDepo!,
          element.fdKodeSF,
          element.fdBadanUsaha,
          element.fdNamaToko,
          element.fdOwner,
          element.fdContactPerson,
          element.fdAlamat,
          element.fdPhone,
          element.fdMobilePhone,
          element.fdKelurahan,
          element.fdKodePos,
          element.fdLA,
          element.fdLG,
          element.fdPatokan,
          element.fdTipeOutlet,
          element.fdLimitKredit?.toString(),
          element.fdNPWP,
          element.fdNamaNPWP,
          element.fdAlamatNPWP,
          element.fdNIK,
          element.fdKelasOutlet,
          fdFotoLuar,
          fdFotoNPWP,
          fdFotoDalam,
          fdFotoKTP,
          element.fdKodeRute,
          element.fdStatusSent,
          element.fdLastproses,
          element.fdCreateDate,
          element.fdUpdateDate,
          element.fdKodeLangganan,
          element.fdStatusAktif);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');
    print('jsonVal:${jsonEncode(jsonVal)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDNooToFMsLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };
      return jsonBody;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> setTipeOutlet(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetAllDataTipeOutlet'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mtoutlet.TipeOutlet> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mtoutlet.TipeOutlet.setData(element));
        }
        print('jumlah ${items.length}');

        await ctoutlet.insertTipeOutletBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendFotoNooServer(
    msf.Salesman user,
    String fdKodeLangganan,
    String fdAction,
    String fdDate,
    List<mnoo.FotoNOO> items,
    String webPath) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    for (var element in items) {
      var nmfile = element.fdPath.toString();
      var namefile = nmfile.split("/").last;
      var fdPath = webPath + namefile;
      Map<String, dynamic> item = mnoo.setJsonDataNooFoto(
          element.fdKodeNoo,
          fdKodeLangganan,
          element.fdDepo,
          element.fdKodeSF,
          element.fdJenis,
          element.fdNamaJenis,
          fdPath,
          element.fdFileName,
          element.fdStatusSent,
          element.fdLastUpdate);

      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);

    var params = {
      "FdDepo": user.fdKodeDepo,
      "FdKodeSF": user.fdKodeSF,
      "FdData": jsonVal,
      "FdAction": fdAction,
      "FdLastUpdate": fdDate
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/CRUDNooToFMsLanggananFoto'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user.fdToken}'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw '500';
    });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Fail save photo"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDataParam(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataParam'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mlog.Param> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mlog.Param.fromJson(element));
        }

        await clog.insertParamBatch(items);

        return 1;
      } else {
        throw ('Data tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> sendGPStoServer(
    String fdKodeSF,
    String fdLA,
    String fdLG,
    String fdBattery,
    String? fdstreet,
    String? fdsubLocality,
    String? fdsubArea,
    String? fdpostalCode,
    String? fdEvent,
    String fdKodeLangganan,
    String fdDepo,
    String fdTanggal,
    String fdLastproses) async {
  try {
    List<Map<String, dynamic>> fdData = [];
    for (var i = 0; i < 1; i++) {
      Map<String, dynamic> item = {
        "fdKodeLangganan": fdKodeLangganan,
        "fdLA": fdLA,
        "fdLG": fdLG,
        "fdBattery": fdBattery,
        "fdstreet": fdstreet,
        "fdsubLocality": fdsubLocality,
        "fdsubArea": fdsubArea,
        "fdpostalCode": fdpostalCode,
        "fdEvent": fdEvent,
        "fdTanggal": fdTanggal,
        "fdLastUpdate": param.dateTimeFormatDB.format(DateTime.now())
      };
      fdData.add(item);
    }

    String jsonVal = jsonEncode(fdData);
    var params = {
      "FdDepo": fdDepo,
      "FdKodeSF": fdKodeSF,
      "FdData": jsonVal,
      "FdAction": '0',
      "FdLastUpdate": ''
    };

    print('json:${jsonEncode(params)}');

    final response = await chttp.post(
        Uri.parse('$urlAPILiveMD/CRUDFTrLogDeviceNoToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody.first;
      } else {
        Map<String, dynamic> jsonBody = {
          "fdData": "0",
          "fdMessage": "Data tidak ada"
        };

        return jsonBody;
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };

      return jsonBody;
    } else {
      Map<String, dynamic> jsonBody = {
        "fdData": response.statusCode.toString(),
      };
      return jsonBody;
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getStatusInitData(
    String fdKodeSF, String fdKey, String fdSIM) async {
  try {
    List<Map<String, dynamic>> fdData = [];

    Map<String, dynamic> item = {
      'fdKodeSF': fdKodeSF,
      'fdKey': fdKey,
      'fdSIM': fdSIM
    };

    fdData.add(item);

    String jsonVal = jsonEncode(fdData);

    Map<String, dynamic> params = {
      "FdDepo": "",
      "FdKodeSF": fdKodeSF,
      'FdData': jsonVal,
      "FdLastUpdate": ""
    };

    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetStatusInitData'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        return jsonBody[0]["fdData"];
      } else {
        throw ('Data menu tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> getKeyDevice(String fdKodeSF) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": "",
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp.post(Uri.parse('$urlAPILiveMD/GetKeyDevice'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];

      if (jsonBody.isNotEmpty) {
        Map<String, dynamic> item = {};

        item['fdKeyDevice'] = jsonBody[0]['fdKeyDevice'];
        item['fdSIM'] = jsonBody[0]['fdMobileNo'];
        item['data'] = '';

        return item;
      } else {
        throw ('Data menu tidak ada');
      }
    } else if (response.statusCode == 401) {
      Map<String, dynamic> item = {};

      item['data'] = response.statusCode.toString();

      return item;
    } else {
      throw ('Tidak menemukan Key Device, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDataPromoGroupLangganan(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataPromoGroupLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpro.PromoGroupLangganan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpro.PromoGroupLangganan.fromJson(element, 1));
        }
        print('jumlah ${items.length}');

        await cpro.insertPromoGroupLanggananBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDataPromoLangganan(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataPromoLangganan'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mpro.PromoLangganan> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mpro.PromoLangganan.fromJson(element, 1));
        }
        print('jumlah ${items.length}');

        await cpro.insertPromoLanggananBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getAllDataTipeDetail(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/GetAllDataTipeDetail'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];
      List<mdetail.TipeDetail> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mdetail.TipeDetail.fromJson(element));
        }

        await cdetail.insertTipeDetailBatch(items);

        return 1;
      } else {
        return 0;
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<void> showlog(String log) async {
  print(log);
  await Future.delayed(const Duration(seconds: 1));
}

void showDownloadProgress(double p, int r, int fileSize) {
  print('downloaded :$r byte =========> $p%');
}

Future<String?> sendNotifOrder(
    String token, String? fdKodeSF, String? fdKodeDepo) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdAction": 'order',
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/NotifFromDevice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          final notificationService = cnotif.NotificationService();
          notificationService.sendPushMessage(
            token: element['fdToken'],
            title: "Notifikasi CRM",
            body: "Notifikasi Approval Order",
            gotopage: element['fdUrl'],
          );
        }

        return '1';
      } else {
        return 'Notifikasi tidak terkirim';
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    // throw Exception(e);
    return "Notifikasi tidak terkirim ($e)";
  }
}

Future<String?> sendNotifCanvas(
    String token, String? fdKodeSF, String? fdKodeDepo, String textBody) async {
  Map<String, dynamic> params = {
    "FdDepo": fdKodeDepo,
    "FdKodeSF": fdKodeSF,
    "FdAction": 'order',
    "FdLastUpdate": ""
  };

  try {
    final response =
        await chttp.post(Uri.parse('$urlAPILiveMD/NotifFromDevice'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"] ?? [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          final notificationService = cnotif.NotificationService();
          notificationService.sendPushMessage(
            token: element['fdToken'],
            title: "Notifikasi CRM",
            body: textBody,
            gotopage: element['fdUrl'],
          );
        }

        return '1';
      } else {
        return 'Notifikasi tidak terkirim';
      }
    } else if (response.statusCode == 401) {
      throw ('Permintaan tidak bisa diautentikasi');
    } else {
      throw ('Data tidak ada');
    }
  } catch (e) {
    // throw Exception(e);
    return "Notifikasi tidak terkirim ($e)";
  }
}

Future<int> getMasterHanger(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataMasterHanger'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.Hanger> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.Hanger.fromJson(element));
        }

        await cbrg.insertHangerBatch(items);

        return 1;
      } else {
        throw ('Data hanger tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getDetailMasterHanger(
    String token, String fdKodeSF, String fdKodeDepo) async {
  try {
    Map<String, dynamic> params = {
      "FdDepo": fdKodeDepo,
      "FdKodeSF": fdKodeSF,
      "FdLastUpdate": ""
    };

    final response = await chttp
        .post(Uri.parse('$urlAPILiveMD/GetDataDetailMasterHanger'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(params))
        .timeout(Duration(minutes: param.minuteTimeout), onTimeout: () {
      throw 408;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResult = jsonDecode(response.body);
      List<dynamic> jsonBody = jsonResult["FdData"];
      List<mbrg.HangerDetail> items = [];

      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          items.add(mbrg.HangerDetail.fromJson(element));
        }

        await cbrg.insertHangerDetailBatch(items);

        return 1;
      } else {
        throw ('Data detail hanger tidak ada');
      }
    } else if (response.statusCode == 401) {
      return response.statusCode;
    } else {
      throw ('Terjadi error, mohon coba kembali');
    }
  } catch (e) {
    rethrow;
  }
}
