import 'package:flutter/material.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

class CheckoutSuccessPage extends StatefulWidget {
  CheckoutSuccessPage({Key? key}) : super(key: key);

  @override
  _CheckoutSuccessPageState createState() => _CheckoutSuccessPageState();
}

class _CheckoutSuccessPageState extends State<CheckoutSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/success.png",
                height: SizeConfig.h(340),
              ),
              SizedBox(
                height: SizeConfig.h(15),
              ),
              Text(
                S.of(context).checkoutSuccess,
                style: AppStyle.vexa20,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.h(15),
              ),
              Text(
                S.of(context).checkoutSuccess_subtitle,
                style: AppStyle.vexa16.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.h(50),
              ),
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.h(225),
                    child: MainButton(
                      isOutlined: false,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          S.of(context).continueShopping,
                          style: AppStyle.vexa14.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
