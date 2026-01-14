class RakDisplaySewa {
  final String fdDepo;
  final String fdKodeLangganan;
  final String fdKodeGroupLangganan;
  final String fdKodeSewa;
  final String fdBaseSewa;
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeRakDisplay;
  final String fdRakDescription;
  final int? code;
  final String? message;

  RakDisplaySewa(
      {required this.fdDepo,
      required this.fdKodeLangganan,
      required this.fdKodeGroupLangganan,
      required this.fdKodeSewa,
      required this.fdBaseSewa,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdKodeRakDisplay,
      required this.fdRakDescription,
      this.code,
      this.message});

  factory RakDisplaySewa.fromJson(Map<String, dynamic> json) {
    return RakDisplaySewa(
        fdDepo: json['fdDepo'] ?? '',
        fdKodeLangganan: json['fdKodeLangganan'] ?? '',
        fdKodeGroupLangganan: json['fdKodeGroupLangganan'] ?? '',
        fdKodeSewa: json['fdKodeSewa'] ?? '',
        fdBaseSewa: json['fdBaseSewa'] ?? '',
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdKodeRakDisplay: json['fdKodeTipeRakDisplay'] ?? '',
        fdRakDescription: json['fdRakDescription'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }

  factory RakDisplaySewa.setData(Map<String, dynamic> item) {
    return RakDisplaySewa(
      fdDepo: item['fdDepo'] ?? '',
      fdKodeLangganan: item['fdKodeLangganan'] ?? '',
      fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
      fdKodeSewa: item['fdKodeSewa'] ?? '',
      fdBaseSewa: item['fdBaseSewa'] ?? '',
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdKodeRakDisplay: item['fdKodeRakDisplay'] ?? '',
      fdRakDescription: item['fdRakDescription'] ?? '',
    );
  }
}
