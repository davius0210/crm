class Planogram {
  int fdStatusSent = 0;
  String? fdData;
  String? fdMessage;

  Planogram({required this.fdStatusSent, this.fdData, this.fdMessage});

  // factory Planogram.setData(Map<String, dynamic> item) {
  //   return Planogram(
  //     fdKodeSF: item['fdKodeSF']?? '',
  //     fdKodeLangganan: item['fdKodeLangganan']?? '',
  //     fdTransDate: item['fdTransDate']?? '',
  //     fdKodeBarang: item['fdKodeBarang']?? '',
  //     fdNamaBarang: item['fdNamaBarang']?? '',
  //     fdPKM: item['fdPKM'].toInt()?? 0,
  //     fdStatusSent: item['fdStatusSent'].toInt()?? 0,
  //     fdLastUpdate: item['fdLastUpdate']?? ''
  //   );
  // }

  factory Planogram.fromJson(Map<String, dynamic> json) {
    return Planogram(
        //   fdKodeSF: json['fdKodeSF']?? '',
        //   fdKodeLangganan: json['fdKodeLangganan']?? '',
        //   fdTransDate: json['fdTransDate']?? '',
        //   fdKodeBarang: json['fdKodeBarang']?? '',
        //   fdNamaBarang: json['fdNamaBarang']?? '',
        //   fdPKM: json['fdPKM'] != null? json['fdPKM'].toInt() : 0,
        fdStatusSent:
            json['fdStatusSent'] != null ? json['fdStatusSent'].toInt() : 0,
        // fdLastUpdate: json['fdLastUpdate']?? '',
        fdData: json['fdData'] ?? '',
        fdMessage: json['fdMessage'] ?? '');
  }
}

class PlanogramPeriode {
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeGroupLangganan;
  final String fdKodeTipeLangganan;
  final int fdAmountChiller;
  final int fdNoImage;
  final String fdLastUpdate;

  PlanogramPeriode(
      {required this.fdStartDate,
      required this.fdEndDate,
      required this.fdKodeGroupLangganan,
      required this.fdKodeTipeLangganan,
      required this.fdAmountChiller,
      required this.fdNoImage,
      required this.fdLastUpdate});

  factory PlanogramPeriode.setData(Map<String, dynamic> item) {
    return PlanogramPeriode(
        fdStartDate: item['fdStartDate'] ?? '',
        fdEndDate: item['fdEndDate'] ?? '',
        fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
        fdKodeTipeLangganan: item['fdKodeTipeLangganan'] ?? '',
        fdAmountChiller: item['fdAmountChiller'] ?? 0,
        fdNoImage: item['fdNoImage'] ?? 0,
        fdLastUpdate: item['fdUpdateTS'] ?? '');
  }

  factory PlanogramPeriode.empty() {
    return PlanogramPeriode(
        fdStartDate: '',
        fdEndDate: '',
        fdKodeGroupLangganan: '',
        fdKodeTipeLangganan: '',
        fdAmountChiller: 0,
        fdNoImage: 0,
        fdLastUpdate: '');
  }
}

class StandardPlano {
  final String fdNamaLangganan;
  final String fdTipe;
  final int fdNoUrut;
  final int fdNoImage;
  final String fdLastUpdate;

  StandardPlano(
      {required this.fdNamaLangganan,
      required this.fdTipe,
      required this.fdNoUrut,
      required this.fdNoImage,
      required this.fdLastUpdate});

  factory StandardPlano.setData(Map<String, dynamic> item) {
    return StandardPlano(
        fdNamaLangganan: item['fdNamaLangganan'] ?? '',
        fdTipe: item['fdTipe'] ?? '',
        fdNoUrut: item['fdNoUrut'] ?? 0,
        fdNoImage: item['fdNoImage'] ?? 0,
        fdLastUpdate: item['fdUpdateTS'] ?? '');
  }

  factory StandardPlano.empty() {
    return StandardPlano(
        fdNamaLangganan: '',
        fdTipe: '',
        fdNoUrut: 0,
        fdNoImage: 0,
        fdLastUpdate: '');
  }
}

class TempPlanogramPeriode {
  final String fdStartDate;
  final String fdEndDate;
  final String fdKodeGroupLangganan;
  final String fdKodeTipeLangganan;
  final int fdAmountChiller;
  final int fdNoImage;
  final String fdLastUpdate;

  TempPlanogramPeriode(
      {required this.fdStartDate,
      required this.fdEndDate,
      required this.fdKodeGroupLangganan,
      required this.fdKodeTipeLangganan,
      required this.fdAmountChiller,
      required this.fdNoImage,
      required this.fdLastUpdate});

  factory TempPlanogramPeriode.setData(Map<String, dynamic> item) {
    return TempPlanogramPeriode(
        fdStartDate: item['fdStartDate'] ?? '',
        fdEndDate: item['fdEndDate'] ?? '',
        fdKodeGroupLangganan: item['fdKodeGroupLangganan'] ?? '',
        fdKodeTipeLangganan: item['fdKodeTipeLangganan'] ?? '',
        fdAmountChiller: item['fdAmountChiller'] ?? 0,
        fdNoImage: item['fdNoImage'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory TempPlanogramPeriode.empty() {
    return TempPlanogramPeriode(
        fdStartDate: '',
        fdEndDate: '',
        fdKodeGroupLangganan: '',
        fdKodeTipeLangganan: '',
        fdAmountChiller: 0,
        fdNoImage: 0,
        fdLastUpdate: '');
  }
}

class TempStandardPlano {
  final String fdNamaLangganan;
  final String fdTipe;
  final int fdNoUrut;
  final int fdNoImage;
  final String fdLastUpdate;

  TempStandardPlano(
      {required this.fdNamaLangganan,
      required this.fdTipe,
      required this.fdNoUrut,
      required this.fdNoImage,
      required this.fdLastUpdate});

  factory TempStandardPlano.setData(Map<String, dynamic> item) {
    return TempStandardPlano(
        fdNamaLangganan: item['fdNamaLangganan'] ?? '',
        fdTipe: item['fdTipe'] ?? '',
        fdNoUrut: item['fdNoUrut'] ?? 0,
        fdNoImage: item['fdNoImage'] ?? 0,
        fdLastUpdate: item['fdLastUpdate'] ?? '');
  }

  factory TempStandardPlano.empty() {
    return TempStandardPlano(
        fdNamaLangganan: '',
        fdTipe: '',
        fdNoUrut: 0,
        fdNoImage: 0,
        fdLastUpdate: '');
  }
}
