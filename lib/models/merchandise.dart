class Merchandise {
  final String? fdKodeMDType;
  final String? fdKodeBarang;
  final int? fdMinStock;
  final int fdAktif;
  final String? message;

  Merchandise(
      {required this.fdKodeMDType,
      required this.fdKodeBarang,
      required this.fdMinStock,
      required this.fdAktif,
      this.message});

  factory Merchandise.setData(Map<String, dynamic> item) {
    return Merchandise(
      fdKodeMDType: item['fdKodeMDType'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdMinStock: item['fdMinStock'] ?? '',
      fdAktif: item['fdAktif'] ?? 1,
    );
  }

  factory Merchandise.fromJson(Map<String, dynamic> json) {
    return Merchandise(
        fdKodeMDType: json['fdKodeMDType'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdMinStock: json['fdMinStock'] ?? '',
        fdAktif: json['fdAktif'] ?? 1,
        message: json['message'] ?? '');
  }

  factory Merchandise.empty() {
    return Merchandise(
        fdKodeMDType: '', fdKodeBarang: '', fdMinStock: 0, fdAktif: 1);
  }
}
