class Salesman {
  final String fdKodeSF;
  final String fdNamaSF;
  final String fdKodeDepo;
  final String fdNamaDepo;
  final String fdTipeSF;
  final String fdToken;
  String? fdPass;
  bool? fdAkses;
  final String? message;
  final String fdLoginDate;
  final String fdKeyDevice;
  final String fdMobileNo;
  final String fdVersion;

  Salesman({
    required this.fdKodeSF,
    required this.fdNamaSF,
    required this.fdKodeDepo,
    required this.fdNamaDepo,
    required this.fdTipeSF,
    required this.fdToken,
    required this.fdLoginDate,
    this.fdPass,
    this.fdAkses,
    this.message,
    required this.fdKeyDevice,
    required this.fdMobileNo,
    required this.fdVersion,
  });

  factory Salesman.setData(Map<String, dynamic> item) {
    return Salesman(
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaSF: item['fdNamaSF'] ?? '',
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdNamaDepo: item['fdNamaDepo'] ?? '',
      fdTipeSF: item['fdTipeSF'] ?? '',
      fdToken: item['fdToken'] ?? '',
      fdPass: item['fdPass'] ?? '',
      fdLoginDate: item['fdLoginDate'] ?? '',
      fdKeyDevice: item['fdKeyDevice'] ?? '',
      fdMobileNo: item['fdMobileNo'] ?? '',
      fdVersion: item['fdVersion'] ?? '',
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
      fdPass: json['FdPassword'] ?? '',
      fdAkses: json['FdAkses'] ?? false,
      message: json['FdMessage'] ?? '',
      fdLoginDate: json['FdLoginDate'] ?? '',
      fdKeyDevice: json['FdKeyDevice'] ?? '',
      fdMobileNo: json['FdMobileNo'] ?? '',
      fdVersion: json['FdVersion'] ?? '',
    );
  }
}

class SalesActivity {
  final String fdKodeSF;
  final String fdKodeDepo;
  final int fdKM;
  final String fdPhoto;
  final String fdKodeLangganan;
  final String fdJenisActivity;
  final String fdStartDate;
  final String fdEndDate;
  final double fdLA;
  final double fdLG;
  final String fdTanggal;
  final int fdIsPaused;
  final int fdRute;
  final int fdStatusSent;
  final String fdBattery;
  final String fdStreet;
  final String fdSubLocality;
  final String fdSubArea;
  final String fdPostalCode;
  final String fdLastUpdate;

  const SalesActivity(
      {required this.fdKodeSF,
      required this.fdKodeDepo,
      required this.fdKM,
      required this.fdKodeLangganan,
      required this.fdJenisActivity,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdLA,
      required this.fdPhoto,
      required this.fdLG,
      required this.fdTanggal,
      required this.fdIsPaused,
      required this.fdRute,
      required this.fdStatusSent,
      required this.fdBattery,
      required this.fdStreet,
      required this.fdSubLocality,
      required this.fdSubArea,
      required this.fdPostalCode,
      required this.fdLastUpdate});

  factory SalesActivity.setData(Map<String, dynamic> item) {
    return SalesActivity(
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdKM: item['fdKM'] ?? 0,
      fdPhoto: item['fdPhoto'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdJenisActivity: item['fdJenisActivity'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdLA: item['fdLA'] ?? 0,
      fdLG: item['fdLG'] ?? 0,
      fdTanggal: item['fdTanggal'] ?? '',
      fdIsPaused: item['fdIsPaused'] ?? 0,
      fdRute: item['fdRute'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdBattery: item['fdBattery'] ?? '',
      fdStreet: item['fdStreet'] ?? '',
      fdSubLocality: item['fdSubLocality'] ?? '',
      fdSubArea: item['fdSubArea'] ?? '',
      fdPostalCode: item['fdPostalCode'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory SalesActivity.fromJson(Map<String, dynamic> json) {
    return SalesActivity(
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdKodeDepo: json['fdKodeDepo'] ?? '',
      fdKM: json['fdKM'] ?? 0,
      fdPhoto: json['fdPhoto'] ?? '',
      fdKodeLangganan: json['fdKodeLangganan'] ?? '',
      fdJenisActivity: json['fdJenisActivity'] ?? '',
      fdStartDate: json['fdStartDate'] ?? '',
      fdEndDate: json['fdEndDate'] ?? '',
      fdLA: json['fdLA'].isEmpty ? 0 : json['fdLA'].toDouble(),
      fdLG: json['fdLG'].isEmpty ? 0 : json['fdLA'].toDouble(),
      fdTanggal: json['fdTanggal'] ?? '',
      fdIsPaused: json['fdIsPaused'] ?? 0,
      fdRute: json['fdRute'] ?? 0,
      fdStatusSent: json['fdStatusSent'] ?? 0,
      fdBattery: json['fdBattery'] ?? '',
      fdStreet: json['fdStreet'] ?? '',
      fdSubLocality: json['fdSubLocality'] ?? '',
      fdSubArea: json['fdSubArea'] ?? '',
      fdPostalCode: json['fdPostalCode'] ?? '',
      fdLastUpdate: json['fdLastUpdate'] ?? '',
    );
  }
}

Map<String, dynamic> setJsonData(
    String fdKodeSF,
    String fdKodeLangganan,
    String fdKodeDepo,
    int fdKM,
    String fdPhoto,
    String fdJenisActivity,
    String fdStartDate,
    String fdEndDate,
    double fdLA,
    double fdLG,
    String fdTanggal,
    int fdRute,
    String? fdBattery,
    String? fdStreet,
    String? fdSubLocality,
    String? fdSubArea,
    String? fdPostalCode,
    String fdLastUpdate) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeDepo": fdKodeDepo,
    "fdKM": fdKM,
    "fdPhoto": fdPhoto,
    "fdJenisActivity": fdJenisActivity,
    "fdStartDate": fdStartDate,
    "fdEndDate": fdEndDate,
    "fdLA": fdLA,
    "fdLG": fdLG,
    'fdTanggal': fdTanggal,
    'fdRute': fdRute,
    'fdBattery': fdBattery,
    'fdStreet': fdStreet,
    'fdSubLocality': fdSubLocality,
    'fdSubArea': fdSubArea,
    'fdPostalCode': fdPostalCode,
    'fdLastUpdate': fdLastUpdate
  };
}

class GudangSales {
  final String fdKodeGudang;
  final String fdNamaGudang;
  final String fdKodeGudangSF;
  final String fdNamaGudangSF;
  final String fdKodeDepo;

  const GudangSales(
      {required this.fdKodeGudang,
      required this.fdNamaGudang,
      required this.fdKodeGudangSF,
      required this.fdNamaGudangSF,
      required this.fdKodeDepo});

  factory GudangSales.setData(Map<String, dynamic> item) {
    return GudangSales(
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdNamaGudang: item['fdNamaGudang'] ?? '',
      fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdNamaGudangSF: item['fdNamaGudangSF'] ?? '',
      fdKodeDepo: item['fdKodeDepo'] ?? '',
    );
  }

  factory GudangSales.fromJson(Map<String, dynamic> json) {
    return GudangSales(
      fdKodeGudang: json['fdKodeGudang'] ?? '',
      fdNamaGudang: json['fdNamaGudang'] ?? '',
      fdKodeGudangSF: json['fdKodeGudangSF'] ?? '',
      fdNamaGudangSF: json['fdNamaGudangSF'] ?? '',
      fdKodeDepo: json['fdKodeDepo'] ?? '',
    );
  }
}
