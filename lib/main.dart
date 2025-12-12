import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/splash_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/translation/translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'common/shared_preferences.dart';

String? type;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.defaultImportance,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  type = prefs.getString(changeLanguagePreference);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Got a message whilst in the foreground!
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            icon: '@drawable/ic_notification',
            channel.id,
            channel.name,
            playSound: true,
          ),
        ),
      );
    }
  });

  runApp(const Myapp());
}

String? value;

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        final themeData = Get.put(ThemeController());
        return GetMaterialApp(
            scrollBehavior: MyBehavior(),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            locale: type == "2"
                ? const Locale('ar', 'ab')
                : const Locale('en', 'US'),
            theme: themeData.isDark ? MyThemes.darkTheme : MyThemes.lightTheme,
            fallbackLocale: type == "2"
                ? const Locale('ar', 'ab')
                : const Locale('en', 'US'),
            translations: Translation(),
            home: AppScaffold(
                isCachesEnable: true,
                offlineStatus: (p0) {
                  setState(() {});
                },
                child: const SplashPage()));
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
