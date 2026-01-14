class GroupLangganan {
  final String? fdKodeGroupLangganan;
  final String? fdGroupLangganan;
  final int fdProgramOSA;
  final String? fdDescription;
  final int fdStatusSent;
  final String? message;

  GroupLangganan(
      {required this.fdKodeGroupLangganan,
      required this.fdGroupLangganan,
      required this.fdProgramOSA,
      required this.fdDescription,
      required this.fdStatusSent,
      this.message});

  factory GroupLangganan.setData(Map<String, dynamic> item) {
    return GroupLangganan(
      fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
      fdGroupLangganan: item['fdGroupLangganan'] ?? '',
      fdProgramOSA: item['fdProgramOSA'] ?? 0,
      fdDescription: item['fdDescription'] ?? '',
      fdStatusSent: item['fdStatusSent'] ?? 0,
    );
  }

  factory GroupLangganan.fromJson(Map<String, dynamic> json) {
    return GroupLangganan(
        fdKodeGroupLangganan: json['fdKodeGroupLangganan'] ?? '',
        fdGroupLangganan: json['fdGroupLangganan'] ?? '',
        fdProgramOSA: json['fdProgramOSA'] ?? 0,
        fdDescription: json['fdDescription'] ?? '',
        fdStatusSent: 0,
        message: json['message'] ?? '');
  }

  factory GroupLangganan.empty() {
    return GroupLangganan(
        fdKodeGroupLangganan: '',
        fdGroupLangganan: '',
        fdProgramOSA: 0,
        fdDescription: '',
        fdStatusSent: 0);
  }
}
