import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'updateapp_page.dart';
import 'package:path/path.dart' as cpath;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:battery_info/battery_info_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/api_cont.dart' as capi;
import 'controller/database_cont.dart' as cdb;
import 'controller/salesman_cont.dart' as csf;
import 'controller/other_cont.dart' as cother;
import 'controller/log_cont.dart' as clog;
import 'models/salesman.dart' as msf;
import 'models/package.dart' as mpck;
import 'models/globalparam.dart' as param;
import 'models/database.dart' as mdbconfig;
import 'style/css.dart' as css;

String? street = '';
String? subLocality = '';
String? subAdministrativeArea = '';
String? postalCode = '';
late Placemark placeGPS;
final service = FlutterBackgroundService();
int checkTbl = 0;
int checkInitData = 0;
final _deviceInfo = DeviceInfoPlugin();
String? _msgToken;
String msgChangeUser = '';
// String? token = '';

/// Create a AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 950) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

Widget loadingProgress(double scaleVal) {
  return SizedBox(
      height: 35 * scaleVal,
      width: 35 * scaleVal,
      child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black, size: 35 * scaleVal)));
}

void alertDialogForm(String msg, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Container(
                  color: css.titleDialogColor(),
                  padding: const EdgeInsets.all(5),
                  child: const Text('Alert!')),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              children: [
                Text(msg),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            );
          }));
}

//sugeng remark push notif
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // try {
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: param.apiKey,
//             appId: param.appId,
//             messagingSenderId: param.messagingSenderId,
//             projectId: param.projectId));
//   }
//   print("Handling a background message: ${message.messageId}");
//   await setupFlutterNotifications();
// //     //sugeng remark set gps notif
// //     // if (message.notification!.title == 'on' ||
// //     //     message.notification!.title == 'off') {
// //     //   service.invoke('stopService');

// //     //   var varTimer = message.notification!.body;
// //     //   var number = num.tryParse(varTimer!);
// //     //   final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     //   final String? fdKodeSF = prefs.getString('fdKodeSF');
// //     //   final String? fdKodeDepo = prefs.getString('fdKodeDepo');
// //     //   final String? fdTanggal = prefs.getString('startDayDate');
// //     //   final double? fdLa = prefs.getDouble('fdLa');
// //     //   final double? fdLg = prefs.getDouble('fdLg');
// //     //   try {
// //     //     if (fdLa != null || fdLg != null) {
// //     //       try {
// //     //         await placemarkFromCoordinates(fdLa!, fdLg!)
// //     //             .then((value) {
// //     //               placeGPS = value.first;

// //     //               street = placeGPS.street;
// //     //               subLocality = placeGPS.subLocality;
// //     //               subAdministrativeArea = placeGPS.subAdministrativeArea;
// //     //               postalCode = placeGPS.postalCode;
// //     //             })
// //     //             .timeout(Duration(seconds: param.gpsTimeOut))
// //     //             .onError((error, stackTrace) {
// //     //               street = '';
// //     //               subLocality = '';
// //     //               subAdministrativeArea = '';
// //     //               postalCode = '';
// //     //             });
// //     //       } on TimeoutException catch (e) {
// //     //         street = '';
// //     //         subLocality = '';
// //     //         subAdministrativeArea = '';
// //     //         postalCode = '';
// //     //       } on Exception catch (e) {
// //     //         street = '';
// //     //         subLocality = '';
// //     //         subAdministrativeArea = '';
// //     //         postalCode = '';
// //     //       }

// //     //       await capi.sendGPStoServer(
// //     //           fdKodeSF!,
// //     //           fdLa.toString(),
// //     //           fdLg.toString(),
// //     //           (await BatteryInfoPlugin().androidBatteryInfo)!
// //     //               .batteryLevel
// //     //               .toString(),
// //     //           street,
// //     //           subLocality,
// //     //           subAdministrativeArea,
// //     //           postalCode,
// //     //           'Tracker ${message.notification!.title}',
// //     //           '',
// //     //           fdKodeDepo!,
// //     //           fdTanggal!,
// //     //           param.dateTimeFormatDB.format(DateTime.now()));
// //     //     }

// //     //     if (message.notification!.title == 'on') {
// //     //       if (number != null) {
// //     //         await clog.updateTimerParameter(int.parse(varTimer));
// //     //       } else {
// //     //         int timerDuration = await clog.getTimerDuration('off');
// //     //         await clog.updateTimerParameter(timerDuration);
// //     //       }
// //     //     } else if (message.notification!.title == 'off') {
// //     //       int timerDuration = await clog.getTimerDuration('off');
// //     //       await clog.updateTimerParameter(timerDuration);
// //     //     }
// //     //   } on TimeoutException {
// //     //     print('error GPS timeout');
// //     //   }

