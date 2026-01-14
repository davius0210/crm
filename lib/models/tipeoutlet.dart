class TipeOutlet {
  final String fdKodeTipe;
  final String? fdTipeOutlet;
  final String? fdKodeJenis;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  TipeOutlet(
      {required this.fdKodeTipe,
      required this.fdTipeOutlet,
      required this.fdKodeJenis,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory TipeOutlet.setData(Map<String, dynamic> item) {
    return TipeOutlet(
      fdKodeTipe: item['fdKodeTipe'] ?? '',
      fdTipeOutlet: item['fdTipeOutlet'] ?? '',
      fdKodeJenis: item['fdKodeJenis'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory TipeOutlet.fromJson(Map<String, dynamic> json) {
    return TipeOutlet(
        fdKodeTipe: json['fdKodeTipeOutlet'] ?? '',
        fdTipeOutlet: json['fdTipeOutlet'] ?? '',
        fdKodeJenis: json['fdKodeJenisOutlet'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory TipeOutlet.empty() {
    return TipeOutlet(
        fdKodeTipe: '',
        fdTipeOutlet: '',
        fdKodeJenis: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}
