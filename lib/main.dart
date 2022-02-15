import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Utils/SizeConfig.dart';
import '/constants.dart';
import './/App/App.dart';
import 'package:bloc/bloc.dart';
import './/injections.dart';
import 'Utils/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  BlocOverrides.runZoned(() {
    runApp(App());
  }, blocObserver: SimpleBlocObserver());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class SelectDemoApp extends StatefulWidget {
  SelectDemoApp({Key? key}) : super(key: key);

  @override
  _SelectDemoAppState createState() => _SelectDemoAppState();
}

class _SelectDemoAppState extends State<SelectDemoApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Almaria",
          primarySwatch: AppStyle.primaryMaterial,
          primaryColor: AppStyle.primaryColor,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: AppStyle.primaryColor)),
      builder: (context, child) {
        SizeConfig().init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/Splash.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: 172,
                          height: 98,
                        ),
                      ],
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: SizeConfig.screenHeight * 0.8,
                    width: SizeConfig.screenWidth * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "اختيار تصنيف",
                              style: AppStyle.vexa16.copyWith(
                                  color: AppStyle.secondaryColor,
                                  fontSize: SizeConfig.h(18),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        ListTile(
                          title: Text("الكترونيات"),
                          onTap: () {
                            BaseUrl = "https://demo1.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("مفروشات"),
                          onTap: () {
                            BaseUrl = "https://demo2.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("أدوات منزلية"),
                          onTap: () {
                            BaseUrl = "https://demo3.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("ملابس"),
                          onTap: () {
                            BaseUrl = "https://demo4.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("مستحضرات تجميل"),
                          onTap: () {
                            BaseUrl = "https://demo5.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("هدايا"),
                          onTap: () {
                            BaseUrl = "https://demo6.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("مطعم"),
                          onTap: () {
                            BaseUrl = "https://demo7.tajraa.com/";
                            runMainApp();
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("أغذية"),
                          onTap: () {
                            BaseUrl = "https://demo8.tajraa.com/";
                            runMainApp();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  runMainApp() async {
    await initInjections();
    await sl<SharedPreferences>().clear();

    runApp(App());
  }
}