// //     //   Future.delayed(const Duration(seconds: 3))
// //     //       .then((value) => service.startService());
// //     // }
// //     //sugeng end remark gps notif

// //     // If you're going to use other Firebase services in the background, such as Firestore,
// //     // make sure you call `initializeApp` before using other Firebase services.
// //     print('Handling a background message ${message.messageId}');
//   // } catch (e) {
//   //   print('error call service ');
//   // showLocalNotification('error job: $e');
//   // }
// }

// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'high_importance_channel', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//   // channel = const AndroidNotificationChannel(
//   //   param.channelNotifId, // id
//   //   param.channelNotifDesc, // title
//   //   description:
//   //       'This channel is used for important notifications.', // description
//   //   importance: Importance.high,
//   // );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@drawable/ic_launcher');

//   // if (Platform.isIOS) {
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: initializationSettingsAndroid,
//       // iOS: DarwinInitializationSettings(),
//     ),
//     onDidReceiveNotificationResponse: notificationHandler,
//     onDidReceiveBackgroundNotificationResponse: notificationHandler,
//   );

//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void notificationHandler(NotificationResponse details) {
//   print('notif click: ${details.payload}');
// }

// void showFlutterNotification(RemoteMessage message) async {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null) {
//     // flutterLocalNotificationsPlugin.show(
//     //     notification.hashCode,
//     //     notification.title,
//     //     notification.body,
//     //     NotificationDetails(
//     //       android: AndroidNotificationDetails(
//     //           param.channelNotifId, param.channelNotifDesc,
//     //           channelDescription: channel.description,
//     //           // largeIcon:
//     //           //     const DrawableResourceAndroidBitmap('@drawable/ic_launcher'),
//     //           styleInformation: const BigTextStyleInformation('')),
//     //     ),
//     //     payload: notification.android!.clickAction);
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel', // ID channel, bisa hardcoded
//             'high_importance_channel', // Nama channel
//             importance: Importance.high,
//             priority: Priority.high,
//           ),
//         ),
//         payload: notification.android!.clickAction);
//   }
// }
// // //--push notif

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   return true;
// }

