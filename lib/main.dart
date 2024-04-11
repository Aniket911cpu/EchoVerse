import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:echoverse/provider/addfavouriteprovider.dart';
import 'package:echoverse/provider/allradioviewallprovider.dart';
import 'package:echoverse/provider/artistviewallprovider.dart';
import 'package:echoverse/provider/categoryviewallprovider.dart';
import 'package:echoverse/provider/cityviewallprovider.dart';
import 'package:echoverse/provider/favouriteprovider.dart';
import 'package:echoverse/provider/generalprovider.dart';
import 'package:echoverse/pages/splash.dart';
import 'package:echoverse/provider/getradiobyartistprovider.dart';
import 'package:echoverse/provider/getradiobycategoryprovider.dart';
import 'package:echoverse/provider/getradiobycityprovider.dart';
import 'package:echoverse/provider/getradiobylanguageprovider.dart';
import 'package:echoverse/provider/homeprovider.dart';
import 'package:echoverse/provider/languageprovider.dart';
import 'package:echoverse/provider/languageviewallprovider.dart';
import 'package:echoverse/provider/latestviewallprovider.dart';
import 'package:echoverse/provider/notificationprovider.dart';
import 'package:echoverse/provider/profileprovider.dart';
import 'package:echoverse/provider/searchprovider.dart';
import 'package:echoverse/provider/updateprofileprovider.dart';
import 'package:echoverse/utils/color.dart';
import 'package:echoverse/utils/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Locales.init(['en', 'ar', 'hi']);

  if (!kIsWeb) {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(Constant.oneSignalAppId);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: ===> $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });
  }
  // Set StatusBar Color And Navigation Color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Navigation bar color
      systemNavigationBarColor: white,
      // status bar color
      statusBarColor: transparent,
    ),
  );
  // Just Audio Player Background Service Set
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      notificationColor: colorPrimaryDark,
      androidResumeOnClick: true,
      androidStopForegroundOnPause: true,
      androidNotificationClickStartsActivity: true);

/*--------------------------------- Temporary Unuseable Section---------------------------------------- */

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // firebaseMessaging.requestPermission();

  // firebaseMessaging.getToken().then((token) {
  //   print('======> TOKEN: $token'); // Print the Token in Console
  // });

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  //Awesome push notification
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: 'Key1',
  //       channelName: 'Proto Coders Point',
  //       channelDescription: 'Notification Example',
  //       playSound: true,
  //       enableVibration: true,
  //       defaultColor: const Color(0xFF9858DD),
  //       ledColor: white,
  //       enableLights: true)
  // ]);

  /*--------------------------------- Temporary Unuseable Section---------------------------------------- */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).whenComplete(() => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GeneralProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => GetRadiobyArtistProvider()),
            ChangeNotifierProvider(create: (_) => GetRadiobyCityProvider()),
            ChangeNotifierProvider(create: (_) => GetRadiobyCategoryProvider()),
            ChangeNotifierProvider(create: (_) => GetRadiobylanguageProvider()),
            ChangeNotifierProvider(create: (_) => FavouriteProvider()),
            ChangeNotifierProvider(create: (_) => AddFavouriteProvider()),
            ChangeNotifierProvider(create: (_) => CityViewAllProvider()),
            ChangeNotifierProvider(create: (_) => CategoryViewAllProvider()),
            ChangeNotifierProvider(create: (_) => LanguageViewAllProvider()),
            ChangeNotifierProvider(create: (_) => ArtistViewAllProvider()),
            ChangeNotifierProvider(create: (_) => AllRadioViewAllProvider()),
            ChangeNotifierProvider(create: (_) => LatestRadioViewAllProvider()),
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    );
  }

/*--------------------------------- Temporary Unuseable Section---------------------------------------- */

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('====THIS IS BACKGROUND======= : ${message.messageId}');
//   log('FIREBASE BACKGROUND DATA LENGTH ${message.data.length}');

//   //Awesome Notification

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 1,
//       channelKey: 'Key1',
//       title: message.data['title'].toString(),
//       body: message.data['body'].toString(),
//       bigPicture: message.data['mediaUrl'].toString(),
//       notificationLayout: NotificationLayout.BigPicture,
//     ),
//   );

/*--------------------------------- Temporary Unuseable Section---------------------------------------- */
}
