class SellOut {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final String fdKompFlag;
  final String fdNamaKompFlag;
  final int fdSellOut;
  final String fdLastUpdate;
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  SellOut({required this.fdKodeSF, required this.fdKodeLangganan, required this.fdTransDate, required this.fdKodeBarang,
    required this.fdNamaBarang, required this.fdStartDate, required this.fdEndDate, required this.fdSellOut, 
    required this.fdKompFlag, required this.fdNamaKompFlag, required this.fdStatusSent, this.fdData, this.fdMessage,
    required this.fdLastUpdate});

  factory SellOut.setData(Map<String, dynamic> item) {
    return SellOut(
      fdKodeSF: item['fdKodeSF']?? '',
      fdKodeLangganan: item['fdKodeLangganan']?? '',
      fdTransDate: item['fdTransDate']?? '',
      fdStartDate: item['fdStartDate']?? '',
      fdEndDate: item['fdEndDate']?? '',
      fdKodeBarang: item['fdKodeBarang']?? '',
      fdNamaBarang: item['fdNamaBarang']?? '',
      fdKompFlag: item['fdKompFlag']?? '',
      fdNamaKompFlag: item['fdNamaKompFlag']?? '',
      fdSellOut: item['fdSellOut'].toInt()?? 0,
      fdStatusSent: item['fdStatusSent'].toInt()?? 0,
      fdLastUpdate: item['fdLastUpdate']?? ''
    );
  }

  factory SellOut.fromJson(Map<String, dynamic> json) {
    return SellOut(
      fdKodeSF: json['fdKodeSF']?? '',
      fdKodeLangganan: json['fdKodeLangganan']?? '',
      fdTransDate: json['fdTransDate']?? '',
      fdStartDate: json['fdStartDate']?? '',
      fdEndDate: json['fdEndDate']?? '',
      fdKodeBarang: json['fdKodeBarang']?? '',
      fdNamaBarang: json['fdNamaBarang']?? '',
      fdKompFlag: json['fdKompFlag']?? '',
      fdNamaKompFlag: json['fdNamaKompFlag']?? '',
      fdSellOut: json['fdSellOut'] != null? json['fdPKM'].toInt() : 0,
      fdStatusSent: json['fdStatusSent'] != null? json['fdStatusSent'].toInt() : 0,
      fdLastUpdate: json['fdLastUpdate']?? '',
      fdData: json['fdData']?? '',
      fdMessage: json['fdMessage']?? ''
    );
  }
}

Map<String, dynamic> setJsonData(String fdKodeSF, String fdKodeLangganan, String fdTransDate, String fdKodeBarang, 
  String fdStartDate, String fdEndDate, int fdSellOut, List<String> listPhoto, String fdLastUpdate) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeBarang": fdKodeBarang,
    "fdTransDate": fdTransDate,
    "fdStartDate": fdStartDate,
    "fdEndDate": fdEndDate,
    "fdSellOut": fdSellOut,
    'fdLastUpdate': fdLastUpdate,
    'detailPhoto': listPhoto
  };
}