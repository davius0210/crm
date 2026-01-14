class Kabupaten {
  final String? fdKodeKabupaten;
  final String? fdNamaKabupaten;
  final String? fdKodePropinsi;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  Kabupaten(
      {required this.fdKodeKabupaten,
      required this.fdNamaKabupaten,
      required this.fdKodePropinsi,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory Kabupaten.setData(Map<String, dynamic> item) {
    return Kabupaten(
      fdKodeKabupaten: item['fdKodeKabupaten'] ?? '',
      fdNamaKabupaten: item['fdNamaKabupaten'] ?? '',
      fdKodePropinsi: item['fdKodePropinsi'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Kabupaten.fromJson(Map<String, dynamic> json) {
    return Kabupaten(
        fdKodeKabupaten: json['fdKodeKabupaten'].toString(),
        fdNamaKabupaten: json['fdNamaKabupaten'] ?? '',
        fdKodePropinsi: json['fdKodePropinsi'].toString(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory Kabupaten.empty() {
    return Kabupaten(
        fdKodeKabupaten: '',
        fdNamaKabupaten: '',
        fdKodePropinsi: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
