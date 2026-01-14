class RakDisplay {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdKodeRak;
  final String fdKategoriRak;
  final bool isPlanoMatch;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final int fdJmlTier;
  final int fdTingkatShelving;
  final int fdShelvingKe;
  int fdStatusSent = 0;

  RakDisplay(
      {required this.fdKodeSF,
      required this.fdKodeLangganan,
      required this.fdTransDate,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodeRak,
      required this.fdKategoriRak,
      required this.isPlanoMatch,
      required this.fdJmlTier,
      required this.fdTingkatShelving,
      required this.fdShelvingKe,
      required this.fdStatusSent});

  factory RakDisplay.setData(Map<String, dynamic> item) {
    return RakDisplay(
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdTransDate: item['fdTransDate'] ?? '',
        fdKodeRak: item['fdKodeRak'] ?? '',
        fdKategoriRak: item['fdKategoriRak'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        isPlanoMatch: item['isPlanoMatch'] ?? false,
        fdJmlTier: item['fdJmlTier'].toInt() ?? 0,
        fdTingkatShelving: item['fdTingkatShelving'].toInt() ?? 0,
        fdShelvingKe: item['fdShelvingKe'].toInt() ?? 0,
        fdStatusSent: item['fdStatusSent'].toInt() ?? 0);
  }
}

class RakTipe {
  final String? fdRakTipe;
  final String? fdDescription;
  final String? fdKodeStatus;
  final String? fdLastUpdate;

  RakTipe(
      {required this.fdRakTipe,
      required this.fdDescription,
      required this.fdKodeStatus,
      required this.fdLastUpdate});

  factory RakTipe.setData(Map<String, dynamic> item) {
    return RakTipe(
      fdRakTipe: item['fdRakTipe'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RakTipe.fromJson(Map<String, dynamic> json, int inRute) {
    return RakTipe(
        fdRakTipe: json['fdRakTipe'] ?? '',
        fdDescription: json['fdDescription'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '');
  }

  factory RakTipe.empty() {
    return RakTipe(
      fdRakTipe: '',
      fdDescription: '',
      fdKodeStatus: '',
      fdLastUpdate: '',
    );
  }
}

class RakDisplayActivity {
  final String? fdTanggal;
  final String? fdKodeCabang;
  final String? fdKodeSF;
  final String? fdNamaSF;
  final String? fdKodeLangganan;
  final String? fdKodeExternal;
  final String? fdNamaLangganan;
  final String? fdKodeKategoriRak;
  final String? fdKodeKategoriRakDesc;
  final String? fdKodeRakDisplay;
  final String? fdKodeRakDisplayDesc;
  final int? fdPlanogram;
  final String? fdFotoBefore1;
  final String? fdFotoBefore2;
  final String? fdFotoBefore3;
  final String? fdFotoAfter1;
  final String? fdFotoAfter2;
  final String? fdFotoAfter3;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final int? fdJumlahTier;
  final int? fdShelving;
  final int? fdShelvingKe;
  final int? fdStatusSent;
  final String? fdLastUpdate;
  String? fdData;
  String? fdMessage;

  RakDisplayActivity(
      {required this.fdTanggal,
      required this.fdKodeCabang,
      required this.fdKodeSF,
      required this.fdNamaSF,
      required this.fdKodeLangganan,
      required this.fdKodeExternal,
      required this.fdNamaLangganan,
      required this.fdKodeKategoriRak,
      required this.fdKodeKategoriRakDesc,
      required this.fdKodeRakDisplay,
      required this.fdKodeRakDisplayDesc,
      required this.fdPlanogram,
      required this.fdFotoBefore1,
      required this.fdFotoBefore2,
      required this.fdFotoBefore3,
      required this.fdFotoAfter1,
      required this.fdFotoAfter2,
      required this.fdFotoAfter3,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdJumlahTier,
      required this.fdShelving,
      required this.fdShelvingKe,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory RakDisplayActivity.setData(Map<String, dynamic> item) {
    return RakDisplayActivity(
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeCabang: item['fdKodeCabang'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdNamaSF: item['fdNamaSF'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeExternal: item['fdKodeExternal'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      fdKodeKategoriRak: item['fdKodeKategoriRak'] ?? '',
      fdKodeKategoriRakDesc: item['fdKodeKategoriRakDesc'] ?? '',
      fdKodeRakDisplay: item['fdKodeRakDisplay'] ?? '',
      fdKodeRakDisplayDesc: item['fdKodeRakDisplayDesc'] ?? '',
      fdPlanogram: item['fdPlanogram'] ?? 0,
      fdFotoBefore1: item['fdFotoBefore1'] ?? '',
      fdFotoBefore2: item['fdFotoBefore2'] ?? '',
      fdFotoBefore3: item['fdFotoBefore3'] ?? '',
      fdFotoAfter1: item['fdFotoAfter1'] ?? '',
      fdFotoAfter2: item['fdFotoAfter2'] ?? '',
      fdFotoAfter3: item['fdFotoAfter3'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdJumlahTier: item['fdJumlahTier'] ?? 0,
      fdShelving: item['fdShelving'] ?? 0,
      fdShelvingKe: item['fdShelvingKe'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory RakDisplayActivity.fromJson(Map<String, dynamic> json) {
    return RakDisplayActivity(
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeCabang: json['fdKodeCabang'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdNamaSF: json['fdNamaSF'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeExternal: json['fdKodeExternal'] ?? '',
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        fdKodeKategoriRak: json['fdKodeKategoriRak'] ?? '',
        fdKodeKategoriRakDesc: json['fdKodeKategoriRakDesc'] ?? '',
        fdKodeRakDisplay: json['fdKodeRakDisplay'] ?? '',
        fdKodeRakDisplayDesc: json['fdKodeRakDisplayDesc'] ?? '',
        fdPlanogram: json['fdPlanogram'] ?? 0,
        fdFotoBefore1: json['fdFotoBefore1'] ?? '',
        fdFotoBefore2: json['fdFotoBefore2'] ?? '',
        fdFotoBefore3: json['fdFotoBefore3'] ?? '',
        fdFotoAfter1: json['fdFotoAfter1'] ?? '',
        fdFotoAfter2: json['fdFotoAfter2'] ?? '',
        fdFotoAfter3: json['fdFotoAfter3'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdJumlahTier: json['fdJumlahTier'] ?? 0,
        fdShelving: json['fdShelving'] ?? 0,
        fdShelvingKe: json['fdShelvingKe'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory RakDisplayActivity.empty() {
    return RakDisplayActivity(
        fdTanggal: '',
        fdKodeCabang: '',
        fdKodeSF: '',
        fdNamaSF: '',
        fdKodeLangganan: '',
        fdKodeExternal: '',
        fdNamaLangganan: '',
        fdKodeKategoriRak: '',
        fdKodeKategoriRakDesc: '',
        fdKodeRakDisplay: '',
        fdKodeRakDisplayDesc: '',
        fdPlanogram: 0,
        fdFotoBefore1: '',
        fdFotoBefore2: '',
        fdFotoBefore3: '',
        fdFotoAfter1: '',
        fdFotoAfter2: '',
        fdFotoAfter3: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdJumlahTier: 0,
        fdShelving: 0,
        fdShelvingKe: 0,
        fdStatusSent: 0,
        fdLastUpdate: '');
  }
}

Map<String, dynamic> setJsonData(
    String? fdTanggal,
    String? fdKodeCabang,
    String? fdKodeSF,
    String? fdKodeLangganan,
    String? fdKodeKategoriRak,
    String? fdKodeRakDisplay,
    int? fdPlanogram,
    String? fdFotoBefore1,
    String? fdFotoBefore2,
    String? fdFotoBefore3,
    String? fdFotoAfter1,
    String? fdFotoAfter2,
    String? fdFotoAfter3,
    String? fdKodeBarang,
    int? fdJumlahTier,
    int? fdShelving,
    int? fdShelvingKe) {
  return <String, dynamic>{
    "fdTanggal": fdTanggal,
    "fdKodeDepo": fdKodeCabang,
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeKategoriRak": fdKodeKategoriRak,
    "fdKodeRakDisplay": fdKodeRakDisplay,
    "fdPlanogram": fdPlanogram,
    "fdFotoBefore1": fdFotoBefore1,
    "fdFotoBefore2": fdFotoBefore2,
    "fdFotoBefore3": fdFotoBefore3,
    "fdFotoAfter1": fdFotoAfter1,
    "fdFotoAfter2": fdFotoAfter2,
    "fdFotoAfter3": fdFotoAfter3,
    "fdKodeBarang": fdKodeBarang,
    "fdJumlahTier": fdJumlahTier,
    "fdShelving": fdShelving,
    "fdShelvingKe": fdShelvingKe
  };
}
