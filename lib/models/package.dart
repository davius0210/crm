class Package {
  final String fdVersion;
  final String fdPath;
  final String fdFileName;
  final String fdSHACode;

  Package({required this.fdVersion,
    required this.fdPath,
    required this.fdFileName,
    required this.fdSHACode
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      fdVersion: json['fdVersion'] ?? '',
      fdPath: json['fdPath'] ?? '',
      fdFileName: json['fdFileName'] ?? '',
      fdSHACode: json['fdSHACode'] ?? '',
    );
  }
}