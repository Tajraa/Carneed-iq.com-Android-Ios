import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

import 'custom_flushbar.dart';

enum ToastType { Info, Success, Error }

class AppSnackBar {
  // static GlobalKey<ScaffoldState> scaffoldKey;

  static void show(BuildContext context, String text, ToastType type) {
    Color backgroundColor;
    switch (type) {
      case ToastType.Success:
        backgroundColor = AppStyle.greenColor;
        break;
      case ToastType.Error:
        backgroundColor = AppStyle.redColor;
        break;
      default:
        backgroundColor = AppStyle.warningColor;
    }

    Flushbar(
      duration: Duration(seconds: 4),
      messageText: Text(
        text,
        style: AppStyle.vexa14
            .copyWith(color: Colors.white, fontSize: SizeConfig.h(13)),
      ),
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(15),
      icon: type == ToastType.Success
          ? SvgPicture.asset(
              "assets/check.svg",
              height: SizeConfig.h(15),
              width: SizeConfig.h(15),
            )
          : SvgPicture.asset(
              "assets/alert.svg",
              height: SizeConfig.h(15),
              width: SizeConfig.h(15),
            ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.h(15), vertical: SizeConfig.h(15)),
    )..show(context);
    // scaffoldKey.currentState.showSnackBar(SnackBar(
    //     backgroundColor: backgroundColor,
    //     content: Text(
    //       text,
    //       style: TextStyle(color: Colors.white),
    //     )));
  }

  static void showToast(
    BuildContext context,
    String text,
  ) {
    Vibration.vibrate(duration: 100);
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showWithUndo(String text, ToastType type, Function undoCallback,
      Function deleteCallback, BuildContext context) {
    Color backgroundColor = Color(0xFFF05454);
    late Flushbar flush;
    flush = Flushbar(
      duration: Duration(seconds: 4),
      messageText: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: SizeConfig.h(12)),
      ),
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.BOTTOM,
      onStatusChanged: (status) {
        if (FlushbarStatus.DISMISSED == status) {}
      },
      mainButton: FlatButton(
        child: Text(
          "تراجع",
          style: AppStyle.vexa12,
        ),
        onPressed: () {
          flush.dismiss();
          undoCallback();
        },
      ),
    );
    flush.show(context).then((value) {
      if (!flush.isDismissed()) {
        deleteCallback();
      }
    });
  }
}
