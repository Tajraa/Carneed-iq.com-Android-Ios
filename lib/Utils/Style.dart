import 'package:flutter/material.dart';

import 'SizeConfig.dart';

class AppStyle {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xffff4000);
  static const Color grediantLightColor = Color(0xFFff8000);
  static const Color secondaryColor = Color(0xFF0b0146);

  static const Color secondaryLight = Color(0xFF2b2156);
  static const Color secondaryDark = Color(0xFF0b0136);
  static const Color backgroundColor = Color(0xFFfcfcfc);
  static const Color disabledColor = Color(0xFFC4C4C4);
  static const Color greyColor = Color(0xFF9B9B9B);
  static const Color greyDark = Color(0xFF6A6A6A);
  static const Color disabledBorderColor = Color(0xFFF5F5F5);
  static const Color redColor = Color(0xFFEB6A6A);
  static const Color greenColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFDCA40);
  static MaterialColor primaryMaterial = MaterialColor(primaryColor.value, {
    50: Color(primaryColor.value),
    100: Color(primaryColor.value),
    200: Color(primaryColor.value),
    300: Color(primaryColor.value),
    400: Color(primaryColor.value),
    500: Color(primaryColor.value),
    600: Color(primaryColor.value),
    700: Color(primaryColor.value),
    800: Color(primaryColor.value),
    900: Color(primaryColor.value),
  });
  static const Color yellowColor = Color(0xFFFFC107);
  static const double bottomNavHieght = 85;

  static final vexa16 =
      TextStyle(fontSize: SizeConfig.h(17), color: whiteColor);
  static final welcome20 =
      TextStyle(fontSize: SizeConfig.h(20), height: 1.5, color: Colors.white);
  static final welcome30 =
      TextStyle(height: 1.5, fontSize: SizeConfig.h(30), color: Colors.white);

  static final vexa14 =
      TextStyle(height: 1.1, fontSize: SizeConfig.h(14), color: secondaryColor);

  static final vexa20 =
      TextStyle(height: 1.1, fontSize: SizeConfig.h(20), color: primaryColor);
  static final vexa11 = TextStyle(
    height: 1.1,
    fontSize: SizeConfig.h(11),
  );
  static final vexa12 =
      TextStyle(height: 1.1, fontSize: SizeConfig.h(12), color: greyDark);
  static final vexa13 = TextStyle(
    height: 1.1,
    fontSize: SizeConfig.h(13),
  );
  static final vexa9 =
      TextStyle(height: 1.1, fontSize: SizeConfig.h(9), color: secondaryColor);
  static final vexaLight12 =
      TextStyle(height: 1.1, fontSize: SizeConfig.h(12), color: greyColor);
  static final yaroCut14 = TextStyle(
      height: 1.1,
      fontWeight: FontWeight.bold,
      fontSize: SizeConfig.h(14),
      color: primaryColor);
  static final BoxShadow boxShadow3on6 =
      BoxShadow(offset: Offset(0.0, 3), blurRadius: 6, color: Colors.black12);
  static bool isArabic(BuildContext context) {
    return (Directionality.of(context) == TextDirection.rtl);
  }

  static String? priceFontFamily(String priceText) {
    return priceText.contains("₺") ? "Roboto" : null;
  }
}
