class Kelurahan {
  final String? fdKodeKelurahan;
  final String? fdNamaKelurahan;
  final String? fdKodeKecamatan;
  final String? fdKodePos;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  Kelurahan(
      {required this.fdKodeKelurahan,
      required this.fdNamaKelurahan,
      required this.fdKodeKecamatan,
      required this.fdKodePos,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory Kelurahan.setData(Map<String, dynamic> item) {
    return Kelurahan(
      fdKodeKelurahan: item['fdKodeKelurahan'] ?? '',
      fdNamaKelurahan: item['fdNamaKelurahan'] ?? '',
      fdKodeKecamatan: item['fdKodeKecamatan'] ?? '',
      fdKodePos: item['fdKodePos'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Kelurahan.fromJson(Map<String, dynamic> json) {
    return Kelurahan(
        fdKodeKelurahan: json['fdKodeKelurahan'].toString(),
        fdNamaKelurahan: json['fdNamaKelurahan'] ?? '',
        fdKodeKecamatan: json['fdKodeKecamatan'].toString(),
        fdKodePos: json['fdKodePos'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory Kelurahan.empty() {
    return Kelurahan(
        fdKodeKelurahan: '',
        fdNamaKelurahan: '',
        fdKodeKecamatan: '',
        fdKodePos: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
