class Propinsi {
  final String? fdKodePropinsi;
  final String? fdNamaPropinsi;
  final String? fdKodeNegara;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  Propinsi(
      {required this.fdKodePropinsi,
      required this.fdNamaPropinsi,
      required this.fdKodeNegara,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory Propinsi.setData(Map<String, dynamic> item) {
    return Propinsi(
      fdKodePropinsi: item['fdKodePropinsi'] ?? '',
      fdNamaPropinsi: item['fdNamaPropinsi'] ?? '',
      fdKodeNegara: item['fdKodeNegara'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Propinsi.fromJson(Map<String, dynamic> json) {
    return Propinsi(
        fdKodePropinsi: json['fdKodePropinsi'].toString(),
        fdNamaPropinsi: json['fdNamaPropinsi'] ?? '',
        fdKodeNegara: json['fdKodeNegara'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory Propinsi.empty() {
    return Propinsi(
        fdKodePropinsi: '',
        fdNamaPropinsi: '',
        fdKodeNegara: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
