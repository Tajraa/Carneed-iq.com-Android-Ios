import 'dart:io';

import 'package:flutter/material.dart';
import '../../App/Widgets/MainButton.dart';
import '../../Utils/SizeConfig.dart';
import '../../Utils/Style.dart';

class EmptyPlacholder extends StatelessWidget {
  final bool skipNavBarHeight;
  final String title;
  final String? subtitle;
  final String imageName;
  final String? actionTitle;
  final Function()? onActionTap;
  const EmptyPlacholder(
      {Key? key,
      required this.title,
      this.subtitle,
      required this.imageName,
      this.actionTitle,
      this.onActionTap,
      this.skipNavBarHeight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Image.asset(
          imageName,
          height: SizeConfig.h(200),
        ),
        SizedBox(
          height: SizeConfig.h(10),
        ),
        Text(
          title,
          style: AppStyle.vexa16.copyWith(
            color: AppStyle.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: SizeConfig.h(10),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            subtitle ?? "",
            textAlign: TextAlign.center,
            style: AppStyle.vexa16.copyWith(color: AppStyle.greyColor),
          ),
        ),
        SizedBox(
          height: SizeConfig.h(25),
        ),
        if (skipNavBarHeight)
          SizedBox(
            height: SizeConfig.h(100),
          )
        else
          Spacer(),
        if (actionTitle != null)
          Row(
            children: [
              SizedBox(
                width: SizeConfig.h(12),
              ),
              Expanded(
                child: SizedBox(
                  height: SizeConfig.h(44),
                  child: MainButton(
                      isOutlined: true,
                      onTap: onActionTap ?? () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            actionTitle ?? "",
                            style: AppStyle.vexa14.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppStyle.primaryColor),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                width: SizeConfig.h(12),
              ),
            ],
          ),
        if (skipNavBarHeight)
          SizedBox(
            height: SizeConfig.h(
              (Platform.isIOS ? 150 : 105),
            ),
          )
        else
          SizedBox(
            height: SizeConfig.h(25),
          ),
      ],
    );
  }
}
