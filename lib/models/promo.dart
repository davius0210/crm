class Promo {
  final String? fdKodePromo;
  final String? fdDescription;
  final String? fdStartDate;
  final String? fdEndDate;
  final int? fdGroupOutlet;
  final int? fdCustomer;
  final int? fdSellingPoint;
  final String? fdKodeJenisPromo;
  final String? fdPhoto;
  final String? fdKodeStatus;
  final String? fdLastUpdate;

  Promo(
      {required this.fdKodePromo,
      required this.fdDescription,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdGroupOutlet,
      required this.fdCustomer,
      required this.fdSellingPoint,
      required this.fdKodeJenisPromo,
      required this.fdPhoto,
      required this.fdKodeStatus,
      required this.fdLastUpdate});

  factory Promo.setData(Map<String, dynamic> item) {
    return Promo(
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdGroupOutlet: item['fdGroupOutlet'] ?? 0,
      fdCustomer: item['fdCustomer'] ?? 0,
      fdSellingPoint: item['fdSellingPoint'] ?? 0,
      fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
      fdPhoto: item['fdPhoto'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Promo.fromJson(Map<String, dynamic> json, int inRute) {
    return Promo(
        fdKodePromo: json['fdKodePromo'] ?? '',
        fdDescription: json['fdDescription'] ?? '',
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdGroupOutlet: json['fdGroupOutlet'] ?? 0,
        fdCustomer: json['fdCustomer'] ?? 0,
        fdSellingPoint: json['fdSellingPoint'] ?? 0,
        fdKodeJenisPromo: json['fdKodeJenisPromo'] ?? '',
        fdPhoto: json['fdPhoto'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '');
  }

  factory Promo.empty() {
    return Promo(
      fdKodePromo: '',
      fdDescription: '',
      fdStartDate: '',
      fdEndDate: '',
      fdGroupOutlet: 0,
      fdCustomer: 0,
      fdSellingPoint: 0,
      fdKodeJenisPromo: '',
      fdPhoto: '',
      fdKodeStatus: '',
      fdLastUpdate: '',
    );
  }
}

class PromoBarang {
  final String? fdKodePromo;
  final String? fdDescription;
  final String? fdStartDate;
  final String? fdEndDate;
  final int? fdGroupOutlet;
  final int? fdCustomer;
  final int? fdSellingPoint;
  final String? fdKodeJenisPromo;
  final String? fdPhoto;
  final String? fdKodeStatus;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdLastUpdate;

  PromoBarang({
    required this.fdKodePromo,
    required this.fdDescription,
    required this.fdStartDate,
    required this.fdEndDate,
    required this.fdGroupOutlet,
    required this.fdCustomer,
    required this.fdSellingPoint,
    required this.fdKodeJenisPromo,
    required this.fdPhoto,
    required this.fdKodeStatus,
    required this.fdKodeBarang,
    required this.fdNamaBarang,
    required this.fdLastUpdate,
  });

  factory PromoBarang.setData(Map<String, dynamic> item) {
    return PromoBarang(
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdGroupOutlet: item['fdGroupOutlet'] ?? 0,
      fdCustomer: item['fdCustomer'] ?? 0,
      fdSellingPoint: item['fdSellingPoint'] ?? 0,
      fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
      fdPhoto: item['fdPhoto'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory PromoBarang.fromJson(Map<String, dynamic> json, int inRute) {
    return PromoBarang(
        fdKodePromo: json['fdKodePromo'] ?? '',
        fdDescription: json['fdDescription'] ?? '',
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdGroupOutlet: json['fdGroupOutlet'] ?? 0,
        fdCustomer: json['fdCustomer'] ?? 0,
        fdSellingPoint: json['fdSellingPoint'] ?? 0,
        fdKodeJenisPromo: json['fdKodeJenisPromo'] ?? '',
        fdPhoto: json['fdPhoto'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '');
  }

  factory PromoBarang.empty() {
    return PromoBarang(
      fdKodePromo: '',
      fdDescription: '',
      fdStartDate: '',
      fdEndDate: '',
      fdGroupOutlet: 0,
      fdCustomer: 0,
      fdSellingPoint: 0,
      fdKodeJenisPromo: '',
      fdPhoto: '',
      fdKodeStatus: '',
      fdKodeBarang: '',
      fdNamaBarang: '',
      fdLastUpdate: '',
    );
  }
}

class Reason {
  final String? fdTipe;
  final String? fdKodeReason;
  final String? fdReason;
  final int? fdCamera;
  final int? fdIsText;
  final String? fdLastUpdate;
  final String? code;
  final String? message;

  Reason(
      {required this.fdTipe,
      required this.fdKodeReason,
      required this.fdReason,
      required this.fdCamera,
      required this.fdIsText,
      required this.fdLastUpdate,
      this.code,
      this.message});

  factory Reason.setData(Map<String, dynamic> item) {
    return Reason(
        fdTipe: item['fdTipe'] ?? '',
        fdKodeReason: item['fdKodeReason'] ?? '',
        fdReason: item['fdReason'] ?? '',
        fdCamera: item['fdCamera'] ?? 0,
        fdIsText: item['fdIsText'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

class PromoActivity {
  final String? fdTanggal;
  final String? fdKodeBranch;
  final String? fdKodeSF;
  final String? fdNamaSF;
  final String? fdKodeLangganan;
  final String? fdKodeExternal;
  final String? fdNamaLangganan;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdKodePromo;
  final String? fdDescription;
  final String? fdStartDate;
  final String? fdEndDate;
  final String? fdKodeJenisPromo;
  final String? fdKetJenisPromo;
  final int? fdPromoStatus;
  final String? fdLastUpdate;
  String? fdData;
  String? fdMessage;

  PromoActivity(
      {required this.fdTanggal,
      required this.fdKodeBranch,
      required this.fdKodeSF,
      required this.fdNamaSF,
      required this.fdKodeLangganan,
      required this.fdKodeExternal,
      required this.fdNamaLangganan,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodePromo,
      required this.fdDescription,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdKodeJenisPromo,
      required this.fdKetJenisPromo,
      required this.fdPromoStatus,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory PromoActivity.setData(Map<String, dynamic> item) {
    return PromoActivity(
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeBranch: item['fdKodeBranch'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaSF: item['fdNamaSF'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeExternal: item['fdKodeExternal'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
      fdKetJenisPromo: item['fdKetJenisPromo'] ?? '',
      fdPromoStatus: item['fdPromoStatus'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory PromoActivity.fromJson(Map<String, dynamic> json) {
    return PromoActivity(
      fdTanggal: json['fdTanggal'] ?? '',
      fdKodeBranch: json['fdKodeBranch'] ?? '',
      fdKodeSF: json['fdKodeSF'] ?? '',
      fdNamaSF: json['fdNamaSF'] ?? '',
      fdKodeLangganan: json['fdKodeLangganan'] ?? '',
      fdKodeExternal: json['fdKodeExternal'] ?? '',
      fdNamaLangganan: json['fdNamaLangganan'] ?? '',
      fdKodeBarang: json['fdKodeBarang'] ?? '',
      fdNamaBarang: json['fdNamaBarang'] ?? '',
      fdKodePromo: json['fdKodePromo'] ?? '',
      fdDescription: json['fdDescription'] ?? '',
      fdStartDate: json['fdStartDate'] ?? '',
      fdEndDate: json['fdEndDate'] ?? '',
      fdKodeJenisPromo: json['fdKodeJenisPromo'] ?? '',
      fdKetJenisPromo: json['fdKetJenisPromo'] ?? '',
      fdPromoStatus: json['fdPromoStatus'] ?? 0,
      fdLastUpdate: json['fdLastUpdate'] ?? '',
    );
  }

  factory PromoActivity.empty() {
    return PromoActivity(
        fdTanggal: '',
        fdKodeBranch: '',
        fdKodeSF: '',
        fdNamaSF: '',
        fdKodeLangganan: '',
        fdKodeExternal: '',
        fdNamaLangganan: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdKodePromo: '',
        fdDescription: '',
        fdStartDate: '',
        fdEndDate: '',
        fdKodeJenisPromo: '',
        fdKetJenisPromo: '',
        fdPromoStatus: 0,
        fdLastUpdate: '');
  }
}

class JenisPromo {
  final String? fdKodeJenisPromo;
  final String? fdJenisPromo;
  final int? fdStatus;
  final String? fdLastUpdate;
  final String? code;
  final String? message;

  JenisPromo(
      {required this.fdKodeJenisPromo,
      required this.fdJenisPromo,
      required this.fdStatus,
      required this.fdLastUpdate,
      this.code,
      this.message});

  factory JenisPromo.setData(Map<String, dynamic> item) {
    return JenisPromo(
        fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
        fdJenisPromo: item['fdJenisPromo'] ?? '',
        fdStatus: item['fdStatus'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

// MASTER
class PopPromo {
  final String? fdKodePOPPromo;
  final String? fdPOPPromo;
  final int? fdCaptureBefore;
  final int? fdSignature;
  final int? fdBarcode;
  final int? fdCaptureAfter;
  final String? fdKodeJenisPromo;
  final String? fdLastUpdate;
  final String? code;
  final String? message;

  PopPromo(
      {required this.fdKodePOPPromo,
      required this.fdPOPPromo,
      required this.fdCaptureBefore,
      required this.fdSignature,
      required this.fdBarcode,
      required this.fdCaptureAfter,
      required this.fdKodeJenisPromo,
      required this.fdLastUpdate,
      this.code,
      this.message});

  factory PopPromo.setData(Map<String, dynamic> item) {
    return PopPromo(
        fdKodePOPPromo: item['fdKodePOPPromo'] ?? '',
        fdPOPPromo: item['fdPOPPromo'] ?? '',
        fdCaptureBefore: item['fdCaptureBefore'] ?? 0,
        fdSignature: item['fdSignature'] ?? 0,
        fdBarcode: item['fdBarcode'] ?? 0,
        fdCaptureAfter: item['fdCaptureAfter'] ?? 0,
        fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

class TransaksiPopPromo {
  // final int? fdID;
  final String? fdNoEntry;
  final String? fdTanggal;
  final String? fdKodeLangganan;
  final String? fdKodeGroup;
  final String? fdKodeBarang;
  final int fdQty;
  final String? fdDepo;
  final int fdSatuanK;
  final int fdCONV2;
  final int fdCONV3;
  final String? fdKodeSF;
  final int fdQtyK;
  final int fdQtyPop;
  final String? fdJenisPop;
  final String? fdKodeJenisPromo;
  final String? fdUCW;
  final String fdLainnya;
  final int fdStatusSent;
  final String? fdLastUpdate;
  // final String? code;
  final String? fdData;
  final String? fdMessage;

  TransaksiPopPromo(
      {
      // required this.fdID,
      required this.fdNoEntry,
      required this.fdTanggal,
      required this.fdKodeLangganan,
      required this.fdKodeGroup,
      required this.fdKodeBarang,
      required this.fdQty,
      required this.fdDepo,
      required this.fdSatuanK,
      required this.fdCONV2,
      required this.fdCONV3,
      required this.fdKodeSF,
      required this.fdQtyK,
      required this.fdQtyPop,
      required this.fdJenisPop,
      required this.fdKodeJenisPromo,
      required this.fdUCW,
      required this.fdLainnya,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory TransaksiPopPromo.setData(Map<String, dynamic> item) {
    return TransaksiPopPromo(
        // fdID: item['fdID'] ?? 0,
        fdNoEntry: item['fdNoEntry'] ?? '',
        fdTanggal: item['fdTanggal'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdKodeGroup: item['fdKodeGroup'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdQty: item['fdQty'] ?? 0,
        fdDepo: item['fdDepo'] ?? '',
        fdSatuanK: item['fdSatuanK'] ?? 0,
        fdCONV2: item['fdCONV2'] ?? 0,
        fdCONV3: item['fdCONV3'] ?? 0,
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdQtyK: item['fdQtyK'] ?? 0,
        fdQtyPop: item['fdQtyPop'] ?? 0,
        fdJenisPop: item['fdJenisPop'] ?? '',
        fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
        fdUCW: item['fdUCW'] ?? '',
        fdLainnya: item['fdLainnya'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
  factory TransaksiPopPromo.fromJson(Map<String, dynamic> item) {
    return TransaksiPopPromo(
        // fdID: item['fdID'] ?? 0,
        fdNoEntry: item['fdNoEntry'] ?? '',
        fdTanggal: item['fdTanggal'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdKodeGroup: item['fdKodeGroup'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdQty: item['fdQty'] ?? 0,
        fdDepo: item['fdDepo'] ?? '',
        fdSatuanK: item['fdSatuanK'] ?? 0,
        fdCONV2: item['fdCONV2'] ?? 0,
        fdCONV3: item['fdCONV3'] ?? 0,
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdQtyK: item['fdQtyK'] ?? 0,
        fdQtyPop: item['fdQtyPop'] ?? 0,
        fdJenisPop: item['fdJenisPop'] ?? '',
        fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
        fdUCW: item['fdUCW'] ?? '',
        fdLainnya: item['fdLainnya'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

Map<String, dynamic> setJsonDataPop(
    String? fdNoEntry,
    String? fdTanggal,
    String? fdKodeLangganan,
    String? fdKodeGroup,
    String? fdKodeBarang,
    int fdQty,
    String? fdDepo,
    int fdSatuanK,
    int fdCONV2,
    int fdCONV3,
    String? fdKodeSF,
    int fdQtyK,
    int fdQtyPop,
    String? fdJenisPop,
    String? fdKodeJenisPromo,
    String? fdUCW,
    String fdLainnya,
    int fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntry": fdNoEntry,
    "fdTanggal": fdTanggal,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeGroup": fdKodeGroup,
    "fdKodeBarang": fdKodeBarang,
    "fdQty": fdQty,
    "fdDepo": fdDepo,
    "fdSatuanK": fdSatuanK,
    "fdCONV2": fdCONV2,
    "fdCONV3": fdCONV3,
    "fdKodeSF": fdKodeSF,
    "fdQtyK": fdQtyK,
    "fdQtyPop": fdQtyPop,
    "fdJenisPop": fdJenisPop,
    "fdKodeJenisPromo": fdKodeJenisPromo,
    "fdUCW": fdUCW,
    "fdLainnya": fdLainnya,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

class FotoPopPromo {
  final String? fdNoEntry;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdFoto;
  final String? fdTanggal;
  final int? fdUrut;
  final int? fdStatusSent;
  final String? fdLastUpdate;
  final String? fdData;
  final String? fdMessage;

  FotoPopPromo(
      {required this.fdNoEntry,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdFoto,
      required this.fdTanggal,
      required this.fdUrut,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory FotoPopPromo.setData(Map<String, dynamic> item) {
    return FotoPopPromo(
        fdNoEntry: item['fdNoEntry'] ?? '',
        fdDepo: item['fdDepo'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdFoto: item['fdFoto'] ?? '',
        fdTanggal: item['fdTanggal'] ?? '',
        fdUrut: item['fdUrut'] ?? 0,
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

Map<String, dynamic> setJsonDataPopFoto(
    String? fdNoEntry,
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdFoto,
    String? fdTanggal,
    int? fdUrut,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntry": fdNoEntry,
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdFoto": fdFoto,
    "fdTanggal": fdTanggal,
    "fdUrut": fdUrut,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

Map<String, dynamic> setJsonDataPromoActivity(
    String? fdTanggal,
    String? fdKodeBranch,
    String? fdKodeSF,
    String? fdKodeLangganan,
    String? fdKodePromo,
    String? fdKodeBarang,
    int? fdPromoStatus) {
  return <String, dynamic>{
    "fdTanggal": fdTanggal,
    "fdKodeBranch": fdKodeBranch,
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodePromo": fdKodePromo,
    "fdKodeBarang": fdKodeBarang,
    "fdPromoStatus": fdPromoStatus
  };
}

class PromoActivityServer {
  final String? fdTanggal;
  final String? fdKodeBranch;
  final String? fdKodeSF;
  final String? fdKodeLangganan;
  final String? fdKodePromo;
  final String? fdKodeBarang;
  final int? fdPromoStatus;
  String? fdData;
  String? fdMessage;
  PromoActivityServer(
      {required this.fdTanggal,
      required this.fdKodeBranch,
      required this.fdKodeSF,
      required this.fdKodeLangganan,
      required this.fdKodePromo,
      required this.fdKodeBarang,
      required this.fdPromoStatus,
      this.fdData,
      this.fdMessage});
  factory PromoActivityServer.setData(Map<String, dynamic> item) {
    return PromoActivityServer(
        fdTanggal: item['fdTanggal'] ?? '',
        fdKodeBranch: item['fdKodeBranch'] ?? '',
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdKodePromo: item['fdKodePromo'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdPromoStatus: item['fdPromoStatus'] ?? 0);
  }
  factory PromoActivityServer.fromJson(Map<String, dynamic> json) {
    return PromoActivityServer(
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeBranch: json['fdKodeBranch'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodePromo: json['fdKodePromo'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromoStatus: json['fdPromoStatus'] ?? 0);
  }
}

class ViewPromoActivityJoinPop {
  final String? fdTanggal;
  final String? fdKodeBranch;
  final String? fdKodeSF;
  final String? fdNamaSF;
  final String? fdKodeLangganan;
  final String? fdKodeExternal;
  final String? fdNamaLangganan;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdKodePromo;
  final String? fdDescription;
  final String? fdStartDate;
  final String? fdEndDate;
  final String? fdKodeJenisPromo;
  final String? fdKetJenisPromo;
  final String? fdUCW;
  final String? fdLainnya;
  final int? fdPromoStatus;
  final String? fdLastUpdate;
  String? fdData;
  String? fdMessage;

  ViewPromoActivityJoinPop(
      {required this.fdTanggal,
      required this.fdKodeBranch,
      required this.fdKodeSF,
      required this.fdNamaSF,
      required this.fdKodeLangganan,
      required this.fdKodeExternal,
      required this.fdNamaLangganan,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodePromo,
      required this.fdDescription,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdKodeJenisPromo,
      required this.fdKetJenisPromo,
      required this.fdUCW,
      required this.fdLainnya,
      required this.fdPromoStatus,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory ViewPromoActivityJoinPop.setData(Map<String, dynamic> item) {
    return ViewPromoActivityJoinPop(
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeBranch: item['fdKodeBranch'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaSF: item['fdNamaSF'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeExternal: item['fdKodeExternal'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdKodeJenisPromo: item['fdKodeJenisPromo'] ?? '',
      fdKetJenisPromo: item['fdKetJenisPromo'] ?? '',
      fdUCW: item['fdUCW'] ?? '',
      fdLainnya: item['fdLainnya'] ?? '',
      fdPromoStatus: item['fdPromoStatus'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }
}

class PromoGroupLangganan {
  final String? fdKodePromo;
  final String? fdKodeGroupLangganan;
  final String? fdKodeStatus;
  final String? fdLastUpdate;

  PromoGroupLangganan({
    required this.fdKodePromo,
    required this.fdKodeGroupLangganan,
    required this.fdKodeStatus,
    required this.fdLastUpdate,
  });

  factory PromoGroupLangganan.setData(Map<String, dynamic> item) {
    return PromoGroupLangganan(
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory PromoGroupLangganan.fromJson(Map<String, dynamic> json, int inRute) {
    return PromoGroupLangganan(
        fdKodePromo: json['fdKodePromo'] ?? '',
        fdKodeGroupLangganan: json['fdKodeGroupLangganan'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '');
  }

  factory PromoGroupLangganan.empty() {
    return PromoGroupLangganan(
      fdKodePromo: '',
      fdKodeGroupLangganan: '',
      fdKodeStatus: '',
      fdLastUpdate: '',
    );
  }
}

class PromoLangganan {
  final String? fdKodePromo;
  final String? fdKodeLangganan;
  final String? fdKodeStatus;
  final String? fdLastUpdate;

  PromoLangganan({
    required this.fdKodePromo,
    required this.fdKodeLangganan,
    required this.fdKodeStatus,
    required this.fdLastUpdate,
  });

  factory PromoLangganan.setData(Map<String, dynamic> item) {
    return PromoLangganan(
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory PromoLangganan.fromJson(Map<String, dynamic> json, int inRute) {
    return PromoLangganan(
        fdKodePromo: json['fdKodePromo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '');
  }

  factory PromoLangganan.empty() {
    return PromoLangganan(
      fdKodePromo: '',
      fdKodeLangganan: '',
      fdKodeStatus: '',
      fdLastUpdate: '',
    );
  }
}

class ViewBarangPromo {
  final String fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdKodeGroupBarang;
  final String? fdKodePromo;
  final String? fdDescription;
  String? fdData;
  String? fdMessage;

  ViewBarangPromo(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodeGroupBarang,
      required this.fdKodePromo,
      required this.fdDescription,
      this.fdData,
      this.fdMessage});

  factory ViewBarangPromo.setData(Map<String, dynamic> item) {
    return ViewBarangPromo(
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdKodeGroupBarang: item['fdKodeGroupBarang'] ?? '',
      fdKodePromo: item['fdKodePromo'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
    );
  }
}
