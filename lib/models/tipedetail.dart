class TipeDetail {
  final String fdKode;
  final String? fdNamaDetail;
  final String? fdTipe;
  final String? fdSort;
  final String? fdSingkat;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  TipeDetail(
      {required this.fdKode,
      required this.fdNamaDetail,
      required this.fdTipe,
      required this.fdSort,
      required this.fdSingkat,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory TipeDetail.setData(Map<String, dynamic> item) {
    return TipeDetail(
      fdKode: item['fdKode'] ?? '',
      fdNamaDetail: item['fdNamaDetail'] ?? '',
      fdTipe: item['fdTipe'] ?? '',
      fdSort: item['fdSort'] ?? '',
      fdSingkat: item['fdSingkat'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory TipeDetail.fromJson(Map<String, dynamic> json) {
    return TipeDetail(
        fdKode: json['fdKode'] ?? '',
        fdNamaDetail: json['fdNamaDetail'] ?? '',
        fdTipe: json['fdTipe'] ?? '',
        fdSort: json['fdSort'] ?? '',
        fdSingkat: json['fdSingkat'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory TipeDetail.empty() {
    return TipeDetail(
        fdKode: '',
        fdNamaDetail: '',
        fdTipe: '',
        fdSort: '',
        fdSingkat: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
