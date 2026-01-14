class Order {
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryOrder;
  String? fdTanggal;
  final double fdUnitPrice;
  final double fdUnitPriceK;
  double? fdDiscount;
  final double fdTotal;
  final double fdTotalK;
  final int fdQty;
  final int fdQtyK;
  final double fdTotalOrder;
  final double fdTotalOrderK;
  String? fdJenisSatuan;
  String? fdTanggalKirim;
  String? fdAlamatKirim;
  int? fdKodeStatus;
  int? fdStatusSent;
  String? fdNoEntryFaktur;
  String? fdNoFaktur;
  String? fdNoEntrySJ;
  String? fdNoSJ;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  Order(
      {required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryOrder,
      required this.fdTanggal,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      this.fdDiscount,
      required this.fdTotal,
      required this.fdTotalK,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdTotalOrder,
      required this.fdTotalOrderK,
      this.fdJenisSatuan,
      this.fdTanggalKirim,
      this.fdAlamatKirim,
      this.fdKodeStatus,
      this.fdStatusSent,
      this.fdNoEntryFaktur,
      this.fdNoFaktur,
      this.fdNoEntrySJ,
      this.fdNoSJ,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory Order.setData(Map<String, dynamic> item) {
    return Order(
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
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
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdTotalOrder: double.tryParse(item['fdTotalOrder'].toString()) != null
          ? item['fdTotalOrder'].toDouble()
          : 0,
      fdTotalOrderK: double.tryParse(item['fdTotalOrderK'].toString()) != null
          ? item['fdTotalOrderK'].toDouble()
          : 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoSJ: item['fdNoSJ'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
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
        fdQty: json['fdQty'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
        fdTotalOrder: double.tryParse(json['fdTotalOrder'].toString()) != null
            ? json['fdTotalOrder'].toDouble()
            : 0,
        fdTotalOrderK: double.tryParse(json['fdTotalOrderK'].toString()) != null
            ? json['fdTotalOrderK'].toDouble()
            : 0,
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdNoEntryFaktur: json['fdNoEntryFaktur'] ?? '',
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdNoSJ: json['fdNoSJ'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory Order.empty() {
    return Order(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryOrder: '',
        fdTanggal: '',
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdDiscount: 0,
        fdTotal: 0,
        fdTotalK: 0,
        fdQty: 0,
        fdQtyK: 0,
        fdTotalOrder: 0,
        fdTotalOrderK: 0,
        fdJenisSatuan: '',
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdKodeStatus: 0,
        fdStatusSent: 0,
        fdNoEntryFaktur: '',
        fdNoFaktur: '',
        fdNoEntrySJ: '',
        fdNoSJ: '',
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataOrder(
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdNoEntryOrder,
    String? fdTanggal,
    double fdUnitPrice,
    double fdDiscount,
    double fdTotal,
    double fdTotalK,
    int fdQty,
    int fdQtyK,
    double fdTotalOrder,
    double fdTotalOrderK,
    String? fdJenisSatuan,
    String? fdTanggalKirim,
    String? fdAlamatKirim,
    int fdKodeStatus,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdNoEntryOrder": fdNoEntryOrder,
    "fdTanggal": fdTanggal,
    "fdUnitPrice": fdUnitPrice,
    "fdDiscount": fdDiscount,
    "fdTotal": fdTotal,
    "fdTotalK": fdTotalK,
    "fdQty": fdQty,
    "fdQtyK": fdQtyK,
    "fdTotalOrder": fdTotalOrder,
    "fdTotalOrderK": fdTotalOrderK,
    "fdJenisSatuan": fdJenisSatuan,
    "fdTanggalKirim": fdTanggalKirim,
    "fdAlamatKirim": fdAlamatKirim,
    "fdKodeStatus": fdKodeStatus,
    "fdLastUpdate": fdLastUpdate
  };
}

class OrderItem {
  final String? fdNoEntryOrder;
  final int? fdNoUrutOrder;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  int fdQty;
  int fdQtyK;
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
  String? jnItem;
  int? urut;
  String? fdNamaSatuan;
  String? fdAlamatKirim;
  String? fdNoSJ;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  OrderItem(
      {required this.fdNoEntryOrder,
      required this.fdNoUrutOrder,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
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
      this.jnItem,
      this.urut,
      this.fdNamaSatuan,
      this.fdAlamatKirim,
      this.fdNoSJ,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory OrderItem.setData(Map<String, dynamic> item) {
    return OrderItem(
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoUrutOrder: item['fdNoUrutOrder'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'].toString() ?? '',
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
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
      jnItem: item['jnItem'] ?? '',
      urut: item['urut'] ?? 0,
      fdNamaSatuan: item['fdNamaSatuan'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdNoSJ: item['fdNoSJ'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
        fdNoUrutOrder: json['fdNoUrutOrder'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? '',
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQty: json['fdQty'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
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
        jnItem: json['jnItem'] ?? '',
        urut: json['urut'] ?? 0,
        fdNamaSatuan: json['fdNamaSatuan'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdNoSJ: json['fdNoSJ'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory OrderItem.empty() {
    return OrderItem(
        fdNoEntryOrder: '',
        fdNoUrutOrder: 0,
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdQty: 0,
        fdQtyK: 0,
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
        jnItem: '',
        urut: 0,
        fdNamaSatuan: '',
        fdAlamatKirim: '',
        fdNoSJ: '',
        fdLastUpdate: '',
        message: '');
  }
}

class OrderApi {
  //HEADER
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdNoEntryOrder;
  final String? fdTanggal;
  // final double fdUnitPrice;
  // double? fdDiscount;
  final double fdTotal;
  final double fdTotalK;
  // final int fdQty;
  final double fdTotalOrder;
  final double fdTotalOrderK;
  // String? fdJenisSatuan;
  final String? fdTanggalKirim;
  final String? fdAlamatKirim;
  //DETAIL
  final int? fdNoUrutOrder;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  int fdQty;
  int fdQtyK;
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

  OrderApi(
      {required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdNoEntryOrder,
      required this.fdTanggal,
      required this.fdTotal,
      required this.fdTotalK,
      required this.fdTotalOrder,
      required this.fdTotalOrderK,
      required this.fdTanggalKirim,
      required this.fdAlamatKirim,
      required this.fdNoUrutOrder,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
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

  factory OrderApi.setData(Map<String, dynamic> item) {
    return OrderApi(
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdTotal: item['fdTotal'] ?? 0,
      fdTotalK: item['fdTotalK'] ?? 0,
      fdTotalOrder: item['fdTotalOrder'] ?? 0,
      fdTotalOrderK: item['fdTotalOrderK'] ?? 0,
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdNoUrutOrder: item['fdNoUrutOrder'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'].toString() ?? '',
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
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

  factory OrderApi.fromJson(Map<String, dynamic> json) {
    return OrderApi(
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdTotal: json['fdTotal'] ?? 0,
        fdTotalK: json['fdTotalK'] ?? 0,
        fdTotalOrder: json['fdTotalOrder'] ?? 0,
        fdTotalOrderK: json['fdTotalOrderK'] ?? 0,
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdNoUrutOrder: json['fdNoUrutOrder'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? '',
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQty: json['fdQty'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
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
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory OrderApi.empty() {
    return OrderApi(
        fdDepo: '',
        fdKodeLangganan: '',
        fdNoEntryOrder: '',
        fdTanggal: '',
        fdTotal: 0,
        fdTotalK: 0,
        fdTotalOrder: 0,
        fdTotalOrderK: 0,
        fdTanggalKirim: '',
        fdAlamatKirim: '',
        fdNoUrutOrder: 0,
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdQty: 0,
        fdQtyK: 0,
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
}

Map<String, dynamic> setJsonDataOrderApi(
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdNoEntryOrder,
    String? fdTanggal,
    double fdTotal,
    double fdTotalK,
    double fdTotalOrder,
    double fdTotalOrderK,
    String? fdTanggalKirim,
    String? fdAlamatKirim,
    //DETAIL
    int? fdNoUrutOrder,
    String? fdKodeBarang,
    String? fdNamaBarang,
    String? fdPromosi,
    String? fdReplacement,
    String? fdJenisSatuan,
    int fdQty,
    int fdQtyK,
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
    "fdNoEntryOrder": fdNoEntryOrder,
    "fdTanggal": fdTanggal,
    "fdTotal": fdTotal,
    "fdTotalK": fdTotalK,
    "fdTotalOrder": fdTotalOrder,
    "fdTotalOrderK": fdTotalOrderK,
    "fdTanggalKirim": fdTanggalKirim,
    "fdAlamatKirim": fdAlamatKirim,
    "fdNoUrutOrder": fdNoUrutOrder,
    "fdKodeBarang": fdKodeBarang,
    "fdNamaBarang": fdNamaBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQty": fdQty,
    "fdQtyK": fdQtyK,
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