// // void showLocalNotification(String msg) {
// //   /// OPTIONAL when use custom notification
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   flutterLocalNotificationsPlugin.show(
// //     99,
// //     'Service',
// //     msg,
// //     const NotificationDetails(
// //       android: AndroidNotificationDetails(
// //         'my_foreground',
// //         'MY FOREGROUND SERVICE',
// //         channelDescription: 'This channel is used for important notifications.',
// //         channelShowBadge: true,
// //         category: AndroidNotificationCategory.message,
// //         styleInformation: BigTextStyleInformation(''),
// //       ),
// //     ),
// //   );
// // }

// // //background process
// @pragma('vm:entry-point')
// void onStart(ServiceInstance serviceIns) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   if (serviceIns is AndroidServiceInstance) {
//     serviceIns.on('setAsForeground').listen((event) {
//       serviceIns.setAsForegroundService();
//     });

//     serviceIns.on('setAsBackground').listen((event) {
//       serviceIns.setAsBackgroundService();
//     });
//   }

//   serviceIns.on('stopService').listen((event) {
//     serviceIns.stopSelf();
//   });

//   //sugeng remark job timer notif
//   // // bring to foreground
//   // //cuma test per detik kalau live ganti jadi 5 menit
//   // int timerDuration = await clog.getTimerDuration('on');
//   // print('timer: $timerDuration');
//   // // print('timer: $timerDuration');
//   // Timer.periodic(Duration(minutes: timerDuration), (timer) async {
//   //   try {
//   //     bool isGPSStart = await handlePermission();

//   //     if (isGPSStart) {
//   //       /// you can see this log in logcat
//   //       Position position = const Position(
//   //           longitude: 0,
//   //           latitude: 0,
//   //           timestamp: null,
//   //           accuracy: 0,
//   //           altitude: 0,
//   //           heading: 0,
//   //           speed: 0,
//   //           speedAccuracy: 0);

//   //       try {
//   //         position = await Geolocator.getCurrentPosition(
//   //             desiredAccuracy: LocationAccuracy.high,
//   //             timeLimit: Duration(seconds: param.gpsTimeOut));
//   //       } on TimeoutException {
//   //         print('error GPS timeout');
//   //       } catch (e) {
//   //         print('error: $e');
//   //       }

//   //       if (position.latitude != 0 && position.longitude != 0) {
//   //         try {
//   //           await placemarkFromCoordinates(
//   //                   position.latitude, position.longitude)
//   //               .then((value) {
//   //                 placeGPS = value.first;

//   //                 street = placeGPS.street;
//   //                 subLocality = placeGPS.subLocality;
//   //                 subAdministrativeArea = placeGPS.subAdministrativeArea;
//   //                 postalCode = placeGPS.postalCode;
//   //               })
//   //               .timeout(Duration(seconds: param.gpsTimeOut))
//   //               .onError((error, stackTrace) {
//   //                 street = '';
//   //                 subLocality = '';
//   //                 subAdministrativeArea = '';
//   //                 postalCode = '';
//   //               });
//   //         } on TimeoutException catch (e) {
//   //           street = '';
//   //           subLocality = '';
//   //           subAdministrativeArea = '';
//   //           postalCode = '';
//   //         } on Exception catch (e) {
//   //           street = '';
//   //           subLocality = '';
//   //           subAdministrativeArea = '';
//   //           postalCode = '';
//   //         }

//   //         String battLevel = (await BatteryInfoPlugin().androidBatteryInfo)!
//   //             .batteryLevel
//   //             .toString();

//   //         // showLocalNotification(
//   //         //     'Battery: $battLevel %\nLog Position: ${position.latitude}, ${position.longitude}');
//   //         print(
//   //             'Battery: $battLevel %\nLog Position: ${position.latitude}, ${position.longitude}');

//   //         String gpsEvent = '';

//   //         if (!position.isMocked) {
//   //           gpsEvent = 'On Travel';
//   //         } else {
//   //           gpsEvent = 'Mock GPS';
//   //         }
//   //         final SharedPreferences prefs = await SharedPreferences.getInstance();
//   //         final String? fdTanggal = prefs.getString('startDayDate');

//   //         await prefs.setDouble('fdLa', position.latitude);
//   //         await prefs.setDouble('fdLg', position.longitude);
//   //         if (fdTanggal == null) {
//   //           await clog.insertGpsLog(
//   //               position.latitude.toString(),
//   //               position.longitude.toString(),
//   //               (await BatteryInfoPlugin().androidBatteryInfo)!
//   //                   .batteryLevel
//   //                   .toString(),
//   //               street,
//   //               subLocality,
//   //               subAdministrativeArea,
//   //               postalCode,
//   //               gpsEvent,
//   //               '',
//   //               '',
//   //               '',
//   //               param.dateTimeFormatDB.format(DateTime.now()));
//   //         } else {
//   //           await clog.insertGpsLog(
//   //               position.latitude.toString(),
//   //               position.longitude.toString(),
//   //               (await BatteryInfoPlugin().androidBatteryInfo)!
//   //                   .batteryLevel
//   //                   .toString(),
//   //               street,
//   //               subLocality,
//   //               subAdministrativeArea,
//   //               postalCode,
//   //               gpsEvent,
//   //               '',
//   //               '',
//   //               fdTanggal,
//   //               param.dateTimeFormatDB.format(DateTime.now()));
//   //         }
//   //         String errorMsg = '';
//   //         String dbPath = await getDatabasesPath();
//   //         mdbconfig.dbFullPath = cpath.join(dbPath, mdbconfig.dbName);
//   //         clog.getSFLogIn().then((user) async {
//   //           if (user != null) {
//   //             try {
//   //               String dbPathLog = await getDatabasesPath();
//   //               mdbconfig.logFullPath =
//   //                   cpath.join(dbPathLog, mdbconfig.dbName2);

//   //               capi.sendLogDevicetoServer(
//   //                   user.fdKodeDepo,
//   //                   user.fdKodeSF,
//   //                   user.fdToken,
//   //                   '',
//   //                   param.dateTimeFormatDB.format(DateTime.now()));
//   //             } catch (e) {
//   //               errorMsg = e.toString();
//   //             }
//   //           }
//   //         });

//   //         if (errorMsg.isEmpty) {
//   //           // test using external plugin
//   //           String? device;
//   //           if (Platform.isAndroid) {
//   //             final androidInfo = await _deviceInfo.androidInfo;
//   //             device = androidInfo.model;
//   //           }

//   //           if (Platform.isIOS) {
//   //             final iosInfo = await _deviceInfo.iosInfo;
//   //             device = iosInfo.model;
//   //           }

//   //           serviceIns.invoke(
//   //             'update',
//   //             {
//   //               "current_date": DateTime.now().toIso8601String(),
//   //               "device": device,
//   //             },
//   //           );
//   //         } else {
//   //           showLocalNotification('error job: $errorMsg');
//   //         }
//   //       } else {
//   //         print('error gps time out');
//   //       }
//   //     } else {
//   //       showLocalNotification('error gps tidak on');
//   //     }
//   //   } catch (e) {
//   //     showLocalNotification('error job: $e');
//   //   }
//   // });
//   //sugeng end remark job timer notif
// }
//sugeng end remark

//sugeng add notif new coding for CRM 30.06.2025
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
//sugeng end add notif new coding for CRM 30.06.2025

Future<void> main() async {
  // await handlePermission();
  // WidgetsFlutterBinding.ensureInitialized();

  //push notif
  // Set the background messaging handler early on, as a named top-level function
  // if (Firebase.apps.isEmpty) {
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: param.apiKey,
  //         appId: param.appId,
  //         messagingSenderId: param.messagingSenderId,
  //         projectId: param.projectId));
  // }
  print(1);
  //sugeng remark call push notif
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await setupFlutterNotifications();
  //sugeng end remark call push notif

//sugeng add notif new coding for CRM 30.06.2025
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Konfigurasi notification untuk Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//sugeng end add notif new coding for CRM 30.06.2025

  runApp(MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade300,
          // scaffoldBackgroundColor: Colors.black,
          // textTheme: const TextTheme(
          //   headlineMedium: TextStyle(color: Colors.red),
          //   bodyMedium: TextStyle(color: Colors.purple),
          //   labelMedium: TextStyle(color: Colors.green),
          //   labelLarge: TextStyle(color: Colors.green),
          //   labelSmall: TextStyle(color: Colors.green),
          //   displayMedium: TextStyle(color: Colors.green),
          //   displayLarge: TextStyle(color: Colors.green),
          //   titleMedium: TextStyle(color: Colors.green),
          // ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
          elevatedButtonTheme:
              ElevatedButtonThemeData(style: css.buttonRound()),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 255, 225, 1),
                  disabledForegroundColor:
                      const Color.fromARGB(255, 255, 150, 150))),
          dialogTheme: DialogThemeData(titleTextStyle: css.textHeaderBold()),
          bottomAppBarTheme:
               BottomAppBarThemeData(color: Color.fromARGB(255, 14, 64, 138)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 242, 133, 0))),
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: ScaleSize.textScaleFactor(context)),
            child: child!);
      },
      title: 'Login',
      home: const LoginPage()));

