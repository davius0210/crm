class DisplaySewaKomp {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdJenisSewa;
  final String fdKodeRakDisplay;
  final String fdRakDescription;
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeGroupBarang;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final String fdKeterangan;
  final String fdLastUpdate;
  bool isCheck = true;
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  DisplaySewaKomp({required this.fdKodeSF, required this.fdKodeLangganan, required this.fdTransDate, required this.fdJenisSewa,
    required this.fdKodeRakDisplay, required this.fdRakDescription, required this.fdStartDate, required this.fdEndDate, 
    required this.fdKodeBarang, required this.fdNamaBarang, required this.fdKeterangan, required this.fdStatusSent,
    required this.isCheck, required this.fdLastUpdate, required this.fdKodeGroupBarang, this.fdData, this.fdMessage});

  factory DisplaySewaKomp.setData(Map<String, dynamic> item) {
    return DisplaySewaKomp(
      fdKodeSF: item['fdKodeSF']?? '',
      fdKodeLangganan: item['fdKodeLangganan']?? '',
      fdTransDate: item['fdTransDate']?? '',
      fdJenisSewa: item['fdJenisSewa']?? '',
      fdStartDate: item['fdStartDate']?? '',
      fdEndDate: item['fdEndDate']?? '',
      fdKodeGroupBarang: item['fdKodeGroupBarang']?? '',
      fdKodeBarang: item['fdKodeBarang']?? '',
      fdNamaBarang: item['fdNamaBarang']?? '',
      fdKodeRakDisplay: item['fdKodeRakDisplay']?? '',
      fdRakDescription: item['fdRakDescription']?? '',
      fdKeterangan: item['fdKeterangan']?? '',
      fdStatusSent: item['fdStatusSent'].toInt()?? 0,
      isCheck: item['isCheck']?? true,
      fdLastUpdate: item['fdLastUpdate']?? ''
    );
  }

  factory DisplaySewaKomp.fromJson(Map<String, dynamic> json) {
    return DisplaySewaKomp(
      fdKodeSF: json['fdKodeSF']?? '',
      fdKodeLangganan: json['fdKodeLangganan']?? '',
      fdTransDate: json['fdTransDate']?? '',
      fdJenisSewa: json['fdJenisSewa']?? '',
      fdStartDate: json['fdStartDate']?? '',
      fdEndDate: json['fdEndDate']?? '',
      fdKodeGroupBarang: json['fdKodeGroupBarang']?? '',
      fdKodeBarang: json['fdKodeBarang']?? '',
      fdNamaBarang: json['fdNamaBarang']?? '',
      fdKodeRakDisplay: json['fdKodeRakDisplay']?? '',
      fdRakDescription: json['fdRakDescription']?? '',
      fdKeterangan: json['fdKeterangan']?? '',
      fdStatusSent: json['fdStatusSent'] != null? json['fdStatusSent'].toInt() : 0,
      isCheck: json['isCheck']?? true,
      fdLastUpdate: json['fdLastUpdate']?? '',
      fdData: json['fdData']?? '',
      fdMessage: json['fdMessage']?? ''
    );
  }
}

Map<String, dynamic> setJsonData(String fdKodeSF, String fdKodeLangganan, String fdTransDate, String fdKodeBarang, 
  String fdStartDate, String fdEndDate, String fdKodeSewa, String fdJenisSewa, String fdKodeRakDisplay, String fdKeterangan, 
  String fdKodeReason, String fdLastUpdate, List<String> listPhoto) {
  return <String, dynamic>{
    "fdKodeSF": fdKodeSF,
    "fdKodeLangganan": fdKodeLangganan,
    "fdKodeBarang": fdKodeBarang,
    "fdTransDate": fdTransDate,
    "fdStartDate": fdStartDate,
    "fdEndDate": fdEndDate,
    "fdKodeSewa": fdKodeSewa,
    "fdJenisSewa": fdJenisSewa,
    "fdKodeRakDisplay": fdKodeRakDisplay,
    "fdKeterangan": fdKeterangan,
    "fdKodeReason": fdKodeReason,
    'fdLastUpdate': fdLastUpdate,
    'detailPhoto': listPhoto
  };
}

class DisplaySewaNonKomp {
  final String fdKodeSF;
  final String fdKodeLangganan;
  final String fdTransDate;
  final String fdKodeSewa;
  final String fdKodeRakDisplay;
  final String fdRakDescription;
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeGroupBarang;
  final String fdKodeBarang;
  final String fdNamaBarang;
  final String fdKeterangan;
  final String fdKodeReason;
  final String fdLastUpdate;
  bool isCheck = true;
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  DisplaySewaNonKomp({required this.fdKodeSF, required this.fdKodeLangganan, required this.fdTransDate, required this.fdKodeSewa,
    required this.fdKodeRakDisplay, required this.fdRakDescription, required this.fdStartDate, required this.fdEndDate, 
    required this.fdKodeBarang, required this.fdNamaBarang, required this.fdKeterangan, required this.fdStatusSent,
    required this.fdKodeReason, required this.isCheck, required this.fdLastUpdate, required this.fdKodeGroupBarang, 
    this.fdData, this.fdMessage});

  factory DisplaySewaNonKomp.setData(Map<String, dynamic> item) {
    return DisplaySewaNonKomp(
      fdKodeSF: item['fdKodeSF']?? '',
      fdKodeLangganan: item['fdKodeLangganan']?? '',
      fdTransDate: item['fdTransDate']?? '',
      fdKodeSewa: item['fdKodeSewa']?? '',
      fdStartDate: item['fdStartDate']?? '',
      fdEndDate: item['fdEndDate']?? '',
      fdKodeGroupBarang: item['fdKodeGroupBarang']?? '',
      fdKodeBarang: item['fdKodeBarang']?? '',
      fdNamaBarang: item['fdNamaBarang']?? '',
      fdKodeRakDisplay: item['fdKodeRakDisplay']?? '',
      fdRakDescription: item['fdRakDescription']?? '',
      fdKeterangan: item['fdKeterangan']?? '',
      fdKodeReason: item['fdKodeReason']?? '',
      fdStatusSent: item['fdStatusSent'].toInt()?? 0,
      isCheck: item['isCheck']?? true,
      fdLastUpdate: item['fdLastUpdate']?? ''
    );
  }

  factory DisplaySewaNonKomp.fromJson(Map<String, dynamic> json) {
    return DisplaySewaNonKomp(
      fdKodeSF: json['fdKodeSF']?? '',
      fdKodeLangganan: json['fdKodeLangganan']?? '',
      fdTransDate: json['fdTransDate']?? '',
      fdKodeSewa: json['fdKodeSewa']?? '',
      fdStartDate: json['fdStartDate']?? '',
      fdEndDate: json['fdEndDate']?? '',
      fdKodeGroupBarang: json['fdKodeGroupBarang']?? '',
      fdKodeBarang: json['fdKodeBarang']?? '',
      fdNamaBarang: json['fdNamaBarang']?? '',
      fdKodeRakDisplay: json['fdKodeRakDisplay']?? '',
      fdRakDescription: json['fdRakDescription']?? '',
      fdKeterangan: json['fdKeterangan']?? '',
      fdKodeReason: json['fdKodeReason']?? '',
      fdStatusSent: json['fdStatusSent'] != null? json['fdStatusSent'].toInt() : 0,
      isCheck: json['isCheck']?? true,
      fdLastUpdate: json['fdLastUpdate']?? '',
      fdData: json['fdData']?? '',
      fdMessage: json['fdMessage']?? ''
    );
  }
}