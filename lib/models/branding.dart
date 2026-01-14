class Branding {
  final String fdKodeBrand;
  final String fdBranding;
  final String fdCaptureBefore;
  final String fdCaptureAfter;
  final int? code;
  final String? message;

  Branding(
      {required this.fdKodeBrand,
      required this.fdBranding,
      required this.fdCaptureBefore,
      required this.fdCaptureAfter,
      this.code,
      this.message});

  factory Branding.fromJson(Map<String, dynamic> json) {
    return Branding(
        fdKodeBrand: json['fdKodeBrand'] ?? '',
        fdBranding: json['fdBranding'] ?? '',
        fdCaptureBefore: json['fdCaptureBefore'] ?? '',
        fdCaptureAfter: json['fdCaptureAfter'] ?? '',
        code: json['code'] ?? 0,
        message: json['message'] ?? '');
  }

  factory Branding.setData(Map<String, dynamic> item) {
    return Branding(
      fdKodeBrand: item['fdKodeBrand'] ?? '',
      fdBranding: item['fdBranding'] ?? '',
      fdCaptureBefore: item['fdCaptureBefore'] ?? '',
      fdCaptureAfter: item['fdCaptureAfter'] ?? '',
    );
  }
}
