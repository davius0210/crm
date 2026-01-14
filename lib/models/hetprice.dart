class HetPrice {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final String fdPriceCard;
  final String fdKompFlag;
  final String fdNamaKompFlag;
  final int fdPrice;
  final String fdLastUpdate;
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  HetPrice({required this.fdKodeSF, required this.fdKodeLangganan, required this.fdTransDate, required this.fdKodeBarang,
    required this.fdNamaBarang, required this.fdPriceCard, required this.fdPrice, required this.fdStatusSent, 
    required this.fdKompFlag, required this.fdNamaKompFlag, required this.fdLastUpdate, this.fdData, this.fdMessage});

  factory HetPrice.setData(Map<String, dynamic> item) {
    return HetPrice(
      fdKodeSF: item['fdKodeSF']?? '',
      fdKodeLangganan: item['fdKodeLangganan']?? '',
      fdTransDate: item['fdTransDate']?? '',
      fdKodeBarang: item['fdKodeBarang']?? '',
      fdNamaBarang: item['fdNamaBarang']?? '',
      fdPriceCard: item['fdPriceCard']?? '',
      fdKompFlag: item['fdKompFlag']?? '',
      fdNamaKompFlag: item['fdNamaKompFlag']?? '',
      fdPrice: item['fdPrice'].toInt()?? 0,
      fdStatusSent: item['fdStatusSent'].toInt()?? 0,
      fdLastUpdate: item['fdLastUpdate']?? ''
    );
  }

  factory HetPrice.fromJson(Map<String, dynamic> json) {
    return HetPrice(
      fdKodeSF: json['fdKodeSF']?? '',
      fdKodeLangganan: json['fdKodeLangganan']?? '',
      fdTransDate: json['fdTransDate']?? '',
      fdKodeBarang: json['fdKodeBarang']?? '',
      fdNamaBarang: json['fdNamaBarang']?? '',
      fdPriceCard: json['fdPriceCard']?? '',
      fdKompFlag: json['fdKompFlag']?? '',
      fdNamaKompFlag: json['fdNamaKompFlag']?? '',
      fdPrice: json['fdPrice'] != null? json['fdPrice'].toInt() : 0,
      fdStatusSent: json['fdStatusSent'] != null? json['fdStatusSent'].toInt() : 0,
      fdLastUpdate: json['fdLastUpdate']?? '',
      fdData: json['fdData']?? '',
      fdMessage: json['fdMessage']?? ''
    );
  }
}

Map<String, dynamic> setJsonData(String fdKodeSF, String fdKodeLangganan, String fdTransDate, String fdKodeBarang, 
  String fdPriceCard, int fdPrice, String fdLastUpdate) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeBarang": fdKodeBarang,
    "fdTransDate": fdTransDate,
    "fdPriceCard": fdPriceCard,
    "fdPrice": fdPrice,
    'fdLastUpdate': fdLastUpdate
  };
}