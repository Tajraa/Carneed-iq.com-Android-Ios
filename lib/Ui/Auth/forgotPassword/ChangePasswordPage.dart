import 'package:flutter/material.dart';

import 'package:progiom_cms/auth.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

import '../../../injections.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  final String code;
  ChangePasswordPage(this.code, this.email, {Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  _ChangePasswordPageState();
  bool isLoading = false;
  String password = "";
  String confirmPassword = "";
  changePassword() async {
    setState(() {
      isLoading = true;
    });
    final result = await ChangePassword(sl()).call(ChangePasswordParams(
        email: widget.email, resetCode: widget.code, password: password));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.h(87),
              left: SizeConfig.w(50),
              right: SizeConfig.w(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/lock.png"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).change_password,
                          textAlign: TextAlign.center,
                          style: AppStyle.vexa16
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                                  S.of(context).new_password,
                                ),
                                TextFormField(
                                  validator: (v) {
                                    if ((v?.length ?? 0) < 8) {
                                      return S.of(context).passwordValidator;
                                    } else
                                      return null;
                                  },
                                  autofocus: true,
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "**********",
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.h(40),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  validator: (v) {
                                    if (v != password) {
                                      return S.of(context).passwordConfirm;
                                    } else
                                      return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      confirmPassword = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: S.of(context).confirm_password,
                                      hintStyle: AppStyle.vexa12),
                                ),
                              ],
                            ))
                          ],
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
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        changePassword();
                                      }
                                    },
                                    isOutlined: false,
                                    child: Center(
                                      child: Text(
                                        S.of(context).continuee,
                                        style: AppStyle.vexa14.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
