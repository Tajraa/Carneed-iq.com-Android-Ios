import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:progiom_cms/homeSettings.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import './/Utils/SizeConfig.dart';
import './/Utils/Style.dart';
import './/data/repository/Repository.dart';
import './/generated/l10n.dart';

import '../../injections.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -SizeConfig.h(90),
            left: -SizeConfig.w(246),
            child: SizedBox(
              height: SizeConfig.h(867),
              width: SizeConfig.w(854),
              child: SvgPicture.asset(
                "assets/onboarding_back.svg",
                height: SizeConfig.h(867),
                width: SizeConfig.w(854),
                fit: BoxFit.cover,
                color: AppStyle.secondaryColor,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView(
                    controller: pageController,
                    children: sl<HomesettingsBloc>()
                            .settings
                            ?.onboards
                            .map((e) => buildOnBoarding(e))
                            .toList() ??
                        []),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.h(24), vertical: SizeConfig.h(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/base");
                    },
                    child: Container(
                      width: SizeConfig.h(103),
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(17)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: AppStyle.secondaryColor,
                        ),
                        borderRadius: BorderRadius.circular(SizeConfig.h(28)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).skip,
                            style: AppStyle.vexa14,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          count: sl<HomesettingsBloc>()
                                  .settings
                                  ?.onboards
                                  .length ??
                              1,
                          effect: ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              expansionFactor: 2,
                              activeDotColor: AppStyle.primaryColor,
                              dotColor: AppStyle.greyColor),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if ((pageController.page!) ==
                          (sl<HomesettingsBloc>().settings?.onboards.length ??
                                  1) -
                              1)
                        Navigator.pushReplacementNamed(context, "/base");
                      else
                        pageController.animateToPage(
                            (pageController.page!.toInt()) + 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn);
                    },
                    child: Container(
                      width: SizeConfig.h(103),
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(17)),
                      decoration: BoxDecoration(
                          color: AppStyle.secondaryColor,
                          borderRadius: BorderRadius.circular(SizeConfig.h(28)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0.0, 4.0),
                                blurRadius: 30,
                                color: Colors.black.withOpacity(0.2))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).next,
                            style:
                                AppStyle.vexa14.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOnBoarding(Onboards onboard) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    onboard.title ?? "",
                    style: AppStyle.vexa20.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.h(18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(50)),
              child: Text(
                onboard.description ?? "",
                style: AppStyle.vexa14.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: SizeConfig.h(34),
            ),
            SizedBox(
              height: SizeConfig.h(250),
              width: SizeConfig.h(250),
            ),
          ],
        ),
        Positioned(
          width: SizeConfig.screenWidth,
          top: SizeConfig.h(370),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                onboard.coverImage ?? "",
                height: SizeConfig.h(250),
                width: SizeConfig.h(250),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
