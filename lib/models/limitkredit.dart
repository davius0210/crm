class LimitKredit {
  final String? fdNoLimitKredit;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final double? fdSisaLimit;
  final double? fdPesananBaru;
  final double? fdOverLK;
  final String? fdTglStatus;
  final String? fdTanggal;
  final double fdLimitKredit;
  final double fdPengajuanLimitBaru;
  final int fdKodeStatus;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  LimitKredit(
      {required this.fdNoLimitKredit,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdSisaLimit,
      required this.fdPesananBaru,
      required this.fdOverLK,
      required this.fdTglStatus,
      required this.fdTanggal,
      required this.fdLimitKredit,
      required this.fdPengajuanLimitBaru,
      required this.fdKodeStatus,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory LimitKredit.setData(Map<String, dynamic> item) {
    return LimitKredit(
      fdNoLimitKredit: item['fdNoLimitKredit'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdSisaLimit: item['fdSisaLimit'] ?? 0,
      fdPesananBaru: item['fdPesananBaru'] ?? 0,
      fdOverLK: item['fdOverLK'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdLimitKredit: item['fdLimitKredit'] ?? 0,
      fdPengajuanLimitBaru: item['fdPengajuanLimitBaru'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory LimitKredit.fromJson(Map<String, dynamic> json) {
    return LimitKredit(
        fdNoLimitKredit: json['fdNoLimitKredit'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdSisaLimit: double.tryParse(json['fdSisaLimit'].toString()) != null
            ? json['fdSisaLimit'].toDouble()
            : 0,
        fdPesananBaru: double.tryParse(json['fdPesananBaru'].toString()) != null
            ? json['fdPesananBaru'].toDouble()
            : 0,
        fdOverLK: double.tryParse(json['fdOverLK'].toString()) != null
            ? json['fdOverLK'].toDouble()
            : 0,
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
            ? json['fdLimitKredit'].toDouble()
            : 0,
        fdPengajuanLimitBaru:
            double.tryParse(json['fdPengajuanLimitBaru'].toString()) != null
                ? json['fdPengajuanLimitBaru'].toDouble()
                : 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory LimitKredit.empty() {
    return LimitKredit(
        fdNoLimitKredit: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdSisaLimit: 0,
        fdPesananBaru: 0,
        fdOverLK: 0,
        fdTglStatus: '',
        fdTanggal: '',
        fdLimitKredit: 0,
        fdPengajuanLimitBaru: 0,
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataLimitKredit(
    String? fdNoLimitKredit,
    String? fdDepo,
    String? fdKodeLangganan,
    double? fdSisaLimit,
    double? fdPesananBaru,
    double? fdOverLK,
    String? fdTglStatus,
    String? fdTanggal,
    double fdLimitKredit,
    double fdPengajuanLimitBaru,
    int fdKodeStatus,
    int fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoLimitKredit": fdNoLimitKredit,
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdSisaLimit": fdSisaLimit,
    "fdPesananBaru": fdPesananBaru,
    "fdOverLK": fdOverLK,
    "fdTglStatus": fdTglStatus,
    "fdTanggal": fdTanggal,
    "fdLimitKredit": fdLimitKredit,
    "fdPengajuanLimitBaru": fdPengajuanLimitBaru,
    "fdKodeStatus": fdKodeStatus,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

class ListLimitKredit {
  final String? fdNoLimitKredit;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final double? fdSisaLimit;
  final double? fdPesananBaru;
  final double? fdOverLK;
  final String? fdTglStatus;
  final String? fdTanggal;
  final double fdLimitKredit;
  final String? fdNamaLangganan;
  final double fdTotalOrder;
  final double fdPengajuanLimitBaru;
  final int fdKodeStatus;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  String? fdEndVisitDate;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  ListLimitKredit(
      {required this.fdNoLimitKredit,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdSisaLimit,
      required this.fdPesananBaru,
      required this.fdOverLK,
      required this.fdTglStatus,
      required this.fdTanggal,
      required this.fdLimitKredit,
      required this.fdNamaLangganan,
      required this.fdTotalOrder,
      required this.fdPengajuanLimitBaru,
      required this.fdKodeStatus,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdEndVisitDate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory ListLimitKredit.setData(Map<String, dynamic> item) {
    return ListLimitKredit(
      fdNoLimitKredit: item['fdNoLimitKredit'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdSisaLimit: item['fdSisaLimit'] ?? 0,
      fdPesananBaru: item['fdPesananBaru'] ?? 0,
      fdOverLK: item['fdOverLK'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdLimitKredit: item['fdLimitKredit'] ?? 0,
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdTotalOrder: item['fdTotalOrder'] ?? 0,
      fdPengajuanLimitBaru: item['fdPengajuanLimitBaru'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
      fdEndVisitDate: item['fdEndVisitDate'] ?? '',
    );
  }

  factory ListLimitKredit.fromJson(Map<String, dynamic> json) {
    return ListLimitKredit(
        fdNoLimitKredit: json['fdNoLimitKredit'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdSisaLimit: double.tryParse(json['fdSisaLimit'].toString()) != null
            ? json['fdSisaLimit'].toDouble()
            : 0,
        fdPesananBaru: double.tryParse(json['fdPesananBaru'].toString()) != null
            ? json['fdPesananBaru'].toDouble()
            : 0,
        fdOverLK: double.tryParse(json['fdOverLK'].toString()) != null
            ? json['fdOverLK'].toDouble()
            : 0,
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
            ? json['fdLimitKredit'].toDouble()
            : 0,
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdTotalOrder: double.tryParse(json['fdTotalOrder'].toString()) != null
            ? json['fdTotalOrder'].toDouble()
            : 0,
        fdPengajuanLimitBaru:
            double.tryParse(json['fdPengajuanLimitBaru'].toString()) != null
                ? json['fdPengajuanLimitBaru'].toDouble()
                : 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory ListLimitKredit.empty() {
    return ListLimitKredit(
        fdNoLimitKredit: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdSisaLimit: 0,
        fdPesananBaru: 0,
        fdOverLK: 0,
        fdTglStatus: '',
        fdTanggal: '',
        fdLimitKredit: 0,
        fdNamaLangganan: '',
        fdTotalOrder: 0,
        fdPengajuanLimitBaru: 0,
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        fdEndVisitDate: '',
        message: '');
  }
}
