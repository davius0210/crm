class PKM {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final int fdPKM;
  final String fdLastUpdate;
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  PKM({required this.fdKodeSF, required this.fdKodeLangganan, required this.fdTransDate, required this.fdKodeBarang,
    required this.fdNamaBarang, required this.fdPKM, required this.fdStatusSent, required this.fdLastUpdate,
    this.fdData, this.fdMessage});

  factory PKM.setData(Map<String, dynamic> item) {
    return PKM(
      fdKodeSF: item['fdKodeSF']?? '',
      fdKodeLangganan: item['fdKodeLangganan']?? '',
      fdTransDate: item['fdTransDate']?? '',
      fdKodeBarang: item['fdKodeBarang']?? '',
      fdNamaBarang: item['fdNamaBarang']?? '',
      fdPKM: item['fdPKM'].toInt()?? 0,
      fdStatusSent: item['fdStatusSent'].toInt()?? 0,
      fdLastUpdate: item['fdLastUpdate']?? ''
    );
  }

  factory PKM.fromJson(Map<String, dynamic> json) {
    return PKM(
      fdKodeSF: json['fdKodeSF']?? '',
      fdKodeLangganan: json['fdKodeLangganan']?? '',
      fdTransDate: json['fdTransDate']?? '',
      fdKodeBarang: json['fdKodeBarang']?? '',
      fdNamaBarang: json['fdNamaBarang']?? '',
      fdPKM: json['fdPKM'] != null? json['fdPKM'].toInt() : 0,
      fdStatusSent: json['fdStatusSent'] != null? json['fdStatusSent'].toInt() : 0,
      fdLastUpdate: json['fdLastUpdate']?? '',
      fdData: json['fdData']?? '',
      fdMessage: json['fdMessage']?? ''
    );
  }
}

Map<String, dynamic> setJsonData(String fdKodeSF, String fdKodeLangganan, String fdTransDate, String fdKodeBarang, 
  int fdPKM, String fdLastUpdate) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeBarang": fdKodeBarang,
    "fdTransDate": fdTransDate,
    "fdPKM": fdPKM,
    'fdLastUpdate': fdLastUpdate
  };
}