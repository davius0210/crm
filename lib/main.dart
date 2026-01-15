import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:crm_apps/new/helper/function_helper.dart';
import 'package:crm_apps/new/page/login/view/login_view.dart';
import 'package:flutter/services.dart';
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

late AndroidNotificationChannel channel;

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print(1);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      String? payload = response.payload;
      if (payload != null && payload.startsWith('http')) {
        if (await canLaunchUrl(Uri.parse(payload))) {
          await launchUrl(Uri.parse(payload),
              mode: LaunchMode.externalApplication);
        } else {
          print('Gagal membuka URL: $payload');
        }
      }
    },
  );
  
  runApp(MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade300,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorHelper.primary,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme:
              ElevatedButtonThemeData(style: css.buttonRound()),
          dialogTheme: DialogThemeData(titleTextStyle: css.textHeaderBold()),
          bottomAppBarTheme:
              const BottomAppBarThemeData(color: ColorHelper.primary),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: ColorHelper.primary)),
      builder: (context, child) {
        return child!;
      },
      title: 'Login',
      home: const LoginPage()));
}

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

  String? clickUrl = message.data['url'];

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
      payload: clickUrl,
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

Future<bool> handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return false;
  }

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

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Izin notifikasi diberikan');
  } else {
    print('Izin notifikasi ditolak');
    return false;
  }

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
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      const AndroidNotificationChannel channelBackground =
          AndroidNotificationChannel(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        description:
            'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: false,
        showBadge: true,
        enableVibration: true,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_launcher');

      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: initializationSettingsAndroid,
        ),
      );
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
    } on PlatformException catch (e) {
    }

    if (!mounted) return;

    setState(() {});
  }

  Future<void> listapk() async {
    bool excludeSystemApps = true;
    bool withIcon = true;
    String packageNamePrefix = '';
    List<AppInfo> apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: excludeSystemApps,
        withIcon: withIcon,
        packageNamePrefix: packageNamePrefix);
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
        AndroidId aid = const AndroidId();
        String? androidid = await aid.getId();
        await initMobileNumberState();

        checkInitData = await capi.getStatusInitData(
            txtUserNameControl.text, androidid!, '');

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
          await sessionExpired();
        } else {
          if (!mounted) return;

          alertDialogForm(
              'Anda tidak memiliki izin untuk initial data, silahkan hubungi admin',
              context);
        }
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

  void initLoad() async {
    try {
      setState(() {
        isLoading = true;
      });

      handlePermission();
      initFCM();
      getToken();
      checkInitialMessage();

      MobileNumber.listenPhonePermission((isPermissionGranted) async {
        if (!isPermissionGranted) {
          await initMobileNumberState();
        }
      });

      PackageInfo packInfo = await PackageInfo.fromPlatform();
      version = packInfo.version;

      Directory? dir = await getExternalStorageDirectory();
      var newDir =
          await Directory('${dir!.path}/ICI/CRM').create(recursive: true);
      param.appDir = newDir.path;

      await cdb.createDB();
      await cdb.createDBLog();
      msf.Salesman? user = await csf.getSFLogIn();

      if (user != null) {
        txtUserNameControl.text = user.fdKodeSF;

        if (user.fdToken.isNotEmpty) {
          msf.Salesman? result = await capi.refreshToken(
              user.fdKodeSF, user.fdPass!, _msgToken!, version, user.fdToken);

          await cdb.onUpdateAlter();
          if (result!.fdAkses == true) {
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

              await clog.updateSFToken(result.fdToken, result.fdKodeSF);

              print('refresh token: ${result.fdToken}');

              await initMobileNumberState();

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
            }
          } else if (result.message == '401') {
            await sessionExpired();
          } else {
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
      extendBodyBehindAppBar: true,
      body: LoginView(),
      floatingActionButton: (isLoading
          ? const Padding(padding: EdgeInsets.zero)
          : IconButton(
              iconSize: 24 * ScaleSize.textScaleFactor(context),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                FunctionHelper.showDialogs(context,
                    title: 'Settings',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
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
                                        ScaleSize.textScaleFactor(context),
                                    color: Colors.black),
                                label: const Text('Update Aplikasi CRM',
                                    style: TextStyle(color: Colors.black)),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft))),
                        const Divider(height: 0),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton.icon(
                                onPressed: () {
                                  yesNoDialogForm('Initial Data');
                                },
                                icon: Icon(Icons.restart_alt_rounded,
                                    size: 24 *
                                        ScaleSize.textScaleFactor(context),
                                    color: Colors.black),
                                label: const Text('Initial Data',
                                    style: TextStyle(color: Colors.black)),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft))),
                        const Divider(height: 0),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton.icon(
                                onPressed: () async {
                                  try {
                                    AndroidId aid = const AndroidId();
                                    String? androidid = await aid.getId();

                                    generateKeyDialogForm(
                                        'Generate Key', androidid!);
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
                                        ScaleSize.textScaleFactor(context),
                                    color: Colors.black),
                                label: const Text('Generate Key',
                                    style: TextStyle(color: Colors.black)),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft)))
                      ],
                    ));
              },
              icon: const Icon(Icons.settings, color: Colors.black),
            )),
    );
  }
}