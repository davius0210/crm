class Diskon {
  final String? fdNoEntryDiskon;
  final String? fdNoSurat;
  final String? fdNamaDiskon;
  final String? fdKodeHarga;
  final String? fdNamaHarga;
  final String? fdMataUang;
  final String? fdTipeDiskon;
  final String? fdNamaTipeDiskon;
  final int? fdMinOrder;
  final String? fdStartDate;
  final String? fdEndDate;
  final double? fdDiscP1;
  final double? fdDiscP2;
  final double? fdDiscP3;
  final double? fdDiscV;
  final String? fdQtyAkumulasi;
  final String? fdKelipatan;
  final double? fdMaxDiscV;
  final String? fdBaseOn;
  final String? fdKodeBarangExtra;
  final int? fdQtyExtra;
  final String? fdDescription;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  Diskon(
      {required this.fdNoEntryDiskon,
      required this.fdNoSurat,
      required this.fdNamaDiskon,
      required this.fdKodeHarga,
      required this.fdNamaHarga,
      required this.fdMataUang,
      required this.fdTipeDiskon,
      required this.fdNamaTipeDiskon,
      required this.fdMinOrder,
      required this.fdStartDate,
      required this.fdEndDate,
      required this.fdDiscP1,
      required this.fdDiscP2,
      required this.fdDiscP3,
      required this.fdDiscV,
      required this.fdQtyAkumulasi,
      required this.fdKelipatan,
      required this.fdMaxDiscV,
      required this.fdBaseOn,
      required this.fdKodeBarangExtra,
      required this.fdQtyExtra,
      required this.fdDescription,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory Diskon.setData(Map<String, dynamic> item) {
    return Diskon(
      fdNoEntryDiskon: item['fdNoEntryDiskon'].toString() ?? '',
      fdNoSurat: item['fdNoSurat'] ?? '',
      fdNamaDiskon: item['fdNamaDiskon'] ?? '',
      fdKodeHarga: item['fdKodeHarga'] ?? '',
      fdNamaHarga: item['fdNamaHarga'] ?? '',
      fdMataUang: item['fdMataUang'] ?? '',
      fdTipeDiskon: item['fdTipeDiskon'] ?? '',
      fdNamaTipeDiskon: item['fdNamaTipeDiskon'] ?? '',
      fdMinOrder: item['fdMinOrder'] ?? 0,
      fdStartDate: item['fdStartDate'] ?? '',
      fdEndDate: item['fdEndDate'] ?? '',
      fdDiscP1: item['fdDiscP1'] ?? 0,
      fdDiscP2: item['fdDiscP2'] ?? 0,
      fdDiscP3: item['fdDiscP3'] ?? 0,
      fdDiscV: item['fdDiscV'] ?? 0,
      fdQtyAkumulasi: item['fdQtyAkumulasi'] ?? '',
      fdKelipatan: item['fdKelipatan'] ?? '',
      fdMaxDiscV: item['fdMaxDiscV'] ?? 0,
      fdBaseOn: item['fdBaseOn'] ?? '',
      fdKodeBarangExtra: item['fdKodeBarangExtra'] ?? '',
      fdQtyExtra: item['fdQtyExtra'] ?? 0,
      fdDescription: item['fdDescription'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory Diskon.fromJson(Map<String, dynamic> json) {
    return Diskon(
        fdNoEntryDiskon: json['fdNoEntryDiskon'].toString() ?? '',
        fdNoSurat: json['fdNoSurat'] ?? '',
        fdNamaDiskon: json['fdNamaDiskon'] ?? '',
        fdKodeHarga: json['fdKodeHarga'] ?? '',
        fdNamaHarga: json['fdNamaHarga'] ?? '',
        fdMataUang: json['fdMataUang'] ?? '',
        fdTipeDiskon: json['fdTipeDiskon'] ?? '',
        fdNamaTipeDiskon: json['fdNamaTipeDiskon'] ?? '',
        fdMinOrder: json['fdMinOrder'] ?? 0,
        fdStartDate: json['fdStartDate'] ?? '',
        fdEndDate: json['fdEndDate'] ?? '',
        fdDiscP1: double.tryParse(json['fdDiscP1'].toString()) != null
            ? json['fdDiscP1'].toDouble()
            : 0,
        fdDiscP2: double.tryParse(json['fdDiscP2'].toString()) != null
            ? json['fdDiscP2'].toDouble()
            : 0,
        fdDiscP3: double.tryParse(json['fdDiscP3'].toString()) != null
            ? json['fdDiscP3'].toDouble()
            : 0,
        fdDiscV: double.tryParse(json['fdDiscV'].toString()) != null
            ? json['fdDiscV'].toDouble()
            : 0,
        fdQtyAkumulasi: json['fdQtyAkumulasi'] ?? '',
        fdKelipatan: json['fdKelipatan'] ?? '',
        fdMaxDiscV: double.tryParse(json['fdMaxDiscV'].toString()) != null
            ? json['fdMaxDiscV'].toDouble()
            : 0,
        fdBaseOn: json['fdBaseOn'] ?? '',
        fdKodeBarangExtra: json['fdKodeBarangExtra'] ?? '',
        fdQtyExtra: json['fdQtyExtra'] ?? 0,
        fdDescription: json['fdDescription'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory Diskon.empty() {
    return Diskon(
        fdNoEntryDiskon: '',
        fdNoSurat: '',
        fdNamaDiskon: '',
        fdKodeHarga: '',
        fdNamaHarga: '',
        fdMataUang: '',
        fdTipeDiskon: '',
        fdNamaTipeDiskon: '',
        fdMinOrder: 0,
        fdStartDate: '',
        fdEndDate: '',
        fdDiscP1: 0,
        fdDiscP2: 0,
        fdDiscP3: 0,
        fdDiscV: 0,
        fdQtyAkumulasi: '',
        fdKelipatan: '',
        fdMaxDiscV: 0,
        fdBaseOn: '',
        fdKodeBarangExtra: '',
        fdQtyExtra: 0,
        fdDescription: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}

class DiskonDetail {
  final String? fdNoEntryDiskon;
  final String? fdKodeBarang;
  final String? fdNamaBarang;
  final String? fdKodeGroup;
  final String? fdNamaGroup;
  final double? fdRangeStart;
  final double? fdRangeEnd;
  final String? fdMandatory;
  final String? fdInclude;
  final String? fdStatusRecord;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  DiskonDetail(
      {required this.fdNoEntryDiskon,
      required this.fdKodeBarang,
      required this.fdNamaBarang,
      required this.fdKodeGroup,
      required this.fdNamaGroup,
      required this.fdRangeStart,
      required this.fdRangeEnd,
      required this.fdMandatory,
      required this.fdInclude,
      required this.fdStatusRecord,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory DiskonDetail.setData(Map<String, dynamic> item) {
    return DiskonDetail(
      fdNoEntryDiskon: item['fdNoEntryDiskon'].toString(),
      fdKodeBarang: item['fdKodeBarang'] ?? '',
      fdNamaBarang: item['fdNamaBarang'] ?? '',
      fdKodeGroup: item['fdKodeGroup'] ?? '',
      fdNamaGroup: item['fdNamaGroup'] ?? '',
      fdRangeStart: item['fdRangeStart'] ?? 0,
      fdRangeEnd: item['fdRangeEnd'] ?? 0,
      fdMandatory: item['fdMandatory'] ?? '',
      fdInclude: item['fdInclude'] ?? '',
      fdStatusRecord: item['fdStatusRecord'].toString(),
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory DiskonDetail.fromJson(Map<String, dynamic> json) {
    return DiskonDetail(
        fdNoEntryDiskon: json['fdNoEntryDiskon'].toString(),
        fdKodeBarang: json['fdKodeBarang'] ?? '',
        fdNamaBarang: json['fdNamaBarang'] ?? '',
        fdKodeGroup: json['fdKodeGroup'] ?? '',
        fdNamaGroup: json['fdNamaGroup'] ?? '',
        fdRangeStart: double.tryParse(json['fdRangeStart'].toString()) != null
            ? json['fdRangeStart'].toDouble()
            : 0,
        fdRangeEnd: double.tryParse(json['fdRangeEnd'].toString()) != null
            ? json['fdRangeEnd'].toDouble()
            : 0,
        fdMandatory: json['fdMandatory'] ?? '',
        fdInclude: json['fdInclude'] ?? '',
        fdStatusRecord: json['fdStatusRecord'].toString(),
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory DiskonDetail.empty() {
    return DiskonDetail(
        fdNoEntryDiskon: '',
        fdKodeBarang: '',
        fdNamaBarang: '',
        fdKodeGroup: '',
        fdNamaGroup: '',
        fdRangeStart: 0,
        fdRangeEnd: 0,
        fdMandatory: '',
        fdInclude: '',
        fdStatusRecord: '',
        fdLastUpdate: '',
        isCheck: false);
  }
}

class KodeHarga {
  final String? fdKodeHarga;
  final String? fdNamaHarga;
  final String? fdLastUpdate;
  final String? message;
  bool? isCheck = false;

  KodeHarga(
      {required this.fdKodeHarga,
      required this.fdNamaHarga,
      required this.fdLastUpdate,
      this.isCheck,
      this.message});

  factory KodeHarga.setData(Map<String, dynamic> item) {
    return KodeHarga(
      fdKodeHarga: item['fdKodeHarga'] ?? '',
      fdNamaHarga: item['fdNamaHarga'] ?? '',
      fdLastUpdate: item['fdLastUpdate'] ?? '',
    );
  }

  factory KodeHarga.fromJson(Map<String, dynamic> json) {
    return KodeHarga(
        fdKodeHarga: json['fdKodeHarga'] ?? '',
        fdNamaHarga: json['fdNamaHarga'] ?? '',
        fdLastUpdate: json['fdLastUpdate'] ?? '',
        isCheck: json['isCheck'] ?? false,
        message: json['message'] ?? '');
  }

  factory KodeHarga.empty() {
    return KodeHarga(
        fdKodeHarga: '', fdNamaHarga: '', fdLastUpdate: '', isCheck: false);
  }
}
