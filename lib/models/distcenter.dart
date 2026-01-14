class DistCenter {
  final String? fdKodeDC;
  final String? fdDC;
  final String? fdDescription;
  final int fdAktif;
  final String? message;

  DistCenter(
      {required this.fdKodeDC,
      required this.fdDC,
      required this.fdDescription,
      required this.fdAktif,
      this.message});

  factory DistCenter.setData(Map<String, dynamic> item) {
    return DistCenter(
      fdKodeDC: item['fdKodeDC'] ?? '',
      fdDC: item['fdDC'] ?? '',
      fdDescription: item['fdDescription'] ?? '',
      fdAktif: item['fdAktif'] ?? 1,
    );
  }

  factory DistCenter.fromJson(Map<String, dynamic> json) {
    return DistCenter(
        fdKodeDC: json['fdKodeDC'] ?? '',
        fdDC: json['fdDC'] ?? '',
        fdDescription: json['fdDescription'] ?? '',
        fdAktif: json['fdAktif'] ?? 1,
        message: json['message'] ?? '');
  }

  factory DistCenter.empty() {
    return DistCenter(fdKodeDC: '', fdDC: '', fdDescription: '', fdAktif: 1);
  }
}

class StockDistCenter {
  final String? fdKodeGroupLangganan;
  final String? fdKodeDC;
  final String? fdKodeBarang;
  final int fdQty;
  final String? message;

  StockDistCenter(
      {required this.fdKodeGroupLangganan,
      required this.fdKodeDC,
      required this.fdKodeBarang,
      required this.fdQty,
      this.message});

  factory StockDistCenter.setData(Map<String, dynamic> item) {
    return StockDistCenter(
      fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
      fdKodeDC: item['fdKodeDC'] ?? '',
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdQty: item['fdQty'] ?? 1,
    );
  }

  factory StockDistCenter.fromJson(Map<String, dynamic> json) {
    return StockDistCenter(
        fdKodeGroupLangganan: json['fdKodeGroupLangganan'] ?? '',
        fdKodeDC: json['fdKodeDC'] ?? '',
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdQty: json['fdQty'] ?? 1,
        message: json['message'] ?? '');
  }

  factory StockDistCenter.empty() {
    return StockDistCenter(
        fdKodeGroupLangganan: '', fdKodeDC: '', fdKodeBarang: '', fdQty: 0);
  }
}
