class RencanaRute {
  final String? fdKodeDepo;
  final String fdNoRencanaRute;
  final String? fdStartDate;
  final String? fdEndDate;
  final String? fdTanggal;
  final String? fdKodeSF;
  final String? fdKodeStatus;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  RencanaRute(
      {required this.fdKodeDepo,
      required this.fdNoRencanaRute,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdTanggal,
      required this.fdKodeSF,
      required this.fdKodeStatus,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory RencanaRute.setData(Map<String, dynamic> item) {
    return RencanaRute(
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdNoRencanaRute: item['fdNoRencanaRute'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeStatus: item['fdKodeStatus'].toString(),
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RencanaRute.fromJson(Map<String, dynamic> json) {
    return RencanaRute(
        fdKodeDepo: json['fdKodeDepo'] ?? '',
        fdNoRencanaRute: json['fdNoRencanaRute'] ?? '',
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory RencanaRute.empty() {
    return RencanaRute(
        fdKodeDepo: '',
        fdNoRencanaRute: '',
        fdStartDate: '',
        fdEndDate: '',
        fdTanggal: '',
        fdKodeSF: '',
        fdKodeStatus: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}

class RencanaRuteLangganan {
  final String fdNoRencanaRute;
  final String fdTanggalRencanaRute;
  final String? fdKodeLangganan;
  final String? fdNamaLangganan;
  final String? fdAlamat;
  final String? fdPekan;
  final String? fdHari;
  final String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  RencanaRuteLangganan(
      {required this.fdNoRencanaRute,
      required this.fdTanggalRencanaRute,
      required this.fdKodeLangganan,
      required this.fdNamaLangganan,
      required this.fdAlamat,
      required this.fdPekan,
      required this.fdHari,
      required this.fdLastUpdate,
      this.code,
      this.isCheck,
      this.message});

  factory RencanaRuteLangganan.setData(Map<String, dynamic> item) {
    return RencanaRuteLangganan(
      fdNoRencanaRute: item['fdNoRencanaRute'] ?? '',
      fdTanggalRencanaRute: item['fdTanggalRencanaRute'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'].toString(),
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdAlamat: item['fdAlamat'] ?? '',
      fdPekan: item['fdPekan'] ?? '',
      fdHari: item['fdHari'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RencanaRuteLangganan.fromJson(Map<String, dynamic> json) {
    return RencanaRuteLangganan(
        fdNoRencanaRute: json['fdNoRencanaRute'] ?? '',
        fdTanggalRencanaRute: json['fdTanggalRencanaRute'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdAlamat: json['fdAlamat'] ?? '',
        fdPekan: json['fdPekan'] ?? '',
        fdHari: json['fdHari'] ?? '',
        code: json['code'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory RencanaRuteLangganan.empty() {
    return RencanaRuteLangganan(
        fdNoRencanaRute: '',
        fdTanggalRencanaRute: '',
        fdKodeLangganan: '',
        fdNamaLangganan: '',
        fdAlamat: '',
        fdPekan: '',
        fdHari: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}

class RencanaRuteFaktur {
  final String fdNoRencanaRute;
  final String? fdNoEntryFaktur;
  final double? fdSisaNilaiInvoice;
  final String? fdKeterangan;
  final String? fdNoFaktur;
  final String? fdTanggalJT;
  final String? fdTanggalFaktur;
  final String? fdKodeLangganan;
  final String? fdNamaLangganan;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  RencanaRuteFaktur(
      {required this.fdNoRencanaRute,
      required this.fdNoEntryFaktur,
      required this.fdSisaNilaiInvoice,
      required this.fdKeterangan,
      required this.fdNoFaktur,
      required this.fdTanggalJT,
      required this.fdTanggalFaktur,
      required this.fdKodeLangganan,
      required this.fdNamaLangganan,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory RencanaRuteFaktur.setData(Map<String, dynamic> item) {
    return RencanaRuteFaktur(
      fdNoRencanaRute: item['fdNoRencanaRute'].toString(),
      fdNoEntryFaktur: item['fdNoEntryFaktur'].toString(),
      fdSisaNilaiInvoice:
          double.tryParse(item['fdSisaNilaiInvoice'].toString()) != null
              ? item['fdSisaNilaiInvoice'].toDouble()
              : 0,
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdTanggalJT: item['fdTanggalJT'] ?? '',
      fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RencanaRuteFaktur.fromJson(Map<String, dynamic> json) {
    return RencanaRuteFaktur(
        fdNoRencanaRute: json['fdNoRencanaRute'].toString(),
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdSisaNilaiInvoice:
            double.tryParse(json['fdSisaNilaiInvoice'].toString()) != null
                ? json['fdSisaNilaiInvoice'].toDouble()
                : 0,
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdTanggalJT: json['fdTanggalJT'] ?? '',
        fdTanggalFaktur: json['fdTanggalFaktur'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory RencanaRuteFaktur.empty() {
    return RencanaRuteFaktur(
        fdNoRencanaRute: '',
        fdNoEntryFaktur: '',
        fdSisaNilaiInvoice: 0,
        fdKeterangan: '',
        fdNoFaktur: '',
        fdTanggalJT: '',
        fdTanggalFaktur: '',
        fdKodeLangganan: '',
        fdNamaLangganan: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}

class RencanaNonRuteLangganan {
  final String? fdNoRencanaRute;
  final String? fdTanggalRencanaRute;
  final String? fdKodeSF;
  final String? fdKodeDepo;
  final String? fdKodeLangganan;
  final String? fdBadanUsaha;
  final String? fdNamaLangganan;
  final String? fdOwner;
  final String? fdContactPerson;
  final String? fdPhone;
  final String? fdMobilePhone;
  final String? fdAlamat;
  final String? fdKelurahan;
  final String? fdKodePos;
  final double fdLA;
  final double fdLG;
  final String? fdTipeOutlet;
  final String? fdNPWP;
  final String? fdNamaNPWP;
  final String? fdAlamatNPWP;
  final String? fdNIK;
  final String? fdKelasOutlet;
  final String? fdKodeRute;
  final int isRute;
  final int fdKodeStatus;
  int isLocked = 0;
  double? fdLimitKredit;
  final int? isEditProfile;
  final String? fdLastUpdate;
  final String? fdTanggalActivity;
  final String? fdStartVisitDate;
  final String? fdEndVisitDate;
  final String? fdNotVisitReason;
  final String? fdKodeReason; //Untuk langganan activity
  final String? fdReason; //Untuk langganan activity
  final String? fdCancelVisitReason;
  final String? fdKodeHarga;
  final int? code;
  final String? message;
  bool? isCheck = false;
  int? fdIsPaused = 0;
  int? fdStatusSent = 0;
  String? fdPauseReason;
  String? fdCategory;
  String? fdPhoto;
  String? fdKeterangan;
  String? fdKodeExternal;
  String? fdKota;
  String? fdKodeTipeLangganan;
  String? fdTipeLangganan;
  String? fdNamaGroupLangganan;
  String? fdGroupLangganan;
  String? fdPekan;
  String? fdHari;
  int? fdAmountChiller;
  int? isLatePayment = 0;

  RencanaNonRuteLangganan(
      {required this.fdNoRencanaRute,
      required this.fdTanggalRencanaRute,
      required this.fdKodeSF,
      required this.fdKodeDepo,
      required this.fdKodeLangganan,
      required this.fdBadanUsaha,
      required this.fdNamaLangganan,
      required this.fdOwner,
      required this.fdContactPerson,
      this.fdPhone,
      this.fdMobilePhone,
      required this.fdAlamat,
      required this.fdKelurahan,
      required this.fdKodePos,
      required this.fdLA,
      required this.fdLG,
      required this.fdTipeOutlet,
      required this.fdNPWP,
      required this.fdNamaNPWP,
      required this.fdAlamatNPWP,
      required this.fdNIK,
      required this.fdKelasOutlet,
      required this.fdKodeRute,
      required this.isRute,
      required this.fdKodeStatus,
      required this.isLocked,
      this.fdLimitKredit,
      required this.isEditProfile,
      required this.fdLastUpdate,
      required this.fdTanggalActivity,
      required this.fdStartVisitDate,
      required this.fdEndVisitDate,
      required this.fdNotVisitReason,
      this.fdKodeReason, //untuk langganan activity
      this.fdReason, //untuk langganan activity
      required this.fdCancelVisitReason,
      required this.fdKodeHarga,
      this.code,
      this.message,
      this.isCheck,
      this.fdIsPaused,
      this.fdStatusSent,
      this.fdPauseReason,
      this.fdCategory,
      this.fdPhoto,
      this.fdKeterangan,
      this.fdKodeExternal,
      this.fdKota,
      this.fdKodeTipeLangganan,
      this.fdTipeLangganan,
      this.fdGroupLangganan,
      this.fdNamaGroupLangganan,
      this.fdPekan,
      this.fdHari,
      this.fdAmountChiller,
      this.isLatePayment});

  factory RencanaNonRuteLangganan.setData(Map<String, dynamic> item) {
    return RencanaNonRuteLangganan(
        fdNoRencanaRute: item['fdNoRencanaRute'] ?? '',
        fdTanggalRencanaRute: item['fdTanggalRencanaRute'] ?? '',
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdKodeDepo: item['fdKodeDepo'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdBadanUsaha: item['fdBadanUsaha'] ?? '',
        fdNamaLangganan: item['fdNamaLangganan'] ?? '',
        fdOwner: item['fdOwner'] ?? '',
        fdContactPerson: item['fdContactPerson'] ?? '',
        fdPhone: item['fdPhone'] ?? '',
        fdMobilePhone: item['fdMobilePhone'] ?? '',
        fdAlamat: item['fdAlamat'] ?? '',
        fdKelurahan: item['fdKelurahan'] ?? '',
        fdKodePos: item['fdKodePos'] ?? '',
        fdLA: double.tryParse(item['fdLA'].toString()) != null
            ? item['fdLA'].toDouble()
            : 0,
        fdLG: double.tryParse(item['fdLG'].toString()) != null
            ? item['fdLG'].toDouble()
            : 0,
        fdTipeOutlet: item['fdTipeOutlet'] ?? '',
        fdNPWP: item['fdNPWP'] ?? '',
        fdNamaNPWP: item['fdNamaNPWP'] ?? '',
        fdAlamatNPWP: item['fdAlamatNPWP'] ?? '',
        fdNIK: item['fdNIK'] ?? '',
        fdKelasOutlet: item['fdKelasOutlet'] ?? '',
        fdKodeRute: item['fdKodeRute'] ?? '',
        isLocked: item['isLocked'] ?? 0,
        fdLimitKredit: double.tryParse(item['fdLimitKredit'].toString()) != null
            ? item['fdLimitKredit'].toDouble()
            : 0,
        isEditProfile: item['isEditProfile'] ?? 0,
        fdIsPaused: item['fdIsPaused'] ?? 0,
        fdPauseReason: item['fdPauseReason'] ?? '',
        fdCategory: item['fdCategory'] ?? '',
        fdPhoto: item['fdPhoto'] ?? '',
        fdKeterangan: item['fdKeterangan'] ?? '',
        isRute: item['isRute'] ?? 0,
        fdKodeStatus: item['fdKodeStatus'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        fdTanggalActivity: item['fdTanggal'] ?? '',
        fdStartVisitDate: item['fdStartVisitDate'] ?? '',
        fdEndVisitDate: item['fdEndVisitDate'] ?? '',
        fdNotVisitReason: item['fdNotVisitReason'] ?? '',
        fdKodeReason: item['fdKodeReason'] ?? '', //untuk langganan activity
        fdReason: item['fdReason'] ?? '', //untuk langganan activity
        fdCancelVisitReason: item['fdCancelVisitReason'] ?? '',
        fdKodeHarga: item['fdKodeHarga'] ?? '',
        fdKodeExternal: item['fdKodeExternal'] ?? '',
        fdPekan: item['fdPekan'] ?? '',
        fdHari: item['fdHari'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0);
  }

  factory RencanaNonRuteLangganan.fromJson(
      Map<String, dynamic> json, int inRute) {
    return RencanaNonRuteLangganan(
        fdNoRencanaRute: json['fdNoRencanaRute'] ?? '',
        fdTanggalRencanaRute: json['fdTanggalRencanaRute'] ?? '',
        fdKodeSF: json['fdKodeSF'].toString(),
        fdKodeDepo: json['fdKodeDepo'].toString(),
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdBadanUsaha: json['fdBadanUsaha'] ?? '',
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdOwner: json['fdOwner'] ?? '',
        fdContactPerson: json['fdContactPerson'] ?? '',
        fdPhone: json['fdPhone'] ?? '',
        fdMobilePhone: json['fdMobilePhone'] ?? '',
        fdAlamat: json['fdAlamat'] ?? '',
        fdKelurahan: json['fdKelurahan'].toString(),
        fdKodePos: json['fdKodePos'] ?? '',
        fdLA: double.tryParse(json['fdLA'].toString()) != null
            ? json['fdLA'].toDouble()
            : 0,
        fdLG: double.tryParse(json['fdLG'].toString()) != null
            ? json['fdLG'].toDouble()
            : 0,
        fdTipeOutlet: json['fdTipeOutlet'] ?? '',
        fdNPWP: json['fdNPWP'] ?? '',
        fdNamaNPWP: json['fdNamaNPWP'] ?? '',
        fdAlamatNPWP: json['fdAlamatNPWP'] ?? '',
        fdNIK: json['fdNIK'] ?? '',
        fdKelasOutlet: json['fdKelasOutlet'] ?? '',
        fdKodeRute: json['fdKodeRute'] ?? '',
        fdIsPaused: json['fdIsPaused'] ?? 0,
        fdPauseReason: json['fdPauseReason'] ?? '',
        fdCategory: json['fdCategory'] ?? '',
        fdPhoto: json['fdPhoto'] ?? '',
        fdKeterangan: json['fdKeterangan'] ?? '',
        isRute: inRute, //json['isRute'] ?? 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        isLocked: json['isLocked'] ?? 0,
        fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
            ? json['fdLimitKredit'].toDouble()
            : 0,
        isEditProfile: json['isEditProfile'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        fdTanggalActivity: json['fdTanggal'] ?? '',
        fdStartVisitDate: json['fdStartVisitDate'] ?? '',
        fdEndVisitDate: json['fdEndVisitDate'] ?? '',
        fdNotVisitReason: json['fdNotVisitReason'] ?? '',
        fdKodeReason: json['fdKodeReason'] ?? '', //untuk langganan activity
        fdReason: json['fdReason'] ?? '', //untuk langganan activity
        fdCancelVisitReason: json['fdCancelVisitReason'] ?? '',
        fdKodeHarga: json['fdKodeHarga'] ?? '',
        fdStatusSent: json['fdStatusSent'] ?? 0,
        isCheck: json['isCheck'] ?? false,
        fdKodeExternal: json['fdKodeExternal'].toString(),
        fdPekan: json['fdPekan'] ?? '',
        fdHari: json['fdHari'] ?? '',
        isLatePayment: json['isLatePayment'] ?? 0,
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }

  factory RencanaNonRuteLangganan.empty() {
    return RencanaNonRuteLangganan(
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
        fdKodeExternal: '',
        fdPekan: '',
        fdHari: '',
        fdStatusSent: 0,
        isCheck: false);
  }
}

class RencanaRuteApi {
  //HEADER
  final String? fdKodeDepo;
  final String fdNoRencanaRute;
  final String? fdStartDate;
  final String? fdEndDate;
  final String? fdTanggal;
  final String? fdKodeSF;
  final String? fdKodeStatus;
  //DETAIL
  final String fdTanggalRencanaRute;
  final String? fdKodeLangganan;
  final String? fdNamaLangganan;
  final String? fdAlamat;
  final String? fdPekan;
  final String? fdHari;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  RencanaRuteApi(
      {required this.fdKodeDepo,
      required this.fdNoRencanaRute,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdTanggal,
      required this.fdKodeSF,
      required this.fdKodeStatus,
      required this.fdTanggalRencanaRute,
      required this.fdKodeLangganan,
      required this.fdNamaLangganan,
      required this.fdAlamat,
      required this.fdPekan,
      required this.fdHari,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory RencanaRuteApi.setData(Map<String, dynamic> item) {
    return RencanaRuteApi(
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdNoRencanaRute: item['fdNoRencanaRute'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeStatus: item['fdKodeStatus'].toString(),
      fdTanggalRencanaRute: item['fdTanggalRencanaRute'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'].toString(),
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdAlamat: item['fdAlamat'] ?? '',
      fdPekan: item['fdPekan'].toString(),
      fdHari: item['fdHari'].toString(),
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RencanaRuteApi.fromJson(Map<String, dynamic> json) {
    return RencanaRuteApi(
        fdKodeDepo: json['fdKodeDepo'] ?? '',
        fdNoRencanaRute: json['fdNoRencanaRute'] ?? '',
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdTanggalRencanaRute: json['fdTanggalRencanaRute'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdAlamat: json['fdAlamat'] ?? '',
        fdPekan: json['fdPekan'] ?? '',
        fdHari: json['fdHari'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory RencanaRuteApi.empty() {
    return RencanaRuteApi(
        fdKodeDepo: '',
        fdNoRencanaRute: '',
        fdStartDate: '',
        fdEndDate: '',
        fdTanggal: '',
        fdKodeSF: '',
        fdKodeStatus: '',
        fdTanggalRencanaRute: '',
        fdKodeLangganan: '',
        fdNamaLangganan: '',
        fdAlamat: '',
        fdPekan: '',
        fdHari: '',
        fdLastUpdate: '',
        message: '',
        fdData: '',
        fdMessage: '');
  }
}

Map<String, dynamic> setJsonDataRencanaRuteApi(
    String? fdKodeDepo,
    String fdNoRencanaRute,
    String? fdStartDate,
    String? fdEndDate,
    String? fdTanggal,
    String? fdKodeSF,
    String? fdKodeStatus,
    //DETAIL
    String fdTanggalRencanaRute,
    String? fdKodeLangganan,
    String? fdNamaLangganan,
    String? fdAlamat,
    String? fdPekan,
    String? fdHari,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdKodeDepo": fdKodeDepo,
    "fdNoRencanaRute": fdNoRencanaRute,
    "fdStartDate": fdStartDate,
    "fdEndDate": fdEndDate,
    "fdTanggal": fdTanggal,
    "fdKodeSF": fdKodeSF,
    "fdKodeStatus": fdKodeStatus,
    "fdTanggalRencanaRute": fdTanggalRencanaRute,
    "fdKodeLangganan": fdKodeLangganan,
    "fdNamaLangganan": fdNamaLangganan,
    "fdAlamat": fdAlamat,
    "fdPekan": fdPekan,
    "fdHari": fdHari,
    "fdLastUpdate": fdLastUpdate
  };
}

class ViewRencanaRuteFaktur {
  final String fdNoRencanaRute;
  final String fdStartDate;
  final String fdEndDate;
  final String? fdNoEntryFaktur;
  final double? fdSisaNilaiInvoice;
  final String? fdKeterangan;
  final String? fdTanggalRencanaRute;
  final int? fdCountInv;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  ViewRencanaRuteFaktur(
      {required this.fdNoRencanaRute,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdNoEntryFaktur,
      required this.fdSisaNilaiInvoice,
      required this.fdKeterangan,
      required this.fdTanggalRencanaRute,
      required this.fdCountInv,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory ViewRencanaRuteFaktur.setData(Map<String, dynamic> item) {
    return ViewRencanaRuteFaktur(
      fdNoRencanaRute: item['fdNoRencanaRute'].toString(),
      fdStartDate: item['fdStartDate'].toString(),
      fdEndDate: item['fdEndDate'].toString(),
      fdNoEntryFaktur: item['fdNoEntryFaktur'].toString(),
      fdSisaNilaiInvoice:
          double.tryParse(item['fdSisaNilaiInvoice'].toString()) != null
              ? item['fdSisaNilaiInvoice'].toDouble()
              : 0,
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdTanggalRencanaRute: item['fdTanggalRencanaRute'] ?? '',
      fdCountInv: item['fdCountInv'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory ViewRencanaRuteFaktur.fromJson(Map<String, dynamic> json) {
    return ViewRencanaRuteFaktur(
        fdNoRencanaRute: json['fdNoRencanaRute'].toString(),
        fdStartDate: json['fdStartDate'].toString(),
        fdEndDate: json['fdEndDate'].toString(),
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdSisaNilaiInvoice:
            double.tryParse(json['fdSisaNilaiInvoice'].toString()) != null
                ? json['fdSisaNilaiInvoice'].toDouble()
                : 0,
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdTanggalRencanaRute: json['fdTanggalRencanaRute'] ?? '',
        fdCountInv: json['fdCountInv'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory ViewRencanaRuteFaktur.empty() {
    return ViewRencanaRuteFaktur(
        fdNoRencanaRute: '',
        fdNoEntryFaktur: '',
        fdStartDate: '',
        fdEndDate: '',
        fdSisaNilaiInvoice: 0,
        fdKeterangan: '',
        fdTanggalRencanaRute: '',
        fdCountInv: 0,
        fdLastUpdate: '',
        isCheck: false);
  }
}

class ViewDetailRencanaRuteFaktur {
  final String fdNoRencanaRute;
  final String fdStartDate;
  final String fdEndDate;
  final String? fdNoEntryFaktur;
  final double? fdSisaNilaiInvoice;
  final String? fdKeterangan;
  final String? fdNoFaktur;
  final String? fdTanggalJT;
  final String? fdTanggalFaktur;
  final String? fdKodeLangganan;
  final String? fdNamaLangganan;
  final int? fdCountInv;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  ViewDetailRencanaRuteFaktur(
      {required this.fdNoRencanaRute,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdNoEntryFaktur,
      required this.fdSisaNilaiInvoice,
      required this.fdKeterangan,
      required this.fdNoFaktur,
      required this.fdTanggalJT,
      required this.fdTanggalFaktur,
      required this.fdKodeLangganan,
      required this.fdNamaLangganan,
      required this.fdCountInv,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory ViewDetailRencanaRuteFaktur.setData(Map<String, dynamic> item) {
    return ViewDetailRencanaRuteFaktur(
      fdNoRencanaRute: item['fdNoRencanaRute'].toString(),
      fdStartDate: item['fdStartDate'].toString(),
      fdEndDate: item['fdEndDate'].toString(),
      fdNoEntryFaktur: item['fdNoEntryFaktur'].toString(),
      fdSisaNilaiInvoice:
          double.tryParse(item['fdSisaNilaiInvoice'].toString()) != null
              ? item['fdSisaNilaiInvoice'].toDouble()
              : 0,
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdTanggalJT: item['fdTanggalJT'] ?? '',
      fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdCountInv: item['fdCountInv'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory ViewDetailRencanaRuteFaktur.fromJson(Map<String, dynamic> json) {
    return ViewDetailRencanaRuteFaktur(
        fdNoRencanaRute: json['fdNoRencanaRute'].toString(),
        fdStartDate: json['fdStartDate'].toString(),
        fdEndDate: json['fdEndDate'].toString(),
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdSisaNilaiInvoice:
            double.tryParse(json['fdSisaNilaiInvoice'].toString()) != null
                ? json['fdSisaNilaiInvoice'].toDouble()
                : 0,
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdTanggalJT: json['fdTanggalJT'] ?? '',
        fdTanggalFaktur: json['fdTanggalFaktur'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdCountInv: json['fdCountInv'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory ViewDetailRencanaRuteFaktur.empty() {
    return ViewDetailRencanaRuteFaktur(
        fdNoRencanaRute: '',
        fdNoEntryFaktur: '',
        fdStartDate: '',
        fdEndDate: '',
        fdSisaNilaiInvoice: 0,
        fdKeterangan: '',
        fdNoFaktur: '',
        fdTanggalJT: '',
        fdTanggalFaktur: '',
        fdKodeLangganan: '',
        fdNamaLangganan: '',
        fdCountInv: 0,
        fdLastUpdate: '',
        isCheck: false);
  }
}
