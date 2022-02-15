part of '../CartPage.dart';

void showTutorial({
  required tutorialCoachMark,
  required context,
  required List<TargetFocus> targets,
}) {
  tutorialCoachMark = TutorialCoachMark(
    context,
    targets: targets,
    colorShadow: Colors.black,
    textSkip: S.of(context).skip,
    pulseAnimationDuration: const Duration(milliseconds: 700),
    focusAnimationDuration: const Duration(milliseconds: 500),
    paddingFocus: 5,
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

TargetFocus buildCartTargetFocus(String identify, GlobalKey keyTarget,
    String title, String subtitle, String svgAsset) {
  return TargetFocus(
    identify: identify,
    keyTarget: keyTarget,
    alignSkip: Alignment.topRight,
    shape: ShapeLightFocus.RRect,
    radius: 3,
    enableOverlayTab: true,
    enableTargetTab: false,
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition:
            CustomTargetContentPosition(top: SizeConfig.screenHeight * .5),
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
