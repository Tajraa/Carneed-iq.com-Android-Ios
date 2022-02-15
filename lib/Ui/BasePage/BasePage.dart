import 'dart:ui';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progiom_cms/auth.dart';
import 'package:tajra/Ui/Cart/bloc/cart_bloc.dart';
import 'package:tajra/Ui/Favorite/bloc/favorite_bloc.dart';
import '/App/Widgets/CustomAppBar.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '/App/Widgets/LoginDialoge.dart';
import '/Ui/Cart/CartPage.dart';
import '/Ui/Categories/CategoriesPage.dart';
import '/Ui/Favorite/FavoritePage.dart';
import '/Ui/Home/HomePage.dart';
import '/Ui/Profile/ProfilePage.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injections.dart';
part 'widgets/base_tutorial.dart';

class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

bool showedBaseTour = false;

class _BasePageState extends State<BasePage> with TickerProviderStateMixin {
  late Animation<double> homeScaleAnimation;
  late Animation<double> categoryScaleAnimation;
  late Animation<double> discountScaleAnimation;
  late Animation<double> profileScaleAnimation;
  late AnimationController homeAnimationController;
  late AnimationController searchAnimationController;
  late AnimationController chatAnimationController;
  late AnimationController profileAnimationController;
  int pageIndex = 0;
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus>? targets;
  final GlobalKey homeNavKey = GlobalKey();
  final GlobalKey categoriesNavKey = GlobalKey();
  final GlobalKey cartNavKey = GlobalKey();
  final GlobalKey favNavKey = GlobalKey();
  final GlobalKey profileNavKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    homeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    profileAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    chatAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    searchAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    categoryScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            curve: Curves.easeInQuad, parent: searchAnimationController));
    discountScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            curve: Curves.easeInQuad, parent: chatAnimationController));
    profileScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            curve: Curves.easeInQuad, parent: profileAnimationController));
    homeScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            curve: Curves.easeInQuad, parent: homeAnimationController));
    homeAnimationController.forward();

    CartNumber.instance.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (sl<AuthBloc>().isFirstLaunch && !showedBaseTour)
        Future.delayed(const Duration(milliseconds: 1500)).then((v) {
          initTargets();
          showTutorial(
            tutorialCoachMark: tutorialCoachMark,
            context: context,
            targets: targets!,
          );
          showedBaseTour = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    DateTime? currentBackPressTime;
    Future<bool> onWillPop() async {
      if (pageIndex != 0) {
        searchAnimationController.reverse();
        profileAnimationController.reverse();
        chatAnimationController.reverse();
        homeAnimationController.forward();

        setState(() {
          oldPageIndex = pageIndex;
          pageIndex = 0;
        });
        return Future.value(false);
      } else {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          AppSnackBar.showToast(context, S.of(context).click_twice);

          return Future.value(false);
        }

        return Future.value(true);
      }
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          extendBody: true,
          bottomNavigationBar: buildBottomNavigaton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            key: cartNavKey,
            backgroundColor: AppStyle.primaryColor,
            onPressed: () {
              searchAnimationController.reverse();
              profileAnimationController.reverse();
              chatAnimationController.reverse();

              homeAnimationController.reverse();

              setState(() {
                oldPageIndex = pageIndex;

                pageIndex = 2;
              });
              BlocProvider.of<CartBloc>(context).add(GetCartEvent());
            },
            child: Badge(
              animationDuration: const Duration(milliseconds: 800),
              showBadge: CartNumber.instance.number != 0,
              position: BadgePosition.topStart(
                start: SizeConfig.h(11),
                top: SizeConfig.h(8),
              ),
              badgeContent: Text(
                CartNumber.instance.number.toString(),
                style:
                    TextStyle(color: Colors.white, fontSize: SizeConfig.h(10)),
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_cart,
                  size: SizeConfig.h(17),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: IndexedStack(
            sizing: StackFit.expand,
            alignment: Alignment.center,
            index: pageIndex,
            children: [
              HomePage(),
              CategoriesPage(),
              CartPage(
                goHome: () {
                  searchAnimationController.reverse();
                  profileAnimationController.reverse();
                  chatAnimationController.reverse();

                  homeAnimationController.forward();
                  setState(() {
                    oldPageIndex = pageIndex;
                    pageIndex = 0;
                  });
                },
              ),
              FavoritePage(
                goHome: () {
                  searchAnimationController.reverse();
                  profileAnimationController.reverse();
                  chatAnimationController.reverse();

                  homeAnimationController.forward();
                  setState(() {
                    oldPageIndex = pageIndex;
                    pageIndex = 0;
                  });
                },
              ),
              ProfilePage(),
            ],
          )),
    );
  }

  int oldPageIndex = 0;
  Positioned buildBottomIndecator() {
    return Positioned(
      bottom: SizeConfig.h(AppStyle.bottomNavHieght - 20),
      width: SizeConfig.screenWidth,
      child: (oldPageIndex <= 1 && pageIndex > 1 ||
              oldPageIndex > 1 && pageIndex <= 1)
          ? Align(
              alignment: Alignment(_getIndicatorPosition(pageIndex), 0),
              child: Container(
                alignment: Alignment(_getIndicatorPosition(pageIndex), 0),
                width: SizeConfig.screenWidth / 5,
                color: Colors.transparent,
                height: 2,
                child: Center(
                  child: Container(
                    width: SizeConfig.h(45),
                    color: AppStyle.primaryColor,
                  ),
                ),
              ),
            )
          : AnimatedAlign(
              alignment: Alignment(_getIndicatorPosition(pageIndex), 0),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: SizeConfig.screenWidth / 4,
                height: 2,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: SizeConfig.h(45),
                    color: AppStyle.primaryColor,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    homeAnimationController.dispose();
    searchAnimationController.dispose();
    chatAnimationController.dispose();
    profileAnimationController.dispose();
    super.dispose();
  }

  void initTargets() {
    print("wefewf");
    targets = [];
    targets!.add(
      buildNavTargetFocus(
          "homeVaKey",
          homeNavKey,
          S.of(context).home_title_tour,
          S.of(context).home_subtitle_tour,
          "assets/home.svg"),
    );
    targets!.add(
      buildNavTargetFocus(
        "categoriesNavKey",
        categoriesNavKey,
        S.of(context).categories,
        S.of(context).categories_tour,
        "assets/category.svg",
      ),
    );
    targets!.add(
      buildNavTargetFocus("cartNavKey", cartNavKey, S.of(context).cart,
          S.of(context).cart_tour, "assets/cart.svg"),
    );
    targets!.add(
      buildNavTargetFocus("favNavKey", favNavKey, S.of(context).myFavorites,
          S.of(context).favorite_tour, "assets/fav.svg"),
    );

    targets!.add(
      buildNavTargetFocus(
        "profileNavKey",
        profileNavKey,
        S.of(context).profile,
        S.of(context).profile_tour,
        "assets/profile.svg",
      ),
    );
  }

  double _getIndicatorPosition(int index) {
    var isLtr = Directionality.of(context) == TextDirection.ltr;
    index = index >= 2 ? index + 1 : index;
    if (isLtr)
      return lerpDouble(-1.0, 1.0, index / (5 - 1))!;
    else
      return lerpDouble(1.0, -1.0, index / (5 - 1))!;
  }

  Widget buildBottomNavigaton(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: SizeConfig.h(67),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: Localizations.localeOf(context).languageCode != "ar"
                      ? EdgeInsets.only(left: 28.0)
                      : EdgeInsets.only(right: 28.0),
                  child: ScaleTransition(
                    scale: homeScaleAnimation,
                    key: homeNavKey,
                    child: IconButton(
                      iconSize: SizeConfig.h(34),
                      padding: EdgeInsets.zero,
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/home.svg",
                              width: SizeConfig.h(18),
                              color: pageIndex == 0
                                  ? AppStyle.primaryColor
                                  : AppStyle.secondaryColor,
                              height: SizeConfig.h(18)),
                          if (pageIndex == 0)
                            Text(
                              S.of(context).home,
                              style: AppStyle.vexa11.copyWith(
                                color: pageIndex == 0
                                    ? AppStyle.primaryColor
                                    : AppStyle.secondaryColor,
                              ),
                            )
                        ],
                      ),
                      onPressed: () {
                        searchAnimationController.reverse();
                        profileAnimationController.reverse();
                        chatAnimationController.reverse();

                        homeAnimationController.forward();
                        setState(() {
                          oldPageIndex = pageIndex;

                          pageIndex = 0;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: Localizations.localeOf(context).languageCode == "ar"
                      ? EdgeInsets.only(left: 28.0)
                      : EdgeInsets.only(right: 28.0),
                  child: ScaleTransition(
                    scale: categoryScaleAnimation,
                    key: categoriesNavKey,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: SizeConfig.h(50),
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/category.svg",
                              width: SizeConfig.h(18),
                              color: pageIndex == 1
                                  ? AppStyle.primaryColor
                                  : AppStyle.secondaryColor,
                              height: SizeConfig.h(18)),
                          if (pageIndex == 1)
                            Text(
                              S.of(context).categories,
                              style: AppStyle.vexa11.copyWith(
                                color: pageIndex == 1
                                    ? AppStyle.primaryColor
                                    : AppStyle.secondaryColor,
                              ),
                            )
                        ],
                      ),
                      onPressed: () {
                        searchAnimationController.forward();
                        profileAnimationController.reverse();
                        chatAnimationController.reverse();

                        homeAnimationController.reverse();
                        setState(() {
                          oldPageIndex = pageIndex;

                          pageIndex = 1;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: Localizations.localeOf(context).languageCode != "ar"
                      ? EdgeInsets.only(left: 28.0)
                      : EdgeInsets.only(right: 28.0),
                  child: ScaleTransition(
                    key: favNavKey,
                    scale: discountScaleAnimation,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: SizeConfig.h(34),
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: pageIndex == 3
                                ? AppStyle.primaryColor
                                : AppStyle.secondaryColor,
                            size: SizeConfig.h(25),
                            // height: SizeConfig.h(18),
                          ),
                          if (pageIndex == 3)
                            Text(
                              S.of(context).myFavorites,
                              maxLines: 1,
                              style: AppStyle.vexa11.copyWith(
                                color: pageIndex == 3
                                    ? AppStyle.primaryColor
                                    : AppStyle.secondaryColor,
                              ),
                            )
                        ],
                      ),
                      onPressed: () {
                        if (sl<AuthBloc>().isGuest) {
                          showLoginDialoge(context);
                        } else {
                          searchAnimationController.reverse();
                          profileAnimationController.reverse();
                          chatAnimationController.forward();

                          homeAnimationController.reverse();

                          setState(() {
                            oldPageIndex = pageIndex;

                            pageIndex = 3;
                          });

                          BlocProvider.of<FavoriteBloc>(context)
                              .add(LoadEvent(""));
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: Localizations.localeOf(context).languageCode == "ar"
                      ? EdgeInsets.only(left: 28.0)
                      : EdgeInsets.only(right: 28.0),
                  child: ScaleTransition(
                    key: profileNavKey,
                    scale: profileScaleAnimation,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: SizeConfig.h(34),
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/profile.svg",
                            color: pageIndex == 4
                                ? AppStyle.primaryColor
                                : AppStyle.secondaryColor,
                            width: SizeConfig.h(18),
                            height: SizeConfig.h(18),
                          ),
                          if (pageIndex == 4)
                            Text(
                              S.of(context).my_account,
                              style: AppStyle.vexa11.copyWith(
                                color: pageIndex == 4
                                    ? AppStyle.primaryColor
                                    : AppStyle.secondaryColor,
                              ),
                            )
                        ],
                      ),
                      onPressed: () {
                        if (sl<AuthBloc>().isGuest) {
                          showLoginDialoge(context);
                        } else {
                          searchAnimationController.reverse();
                          profileAnimationController.forward();
                          chatAnimationController.reverse();

                          homeAnimationController.reverse();
                          setState(() {
                            oldPageIndex = pageIndex;

                            pageIndex = 4;
                          });
                          // if (sl<AuthBloc>().isFirstLaunch &&
                          //     !ProfileTutorial.showedProfileTutorial) {
                          //   Future.delayed(const Duration(milliseconds: 800))
                          //       .then((v) {
                          //     ProfileTutorial.initTargets(context);
                          //     ProfileTutorial.showTutorial(
                          //       context: context,
                          //     );
                          //     ProfileTutorial.showedProfileTutorial = true;
                          //   });
                          // }
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        // buildBottomIndecator(),
      ],
    );
  }
}
