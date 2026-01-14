class CollectionDetail {
  int fdId;
  String fdNoEntryFaktur;
  String fdTipe;
  String fdKodeLangganan;
  String fdTanggal;
  double fdTotalCollection;
  String fdNoRekeningAsal;
  String fdFromBank;
  String fdToBank;
  String fdNoCollection;
  String fdTanggalCollection;
  String fdDueDateCollection;
  String fdTanggalTerima;
  String fdBuktiImg;
  double fdAllocationAmount = 0;
  int? fdStatusSent;
  String? fdLastUpdate;
  String? fdData;
  String? fdMessage;

  CollectionDetail(
      {required this.fdId,
      required this.fdNoEntryFaktur,
      required this.fdTipe,
      required this.fdKodeLangganan,
      required this.fdTanggal,
      required this.fdTotalCollection,
      this.fdNoRekeningAsal = '',
      required this.fdFromBank,
      required this.fdToBank,
      required this.fdNoCollection,
      required this.fdTanggalCollection,
      required this.fdDueDateCollection,
      required this.fdTanggalTerima,
      this.fdBuktiImg = '',
      this.fdAllocationAmount = 0,
      this.fdStatusSent,
      this.fdLastUpdate,
      this.fdData,
      this.fdMessage});

  factory CollectionDetail.fromJson(Map<String, dynamic> json) {
    return CollectionDetail(
        fdId: json['fdId'] ?? 0,
        fdNoEntryFaktur: json['fdNoEntryFaktur'] ?? '',
        fdTipe: json['fdTipe'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdTanggal: json['fdTanggal'] ?? '',
        fdTotalCollection:
            double.tryParse(json['fdTotalCollection'].toString()) != null
                ? json['fdTotalCollection'].toDouble()
                : 0,
        fdNoRekeningAsal: json['fdNoRekeningAsal'] ?? '',
        fdFromBank: json['fdFromBank'] ?? '',
        fdToBank: json['fdToBank'] ?? '',
        fdNoCollection: json['fdNoCollection'] ?? '',
        fdTanggalCollection: json['fdTanggalCollection'] ?? '',
        fdDueDateCollection: json['fdDueDateCollection'] ?? '',
        fdTanggalTerima: json['fdTanggalTerima'] ?? '',
        fdBuktiImg: json['fdBuktiImg'] ?? '',
        fdAllocationAmount:
            double.tryParse(json['fdAllocationAmount'].toString()) != null
                ? json['fdAllocationAmount'].toDouble()
                : 0,
        fdStatusSent: json['fdStatusSent'] ?? 0,
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        fdData: json['FdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }

  factory CollectionDetail.setData(Map<String, dynamic> json) {
    return CollectionDetail(
      fdId: json['fdId'] ?? 0,
      fdNoEntryFaktur: json['fdNoEntryFaktur'] ?? '',
      fdTipe: json['fdTipe'] ?? '',
      fdKodeLangganan: json['fdKodeLangganan'] ?? '',
      fdTanggal: json['fdTanggal'] ?? '',
      fdTotalCollection: json['fdTotalCollection'] ?? 0,
      fdNoRekeningAsal: json['fdNoRekeningAsal'] ?? '',
      fdFromBank: json['fdFromBank'] ?? '',
      fdToBank: json['fdToBank'] ?? '',
      fdNoCollection: json['fdNoCollection'] ?? '',
      fdTanggalCollection: json['fdTanggalCollection'] ?? '',
      fdDueDateCollection: json['fdDueDateCollection'] ?? '',
      fdTanggalTerima: json['fdTanggalTerima'] ?? '',
      fdBuktiImg: json['fdBuktiImg'] ?? '',
      fdAllocationAmount: json['fdAllocationAmount'] ?? 0,
      fdStatusSent: json['fdStatusSent'] ?? 0,
      fdLastUpdate: json['fdLastUpdate'] ?? '',
    );
  }
}

Map<String, dynamic> setJsonDataCollectionApi(
    String fdNoEntryFaktur,
    String fdIdCollection,
    String fdTipe,
    String fdKodeLangganan,
    String fdTanggal,
    double fdTotalCollection,
    String fdNoRekeningAsal,
    String fdFromBank,
    String fdToBank,
    String fdNoCollection,
    String fdTanggalCollection,
    String fdDueDateCollection,
    String fdTanggalTerima,
    String fdBuktiImg,
    double fdAllocationAmount,
    int? fdStatusSent,
    String? fdLastUpdate) {
  return <String, dynamic>{
    "fdNoEntryFaktur": fdNoEntryFaktur,
    "fdIdCollection": fdIdCollection,
    "fdTipe": fdTipe,
    "fdKodeLangganan": fdKodeLangganan,
    "fdTanggal": fdTanggal,
    "fdTotalCollection": fdTotalCollection,
    "fdNoRekeningAsal": fdNoRekeningAsal,
    "fdFromBank": fdFromBank,
    "fdToBank": fdToBank,
    "fdNoCollection": fdNoCollection,
    "fdTanggalCollection": fdTanggalCollection,
    "fdDueDateCollection": fdDueDateCollection,
    "fdTanggalTerima": fdTanggalTerima,
    "fdBuktiImg": fdBuktiImg,
    "fdAllocationAmount": fdAllocationAmount,
    "fdStatusSent": fdStatusSent,
    "fdLastUpdate": fdLastUpdate
  };
}
