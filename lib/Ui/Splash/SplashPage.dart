import 'package:flutter/material.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import '/Utils/Style.dart';
import './/Utils/AppSnackBar.dart';
import './/Utils/SizeConfig.dart';
import './/generated/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../injections.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late HomeSettingsWrapper homeSettingsWrapper;
  final GlobalKey<_SplashContentState> splashKey =
      GlobalKey<_SplashContentState>();
  @override
  void initState() {
    homeSettingsWrapper = HomeSettingsWrapper(
      successCallback: goToHomePage,
      failureCallback: failledToGetSettings,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AuthWrapper(
        onTokenReady: (isafterLogout, {token}) {
          if (!isafterLogout) {
            homeSettingsWrapper.getSettings();
          }
        },
        onErrorInToken: (error) =>
            AppSnackBar.show(context, error, ToastType.Error),
        authBloc: sl<AuthBloc>(),
        child: homeSettingsWrapper
          ..child = SplashContent(
            key: splashKey,
          ));
  }

  failledToGetSettings(String error) {
    AppSnackBar.show(context, error, ToastType.Error);
  }

  goToHomePage() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      splashKey.currentState?.setState(() {
        splashKey.currentState?.done = true;
      });
    });
  }
}

class SplashContent extends StatefulWidget {
  SplashContent({
    Key? key,
  }) : super(key: key);

  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  Tween<double> tween = Tween<double>(begin: 1.0, end: 0.0);
  Duration duration = Duration(milliseconds: 2000);
  Curve curve = Curves.fastOutSlowIn;
  bool done = false;
  bool navigateInAfterEnd = false;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      onEnd: () {
        if (mounted) {
          if (navigateInAfterEnd) {
            if (sl<AuthBloc>().isFirstLaunch) {
              Navigator.pushReplacementNamed(context, '/onboard');
            } else if (sl<AuthBloc>().isGuest) {
              Navigator.pushReplacementNamed(context, '/base');
            } else {
              Navigator.pushReplacementNamed(context, '/base');
            }
          } else if (done) {
            setState(() {
              tween = Tween<double>(begin: tween.begin, end: 0.9);
              duration = Duration(milliseconds: 500);
              navigateInAfterEnd = true;
              curve = Curves.linear;
            });
          } else {
            setState(() {
              tween = Tween<double>(
                  begin: tween.begin == 1.0 ? 0.05 : 1.0,
                  end: tween.end == 0.0 ? 0.05 : 0.0);
              duration = Duration(milliseconds: 3000);
              curve = Curves.easeInOutQuad;
            });
          }
        }
      },
      builder: (BuildContext context, double? value, Widget? child) {
        return Scaffold(
          backgroundColor: Color(0xFFf7f7f7),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                Opacity(
                  opacity: (1 -
                      ((value ?? 0).abs() > 1.0 ? 0.0 : (value ?? 0).abs())),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          AppStyle.secondaryLight,
                          AppStyle.secondaryDark
                        ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/logo.png",
                              width: SizeConfig.h(172),
                              height: SizeConfig.h(172),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -SizeConfig.h(92) - ((value ?? 0) * SizeConfig.h(150)),
                  left: -SizeConfig.w(50) - ((value ?? 0) * SizeConfig.w(500)),
                  child: SizedBox(
                    child: SimpleShadow(
                      offset: Offset(0, 3),
                      sigma: 6,
                      color: Colors.black.withOpacity(0.85),
                      child: SvgPicture.asset(
                        "assets/splashTop.svg",
                        color: AppStyle.secondaryLight,
                        height: SizeConfig.h(420),
                        width: SizeConfig.h(600),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: SizeConfig.h(500) + ((value ?? 0) * SizeConfig.h(50)),
                  left: -SizeConfig.w(120) + ((value ?? 0) * SizeConfig.w(500)),
                  child: SizedBox(
                    height: SizeConfig.h(420),
                    width: SizeConfig.w(600),
                    child: SimpleShadow(
                      offset: Offset(0, 3),
                      sigma: 6,
                      color: Colors.black.withOpacity(0.85),
                      child: SvgPicture.asset(
                        "assets/splashBottom.svg",
                        color: AppStyle.secondaryLight,
                        height: SizeConfig.h(420),
                        width: SizeConfig.w(600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      duration: duration,
      tween: tween,
      curve: curve,
    );
  }
}

// class SplashPage extends StatefulWidget {
//   SplashPage({Key? key}) : super(key: key);

//   @override
//   _SplashPageState createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   late HomeSettingsWrapper homeSettingsWrapper;
//   @override
//   void initState() {
//     homeSettingsWrapper = HomeSettingsWrapper(
//       successCallback: goToHomePage,
//       failureCallback: failledToGetSettings,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return AuthWrapper(
//         onTokenReady: (isafterLogout, {token}) {
//           if (!isafterLogout) {
//             homeSettingsWrapper.getSettings();
//           }
//         },
//         onErrorInToken: (error) =>
//             AppSnackBar.show(context, error, ToastType.Error),
//         authBloc: sl<AuthBloc>(),
//         child: homeSettingsWrapper
//           ..child = Scaffold(
//             body: Stack(
//               children: [
//                 Container(
//                   height: double.infinity,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                         AppStyle.secondaryLight,
//                         AppStyle.secondaryDark
//                       ])),
//                 ),
//                 Positioned(
//                   top: -SizeConfig.h(92),
//                   left: -SizeConfig.h(90),
//                   child: SizedBox(
//                     child: SimpleShadow(
//                       offset: Offset(0, 3),
//                       sigma: 6,
//                       color: Colors.black.withOpacity(0.85),
//                       child: SvgPicture.asset(
//                         "assets/splashTop.svg",
//                         color: AppStyle.secondaryColor,
//                         height: SizeConfig.h(420),
//                         width: SizeConfig.h(600),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: SizeConfig.h(500),
//                   left: -SizeConfig.w(120),
//                   child: SizedBox(
//                     height: SizeConfig.h(420),
//                     width: SizeConfig.w(600),
//                     child: SimpleShadow(
//                       offset: Offset(0, 3),
//                       sigma: 6,
//                       color: Colors.black.withOpacity(0.85),
//                       child: SvgPicture.asset(
//                         "assets/splashBottom.svg",
//                         color: AppStyle.secondaryColor,
//                         height: SizeConfig.h(420),
//                         width: SizeConfig.w(600),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/logo.png",
//                           width: SizeConfig.h(172),
//                           height: SizeConfig.h(98),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ));
//   }

//   failledToGetSettings(String error) {
//     AppSnackBar.show(context, error, ToastType.Error);
//   }

//   goToHomePage() {
//     if (sl<AuthBloc>().isFirstLaunch) {
//       Navigator.pushReplacementNamed(context, '/onboard');
//     } else if (sl<AuthBloc>().isGuest) {
//       Navigator.pushReplacementNamed(context, '/base');
//     } else {
//       Navigator.pushReplacementNamed(context, '/base');
//     }
//   }
// }
