part of '../ProfilePage.dart';

class ProfileTutorial {
  static List<TargetFocus> targets = [];
  static TutorialCoachMark? tutorialCoachMark;
  static showTutorial({
    required context,
  }) {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black,
      hideSkip: false,
      textSkip: S.of(context).skip,
      pulseAnimationDuration: const Duration(milliseconds: 700),
      focusAnimationDuration: const Duration(milliseconds: 500),
      paddingFocus: 10,
      opacityShadow: 0.7,
      textStyleSkip: AppStyle.vexa16.copyWith(fontWeight: FontWeight.bold),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {},
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
        // tutorialCoachMark?.next();
      },
    )..show();
  }

  static TargetFocus buildProfileTargetFocus(String identify,
      GlobalKey? keyTarget, String title, String subtitle, String svgAsset) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      radius: 0,
      enableOverlayTab: true,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition:
              CustomTargetContentPosition(top: SizeConfig.screenHeight * .2),
          builder: (context, controller) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(svgAsset,
                      width: SizeConfig.h(45),
                      color: AppStyle.grediantLightColor,
                      height: SizeConfig.h(45)),
                  SizedBox(
                    height: SizeConfig.h(10),
                  ),
                  Text(
                    title,
                    style: AppStyle.vexa20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.grediantLightColor,
                        fontSize: SizeConfig.h(24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      subtitle,
                      style: AppStyle.vexa16.copyWith(
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  static bool showedProfileTutorial = false;
  static GlobalKey? editProfileKey;
  static GlobalKey? addressesKey;
  static GlobalKey? ordersKey;
  static initTargets(BuildContext context) {
    targets.add(TargetFocus(
      identify: "editProfileKey",
      keyTarget: editProfileKey,
      shape: ShapeLightFocus.RRect,
      radius: 3,
      enableOverlayTab: true,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition:
              CustomTargetContentPosition(top: SizeConfig.screenHeight * .2),
          builder: (context, controller) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: AppStyle.primaryColor,
                    size: SizeConfig.h(50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).edit_profile_tour,
                      style: AppStyle.vexa16.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    targets.add(
      buildProfileTargetFocus(
          "addressesKey",
          addressesKey,
          S.of(context).my_addresses,
          S.of(context).address_tour,
          "assets/address.svg"),
    );
    targets.add(
      buildProfileTargetFocus(
          "ordersKey",
          ordersKey,
          S.of(context).orderHistory,
          S.of(context).order_tour,
          "assets/sent.svg"),
    );
  }
}
