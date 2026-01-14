class TipeRakDisplay {
  final String fdKodeRak;
  final String fdRakDescription;
  final int? code;
  final String? message;

  TipeRakDisplay({required this.fdKodeRak, required this.fdRakDescription, this.code, this.message});

  factory TipeRakDisplay.fromJson(Map<String, dynamic> json) {
    return TipeRakDisplay(
      fdKodeRak: json['fdKodeRak'] ?? '',
      fdRakDescription: json['fdRakDescription'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? ''
    );
  }

  factory TipeRakDisplay.setData(Map<String, dynamic> item) {
    return TipeRakDisplay(
      fdKodeRak: item['fdKodeRak'] ?? '',
      fdRakDescription: item['fdRakDescription'] ?? ''
    );
  }
}

class KategoriRak {
  final String fdKodeKategori;
  final String fdKategoriDescription;
  final int? code;
  final String? message;

  KategoriRak({required this.fdKodeKategori, required this.fdKategoriDescription, this.code, this.message});

  factory KategoriRak.fromJson(Map<String, dynamic> json) {
    return KategoriRak(
      fdKodeKategori: json['fdKodeKategoriRakDisplay'] ?? '',
      fdKategoriDescription: json['fdKategoriRakDisplay'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? ''
    );
  }

  factory KategoriRak.setData(Map<String, dynamic> item) {
    return KategoriRak(
      fdKodeKategori: item['fdKodeKategori'] ?? '',
      fdKategoriDescription: item['fdKategoriDescription'] ?? ''
    );
  }
}