//sugeng add notif new coding for CRM 30.06.2025
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      String? payload = response.payload;
      if (payload != null && payload.startsWith('http')) {
        // Buka URL pakai url_launcher
        if (await canLaunchUrl(Uri.parse(payload))) {
          await launchUrl(Uri.parse(payload),
              mode: LaunchMode.externalApplication);
        } else {
          print('Gagal membuka URL: $payload');
        }
      }
    },
  );
  //sugeng end add notif new coding for CRM 30.06.2025
}

//sugeng add notif new coding for CRM 30.06.2025
void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Izin notifikasi diberikan');
  } else {
    print('Izin notifikasi ditolak');
  }
}

void initFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Pesan diterima saat app terbuka');
    if (message.notification != null) {
      showFlutterNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notifikasi diklik saat app di background');
  });
}

void getToken() async {
  _msgToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $_msgToken");
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  String? clickUrl = message.data['url']; // Ambil URL dari data FCM

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: clickUrl, // kirim URL sebagai payload
    );
  }
}

void checkInitialMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    String? url = initialMessage.data['url'];
    if (url != null && url.startsWith('http')) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }
}

//sugeng end add notif new coding for CRM 30.06.2025

Future<bool> handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();

    return false;
  }

  //Request Permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  //sugeng add notif new coding for CRM 30.06.2025
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Izin notifikasi diberikan');
  } else {
    print('Izin notifikasi ditolak');
    return false;
  }
  //sugeng end add notif new coding for CRM 30.06.2025

  return true;
}

Future<void> initializeService() async {
  LocationPermission permission;
  try {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
      }
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
      }
    }
    if (permission != LocationPermission.denied) {
      // Position position =
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      /// OPTIONAL, using custom notification channel id
      const AndroidNotificationChannel channelBackground =
          AndroidNotificationChannel(
        'my_foreground', // id
        'MY FOREGROUND SERVICE', // title
        description:
            'This channel is used for important notifications.', // description
        importance:
            Importance.high, // importance must be at low or higher level
        playSound: false,
        showBadge: true,
        enableVibration: true,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_launcher');

      // if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: initializationSettingsAndroid,
          // iOS: DarwinInitializationSettings(),
        ),
      );

//sugeng remark notif
      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(channelBackground);

      // await service.configure(
      //   androidConfiguration: AndroidConfiguration(
      //     // this will be executed when app is in foreground or background in separated isolate
      //     onStart: onStart,

      //     // auto start service
      //     autoStart: false,
      //     isForegroundMode: true,
      //     notificationChannelId: 'my_foreground', // param.channelNotifId, //
      //     foregroundServiceNotificationId: 99,
      //   ),
      //   iosConfiguration: IosConfiguration(
      //     // auto start service
      //     autoStart: false,

      //     // this will be executed when app is in foreground in separated isolate
      //     onForeground: onStart,

      //     // you have to enable background fetch capability on xcode project
      //     onBackground: onIosBackground,
      //   ),
      // );
//sugeng end remark

      // Future.delayed(const Duration(seconds: 3))
      //     .then((value) => service.startService());
    }
  } catch (e) {
    throw Exception(e);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LayerLogin();
}

