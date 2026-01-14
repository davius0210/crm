class Stock {
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryStock;
  final String? fdNoOrder;
  String? fdTanggal;
  final double fdUnitPrice;
  final double fdUnitPriceK;
  double? fdDiscount;
  final double fdTotal;
  final double fdTotalK;
  final int fdQtyStock;
  final int fdQtyStockK;
  final double fdTotalStock;
  final double fdTotalStockK;
  String? fdJenisSatuan;
  String? fdTanggalKirim;
  String? fdAlamatKirim;
  String? fdKodeGudang;
  String? fdKodeGudangSF;
  int? fdKodeStatus;
  int? fdApproveAdmin;
  int? fdStatusSent;
  String? fdNoEntryOrder;
  String? fdNoEntrySJ;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  Stock(
      {required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryStock,
      required this.fdNoOrder,
      required this.fdTanggal,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      this.fdDiscount,
      required this.fdTotal,
      required this.fdTotalK,
      required this.fdQtyStock,
      required this.fdQtyStockK,
      required this.fdTotalStock,
      required this.fdTotalStockK,
      this.fdJenisSatuan,
      this.fdTanggalKirim,
      this.fdAlamatKirim,
      required this.fdKodeGudang,
      required this.fdKodeGudangSF,
      this.fdKodeStatus,
      this.fdApproveAdmin,
      this.fdStatusSent,
      this.fdNoEntryOrder,
      this.fdNoEntrySJ,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory Stock.setData(Map<String, dynamic> item) {
    return Stock(
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdNoOrder: item['fdNoOrder'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdUnitPrice: double.tryParse(item['fdUnitPrice'].toString()) != null
          ? item['fdUnitPrice'].toDouble()
          : 0,
      fdUnitPriceK: double.tryParse(item['fdUnitPriceK'].toString()) != null
          ? item['fdUnitPriceK'].toDouble()
          : 0,
      fdDiscount: double.tryParse(item['fdDiscount'].toString()) != null
          ? item['fdDiscount'].toDouble()
          : 0,
      fdTotal: double.tryParse(item['fdTotal'].toString()) != null
          ? item['fdTotal'].toDouble()
          : 0,
      fdTotalK: double.tryParse(item['fdTotalK'].toString()) != null
          ? item['fdTotalK'].toDouble()
          : 0,
      fdQtyStock: item['fdQtyStock'] ?? 0,
      fdQtyStockK: item['fdQtyStockK'] ?? 0,
      fdTotalStock: double.tryParse(item['fdTotalStock'].toString()) != null
          ? item['fdTotalStock'].toDouble()
          : 0,
      fdTotalStockK: double.tryParse(item['fdTotalStockK'].toString()) != null
          ? item['fdTotalStockK'].toDouble()
          : 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdApproveAdmin: item['fdApproveAdmin'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNoEntryStock: json['fdNoEntryStock'].toString(),
        fdNoOrder: json['fdNoOrder'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdUnitPrice: double.tryParse(json['fdUnitPrice'].toString()) != null
            ? json['fdUnitPrice'].toDouble()
            : 0,
        fdUnitPriceK: double.tryParse(json['fdUnitPriceK'].toString()) != null
            ? json['fdUnitPriceK'].toDouble()
            : 0,
        fdDiscount: double.tryParse(json['fdDiscount'].toString()) != null
            ? json['fdDiscount'].toDouble()
            : 0,
        fdTotal: double.tryParse(json['fdTotal'].toString()) != null
            ? json['fdTotal'].toDouble()
            : 0,
        fdTotalK: double.tryParse(json['fdTotalK'].toString()) != null
            ? json['fdTotalK'].toDouble()
            : 0,
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        fdTotalStock: double.tryParse(json['fdTotalStock'].toString()) != null
            ? json['fdTotalStock'].toDouble()
            : 0,
        fdTotalStockK: double.tryParse(json['fdTotalStockK'].toString()) != null
            ? json['fdTotalStockK'].toDouble()
            : 0,
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangSF: json['fdKodeGudangSF'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdApproveAdmin: json['fdApproveAdmin'] ?? 0,
        fdNoEntryOrder: json['fdNoEntryOrder'].toString(),
        fdNoEntrySJ: json['fdNoEntrySJ'].toString(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory Stock.empty() {
    return Stock(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdDiscount: 0,
        fdTotal: 0,
        fdTotalK: 0,
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdTotalStock: 0,
        fdTotalStockK: 0,
        fdJenisSatuan: '',
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdKodeStatus: 0,
        fdApproveAdmin: 0,
        fdStatusSent: 0,
        fdNoEntryOrder: '',
        fdNoEntrySJ: '',
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataStock(
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdNoEntryStock,
    String? fdNoOrder,
    String? fdTanggal,
    double fdUnitPrice,
    double fdDiscount,
    double fdTotal,
    double fdTotalK,
    int fdQtyStock,
    int fdQtyStockK,
    double fdTotalStock,
    double fdTotalStockK,
    String? fdJenisSatuan,
    String? fdTanggalKirim,
    String? fdAlamatKirim,
    String? fdKodeGudang,
    String? fdKodeGudangSF,
    int fdKodeStatus,
    String? fdNoEntryOrder,
    String? fdNoEntrySJ,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdNoEntryStock": fdNoEntryStock,
    "fdNoOrder": fdNoOrder,
    "fdTanggal": fdTanggal,
    "fdUnitPrice": fdUnitPrice,
    "fdDiscount": fdDiscount,
    "fdTotal": fdTotal,
    "fdTotalK": fdTotalK,
    "fdQtyStock": fdQtyStock,
    "fdQtyStockK": fdQtyStockK,
    "fdTotalStock": fdTotalStock,
    "fdTotalStockK": fdTotalStockK,
    "fdJenisSatuan": fdJenisSatuan,
    "fdTanggalKirim": fdTanggalKirim,
    "fdAlamatKirim": fdAlamatKirim,
    "fdKodeGudang": fdKodeGudang,
    "fdKodeGudangSF": fdKodeGudangSF,
    "fdKodeStatus": fdKodeStatus,
    "fdNoEntryOrder": fdNoEntryOrder,
    "fdNoEntrySJ": fdNoEntrySJ,
    "fdLastUpdate": fdLastUpdate
  };
}

class StockItem {
  final String? fdNoEntryStock;
  final int? fdNoUrutStock;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  int fdQtyStock;
  int fdQtyStockK;
  double fdUnitPrice;
  double fdUnitPriceK;
  double fdBrutto;
  double fdDiscount;
  String? fdDiscountDetail;
  double fdNetto;
  final String? fdNoPromosi;
  final String? fdNotes;
  int fdQtyPBE;
  int fdQtySJ;
  int? fdStatusRecord;
  int? fdKodeStatus;

  int? fdStatusSent;
  String? isHanger;
  String? isShow;
  int? urut;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  StockItem(
      {required this.fdNoEntryStock,
      required this.fdNoUrutStock,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQtyStock,
      required this.fdQtyStockK,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdBrutto,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdNetto,
      required this.fdNoPromosi,
      required this.fdNotes,
      required this.fdQtyPBE,
      required this.fdQtySJ,
      this.fdStatusRecord,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.isHanger,
      this.isShow,
      this.urut,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory StockItem.setData(Map<String, dynamic> item) {
    return StockItem(
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdNoUrutStock: item['fdNoUrutStock'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'].toString() ?? '',
      fdQtyStock: item['fdQtyStock'] ?? 0,
      fdQtyStockK: item['fdQtyStockK'] ?? 0,
      fdUnitPrice: item['fdUnitPrice'] ?? 0,
      fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
      fdBrutto: item['fdBrutto'] ?? 0,
      fdDiscount: item['fdDiscount'] ?? 0,
      fdDiscountDetail: item['fdDiscountDetail'] ?? '',
      fdNetto: item['fdNetto'] ?? 0,
      fdNoPromosi: item['fdNoPromosi'] ?? '',
      fdNotes: item['fdNotes'] ?? '',
      fdQtyPBE: item['fdQtyPBE'] ?? 0,
      fdQtySJ: item['fdQtySJ'] ?? 0,
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      isHanger: item['isHanger'] ?? '',
      isShow: item['isShow'] ?? '',
      urut: item['urut'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
        fdNoEntryStock: json['fdNoEntryStock'] ?? '',
        fdNoUrutStock: json['fdNoUrutStock'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? '',
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        fdUnitPrice: double.tryParse(json['fdUnitPrice'].toString()) != null
            ? json['fdUnitPrice'].toDouble()
            : 0,
        fdUnitPriceK: double.tryParse(json['fdUnitPriceK'].toString()) != null
            ? json['fdUnitPriceK'].toDouble()
            : 0,
        fdBrutto: double.tryParse(json['fdBrutto'].toString()) != null
            ? json['fdBrutto'].toDouble()
            : 0,
        fdDiscount: double.tryParse(json['fdDiscount'].toString()) != null
            ? json['fdDiscount'].toDouble()
            : 0,
        fdDiscountDetail:
            double.tryParse(json['fdDiscountDetail'].toString()) != null
                ? json['fdDiscountDetail'].toDouble()
                : 0,
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdNoPromosi: json['fdNoPromosi'] ?? '',
        fdNotes: json['fdNotes'] ?? '',
        fdQtyPBE: json['fdQtyPBE'] ?? 0,
        fdQtySJ: json['fdQtySJ'] ?? 0,
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        isHanger: json['isHanger'] ?? '',
        isShow: json['isShow'] ?? '',
        urut: json['urut'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory StockItem.empty() {
    return StockItem(
        fdNoEntryStock: '',
        fdNoUrutStock: 0,
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdBrutto: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdNetto: 0,
        fdNoPromosi: '',
        fdNotes: '',
        fdQtyPBE: 0,
        fdQtySJ: 0,
        fdStatusRecord: 0,
        fdKodeStatus: 0,
        fdStatusSent: 0,
        isHanger: '',
        isShow: '',
        urut: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataStockItem(
  String? fdNoEntryStock,
  int? fdNoUrutStock,
  String? fdKodeBarang,
  String? fdNamaBarang,
  String? fdPromosi,
  String? fdReplacement,
  String? fdJenisSatuan,
  int fdQtyStock,
  int fdQtyStockK,
  double fdUnitPrice,
  double fdUnitPriceK,
  double fdBrutto,
  double fdDiscount,
  String? fdDiscountDetail,
  double fdNetto,
  String? fdNoPromosi,
  String? fdNotes,
  int fdQtyPBE,
  int fdQtySJ,
  int? fdStatusRecord,
  int? fdKodeStatus,
  String? isHanger,
  String? isShow,
  int? urut,
  String? fdLastUpdate,
) {
  return <String, dynamic>{
    "fdNoEntryStock": fdNoEntryStock,
    "fdNoUrutStock": fdNoUrutStock,
    "fdKodeBarang": fdKodeBarang,
    "fdNamaBarang": fdNamaBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQtyStock": fdQtyStock,
    "fdQtyStockK": fdQtyStockK,
    "fdUnitPrice": fdUnitPrice,
    "fdUnitPriceK": fdUnitPriceK,
    "fdBrutto": fdBrutto,
    "fdDiscount": fdDiscount,
    "fdDiscountDetail": fdDiscountDetail,
    "fdNetto": fdNetto,
    "fdNoPromosi": fdNoPromosi,
    "fdNotes": fdNotes,
    "fdQtyPBE": fdQtyPBE,
    "fdQtySJ": fdQtySJ,
    "fdStatusRecord": fdStatusRecord,
    "fdKodeStatus": fdKodeStatus,
    "isHanger": isHanger,
    "isShow": isShow,
    "urut": urut,
    "fdLastUpdate": fdLastUpdate
  };
}

class StockItemSum {
  final String? fdKodeSF;
  final String? fdDepo;
  final String? fdNoEntryStock;
  final String? fdTanggal;
  final String? fdKodeGudang;
  final String? fdKodeGudangSF;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  int fdQtyStock;
  int fdQtyStockK;
  double fdUnitPrice;
  double fdUnitPriceK;
  double fdBrutto;
  double fdDiscount;
  String? fdDiscountDetail;
  double fdNetto;
  final String? fdNoPromosi;
  final String? fdNotes;
  int fdQtyPBE;
  int fdQtySJ;
  int? fdStatusRecord;
  int? fdKodeStatus;

  int? fdStatusSent;
  String? isHanger;
  String? isShow;
  int? urut;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  StockItemSum(
      {required this.fdKodeSF,
      required this.fdDepo,
      required this.fdNoEntryStock,
      required this.fdTanggal,
      required this.fdKodeGudang,
      required this.fdKodeGudangSF,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQtyStock,
      required this.fdQtyStockK,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdBrutto,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdNetto,
      required this.fdNoPromosi,
      required this.fdNotes,
      required this.fdQtyPBE,
      required this.fdQtySJ,
      this.fdStatusRecord,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.isHanger,
      this.isShow,
      this.urut,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory StockItemSum.setData(Map<String, dynamic> item) {
    return StockItemSum(
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'].toString() ?? '',
      fdQtyStock: item['fdQtyStock'] ?? 0,
      fdQtyStockK: item['fdQtyStockK'] ?? 0,
      fdUnitPrice: item['fdUnitPrice'] ?? 0,
      fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
      fdBrutto: item['fdBrutto'] ?? 0,
      fdDiscount: item['fdDiscount'] ?? 0,
      fdDiscountDetail: item['fdDiscountDetail'] ?? '',
      fdNetto: item['fdNetto'] ?? 0,
      fdNoPromosi: item['fdNoPromosi'] ?? '',
      fdNotes: item['fdNotes'] ?? '',
      fdQtyPBE: item['fdQtyPBE'] ?? 0,
      fdQtySJ: item['fdQtySJ'] ?? 0,
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      isHanger: item['isHanger'] ?? '',
      isShow: item['isShow'] ?? '',
      urut: item['urut'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory StockItemSum.fromJson(Map<String, dynamic> json) {
    return StockItemSum(
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdNoEntryStock: json['fdNoEntryStock'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangSF: json['fdKodeGudangSF'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? '',
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        fdUnitPrice: double.tryParse(json['fdUnitPrice'].toString()) != null
            ? json['fdUnitPrice'].toDouble()
            : 0,
        fdUnitPriceK: double.tryParse(json['fdUnitPriceK'].toString()) != null
            ? json['fdUnitPriceK'].toDouble()
            : 0,
        fdBrutto: double.tryParse(json['fdBrutto'].toString()) != null
            ? json['fdBrutto'].toDouble()
            : 0,
        fdDiscount: double.tryParse(json['fdDiscount'].toString()) != null
            ? json['fdDiscount'].toDouble()
            : 0,
        fdDiscountDetail:
            double.tryParse(json['fdDiscountDetail'].toString()) != null
                ? json['fdDiscountDetail'].toDouble()
                : 0,
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdNoPromosi: json['fdNoPromosi'] ?? '',
        fdNotes: json['fdNotes'] ?? '',
        fdQtyPBE: json['fdQtyPBE'] ?? 0,
        fdQtySJ: json['fdQtySJ'] ?? 0,
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        isHanger: json['isHanger'] ?? '',
        isShow: json['isShow'] ?? '',
        urut: json['urut'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory StockItemSum.empty() {
    return StockItemSum(
        fdKodeSF: '',
        fdDepo: '',
        fdNoEntryStock: '',
        fdTanggal: '',
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdBrutto: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdNetto: 0,
        fdNoPromosi: '',
        fdNotes: '',
        fdQtyPBE: 0,
        fdQtySJ: 0,
        fdStatusRecord: 0,
        fdKodeStatus: 0,
        fdStatusSent: 0,
        isHanger: '',
        isShow: '',
        urut: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataStockItemSum(
  String? fdKodeSF,
  String? fdDepo,
  String? fdNoEntryStock,
  String? fdTanggal,
  String? fdKodeGudang,
  String? fdKodeGudangSF,
  String? fdKodeBarang,
  String? fdNamaBarang,
  String? fdPromosi,
  String? fdReplacement,
  String? fdJenisSatuan,
  int fdQtyStock,
  int fdQtyStockK,
  double fdUnitPrice,
  double fdUnitPriceK,
  double fdBrutto,
  double fdDiscount,
  String? fdDiscountDetail,
  double fdNetto,
  String? fdNoPromosi,
  String? fdNotes,
  int fdQtyPBE,
  int fdQtySJ,
  int? fdStatusRecord,
  int? fdKodeStatus,
  String? isHanger,
  String? isShow,
  int? urut,
  String? fdLastUpdate,
) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdDepo": fdDepo,
    "fdNoEntryStock": fdNoEntryStock,
    "fdTanggal": fdTanggal,
    "fdKodeGudang": fdKodeGudang,
    "fdKodeGudangSF": fdKodeGudangSF,
    "fdKodeBarang": fdKodeBarang,
    "fdNamaBarang": fdNamaBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQtyStock": fdQtyStock,
    "fdQtyStockK": fdQtyStockK,
    "fdUnitPrice": fdUnitPrice,
    "fdUnitPriceK": fdUnitPriceK,
    "fdBrutto": fdBrutto,
    "fdDiscount": fdDiscount,
    "fdDiscountDetail": fdDiscountDetail,
    "fdNetto": fdNetto,
    "fdNoPromosi": fdNoPromosi,
    "fdNotes": fdNotes,
    "fdQtyPBE": fdQtyPBE,
    "fdQtySJ": fdQtySJ,
    "fdStatusRecord": fdStatusRecord,
    "fdKodeStatus": fdKodeStatus,
    "isHanger": isHanger,
    "isShow": isShow,
    "urut": urut,
    "fdLastUpdate": fdLastUpdate
  };
}

class StockApi {
  //HEADER
  String? fdNoEntryOrder;
  String? fdNoEntrySJ;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryStock;
  final String? fdTanggal;
  // final double fdUnitPrice;
  // double? fdDiscount;
  final double fdTotal;
  final double fdTotalK;
  // final int fdQty;
  final double fdTotalStock;
  final double fdTotalStockK;
  // String? fdJenisSatuan;
  final String? fdTanggalKirim;
  final String? fdAlamatKirim;
  final String? fdKodeGudang;
  final String? fdKodeGudangSF;
  //DETAIL
  final int? fdNoUrutStock;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  double fdQtyStock;
  int fdQtyStockK;
  double fdUnitPrice;
  double fdUnitPriceK;
  double fdBrutto;
  double fdDiscount;
  String? fdDiscountDetail;
  double fdNetto;
  final String? fdNoPromosi;
  final String? fdNotes;
  int fdQtyPBE;
  int fdQtySJ;
  int? fdStatusRecord;
  int? fdKodeStatus;

  int? fdStatusSent;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  StockApi(
      {required this.fdNoEntryOrder,
      required this.fdNoEntrySJ,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryStock,
      required this.fdTanggal,
      required this.fdTotal,
      required this.fdTotalK,
      required this.fdTotalStock,
      required this.fdTotalStockK,
      required this.fdTanggalKirim,
      required this.fdAlamatKirim,
      required this.fdKodeGudang,
      required this.fdKodeGudangSF,
      required this.fdNoUrutStock,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQtyStock,
      required this.fdQtyStockK,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdBrutto,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdNetto,
      required this.fdNoPromosi,
      required this.fdNotes,
      required this.fdQtyPBE,
      required this.fdQtySJ,
      this.fdStatusRecord,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory StockApi.setData(Map<String, dynamic> item) {
    return StockApi(
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdTotal: item['fdTotal'] ?? 0,
      fdTotalK: item['fdTotalK'] ?? 0,
      fdTotalStock: item['fdTotalStock'] ?? 0,
      fdTotalStockK: item['fdTotalStockK'] ?? 0,
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdNoUrutStock: item['fdNoUrutStock'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'].toString() ?? '',
      fdQtyStock: item['fdQtyStock'] ?? 0,
      fdQtyStockK: item['fdQtyStockK'] ?? 0,
      fdUnitPrice: double.tryParse(item['fdUnitPrice'].toString()) != null
          ? item['fdUnitPrice'].toDouble()
          : 0,
      fdUnitPriceK: double.tryParse(item['fdUnitPriceK'].toString()) != null
          ? item['fdUnitPriceK'].toDouble()
          : 0,
      fdBrutto: double.tryParse(item['fdBrutto'].toString()) != null
          ? item['fdBrutto'].toDouble()
          : 0,
      fdDiscount: double.tryParse(item['fdDiscount'].toString()) != null
          ? item['fdDiscount'].toDouble()
          : 0,
      fdDiscountDetail: item['fdDiscountDetail'].toString() ?? '',
      fdNetto: double.tryParse(item['fdNetto'].toString()) != null
          ? item['fdNetto'].toDouble()
          : 0,
      fdNoPromosi: item['fdNoPromosi'] ?? '',
      fdNotes: item['fdNotes'] ?? '',
      fdQtyPBE: item['fdQtyPBE'] ?? 0,
      fdQtySJ: item['fdQtySJ'] ?? 0,
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory StockApi.fromJson(Map<String, dynamic> json) {
    return StockApi(
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdNoEntryStock: json['fdNoEntryStock'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdTotal: json['fdTotal'] ?? 0,
        fdTotalK: json['fdTotalK'] ?? 0,
        fdTotalStock: json['fdTotalStock'] ?? 0,
        fdTotalStockK: json['fdTotalStockK'] ?? 0,
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangSF: json['fdKodeGudangSF'] ?? '',
        fdNoUrutStock: json['fdNoUrutStock'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? '',
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        fdUnitPrice: double.tryParse(json['fdUnitPrice'].toString()) != null
            ? json['fdUnitPrice'].toDouble()
            : 0,
        fdUnitPriceK: double.tryParse(json['fdUnitPriceK'].toString()) != null
            ? json['fdUnitPriceK'].toDouble()
            : 0,
        fdBrutto: double.tryParse(json['fdBrutto'].toString()) != null
            ? json['fdBrutto'].toDouble()
            : 0,
        fdDiscount: double.tryParse(json['fdDiscount'].toString()) != null
            ? json['fdDiscount'].toDouble()
            : 0,
        fdDiscountDetail: json['fdDiscountDetail'] ?? '',
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdNoPromosi: json['fdNoPromosi'] ?? '',
        fdNotes: json['fdNotes'] ?? '',
        fdQtyPBE: json['fdQtyPBE'] ?? 0,
        fdQtySJ: json['fdQtySJ'] ?? 0,
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory StockApi.empty() {
    return StockApi(
        fdNoEntryOrder: '',
        fdNoEntrySJ: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdTanggal: '',
        fdTotal: 0,
        fdTotalK: 0,
        fdTotalStock: 0,
        fdTotalStockK: 0,
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdNoUrutStock: 0,
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdQtyStock: 0,
        fdQtyStockK: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdBrutto: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdNetto: 0,
        fdNoPromosi: '',
        fdNotes: '',
        fdQtyPBE: 0,
        fdQtySJ: 0,
        fdStatusRecord: 0,
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '',
        fdData: '',
        fdMessage: '');
  }

  factory StockApi.fromStock(
    String? fdNoEntryOrder,
    String? fdNoEntrySJ,
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdNoEntryStock,
    String? fdTanggal,
    double fdTotal,
    double fdTotalK,
    double fdTotalStock,
    double fdTotalStockK,
    String? fdTanggalKirim,
    String? fdAlamatKirim,
    String? fdKodeGudang,
    String? fdKodeGudangSF,
    int? fdNoUrutStock,
    String? fdKodeBarang,
    String? fdNamaBarang,
    String? fdPromosi,
    String? fdReplacement,
    String? fdJenisSatuan,
    int fdQtyStock,
    int fdQtyStockK,
    double fdUnitPrice,
    double fdUnitPriceK,
    double fdBrutto,
    double fdDiscount,
    String? fdDiscountDetail,
    double fdNetto,
    String? fdNoPromosi,
    String? fdNotes,
    int fdQtyPBE,
    int fdQtySJ,
    int? fdStatusRecord,
    int? fdKodeStatus,
    int? fdStatusSent,
    String? fdLastUpdate,
  ) {
    return StockApi(
      fdNoEntryOrder: '',
      fdNoEntrySJ: '',
      fdDepo: '',
      fdKodeLangganan: '',
      fdNoEntryStock: '',
      fdTanggal: '',
      fdTotal: 0,
      fdTotalK: 0,
      fdTotalStock: 0,
      fdTotalStockK: 0,
      fdTanggalKirim: '',
      fdAlamatKirim: '',
      fdKodeGudang: '',
      fdKodeGudangSF: '',
      fdNoUrutStock: 0,
      fdKodeBarang: '',
      fdNamaBarang: '',
      fdPromosi: '',
      fdReplacement: '',
      fdJenisSatuan: '',
      fdQtyStock: 0,
      fdQtyStockK: 0,
      fdUnitPrice: 0,
      fdUnitPriceK: 0,
      fdBrutto: 0,
      fdDiscount: 0,
      fdDiscountDetail: '',
      fdNetto: 0,
      fdNoPromosi: '',
      fdNotes: '',
      fdQtyPBE: 0,
      fdQtySJ: 0,
      fdStatusRecord: 0,
      fdKodeStatus: 0,
      fdStatusSent: 0,
      fdLastUpdate: '',
    );
  }
}

class ViewStockItem {
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdJenisSatuan;
  final double pcs;
  final double lsn;
  final double ktn;

  ViewStockItem(
      {required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdJenisSatuan,
      required this.pcs,
      required this.lsn,
      required this.ktn});

  factory ViewStockItem.setData(Map<String, dynamic> item) {
    return ViewStockItem(
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      pcs: item['pcs'] ?? 0,
      lsn: item['lsn'] ?? 0,
      ktn: item['ktn'] ?? 0,
    );
  }

  factory ViewStockItem.fromJson(Map<String, dynamic> json) {
    return ViewStockItem(
      fdKodeBarang: json['fdKodeBarang'] ?? '',
      fdNamaBarang: json['fdNamaBarang'] ?? '',
      fdJenisSatuan: json['fdJenisSatuan'] ?? '',
      pcs: json['pcs'] ?? 0,
      lsn: json['lsn'] ?? 0,
      ktn: json['ktn'] ?? 0,
    );
  }

  factory ViewStockItem.empty() {
    return ViewStockItem(
      fdKodeBarang: '',
      fdNamaBarang: '',
      fdJenisSatuan: '',
      pcs: 0,
      lsn: 0,
      ktn: 0,
    );
  }
}

Map<String, dynamic> setJsonDataStockApi(
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdNoEntryStock,
    String? fdTanggal,
    double fdTotal,
    double fdTotalK,
    double fdTotalStock,
    double fdTotalStockK,
    String? fdTanggalKirim,
    String? fdAlamatKirim,
    String? fdKodeGudang,
    String? fdKodeGudangSF,
    //DETAIL
    int? fdNoUrutStock,
    String? fdKodeBarang,
    String? fdNamaBarang,
    String? fdPromosi,
    String? fdReplacement,
    String? fdJenisSatuan,
    double fdQtyStock,
    int fdQtyStockK,
    double fdUnitPrice,
    double fdUnitPriceK,
    double fdBrutto,
    double fdDiscount,
    String? fdDiscountDetail,
    double fdNetto,
    String? fdNoPromosi,
    String? fdNotes,
    int fdQtyPBE,
    int fdQtySJ,
    int? fdStatusRecord,
    int fdKodeStatus,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdNoEntryStock": fdNoEntryStock,
    "fdTanggal": fdTanggal,
    "fdTotal": fdTotal,
    "fdTotalK": fdTotalK,
    "fdTotalStock": fdTotalStock,
    "fdTotalStockK": fdTotalStockK,
    "fdTanggalKirim": fdTanggalKirim,
    "fdAlamatKirim": fdAlamatKirim,
    "fdKodeGudang": fdKodeGudang,
    "fdKodeGudangSF": fdKodeGudangSF,
    "fdNoUrutStock": fdNoUrutStock,
    "fdKodeBarang": fdKodeBarang,
    "fdNamaBarang": fdNamaBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQtyStock": fdQtyStock,
    "fdQtyStockK": fdQtyStockK,
    "fdUnitPrice": fdUnitPrice,
    "fdUnitPriceK": fdUnitPriceK,
    "fdBrutto": fdBrutto,
    "fdDiscount": fdDiscount,
    "fdDiscountDetail": fdDiscountDetail,
    "fdNetto": fdNetto,
    "fdNoPromosi": fdNoPromosi,
    "fdNotes": fdNotes,
    "fdQtyPBE": fdQtyPBE,
    "fdQtySJ": fdQtySJ,
    "fdStatusRecord": fdStatusRecord,
    "fdKodeStatus": fdKodeStatus,
    "fdLastUpdate": fdLastUpdate
  };
}

class StockVerification {
  final String? fdNoEntryOrder;
  final String? fdNoEntrySJ;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryStock;
  final String? fdNoOrder;
  String? fdTanggal;
  // final double fdUnitPrice;
  // final double fdUnitPriceK;
  // double? fdDiscount;
  // final double fdTotal;
  // final double fdTotalK;
  // final int fdQty;
  // final int fdQtyK;
  // final double fdTotalStock;
  // final double fdTotalStockK;
  String? fdJenisSatuan;
  String? fdNamaJenisSatuan;
  String? fdJenisSatuanBS;
  String? fdTanggalKirim;
  // String? fdAlamatKirim;
  // String? fdKodeGudang;
  // String? fdKodeGudangSF;
  int? fdKodeStatus;
  String? fdKodeBarang;
  String? fdNamaBarang;
  int? fdQty;
  int? fdQtyS;
  int? fdQtyK;
  int? fdQtyReal;
  int? fdQtyRealS;
  int? fdQtyRealK;
  int? fdStatusSent;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  StockVerification(
      {required this.fdNoEntryOrder,
      required this.fdNoEntrySJ,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryStock,
      required this.fdNoOrder,
      required this.fdTanggal,
      // required this.fdUnitPrice,
      // required this.fdUnitPriceK,
      // this.fdDiscount,
      // required this.fdTotal,
      // required this.fdTotalK,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdQty,
      required this.fdQtyS,
      required this.fdQtyK,
      required this.fdQtyReal,
      required this.fdQtyRealS,
      required this.fdQtyRealK,
      // required this.fdTotalStock,
      // required this.fdTotalStockK,
      this.fdJenisSatuan,
      this.fdNamaJenisSatuan,
      this.fdJenisSatuanBS,
      this.fdTanggalKirim,
      // this.fdAlamatKirim,
      // required this.fdKodeGudang,
      // required this.fdKodeGudangSF,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory StockVerification.setData(Map<String, dynamic> item) {
    return StockVerification(
      fdNoEntryOrder: item['fdNoEntryOrder'].toString(),
      fdNoEntrySJ: item['fdNoEntrySJ'].toString(),
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdNoOrder: item['fdNoOrder'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      // fdUnitPrice: double.tryParse(item['fdUnitPrice'].toString()) != null
      //     ? item['fdUnitPrice'].toDouble()
      //     : 0,
      // fdUnitPriceK: double.tryParse(item['fdUnitPriceK'].toString()) != null
      //     ? item['fdUnitPriceK'].toDouble()
      //     : 0,
      // fdDiscount: double.tryParse(item['fdDiscount'].toString()) != null
      //     ? item['fdDiscount'].toDouble()
      //     : 0,
      // fdTotal: double.tryParse(item['fdTotal'].toString()) != null
      //     ? item['fdTotal'].toDouble()
      //     : 0,
      // fdTotalK: double.tryParse(item['fdTotalK'].toString()) != null
      //     ? item['fdTotalK'].toDouble()
      //     : 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdQty: item['fdQtyB'] ?? 0,
      fdQtyS: item['fdQtyS'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdQtyReal: item['fdQtyRealB'] ?? 0,
      fdQtyRealS: item['fdQtyRealS'] ?? 0,
      fdQtyRealK: item['fdQtyRealK'] ?? 0,
      // fdTotalStock: double.tryParse(item['fdTotalStock'].toString()) != null
      //     ? item['fdTotalStock'].toDouble()
      //     : 0,
      // fdTotalStockK: double.tryParse(item['fdTotalStockK'].toString()) != null
      //     ? item['fdTotalStockK'].toDouble()
      //     : 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdNamaJenisSatuan: item['fdNamaJenisSatuan'] ?? '',
      fdJenisSatuanBS: item['fdJenisSatuanBS'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      // fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      // fdKodeGudang: item['fdKodeGudang'] ?? '',
      // fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory StockVerification.fromJson(Map<String, dynamic> json) {
    return StockVerification(
        fdNoEntryOrder: json['fdNoEntryOrder'].toString(),
        fdNoEntrySJ: json['fdNoEntrySJ'].toString(),
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNoEntryStock: json['fdNoEntryStock'] ?? '',
        fdNoOrder: json['fdNoOrder'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdQty: json['fdQtyB'] ?? 0,
        fdQtyS: json['fdQtyS'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
        fdQtyReal: json['fdQtyRealB'] ?? 0,
        fdQtyRealS: json['fdQtyRealS'] ?? 0,
        fdQtyRealK: json['fdQtyRealK'] ?? 0,
        fdJenisSatuan: json['fdJenisSatuan'].toString(),
        fdNamaJenisSatuan: json['fdNamaJenisSatuan'] ?? '',
        fdJenisSatuanBS: json['fdJenisSatuanBS'].toString(),
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory StockVerification.empty() {
    return StockVerification(
        fdNoEntryOrder: '',
        fdNoEntrySJ: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdQty: 0,
        fdQtyS: 0,
        fdQtyK: 0,
        fdQtyReal: 0,
        fdQtyRealS: 0,
        fdQtyRealK: 0,
        fdJenisSatuan: '',
        fdNamaJenisSatuan: '',
        fdJenisSatuanBS: '',
        fdTanggalKirim: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class StockUnloading {
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryStock;
  final String? fdNoOrder;
  String? fdTanggal;
  // final double fdUnitPrice;
  // final double fdUnitPriceK;
  // double? fdDiscount;
  // final double fdTotal;
  // final double fdTotalK;
  String? fdKodeBarang;
  String? fdNamaBarang;
  final double fdQtyStock;
  final double fdQtyStockS;
  final int fdQtyStockK;
  // final double fdTotalStock;
  // final double fdTotalStockK;
  String? fdJenisSatuan;
  String? fdNamaJenisSatuan;
  String? fdJenisSatuanBS;
  String? fdTanggalKirim;
  // String? fdAlamatKirim;
  String? fdKodeGudang;
  String? fdKodeGudangSF;
  int? fdKodeStatus;
  int? fdStatusSent;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  StockUnloading(
      {required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryStock,
      required this.fdNoOrder,
      required this.fdTanggal,
      // required this.fdUnitPrice,
      // required this.fdUnitPriceK,
      // this.fdDiscount,
      // required this.fdTotal,
      // required this.fdTotalK,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdQtyStock,
      required this.fdQtyStockS,
      required this.fdQtyStockK,
      // required this.fdTotalStock,
      // required this.fdTotalStockK,
      this.fdJenisSatuan,
      this.fdNamaJenisSatuan,
      this.fdJenisSatuanBS,
      this.fdTanggalKirim,
      // this.fdAlamatKirim,
      required this.fdKodeGudang,
      required this.fdKodeGudangSF,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory StockUnloading.setData(Map<String, dynamic> item) {
    return StockUnloading(
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryStock: item['fdNoEntryStock'] ?? '',
      fdNoOrder: item['fdNoOrder'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      // fdUnitPrice: double.tryParse(item['fdUnitPrice'].toString()) != null
      //     ? item['fdUnitPrice'].toDouble()
      //     : 0,
      // fdUnitPriceK: double.tryParse(item['fdUnitPriceK'].toString()) != null
      //     ? item['fdUnitPriceK'].toDouble()
      //     : 0,
      // fdDiscount: double.tryParse(item['fdDiscount'].toString()) != null
      //     ? item['fdDiscount'].toDouble()
      //     : 0,
      // fdTotal: double.tryParse(item['fdTotal'].toString()) != null
      //     ? item['fdTotal'].toDouble()
      //     : 0,
      // fdTotalK: double.tryParse(item['fdTotalK'].toString()) != null
      //     ? item['fdTotalK'].toDouble()
      //     : 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdQtyStock: double.tryParse(item['fdQtyStock'].toString()) ?? 0,
      fdQtyStockS: double.tryParse(item['fdQtyStockS'].toString()) ?? 0,
      // int.tryParse(item['fdQtyStockS'].toString()) != null          ? item['fdQtyStockS'].toInt()          : 0,
      fdQtyStockK:
          double.tryParse(item['fdQtyStockK'].toString())?.toInt() ?? 0,
      // fdTotalStock: double.tryParse(item['fdTotalStock'].toString()) != null
      //     ? item['fdTotalStock'].toDouble()
      //     : 0,
      // fdTotalStockK: double.tryParse(item['fdTotalStockK'].toString()) != null
      //     ? item['fdTotalStockK'].toDouble()
      //     : 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdNamaJenisSatuan: item['fdNamaJenisSatuan'] ?? '',
      fdJenisSatuanBS: item['fdJenisSatuanBS'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      // fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangSF: item['fdKodeGudangSF'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory StockUnloading.fromJson(Map<String, dynamic> json) {
    return StockUnloading(
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNoEntryStock: json['fdNoEntryStock'] ?? '',
        fdNoOrder: json['fdNoOrder'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdQtyStock: json['fdQtyStock'] ?? 0,
        fdQtyStockS: json['fdQtyStockS'] ?? 0,
        fdQtyStockK: json['fdQtyStockK'] ?? 0,
        fdJenisSatuan: json['fdJenisSatuan'].toString(),
        fdNamaJenisSatuan: json['fdNamaJenisSatuan'] ?? '',
        fdJenisSatuanBS: json['fdJenisSatuanBS'].toString(),
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangSF: json['fdKodeGudangSF'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory StockUnloading.empty() {
    return StockUnloading(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryStock: '',
        fdNoOrder: '',
        fdTanggal: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdQtyStock: 0,
        fdQtyStockS: 0,
        fdQtyStockK: 0,
        fdJenisSatuan: '',
        fdNamaJenisSatuan: '',
        fdJenisSatuanBS: '',
        fdTanggalKirim: '',
        fdKodeGudang: '',
        fdKodeGudangSF: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}
