import 'package:badges/badges.dart' as badges;
import 'package:crm_apps/backup_page.dart';
import 'package:crm_apps/coveragearea_page.dart';
import 'package:crm_apps/limitkredit_page.dart';
import 'package:crm_apps/listinvoice_page.dart';
import 'package:crm_apps/models/globalparam.dart' as param;
import 'package:crm_apps/models/salesman.dart';
import 'package:crm_apps/new/component/card_component.dart';
import 'package:crm_apps/new/component/custom_card_dashobard_component.dart';
import 'package:crm_apps/new/component/icon_button_component.dart';
import 'package:crm_apps/new/component/list_menu_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:crm_apps/nonrute_page.dart';
import 'package:crm_apps/noo_page.dart';
import 'package:crm_apps/pdf_lash_page.dart';
import 'package:crm_apps/rencanarute_page.dart';
import 'package:crm_apps/rute_page.dart';
import 'package:crm_apps/stock_page.dart';
import 'package:crm_apps/style/css.dart' as css;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class HomeView extends StatelessWidget {
  final Salesman user;
  final String todayDate;
  final List<Map<dynamic, dynamic>> listNotif;
  final Map<String, dynamic> mapSFSummary;
  final bool isNonRuteValid;
  final String startDayDate;
  final bool isEndDay;
  final int countNoo;
  final int countCall;
  final int countOrderCZ;
  final int countOrderALK;
  final double totalOrderCZ;
  final double totalOrderALK;
  final double omzetLusinCZ;
  final double omzetKartonALK;
  final bool isStartDay;
  final Future<void> Function() confirmSendUnsentImages;
  final Future<void> Function() confirmSendLog;

  const HomeView({
    super.key,
    required this.confirmSendUnsentImages,
    required this.confirmSendLog,
    required this.user,
    required this.isStartDay,
    required this.todayDate,
    required this.listNotif,
    required this.mapSFSummary,
    required this.isNonRuteValid,
    required this.startDayDate,
    required this.isEndDay,
    required this.countNoo,
    required this.countCall,
    required this.countOrderALK,
    required this.countOrderCZ,
    required this.omzetKartonALK,
    required this.omzetLusinCZ,
    required this.totalOrderALK,
    required this.totalOrderCZ,
  });

  // Helper method untuk textScaleFactor
  double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 950) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE0F2F1),
                Color(0xFFE1F5FE),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CardComponent(
                    content: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Image(
                            image: const AssetImage('assets/images/logo250abc.png'),
                            width: 100,
                            color: Colors.white.withOpacity(0.3),
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: ColorHelper.color12,
                              radius: 50,
                              child: Image.asset('assets/images/UserProfile.png'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, ${user.fdNamaSF}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  color: ColorHelper.border,
                                  height: 1,
                                  width: MediaQuery.of(context).size.width / 1.8,
                                ),
                                Text(
                                  '${user.fdKodeDepo} - ${user.fdNamaDepo}',
                                  style: const TextStyle(
                                    color: ColorHelper.hint,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user.fdKodeSF,
                                  style: const TextStyle(
                                    color: ColorHelper.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  CardComponent(
                    content: RichText(
                      textScaleFactor: textScaleFactor(context),
                      text: TextSpan(
                        style: css.textSmallSizeBlack(),
                        children: [
                          TextSpan(
                            text: 'Tanggal: ',
                            style: css.textNormalBold(),
                          ),
                          TextSpan(
                            text: param.dtFormatViewMMM.format(
                              todayDate == '' 
                                  ? DateTime.now() 
                                  : param.dtFormatView.parse(todayDate),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CardComponent(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 90,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  IconButtonComponent(
                                    label: 'Sales Activity',
                                    color: ColorHelper.primary,
                                    onPressed: () {
                                      FunctionHelper.showDialogs(
                                        context,
                                        title: 'Sales Activity',
                                        content: CardListMenuComponent(
                                          isEnableChevron: false,
                                          items: [
                                            CardTileMenu(
                                              title: const Text('Stock'),
                                              prefix: Icon(
                                                Icons.download_rounded,
                                                color: ColorHelper.primary,
                                                size: 24 * textScaleFactor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    settings: const RouteSettings(name: 'stock'),
                                                    builder: (context) => StockPage(
                                                      user: user,
                                                      startDayDate: startDayDate,
                                                      isEndDay: isEndDay,
                                                      routeName: 'stock',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            CardTileMenu(
                                              title: const Text('Rencana Rute'),
                                              prefix: Icon(
                                                Icons.route_outlined,
                                                color: ColorHelper.primary,
                                                size: 24 * textScaleFactor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    settings: const RouteSettings(name: 'rencanarute'),
                                                    builder: (context) => RencanaRutePage(
                                                      user: user,
                                                      startDayDate: startDayDate,
                                                      isEndDay: isEndDay,
                                                      routeName: 'rencanarute',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            CardTileMenu(
                                              title: const Text('List Invoice'),
                                              prefix: Icon(
                                                Icons.list_alt_rounded,
                                                color: ColorHelper.primary,
                                                size: 24 * textScaleFactor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    settings: const RouteSettings(name: 'listinvoice'),
                                                    builder: (context) => ListInvoicePage(
                                                      user: user,
                                                      startDayDate: startDayDate,
                                                      isEndDay: isEndDay,
                                                      routeName: 'listinvoice',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            CardTileMenu(
                                              title: const Text('Coverage Area'),
                                              prefix: Icon(
                                                Icons.place_rounded,
                                                color: ColorHelper.primary,
                                                size: 24 * textScaleFactor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    settings: const RouteSettings(name: 'coveragearea'),
                                                    builder: (context) => CoverageAreaPage(
                                                      user: user,
                                                      startDayDate: startDayDate,
                                                      routeName: 'coveragearea',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            CardTileMenu(
                                              title: const Text('Limit Kredit'),
                                              prefix: Icon(
                                                Icons.credit_card,
                                                color: ColorHelper.primary,
                                                size: 24 * textScaleFactor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    settings: const RouteSettings(name: 'limitkredit'),
                                                    builder: (context) => LimitKreditPage(
                                                      user: user,
                                                      startDayDate: startDayDate,
                                                      isEndDay: isEndDay,
                                                      routeName: 'limitkredit',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(CupertinoIcons.bag, color: Colors.white),
                                  ),
                                  IconButtonComponent(
                                    label: 'Store Activity',
                                    color: ColorHelper.secondary,
                                    onPressed: () {
                                      _showStoreActivityDialog(context);
                                    },
                                    child: const Icon(CupertinoIcons.shopping_cart, color: Colors.white),
                                  ),
                                  IconButtonComponent(
                                    label: 'Files',
                                    color: ColorHelper.color24,
                                    onPressed: () {
                                      _showFilesDialog(context);
                                    },
                                    child: const Icon(Icons.storage, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: CardComponent(
                      content: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildNotificationSection(context),
                            _buildDailySummarySection(context),
                            _buildTargetRealisasiSection(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods untuk memisahkan UI
  Widget _buildNotificationSection(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: css.boxDecorTitle(),
          padding: const EdgeInsets.all(5),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Notifikasi', style: css.textHeaderBold()),
              ),
            ],
          ),
        ),
        if (listNotif.isNotEmpty)
          ...listNotif.map((entry) => _buildNotifItem(entry))
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Text(
                  'Tidak ada notifikasi',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildNotifItem(Map<dynamic, dynamic> entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: TextButton(
            onPressed: () async {
              final url = entry['fdUrl'];
              if (url != null && await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -3, end: -33),
              showBadge: true,
              badgeContent: Text(
                entry['fdBadges'].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              badgeAnimation: const badges.BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: const badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: Colors.red,
                padding: EdgeInsets.only(left: 5, right: 5),
                elevation: 0,
              ),
              child: Text(
                entry['fdLabel'] ?? '---',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummarySection(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: css.boxDecorTitle(),
          padding: const EdgeInsets.all(5),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Daily Summary', style: css.textHeaderBold()),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorHelper.primary, width: 2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Plan Rute',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(mapSFSummary['rute'].toString()),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isNonRuteValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NonRutePage(
                          user: user,
                          startDayDate: startDayDate,
                          isEndDay: isEndDay,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: const Border(
                      top: BorderSide(color: ColorHelper.primary, width: 2),
                      bottom: BorderSide(color: ColorHelper.primary, width: 2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Non Rute',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Text(mapSFSummary['nonrute'].toString()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorHelper.primary, width: 2),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Rute',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(mapSFSummary['rute'].toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
      ],
    );
  }

  Widget _buildTargetRealisasiSection(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: css.boxDecorTitle(),
          padding: const EdgeInsets.all(5),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Target dan Realisasi', style: css.textHeaderBold()),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FixedColumnWidth(120 * textScaleFactor(context)),
            1: FixedColumnWidth(100 * textScaleFactor(context)),
            2: FixedColumnWidth(100 * textScaleFactor(context)),
          },
          children: [
            TableRow(
              children: [
                const SizedBox(),
                _buildTableCell('Target Harian', isHeader: true),
                _buildTableCell('Realisasi Hari ini', isHeader: true),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('NOO'),
                _buildTableCell('0'),
                _buildTableCell('$countNoo Toko'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Call'),
                _buildTableCell('0'),
                _buildTableCell('$countCall Toko'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Order CZ'),
                _buildTableCell('0'),
                _buildTableCell('$countOrderCZ Toko'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Omzet CZ (LSN)'),
                _buildTableCell('0'),
                _buildTableCell('${param.idNumberFormatDec.format(omzetLusinCZ)} LSN'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Total Rp CZ'),
                _buildTableCell('0'),
                _buildTableCell('Rp. ${param.enNumberFormat.format(totalOrderCZ)}'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Order ALK'),
                _buildTableCell('0'),
                _buildTableCell('$countOrderALK Toko'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Omzet ALK (CTN)'),
                _buildTableCell('0'),
                _buildTableCell('${param.idNumberFormatDec.format(omzetKartonALK)} CTN'),
              ],
            ),
            _buildSpacerRow(),
            TableRow(
              children: [
                _buildTableCell('Total Rp ALK'),
                _buildTableCell('0'),
                _buildTableCell('Rp. ${param.enNumberFormat.format(totalOrderALK)}'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textAlign: isHeader ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  TableRow _buildSpacerRow() {
    return const TableRow(
      children: [
        SizedBox(height: 10),
        SizedBox(height: 10),
        SizedBox(height: 10),
      ],
    );
  }

  void _showStoreActivityDialog(BuildContext context) {
    FunctionHelper.showDialogs(
      context,
      title: 'Store Activity',
      content: CardListMenuComponent(
        isEnableChevron: false,
        items: [
          CardTileMenu(
            title: const Text('Registrasi Langganan Baru'),
            prefix: Icon(
              Icons.store,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: 
            isStartDay
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'noo'),
                        builder: (context) => NOOPage(
                          user: user,
                          routeName: 'noo',
                          isEndDay: isEndDay,
                          startDayDate: startDayDate,
                        ),
                      ),
                    );
                  }
                : null,
          ),
          CardTileMenu(
            title: const Text('Rute'),
            prefix: Icon(
              Icons.route_rounded,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: 
            isStartDay
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'rute'),
                        builder: (context) => RutePage(
                          user: user,
                          startDayDate: startDayDate,
                          isEndDay: isEndDay,
                          routeName: 'rute',
                        ),
                      ),
                    );
                  }
                : null,
          ),
          CardTileMenu(
            title: const Text('Non Rute'),
            prefix: Icon(
              Icons.share_location,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: isNonRuteValid
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NonRutePage(
                          user: user,
                          startDayDate: startDayDate,
                          isEndDay: isEndDay,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showFilesDialog(BuildContext context) {
    FunctionHelper.showDialogs(
      context,
      content: CardListMenuComponent(
        isEnableChevron: false,
        items: [
          CardTileMenu(
            title: const Text('LASH'),
            prefix: Icon(
              Icons.file_download,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: isEndDay
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'pdfLash'),
                        builder: (context) => PreviewLashPage(
                          user: user,
                          routeName: 'pdfLash',
                          startDayDate: startDayDate,
                        ),
                      ),
                    );
                  }
                : null,
          ),
          CardTileMenu(
            title: const Text('Send Unsent Images'),
            prefix: Icon(
              Icons.upload_file,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: isStartDay
                ? () async {
                    await confirmSendUnsentImages();
                  }
                : null,
          ),
          CardTileMenu(
            title: const Text('Send Log'),
            prefix: Icon(
              Icons.send_and_archive_sharp,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: isStartDay
                ? () async {
                    await confirmSendLog();
                  }
                : null,
          ),
          CardTileMenu(
            title: const Text('Send Backup Images'),
            prefix: Icon(
              Icons.upload_file,
              color: ColorHelper.primary,
              size: 24 * textScaleFactor(context),
            ),
            onPressed: isStartDay
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'backup'),
                        builder: (context) => BackupPage(
                          user: user,
                          startDayDate: startDayDate,
                          routeName: 'backup',
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}