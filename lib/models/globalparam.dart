import 'package:intl/intl.dart';

NumberFormat idNumberFormat = NumberFormat('#,##0', 'id_ID');
NumberFormat idNumberFormatDec = NumberFormat('#,##0.00', 'id_ID');
NumberFormat enNumberFormat = NumberFormat('#,##0.00', 'en_US');
NumberFormat enNumberFormatQty = NumberFormat('#,##0', 'en_US');
NumberFormat enNumberFormatDec = NumberFormat('#,##0.0', 'en_US');
var dtFormatDB = DateFormat('yyyy-MM-dd');
var dateTimeFormatDB = DateFormat('yyyy-MM-dd HH:mm:ss');
var dtFormatView = DateFormat('dd/MM/yyyy');
var dtFormatViewMMM = DateFormat('dd MMM yyyy');
var dateTimeFormatViewMMM = DateFormat('dd MMM yyyy HH:mm:ss');
var dtStripFormatView = DateFormat('dd-MM-yyyy');
var dateTimeFormatView = DateFormat('dd/MM/yyyy HH:mm:ss');
var timeFormatView = DateFormat('HH:mm');

int gpsTimeOut = 10;
int minuteTimeout = 15;

//Firebase push notification
const String channelNotifId = 'high_importance_channel';
const String channelNotifDesc = 'High Importance Notifications';
const String apiKey =
    'AIzaSyAmuStKoFYWT-xYIWvuGLVpqr0LDubntmc'; //'AIzaSyAHCHKFkyqtfggcrXmG3oZEdm0j6sNUZNY';
const String appId =
    '1:567149442879:android:a7032599399502d453c58a'; //'1:529622676554:android:a798dff96326577092a2b3';
const String messagingSenderId = '567149442879'; //'529622676554';
const String projectId = 'crmmobile-bd71a'; //'md-apps-aspp';
const String webPushCertificate =
    'BLttyHmvERVa8mOhTWCQzSXlKRLGosDtsNBilp5vtiF-EeX_OvZ_LaLuwxwSAapZx0yZRq6-nLwTSkFweNrj8iU';
//'BGuv7EefLOGcOSHeIsaG335KOWqj6h6x-FVXXIehA74w5jtBDBMMYWCwK4kM2O7aOIhZktpMAM8WwhalLsuTq5o';
const String msgTopic = 'crm_news'; //'md_news';
//---firebase

String appDir = '';
const String kmStartZipFileName = 'KMStart.zip';
const String kmEndZipFileName = 'KMEnd.zip';
const String imgPath = 'Camera';
const String kmStartPre = 'KMS';
const String kmEndPre = 'KME';
const String sellOPre = 'SellO';
const String dsKompPre = 'DSK';
const String dsNonKompPre = 'DSN';
const String planoPre = 'Plano';
const String reasonPre = 'RNV';
const String reasonPausePre = 'RP';
const String rakActPre = 'RDA';
const String popPromoPre = 'Ppro';
const String compActPre = 'Komp';
const String outletAbsenPre = 'OAbs';
const String nooPre = 'NOO';
const String imgPathPlano = 'Planogram';
const String imgPathStandardPlano = 'StdPlanogram';
const String custEdit = 'CE';
const String invPre = 'INV';
const String buktiGiroPre = 'BuktiG';
const String buktiTransferPre = 'BuktiT';
const String buktiChequePre = 'BuktiC';

String pathImgServer(
    String fdDepo, String fdKodeSF, String fdStartDate, String fdImgName) {
  String monthYear = DateFormat('yyyyMM').format(DateTime.parse(fdStartDate));
  String day = DateFormat('dd').format(DateTime.parse(fdStartDate));

  return '$fdDepo/$monthYear/$day/$fdKodeSF/$fdImgName';
}

String pathImgNOOServer(
    String fdDepo, String fdKodeSF, String fdStartDate, String fdImgName) {
  String monthYear = DateFormat('yyyyMM').format(DateTime.parse(fdStartDate));
  String day = DateFormat('dd').format(DateTime.parse(fdStartDate));

  return '$fdDepo/$fdKodeSF/$monthYear/$day/NOO/$fdImgName';
}

String kmStartFileName(String fdKodeSF, String fdDate) {
  return '${kmStartPre}_${fdKodeSF}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}.jpg';
}

String kmStartFullImgName(String fdKodeSF, String fdDate) {
  String fileName = kmStartFileName(fdKodeSF, fdDate);

  return '$fdKodeSF/$fileName';
}

String kmEndFileName(String fdKodeSF, String fdDate) {
  return '${kmEndPre}_${fdKodeSF}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}.jpg';
}

