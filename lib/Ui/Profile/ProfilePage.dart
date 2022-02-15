import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:progiom_cms/notifications.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '/App/App.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Profile/page_view_page.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

import '/data/sharedPreferences/SharedPrefHelper.dart';
import '/generated/l10n.dart';
import '../../injections.dart';
import 'package:package_info_plus/package_info_plus.dart';
part 'widgets/profile_tutorial.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationEnabled = true;
  bool showLanguages = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return AppStyle.primaryColor;
    }
    return AppStyle.disabledColor;
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool notificationsEnabled = false;
  final debouncer = Debouncer();
  String selectedLanguage = "ar";
  PackageInfo? packageInfo;
  @override
  void initState() {
    super.initState();

    getPreferences();
    getLanguage();
    PackageInfo.fromPlatform().then((value) {
      if (mounted)
        setState(() {
          packageInfo = value;
        });
    }).catchError((onError) {});
  }

  Map? preferences;
  getPreferences() async {
    final result = await GetPreferences(sl()).call(NoParams());
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      if (mounted)
        setState(() {
          preferences = r;
          notificationsEnabled = preferences!["push_notifications"] == 1;
        });
    });
  }

  getLanguage() async {
    selectedLanguage =
        await sl<PrefsHelper>().loadLangFromSharedPref() ?? App.defaultLanguage;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = sl<HomesettingsBloc>().settings!;
   
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(isCustom: false),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, boxShadow: [AppStyle.boxShadow3on6]),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.h(14), horizontal: SizeConfig.h(24)),
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).personalInfo,
                        style: AppStyle.vexa16
                            .copyWith(color: AppStyle.secondaryColor),
                      ),
                      Spacer(),
                      TextButton(
                          key: ProfileTutorial.editProfileKey,
                          onPressed: () {
                            Navigator.pushNamed(context, "/editProfile");
                          },
                          child: Text(
                            S.of(context).edit,
                            style: AppStyle.vexa14.copyWith(
                                color: AppStyle.primaryColor,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.h(10),
                  ),
                  buildTextField(
                      S.of(context).fullName,
                      Icons.person_outline,
                      userNameController
                        ..value = TextEditingValue(
                            text: sl<HomesettingsBloc>().settings?.user?.name ??
                                "")),
                  SizedBox(
                    height: SizeConfig.h(16),
                  ),
                  buildTextField(
                      S.of(context).e_mail,
                      Icons.email_outlined,
                      emailController
                        ..value = TextEditingValue(
                            text:
                                sl<HomesettingsBloc>().settings?.user?.email ??
                                    "")),
                  SizedBox(
                    height: SizeConfig.h(16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.h(14),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, boxShadow: [AppStyle.boxShadow3on6]),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.h(14), horizontal: SizeConfig.h(24)),
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).my_account,
                        style: AppStyle.vexa16
                            .copyWith(color: AppStyle.secondaryColor),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: SizeConfig.h(20),
                  // ),
                  // buildSubSection(S.of(context).myFavorites, () {
                  //   Navigator.pushNamed(context, "/favorite");
                  // }, icon: Icons.favorite_border),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                  buildSubSection(
                    S.of(context).my_addresses,
                    () {
                      Navigator.pushNamed(context, "/myAddresses");
                    },
                    icon: Icons.location_on_outlined,
                    key: ProfileTutorial.addressesKey,
                  ),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                  buildSubSection(
                    S.of(context).orderHistory,
                    () {
                      Navigator.pushNamed(context, "/orders");
                    },
                    svgAsset: "assets/sent.svg",
                    key: ProfileTutorial.ordersKey,
                  ),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                  buildSubSection(S.of(context).my_points, () {
                    Navigator.pushNamed(context, "/myPoints");
                  }, icon: FontAwesomeIcons.bitcoin),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                  buildSubSection(
                    S.of(context).notifications,
                    () {},
                    svgAsset: "assets/speaker.svg",
                    trailing: SizedBox(
                      height: SizeConfig.h(18),
                      child: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                              value: notificationEnabled,
                              thumbColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              inactiveThumbColor: AppStyle.disabledColor,
                              inactiveTrackColor: AppStyle.disabledColor,
                              activeColor: AppStyle.primaryColor,
                              onChanged: (v) {
                                setState(() {
                                  notificationsEnabled = v;
                                });
                                debouncer.run(() {
                                  DisableEnableNotification(sl()).call(
                                      DisableEnableNotificationParams(
                                          enable: notificationsEnabled));
                                });
                              })),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.h(14),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, boxShadow: [AppStyle.boxShadow3on6]),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.h(14), horizontal: SizeConfig.h(24)),
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  buildSubSection(S.of(context).shareApp, () {
                    shareApp();
                  }, icon: Icons.share_outlined),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),
                  for (PageModel page in homeModel.pages ?? [])
                    Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => PageViewScreen(page.id)));
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 0.5))),
                            child: Row(
                              children: [
                                Image.network(
                                  page.coverImage ?? "",
                                  fit: BoxFit.fill,
                                  height: SizeConfig.h(18),
                                  width: SizeConfig.h(18),
                                ),
                                SizedBox(
                                  width: SizeConfig.h(8),
                                ),
                                Text(
                                  page.title,
                                  style: AppStyle.vexaLight12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.h(30),
                        ),
                      ],
                    ),
                  buildSubSection(S.of(context).technicalSupport, () {
                    if (preferences != null)
                      openWhatsapp(preferences!["support_phone"]);
                  }, svgAsset: "assets/support.svg"),
                  SizedBox(
                    height: SizeConfig.h(30),
                  ),

                  buildSubSection(S.of(context).language, () {
                    setState(() {
                      showLanguages = !showLanguages;
                    });
                  },
                      icon: Icons.language,
                      trailing: SizedBox(
                          height: SizeConfig.h(18),
                          child: Icon(
                            !showLanguages
                                ? Icons.arrow_downward_outlined
                                : Icons.arrow_upward_outlined,
                            size: SizeConfig.h(18),
                          ))),
                  if (showLanguages)
                    Column(
                      children: [
                        if (isLanguageActive("ar", homeModel))
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: RadioListTile<String>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(S.of(context).arabic,
                                          style: AppStyle.vexaLight12),
                                      activeColor: AppStyle.primaryColor,
                                      value: "ar",
                                      groupValue: selectedLanguage,
                                      onChanged: (v) {
                                        setState(() {
                                          selectedLanguage = v!;

                                          sl<PrefsHelper>()
                                              .saveLangToSharedPref(v);
                                          App.setLocale(
                                              context, selectedLanguage);
                                        });
                                      }),
                                ),
                              )
                            ],
                          ),
                        if (isLanguageActive("en", homeModel))
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: RadioListTile<String>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(S.of(context).english,
                                          style: AppStyle.vexaLight12),
                                      activeColor: AppStyle.primaryColor,
                                      value: "en",
                                      groupValue: selectedLanguage,
                                      onChanged: (v) {
                                        setState(() {
                                          selectedLanguage = v!;

                                          sl<PrefsHelper>()
                                              .saveLangToSharedPref(v);
                                          App.setLocale(
                                              context, selectedLanguage);
                                        });
                                      }),
                                ),
                              )
                            ],
                          ),
                        if (isLanguageActive("tr", homeModel))
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: RadioListTile<String>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(S.of(context).turkish,
                                          style: AppStyle.vexaLight12),
                                      activeColor: AppStyle.primaryColor,
                                      value: "tr",
                                      groupValue: selectedLanguage,
                                      onChanged: (v) {
                                        setState(() {
                                          selectedLanguage = v!;
                                          sl<PrefsHelper>()
                                              .saveLangToSharedPref(v);
                                          App.setLocale(
                                              context, selectedLanguage);
                                        });
                                      }),
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  // SizedBox(
                  //   height: SizeConfig.h(30),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.h(16),
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.h(24),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    sl<AuthBloc>().add(LogoutEvent());
                    sl<HomesettingsBloc>().settings?.user = null;
                    // Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/login",
                        arguments: false);
                  },
                  child: SizedBox(
                    height: SizeConfig.h(44),
                    child: MainButton(
                      color: AppStyle.redColor,
                      isOutlined: true,
                      child: Center(
                          child: Text(
                        S.of(context).signOut,
                        style:
                            AppStyle.vexa16.copyWith(color: AppStyle.redColor),
                      )),
                    ),
                  ),
                )),
                SizedBox(
                  width: SizeConfig.h(24),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.h(AppStyle.bottomNavHieght + 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubSection(
    String title,
    Function onTap, {
    IconData? icon,
    String? svgAsset,
    Widget? trailing,
    GlobalKey? key,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
        width: double.infinity,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
        child: Row(
          key: key,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: AppStyle.primaryColor,
                    size: SizeConfig.h(18),
                  )
                : SvgPicture.asset(
                    svgAsset!,
                    height: SizeConfig.h(18),
                    width: SizeConfig.h(18),
                    color: AppStyle.primaryColor,
                  ),
            SizedBox(
              width: SizeConfig.h(8),
            ),
            Text(
              title,
              style: AppStyle.vexaLight12,
            ),
            if (trailing != null) Spacer(),
            if (trailing != null) trailing
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return SizedBox(
      height: SizeConfig.h(50),
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.primaryColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.disabledColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.primaryColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10),
              ),
            ),
            prefixIcon: Icon(
              icon,
            ),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: TextStyle(fontSize: SizeConfig.h(14)),
            fillColor: Colors.white70),
      ),
    );
  }
}

void shareApp() {
  if (Platform.isIOS)
    actionShare("https://apps.apple.com/us/app/تجرة/id1589506302",
        SizeConfig.screenWidth);
  else
    actionShare(
        "https://play.google.com/store/apps/details?id=com.progiom.tajraa",
        SizeConfig.screenWidth);
}

bool isLanguageActive(String slug, homeModel) {
  return (homeModel.languages.contains(Languages(slug: slug)));
}
