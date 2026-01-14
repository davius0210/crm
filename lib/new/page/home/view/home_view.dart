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
import 'package:crm_apps/new/page/home/controller/home_controller.dart';
import 'package:crm_apps/nonrute_page.dart';
import 'package:crm_apps/noo_page.dart';
import 'package:crm_apps/pdf_lash_page.dart';
import 'package:crm_apps/rencanarute_page.dart';
import 'package:crm_apps/rute_page.dart';
import 'package:crm_apps/stock_page.dart';
import 'package:crm_apps/style/css.dart' as css;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeView extends GetView<HomeController> {
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
  const HomeView({super.key, 
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
  required this.totalOrderCZ});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (_){
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
                            child: Image(image: AssetImage('assets/images/logo250abc.png'),width: 100,color: Colors.white.withOpacity(0.3),
  // Mode Modulate akan mengalikan warna gambar dengan warna di atas
                            colorBlendMode: BlendMode.modulate,)),
                          Row(
                            children: [
                              CircleAvatar(
                                    backgroundColor: ColorHelper.color12,
                                    child: Image.asset('assets/images/UserProfile.png'),radius: 50,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome, ${user.fdNamaSF}', style: TextStyle(fontWeight: FontWeight.bold,),),
                                  Container(
                                    color: ColorHelper.border,
                                    height: 1,
                                    width: MediaQuery.of(context).size.width/1.8,
                                  ),
                                  Text('${user.fdKodeDepo} - ${user.fdNamaDepo}', style: TextStyle(color: ColorHelper.hint, fontSize: 12),),
                                  Text('${user.fdKodeSF}', style: TextStyle(color: ColorHelper.primary, fontSize: 12),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    CardComponent(
                      content: RichText(
                          textScaleFactor: controller.textScaleFactor(context),
                          text: TextSpan(
                              style: css.textSmallSizeBlack(),
                              children: [
                                TextSpan(
                                    text: 'Tanggal: ',
                                    style: css.textNormalBold()),
                                TextSpan(
                                    text: param.dtFormatViewMMM.format(
                                        param.dtFormatView.parse(todayDate))),
                              ])),
                    ),
                    SizedBox(height: 5,),
                    CardComponent(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Container(
                            height: 90,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    IconButtonComponent(
                                      label: 'Sales Activity',
                                      color: ColorHelper.primary,
                                      child: Icon(CupertinoIcons.bag, color: Colors.white,),
                                      onPressed: (){
                                        FunctionHelper.showDialogs(context,
                                        title: 'Sales Activity',
                                        content: CardListMenuComponent(
                                          isEnableChevron: false,
                                          items: [
                                            CardTileMenu(
                                              title: Text('Stock'),
                                              prefix: Icon(Icons.download_rounded,
                                                  color: ColorHelper.primary,
                                                  size:
                                                      24 * controller.textScaleFactor(context)),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings:
                                                            const RouteSettings(name: 'stock'),
                                                        builder: (context) => StockPage(
                                                            user: user,
                                                            startDayDate: startDayDate,
                                                            isEndDay: isEndDay,
                                                            routeName: 'stock')));
                                              }
                                            ),
                                            CardTileMenu(
                                              title: Text('Rencana Rute'),
                                              prefix: Icon(Icons.route_outlined,
                                                  color: ColorHelper.primary,
                                                  size:
                                                      24 * controller.textScaleFactor(context)),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings: const RouteSettings(
                                                            name: 'rencanarute'),
                                                        builder: (context) => RencanaRutePage(
                                                            user: user,
                                                            startDayDate: startDayDate,
                                                            isEndDay: isEndDay,
                                                            routeName: 'rencanarute')));
                                              }
                                            ),
                                            CardTileMenu(
                                              title: Text('List Invoice'),
                                              prefix: Icon(Icons.list_alt_rounded,
                                                  color: ColorHelper.primary,
                                                  size:
                                                      24 * controller.textScaleFactor(context)),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings: const RouteSettings(
                                                            name: 'listinvoice'),
                                                        builder: (context) => ListInvoicePage(
                                                            user: user,
                                                            startDayDate: startDayDate,
                                                            isEndDay: isEndDay,
                                                            routeName: 'listinvoice')));
                                              }
                                            ),
                                            CardTileMenu(
                                              title: Text('Coverage Area'),
                                              prefix: Icon(Icons.place_rounded,
                                                  color: ColorHelper.primary,
                                                  size:
                                                      24 * controller.textScaleFactor(context)),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings: const RouteSettings(
                                                            name: 'coveragearea'),
                                                        builder: (context) => CoverageAreaPage(
                                                            user: user,
                                                            startDayDate: startDayDate,
                                                            routeName: 'coveragearea')));
                                              }
                                            ),
                                            CardTileMenu(
                                              title: Text('Limit Kredit'),
                                              prefix: Icon(Icons.credit_card,
                                                  color: ColorHelper.primary,
                                                  size:
                                                      24 * controller.textScaleFactor(context)),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings: const RouteSettings(
                                                            name: 'limitkredit'),
                                                        builder: (context) => LimitKreditPage(
                                                            user: user,
                                                            startDayDate: startDayDate,
                                                            isEndDay: isEndDay,
                                                            routeName: 'limitkredit')));
                                              }
                                            ),
                                          ],
                                        )
                                        
                                        );
                                      },
                                    ),
                                    IconButtonComponent(
                                      label: 'Store Activity',
                                      color: ColorHelper.secondary,
                                      child: Icon(CupertinoIcons.shopping_cart, color: Colors.white,),
                                      onPressed: (){
                                        FunctionHelper.showDialogs(context,
                                          title: 'Store Activity',
                                          content: CardListMenuComponent(
                                            isEnableChevron: false,
                                            items: [
                                              user.fdTipeSF == '1' 
                                              ? CardTileMenu(
                                                title: Text('Registrasi Langganan Baru'),
                                                prefix: Icon(Icons.store,
                                                  color: ColorHelper.primary,
                                                  size: 24 *
                                                      controller.textScaleFactor(context)),
                                                onPressed:isStartDay
                                                ? () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            settings:
                                                                const RouteSettings(
                                                                    name: 'noo'),
                                                            builder: (context) =>
                                                                NOOPage(
                                                                    user: user,
                                                                    routeName: 'noo',
                                                                    isEndDay: isEndDay,
                                                                    startDayDate:
                                                                        startDayDate)));
                                                  } : null,
                                                      ) :  CardTileMenu(
                                                        title: Text('Registrasi Langganan Baru'),
                                                        prefix: Icon(Icons.store,
                                                          color: ColorHelper.primary,
                                                          size: 24 *
                                                              controller.textScaleFactor(context)),
                                                        onPressed:isStartDay
                                                ? () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            settings:
                                                                const RouteSettings(
                                                                    name: 'noo'),
                                                            builder: (context) =>
                                                                NOOPage(
                                                                    user: user,
                                                                    routeName: 'noo',
                                                                    isEndDay: isEndDay,
                                                                    startDayDate:
                                                                        startDayDate)));
                                                  } : null,
                                              ),
                                              CardTileMenu(
                                                title: Text('Rute'),
                                                prefix: Icon(Icons.route_rounded,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                onPressed:(isStartDay
                                                    ? () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                settings: const RouteSettings(
                                                                    name: 'rute'),
                                                                builder: (context) => RutePage(
                                                                    user: user,
                                                                    startDayDate: startDayDate,
                                                                    isEndDay: isEndDay,
                                                                    routeName: 'rute')));
                                                      }
                                                    : null)
                                              ),
                                              CardTileMenu(
                                                title: Text('Non Rute'),
                                                prefix: Icon(Icons.share_location,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                onPressed:(isNonRuteValid
                                                  ? () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NonRutePage(
                                                                      user: user,
                                                                      startDayDate:
                                                                          startDayDate,
                                                                      isEndDay: isEndDay)));
                                                    }
                                                  : null)
                                              ),
                                              
                                              
                                            ],
                                          )
                                        );
                                      },
                                    ),
                                    IconButtonComponent(
                                      label: 'Files',
                                      color: ColorHelper.color24,
                                      child: Icon(Icons.storage, color: Colors.white,),
                                      onPressed: (){
                                        FunctionHelper.showDialogs(context,
                                          content: CardListMenuComponent(
                                            isEnableChevron: false,
                                            items: [
                                              CardTileMenu(
                                                title: Text('LASH'),
                                                prefix: Icon(Icons.file_download,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                onPressed:(isEndDay
                                                  ? () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              settings: const RouteSettings(
                                                                  name: 'pdfLash'),
                                                              builder: (context) =>
                                                                  PreviewLashPage(
                                                                    user: user,
                                                                    routeName: 'pdfLash',
                                                                    startDayDate:
                                                                        startDayDate)));
                                                    }
                                                  : null)
                                              ),
                                              CardTileMenu(
                                                title: Text('Send Unsent Images'),
                                                prefix: Icon(Icons.upload_file,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                onPressed:(isStartDay
                                                  ? ()async {
                                                      await confirmSendUnsentImages();
                                                    }
                                                  : null)
                                              ),
                                              CardTileMenu(
                                                title: Text('Send Log'),
                                                prefix: Icon(Icons.send_and_archive_sharp,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                            onPressed:(isStartDay
                                                ? () async {
                                                    await confirmSendLog();
                                                  }
                                                : null)
                                              ),
                                              CardTileMenu(
                                                title: Text('Send Backup Images'),
                                                prefix: Icon(Icons.upload_file,
                                                    color: ColorHelper.primary,
                                                    size:
                                                        24 * controller.textScaleFactor(context)),
                                                            onPressed:(isStartDay
                                                          ? () {
                                                              Navigator.pop(context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      settings: const RouteSettings(
                                                                          name: 'backup'),
                                                                      builder: (context) =>
                                                                          BackupPage(
                                                                              user: user,
                                                                              startDayDate:
                                                                                  startDayDate,
                                                                              routeName: 'backup')));
                                                            }
                                                          : null)
                                              ),
                                            ]
                                          )
                                        );
                                      },
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    
                    Expanded(
                      child: CardComponent(content: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: css.boxDecorTitle(),
                                  padding: const EdgeInsets.all(5),
                                  height: 50,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text('Notifikasi',
                                                style:
                                                    css.textHeaderBold())),
                                      ])),
                              if (listNotif.isNotEmpty)
                                ...listNotif.map((entry) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, bottom: 5),
                                        child: SizedBox(
                                          child: TextButton(
                                            onPressed: () async {
                                              final url = entry['fdUrl'];
                                              if (url != null &&
                                                  await canLaunchUrl(
                                                      Uri.parse(url))) {
                                                await launchUrl(
                                                    Uri.parse(url));
                                              }
                                            },
                                            child: badges.Badge(
                                              position: badges.BadgePosition
                                                  .topEnd(
                                                      top: -3, end: -33),
                                              showBadge: true,
                                              badgeContent: Text(
                                                entry['fdBadges']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              badgeAnimation: const badges
                                                  .BadgeAnimation.rotation(
                                                animationDuration:
                                                    Duration(seconds: 1),
                                                colorChangeAnimationDuration:
                                                    Duration(seconds: 1),
                                                loopAnimation: false,
                                                curve: Curves.fastOutSlowIn,
                                                colorChangeAnimationCurve:
                                                    Curves.easeInCubic,
                                              ),
                                              badgeStyle:
                                                  const badges.BadgeStyle(
                                                shape: badges
                                                    .BadgeShape.circle,
                                                badgeColor: Colors.red,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                // borderRadius:
                                                //     BorderRadius.circular(
                                                //         1),
                                                // borderSide: BorderSide(
                                                //     color: Colors.white,
                                                //     width: 1),
                                                // borderGradient:
                                                //     badges.BadgeGradient
                                                //         .linear(colors: [
                                                //   Colors.red,
                                                //   Colors.black
                                                // ]),
                                                // badgeGradient: badges
                                                //     .BadgeGradient.linear(
                                                //   colors: [
                                                //     Colors.blue,
                                                //     Colors.yellow
                                                //   ],
                                                //   begin:
                                                //       Alignment.topCenter,
                                                //   end: Alignment
                                                //       .bottomCenter,
                                                // ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                entry['fdLabel'] ?? '---',
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList()
                              else
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, bottom: 5),
                                      child: Text(
                                        'Tidak ada notifikasi',
                                        style: TextStyle(
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                              Container(
                                  decoration: css.boxDecorTitle(),
                                  padding: const EdgeInsets.all(5),
                                  height: 50,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text('Daily Summary',
                                                style:
                                                    css.textHeaderBold())),
                                      ])),
                              const Padding(padding: EdgeInsets.all(5)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: ColorHelper.primary,width: 2),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            offset: Offset(2,3)
                                    
                                          )
                                        ]
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Plan Rute',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ))
                                                      ]),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(5)),
                                                  Text(
                                                    mapSFSummary['rute']
                                                        .toString(),
                                                  )
                                                ],
                                              ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(color: ColorHelper.primary,width: 2,),
                                          bottom: BorderSide(color: ColorHelper.primary,width: 2),
                                        ),
                                        
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            offset: Offset(2,3)
                                    
                                          )
                                        ]
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isNonRuteValid) {
                                            // Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NonRutePage(
                                                  user: user,
                                                  startDayDate: startDayDate,
                                                  isEndDay: isEndDay,
                                                ),
                                              ),
                                            );
                                          } else {
                                            null;
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Text('Non Rute',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold))
                                                ]),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.all(5)),
                                            Text(
                                              mapSFSummary['nonrute']
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: ColorHelper.primary,width: 2),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            offset: Offset(2,3)
                                    
                                          )
                                        ]
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Total Rute',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ))
                                                      ]),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(5)),
                                                  Text(
                                                    mapSFSummary['rute']
                                                        .toString(),
                                                  )
                                                ],
                                              )
                                    ),
                                  ),
                                  
                                ],
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Container(
                                  decoration: css.boxDecorTitle(),
                                  padding: const EdgeInsets.all(5),
                                  height: 50,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                'Target dan Realisasi',
                                                style:
                                                    css.textHeaderBold())),
                                      ])),
                              const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text(''),
                              //     ),
                              //     SizedBox(
                              //       width: 90 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Target Harian',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 90 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Realisasi Hari ini',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('NOO'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           '${countNoo.toString()} Toko',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Call'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           '${countCall.toString()} Toko',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Order CZ'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           ' ${countOrderCZ.toString()} Toko',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Omzet CZ (LSN)'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           '${param.idNumberFormatDec.format(omzetLusinCZ).toString()} LSN',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Total Rp CZ'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           'Rp. ${param.enNumberFormat.format(totalOrderCZ).toString()}',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Order ALK'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           '${countOrderALK.toString()} Toko',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Omzet ALK (CTN)'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           '${param.idNumberFormatDec.format(omzetKartonALK).toString()} CTN',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(padding: EdgeInsets.all(5)),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     SizedBox(
                              //       width: 120 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('Total Rp ALK'),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: const Text('0',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //     SizedBox(
                              //       width: 100 *
                              //           controller.textScaleFactor(context),
                              //       child: Text(
                              //           'Rp. ${param.enNumberFormat.format(totalOrderALK).toString()}',
                              //           textAlign: TextAlign.center),
                              //     ),
                              //   ],
                              // ),
                              Table(
                                  // Mengatur perataan vertikal konten di dalam cell
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  // Mengatur lebar kolom (sesuai dengan lebar di kodingan asli Anda)
                                  columnWidths: {
                                    0: FixedColumnWidth(120 * controller.textScaleFactor(context)),
                                    1: FixedColumnWidth(100 * controller.textScaleFactor(context)),
                                    2: FixedColumnWidth(100 * controller.textScaleFactor(context)),
                                  },
                                  children: [
                                    // --- HEADER TABLE ---
                                    TableRow(
                                      children: [
                                        const SizedBox(), // Kolom kosong pertama
                                        _buildTableCell('Target Harian', isHeader: true),
                                        _buildTableCell('Realisasi Hari ini', isHeader: true),
                                      ],
                                    ),
                                    
                                    // Memberikan spasi antar baris (pengganti Padding(5))
                                    _buildSpacerRow(),

                                    // --- BARIS NOO ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('NOO'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${countNoo.toString()} Toko'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS CALL ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Call'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${countCall.toString()} Toko'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS ORDER CZ ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Order CZ'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${countOrderCZ.toString()} Toko'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS OMZET CZ ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Omzet CZ (LSN)'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${param.idNumberFormatDec.format(omzetLusinCZ)} LSN'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS TOTAL RP CZ ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Total Rp CZ'),
                                        _buildTableCell('0'),
                                        _buildTableCell('Rp. ${param.enNumberFormat.format(totalOrderCZ)}'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS ORDER ALK ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Order ALK'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${countOrderALK.toString()} Toko'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS OMZET ALK ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Omzet ALK (CTN)'),
                                        _buildTableCell('0'),
                                        _buildTableCell('${param.idNumberFormatDec.format(omzetKartonALK)} CTN'),
                                      ],
                                    ),

                                    _buildSpacerRow(),

                                    // --- BARIS TOTAL RP ALK ---
                                    TableRow(
                                      children: [
                                        _buildTableCell('Total Rp ALK'),
                                        _buildTableCell('0'),
                                        _buildTableCell('Rp. ${param.enNumberFormat.format(totalOrderALK)}'),
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          )),),
                    )
                    
                  ],
                ),
              ),
            ),
          ),
            
          ],
        );
    });
    
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

  // Helper untuk membuat baris kosong sebagai pemisah (pengganti Padding(5))
  TableRow _buildSpacerRow() {
    return const TableRow(
      children: [
        SizedBox(height: 10),
        SizedBox(height: 10),
        SizedBox(height: 10),
      ],
    );
  }
}