String kmEndFullImgName(String fdKodeSF, String fdDate) {
  String fileName = kmEndFileName(fdKodeSF, fdDate);

  return '$fdKodeSF/$fileName';
}

String displaySewaKompImgName(
    int index,
    String fdKodeSF,
    String fdKodeLangganan,
    String fdKodeRak,
    String fdDate,
    String fdKodeGroupBarang) {
  return '$fdKodeSF/$fdKodeLangganan/${dsKompPre}_${fdKodeRak}_${fdKodeGroupBarang}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String displaySewaNonKompImgName(int index, String fdKodeSF,
    String fdKodeLangganan, String fdKodeSewa, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${dsNonKompPre}_${fdKodeSewa}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String buktiTransferImgName(int index, String fdKodeSF, String fdKodeLangganan,
    String fdNoEntryFaktur, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${invPre}_${fdNoEntryFaktur}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String sellOutImgName(int index, String fdKodeSF, String fdKodeLangganan,
    String fdJenisBarang, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${sellOPre}_${fdJenisBarang}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String planogramImgName(
    int index, String fdKodeSF, String fdKodeLangganan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${planoPre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String reasonNotVisitFileName(String fdKodeLangganan, String fdDate) {
  return '${reasonPre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}.jpg';
}

String reasonNotVisitFullImgName(
    String fdKodeSF, String fdKodeLangganan, String fdDate) {
  String fileName = reasonNotVisitFileName(fdKodeLangganan, fdDate);

  return '$fdKodeSF/$fdKodeLangganan/$fileName';
}

String reasonPauseFileName(String fdKodeLangganan, String fdDate) {
  return '${reasonPausePre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}.jpg';
}

String reasonPauseFullImgName(
    String fdKodeSF, String fdKodeLangganan, String fdDate) {
  String fileName = reasonPauseFileName(fdKodeLangganan, fdDate);

  return '$fdKodeSF/$fdKodeLangganan/$fileName';
}

String kompetitorImgName(int index, String fdKodeSF, String fdKodeBarang,
    String fdKodeLangganan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${compActPre}_${fdKodeSF}_${fdKodeLangganan}_${fdKodeBarang}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String nooImgName(int index, String filename, String fdKodeSF,
    String fdKeterangan, String fdDate) {
  return '$fdKodeSF/NOO/NOO_${filename}_${fdKeterangan}_${index.toString()}.jpg';
}

String ttdImgName(
    int index, String fdKodeSF, String fdKeterangan, String fdDate) {
  return '$fdKodeSF/TTD/Sign_${fdKodeSF}_${fdKeterangan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String rakActivityImgName(int index, String fdKodeSF, String fdKodeLangganan,
    String fdRakTipe, String fdRakKategori, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${rakActPre}_${fdRakTipe}_${fdRakKategori}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String ttdImgName2(
    int index, String fdKodeSF, String fdKeterangan, String fdDate) {
  return 'Sign_${fdKodeSF}_${fdKeterangan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String popPromoImgName(int index, String fdKodeSF, String fdDepo,
    String fdKodeLangganan, String noKey, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${popPromoPre}_${fdDepo}_${fdKodeSF}_${fdKodeLangganan}_${noKey}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String outletAbsenFileName(String fdKodeLangganan, String fdDate) {
  return '${outletAbsenPre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}.jpg';
}

String outletAbsenFullImgName(
    String fdKodeSF, String fdKodeLangganan, String fdDate) {
  String fileName = outletAbsenFileName(fdKodeLangganan, fdDate);

  return '$fdKodeSF/$fdKodeLangganan/$fileName';
}

String custEditImgName(int index, String filename, String fdKodeSF,
    String fdKodeLangganan, String fdKeterangan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${custEdit}_${filename}_${fdKeterangan}_${index.toString()}.jpg';
}

String buktiCollectionTransferImgName(
    int index, String fdKodeSF, String fdKodeLangganan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${buktiTransferPre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String buktiCollectionGiroImgName(
    int index, String fdKodeSF, String fdKodeLangganan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${buktiGiroPre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String buktiCollectionChequeImgName(
    int index, String fdKodeSF, String fdKodeLangganan, String fdDate) {
  return '$fdKodeSF/$fdKodeLangganan/${buktiChequePre}_${fdKodeLangganan}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}

String ttbImgName(int index, String fdKodeSF, String fdKodeNoo,
    String fdNoEntryOrder, String fdDate) {
  return '$fdKodeSF/$fdKodeNoo/${buktiTransferPre}_${fdNoEntryOrder}_${DateFormat('ddMMyy').format(DateTime.parse(fdDate))}_${index.toString()}.jpg';
}
