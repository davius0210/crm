class Piutang {
  final String? fdTipePiutang;
  final String? fdNoEntryFaktur;
  final String? fdNoFaktur;
  final String? fdDepo;
  final String? fdTanggalFaktur;
  final String? fdTanggalJT;
  final String? fdKodeLangganan;
  final double fdBayar;
  final double fdGiro;
  final double fdGiroTolak;
  final int fdKodeStatus;
  final String? fdTglStatus;
  final int fdStatusRecord;
  final String? fdNoUrutFaktur;
  final String? fdNoEntrySJ;
  final String? fdNoUrutSJ;
  final String? fdKodeBarang;
  final String? fdPromosi;
  final String? fdReplacement;
  final String? fdJenisSatuan;
  final String? fdSatuan;
  final double fdQty;
  final double fdQtyK;
  final double fdHargaAsli;
  final double fdUnitPrice;
  final double fdUnitPriceK;
  final double fdUnitPricePPN;
  final double fdBrutto;
  final double fdBruttopromosi;
  final double fdDiscount;
  final double fdNetto;
  final double fdDPP;
  final double fdPPN;
  final String? fdNamaBarang;
  final String? fdTanggalKirim;
  final String? fdNoEntryOrder;
  final String? fdNoOrder;
  final String? fdTanggalOrder;
  final double fdLimitKredit;
  final String? fdKodeTransaksiFP;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  Piutang(
      {required this.fdTipePiutang,
      required this.fdNoEntryFaktur,
      required this.fdNoFaktur,
      required this.fdDepo,
      required this.fdTanggalFaktur,
      required this.fdTanggalJT,
      required this.fdKodeLangganan,
      required this.fdBayar,
      required this.fdGiro,
      required this.fdGiroTolak,
      required this.fdKodeStatus,
      required this.fdTglStatus,
      required this.fdStatusRecord,
      required this.fdNoUrutFaktur,
      required this.fdNoEntrySJ,
      required this.fdNoUrutSJ,
      required this.fdKodeBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdSatuan,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdHargaAsli,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdUnitPricePPN,
      required this.fdBrutto,
      required this.fdBruttopromosi,
      required this.fdDiscount,
      required this.fdNetto,
      required this.fdDPP,
      required this.fdPPN,
      required this.fdNamaBarang,
      required this.fdTanggalKirim,
      required this.fdNoEntryOrder,
      required this.fdNoOrder,
      required this.fdTanggalOrder,
      required this.fdLimitKredit,
      required this.fdKodeTransaksiFP,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory Piutang.setData(Map<String, dynamic> item) {
    return Piutang(
      fdTipePiutang: item['fdTipePiutang'] ?? '',
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
      fdTanggalJT: item['fdTanggalJT'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdBayar: item['fdBayar'] ?? 0,
      fdGiro: item['fdGiro'] ?? 0,
      fdGiroTolak: item['fdGiroTolak'] ?? 0,
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdNoUrutFaktur: item['fdNoUrutFaktur'] ?? '',
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? '',
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdSatuan: item['fdSatuan'] ?? '',
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdHargaAsli: item['fdHargaAsli'] ?? 0,
      fdUnitPrice: item['fdUnitPrice'] ?? 0,
      fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
      fdUnitPricePPN: item['fdUnitPricePPN'] ?? 0,
      fdBrutto: item['fdBrutto'] ?? 0,
      fdBruttopromosi: item['fdBruttopromosi'] ?? 0,
      fdDiscount: item['fdDiscount'] ?? 0,
      fdNetto: item['fdNetto'] ?? 0,
      fdDPP: item['fdDPP'] ?? 0,
      fdPPN: item['fdPPN'] ?? 0,
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoOrder: item['fdNoOrder'] ?? '',
      fdTanggalOrder: item['fdTanggalOrder'] ?? '',
      fdLimitKredit: item['fdLimitKredit'] ?? 0,
      fdKodeTransaksiFP: item['fdKodeTransaksiFP'] ?? '',
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Piutang.fromJson(Map<String, dynamic> json) {
    return Piutang(
        fdTipePiutang: json['fdTipePiutang'] ?? '',
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdNoFaktur: json['fdNoFaktur'].toString(),
        fdDepo: json['fdDepo'] ?? '',
        fdTanggalFaktur: json['fdTanggalFaktur'].toString(),
        fdTanggalJT: json['fdTanggalJT'].toString(),
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdBayar: double.tryParse(json['fdBayar'].toString()) != null
            ? json['fdBayar'].toDouble()
            : 0,
        fdGiro: double.tryParse(json['fdGiro'].toString()) != null
            ? json['fdGiro'].toDouble()
            : 0,
        fdGiroTolak: double.tryParse(json['fdGiroTolak'].toString()) != null
            ? json['fdGiroTolak'].toDouble()
            : 0,
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdTglStatus: json['fdTglStatus'].toString(),
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdNoUrutFaktur: json['fdNoUrutFaktur'].toString(),
        fdNoEntrySJ: json['fdNoEntrySJ'].toString(),
        fdNoUrutSJ: json['fdNoUrutSJ'].toString(),
        fdKodeBarang: json['fdKodeBarang'].toString(),
        fdPromosi: json['fdPromosi'].toString(),
        fdReplacement: json['fdReplacement'].toString(),
        fdJenisSatuan: json['fdJenisSatuan'].toString(),
        fdSatuan: json['fdSatuan'].toString(),
        fdQty: double.tryParse(json['fdQty'].toString()) != null
            ? json['fdQty'].toDouble()
            : 0,
        fdQtyK: double.tryParse(json['fdQtyK'].toString()) != null
            ? json['fdQtyK'].toDouble()
            : 0,
        fdHargaAsli: double.tryParse(json['fdHargaAsli'].toString()) != null
            ? json['fdHargaAsli'].toDouble()
            : 0,
        fdUnitPrice: double.tryParse(json['fdUnitPrice'].toString()) != null
            ? json['fdUnitPrice'].toDouble()
            : 0,
        fdUnitPriceK: double.tryParse(json['fdUnitPriceK'].toString()) != null
            ? json['fdUnitPriceK'].toDouble()
            : 0,
        fdUnitPricePPN:
            double.tryParse(json['fdUnitPricePPN'].toString()) != null
                ? json['fdUnitPricePPN'].toDouble()
                : 0,
        fdBrutto: double.tryParse(json['fdBrutto'].toString()) != null
            ? json['fdBrutto'].toDouble()
            : 0,
        fdBruttopromosi:
            double.tryParse(json['fdBruttopromosi'].toString()) != null
                ? json['fdBruttopromosi'].toDouble()
                : 0,
        fdDiscount: double.tryParse(json['fdDiscount'].toString()) != null
            ? json['fdDiscount'].toDouble()
            : 0,
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdDPP: double.tryParse(json['fdDPP'].toString()) != null
            ? json['fdDPP'].toDouble()
            : 0,
        fdPPN: double.tryParse(json['fdPPN'].toString()) != null
            ? json['fdPPN'].toDouble()
            : 0,
        fdNamaBarang: json['fdNamaBarang'].toString(),
        fdTanggalKirim: json['fdTanggalKirim'].toString(),
        fdNoEntryOrder: json['fdNoEntryOrder'].toString(),
        fdNoOrder: json['fdNoOrder'].toString(),
        fdTanggalOrder: json['fdTanggalOrder'].toString(),
        fdLimitKredit: double.tryParse(json['fdLimitKredit'].toString()) != null
            ? json['fdLimitKredit'].toDouble()
            : 0,
        fdKodeTransaksiFP: json['fdKodeTransaksiFP'] ?? '',
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory Piutang.empty() {
    return Piutang(
        fdTipePiutang: '',
        fdNoEntryFaktur: '',
        fdNoFaktur: '',
        fdDepo: '',
        fdTanggalFaktur: '',
        fdTanggalJT: '',
        fdKodeLangganan: '',
        fdBayar: 0,
        fdGiro: 0,
        fdGiroTolak: 0,
        fdKodeStatus: 0,
        fdTglStatus: '',
        fdStatusRecord: 0,
        fdNoUrutFaktur: '',
        fdNoEntrySJ: '',
        fdNoUrutSJ: '',
        fdKodeBarang: '',
        fdPromosi: '',
        fdReplacement: '',
        fdJenisSatuan: '',
        fdSatuan: '',
        fdQty: 0,
        fdQtyK: 0,
        fdHargaAsli: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdUnitPricePPN: 0,
        fdBrutto: 0,
        fdBruttopromosi: 0,
        fdDiscount: 0,
        fdNetto: 0,
        fdDPP: 0,
        fdPPN: 0,
        fdNamaBarang: '',
        fdTanggalKirim: '',
        fdNoEntryOrder: '',
        fdNoOrder: '',
        fdTanggalOrder: '',
        fdLimitKredit: 0,
        fdKodeTransaksiFP: '',
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataPiutang(
    String? fdTipePiutang,
    String? fdNoEntryFaktur,
    String? fdNoFaktur,
    String? fdDepo,
    String? fdTanggalFaktur,
    String? fdTanggalJT,
    String? fdKodeLangganan,
    double fdBayar,
    double fdGiro,
    double fdGiroTolak,
    int fdKodeStatus,
    String? fdTglStatus,
    int fdStatusRecord,
    String? fdNoUrutFaktur,
    String? fdNoEntrySJ,
    String? fdNoUrutSJ,
    String? fdKodeBarang,
    String? fdPromosi,
    String? fdReplacement,
    String? fdJenisSatuan,
    double fdQty,
    double fdUnitPrice,
    double fdBrutto,
    double fdDiscount,
    double fdNetto,
    double fdDPP,
    double fdPPN,
    String? fdNamaBarang,
    String? fdSatuan,
    String? fdTanggalKirim,
    String? fdNoOrder,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdTipePiutang": fdTipePiutang,
    "fdNoEntryFaktur": fdNoEntryFaktur,
    "fdNoFaktur": fdNoFaktur,
    "fdDepo": fdDepo,
    "fdTanggalFaktur": fdTanggalFaktur,
    "fdTanggalJT": fdTanggalJT,
    "fdKodeLangganan": fdKodeLangganan,
    "fdBayar": fdBayar,
    "fdGiro": fdGiro,
    "fdGiroTolak": fdGiroTolak,
    "fdKodeStatus": fdKodeStatus,
    "fdTglStatus": fdTglStatus,
    "fdStatusRecord": fdStatusRecord,
    "fdNoUrutFaktur": fdNoUrutFaktur,
    "fdNoEntrySJ": fdNoEntrySJ,
    "fdNoUrutSJ": fdNoUrutSJ,
    "fdKodeBarang": fdKodeBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQty": fdQty,
    "fdUnitPrice": fdUnitPrice,
    "fdBrutto": fdBrutto,
    "fdDiscount": fdDiscount,
    "fdNetto": fdNetto,
    "fdDPP": fdDPP,
    "fdPPN": fdPPN,
    "fdNamaBarang": fdNamaBarang,
    "fdSatuan": fdSatuan,
    "fdTanggalKirim": fdTanggalKirim,
    "fdNoOrder": fdNoOrder,
    "fdLastUpdate": fdLastUpdate
  };
}

class FakturExt {
  final String? fdNoEntry;
  final String? fdNoEntryFaktur;
  final String? fdNoFaktur;
  final String? fdDepo;
  final String? fdKodeLangganan;
  final String? fdJenis;
  final String? fdPath;
  final String? fdTanggal;
  final int fdUrut;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  FakturExt(
      {required this.fdNoEntry,
      required this.fdNoEntryFaktur,
      required this.fdNoFaktur,
      required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdJenis,
      required this.fdPath,
      required this.fdTanggal,
      required this.fdUrut,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory FakturExt.setData(Map<String, dynamic> item) {
    return FakturExt(
      fdNoEntry: item['fdNoEntry'] ?? '',
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdJenis: item['fdJenis'] ?? '',
      fdPath: item['fdPath'] ?? '',
      fdTanggal: item['fdTanggal'] ?? '',
      fdUrut: item['fdUrut'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory FakturExt.prepareInsert(Map<String, dynamic> item, String fdPath) {
    return FakturExt(
      fdNoEntry: item['fdNoEntryFaktur'] ?? '',
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdJenis: item['fdJenisFaktur'] ?? '',
      fdPath: fdPath,
      fdTanggal: item['fdTanggalFaktur'] ?? '',
      fdUrut: item['fdUrut'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory FakturExt.fromJson(Map<String, dynamic> json) {
    return FakturExt(
        fdNoEntry: json['fdNoEntry'] ?? '',
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdNoFaktur: json['fdNoFaktur'].toString(),
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdJenis: json['fdJenis'].toString(),
        fdPath: json['fdPath'].toString(),
        fdTanggal: json['fdTanggal'].toString(),
        fdUrut: json['fdUrut'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory FakturExt.empty() {
    return FakturExt(
        fdNoEntry: '',
        fdNoEntryFaktur: '',
        fdNoFaktur: '',
        fdDepo: '',
        fdKodeLangganan: '',
        fdJenis: '',
        fdPath: '',
        fdTanggal: '',
        fdUrut: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

Map<String, dynamic> setJsonDataFakturExt(
    String? fdNoEntry,
    String? fdNoEntryFaktur,
    String? fdNoFaktur,
    String? fdDepo,
    String? fdKodeLangganan,
    String? fdJenis,
    String? fdPath,
    String? fdTanggal,
    int fdUrut,
    int fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdTipePiutang": fdNoEntry,
    "fdNoEntryFaktur": fdNoEntryFaktur,
    "fdNoFaktur": fdNoFaktur,
    "fdDepo": fdDepo,
    "fdKodeLangganan": fdKodeLangganan,
    "fdJenis": fdJenis,
    "fdPath": fdPath,
    "fdTanggal": fdTanggal,
    "fdUrut": fdUrut,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

class Payment {
  final String? fdNoEntryFaktur;
  final String? fdNoFaktur;
  final String? fdDepo;
  final String? fdTanggal;
  final String? fdTanggalFaktur;
  final String? fdTanggalJT;
  final double? fdNetto;
  final int fdIdCollection;
  final String fdKodeLangganan;
  double fdAllocationAmount = 0;
  bool selected = false;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? fdData;
  final String? fdMessage;

  Payment(
      {required this.fdNoEntryFaktur,
      this.fdNoFaktur,
      required this.fdDepo,
      required this.fdTanggal,
      this.fdTanggalFaktur,
      this.fdTanggalJT,
      this.fdNetto,
      required this.fdIdCollection,
      required this.fdKodeLangganan,
      required this.fdAllocationAmount,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      required this.fdData,
      required this.fdMessage});

  factory Payment.setData(Map<String, dynamic> item) {
    return Payment(
        fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
        fdNoFaktur: item['fdNoFaktur'] ?? '',
        fdDepo: item['fdDepo'] ?? '',
        fdTanggal: item['fdTanggal'] ?? '',
        fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
        fdTanggalJT: item['fdTanggalJT'] ?? '',
        fdNetto: double.tryParse(item['fdNetto'].toString()) != null
            ? item['fdNetto'].toDouble()
            : 0,
        fdIdCollection: ((item['fdIdCollection'] is num)
            ? (item['fdIdCollection'] as num).toInt()
            : int.tryParse(item['fdIdCollection'].toString()) ?? 0),
        fdKodeLangganan: item['fdKodeLangganan'] ?? '',
        fdAllocationAmount:
            double.tryParse(item['fdAllocationAmount'].toString()) != null
                ? item['fdAllocationAmount'].toDouble()
                : 0,
        fdStatusSent: item['fdStatusSent'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '',
        fdData: item['fdData'] ?? '',
        fdMessage: item['fdMessage'] ?? '');
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdTanggal: json['fdTanggal'].toString(),
        fdTanggalFaktur: json['fdTanggalFaktur'] ?? '',
        fdTanggalJT: json['fdTanggalJT'] ?? '',
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdIdCollection: ((json['fdIdCollection'] is num)
            ? (json['fdIdCollection'] as num).toInt()
            : int.tryParse(json['fdIdCollection'].toString()) ?? 0),
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdAllocationAmount:
            double.tryParse(json['fdAllocationAmount'].toString()) != null
                ? json['fdAllocationAmount'].toDouble()
                : 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }
}

Map<String, dynamic> setJsonDataPaymentApi(
    String? fdNoEntryFaktur,
    String? fdDepo,
    String? fdTanggal,
    int? fdIdCollection,
    String? fdKodeLangganan,
    double? fdAllocationAmount,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntryFaktur": fdNoEntryFaktur,
    "fdDepo": fdDepo,
    "fdTanggal": fdTanggal,
    "fdIdCollection": fdIdCollection,
    "fdKodeLangganan": fdKodeLangganan,
    "fdAllocationAmount": fdAllocationAmount,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

class Faktur {
  final String? fdNoEntryFaktur;
  final String? fdDepo;
  final String? fdJenisFaktur;
  final String? fdNoFaktur;
  final String? fdNoOrder;
  final String? fdTanggalOrder;
  final int isTagihan;
  final String? fdTanggalKirim;
  final String? fdTanggalFaktur;
  final String? fdTOP;
  final String? fdTanggalJT;
  final String? fdKodeLangganan;
  final String? fdNoEntryProforma;
  final String? fdFPajak;
  final String? fdPPH;
  final String? fdKeterangan;
  final String? fdMataUang;
  final String? fdKodeSF;
  final String? fdKodeAP1;
  final String? fdKodeAP2;
  final int fdReasonNotApprove;
  final String? fdDisetujuiOleh;
  final int fdKodeStatus;
  final String? fdTglStatus;
  final String? fdKodeGudang;
  final String? fdNoOrderSFA;
  final String? fdTglSFA;
  final int fdStatusRecord;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  Faktur(
      {required this.fdNoEntryFaktur,
      required this.fdDepo,
      required this.fdJenisFaktur,
      required this.fdNoFaktur,
      required this.fdNoOrder,
      required this.fdTanggalKirim,
      required this.fdTanggalOrder,
      required this.isTagihan,
      required this.fdTanggalFaktur,
      required this.fdTOP,
      required this.fdTanggalJT,
      required this.fdKodeLangganan,
      required this.fdNoEntryProforma,
      required this.fdFPajak,
      required this.fdPPH,
      required this.fdKeterangan,
      required this.fdMataUang,
      required this.fdKodeSF,
      required this.fdKodeAP1,
      required this.fdKodeAP2,
      required this.fdReasonNotApprove,
      required this.fdDisetujuiOleh,
      required this.fdKodeStatus,
      required this.fdTglStatus,
      required this.fdKodeGudang,
      required this.fdNoOrderSFA,
      required this.fdTglSFA,
      required this.fdStatusRecord,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory Faktur.setData(Map<String, dynamic> item) {
    return Faktur(
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdJenisFaktur: item['fdJenisFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdNoOrder: item['fdNoOrder'] ?? '',
      fdTanggalOrder: item['fdTanggalOrder'] ?? '',
      fdTanggalKirim: item['fdTanggalKirim'] ?? '',
      isTagihan: item['isTagihan'] ?? 0,
      fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
      fdTOP: item['fdTOP'] ?? '',
      fdTanggalJT: item['fdTanggalJT'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdFPajak: item['fdFPajak'] ?? '',
      fdPPH: item['fdPPH'] ?? '',
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdMataUang: item['fdMataUang'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeAP1: item['fdKodeAP1'] ?? '',
      fdKodeAP2: item['fdKodeAP2'] ?? '',
      fdReasonNotApprove: item['fdReasonNotApprove'] ?? 0,
      fdDisetujuiOleh: item['fdDisetujuiOleh'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdNoOrderSFA: item['fdNoOrderSFA'] ?? '',
      fdTglSFA: item['fdTglSFA'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Faktur.fromJson(Map<String, dynamic> json) {
    return Faktur(
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdDepo: json['fdDepo'] ?? '',
        fdJenisFaktur: json['fdJenisFaktur'] ?? '',
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdNoOrder: json['fdNoOrder'].toString(),
        fdTanggalOrder: json['fdTanggalOrder'] ?? '',
        fdTanggalKirim: json['fdTanggalKirim'] ?? '',
        isTagihan: 1,
        fdTanggalFaktur: json['fdTanggalFaktur'] ?? '',
        fdTOP: json['fdTOP'].toString(),
        fdTanggalJT: json['fdTanggalJT'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'].toString(),
        fdNoEntryProforma: json['fdNoEntryProforma'].toString(),
        fdFPajak: json['fdFPajak'] ?? '',
        fdPPH: json['fdPPH'].toString(),
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdMataUang: json['fdMataUang'] ?? '',
        fdKodeSF: json['fdKodeSF'].toString(),
        fdKodeAP1: json['fdKodeAP1'].toString(),
        fdKodeAP2: json['fdKodeAP2'].toString(),
        fdReasonNotApprove: json['fdReasonNotApprove'] ?? 0,
        fdDisetujuiOleh: json['fdDisetujuiOleh'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdNoOrderSFA: json['fdNoOrderSFA'].toString(),
        fdTglSFA: json['fdTglSFA'] ?? '',
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory Faktur.empty() {
    return Faktur(
        fdNoEntryFaktur: '',
        fdDepo: '',
        fdJenisFaktur: '',
        fdNoFaktur: '',
        fdNoOrder: '',
        fdTanggalOrder: '',
        fdTanggalKirim: '',
        isTagihan: 0,
        fdTanggalFaktur: '',
        fdTOP: '',
        fdTanggalJT: '',
        fdKodeLangganan: '',
        fdNoEntryProforma: '',
        fdFPajak: '',
        fdPPH: '',
        fdKeterangan: '',
        fdMataUang: '',
        fdKodeSF: '',
        fdKodeAP1: '',
        fdKodeAP2: '',
        fdReasonNotApprove: 0,
        fdDisetujuiOleh: '',
        fdKodeStatus: 0,
        fdTglStatus: '',
        fdKodeGudang: '',
        fdNoOrderSFA: '',
        fdTglSFA: '',
        fdStatusRecord: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class FakturItem {
  final String? fdNoEntryFaktur;
  final int? fdNoUrutFaktur;
  final String? fdNoEntrySJ;
  final int? fdNoUrutSJ;
  final String? fdNoEntryProforma;
  final int? fdNoUrutProforma;
  final String? fdKodeBarang;
  final String? fdPromosi;
  final int? fdReplacement;
  final String fdJenisSatuan;
  int fdQty;
  int fdQtyK;
  double fdHargaAsli;
  double fdUnitPrice;
  double fdUnitPriceK;
  double fdBrutto;
  double fdDiscount;
  String fdDiscountDetail;
  double fdNetto;
  final double fdDPP;
  final double fdPPN;
  final String fdNoPromosi;
  final int fdStatusRecord;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  FakturItem(
      {required this.fdNoEntryFaktur,
      required this.fdNoUrutFaktur,
      required this.fdNoEntrySJ,
      required this.fdNoUrutSJ,
      required this.fdNoEntryProforma,
      required this.fdNoUrutProforma,
      required this.fdKodeBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdHargaAsli,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdBrutto,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdNetto,
      required this.fdDPP,
      required this.fdPPN,
      required this.fdNoPromosi,
      required this.fdStatusRecord,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory FakturItem.setData(Map<String, dynamic> item) {
    return FakturItem(
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdNoUrutFaktur: item['fdNoUrutFaktur'] ?? 0,
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? 0,
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdNoUrutProforma: item['fdNoUrutProforma'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? 0,
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdHargaAsli: item['fdHargaAsli'] ?? 0,
      fdUnitPrice: item['fdUnitPrice'] ?? 0,
      fdUnitPriceK: item['fdUnitPriceK'] ?? 0,
      fdBrutto: item['fdBrutto'] ?? 0,
      fdDiscount: item['fdDiscount'] ?? 0,
      fdDiscountDetail: item['fdDiscountDetail'] ?? '',
      fdNetto: item['fdNetto'] ?? 0,
      fdDPP: item['fdDPP'] ?? 0,
      fdPPN: item['fdPPN'] ?? 0,
      fdNoPromosi: item['fdNoPromosi'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory FakturItem.fromJson(Map<String, dynamic> json) {
    return FakturItem(
        fdNoEntryFaktur: json['fdNoEntryFaktur'].toString(),
        fdNoUrutFaktur: json['fdNoUrutFaktur'] ?? 0,
        fdNoEntrySJ: json['fdNoEntrySJ'].toString(),
        fdNoUrutSJ: json['fdNoUrutSJ'] ?? 0,
        fdNoEntryProforma: json['fdNoEntryProforma'].toString(),
        fdNoUrutProforma: json['fdNoUrutProforma'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? 0,
        fdJenisSatuan: json['fdJenisSatuan'].toString(),
        fdQty: ((json['fdQty'] is num)
            ? (json['fdQty'] as num).toInt()
            : int.tryParse(json['fdQty'].toString()) ?? 0),
        fdQtyK: ((json['fdQtyK'] is num)
            ? (json['fdQtyK'] as num).toInt()
            : int.tryParse(json['fdQtyK'].toString()) ?? 0),
        fdHargaAsli: double.tryParse(json['fdHargaAsli'].toString()) != null
            ? json['fdHargaAsli'].toDouble()
            : 0,
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
        fdDPP: double.tryParse(json['fdDPP'].toString()) != null
            ? json['fdDPP'].toDouble()
            : 0,
        fdPPN: double.tryParse(json['fdPPN'].toString()) != null
            ? json['fdPPN'].toDouble()
            : 0,
        fdNoPromosi: json['fdNoPromosi'].toString(),
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory FakturItem.empty() {
    return FakturItem(
        fdNoEntryFaktur: '',
        fdNoUrutFaktur: 0,
        fdNoEntrySJ: '',
        fdNoUrutSJ: 0,
        fdNoEntryProforma: '',
        fdNoUrutProforma: 0,
        fdKodeBarang: '',
        fdPromosi: '',
        fdReplacement: 0,
        fdJenisSatuan: '0',
        fdQty: 0,
        fdQtyK: 0,
        fdHargaAsli: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdBrutto: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdNetto: 0,
        fdDPP: 0,
        fdPPN: 0,
        fdNoPromosi: '',
        fdStatusRecord: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class SuratJalan {
  final String? fdNoEntrySJ;
  final String? fdDepo;
  final String? fdJenisSJ;
  final String? fdNoSJ;
  final String? fdTanggalSJ;
  final String? fdKodeLangganan;
  final String? fdKodeSF;
  final String? fdKodeAP1;
  final String? fdKodeAP2;
  final String? fdKodeGudang;
  final String? fdKodeGudangTujuan;
  final String? fdNoEntryProforma;
  final String? fdAlamatKirim;
  final String? fdKeterangan;
  final String? fdNoPolisi;
  final String? fdKodeEkspedisi;
  final String fdSupirNama;
  final String? fdSupirKTP;
  final String? fdArmada;
  final String? fdETD;
  final String? fdETA;
  final String? fdNoContainer;
  final String? fdNoSeal;
  final String? fdAktTglKirim;
  final String? fdAktTglTiba;
  final String? fdAktTglSerah;
  final String? fdKeteranganPengiriman;
  final String? fdIsFaktur;
  final int fdKodeStatus;
  final String? fdTglStatus;
  final int fdStatusRecord;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  SuratJalan(
      {required this.fdNoEntrySJ,
      required this.fdDepo,
      required this.fdJenisSJ,
      required this.fdNoSJ,
      required this.fdTanggalSJ,
      required this.fdKodeLangganan,
      required this.fdKodeSF,
      required this.fdKodeAP1,
      required this.fdKodeAP2,
      required this.fdKodeGudang,
      required this.fdKodeGudangTujuan,
      required this.fdNoEntryProforma,
      required this.fdAlamatKirim,
      required this.fdKeterangan,
      required this.fdNoPolisi,
      required this.fdKodeEkspedisi,
      required this.fdSupirNama,
      required this.fdSupirKTP,
      required this.fdArmada,
      required this.fdETD,
      required this.fdETA,
      required this.fdNoContainer,
      required this.fdNoSeal,
      required this.fdAktTglKirim,
      required this.fdAktTglTiba,
      required this.fdAktTglSerah,
      required this.fdKeteranganPengiriman,
      required this.fdIsFaktur,
      required this.fdKodeStatus,
      required this.fdTglStatus,
      required this.fdStatusRecord,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory SuratJalan.setData(Map<String, dynamic> item) {
    return SuratJalan(
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdJenisSJ: item['fdJenisSJ'] ?? '',
      fdNoSJ: item['fdNoSJ'] ?? '',
      fdTanggalSJ: item['fdTanggalSJ'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeAP1: item['fdKodeAP1'] ?? '',
      fdKodeAP2: item['fdKodeAP2'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangTujuan: item['fdKodeGudangTujuan'] ?? '',
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdNoPolisi: item['fdNoPolisi'] ?? '',
      fdKodeEkspedisi: item['fdKodeEkspedisi'] ?? '',
      fdSupirNama: item['fdSupirNama'] ?? '',
      fdSupirKTP: item['fdSupirKTP'] ?? '',
      fdArmada: item['fdArmada'] ?? '',
      fdETD: item['fdETD'] ?? '',
      fdETA: item['fdETA'] ?? '',
      fdNoContainer: item['fdNoContainer'] ?? '',
      fdNoSeal: item['fdNoSeal'] ?? '',
      fdAktTglKirim: item['fdAktTglKirim'] ?? '',
      fdAktTglTiba: item['fdAktTglTiba'] ?? '',
      fdAktTglSerah: item['fdAktTglSerah'] ?? '',
      fdKeteranganPengiriman: item['fdKeteranganPengiriman'] ?? '',
      fdIsFaktur: item['fdIsFaktur'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory SuratJalan.fromJson(Map<String, dynamic> json) {
    return SuratJalan(
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdJenisSJ: json['fdJenisSJ'] ?? '',
        fdNoSJ: json['fdNoSJ'] ?? '',
        fdTanggalSJ: json['fdTanggalSJ'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeAP1: json['fdKodeAP1'] ?? '',
        fdKodeAP2: json['fdKodeAP2'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangTujuan: json['fdKodeGudangTujuan'] ?? '',
        fdNoEntryProforma: json['fdNoEntryProforma'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdNoPolisi: json['fdNoPolisi'] ?? '',
        fdKodeEkspedisi: json['fdKodeEkspedisi'] ?? '',
        fdSupirNama: json['fdSupirNama'] ?? '',
        fdSupirKTP: json['fdSupirKTP'] ?? '',
        fdArmada: json['fdArmada'] ?? '',
        fdETD: json['fdETD'] ?? '',
        fdETA: json['fdETA'] ?? '',
        fdNoContainer: json['fdNoContainer'] ?? '',
        fdNoSeal: json['fdNoSeal'] ?? '',
        fdAktTglKirim: json['fdAktTglKirim'] ?? '',
        fdAktTglTiba: json['fdAktTglTiba'] ?? '',
        fdAktTglSerah: json['fdAktTglSerah'] ?? '',
        fdKeteranganPengiriman: json['fdKeteranganPengiriman'] ?? '',
        fdIsFaktur: json['fdIsFaktur'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory SuratJalan.empty() {
    return SuratJalan(
        fdNoEntrySJ: '',
        fdDepo: '',
        fdJenisSJ: '',
        fdNoSJ: '',
        fdTanggalSJ: '',
        fdKodeLangganan: '',
        fdKodeSF: '',
        fdKodeAP1: '',
        fdKodeAP2: '',
        fdKodeGudang: '',
        fdKodeGudangTujuan: '',
        fdNoEntryProforma: '',
        fdAlamatKirim: '',
        fdKeterangan: '',
        fdNoPolisi: '',
        fdKodeEkspedisi: '',
        fdSupirNama: '',
        fdSupirKTP: '',
        fdArmada: '',
        fdETD: '',
        fdETA: '',
        fdNoContainer: '',
        fdNoSeal: '',
        fdAktTglKirim: '',
        fdAktTglTiba: '',
        fdAktTglSerah: '',
        fdKeteranganPengiriman: '',
        fdIsFaktur: '',
        fdKodeStatus: 0,
        fdTglStatus: '',
        fdStatusRecord: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class SuratJalanItem {
  final String? fdNoEntrySJ;
  final int? fdNoUrutSJ;
  final String? fdNoEntryOrder;
  final int? fdNoUrutOrder;
  final String? fdNoEntryProforma;
  final int? fdNoUrutProforma;
  final String? fdKodeBarang;
  final String? fdPromosi;
  final int? fdReplacement;
  final String? fdJenisSatuan;
  final int? fdQty;
  final int? fdQtyK;
  final double? fdPalet;
  final String? fdDetailPalet;
  final double? fdNetWeight;
  final double? fdGrossWeight;
  final double? fdVolume;
  final String fdNotes;
  final String? fdCartonNo;
  final int? fdQtyJual;
  final double? fdRusakB;
  final double? fdRusakS;
  final double? fdRusakK;
  final double? fdSisaB;
  final double? fdSisaS;
  final double? fdSisaK;
  final int fdStatusRecord;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  SuratJalanItem(
      {required this.fdNoEntrySJ,
      required this.fdNoUrutSJ,
      required this.fdNoEntryOrder,
      required this.fdNoUrutOrder,
      required this.fdNoEntryProforma,
      required this.fdNoUrutProforma,
      required this.fdKodeBarang,
      required this.fdPromosi,
      required this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdPalet,
      required this.fdDetailPalet,
      required this.fdNetWeight,
      required this.fdGrossWeight,
      required this.fdVolume,
      required this.fdNotes,
      required this.fdCartonNo,
      required this.fdQtyJual,
      required this.fdRusakB,
      required this.fdRusakS,
      required this.fdRusakK,
      required this.fdSisaB,
      required this.fdSisaS,
      required this.fdSisaK,
      required this.fdStatusRecord,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory SuratJalanItem.setData(Map<String, dynamic> item) {
    return SuratJalanItem(
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? 0,
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoUrutOrder: item['fdNoUrutOrder'] ?? 0,
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdNoUrutProforma: item['fdNoUrutProforma'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '0',
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdPalet: item['fdPalet'] ?? 0,
      fdDetailPalet: item['fdDetailPalet'] ?? '',
      fdNetWeight: 0,
      fdGrossWeight: 0,
      fdVolume: item['fdVolume'] ?? 0,
      fdNotes: item['fdNotes'] ?? '',
      fdCartonNo: item['fdCartonNo'] ?? '',
      fdQtyJual: item['fdQtyJual'] ?? 0,
      fdRusakB: item['fdRusakB'] ?? 0,
      fdRusakS: item['fdRusakS'] ?? 0,
      fdRusakK: item['fdRusakK'] ?? 0,
      fdSisaB: item['fdSisaB'] ?? 0,
      fdSisaS: item['fdSisaS'] ?? 0,
      fdSisaK: item['fdSisaK'] ?? 0,
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory SuratJalanItem.fromJson(Map<String, dynamic> json) {
    return SuratJalanItem(
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdNoUrutSJ: json['fdNoUrutSJ'] ?? 0,
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
        fdNoUrutOrder: json['fdNoUrutOrder'] ?? 0,
        fdNoEntryProforma: json['fdNoEntryProforma'] ?? '',
        fdNoUrutProforma: json['fdNoUrutProforma'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? 0,
        fdJenisSatuan: json['fdJenisSatuan'] ?? '0',
        fdQty: json['fdQty'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
        fdPalet: json['fdPalet'] ?? 0,
        fdDetailPalet: json['fdDetailPalet'] ?? '',
        fdNetWeight: json['fdNetWeight'] ?? 0,
        fdGrossWeight: json['fdGrossWeight'] ?? 0,
        fdVolume: json['fdVolume'] ?? 0,
        fdNotes: json['fdNotes'] ?? '',
        fdCartonNo: json['fdCartonNo'] ?? '',
        fdQtyJual: json['fdQtyJual'] ?? 0,
        fdRusakB: json['fdRusakB'] ?? 0,
        fdRusakS: json['fdRusakS'] ?? 0,
        fdRusakK: json['fdRusakK'] ?? 0,
        fdSisaB: json['fdSisaB'] ?? 0,
        fdSisaS: json['fdSisaS'] ?? 0,
        fdSisaK: json['fdSisaK'] ?? 0,
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory SuratJalanItem.empty() {
    return SuratJalanItem(
        fdNoEntrySJ: '',
        fdNoUrutSJ: 0,
        fdNoEntryOrder: '',
        fdNoUrutOrder: 0,
        fdNoEntryProforma: '',
        fdNoUrutProforma: 0,
        fdKodeBarang: '',
        fdPromosi: '',
        fdReplacement: 0,
        fdJenisSatuan: '0',
        fdQty: 0,
        fdQtyK: 0,
        fdPalet: 0,
        fdDetailPalet: '',
        fdNetWeight: 0,
        fdGrossWeight: 0,
        fdVolume: 0,
        fdNotes: '',
        fdCartonNo: '',
        fdQtyJual: 0,
        fdRusakB: 0,
        fdRusakS: 0,
        fdRusakK: 0,
        fdSisaB: 0,
        fdSisaS: 0,
        fdSisaK: 0,
        fdStatusRecord: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class SuratJalanItemDetail {
  final String? fdNoEntrySJ;
  final int? fdNoUrutSJ;
  final String? fdKodeBarang;
  final String? fdDateCode;
  final String? fdPromosi;
  final String? fdJenisSatuan;
  final int? fdQty;
  final int? fdQtyK;
  final int fdStatusRecord;
  final int fdStatusSent;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  SuratJalanItemDetail(
      {required this.fdNoEntrySJ,
      required this.fdNoUrutSJ,
      required this.fdKodeBarang,
      required this.fdDateCode,
      required this.fdPromosi,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdStatusRecord,
      required this.fdStatusSent,
      required this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory SuratJalanItemDetail.setData(Map<String, dynamic> item) {
    return SuratJalanItemDetail(
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdDateCode: item['fdDateCode'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdJenisSatuan: item['fdNoEntrySJ'] ?? '0',
      fdQty: item['fdQty'] ?? 0,
      fdQtyK: item['fdQtyK'] ?? 0,
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory SuratJalanItemDetail.fromJson(Map<String, dynamic> json) {
    return SuratJalanItemDetail(
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdNoUrutSJ: json['fdNoUrutSJ'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdDateCode: json['fdDateCode'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdJenisSatuan: json['fdNoEntrySJ'] ?? '0',
        fdQty: json['fdNoEntrySJ'] ?? 0,
        fdQtyK: json['fdQtyK'] ?? 0,
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory SuratJalanItemDetail.empty() {
    return SuratJalanItemDetail(
        fdNoEntrySJ: '',
        fdNoUrutSJ: 0,
        fdKodeBarang: '',
        fdDateCode: '',
        fdPromosi: '',
        fdJenisSatuan: '0',
        fdQty: 0,
        fdQtyK: 0,
        fdStatusRecord: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '');
  }
}

class FakturApi {
  //HEADER
  final String? fdNoEntryFaktur;
  final String? fdDepo;
  final String? fdJenisFaktur;
  final String? fdNoFaktur;
  final String? fdTanggalFaktur;
  String? fdTOP;
  final String? fdTanggalJT;
  final String? fdKodeLangganan;
  String? fdNoEntryProforma;
  String? fdFPajak;
  String? fdPPH;
  String? fdKeterangan;
  String? fdMataUang;
  final String? fdKodeSF;
  String? fdKodeAP1;
  String? fdKodeAP2;
  int? fdReasonNotApprove;
  final String? fdDisetujuiOleh;
  int? fdKodeStatus;
  final String? fdTglStatus;
  final String? fdKodeGudang;
  final String? fdNoOrderSFA;
  final String? fdTglSFA;
  int? fdStatusRecord;
  String? fdCreateUserID;
  String? fdCreateTS;
  String? fdUpdateUserID;
  String? fdUpdateTS;
  String? fdNoEntryLama;
  //DETAIL
  int? fdNoUrutFaktur;
  final String? fdNoEntrySJ;
  int? fdNoUrutSJ;
  int? fdNoUrutProforma;
  final String? fdKodeBarang;
  final String? fdPromosi;
  int? fdReplacement;
  final String? fdJenisSatuan;
  final int fdQty;
  final int fdQtyK;
  final double fdUnitPrice;
  final double fdUnitPriceK;
  final double fdBrutto;
  final double fdDiscount;
  final String? fdDiscountDetail;
  final double fdNetto;
  double? fdDPP;
  double? fdPPN;
  String? fdNoPromosi;
  String? fdNamaLangganan;
  double? tagihan;
  double? tunai;
  double? giro;
  double? cheque;
  double? transfer;

  int? fdStatusSent;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  FakturApi(
      {required this.fdNoEntryFaktur,
      required this.fdDepo,
      required this.fdJenisFaktur,
      required this.fdNoFaktur,
      required this.fdTanggalFaktur,
      this.fdTOP,
      required this.fdTanggalJT,
      required this.fdKodeLangganan,
      this.fdNoEntryProforma,
      this.fdFPajak,
      this.fdPPH,
      this.fdKeterangan,
      this.fdMataUang,
      required this.fdKodeSF,
      this.fdKodeAP1,
      this.fdKodeAP2,
      this.fdReasonNotApprove,
      this.fdDisetujuiOleh,
      this.fdKodeStatus,
      required this.fdTglStatus,
      required this.fdKodeGudang,
      required this.fdNoOrderSFA,
      required this.fdTglSFA,
      this.fdStatusRecord,
      this.fdCreateUserID,
      this.fdCreateTS,
      this.fdUpdateUserID,
      this.fdUpdateTS,
      this.fdNoEntryLama,
      required this.fdNoUrutFaktur,
      required this.fdNoEntrySJ,
      required this.fdNoUrutSJ,
      this.fdNoUrutProforma,
      required this.fdKodeBarang,
      required this.fdPromosi,
      this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
      required this.fdUnitPrice,
      required this.fdUnitPriceK,
      required this.fdBrutto,
      required this.fdDiscount,
      required this.fdDiscountDetail,
      required this.fdNetto,
      this.fdDPP,
      this.fdPPN,
      this.fdNoPromosi,
      this.fdNamaLangganan,
      this.tagihan,
      this.tunai,
      this.giro,
      this.cheque,
      this.transfer,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory FakturApi.setData(Map<String, dynamic> item) {
    return FakturApi(
      fdNoEntryFaktur: item['fdNoEntryFaktur'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdJenisFaktur: item['fdJenisFaktur'] ?? '',
      fdNoFaktur: item['fdNoFaktur'] ?? '',
      fdTanggalFaktur: item['fdTanggalFaktur'] ?? '',
      fdTOP: item['fdTOP'].toString(),
      fdTanggalJT: item['fdTanggalJT'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdFPajak: item['fdFPajak'] ?? '',
      fdPPH: item['fdPPH'].toString(),
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdMataUang: item['fdMataUang'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeAP1: item['fdKodeAP1'] ?? '',
      fdKodeAP2: item['fdKodeAP2'] ?? '',
      fdReasonNotApprove: item['fdReasonNotApprove'] ?? 0,
      fdDisetujuiOleh: item['fdDisetujuiOleh'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? 0,
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdNoOrderSFA: item['fdNoOrderSFA'] ?? '',
      fdTglSFA: item['fdTglSFA'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdCreateUserID: item['fdCreateUserID'] ?? '',
      fdCreateTS: item['fdCreateTS'] ?? '',
      fdUpdateUserID: item['fdUpdateUserID'] ?? '',
      fdUpdateTS: item['fdUpdateTS'] ?? '',
      fdNoEntryLama: item['fdNoEntryLama'] ?? '',
      fdNoUrutFaktur: item['fdNoUrutFaktur'] ?? 0,
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? 0,
      fdNoUrutProforma: item['fdNoUrutProforma'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'] ?? 0,
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdQty: ((item['fdQty'] is num)
          ? (item['fdQty'] as num).toInt()
          : int.tryParse(item['fdQty'].toString()) ?? 0),
      fdQtyK: ((item['fdQtyK'] is num)
          ? (item['fdQtyK'] as num).toInt()
          : int.tryParse(item['fdQtyK'].toString()) ?? 0),
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
      fdDiscountDetail: item['fdDiscountDetail'] ?? '',
      fdNetto: double.tryParse(item['fdNetto'].toString()) != null
          ? item['fdNetto'].toDouble()
          : 0,
      fdDPP: item['fdDPP'] ?? 0,
      fdPPN: item['fdPPN'] ?? 0,
      fdNoPromosi: item['fdNoPromosi'] ?? '',
      fdNamaLangganan: item['fdNamaLangganan'] ?? '',
      tagihan: double.tryParse(item['tagihan'].toString()) != null
          ? item['tagihan'].toDouble()
          : 0,
      tunai: double.tryParse(item['tunai'].toString()) != null
          ? item['tunai'].toDouble()
          : 0,
      giro: double.tryParse(item['giro'].toString()) != null
          ? item['giro'].toDouble()
          : 0,
      cheque: double.tryParse(item['cheque'].toString()) != null
          ? item['cheque'].toDouble()
          : 0,
      transfer: double.tryParse(item['transfer'].toString()) != null
          ? item['transfer'].toDouble()
          : 0,
      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory FakturApi.fromJson(Map<String, dynamic> json) {
    return FakturApi(
        fdNoEntryFaktur: json['fdNoEntryFaktur'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdJenisFaktur: json['fdJenisFaktur'] ?? '',
        fdNoFaktur: json['fdNoFaktur'] ?? '',
        fdTanggalFaktur: json['fdTanggalFaktur'] ?? '',
        fdTOP: json['fdTOP'] ?? '0',
        fdTanggalJT: json['fdTanggalJT'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdNoEntryProforma: json['fdNoEntryProforma'] ?? '',
        fdFPajak: json['fdFPajak'] ?? '',
        fdPPH: json['fdPPH'] ?? '0',
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdMataUang: json['fdMataUang'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeAP1: json['fdKodeAP1'] ?? '',
        fdKodeAP2: json['fdKodeAP2'] ?? '',
        fdReasonNotApprove: json['fdReasonNotApprove'] ?? 0,
        fdDisetujuiOleh: json['fdDisetujuiOleh'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? 0,
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdNoOrderSFA: json['fdNoOrderSFA'] ?? '',
        fdTglSFA: json['fdTglSFA'] ?? '',
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdCreateUserID: json['fdCreateUserID'] ?? '',
        fdCreateTS: json['fdCreateTS'] ?? '',
        fdUpdateUserID: json['fdUpdateUserID'] ?? '',
        fdUpdateTS: json['fdUpdateTS'] ?? '',
        fdNoEntryLama: json['fdNoEntryLama'] ?? '',
        fdNoUrutFaktur: json['fdNoUrutFaktur'] ?? 0,
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdNoUrutSJ: json['fdNoUrutSJ'] ?? 0,
        fdNoUrutProforma: json['fdNoUrutProforma'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'] ?? 0,
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
        fdDiscountDetail: json['fdDiscountDetail'] ?? '',
        fdNetto: double.tryParse(json['fdNetto'].toString()) != null
            ? json['fdNetto'].toDouble()
            : 0,
        fdDPP: json['fdDPP'] ?? 0,
        fdPPN: json['fdPPN'] ?? 0,
        fdNoPromosi: json['fdNoPromosi'] ?? '',
        fdNamaLangganan: json['fdNamaLangganan'] ?? '',
        tagihan: double.tryParse(json['tagihan'].toString()) != null
            ? json['tagihan'].toDouble()
            : 0,
        tunai: double.tryParse(json['tunai'].toString()) != null
            ? json['tunai'].toDouble()
            : 0,
        giro: double.tryParse(json['giro'].toString()) != null
            ? json['giro'].toDouble()
            : 0,
        cheque: double.tryParse(json['cheque'].toString()) != null
            ? json['cheque'].toDouble()
            : 0,
        transfer: double.tryParse(json['transfer'].toString()) != null
            ? json['transfer'].toDouble()
            : 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory FakturApi.empty() {
    return FakturApi(
        fdNoEntryFaktur: '',
        fdDepo: '',
        fdJenisFaktur: '',
        fdNoFaktur: '',
        fdTanggalFaktur: '',
        fdTOP: '0',
        fdTanggalJT: '',
        fdKodeLangganan: '',
        fdNoEntryProforma: '',
        fdFPajak: '',
        fdPPH: '0',
        fdKeterangan: '',
        fdMataUang: '',
        fdKodeSF: '',
        fdKodeAP1: '',
        fdKodeAP2: '',
        fdReasonNotApprove: 0,
        fdDisetujuiOleh: '',
        fdKodeStatus: 0,
        fdTglStatus: '',
        fdKodeGudang: '',
        fdNoOrderSFA: '',
        fdTglSFA: '',
        fdStatusRecord: 0,
        fdCreateUserID: '',
        fdCreateTS: '',
        fdUpdateUserID: '',
        fdUpdateTS: '',
        fdNoEntryLama: '',
        fdNoUrutFaktur: 0,
        fdNoEntrySJ: '',
        fdNoUrutSJ: 0,
        fdNoUrutProforma: 0,
        fdKodeBarang: '',
        fdPromosi: '',
        fdReplacement: 0,
        fdJenisSatuan: '',
        fdQty: 0,
        fdQtyK: 0,
        fdUnitPrice: 0,
        fdUnitPriceK: 0,
        fdBrutto: 0,
        fdDiscount: 0,
        fdDiscountDetail: '',
        fdNetto: 0,
        fdDPP: 0,
        fdPPN: 0,
        fdNoPromosi: '',
        fdNamaLangganan: '',
        tagihan: 0,
        tunai: 0,
        giro: 0,
        cheque: 0,
        transfer: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '',
        fdData: '',
        fdMessage: '');
  }
}

Map<String, dynamic> setJsonDataFakturApi(
    String? fdNoEntryFaktur,
    String? fdDepo,
    String? fdJenisFaktur,
    String? fdNoFaktur,
    String? fdTanggalFaktur,
    String? fdTOP,
    String? fdTanggalJT,
    String? fdKodeLangganan,
    String? fdNoEntryProforma,
    String? fdFPajak,
    String? fdPPH,
    String? fdKeterangan,
    String? fdMataUang,
    String? fdKodeSF,
    String? fdKodeAP1,
    String? fdKodeAP2,
    int? fdReasonNotApprove,
    String? fdDisetujuiOleh,
    int? fdKodeStatus,
    String? fdTglStatus,
    String? fdKodeGudang,
    String? fdNoOrderSFA,
    String? fdTglSFA,
    int? fdStatusRecord,
    String? fdCreateUserID,
    String? fdCreateTS,
    String? fdUpdateUserID,
    String? fdUpdateTS,
    String? fdNoEntryLama,
//DETAIL
    int? fdNoUrutFaktur,
    String? fdNoEntrySJ,
    int? fdNoUrutSJ,
    int? fdNoUrutProforma,
    String? fdKodeBarang,
    String? fdPromosi,
    int? fdReplacement,
    String? fdJenisSatuan,
    int fdQty,
    int fdQtyK,
    double fdUnitPrice,
    double fdUnitPriceK,
    double fdBrutto,
    double fdDiscount,
    String? fdDiscountDetail,
    double fdNetto,
    double fdDPP,
    double fdPPN,
    String? fdNoPromosi,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntryFaktur": fdNoEntryFaktur,
    "fdDepo": fdDepo,
    "fdJenisFaktur": fdJenisFaktur,
    "fdNoFaktur": fdNoFaktur,
    "fdTanggalFaktur": fdTanggalFaktur,
    "fdTOP": fdTOP,
    "fdTanggalJT": fdTanggalJT,
    "fdKodeLangganan": fdKodeLangganan,
    "fdNoEntryProforma": fdNoEntryProforma,
    "fdFPajak": fdFPajak,
    "fdPPH": fdPPH,
    "fdKeterangan": fdKeterangan,
    "fdMataUang": fdMataUang,
    "fdKodeSF": fdKodeSF,
    "fdKodeAP1": fdKodeAP1,
    "fdKodeAP2": fdKodeAP2,
    "fdReasonNotApprove": fdReasonNotApprove,
    "fdDisetujuiOleh": fdDisetujuiOleh,
    "fdKodeStatus": fdKodeStatus,
    "fdTglStatus": fdTglStatus,
    "fdKodeGudang": fdKodeGudang,
    "fdNoOrderSFA": fdNoOrderSFA,
    "fdTglSFA": fdTglSFA,
    "fdStatusRecord": fdStatusRecord,
    "fdCreateUserID": fdCreateUserID,
    "fdCreateTS": fdCreateTS,
    "fdUpdateUserID": fdUpdateUserID,
    "fdUpdateTS": fdUpdateTS,
    "fdNoEntryLama": fdNoEntryLama,
    "fdNoUrutFaktur": fdNoUrutFaktur,
    "fdNoEntrySJ": fdNoEntrySJ,
    "fdNoUrutSJ": fdNoUrutSJ,
    "fdNoUrutProforma": fdNoUrutProforma,
    "fdKodeBarang": fdKodeBarang,
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
    "fdDPP": fdDPP,
    "fdPPN": fdPPN,
    "fdNoPromosi": fdNoPromosi,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}

//SJ
class SuratJalanApi {
  //HEADER
  final String? fdNoEntrySJ;
  final String? fdDepo;
  final String? fdJenisSJ;
  final String? fdNoSJ;
  final String? fdTanggalSJ;
  final String? fdKodeLangganan;
  final String? fdKodeSF;
  String? fdKodeAP1;
  String? fdKodeAP2;
  final String? fdKodeGudang;
  String? fdKodeGudangTujuan;
  String? fdNoEntryProforma;
  final String? fdAlamatKirim;
  String? fdKeterangan;
  String? fdNoPolisi;
  String? fdKodeEkspedisi;
  String? fdSupirNama;
  String? fdSupirKTP;
  String? fdArmada;
  String? fdETD;
  String? fdETA;
  String? fdNoContainer;
  String? fdNoSeal;
  String? fdAktTglKirim;
  String? fdAktTglTiba;
  String? fdAktTglSerah;
  String? fdKeteranganPengiriman;
  String? fdIsFaktur;
  String? fdKodeStatus;
  String? fdTglStatus;
  int? fdStatusRecord;
  String? fdKodeStatusGit;
  String? fdTanggalLPB;
  String? fdNoLPB;
  String? fdKeteranganLPB;
  String? fdUserLPB;
  String? fdCreateUserID;
  String? fdCreateTS;
  String? fdUpdateUserID;
  String? fdUpdateTS;
  String? fdNoEntryLama;
  //DETAIL
  final int? fdNoUrutSJ;
  final String? fdNoEntryOrder;
  final int? fdNoUrutOrder;
  int? fdNoUrutProforma;
  final String? fdKodeBarang;
  final String? fdPromosi;
  String? fdReplacement;
  final String? fdJenisSatuan;
  final int? fdQty;
  final int? fdQtyK;
  int? fdPalet;
  String? fdDetailPalet;
  double? fdNetWeight;
  double? fdGrossWeight;
  double? fdVolume;
  String? fdNotes;
  String? fdCartonNo;
  final int? fdQtyJual;
  int? fdRusakB;
  int? fdRusakS;
  int? fdRusakK;
  int? fdSisaB;
  int? fdSisaS;
  int? fdSisaK;

  int? fdStatusSent;
  String? fdLastUpdate;
  String? message;
  bool? isCheck = false;
  String? fdData;
  String? fdMessage;

  SuratJalanApi(
      {required this.fdNoEntrySJ,
      required this.fdDepo,
      required this.fdJenisSJ,
      required this.fdNoSJ,
      required this.fdTanggalSJ,
      required this.fdKodeLangganan,
      required this.fdKodeSF,
      this.fdKodeAP1,
      this.fdKodeAP2,
      required this.fdKodeGudang,
      this.fdKodeGudangTujuan,
      this.fdNoEntryProforma,
      required this.fdAlamatKirim,
      this.fdKeterangan,
      this.fdNoPolisi,
      this.fdKodeEkspedisi,
      this.fdSupirNama,
      this.fdSupirKTP,
      this.fdArmada,
      this.fdETD,
      this.fdETA,
      this.fdNoContainer,
      this.fdNoSeal,
      this.fdAktTglKirim,
      this.fdAktTglTiba,
      this.fdAktTglSerah,
      this.fdKeteranganPengiriman,
      this.fdIsFaktur,
      this.fdKodeStatus,
      this.fdTglStatus,
      this.fdStatusRecord,
      this.fdKodeStatusGit,
      this.fdTanggalLPB,
      this.fdNoLPB,
      this.fdKeteranganLPB,
      this.fdUserLPB,
      this.fdCreateUserID,
      this.fdCreateTS,
      this.fdUpdateUserID,
      this.fdUpdateTS,
      this.fdNoEntryLama,
      //DETAIL
      required this.fdNoUrutSJ,
      required this.fdNoEntryOrder,
      required this.fdNoUrutOrder,
      this.fdNoUrutProforma,
      required this.fdKodeBarang,
      required this.fdPromosi,
      this.fdReplacement,
      required this.fdJenisSatuan,
      required this.fdQty,
      required this.fdQtyK,
      this.fdPalet,
      this.fdDetailPalet,
      this.fdNetWeight,
      this.fdGrossWeight,
      this.fdVolume,
      this.fdNotes,
      this.fdCartonNo,
      required this.fdQtyJual,
      this.fdRusakB,
      this.fdRusakS,
      this.fdRusakK,
      this.fdSisaB,
      this.fdSisaS,
      this.fdSisaK,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.message,
      this.fdData,
      this.fdMessage});

  factory SuratJalanApi.setData(Map<String, dynamic> item) {
    return SuratJalanApi(
      fdNoEntrySJ: item['fdNoEntrySJ'] ?? '',
      fdDepo: item['fdDepo'] ?? '',
      fdJenisSJ: item['fdJenisSJ'] ?? '',
      fdNoSJ: item['fdNoSJ'] ?? '',
      fdTanggalSJ: item['fdTanggalSJ'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeSF: item['fdKodeSF'] ?? '',
      fdKodeAP1: item['fdKodeAP1'] ?? '',
      fdKodeAP2: item['fdKodeAP2'] ?? '',
      fdKodeGudang: item['fdKodeGudang'] ?? '',
      fdKodeGudangTujuan: item['fdKodeGudangTujuan'] ?? '',
      fdNoEntryProforma: item['fdNoEntryProforma'] ?? '',
      fdAlamatKirim: item['fdAlamatKirim'] ?? '',
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdNoPolisi: item['fdNoPolisi'] ?? '',
      fdKodeEkspedisi: item['fdKodeEkspedisi'] ?? '',
      fdSupirNama: item['fdSupirNama'] ?? '',
      fdSupirKTP: item['fdSupirKTP'] ?? '',
      fdArmada: item['fdArmada'] ?? '',
      fdETD: item['fdETD'] ?? '',
      fdETA: item['fdETA'] ?? '',
      fdNoContainer: item['fdNoContainer'] ?? '',
      fdNoSeal: item['fdNoSeal'] ?? '',
      fdAktTglKirim: item['fdAktTglKirim'] ?? '',
      fdAktTglTiba: item['fdAktTglTiba'] ?? '',
      fdAktTglSerah: item['fdAktTglSerah'] ?? '',
      fdKeteranganPengiriman: item['fdKeteranganPengiriman'] ?? '',
      fdIsFaktur: item['fdIsFaktur'] ?? '',
      fdKodeStatus: item['fdKodeStatus'] ?? '',
      fdTglStatus: item['fdTglStatus'] ?? '',
      fdStatusRecord: item['fdStatusRecord'] ?? 0,
      fdKodeStatusGit: item['fdKodeStatusGit'] ?? '',
      fdTanggalLPB: item['fdTanggalLPB'] ?? '',
      fdNoLPB: item['fdNoLPB'] ?? '',
      fdKeteranganLPB: item['fdKeteranganLPB'] ?? '',
      fdUserLPB: item['fdUserLPB'] ?? '',
      fdCreateUserID: item['fdCreateUserID'] ?? '',
      fdCreateTS: item['fdCreateTS'] ?? '',
      fdUpdateUserID: item['fdUpdateUserID'] ?? '',
      fdUpdateTS: item['fdUpdateTS'] ?? '',
      fdNoEntryLama: item['fdNoEntryLama'] ?? '',
      //DETAIL
      fdNoUrutSJ: item['fdNoUrutSJ'] ?? 0,
      fdNoEntryOrder: item['fdNoEntryOrder'] ?? '',
      fdNoUrutOrder: item['fdNoUrutOrder'] ?? 0,
      fdNoUrutProforma: item['fdNoUrutProforma'] ?? 0,
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdPromosi: item['fdPromosi'] ?? '',
      fdReplacement: item['fdReplacement'].toString(),
      fdJenisSatuan: item['fdJenisSatuan'] ?? '',
      fdQty: ((item['fdQty'] is num)
          ? (item['fdQty'] as num).toInt()
          : int.tryParse(item['fdQty'].toString()) ?? 0),
      fdQtyK: ((item['fdQtyK'] is num)
          ? (item['fdQtyK'] as num).toInt()
          : int.tryParse(item['fdQtyK'].toString()) ?? 0),
      fdPalet: ((item['fdPalet'] is num)
          ? (item['fdPalet'] as num).toInt()
          : int.tryParse(item['fdPalet'].toString()) ?? 0),
      fdDetailPalet: item['fdDetailPalet'] ?? '',
      fdNetWeight: item['fdNetWeight'] ?? 0,
      fdGrossWeight: item['fdGrossWeight'] ?? 0,
      fdVolume: item['fdVolume'] ?? 0,
      fdNotes: item['fdNotes'] ?? '',
      fdCartonNo: item['fdCartonNo'] ?? '',
      fdQtyJual: ((item['fdQtyJual'] is num)
          ? (item['fdQtyJual'] as num).toInt()
          : int.tryParse(item['fdQtyJual'].toString()) ?? 0),
      fdRusakB: ((item['fdRusakB'] is num)
          ? (item['fdRusakB'] as num).toInt()
          : int.tryParse(item['fdRusakB'].toString()) ?? 0),
      fdRusakS: ((item['fdRusakS'] is num)
          ? (item['fdRusakS'] as num).toInt()
          : int.tryParse(item['fdRusakS'].toString()) ?? 0),
      fdRusakK: ((item['fdRusakK'] is num)
          ? (item['fdRusakK'] as num).toInt()
          : int.tryParse(item['fdRusakK'].toString()) ?? 0),
      fdSisaB: ((item['fdSisaB'] is num)
          ? (item['fdSisaB'] as num).toInt()
          : int.tryParse(item['fdSisaB'].toString()) ?? 0),
      fdSisaS: ((item['fdSisaS'] is num)
          ? (item['fdSisaS'] as num).toInt()
          : int.tryParse(item['fdSisaS'].toString()) ?? 0),
      fdSisaK: ((item['fdSisaK'] is num)
          ? (item['fdSisaK'] as num).toInt()
          : int.tryParse(item['fdSisaK'].toString()) ?? 0),

      fdStatusSent: item['fdStatusSent'] ?? 0,
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory SuratJalanApi.fromJson(Map<String, dynamic> json) {
    return SuratJalanApi(
        fdNoEntrySJ: json['fdNoEntrySJ'] ?? '',
        fdDepo: json['fdDepo'] ?? '',
        fdJenisSJ: json['fdJenisSJ'] ?? '',
        fdNoSJ: json['fdNoSJ'] ?? '',
        fdTanggalSJ: json['fdTanggalSJ'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeSF: json['fdKodeSF'] ?? '',
        fdKodeAP1: json['fdKodeAP1'] ?? '',
        fdKodeAP2: json['fdKodeAP2'] ?? '',
        fdKodeGudang: json['fdKodeGudang'] ?? '',
        fdKodeGudangTujuan: json['fdKodeGudangTujuan'] ?? '',
        fdNoEntryProforma: json['fdNoEntryProforma'] ?? '',
        fdAlamatKirim: json['fdAlamatKirim'] ?? '',
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdNoPolisi: json['fdNoPolisi'] ?? '',
        fdKodeEkspedisi: json['fdKodeEkspedisi'] ?? '',
        fdSupirNama: json['fdSupirNama'] ?? '',
        fdSupirKTP: json['fdSupirKTP'] ?? '',
        fdArmada: json['fdArmada'] ?? '',
        fdETD: json['fdETD'] ?? '',
        fdETA: json['fdETA'] ?? '',
        fdNoContainer: json['fdNoContainer'] ?? '',
        fdNoSeal: json['fdNoSeal'] ?? '',
        fdAktTglKirim: json['fdAktTglKirim'] ?? '',
        fdAktTglTiba: json['fdAktTglTiba'] ?? '',
        fdAktTglSerah: json['fdAktTglSerah'] ?? '',
        fdKeteranganPengiriman: json['fdKeteranganPengiriman'] ?? '',
        fdIsFaktur: json['fdIsFaktur'] ?? '',
        fdKodeStatus: json['fdKodeStatus'] ?? '',
        fdTglStatus: json['fdTglStatus'] ?? '',
        fdStatusRecord: json['fdStatusRecord'] ?? 0,
        fdKodeStatusGit: json['fdKodeStatusGit'] ?? '',
        fdTanggalLPB: json['fdTanggalLPB'] ?? '',
        fdNoLPB: json['fdNoLPB'] ?? '',
        fdKeteranganLPB: json['fdKeteranganLPB'] ?? '',
        fdUserLPB: json['fdUserLPB'] ?? '',
        fdCreateUserID: json['fdCreateUserID'] ?? '',
        fdCreateTS: json['fdCreateTS'] ?? '',
        fdUpdateUserID: json['fdUpdateUserID'] ?? '',
        fdUpdateTS: json['fdUpdateTS'] ?? '',
        fdNoEntryLama: json['fdNoEntryLama'] ?? '',
        //DETAIL
        fdNoUrutSJ: json['fdNoUrutSJ'] ?? 0,
        fdNoEntryOrder: json['fdNoEntryOrder'] ?? '',
        fdNoUrutOrder: json['fdNoUrutOrder'] ?? 0,
        fdNoUrutProforma: json['fdNoUrutProforma'] ?? 0,
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdPromosi: json['fdPromosi'] ?? '',
        fdReplacement: json['fdReplacement'].toString(),
        fdJenisSatuan: json['fdJenisSatuan'] ?? '',
        fdQty: ((json['fdQty'] is num)
            ? (json['fdQty'] as num).toInt()
            : int.tryParse(json['fdQty'].toString()) ?? 0),
        fdQtyK: ((json['fdQtyK'] is num)
            ? (json['fdQtyK'] as num).toInt()
            : int.tryParse(json['fdQtyK'].toString()) ?? 0),
        fdPalet: ((json['fdPalet'] is num)
            ? (json['fdPalet'] as num).toInt()
            : int.tryParse(json['fdPalet'].toString()) ?? 0),
        fdDetailPalet: json['fdDetailPalet'] ?? '',
        fdNetWeight: json['fdNetWeight'] ?? 0,
        fdGrossWeight: json['fdGrossWeight'] ?? 0,
        fdVolume: json['fdVolume'] ?? 0,
        fdNotes: json['fdNotes'] ?? '',
        fdCartonNo: json['fdCartonNo'] ?? '',
        fdQtyJual: ((json['fdQtyJual'] is num)
            ? (json['fdQtyJual'] as num).toInt()
            : int.tryParse(json['fdQtyJual'].toString()) ?? 0),
        fdRusakB: ((json['fdRusakB'] is num)
            ? (json['fdRusakB'] as num).toInt()
            : int.tryParse(json['fdRusakB'].toString()) ?? 0),
        fdRusakS: ((json['fdRusakS'] is num)
            ? (json['fdRusakS'] as num).toInt()
            : int.tryParse(json['fdRusakS'].toString()) ?? 0),
        fdRusakK: ((json['fdRusakK'] is num)
            ? (json['fdRusakK'] as num).toInt()
            : int.tryParse(json['fdRusakK'].toString()) ?? 0),
        fdSisaB: ((json['fdSisaB'] is num)
            ? (json['fdSisaB'] as num).toInt()
            : int.tryParse(json['fdSisaB'].toString()) ?? 0),
        fdSisaS: ((json['fdSisaS'] is num)
            ? (json['fdSisaS'] as num).toInt()
            : int.tryParse(json['fdSisaS'].toString()) ?? 0),
        fdSisaK: ((json['fdSisaK'] is num)
            ? (json['fdSisaK'] as num).toInt()
            : int.tryParse(json['fdSisaK'].toString()) ?? 0),
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        message: json['message'] ?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory SuratJalanApi.empty() {
    return SuratJalanApi(
        fdNoEntrySJ: '',
        fdDepo: '',
        fdJenisSJ: '',
        fdNoSJ: '',
        fdTanggalSJ: '',
        fdKodeLangganan: '',
        fdKodeSF: '',
        fdKodeAP1: '',
        fdKodeAP2: '',
        fdKodeGudang: '',
        fdKodeGudangTujuan: '',
        fdNoEntryProforma: '',
        fdAlamatKirim: '',
        fdKeterangan: '',
        fdNoPolisi: '',
        fdKodeEkspedisi: '',
        fdSupirNama: '',
        fdSupirKTP: '',
        fdArmada: '',
        fdETD: '',
        fdETA: '',
        fdNoContainer: '',
        fdNoSeal: '',
        fdAktTglKirim: '',
        fdAktTglTiba: '',
        fdAktTglSerah: '',
        fdKeteranganPengiriman: '',
        fdIsFaktur: '',
        fdKodeStatus: '',
        fdTglStatus: '',
        fdStatusRecord: 0,
        fdKodeStatusGit: '',
        fdTanggalLPB: '',
        fdNoLPB: '',
        fdKeteranganLPB: '',
        fdUserLPB: '',
        fdCreateUserID: '',
        fdCreateTS: '',
        fdUpdateUserID: '',
        fdUpdateTS: '',
        fdNoEntryLama: '',
//DETAIL
        fdNoUrutSJ: 0,
        fdNoEntryOrder: '',
        fdNoUrutOrder: 0,
        fdNoUrutProforma: 0,
        fdKodeBarang: '',
        fdPromosi: '',
        fdReplacement: '0',
        fdJenisSatuan: '',
        fdQty: 0,
        fdQtyK: 0,
        fdPalet: 0,
        fdDetailPalet: '',
        fdNetWeight: 0,
        fdGrossWeight: 0,
        fdVolume: 0,
        fdNotes: '',
        fdCartonNo: '',
        fdQtyJual: 0,
        fdRusakB: 0,
        fdRusakS: 0,
        fdRusakK: 0,
        fdSisaB: 0,
        fdSisaS: 0,
        fdSisaK: 0,
        fdStatusSent: 0,
        fdLastUpdate: '',
        message: '',
        fdData: '',
        fdMessage: '');
  }
}

Map<String, dynamic> setJsonDataSuratJalanApi(
    String? fdNoEntrySJ,
    String? fdDepo,
    String? fdJenisSJ,
    String? fdNoSJ,
    String? fdTanggalSJ,
    String? fdKodeLangganan,
    String? fdKodeSF,
    String? fdKodeAP1,
    String? fdKodeAP2,
    String? fdKodeGudang,
    String? fdKodeGudangTujuan,
    String? fdNoEntryProforma,
    String? fdAlamatKirim,
    String? fdKeterangan,
    String? fdNoPolisi,
    String? fdKodeEkspedisi,
    String? fdSupirNama,
    String? fdSupirKTP,
    String? fdArmada,
    String? fdETD,
    String? fdETA,
    String? fdNoContainer,
    String? fdNoSeal,
    String? fdAktTglKirim,
    String? fdAktTglTiba,
    String? fdAktTglSerah,
    String? fdKeteranganPengiriman,
    String? fdIsFaktur,
    String? fdKodeStatus,
    String? fdTglStatus,
    int? fdStatusRecord,
    String? fdKodeStatusGit,
    String? fdTanggalLPB,
    String? fdNoLPB,
    String? fdKeteranganLPB,
    String? fdUserLPB,
    String? fdCreateUserID,
    String? fdCreateTS,
    String? fdUpdateUserID,
    String? fdUpdateTS,
    String? fdNoEntryLama,
    //DETAIL
    int? fdNoUrutSJ,
    String? fdNoEntryOrder,
    int? fdNoUrutOrder,
    int? fdNoUrutProforma,
    String? fdKodeBarang,
    String? fdPromosi,
    String? fdReplacement,
    String? fdJenisSatuan,
    int? fdQty,
    int? fdQtyK,
    int? fdPalet,
    String? fdDetailPalet,
    double? fdNetWeight,
    double? fdGrossWeight,
    double? fdVolume,
    String? fdNotes,
    String? fdCartonNo,
    int? fdQtyJual,
    int? fdRusakB,
    int? fdRusakS,
    int? fdRusakK,
    int? fdSisaB,
    int? fdSisaS,
    int? fdSisaK,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntrySJ": fdNoEntrySJ,
    "fdDepo": fdDepo,
    "fdJenisSJ": fdJenisSJ,
    "fdNoSJ": fdNoSJ,
    "fdTanggalSJ": fdTanggalSJ,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeSF": fdKodeSF,
    "fdKodeAP1": fdKodeAP1,
    "fdKodeAP2": fdKodeAP2,
    "fdKodeGudang": fdKodeGudang,
    "fdKodeGudangTujuan": fdKodeGudangTujuan,
    "fdNoEntryProforma": fdNoEntryProforma,
    "fdAlamatKirim": fdAlamatKirim,
    "fdKeterangan": fdKeterangan,
    "fdNoPolisi": fdNoPolisi,
    "fdKodeEkspedisi": fdKodeEkspedisi,
    "fdSupirNama": fdSupirNama,
    "fdSupirKTP": fdSupirKTP,
    "fdArmada": fdArmada,
    "fdETD": fdETD,
    "fdETA": fdETA,
    "fdNoContainer": fdNoContainer,
    "fdNoSeal": fdNoSeal,
    "fdAktTglKirim": fdAktTglKirim,
    "fdAktTglTiba": fdAktTglTiba,
    "fdAktTglSerah": fdAktTglSerah,
    "fdKeteranganPengiriman": fdKeteranganPengiriman,
    "fdIsFaktur": fdIsFaktur,
    "fdKodeStatus": fdKodeStatus,
    "fdTglStatus": fdTglStatus,
    "fdStatusRecord": fdStatusRecord,
    "fdKodeStatusGit": fdKodeStatusGit,
    "fdTanggalLPB": fdTanggalLPB,
    "fdNoLPB": fdNoLPB,
    "fdKeteranganLPB": fdKeteranganLPB,
    "fdUserLPB": fdUserLPB,
    "fdCreateUserID": fdCreateUserID,
    "fdCreateTS": fdCreateTS,
    "fdUpdateUserID": fdUpdateUserID,
    "fdUpdateTS": fdUpdateTS,
    "fdNoEntryLama": fdNoEntryLama,
    //DETAIL
    "fdNoUrutSJ": fdNoUrutSJ,
    "fdNoEntryOrder": fdNoEntryOrder,
    "fdNoUrutOrder": fdNoUrutOrder,
    "fdNoUrutProforma": fdNoUrutProforma,
    "fdKodeBarang": fdKodeBarang,
    "fdPromosi": fdPromosi,
    "fdReplacement": fdReplacement,
    "fdJenisSatuan": fdJenisSatuan,
    "fdQty": fdQty,
    "fdQtyK": fdQtyK,
    "fdPalet": fdPalet,
    "fdDetailPalet": fdDetailPalet,
    "fdNetWeight": fdNetWeight,
    "fdGrossWeight": fdGrossWeight,
    "fdVolume": fdVolume,
    "fdNotes": fdNotes,
    "fdCartonNo": fdCartonNo,
    "fdQtyJual": fdQtyJual,
    "fdRusakB": fdRusakB,
    "fdRusakS": fdRusakS,
    "fdRusakK": fdRusakK,
    "fdSisaB": fdSisaB,
    "fdSisaS": fdSisaS,
    "fdSisaK": fdSisaK,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}
