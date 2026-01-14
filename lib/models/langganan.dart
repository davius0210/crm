class Langganan {
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
  String? fdKodeDC;
  String? fdDC;
  int? fdAmountChiller;
  int? isLatePayment = 0;

  Langganan(
      {required this.fdKodeSF,
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
      this.fdKodeDC,
      this.fdDC,
      this.fdAmountChiller,
      this.isLatePayment});

  factory Langganan.setData(Map<String, dynamic> item) {
    return Langganan(
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
        fdStatusSent: item['fdStatusSent'] ?? 0);
  }

  factory Langganan.fromJson(Map<String, dynamic> json, int inRute) {
    return Langganan(
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
        isRute: json['isRute'] ?? 0,
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
        isLatePayment: json['isLatePayment'] ?? 0,
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }

  factory Langganan.empty() {
    return Langganan(
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
        fdStatusSent: 0,
        isCheck: false);
  }
}

class Reason {
  final String? fdTipe; //1 = NotVisit, 2 = Pause
  final String? fdDescription;
  final String? fdKodeReason;
  final String? fdReasonDescription;
  final int? fdCamera;
  final int? fdFreeTeks;
  final int? fdCancelVisit;
  final String? fdLastUpdate;
  final int? code;
  final String? message;

  Reason(
      {required this.fdTipe,
      required this.fdDescription,
      required this.fdKodeReason,
      required this.fdReasonDescription,
      required this.fdCamera,
      required this.fdFreeTeks,
      required this.fdCancelVisit,
      required this.fdLastUpdate,
      this.code,
      this.message});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
        fdTipe: json['fdTipe'] ?? '',
        fdDescription: json['fdDescription'] ?? '',
        fdKodeReason: json['fdKodeReason'] ?? '',
        fdReasonDescription: json['fdReasonDescription'] ?? '',
        fdCamera: json['fdCamera'].toInt() ?? 0,
        fdFreeTeks: json['fdFreeTeks'].toInt() ?? 0,
        fdCancelVisit: json['fdCancelVisit'].toInt() ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }

  factory Reason.setData(Map<String, dynamic> item) {
    return Reason(
        fdTipe: item['fdTipe'] ?? '',
        fdDescription: item['fdDescription'] ?? '',
        fdKodeReason: item['fdKodeReason'] ?? '',
        fdReasonDescription: item['fdReasonDescription'] ?? '',
        fdCamera: item['fdCamera'] ?? 0,
        fdFreeTeks: item['fdFreeTeks'] ?? 0,
        fdCancelVisit: item['fdCancelVisit'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

class LanggananAlamat {
  final String? fdKodeLangganan;
  final String? fdJenis;
  final int? fdNoUrut;
  final int? fdIdAlamat;
  final String? fdAlamat;
  final double fdLatitude;
  final double fdLongitude;
  final String? fdLastUpdate;
  final String? message;
  int? fdStatusSent = 0;

  LanggananAlamat(
      {required this.fdKodeLangganan,
      required this.fdJenis,
      required this.fdNoUrut,
      required this.fdIdAlamat,
      required this.fdAlamat,
      required this.fdLatitude,
      required this.fdLongitude,
      required this.fdLastUpdate,
      this.message,
      this.fdStatusSent});

  factory LanggananAlamat.setData(Map<String, dynamic> item) {
    return LanggananAlamat(
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdJenis: item['fdJenis'] ?? '',
        fdNoUrut: item['fdNoUrut'] ?? '',
        fdIdAlamat: item['fdIdAlamat'] ?? '',
        fdAlamat: item['fdAlamat'] ?? '',
        fdLatitude: double.tryParse(item['fdLatitude'].toString()) != null
            ? item['fdLatitude'].toDouble()
            : 0,
        fdLongitude: double.tryParse(item['fdLongitude'].toString()) != null
            ? item['fdLongitude'].toDouble()
            : 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0);
  }

  factory LanggananAlamat.fromJson(Map<String, dynamic> json) {
    return LanggananAlamat(
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdJenis: json['fdJenis'] ?? '',
        fdNoUrut: json['fdNoUrut'] ?? '',
        fdIdAlamat: json['fdIdAlamat'] ?? '',
        fdAlamat: json['fdAlamat'] ?? '',
        fdLatitude: double.tryParse(json['fdLatitude'].toString()) != null
            ? json['fdLatitude'].toDouble()
            : 0,
        fdLongitude: double.tryParse(json['fdLongitude'].toString()) != null
            ? json['fdLongitude'].toDouble()
            : 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }

  factory LanggananAlamat.empty() {
    return LanggananAlamat(
        fdKodeLangganan: '',
        fdJenis: '',
        fdNoUrut: 0,
        fdIdAlamat: 0,
        fdAlamat: '',
        fdLatitude: 0,
        fdLongitude: 0,
        fdLastUpdate: '',
        fdStatusSent: 0);
  }
}

class LanggananTOP {
  final String? fdKodeLangganan;
  final String? fdKodeGroup;
  final String? fdKodeBarang;
  final int? fdTOP;
  final String? fdLastUpdate;
  final String? message;
  int? fdStatusSent = 0;

  LanggananTOP(
      {required this.fdKodeLangganan,
      required this.fdKodeGroup,
      required this.fdKodeBarang,
      required this.fdTOP,
      required this.fdLastUpdate,
      this.message,
      this.fdStatusSent});

  factory LanggananTOP.setData(Map<String, dynamic> item) {
    return LanggananTOP(
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdKodeGroup: item['fdKodeGroup'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdTOP: item['fdTOP'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0);
  }

  factory LanggananTOP.fromJson(Map<String, dynamic> json) {
    return LanggananTOP(
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdTOP: json['fdTOP'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }

  factory LanggananTOP.empty() {
    return LanggananTOP(
        fdKodeLangganan: '',
        fdKodeGroup: '',
        fdKodeBarang: '',
        fdTOP: 0,
        fdLastUpdate: '',
        fdStatusSent: 0);
  }
}

class Bank {
  final String fdKodeBank;
  final String fdNamaBank;
  final String fdNamaSingkat;
  final String? fdLastUpdate;
  int? fdStatusSent = 0;
  final String? message;

  Bank(
      {required this.fdKodeBank,
      required this.fdNamaBank,
      required this.fdNamaSingkat,
      required this.fdLastUpdate,
      this.fdStatusSent,
      this.message});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        fdKodeBank: json['fdKodeBank'] ?? '',
        fdNamaBank: json['fdNamaBank'] ?? '',
        fdNamaSingkat: json['fdNamaSingkat'] ?? '',
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }

  factory Bank.setData(Map<String, dynamic> item) {
    return Bank(
        fdKodeBank: item['fdKodeBank'] ?? '',
        fdNamaBank: item['fdNamaBank'] ?? '',
        fdNamaSingkat: item['fdNamaSingkat'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        message: item['message'] ?? '');
  }
}
