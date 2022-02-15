import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:progiom_cms/auth.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Auth/forgotPassword/CodePage.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

import '../../../injections.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  bool isLoading = false;
  bool emailNotVerified = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: SizeConfig.h(87),
            left: SizeConfig.w(50),
            right: SizeConfig.w(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/lock.png"),
                Text(
                  S.of(context).change_password,
                  textAlign: TextAlign.center,
                  style: AppStyle.vexa20.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: SizeConfig.h(27),
                ),
                Text(
                  S.of(context).change_password_message,
                  textAlign: TextAlign.center,
                  style: AppStyle.vexa12,
                ),
                SizedBox(
                  height: SizeConfig.h(53),
                ),
                Container(
                    width: SizeConfig.w(315),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).e_mail,
                                style: AppStyle.vexa12,
                              ),
                              TextFormField(
                                autofocus: true,
                                onChanged: (v) {
                                  setState(() {
                                    if ((RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(v))) {
                                      email = v;
                                      emailNotVerified = false;
                                    } else {
                                      emailNotVerified = true;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "user@email.com",
                                    suffixIcon: Icon(
                                      Icons.check_circle,
                                      size: SizeConfig.h(28),
                                      color: emailNotVerified
                                          ? Colors.white12
                                          : AppStyle.primaryColor,
                                    )),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ])),
                SizedBox(
                  height: SizeConfig.h(42),
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: SizeConfig.w(315),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: MainButton(
                                    onTap: emailNotVerified
                                        ? () {}
                                        : () {
                                            resetPassword();
                                          },
                                    isOutlined: false,
                                    child: Center(
                                      child: Text(
                                        S.of(context).continuee,
                                        style: AppStyle.vexa14.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )))
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    final result = await RequestResetPassword(sl())
        .call(RequestResetPasswordParams(email: email));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => CodePage(
                    email: email,
                  )));
    });
  }
}
