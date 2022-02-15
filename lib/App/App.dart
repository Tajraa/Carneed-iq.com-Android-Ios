import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:tajra/Ui/Cart/bloc/cart_bloc.dart';
import 'package:tajra/Ui/Favorite/bloc/favorite_bloc.dart';
import '/Ui/Notifications/NotificationsPage.dart';
import '/Ui/ProductDetails/ProductDetailsPage.dart';
import '/Ui/Profile/page_view_page.dart';
import '/Ui/Splash/SplashPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Utils/Style.dart';
import '/data/sharedPreferences/SharedPrefHelper.dart';
import '/generated/l10n.dart';

import '../injections.dart';
import '../router.dart';

class App extends StatefulWidget {
  static String defaultLanguage = "ar";

  @override
  _AppState createState() => _AppState();

  static void setLocale(BuildContext context, String newLocale) {
    _AppState state = context.findAncestorStateOfType()!;
    state.setState(() {
      state.locale = Locale(newLocale);
    });
    sl<PrefsHelper>().saveLangToSharedPref(newLocale);
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class _AppState extends State<App> {
  Locale? locale;
  String? deviceLanguageCode, backUpLanguageCode;
  @override
  void initState() {
    super.initState();
    // deviceLanguageCode = Platform.localeName.split('_')[0];
    // if (deviceLanguageCode!.toLowerCase() == 'en' ||
    //     deviceLanguageCode!.toLowerCase() == 'ar' ||
    //     deviceLanguageCode!.toLowerCase() == 'tr') {
    //   backUpLanguageCode = deviceLanguageCode;
    // }
    // else {
    backUpLanguageCode = App.defaultLanguage;
    // }
    sl<PrefsHelper>().loadLangFromSharedPref().then((lang) {
      setState(() {
        locale = Locale(lang ?? backUpLanguageCode);
      });
    });
    initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        onGenerateRoute: AppRouter.generateRoute,
        theme: ThemeData(
            fontFamily: locale?.languageCode == "ar" ? "Almaria" : null,
            primarySwatch: AppStyle.primaryMaterial,
            primaryColor: AppStyle.primaryColor,
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: AppStyle.primaryColor)),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: this.locale,
        supportedLocales: [Locale("ar"), Locale("en"), Locale("tr")],
        builder: (context, child) {
          return ConnectivityBuilder(
              connectedCallback: () {
                if (AppRouter.currentRoute == "/")
                  sl<AuthBloc>().add(InitToken(isAfterLogout: false));
              },
              noInternetString: S.of(context).noInternet,
              tryAgainString: S.of(context).tryAgain,
              child: Directionality(
                  textDirection: locale!.languageCode != "ar"
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: child!));
        },
        initialRoute: "/",
        home: SplashPage(),
      ),
    );
  }
}

initFirebaseMessaging() async {
  // NotificationClass.clickCallback = (conversationId) {
  //   print("clicked on noti $conversationId");
  //   if (conversationId != null && conversationId.toString().isNotEmpty) {
  //     navigatorKey.currentState.push(MaterialPageRoute(
  //         builder: (context) => ChatPage(
  //               conversationId,
  //             )));
  //   } else {
  //     navigatorKey.currentState
  //         .push(MaterialPageRoute(builder: (context) => Notifications()));
  //   }
  // };
  await Firebase.initializeApp();
  //  NotificationClass.notificationClass.init();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      // if (message.data['entity'] == "message") {
      //   print("onMessage " + message.toString());
      //   chatBloc.add(NewMessage(NotificationMessage(
      //       conversationId: message.data['entity_id'].toString(),
      //       image: message.data['cover_image'],
      //       time: message.data['time'],
      //       title: message.data['title'],
      //       text: message.data['body'])));
      // } else {
      //   NotificationClass.notificationClass.showNotification(
      //       message.notification.title, message.notification.body, "");
      //   chatBloc.add(NewNotification());
      // }
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("hanlde message" + (event.data.toString()));
    handleFCMNotification(event.data, false);
  });
  await Firebase.initializeApp();

  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      print("hanlde message" + (value.data.toString()));
      handleFCMNotification(value.data, true);
    }
  });
}

void handleFCMNotification(Map<String, dynamic> message, bool isLaunch) {
  Timer.periodic(Duration(seconds: 1), (timer) {
    print(AppRouter.currentRoute);
    if (AppRouter.currentRoute != "/") {
      timer.cancel();

      if (message['entity'] == 'post') {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ProductsDetailsPage(
                  id: message['entity_id'].toString(),
                  goToOptions: false,
                )));
      } else if (message['entity'] == 'page') {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => PageViewScreen(
                  int.parse(message['entity_id']),
                )));
      }
      //  else if (message['entity'] == 'review') {
      //   showDialog(
      //       context: AppSnackBar.appContext,
      //       builder: (context) => Evaluation(int.parse(message['entity_id'])));
      // }
      else {
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => NotificationsPage()));
      }
    }
  });
}
