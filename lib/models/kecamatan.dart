class Kecamatan {
  final String? fdKodeKecamatan;
  final String? fdNamaKecamatan;
  final String? fdKodeKabupaten;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  Kecamatan(
      {required this.fdKodeKecamatan,
      required this.fdNamaKecamatan,
      required this.fdKodeKabupaten,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory Kecamatan.setData(Map<String, dynamic> item) {
    return Kecamatan(
      fdKodeKecamatan: item['fdKodeKecamatan'] ?? '',
      fdNamaKecamatan: item['fdNamaKecamatan'] ?? '',
      fdKodeKabupaten: item['fdKodeKabupaten'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
        fdKodeKecamatan: json['fdKodeKecamatan'].toString(),
        fdNamaKecamatan: json['fdNamaKecamatan'] ?? '',
        fdKodeKabupaten: json['fdKodeKabupaten'].toString(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory Kecamatan.empty() {
    return Kecamatan(
        fdKodeKecamatan: '',
        fdNamaKecamatan: '',
        fdKodeKabupaten: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