class LayerLogin extends State<LoginPage> {
  GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  TextEditingController txtUserNameControl = TextEditingController();
  TextEditingController txtPasswordControl = TextEditingController();
  bool bObscureText = true;
  bool isLoading = false;
  late msf.Salesman? fLoginResult;
  String version = '';
  bool isPassInitDataKeyEmpty = false;
  // String mobileNumber = '';
  // List<SimCard> listSimCard = [];

  Future<void> sessionExpired() async {
    await cdb.logOut();
    service.invoke("stopService");

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Session expired')));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }

    try {
      // listSimCard = (await MobileNumber.getSimCards)!;
      // mobileNumber = (await MobileNumber.mobileNumber)!;
    } on PlatformException catch (e) {
      //sugeng remark notif
      // showLocalNotification('Error mendapat nomor SIM card: ${e.message}');
    }

    if (!mounted) return;

    setState(() {});
  }

  Future<void> listapk() async {
    bool excludeSystemApps = true;
    bool withIcon = true;
    String packageNamePrefix = '';
    List<AppInfo> apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: excludeSystemApps, withIcon:withIcon,packageNamePrefix: packageNamePrefix);
    for (var i = 0; i < apps.length; i++) {
      print(
          '${apps[i].name} | ${apps[i].packageName} | ${apps[i].versionCode} | ${apps[i].versionName}');
    }

    print(apps);
  }

  void yesNoDialogForm(String title) async {
    try {
      if (txtUserNameControl.text.isEmpty) {
        alertDialogForm('Username harus diisi', context);
      } else {
        // final androidInfo = await _deviceInfo.androidInfo;
        AndroidId aid = const AndroidId();
        String? androidid = await aid.getId();
        await initMobileNumberState();

        // if (mobileNumber.isNotEmpty) {
        checkInitData = await capi.getStatusInitData(
            txtUserNameControl.text, androidid!, ''); //mobileNumber);

        if (checkInitData == 1) {
          if (!mounted) return;

          showDialog<void>(
            context: context,
            builder: (BuildContext context) =>
                StatefulBuilder(builder: (context, setState) {
              return SimpleDialog(
                title: Container(
                    color: css.titleDialogColor(),
                    padding: const EdgeInsets.all(5),
                    child: Text('Lanjut $title?')),
                titlePadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await cdb.initialData();

                          service.invoke('stopService');

                          if (await service.isRunning()) {
                            //stop service jika masih running
                            service.invoke('stopService');
                          }

                          if (!mounted) return;

                          Navigator.pop(context);

                          alertDialogForm(
                              'Sukses initial data, mohon login ulang',
                              context);
                        } catch (e) {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                SnackBar(content: Text('error: $e')));
                        }
                      },
                      child: const Text('Ya')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tidak'))
                ],
              );
            }),
          );
        } else if (checkInitData == 401) {
          //responce code 401
          await sessionExpired();
        } else {
          if (!mounted) return;

          alertDialogForm(
              'Anda tidak memiliki izin untuk initial data, silahkan hubungi admin',
              context);
        }
        // } else {
        //   if (!mounted) return;

        //   alertDialogForm(
        //       'Gagal initial data. Aktifkan izin akses phone dan pastikan SIM card terpasang nomor aktif',
        //       context);
        // }
      }
    } catch (e) {
      if (!mounted) return;

      alertDialogForm('error: $e', context);
    }
  }

  Future<void> alertDialog(String notes) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: Text(notes)),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (!mounted) return;

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('error: $e')));
                  }
                },
                child: const Text('OK')),
          ],
        );
      }),
    );
  }

  void generateKeyDialogForm(String title, String deviceID) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          title: Container(
              color: css.titleDialogColor(),
              padding: const EdgeInsets.all(5),
              child: Text(title)),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          children: [
            Row(children: [
              SelectableText(
                deviceID,
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy Generate Key',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: deviceID));
                  await alertDialog('Generate key berhasil di copy');
                },
              ),
            ]),
            const Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'))
          ],
        );
      }),
    );
  }

  Future<bool> checkUpdate() async {
    try {
      PackageInfo packInfo = await PackageInfo.fromPlatform();
      mpck.Package latestPackage = await capi.getPackage(packInfo.appName);

      int iVersion = int.parse(version.replaceAll('.', ''));
      int iLatestVersion =
          int.parse(latestPackage.fdVersion.replaceAll('.', ''));

      if (iVersion < iLatestVersion) {
        // if (25041 < iLatestVersion) {
        if (!mounted) return false;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateAppPage(
                    version: version,
                    fdPath: latestPackage.fdPath,
                    fdFileName: latestPackage.fdFileName)),
            (Route<dynamic> route) => false);

        return false;
      } else {
        if (!mounted) return false;

        alertDialogForm('Versi aplikasi sudah terbaru', context);

        return true;
      }
      //ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to make update. Details: $e')));

      return false;
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initLoad();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String? url = message.data['url'];
      if (url != null && url.startsWith('http')) {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }
    });
  }

