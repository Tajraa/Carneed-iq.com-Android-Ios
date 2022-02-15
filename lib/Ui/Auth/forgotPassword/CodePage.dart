import 'package:flutter/material.dart';

import 'package:progiom_cms/auth.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Auth/forgotPassword/ChangePasswordPage.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

import '../../../injections.dart';

class CodePage extends StatefulWidget {
  final String email;
  CodePage({required this.email, Key? key}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState(email);
}

class _CodePageState extends State<CodePage> {
  _CodePageState(this.email);
  String? code;
  String email;
  bool isLoading = false;
  bool emailNotVerified = true;
  @override
  void initState() {
    if (email != null) {
      emailNotVerified = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: SizeConfig.h(10),
            left: SizeConfig.w(50),
            right: SizeConfig.w(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/lock.png"),
                Text(S.of(context).change_password,
                    textAlign: TextAlign.center,
                    style: AppStyle.vexa20.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: SizeConfig.h(27),
                ),
                Text(
                  S.of(context).enter_code,
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
                                style: AppStyle.vexa12
                                    .copyWith(color: AppStyle.primaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
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
                                initialValue: email,
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
                  height: SizeConfig.h(27),
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
                                S.of(context).code,
                                style: AppStyle.vexa12
                                    .copyWith(color: AppStyle.primaryColor),
                              ),
                              TextFormField(
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    code = value;
                                  });
                                },
                              ),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.h(40),
                      ),
                    ])),
                SizedBox(
                  height: SizeConfig.h(42),
                ),
                Container(
                  width: SizeConfig.w(315),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          children: [
                            Expanded(
                                child: MainButton(
                                    onTap: () {
                                      if (!emailNotVerified &&
                                          (code?.isNotEmpty ?? false))
                                        validateCode();
                                    },
                                    isOutlined: false,
                                    child: Center(
                                      child: Text(S.of(context).continuee, style: AppStyle.vexa14.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),),
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

  validateCode() async {
    setState(() {
      isLoading = true;
    });
    final result = await ValidateResetPassword(sl()).call(
        ValidateResetPasswordParams(email: email, resetCoode: code ?? ""));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => ChangePasswordPage(code!, email)));
    });
  }
}
