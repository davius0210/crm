class Oos {
  final String? fdTanggal;
  final String? fdDocNo;
  final String? fdKodeLangganan;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdKodeGroup;
  final int fdIsGudang;
  final int fdIsKomputer;
  final int fdQty;
  final String? fdKodeDepo;
  final String? fdUOM1;
  final String? fdUOM2;
  final String? fdUOM3;
  final int fdCONV2;
  final int fdCONV3;
  final String? fdKodeSF;
  final int fdQtyPajang;
  final int fdQtyGudang;
  final int fdQtyKomputer;
  final int fdQty4;
  final int fdQty5;
  final String? fdReason;
  final String? fdRemark;
  final int fdQtyOOS;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  Oos(
      {required this.fdTanggal,
      required this.fdDocNo,
      required this.fdKodeLangganan,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodeGroup,
      required this.fdIsGudang,
      required this.fdIsKomputer,
      required this.fdQty,
      required this.fdKodeDepo,
      required this.fdUOM1,
      required this.fdUOM2,
      required this.fdUOM3,
      required this.fdCONV2,
      required this.fdCONV3,
      required this.fdKodeSF,
      required this.fdQtyPajang,
      required this.fdQtyGudang,
      required this.fdQtyKomputer,
      required this.fdQty4,
      required this.fdQty5,
      required this.fdReason,
      required this.fdRemark,
      required this.fdQtyOOS,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory Oos.setData(Map<String, dynamic> item) {
    return Oos(
      fdTanggal: item['fdTanggal'] ?? '',
      fdDocNo: item['fdDocNo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdKodeGroup: item['fdKodeGroup'] ?? '',
      fdIsGudang: item['fdIsGudang'] ?? 0,
      fdIsKomputer: item['fdIsKomputer'] ?? 0,
      fdQty: item['fdQty'] ?? 0,
      fdKodeDepo: item['fdKodeDepo'] ?? '',
      fdUOM1: item['fdUOM1'] ?? '',
      fdUOM2: item['fdUOM2'] ?? '',
      fdUOM3: item['fdUOM3'] ?? '',
      fdCONV2: item['fdCONV2'] ?? 0,
      fdCONV3: item['fdCONV3'] ?? 0,
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdQtyPajang: item['fdQtyPajang'] ?? 0,
      fdQtyGudang: item['fdQtyGudang'] ?? 0,
      fdQtyKomputer: item['fdQtyKomputer'] ?? 0,
      fdQty4: item['fdQty4'] ?? 0,
      fdQty5: item['fdQty5'] ?? 0,
      fdReason: item['fdReason'] ?? '',
      fdRemark: item['fdRemark'] ?? '',
      fdQtyOOS: item['fdQtyOOS'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Oos.fromJson(Map<String, dynamic> json) {
    return Oos(
        fdTanggal: json['fdTanggal'] ?? '',
        fdDocNo: json['fdDocNo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdIsGudang: json['fdIsGudang'] ?? 0,
        fdIsKomputer: json['fdIsKomputer'] ?? 0,
        fdQty: json['fdQty'] ?? 0,
        fdKodeDepo: json['fdKodeDepo'] ?? '',
        fdUOM1: json['fdUOM1'] ?? '',
        fdUOM2: json['fdUOM2'] ?? '',
        fdUOM3: json['fdUOM3'] ?? '',
        fdCONV2: json['fdCONV2'] ?? 0,
        fdCONV3: json['fdCONV3'] ?? 0,
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdQtyPajang: json['fdQtyPajang'] ?? 0,
        fdQtyGudang: json['fdQtyGudang'] ?? 0,
        fdQtyKomputer: json['fdQtyKomputer'] ?? 0,
        fdQty4: json['fdQty4'] ?? 0,
        fdQty5: json['fdQty5'] ?? 0,
        fdReason: json['fdReason'] ?? '',
        fdRemark: json['fdRemark'] ?? '',
        fdQtyOOS: json['fdQtyOOS'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory Oos.empty() {
    return Oos(
        fdTanggal: '',
        fdDocNo: '',
        fdKodeLangganan: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdKodeGroup: '',
        fdIsGudang: 0,
        fdIsKomputer: 0,
        fdQty: 0,
        fdKodeDepo: '',
        fdUOM1: '',
        fdUOM2: '',
        fdUOM3: '',
        fdCONV2: 0,
        fdCONV3: 0,
        fdKodeSF: '',
        fdQtyPajang: 0,
        fdQtyGudang: 0,
        fdQtyKomputer: 0,
        fdQty4: 0,
        fdQty5: 0,
        fdReason: '',
        fdRemark: '',
        fdQtyOOS: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataOOS(
    String? fdTanggal,
    String? fdDocNo,
    String? fdKodeLangganan,
    String? fdKodeBarang,
    String? fdKodeGroup,
    int fdIsGudang,
    int fdIsKomputer,
    int fdQty,
    String? fdKodeDepo,
    String? fdUOM1,
    String? fdUOM2,
    String? fdUOM3,
    int fdCONV2,
    int fdCONV3,
    String? fdKodeSF,
    int fdQtyPajang,
    int fdQtyGudang,
    int fdQtyKomputer,
    int fdQty4,
    int fdQty5,
    String? fdReason,
    String? fdRemark,
    int fdQtyOOS,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdTanggal": fdTanggal,
    "fdDocNo": fdDocNo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeBarang": fdKodeBarang,
    "fdKodeGroup": fdKodeGroup,
    "fdIsGudang": fdIsGudang,
    "fdIsKomputer": fdIsKomputer,
    "fdQty": fdQty,
    "fdKodeDepo": fdKodeDepo,
    "fdUOM1": fdUOM1,
    "fdUOM2": fdUOM2,
    "fdUOM3": fdUOM3,
    "fdCONV2": fdCONV2,
    "fdCONV3": fdCONV3,
    "fdKodeSF": fdKodeSF,
    "fdQtyPajang": fdQtyPajang,
    "fdQtyGudang": fdQtyGudang,
    "fdQtyKomputer": fdQtyKomputer,
    "fdQty4": fdQty4,
    "fdQty5": fdQty5,
    "fdReason": fdReason,
    "fdRemark": fdRemark,
    "fdQtyOOS": fdQtyOOS,
    "fdLastUpdate": fdLastUpdate
  };
}

class OosNotSold {
  final String? fdTanggal;
  final String? fdDocNo;
  final String? fdKodeLangganan;
  final String? fdKodeBarang;
  final String? fdKodeGroup;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  OosNotSold(
      {required this.fdTanggal,
      required this.fdDocNo,
      required this.fdKodeLangganan,
      required this.fdKodeBarang,
      required this.fdKodeGroup,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory OosNotSold.setData(Map<String, dynamic> item) {
    return OosNotSold(
      fdTanggal: item['fdTanggal'] ?? '',
      fdDocNo: item['fdDocNo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdKodeGroup: item['fdKodeGroup'] ?? '',
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }
}
