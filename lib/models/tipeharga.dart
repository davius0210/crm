class TipeHarga {
  final String? fdKodeHarga;
  final String fdKodeDivisi;
  final String? fdKeterangan;
  final String? fdKodeJenis;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  TipeHarga(
      {required this.fdKodeHarga,
      required this.fdKodeDivisi,
      required this.fdKeterangan,
      required this.fdKodeJenis,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory TipeHarga.setData(Map<String, dynamic> item) {
    return TipeHarga(
      fdKodeHarga: item['fdKodeHarga'] ?? '',
      fdKodeDivisi: item['fdKodeDivisi'] ?? '',
      fdKeterangan: item['fdKeterangan'] ?? '',
      fdKodeJenis: item['fdKodeJenis'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory TipeHarga.fromJson(Map<String, dynamic> json) {
    return TipeHarga(
        fdKodeHarga: json['fdKodeHarga'] ?? '',
        fdKodeDivisi: json['fdKodeDivisi'] ?? '',
        fdKodeJenis: json['fdKodeJenis'] ?? '',
        fdKeterangan: json['fdKeterangan'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory TipeHarga.empty() {
    return TipeHarga(
        fdKodeHarga: '',
        fdKodeDivisi: '',
        fdKeterangan: '',
        fdKodeJenis: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
