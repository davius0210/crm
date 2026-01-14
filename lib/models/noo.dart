class NOO {
  String? fdNoEntryMobile;
  String? fdKodeNoo;
  String? fdDepo;
  String? fdKodeSF;
  String? fdBadanUsaha;
  String? fdNamaToko;
  String? fdOwner;
  String? fdContactPerson;
  String? fdPhone;
  String? fdMobilePhone;
  String? fdAlamat;
  String? fdKelurahan;
  String? fdKodePos;
  String? fdLA;
  String? fdLG;
  String? fdPatokan;
  String? fdTipeOutlet;
  double? fdLimitKredit;
  String? fdNPWP;
  String? fdNamaNPWP;
  String? fdAlamatNPWP;
  String? fdNIK;
  String? fdKelasOutlet;
  String? fdTokoLuar1;
  String? fdNpwpImg;
  String? fdTokoDalam1;
  String? fdKtpImg;
  String? fdKodeRute;
  String? fdKodeLangganan;
  int? fdStatusSent;
  int? fdStatusAktif;
  String? fdLastproses;
  String? fdCreateDate;
  String? fdUpdateDate;
  String? fdData;
  String? fdMessage;

  NOO(
      {required this.fdNoEntryMobile,
      required this.fdKodeNoo,
      required this.fdDepo,
      required this.fdKodeSF,
      required this.fdBadanUsaha,
      required this.fdNamaToko,
      required this.fdOwner,
      required this.fdContactPerson,
      required this.fdAlamat,
      required this.fdPhone,
      required this.fdMobilePhone,
      required this.fdKelurahan,
      required this.fdKodePos,
      required this.fdLA,
      required this.fdLG,
      required this.fdPatokan,
      required this.fdTipeOutlet,
      required this.fdLimitKredit,
      required this.fdNPWP,
      required this.fdNamaNPWP,
      required this.fdAlamatNPWP,
      required this.fdNIK,
      required this.fdKelasOutlet,
      required this.fdTokoLuar1,
      required this.fdNpwpImg,
      required this.fdTokoDalam1,
      required this.fdKtpImg,
      required this.fdKodeRute,
      required this.fdKodeLangganan,
      required this.fdStatusSent,
      required this.fdStatusAktif,
      required this.fdLastproses,
      required this.fdCreateDate,
      required this.fdUpdateDate});

  factory NOO.setData(Map<String, dynamic> item) {
    return NOO(
      fdNoEntryMobile: item['fdNoEntryMobile'] ?? '',
      fdKodeNoo: item['fdKodeNoo'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdBadanUsaha: item['fdBadanUsaha'] ?? '',
      fdNamaToko: item['fdNamaToko'] ?? '',
      fdOwner: item['fdOwner'] ?? '',
      fdContactPerson: item['fdContactPerson'] ?? '',
      fdPhone: item['fdPhone'] ?? '',
      fdMobilePhone: item['fdMobilePhone'] ?? '',
      fdAlamat: item['fdAlamat'] ?? '',
      fdKelurahan: item['fdKelurahan'] ?? '',
      fdKodePos: item['fdKodePos'] ?? '',
      fdLA: item['fdLA'] ?? '',
      fdLG: item['fdLG'] ?? '',
      fdPatokan: item['fdPatokan'] ?? '',
      fdTipeOutlet: item['fdTipeOutlet'] ?? '',
      fdLimitKredit: double.tryParse(item['fdLimitKredit'].toString()) != null
          ? item['fdLimitKredit'].toDouble()
          : 0,
      fdNPWP: item['fdNPWP'] ?? '',
      fdNamaNPWP: item['fdNamaNPWP'] ?? '',
      fdAlamatNPWP: item['fdAlamatNPWP'] ?? '',
      fdNIK: item['fdNIK'] ?? '',
      fdKelasOutlet: item['fdKelasOutlet'] ?? '',
      fdTokoLuar1: item['fdTokoLuar1'] ?? '',
      fdNpwpImg: item['fdNpwpImg'] ?? '',
      fdTokoDalam1: item['fdTokoDalam1'] ?? '',
      fdKtpImg: item['fdKtpImg'] ?? '',
      fdKodeRute: item['fdKodeRute'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdStatusSent: item['fdUpload'] ?? 0,
      fdStatusAktif: item['fdStatusAktif'] ?? 3, //3=void
      fdLastproses: item['fdLastproses'] ?? '',
      fdCreateDate: item['fdCreateDate'] ?? '',
      fdUpdateDate: item['fdUpdateDate'] ?? '',
    );
  }

  factory NOO.fromJson(Map<String, dynamic> json) {
    return NOO(
      fdNoEntryMobile: json['fdNoEntryMobile'] ?? '',
      fdKodeNoo: json['fdKodeNoo'] ?? '',
      fdDepo: json['fdDepo'] ?? '',
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdBadanUsaha: json['fdBadanUsaha'] ?? '',
      fdNamaToko: json['fdNamaToko'] ?? '',
      fdOwner: json['fdOwner'] ?? '',
      fdContactPerson: json['fdContactPerson'] ?? '',
      fdPhone: json['fdPhone'] ?? '',
      fdMobilePhone: json['fdMobilePhone'] ?? '',
      fdAlamat: json['fdAlamat'] ?? '',
      fdKelurahan: json['fdKelurahan'] ?? '',
      fdKodePos: json['fdKodePos'] ?? '',
      fdLA: json['fdLA'] ?? '',
      fdLG: json['fdLG'] ?? '',
      fdPatokan: json['fdPatokan'] ?? '',
      fdTipeOutlet: json['fdTipeOutlet'] ?? '',
      fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
          ? json['fdLimitKredit'].toDouble()
          : 0,
      fdNPWP: json['fdNPWP'] ?? '',
      fdNamaNPWP: json['fdNamaNPWP'] ?? '',
      fdAlamatNPWP: json['fdAlamatNPWP'] ?? '',
      fdNIK: json['fdNIK'] ?? '',
      fdKelasOutlet: json['fdKelasOutlet'] ?? '',
      fdTokoLuar1: json['fdTokoLuar1'] ?? '',
      fdNpwpImg: json['fdNpwpImg'] ?? '',
      fdTokoDalam1: json['fdTokoDalam1'] ?? '',
      fdKtpImg: json['fdKtpImg'] ?? '',
      fdKodeRute: json['fdKodeRute'] ?? '',
      fdKodeLangganan: json['fdKodeLangganan'] ?? '',
      fdStatusSent: json['fdStatusSent'] ?? 0,
      fdStatusAktif: json['fdStatusAktif'] ?? 3,
      fdLastproses: json['fdLastproses'] ?? '',
      fdCreateDate: json['fdCreateDate'] ?? '',
      fdUpdateDate: json['fdUpdateDate'] ?? '',
    );
  }
}

Map<String, dynamic> setJsonData(
    String? fdNoEntryMobile,
    String? fdKodeNoo,
    String? fdDepo,
    String? fdKodeSF,
    String? fdBadanUsaha,
    String? fdNamaToko,
    String? fdOwner,
    String? fdContactPerson,
    String? fdAlamat,
    String? fdPhone,
    String? fdMobilePhone,
    String? fdKelurahan,
    String? fdKodePos,
    String? fdLA,
    String? fdLG,
    String? fdPatokan,
    String? fdTipeOutlet,
    String? fdLimitKredit,
    String? fdNPWP,
    String? fdNamaNPWP,
    String? fdAlamatNPWP,
    String? fdNIK,
    String? fdKelasOutlet,
    String? fdTokoLuar1,
    String? fdNpwpImg,
    String? fdTokoDalam1,
    String? fdKtpImg,
    String? fdKodeRute,
    int? fdStatusSent,
    String? fdLastproses,
    String? fdCreateDate,
    String? fdUpdateDate,
    String? fdKodeLangganan,
    int? fdStatusAktif) {
  return <String, dynamic>{
    "fdNoEntryMobile": fdNoEntryMobile,
    "fdKodeNoo": fdKodeNoo,
    "fdKodeDepo": fdDepo,
    "fdKodeSF": fdKodeSF,
    "fdBadanUsaha": fdBadanUsaha,
    "fdNamaToko": fdNamaToko,
    "fdOwner": fdOwner,
    "fdContactPerson": fdContactPerson,
    "fdAlamat": fdAlamat,
    "fdPhone": fdPhone,
    "fdMobilePhone": fdMobilePhone,
    "fdKelurahan": fdKelurahan,
    "fdKodePos": fdKodePos,
    "fdLA": fdLA,
    "fdLG": fdLG,
    "fdPatokan": fdPatokan,
    "fdTipeOutlet": fdTipeOutlet,
    "fdLimitKredit": fdLimitKredit,
    "fdNPWP": fdNPWP,
    "fdNamaNPWP": fdNamaNPWP,
    "fdAlamatNPWP": fdAlamatNPWP,
    "fdNIK": fdNIK,
    "fdKelasOutlet": fdKelasOutlet,
    "fdTokoLuar1": fdTokoLuar1,
    "fdNpwpImg": fdNpwpImg,
    "fdTokoDalam1": fdTokoDalam1,
    "fdKtpImg": fdKtpImg,
    "fdKodeRute": fdKodeRute,
    "fdStatusSent": fdStatusSent,
    "fdLastproses": fdLastproses,
    "fdCreateDate": fdCreateDate,
    "fdUpdateDate": fdUpdateDate,
    "fdKodeLangganan": fdKodeLangganan,
    "fdStatusAktif": fdStatusAktif,
  };
}

class FotoNOO {
  final String? fdKodeNoo;
  final String? fdDepo;
  final String? fdKodeSF;
  final String? fdJenis;
  final String? fdNamaJenis;
  final String? fdPath;
  final String? fdFileName;
  final int? fdStatusSent;
  final String? fdLastUpdate;
  final String? fdData;
  final String? fdMessage;

  FotoNOO(
      {required this.fdKodeNoo,
      required this.fdDepo,
      required this.fdKodeSF,
      required this.fdJenis,
      required this.fdNamaJenis,
      required this.fdPath,
      required this.fdFileName,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory FotoNOO.setData(Map<String, dynamic> item) {
    return FotoNOO(
        fdKodeNoo: item['fdKodeNoo'] ?? '',
        fdDepo: item['fdDepo'] ?? '',
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdJenis: item['fdJenis'] ?? '',
        fdNamaJenis: item['fdNamaJenis'] ?? '',
        fdPath: item['fdPath'] ?? '',
        fdFileName: item['fdFileName'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

Map<String, dynamic> setJsonDataNooFoto(
    String? fdKodeNoo,
    String? fdKodeLangganan,
    String? fdDepo,
    String? fdKodeSF,
    String? fdJenis,
    String? fdNamaJenis,
    String? fdPath,
    String? fdFileName,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntry": fdKodeNoo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdDepo": fdDepo,
    "fdKodeSF": fdKodeSF,
    "fdJenis": fdJenis,
    "fdNamaJenis": fdNamaJenis,
    "fdPath": fdPath,
    "fdFileName": fdFileName,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

class viewNOO {
  String? fdNoEntryMobile;
  String? fdKodeNoo;
  String? fdDepo;
  String? fdKodeSF;
  String? fdNamaToko;
  String? fdAlamat;
  String? fdCity;
  String? fdDC;
  String? fdLA;
  String? fdLG;
  String? fdLokasi;
  String? fdTipeOutlet;
  String? fdTipeHarga;
  String? fdGroupOutlet;
  String? fdKodeExternal;
  int? fdChiller;
  String? fdKodeRute;
  String? fdTokoLuar1;
  String? fdTokoLuar2;
  String? fdTokoDalam1;
  String? fdTokoDalam2;
  int? fdStatusSent;
  String? fdGroupLangganan;
  String? fdTipeOutletName;
  String? fdNoEntryOrder;
  double? fdLimitKredit;
  String? fdKelasOutlet;
  String? fdContactPerson;
  String? fdPhone;
  int? fdIsPaused = 0;
  String? fdTanggalActivity;
  String? fdStartVisitDate;
  String? fdEndVisitDate;
  String? fdNotVisitReason;
  String? fdKodeReason;
  String? fdReason;
  String? fdCancelVisitReason;
  String? fdLastproses;
  String? fdCreateDate;
  String? fdUpdateDate;
  String? fdData;
  String? fdMessage;

  viewNOO(
      {required this.fdNoEntryMobile,
      required this.fdKodeNoo,
      required this.fdDepo,
      required this.fdKodeSF,
      required this.fdNamaToko,
      required this.fdAlamat,
      required this.fdCity,
      required this.fdDC,
      required this.fdLA,
      required this.fdLG,
      required this.fdLokasi,
      required this.fdTipeOutlet,
      required this.fdTipeHarga,
      required this.fdGroupOutlet,
      required this.fdKodeExternal,
      required this.fdChiller,
      required this.fdKodeRute,
      required this.fdTokoLuar1,
      required this.fdTokoLuar2,
      required this.fdTokoDalam1,
      required this.fdTokoDalam2,
      required this.fdStatusSent,
      required this.fdLastproses,
      required this.fdGroupLangganan,
      required this.fdTipeOutletName,
      required this.fdNoEntryOrder,
      required this.fdLimitKredit,
      required this.fdKelasOutlet,
      required this.fdContactPerson,
      required this.fdPhone,
      required this.fdIsPaused,
      required this.fdTanggalActivity,
      required this.fdStartVisitDate,
      required this.fdEndVisitDate,
      required this.fdNotVisitReason,
      required this.fdKodeReason,
      required this.fdReason,
      required this.fdCancelVisitReason,
      required this.fdCreateDate,
      required this.fdUpdateDate});

  factory viewNOO.setData(Map<String, dynamic> item) {
    return viewNOO(
      fdNoEntryMobile: item['fdNoEntryMobile'] ?? '',
      fdKodeNoo: item['fdKodeNoo'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaToko: item['fdNamaToko'] ?? '',
      fdAlamat: item['fdAlamat'] ?? '',
      fdCity: item['fdCity'] ?? '',
      fdDC: item['fdDC'] ?? '',
      fdLA: item['fdLA'] ?? '',
      fdLG: item['fdLG'] ?? '',
      fdLokasi: item['fdLokasi'] ?? '',
      fdTipeOutlet: item['fdTipeOutlet'] ?? '',
      fdTipeHarga: item['fdTipeHarga'] ?? '',
      fdGroupOutlet: item['fdGroupOutlet'] ?? '',
      fdKodeExternal: item['fdKodeExternal'] ?? '',
      fdChiller: item['fdChiller'] ?? 0,
      fdKodeRute: item['fdKodeRute'] ?? '',
      fdTokoLuar1: item['fdTokoLuar1'] ?? '',
      fdTokoLuar2: item['fdTokoLuar2'] ?? '',
      fdTokoDalam1: item['fdTokoDalam1'] ?? '',
      fdTokoDalam2: item['fdTokoDalam2'] ?? '',
      fdStatusSent: item['fdUpload'] ?? 0,
      fdGroupLangganan: item['fdGroupLangganan'] ?? '',
      fdTipeOutletName: item['fdTipeOutletName'] ?? '',
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdLimitKredit: item['fdLimitKredit'] ?? 0,
      fdKelasOutlet: item['fdKelasOutlet'] ?? '',
      fdContactPerson: item['fdContactPerson'] ?? '',
      fdPhone: item['fdPhone'] ?? '',
      fdIsPaused: item['fdIsPaused'] ?? 0,
      fdTanggalActivity: item['fdTanggalActivity'] ?? '',
      fdStartVisitDate: item['fdStartVisitDate'] ?? '',
      fdEndVisitDate: item['fdEndVisitDate'] ?? '',
      fdNotVisitReason: item['fdNotVisitReason'] ?? '',
      fdKodeReason: item['fdKodeReason'] ?? '',
      fdReason: item['fdReason'] ?? '',
      fdCancelVisitReason: item['fdCancelVisitReason'] ?? '',
      fdLastproses: item['fdLastproses'] ?? '',
      fdCreateDate: item['fdCreateDate'] ?? '',
      fdUpdateDate: item['fdUpdateDate'] ?? '',
    );
  }

  factory viewNOO.fromJson(Map<String, dynamic> json) {
    return viewNOO(
      fdNoEntryMobile: json['fdNoEntryMobile'] ?? '',
      fdKodeNoo: json['fdKodeNoo'] ?? '',
      fdDepo: json['fdDepo'] ?? '',
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdNamaToko: json['fdNamaToko'] ?? '',
      fdAlamat: json['fdAlamat'] ?? '',
      fdCity: json['fdCity'] ?? '',
      fdDC: json['fdDC'] ?? '',
      fdLA: json['fdLA'] ?? '',
      fdLG: json['fdLG'] ?? '',
      fdLokasi: json['fdLokasi'] ?? '',
      fdTipeOutlet: json['fdTipeOutlet'] ?? '',
      fdTipeHarga: json['fdTipeHarga'] ?? '',
      fdGroupOutlet: json['fdGroupOutlet'] ?? '',
      fdKodeExternal: json['fdKodeExternal'] ?? '',
      fdChiller: json['fdChiller'] ?? 0,
      fdKodeRute: json['fdKodeRute'] ?? '',
      fdTokoLuar1: json['fdTokoLuar1'] ?? '',
      fdTokoLuar2: json['fdTokoLuar2'] ?? '',
      fdTokoDalam1: json['fdTokoDalam1'] ?? '',
      fdTokoDalam2: json['fdTokoDalam2'] ?? '',
      fdStatusSent: json['fdStatusSent'] ?? 0,
      fdGroupLangganan: json['fdGroupLangganan'] ?? '',
      fdTipeOutletName: json['fdTipeOutletName'] ?? '',
      fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
      fdLimitKredit: json['fdLimitKredit'] ?? 0,
      fdKelasOutlet: json['fdKelasOutlet'] ?? '',
      fdContactPerson: json['fdContactPerson'] ?? '',
      fdPhone: json['fdPhone'] ?? '',
      fdIsPaused: json['fdIsPaused'] ?? 0,
      fdTanggalActivity: json['fdTanggalActivity'] ?? '',
      fdStartVisitDate: json['fdStartVisitDate'] ?? '',
      fdEndVisitDate: json['fdEndVisitDate'] ?? '',
      fdNotVisitReason: json['fdNotVisitReason'] ?? '',
      fdKodeReason: json['fdKodeReason'] ?? '',
      fdReason: json['fdReason'] ?? '',
      fdCancelVisitReason: json['fdCancelVisitReason'] ?? '',
      fdLastproses: json['fdLastproses'] ?? '',
      fdCreateDate: json['fdCreateDate'] ?? '',
      fdUpdateDate: json['fdUpdateDate'] ?? '',
    );
  }

  factory viewNOO.empty() {
    return viewNOO(
      fdNoEntryMobile: '',
      fdKodeNoo: '',
      fdDepo: '',
      fdKodeSF: '',
      fdNamaToko: '',
      fdAlamat: '',
      fdCity: '',
      fdDC: '',
      fdLA: '',
      fdLG: '',
      fdLokasi: '',
      fdTipeOutlet: '',
      fdTipeHarga: '',
      fdGroupOutlet: '',
      fdKodeExternal: '',
      fdChiller: 0,
      fdKodeRute: '',
      fdTokoLuar1: '',
      fdTokoLuar2: '',
      fdTokoDalam1: '',
      fdTokoDalam2: '',
      fdStatusSent: 0,
      fdGroupLangganan: '',
      fdTipeOutletName: '',
      fdNoEntryOrder: '',
      fdLimitKredit: 0,
      fdKelasOutlet: '',
      fdContactPerson: '',
      fdPhone: '',
      fdIsPaused: 0,
      fdTanggalActivity: '',
      fdStartVisitDate: '',
      fdEndVisitDate: '',
      fdNotVisitReason: '',
      fdKodeReason: '',
      fdReason: '',
      fdCancelVisitReason: '',
      fdLastproses: '',
      fdCreateDate: '',
      fdUpdateDate: '',
    );
  }
}

class ActivityNOO {
  String? fdNoEntryMobile;
  String? fdKodeNoo;
  String? fdDepo;
  String? fdKodeSF;
  String? fdBadanUsaha;
  String? fdNamaToko;
  String? fdOwner;
  String? fdContactPerson;
  String? fdPhone;
  String? fdMobilePhone;
  String? fdAlamat;
  String? fdKelurahan;
  String? fdKodePos;
  String? fdLA;
  String? fdLG;
  String? fdPatokan;
  String? fdTipeOutlet;
  double? fdLimitKredit;
  String? fdNPWP;
  String? fdNamaNPWP;
  String? fdAlamatNPWP;
  String? fdNIK;
  String? fdKelasOutlet;
  String? fdTokoLuar1;
  String? fdNpwpImg;
  String? fdTokoDalam1;
  String? fdKtpImg;
  String? fdKodeRute;
  String? fdKodeLangganan;
  int? fdIsPaused = 0;
  String? fdTanggalActivity;
  String? fdStartVisitDate;
  String? fdEndVisitDate;
  String? fdNotVisitReason;
  String? fdKodeReason; //Untuk langganan activity
  String? fdReason; //Untuk langganan activity
  String? fdCancelVisitReason;
  int? fdStatusSent;
  int? fdStatusAktif;
  String? fdLastproses;
  String? fdCreateDate;
  String? fdUpdateDate;
  String? fdData;
  String? fdMessage;

  ActivityNOO(
      {required this.fdNoEntryMobile,
      required this.fdKodeNoo,
      required this.fdDepo,
      required this.fdKodeSF,
      required this.fdBadanUsaha,
      required this.fdNamaToko,
      required this.fdOwner,
      required this.fdContactPerson,
      required this.fdAlamat,
      required this.fdPhone,
      required this.fdMobilePhone,
      required this.fdKelurahan,
      required this.fdKodePos,
      required this.fdLA,
      required this.fdLG,
      required this.fdPatokan,
      required this.fdTipeOutlet,
      required this.fdLimitKredit,
      required this.fdNPWP,
      required this.fdNamaNPWP,
      required this.fdAlamatNPWP,
      required this.fdNIK,
      required this.fdKelasOutlet,
      required this.fdTokoLuar1,
      required this.fdNpwpImg,
      required this.fdTokoDalam1,
      required this.fdKtpImg,
      required this.fdKodeRute,
      required this.fdKodeLangganan,
      required this.fdIsPaused,
      required this.fdTanggalActivity,
      required this.fdStartVisitDate,
      required this.fdEndVisitDate,
      required this.fdNotVisitReason,
      required this.fdKodeReason,
      required this.fdReason,
      required this.fdCancelVisitReason,
      required this.fdStatusSent,
      required this.fdStatusAktif,
      required this.fdLastproses,
      required this.fdCreateDate,
      required this.fdUpdateDate});

  factory ActivityNOO.setData(Map<String, dynamic> item) {
    return ActivityNOO(
      fdNoEntryMobile: item['fdNoEntryMobile'] ?? '',
      fdKodeNoo: item['fdKodeNoo'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdBadanUsaha: item['fdBadanUsaha'] ?? '',
      fdNamaToko: item['fdNamaToko'] ?? '',
      fdOwner: item['fdOwner'] ?? '',
      fdContactPerson: item['fdContactPerson'] ?? '',
      fdPhone: item['fdPhone'] ?? '',
      fdMobilePhone: item['fdMobilePhone'] ?? '',
      fdAlamat: item['fdAlamat'] ?? '',
      fdKelurahan: item['fdKelurahan'] ?? '',
      fdKodePos: item['fdKodePos'] ?? '',
      fdLA: item['fdLA'] ?? '',
      fdLG: item['fdLG'] ?? '',
      fdPatokan: item['fdPatokan'] ?? '',
      fdTipeOutlet: item['fdTipeOutlet'] ?? '',
      fdLimitKredit: double.tryParse(item['fdLimitKredit'].toString()) != null
          ? item['fdLimitKredit'].toDouble()
          : 0,
      fdNPWP: item['fdNPWP'] ?? '',
      fdNamaNPWP: item['fdNamaNPWP'] ?? '',
      fdAlamatNPWP: item['fdAlamatNPWP'] ?? '',
      fdNIK: item['fdNIK'] ?? '',
      fdKelasOutlet: item['fdKelasOutlet'] ?? '',
      fdTokoLuar1: item['fdTokoLuar1'] ?? '',
      fdNpwpImg: item['fdNpwpImg'] ?? '',
      fdTokoDalam1: item['fdTokoDalam1'] ?? '',
      fdKtpImg: item['fdKtpImg'] ?? '',
      fdKodeRute: item['fdKodeRute'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdIsPaused: item['fdIsPaused'] ?? '',
      fdTanggalActivity: item['fdTanggalActivity'] ?? '',
      fdStartVisitDate: item['fdStartVisitDate'] ?? '',
      fdEndVisitDate: item['fdEndVisitDate'] ?? '',
      fdNotVisitReason: item['fdNotVisitReason'] ?? '',
      fdKodeReason: item['fdKodeReason'] ?? '',
      fdReason: item['fdReason'] ?? '',
      fdCancelVisitReason: item['fdCancelVisitReason'] ?? '',
      fdStatusSent: item['fdUpload'] ?? 0,
      fdStatusAktif: item['fdStatusAktif'] ?? 3, //3=void
      fdLastproses: item['fdLastproses'] ?? '',
      fdCreateDate: item['fdCreateDate'] ?? '',
      fdUpdateDate: item['fdUpdateDate'] ?? '',
    );
  }

  factory ActivityNOO.fromJson(Map<String, dynamic> json) {
    return ActivityNOO(
      fdNoEntryMobile: json['fdNoEntryMobile'] ?? '',
      fdKodeNoo: json['fdKodeNoo'] ?? '',
      fdDepo: json['fdDepo'] ?? '',
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdBadanUsaha: json['fdBadanUsaha'] ?? '',
      fdNamaToko: json['fdNamaToko'] ?? '',
      fdOwner: json['fdOwner'] ?? '',
      fdContactPerson: json['fdContactPerson'] ?? '',
      fdPhone: json['fdPhone'] ?? '',
      fdMobilePhone: json['fdMobilePhone'] ?? '',
      fdAlamat: json['fdAlamat'] ?? '',
      fdKelurahan: json['fdKelurahan'] ?? '',
      fdKodePos: json['fdKodePos'] ?? '',
      fdLA: json['fdLA'] ?? '',
      fdLG: json['fdLG'] ?? '',
      fdPatokan: json['fdPatokan'] ?? '',
      fdTipeOutlet: json['fdTipeOutlet'] ?? '',
      fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
          ? json['fdLimitKredit'].toDouble()
          : 0,
      fdNPWP: json['fdNPWP'] ?? '',
      fdNamaNPWP: json['fdNamaNPWP'] ?? '',
      fdAlamatNPWP: json['fdAlamatNPWP'] ?? '',
      fdNIK: json['fdNIK'] ?? '',
      fdKelasOutlet: json['fdKelasOutlet'] ?? '',
      fdTokoLuar1: json['fdTokoLuar1'] ?? '',
      fdNpwpImg: json['fdNpwpImg'] ?? '',
      fdTokoDalam1: json['fdTokoDalam1'] ?? '',
      fdKtpImg: json['fdKtpImg'] ?? '',
      fdKodeRute: json['fdKodeRute'] ?? '',
      fdKodeLangganan: json['fdKodeLangganan'] ?? '',
      fdIsPaused: json['fdIsPaused'] ?? '',
      fdTanggalActivity: json['fdTanggalActivity'] ?? '',
      fdStartVisitDate: json['fdStartVisitDate'] ?? '',
      fdEndVisitDate: json['fdEndVisitDate'] ?? '',
      fdNotVisitReason: json['fdNotVisitReason'] ?? '',
      fdKodeReason: json['fdKodeReason'] ?? '',
      fdReason: json['fdReason'] ?? '',
      fdCancelVisitReason: json['fdCancelVisitReason'] ?? '',
      fdStatusSent: json['fdStatusSent'] ?? 0,
      fdStatusAktif: json['fdStatusAktif'] ?? 3,
      fdLastproses: json['fdLastproses'] ?? '',
      fdCreateDate: json['fdCreateDate'] ?? '',
      fdUpdateDate: json['fdUpdateDate'] ?? '',
    );
  }
}
