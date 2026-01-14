class LogDevice {
  final String fdLA;
  final String fdLG;
  final String fdBattery;
  final String fdstreet;
  final String fdsubLocality;
  final String fdsubArea;
  final String fdpostalCode;
  final String fdTanggal;
  final int fdStatusSent;
  final String? fdLastUpdate;
  String? fdData;
  String? fdMessage;

  LogDevice(
      {required this.fdLA,
      required this.fdLG,
      required this.fdBattery,
      required this.fdstreet,
      required this.fdsubLocality,
      required this.fdsubArea,
      required this.fdpostalCode,
      required this.fdTanggal,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory LogDevice.setData(Map<String, dynamic> item) {
    return LogDevice(
        fdLA: item['fdLA'] ?? '',
        fdLG: item['fdLG'] ?? '',
        fdBattery: item['fdBattery'] ?? '',
        fdstreet: item['fdstreet'] ?? '',
        fdsubLocality: item['fdsubLocality'] ?? '',
        fdsubArea: item['fdsubArea'] ?? '',
        fdpostalCode: item['fdpostalCode'] ?? '',
        fdTanggal: item['fdTanggal'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory LogDevice.fromJson(Map<String, dynamic> json) {
    return LogDevice(
        fdLA: json['fdLA'] ?? '',
        fdLG: json['fdLG'] ?? '',
        fdBattery: json['fdBattery'] ?? '',
        fdstreet: json['fdstreet'] ?? '',
        fdsubLocality: json['fdsubLocality'] ?? '',
        fdsubArea: json['fdsubArea'] != null ? json['fdsubArea'] : '',
        fdpostalCode: json['fdpostalCode'] != null ? json['fdpostalCode'] : '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }
}

Map<String, dynamic> setJsonData(
    String fdLA,
    String fdLG,
    String fdBattery,
    String fdstreet,
    String fdsubArea,
    String fdpostalCode,
    String fdTanggal,
    int fdStatusSent) {
  return <String, dynamic>{
    "fdLA": fdLA,
    "fdLG": fdLG,
    "fdstreet": fdstreet,
    "fdBattery": fdBattery,
    "fdsubArea": fdsubArea,
    "fdpostalCode": fdpostalCode,
    "fdTanggal": fdTanggal,
    "fdStatusSent": fdStatusSent
  };
}

class Param {
  final String fdKodeSF;
  final String fdType;
  final int fdDuration;
  final int fdMaxRute;
  final int fdMaxPause;
  final int fdMaxDistance;
  final int fdMaxBackup;
  final int fdTimeoutGps;
  final int fdTimeoutApi;
  final int fdPPN;
  String? fdData;
  String? fdMessage;

  Param(
      {required this.fdKodeSF,
      required this.fdType,
      required this.fdDuration,
      required this.fdMaxRute,
      required this.fdMaxPause,
      required this.fdMaxDistance,
      required this.fdMaxBackup,
      required this.fdTimeoutGps,
      required this.fdTimeoutApi,
      required this.fdPPN,
      this.fdData,
      this.fdMessage});

  factory Param.setData(Map<String, dynamic> item) {
    return Param(
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdType: item['fdType'] ?? '',
      fdDuration: item['fdDuration'] ?? 0,
      fdMaxRute: item['fdMaxRute'] ?? 0,
      fdMaxPause: item['fdMaxPause'] ?? 0,
      fdMaxDistance: item['fdMaxDistance'] ?? 0,
      fdMaxBackup: item['fdMaxBackup'] ?? 0,
      fdTimeoutGps: item['fdTimeoutGps'] ?? 0,
      fdTimeoutApi: item['fdTimeoutApi'] ?? 0,
      fdPPN: item['fdPPN'] ?? 0,
    );
  }

  factory Param.fromJson(Map<String, dynamic> json) {
    return Param(
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdType: json['fdType'] ?? '',
      fdDuration: json['fdDuration'] ?? 0,
      fdMaxRute: json['fdMaxRute'] ?? 0,
      fdMaxPause: json['fdMaxPause'] ?? 0,
      fdMaxDistance: json['fdMaxDistance'] ?? 0,
      fdMaxBackup: json['fdMaxBackup'] ?? 0,
      fdTimeoutGps: json['fdTimeoutGps'] ?? 0,
      fdTimeoutApi: json['fdTimeoutApi'] ?? 0,
      fdPPN: json['fdPPN'] ?? 0,
      fdData: json['fdData'] ?? '',
      fdMessage: json['fdMessage'] ?? '',
    );
  }
}

Map<String, dynamic> setJsonParam(String fdKodeSF, String fdType,
    int fdDuration, int fdMaxRute, int fdMaxPause, int fdMaxDistance) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdType": fdType,
    "fdDuration": fdDuration,
    "fdMaxRute": fdMaxRute,
    "fdMaxPause": fdMaxPause,
    "fdMaxDistance": fdMaxDistance
  };
}

class Salesman {
  final String fdKodeSF;
  final String fdNamaSF;
  final String fdKodeDepo;
  final String fdNamaDepo;
  final String fdTipeSF;
  final String fdToken;
  bool? fdAkses;
  final String? message;
  final String fdLoginDate;

  Salesman(
      {required this.fdKodeSF,
      required this.fdNamaSF,
      required this.fdKodeDepo,
      required this.fdNamaDepo,
      required this.fdTipeSF,
      required this.fdToken,
      required this.fdLoginDate,
      this.fdAkses,
      this.message});

  factory Salesman.setData(Map<String, dynamic> item) {
    return Salesman(
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaSF: item['fdNamaSF'] ?? '',
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdNamaDepo: item['fdNamaDepo'] ?? '',
      fdTipeSF: item['fdTipeSF'] ?? '',
      fdToken: item['fdToken'] ?? '',
      fdLoginDate: item['fdLoginDate'] ?? '',
    );
  }

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      fdKodeSF: json['FdKodeSF'] ?? '',
      fdNamaSF: json['FdNamaSF'] ?? '',
      fdKodeDepo: json['FdKodeDepo'] ?? '',
      fdNamaDepo: json['FdNamaDepo'] ?? '',
      fdTipeSF: json['FdTipeSF'] ?? '',
      fdToken: json['FdToken'] ?? '',
      fdAkses: json['FdAkses'] ?? false,
      message: json['FdMessage'] ?? '',
      fdLoginDate: json['FdLoginDate'] ?? '',
    );
  }
}
