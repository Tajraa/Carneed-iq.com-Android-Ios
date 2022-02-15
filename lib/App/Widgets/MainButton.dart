import 'package:flutter/material.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {Key? key,
      this.onTap,
      this.height,
      required this.child,
      required this.isOutlined,
      this.color,
      this.borderRadius})
      : super(key: key);
  final bool isOutlined;
  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var mainColor = color != null ? color! : AppStyle.primaryColor;
    return Material(
      borderRadius: borderRadius == null
          ? BorderRadius.circular(SizeConfig.h(3))
          : borderRadius,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height ?? SizeConfig.h(44),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(7)),
          decoration: BoxDecoration(
              color: isOutlined ? Colors.white10 : mainColor,
              border: !isOutlined ? null : Border.all(color: mainColor),
              boxShadow: isOutlined
                  ? null
                  : [
                      BoxShadow(
                          offset: Offset(0.0, 6),
                          blurRadius: 6,
                          color: Colors.black12),
                    ],
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(SizeConfig.h(3))
                  : borderRadius),
          child: child,
        ),
      ),
    );
  }
}
