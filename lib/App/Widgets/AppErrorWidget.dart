import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Utils/SizeConfig.dart';
import '../../Utils/Style.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({required this.text, Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/alert.svg",
          color: AppStyle.redColor,
          width: SizeConfig.h(80),
          height: SizeConfig.h(80),
        ),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: AppStyle.vexa16.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }
}