//sugeng remark job timer
  // void changeTimer(RemoteMessage message) async {
  //   if (message.notification!.title == 'on' ||
  //       message.notification!.title == 'off') {
  //     service.invoke('stopService');
  //     var varTimer = message.notification!.body;
  //     var number = num.tryParse(varTimer!);

  //     // final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // final String? fdKodeSF = prefs.getString('fdKodeSF');
  //     // final String? fdKodeDepo = prefs.getString('fdKodeDepo');
  //     // final String? fdTanggal = prefs.getString('startDayDate');
  //     // try {
  //     //   Position position = await Geolocator.getCurrentPosition(
  //     //       // forceAndroidLocationManager: true,
  //     //       desiredAccuracy: LocationAccuracy.high,
  //     //       timeLimit: Duration(seconds: param.gpsTimeOut));
  //     //   try {
  //     //     await placemarkFromCoordinates(position.latitude, position.longitude)
  //     //         .then((value) {
  //     //           placeGPS = value.first;

  //     //           street = placeGPS.street;
  //     //           subLocality = placeGPS.subLocality;
  //     //           subAdministrativeArea = placeGPS.subAdministrativeArea;
  //     //           postalCode = placeGPS.postalCode;
  //     //         })
  //     //         .timeout(Duration(seconds: param.gpsTimeOut))
  //     //         .onError((error, stackTrace) {
  //     //           street = '';
  //     //           subLocality = '';
  //     //           subAdministrativeArea = '';
  //     //           postalCode = '';
  //     //         });
  //     //   } on TimeoutException catch (e) {
  //     //     street = '';
  //     //     subLocality = '';
  //     //     subAdministrativeArea = '';
  //     //     postalCode = '';
  //     //   } on Exception catch (e) {
  //     //     street = '';
  //     //     subLocality = '';
  //     //     subAdministrativeArea = '';
  //     //     postalCode = '';
  //     //   }

  //     //   await capi.sendGPStoServer(
  //     //       fdKodeSF!,
  //     //       position.latitude.toString(),
  //     //       position.longitude.toString(),
  //     //       (await BatteryInfoPlugin().androidBatteryInfo)!
  //     //           .batteryLevel
  //     //           .toString(),
  //     //       street,
  //     //       subLocality,
  //     //       subAdministrativeArea,
  //     //       postalCode,
  //     //       'Tracker ${message.notification!.title}',
  //     //       '',
  //     //       fdKodeDepo!,
  //     //       fdTanggal!,
  //     //       param.dateTimeFormatDB.format(DateTime.now()));

  //     //   if (message.notification!.title == 'on') {
  //     //     if (number != null) {
  //     //       await clog.updateTimerParameter(int.parse(varTimer));
  //     //       // await capi.sendLogTracker(fdKodeSF, 'on',
  //     //       //     param.dateTimeFormatDB.format(DateTime.now()), fdToken!);
  //     //     } else {
  //     //       int timerDuration = await clog.getTimerDuration('off');
  //     //       await clog.updateTimerParameter(timerDuration);
  //     //       // await capi.sendLogTracker(fdKodeSF, 'off',
  //     //       //     param.dateTimeFormatDB.format(DateTime.now()), fdToken!);
  //     //     }
  //     //   } else if (message.notification!.title == 'off') {
  //     //     int timerDuration = await clog.getTimerDuration('off');
  //     //     await clog.updateTimerParameter(timerDuration);
  //     //     // await capi.sendLogTracker(fdKodeSF, 'off',
  //     //     //     param.dateTimeFormatDB.format(DateTime.now()), fdToken!);
  //     //   }
  //     // } on TimeoutException {
  //     //   print('error GPS timeout');
  //     // }

  //     Future.delayed(const Duration(seconds: 3))
  //         .then((value) => service.startService());
  //   }

  //   showFlutterNotification(message);
  // }

  void initLoad() async {
    try {
      setState(() {
        isLoading = true;
      });
      // txtUserNameControl.text = '516165';
      // txtUserNameControl.text = '516132';
      // txtUserNameControl.text = '516054';
      // txtUserNameControl.text = '522010';
      // txtUserNameControl.text = '526102';

      //sugeng remark push notif
      // FirebaseMessaging.onMessage.listen(changeTimer);
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print("Got a message in foreground");
      //   if (message.notification != null) {
      //     showFlutterNotification(message);
      //   }
      // });
      // _msgToken = await FirebaseMessaging.instance
      //     .getToken(vapidKey: param.webPushCertificate);
      // await FirebaseMessaging.instance.subscribeToTopic(
      //     param.msgTopic); //bisa kirim pesan per group atau topik (>1 device)
      // print('token msg: $_msgToken');
      //sugeng end remark

      //sugeng add notif new coding for CRM 30.06.2025
      handlePermission();
      initFCM();
      getToken();
      checkInitialMessage();
      //sugeng end add notif new coding for CRM 30.06.2025

      MobileNumber.listenPhonePermission((isPermissionGranted) async {
        if (!isPermissionGranted) {
          await initMobileNumberState();
        }
      });
      //push notif

      PackageInfo packInfo = await PackageInfo.fromPlatform();
      version = packInfo.version;

      Directory? dir = await getExternalStorageDirectory();
      var newDir =
          await Directory('${dir!.path}/ICI/CRM').create(recursive: true);
      param.appDir = newDir.path;

      await cdb.createDB();
      await cdb.createDBLog(); //#LOG
      msf.Salesman? user = await csf.getSFLogIn();

      if (user != null) {
        txtUserNameControl.text = user.fdKodeSF;

        if (user.fdToken.isNotEmpty) {
          //refresh token
          msf.Salesman? result = await capi.refreshToken(
              user.fdKodeSF, user.fdPass!, _msgToken!, version, user.fdToken);

          await cdb.onUpdateAlter();
          if (result!.fdAkses == true) {
            //add sugeng
            PackageInfo packInfo = await PackageInfo.fromPlatform();
            mpck.Package latestPackage =
                await capi.getPackage(packInfo.appName);

            int iVersion = int.parse(version.replaceAll('.', ''));
            int iLatestVersion =
                int.parse(latestPackage.fdVersion.replaceAll('.', ''));

            if (iVersion < iLatestVersion) {
              await sessionExpired();
              alertDialogForm('Ada update App terbaru', context);
            } else {
              await csf.updateSFToken(result);

              //Update token di master sales DB log untuk kirim data GPS via job background
              await clog.updateSFToken(result.fdToken, result.fdKodeSF);

              print('refresh token: ${result.fdToken}');
              //Get key dan SIM device dari server
              // Map<String, dynamic> item = await capi.getKeyDevice(user.fdKodeSF);

              // if (item['data'].isEmpty) {
              // final androidInfo = await _deviceInfo.androidInfo;
              await initMobileNumberState();

              //compare key dan sim device dengan data dari Core
              // if (androidInfo.id == item['fdKeyDevice'] && mobileNumber == item['fdSIM']) {
              bool isDateTimeSettingValid =
                  await cother.dateTimeSettingValidation();

              if (isDateTimeSettingValid) {
                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: 'home'),
                        builder: (context) => HomePage(user: user)),
                    (Route<dynamic> route) => false);
              }
              // } else {
              //   if (!mounted) return;

              //   alertDialogForm('Anda tidak dapat menggunakan device ini', context);
              // }
              // } else if (item['data'] == '401') {
              //   sessionExpired();
              // }
            }
          } else if (result.message == '401') {
            await sessionExpired();
          } else {
            //error
            await cdb.logOut();
            service.invoke("stopService");

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('error: ${result.message}')));

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false);
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PT. Intercallin'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          reverse: true,
          child: Form(
              key: formLoginKey,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo250.png',
                          alignment: Alignment.center),
                      Text('versi $version'),
                      const Padding(padding: EdgeInsets.only(bottom: 50)),
                      TextFormField(
                        controller: txtUserNameControl,
                        decoration: css.textInputStyle(
                            'Username',
                            null,
                            null,
                            Icon(Icons.person_outline,
                                size: 24 * ScaleSize.textScaleFactor(context)),
                            null),
                        // textCapitalization: TextCapitalization.characters,
                        // keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill Username';
                          }

                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      TextFormField(
                        controller: txtPasswordControl,
                        obscureText: bObscureText,
                        autocorrect: false,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: const Color.fromARGB(255, 243, 255, 241),
                            filled: true,
                            hintText: 'Password',
                            border: css.borderOutlineInputRound(),
                            suffixIcon: IconButton(
                                iconSize:
                                    24 * ScaleSize.textScaleFactor(context),
                                onPressed: () {
                                  setState(() {
                                    bObscureText = !bObscureText;
                                  });
                                },
                                icon: Icon(bObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined)),
                            prefixIcon: Icon(Icons.lock_outline,
                                size: 24 * ScaleSize.textScaleFactor(context))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill Password';
                          }

                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      (isLoading
                          ? loadingProgress(ScaleSize.textScaleFactor(context))
                          : ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  bool isJailBroken =false;
                                  bool isDeveloperMode =false;
                                  // bool isJailBroken =
                                  //     await FlutterJailbreakDetection
                                  //         .jailbroken;
                                  // bool isDeveloperMode =
                                  //     await FlutterJailbreakDetection
                                  //         .developerMode;

                                  //Ed1 - 26/09/23 - comment selama develop
                                  if (true) {
                                    // if (!isJailBroken && !isDeveloperMode) {
                                    bool isDateTimeSettingValid = await cother
                                        .dateTimeSettingValidation();
                                    
                                    if (isDateTimeSettingValid) {
                                      if (formLoginKey.currentState!
                                          .validate()) {
                                        bool isDoneUpdate = true;
                                        //await checkUpdate();

                                        if (isDoneUpdate) {
                                          PackageInfo packInfo =
                                              await PackageInfo.fromPlatform();
                                             
                                          fLoginResult = await capi.loginMD(
                                              txtUserNameControl.text,
                                              txtPasswordControl.text,
                                              packInfo.version,
                                              '_msgToken');
                                               print(fLoginResult!.fdAkses!);
                                          if (fLoginResult!.fdAkses!) {
                                            // Map<String, dynamic> item =
                                            //     await capi.getKeyDevice(
                                            //         fLoginResult!.fdKodeSF);

                                            // if (item['data'].isEmpty) {
                                            AndroidId aid = const AndroidId();
                                            String? androidid ='idAndroid';
                                            // String? androidid =
                                            //     await aid.getId();
                                            await initMobileNumberState();
                                            // if (true) {
                                            print('android:'+androidid.toString());
                                            print('fdkey :'+fLoginResult!.fdKeyDevice);
                                            if (androidid ==
                                                fLoginResult!.fdKeyDevice) {
                                              // item['fdKeyDevice']) {
                                              // if (androidInfo.id ==
                                              //         item['fdKeyDevice'] &&
                                              //     mobileNumber ==
                                              //         item['fdSIM']) {
                                              print(
                                                  'token: ${fLoginResult!.fdToken.toString()}');

                                              msgChangeUser =
                                                  await csf.checkIsKodeMdExist(
                                                      fLoginResult!.fdKodeSF);
                                              if (msgChangeUser != '') {
                                                if (!mounted) return;
                                                alertDialogForm(
                                                    msgChangeUser, context);
                                              } else {
                                                await cdb.initDB2(); //#LOG
                                                await cdb.initDB(fLoginResult!);

                                                await cdb.onUpdateAlter();

                                                //Go to home page
                                                if (!mounted) return;

                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings:
                                                            const RouteSettings(
                                                                name: 'home'),
                                                        builder: (context) =>
                                                            HomePage(
                                                                user:
                                                                    fLoginResult!)),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              }
                                            } else {
                                              if (!mounted) return;

                                              alertDialogForm(
                                                  'Anda tidak dapat menggunakan device ini',
                                                  context);
                                            }
                                            // } else if (item['data'] == '401') {
                                            //   await sessionExpired();
                                            // }
                                          } else {
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'error: ${fLoginResult!.message}')));
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          content: Text(
                                              'Deteksi aplikasi error: J-$isJailBroken, D-$isDeveloperMode')));
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('error: $e')));

                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: const Text('Sign in'),
                            )),
                      //Sizebox dengan height "MediaQuery.of(context).viewInsets.bottom" paling bawah untuk
                      // pancing bagian terbawah widget untuk ketarik / scroll ke atas keyboard
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  )))),
      floatingActionButton: (isLoading
          ? const Padding(padding: EdgeInsets.zero)
          : IconButton(
              iconSize: 24 * ScaleSize.textScaleFactor(context),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                showModalBottomSheet(
                    shape: css.borderModalRound(),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('Setting',
                                    style: css.textNormalBold())),
                            Expanded(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          await checkUpdate();

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        icon: Icon(Icons.download_sharp,
                                            size: 24 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                            color: Colors.black),
                                        label: const Text('Update Aplikasi CRM',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        style: const ButtonStyle(
                                            alignment: Alignment.centerLeft)))),
                            const Divider(height: 0),
                            Expanded(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton.icon(
                                        onPressed: () {
                                          yesNoDialogForm('Initial Data');
                                        },
                                        icon: Icon(Icons.restart_alt_rounded,
                                            size: 24 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                            color: Colors.black),
                                        label: const Text('Initial Data',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        style: const ButtonStyle(
                                            alignment: Alignment.centerLeft)))),
                            const Divider(height: 0),
                            Expanded(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          try {
                                            AndroidId aid = const AndroidId();
                                            String? androidid =
                                                await aid.getId();

                                            generateKeyDialogForm(
                                                'Generate Key',
                                                androidid!); //androidInfo.id);
                                          } catch (e) {
                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text('error: $e')));
                                          }
                                        },
                                        icon: Icon(Icons.generating_tokens,
                                            size: 24 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                            color: Colors.black),
                                        label: const Text('Generate Key',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        style: const ButtonStyle(
                                            alignment: Alignment.centerLeft))))
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.settings, color: Colors.black),
            )),
    );
  }
}
