class Barang {
  final String fdKodeBarang;
  final String fdNamaBarang;
  String? fdKodeGroup;
  String? fdSatuanK;
  String? fdSatuanS;
  String? fdSatuanB;
  int? fdKonvS_K;
  int? fdKonvB_S;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  Barang(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      this.fdKodeGroup,
      this.fdSatuanK,
      this.fdSatuanS,
      this.fdSatuanB,
      this.fdKonvS_K,
      this.fdKonvB_S,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory Barang.setData(Map<String, dynamic> item) {
    return Barang(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        fdKodeGroup: item['fdKodeGroupBarang'] ?? '',
        fdSatuanK: item['fdSatuanK'] ?? '',
        fdSatuanS: item['fdSatuanS'] ?? '',
        fdSatuanB: item['fdSatuanB'] ?? '',
        fdKonvS_K: item['fdKonvS_K'] == null ? 0 : item['fdKonvS_K'].toInt(),
        fdKonvB_S: item['fdKonvB_S'] == null ? 0 : item['fdKonvB_S'].toInt(),
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdSatuanK: json['fdSatuanK'] ?? '',
        fdSatuanS: json['fdSatuanS'] ?? '',
        fdSatuanB: json['fdSatuanB'] ?? '',
        fdKonvS_K: json['fdKonvS_K'] == null ? 0 : json['fdKonvS_K'].toInt(),
        fdKonvB_S: json['fdKonvB_S'] == null ? 0 : json['fdKonvB_S'].toInt(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class GroupBarang {
  final String fdKodeGroup;
  final String fdDescription;
  final String fdGroupInduk;
  final String fdLastUpdate;
  final int? code;
  final String? message;

  GroupBarang(
      {required this.fdKodeGroup,
      required this.fdDescription,
      required this.fdGroupInduk,
      required this.fdLastUpdate,
      this.code,
      this.message});

  factory GroupBarang.setData(Map<String, dynamic> item) {
    return GroupBarang(
        fdKodeGroup: item['fdKodeGroup'] ?? '',
        fdDescription: item['fdNamaGroup'] ?? '',
        fdGroupInduk: item['fdGroupInduk'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory GroupBarang.fromJson(Map<String, dynamic> json) {
    return GroupBarang(
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdDescription: json['fdNamaGroup'] ?? '',
        fdGroupInduk: json['fdGroupInduk'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class BarangInputed {
  final String fdKodeBarang;
  final String fdNamaBarang;
  final String fdKodeGroup;
  final String fdUOM1;
  final String fdUOM2;
  final String fdUOM3;
  final int fdCONV2;
  final int fdCONV3;
  final String fdKodeBrand;
  final String input;
  final String fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  BarangInputed(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodeGroup,
      required this.fdUOM1,
      required this.fdUOM2,
      required this.fdUOM3,
      required this.fdCONV2,
      required this.fdCONV3,
      required this.fdKodeBrand,
      required this.input,
      required this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory BarangInputed.setData(Map<String, dynamic> item) {
    return BarangInputed(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        fdKodeGroup: item['fdKodeGroupBarang'] ?? '',
        fdUOM1: item['fdUOM1'] ?? '',
        fdUOM2: item['fdUOM2'] ?? '',
        fdUOM3: item['fdUOM3'] ?? '',
        fdCONV2: item['fdCONV2'] == null ? 0 : item['fdCONV2'].toInt(),
        fdCONV3: item['fdCONV3'] == null ? 0 : item['fdCONV3'].toInt(),
        fdKodeBrand: item['fdKodeBrand'] ?? '',
        input: item['input'] ?? '0',
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }
}

class HargaJualBarang {
  final String fdKodeHarga;
  final String fdKodeBarang;
  final double fdHarga;
  final double fdHargaQty;
  final double fdHargaSatuan;
  final String fdKodeLangganan;
  final String fdTermasukPPN;
  final String fdLastUpdate;
  final String? message;

  HargaJualBarang(
      {required this.fdKodeHarga,
      required this.fdKodeBarang,
      required this.fdHarga,
      required this.fdHargaQty,
      required this.fdHargaSatuan,
      required this.fdKodeLangganan,
      required this.fdTermasukPPN,
      required this.fdLastUpdate,
      this.message});

  factory HargaJualBarang.setData(Map<String, dynamic> item) {
    return HargaJualBarang(
        fdKodeHarga: item['fdKodeHarga'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdHarga: item['fdHarga'] ?? '',
        fdHargaQty: item['fdHargaQty'] ?? '',
        fdHargaSatuan: item['fdHargaSatuan'] ?? '',
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdTermasukPPN: item['fdTermasukPPN'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory HargaJualBarang.fromJson(Map<String, dynamic> json) {
    return HargaJualBarang(
        fdKodeHarga: json['fdKodeHarga'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdHarga: double.tryParse(json['fdHarga'].toString()) != null
            ? json['fdHarga'].toDouble()
            : 0,
        fdHargaQty: double.tryParse(json['fdHargaQty'].toString()) != null
            ? json['fdHargaQty'].toDouble()
            : 0,
        fdHargaSatuan: double.tryParse(json['fdHargaSatuan'].toString()) != null
            ? json['fdHargaSatuan'].toDouble()
            : 0,
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdTermasukPPN: json['fdTermasukPPN'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }
}

class BarangSelected {
  final String fdKodeBarang;
  final String fdNamaBarang;
  double? fdQty;
  double? fdQtyK;
  int? fdJenisSatuan;
  String? fdNamaJenisSatuan;
  String? fdPromosi;
  double? fdHargaAsli;
  double? fdUnitPrice;
  double? fdUnitPriceK;
  double? fdTotalPrice;
  double? fdTotalPriceK;
  double? fdDiscount;
  String? fdDiscountDetail;
  int? fdKonvB_S;
  int? fdKonvS_K;
  int? fdQtyStock;
  int? fdQtyStockK;
  String? isHanger;
  String? isShow;
  String? jnItem;
  int? urut;
  String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  BarangSelected(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      this.fdQty,
      this.fdQtyK,
      this.fdJenisSatuan,
      this.fdNamaJenisSatuan,
      this.fdPromosi,
      this.fdHargaAsli,
      this.fdUnitPrice,
      this.fdUnitPriceK,
      this.fdTotalPrice,
      this.fdTotalPriceK,
      this.fdDiscount,
      this.fdDiscountDetail,
      this.fdKonvB_S,
      this.fdKonvS_K,
      this.fdQtyStock,
      this.fdQtyStockK,
      this.isHanger,
      this.isShow,
      this.jnItem,
      this.urut,
      this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory BarangSelected.setData(Map<String, dynamic> item) {
    return BarangSelected(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        fdQty: double.tryParse(item['fdQty'].toString()) ?? 0,
        fdQtyK: double.tryParse(item['fdQtyK'].toString()) ?? 0,
        fdJenisSatuan: int.tryParse(item['fdJenisSatuan'].toString()) ?? 0,
        fdNamaJenisSatuan: item['fdNamaJenisSatuan'] ?? '',
        fdPromosi: item['fdPromosi'] ?? '',
        fdHargaAsli: item['fdHargaAsli'] ?? 0,
        fdUnitPrice: item['fdUnitPrice'] ?? 0,
        fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
        fdTotalPrice: item['fdTotalPrice'] ?? 0,
        fdTotalPriceK: item['fdTotalPriceK'] ?? 0,
        fdDiscount: item['fdDiscount'] ?? 0,
        fdDiscountDetail: item['fdDiscountDetail'] ?? '',
        fdKonvB_S: item['fdKonvB_S'] ?? 0,
        fdKonvS_K: item['fdKonvS_K'] ?? 0,
        fdQtyStock: item['fdQtyStock'] ?? 0,
        fdQtyStockK: item['fdQtyStockK'] ?? 0,
        isHanger: item['isHanger'] ?? '0',
        isShow: item['isShow'] ?? '0',
        jnItem: item['jnItem'] ?? '',
        urut: item['urut'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory BarangSelected.setDataBarangExtra(Map<String, dynamic> item) {
    return BarangSelected(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        fdQty: double.tryParse(item['fdQty'].toString()) ?? 0,
        fdQtyK: double.tryParse(item['fdQtyK'].toString()) ?? 0,
        fdJenisSatuan: item['fdJenisSatuan'] ?? 0,
        fdNamaJenisSatuan: item['fdNamaJenisSatuan'] ?? '',
        fdPromosi: '1',
        fdHargaAsli: item['fdHargaAsli'] ?? 0,
        fdUnitPrice: item['fdUnitPrice'] ?? 0,
        fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
        fdTotalPrice: item['fdTotalPrice'] ?? 0,
        fdTotalPriceK: item['fdTotalPriceK'] ?? 0,
        fdKonvB_S: item['fdKonvB_S'] ?? 0,
        fdKonvS_K: item['fdKonvS_K'] ?? 0,
        fdQtyStock: item['fdQtyStock'] ?? 0,
        fdQtyStockK: item['fdQtyStockK'] ?? 0,
        isHanger: item['isHanger'] ?? '',
        isShow: item['isShow'] ?? '0',
        jnItem: item['jnItem'] ?? '',
        urut: item['urut'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        message: '');
  }

  factory BarangSelected.fromJson(Map<String, dynamic> json) {
    return BarangSelected(
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdQty: double.tryParse(json['fdQty'].toString()) ?? 0,
        fdQtyK: double.tryParse(json['fdQtyK'].toString()) ?? 0,
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdNamaJenisSatuan: json['fdNamaJenisSatuan'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdHargaAsli: json['fdHargaAsli'] ?? 0,
        fdUnitPrice: json['fdUnitPrice'] ?? 0,
        fdUnitPriceK: json['fdUnitPriceK'] ?? 0,
        fdTotalPrice: json['fdTotalPrice'] ?? 0,
        fdTotalPriceK: json['fdTotalPriceK'] ?? 0,
        fdDiscount: json['fdDiscount'] ?? 0,
        fdDiscountDetail: json['fdDiscountDetail'] ?? '',
        fdKonvB_S: json['fdKonvB_S'] ?? 0,
        fdKonvS_K: json['fdKonvS_K'] ?? 0,
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        isHanger: json['isHanger'] ?? '0',
        isShow: json['isShow'] ?? '0',
        jnItem: json['jnItem'] ?? '',
        urut: json['urut'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }
}

class BarangExtra {
  final String fdKodeBarang;
  final double fdQtyExtra;
  final String fdLastUpdate;
  final String? message;

  BarangExtra(
      {required this.fdKodeBarang,
      required this.fdQtyExtra,
      required this.fdLastUpdate,
      this.message});

  factory BarangExtra.setData(Map<String, dynamic> item) {
    return BarangExtra(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdQtyExtra: item['fdQtyExtra'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory BarangExtra.fromJson(Map<String, dynamic> json) {
    return BarangExtra(
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdQtyExtra: double.tryParse(json['fdQtyExtra'].toString()) != null
            ? json['fdQtyExtra'].toDouble()
            : 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }
}

class JsonBarangExtra {
  final String fdKodeDepo;
  final String fdKodeSF;
  final int fdPromisi;
  final String fdKodeBarang;
  final double fdQtyInput;
  final int fdSatuan;
  final String fdLastUpdate;
  final String? message;

  JsonBarangExtra(
      {required this.fdKodeDepo,
      required this.fdKodeSF,
      required this.fdPromisi,
      required this.fdKodeBarang,
      required this.fdQtyInput,
      required this.fdSatuan,
      required this.fdLastUpdate,
      this.message});

  factory JsonBarangExtra.setData(Map<String, dynamic> item) {
    return JsonBarangExtra(
        fdKodeDepo: item['fdKodeDepo'] ?? '',
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdPromisi: item['fdPromisi'] ?? 0,
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdQtyInput: item['fdQtyInput'] ?? '',
        fdSatuan: item['fdSatuan'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory JsonBarangExtra.fromJson(Map<String, dynamic> json) {
    return JsonBarangExtra(
        fdKodeDepo: json['fdKodeDepo'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdPromisi: json['fdPromisi'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdQtyInput: double.tryParse(json['fdQtyInput'].toString()) != null
            ? json['fdQtyInput'].toDouble()
            : 0,
        fdSatuan: double.tryParse(json['fdSatuan'].toString()) != null
            ? json['fdSatuan'].toDouble()
            : 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'fdKodeDepo': fdKodeDepo,
      'fdKodeSF': fdKodeSF,
      'fdPromisi': fdPromisi,
      'fdKodeBarang': fdKodeBarang,
      'fdQtyInput': fdQtyInput,
      'fdSatuan': fdSatuan,
      'fdLastUpdate': fdLastUpdate,
    };
  }
}

class JsonBarangDiskon {
  final String fdKodeBarang;
  final double fdQty;
  final double fdDiscount;
  final String fdDiscountDetail;
  final String fdLastUpdate;
  final String? message;

  JsonBarangDiskon(
      {required this.fdKodeBarang,
      required this.fdQty,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdLastUpdate,
      this.message});

  factory JsonBarangDiskon.setData(Map<String, dynamic> item) {
    return JsonBarangDiskon(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdQty: double.tryParse(item['fdQty'].toString()) != null
            ? item['fdQty'].toDouble()
            : 0,
        fdDiscount: double.tryParse(item['fdDiscount'].toString()) != null
            ? item['fdDiscount'].toDouble()
            : 0,
        fdDiscountDetail: item['fdDiscountDetail'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        message: item['fdMessage'] ?? '');
  }

  factory JsonBarangDiskon.fromJson(Map<String, dynamic> json) {
    return JsonBarangDiskon(
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdQty: json['fdQty'] ?? 0,
        fdDiscount: json['fdDiscount'] ?? 0,
        fdDiscountDetail: json['fdDiscountDetail'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'fdKodeBarang': fdKodeBarang,
      'fdQty': fdQty,
      'fdDiscount': fdDiscount,
      'fdDiscountDetail': fdDiscountDetail,
      'fdLastUpdate': fdLastUpdate,
    };
  }
}

class Satuan {
  final String fdKodeSatuan;
  String? fdNamaSatuan;
  String? isHanger;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  Satuan(
      {required this.fdKodeSatuan,
      required this.fdNamaSatuan,
      this.isHanger,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory Satuan.setData(Map<String, dynamic> item) {
    return Satuan(
        fdKodeSatuan: item['fdKodeSatuan'] ?? '',
        fdNamaSatuan: item['fdNamaSatuan'] ?? '',
        isHanger: item['isHanger'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory Satuan.fromJson(Map<String, dynamic> json) {
    return Satuan(
        fdKodeSatuan: json['fdKodeSatuan'] ?? '',
        fdNamaSatuan: json['fdNamaSatuan'] ?? '',
        isHanger: json['isHanger'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class Hanger {
  final int? fdID;
  final String fdKodeBarang;
  String? fdSatuanK;
  String? fdSatuanS;
  String? fdSatuanB;
  int? fdKonvB_S;
  int? fdKonvS_K;
  String? fdKeterangan;
  int? fdQtyKomersil;
  int? fdQtyPromosi;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  Hanger(
      {required this.fdID,
      required this.fdKodeBarang,
      this.fdSatuanK,
      this.fdSatuanS,
      this.fdSatuanB,
      this.fdKonvB_S,
      this.fdKonvS_K,
      this.fdKeterangan,
      this.fdQtyKomersil,
      this.fdQtyPromosi,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory Hanger.setData(Map<String, dynamic> item) {
    return Hanger(
        fdID: item['fdID'] == null ? 0 : item['fdID'].toInt(),
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdSatuanK: item['fdSatuanK'] ?? '',
        fdSatuanS: item['fdSatuanS'] ?? '',
        fdSatuanB: item['fdSatuanB'] ?? '',
        fdKonvB_S: item['fdKonvB_S'] == null ? 0 : item['fdKonvB_S'].toInt(),
        fdKonvS_K: item['fdKonvS_K'] == null ? 0 : item['fdKonvS_K'].toInt(),
        fdKeterangan: item['fdKeterangan'] ?? '',
        fdQtyKomersil:
            item['fdQtyKomersil'] == null ? 0 : item['fdQtyKomersil'].toInt(),
        fdQtyPromosi:
            item['fdQtyPromosi'] == null ? 0 : item['fdQtyPromosi'].toInt(),
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory Hanger.fromJson(Map<String, dynamic> json) {
    return Hanger(
        fdID: json['fdID'] == null ? 0 : json['fdID'].toInt(),
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdSatuanK: json['fdSatuanK'] ?? '',
        fdSatuanS: json['fdSatuanS'] ?? '',
        fdSatuanB: json['fdSatuanB'] ?? '',
        fdKonvB_S: json['fdKonvB_S'] == null ? 0 : json['fdKonvB_S'].toInt(),
        fdKonvS_K: json['fdKonvS_K'] == null ? 0 : json['fdKonvS_K'].toInt(),
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdQtyKomersil:
            json['fdQtyKomersil'] == null ? 0 : json['fdQtyKomersil'].toInt(),
        fdQtyPromosi:
            json['fdQtyPromosi'] == null ? 0 : json['fdQtyPromosi'].toInt(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class HangerDetail {
  final int? fdID;
  final String fdKodeBarang;
  String? fdPromosi;
  int? fdQty;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  HangerDetail(
      {required this.fdID,
      required this.fdKodeBarang,
      this.fdPromosi,
      this.fdQty,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory HangerDetail.setData(Map<String, dynamic> item) {
    return HangerDetail(
        fdID: item['fdID'] == null ? 0 : item['fdID'].toInt(),
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdPromosi: item['fdPromosi'] ?? '',
        fdQty: item['fdQty'] == null ? 0 : item['fdQty'].toInt(),
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory HangerDetail.fromJson(Map<String, dynamic> json) {
    return HangerDetail(
        fdID: json['fdID'] == null ? 0 : json['fdID'].toInt(),
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdQty: json['fdQty'] == null ? 0 : json['fdQty'].toInt(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class BarangSales {
  final String fdKodeSF;
  final String fdKodeBarang;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  BarangSales(
      {required this.fdKodeSF,
      required this.fdKodeBarang,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory BarangSales.setData(Map<String, dynamic> item) {
    return BarangSales(
        fdKodeSF: item['fdKodeSF'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory BarangSales.fromJson(Map<String, dynamic> json) {
    return BarangSales(
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}

class BarangTOP {
  final String? fdKodeHarga;
  final String? fdKodeGroup;
  final String? fdKodeBarang;
  final int? fdTOP;
  final String fdStartDate;
  final String fdEndDate;
  final String? fdLastUpdate;
  final String? message;
  int? fdStatusSent = 0;

  BarangTOP(
      {required this.fdKodeHarga,
      required this.fdKodeGroup,
      required this.fdKodeBarang,
      required this.fdTOP,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdLastUpdate,
      this.message,
      this.fdStatusSent});

  factory BarangTOP.setData(Map<String, dynamic> item) {
    return BarangTOP(
        fdKodeHarga: item['fdKodeHarga'] ?? '',
        fdKodeGroup: item['fdKodeGroup'] ?? '',
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdTOP: item['fdTOP'] ?? 0,
        fdStartDate: item['fdStartDate'] ?? '',
        fdEndDate: item['fdEndDate'] ?? '',
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        fdStatusSent: item['fdStatusSent'] ?? 0);
  }

  factory BarangTOP.fromJson(Map<String, dynamic> json) {
    return BarangTOP(
        fdKodeHarga: json['fdKodeHarga'].toString(),
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdTOP: json['fdTOP'] ?? 0,
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '');
  }

  factory BarangTOP.empty() {
    return BarangTOP(
        fdKodeHarga: '',
        fdKodeGroup: '',
        fdKodeBarang: '',
        fdTOP: 0,
        fdStartDate: '',
        fdEndDate: '',
        fdLastUpdate: '',
        fdStatusSent: 0);
  }
}

class BarangStock {
  final String fdKodeBarang;
  final String fdNamaBarang;
  String? fdKodeGroup;
  String? fdSatuanK;
  String? fdSatuanS;
  String? fdSatuanB;
  int? fdKonvS_K;
  int? fdKonvB_S;
  int? fdQtyStock;
  int? fdQtyStockK;
  String? fdLastUpdate;
  final int? code;
  final String? message;
  bool? isCheck = false;

  BarangStock(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      this.fdKodeGroup,
      this.fdSatuanK,
      this.fdSatuanS,
      this.fdSatuanB,
      this.fdKonvS_K,
      this.fdKonvB_S,
      this.fdQtyStock,
      this.fdQtyStockK,
      this.fdLastUpdate,
      this.isCheck,
      this.code,
      this.message});

  factory BarangStock.setData(Map<String, dynamic> item) {
    return BarangStock(
        fdKodeBarang: item['fdKodeBarang'] ?? '',
        fdNamaBarang: item['fdNamaBarang'] ?? '',
        fdKodeGroup: item['fdKodeGroupBarang'] ?? '',
        fdSatuanK: item['fdSatuanK'] ?? '',
        fdSatuanS: item['fdSatuanS'] ?? '',
        fdSatuanB: item['fdSatuanB'] ?? '',
        fdKonvS_K: item['fdKonvS_K'] == null ? 0 : item['fdKonvS_K'].toInt(),
        fdKonvB_S: item['fdKonvB_S'] == null ? 0 : item['fdKonvB_S'].toInt(),
        fdQtyStock: item['fdQtyStock'] == null ? 0 : item['fdQtyStock'].toInt(),
        fdQtyStockK:
            item['fdQtyStockK'] == null ? 0 : item['fdQtyStockK'].toInt(),
        isCheck: item['isCheck'] ?? false,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory BarangStock.fromJson(Map<String, dynamic> json) {
    return BarangStock(
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdSatuanK: json['fdSatuanK'] ?? '',
        fdSatuanS: json['fdSatuanS'] ?? '',
        fdSatuanB: json['fdSatuanB'] ?? '',
        fdKonvS_K: json['fdKonvS_K'] == null ? 0 : json['fdKonvS_K'].toInt(),
        fdKonvB_S: json['fdKonvB_S'] == null ? 0 : json['fdKonvB_S'].toInt(),
        fdQtyStock: json['fdQtyStock'] == null ? 0 : json['fdQtyStock'].toInt(),
        fdQtyStockK:
            json['fdQtyStockK'] == null ? 0 : json['fdQtyStockK'].toInt(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }
}
