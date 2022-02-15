import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import './/Utils/AppSnackBar.dart';
import './/Utils/SizeConfig.dart';
import './/Utils/Style.dart';
import './/data/repository/Repository.dart';
import './/generated/l10n.dart';
import './/injections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgotPassword/ForgotPassword.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSignUp = false;
  late TabController _controller;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    tapGestureRecognizer = TapGestureRecognizer()..onTap = _goToRegister;

    super.initState();
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        if (_controller.index == 0) {
          setState(() {
            isSignUp = false;
          });
        } else {
          setState(() {
            isSignUp = true;
          });
        }
      }
    });
  }

  TapGestureRecognizer? tapGestureRecognizer;
  void _goToRegister() {
    _controller.animateTo(1);
    setState(() {
      isSignUp = true;
    });
  }

  @override
  void dispose() {
    tapGestureRecognizer?.dispose();

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned(
                top: -SizeConfig.h(90),
                left: -SizeConfig.w(212),
                child: SizedBox(
                  width: SizeConfig.w(867.71),
                  height: SizeConfig.h(608),
                  child: SvgPicture.asset(
                    "assets/login.svg",
                    width: SizeConfig.w(867.71),
                    height: SizeConfig.h(608),
                    fit: BoxFit.cover,
                    color: AppStyle.secondaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height:
                        SizeConfig.screenHeight + ((Platform.isIOS) ? 45 : 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.1,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                    text: S.of(context).welcome + "\n",
                                    style: AppStyle.welcome20
                                        .copyWith(fontFamily: "Almaria"),
                                    children: [
                                      TextSpan(
                                          text: S.of(context).to_carneed + "\n",
                                          style: AppStyle.welcome30
                                              .copyWith(fontFamily: "Almaria")),
                                      TextSpan(text: S.of(context).by_login)
                                    ]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.h(35),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: SizeConfig.h(isSignUp ? 435 : 412),
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: EdgeInsets.all(SizeConfig.h(28)),
                                height: SizeConfig.h(isSignUp ? 400 : 382),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, 3.0),
                                          blurRadius: 20)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Scaffold(
                                    backgroundColor: Colors.white,
                                    appBar: AppBar(
                                      automaticallyImplyLeading: false,
                                      backgroundColor: Colors.white,
                                      elevation: 0.0,
                                      flexibleSpace: TabBar(
                                        controller: _controller,
                                        isScrollable: true,
                                        indicatorColor: Colors.orange,
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        tabs: [
                                          Tab(
                                              child: Text(
                                            S.of(context).login,
                                            style: AppStyle.vexa14.copyWith(
                                                color: isSignUp
                                                    ? AppStyle.disabledColor
                                                    : AppStyle.secondaryColor),
                                          )),
                                          Tab(
                                              child: Text(
                                            S.of(context).create_account,
                                            style: AppStyle.vexa14.copyWith(
                                                color: !isSignUp
                                                    ? AppStyle.disabledColor
                                                    : AppStyle.secondaryColor),
                                          )),
                                        ],
                                      ),
                                    ),
                                    body: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _controller,
                                      children: [
                                        buildLoginDialoge(),
                                        buildSignUpDialoge(),
                                      ],
                                    )),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      if (isSignUp) {
                                        sl<AuthBloc>().add(SignUpEvent({
                                          "name": nameController.text,
                                          "email": emailController.text,
                                          "password": passwordController.text
                                        }));
                                      } else {
                                        sl<AuthBloc>().add(LoginEvent(
                                            email: emailController.text,
                                            password: passwordController.text));
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0.0, 3.0),
                                              blurRadius: 6,
                                              color: Colors.black12)
                                        ]),
                                    height: SizeConfig.h(72),
                                    width: SizeConfig.h(72),
                                    padding: EdgeInsets.all(SizeConfig.h(9)),
                                    child: BlocConsumer(
                                        bloc: sl<AuthBloc>(),
                                        listener: (context, state) {
                                          if (state is ErrorInLogin) {
                                            AppSnackBar.show(
                                                context,
                                                S
                                                    .of(context)
                                                    .emailOrPasswordWrong,
                                                ToastType.Error);
                                          }
                                          if (state is ErrorSignUp) {
                                            AppSnackBar.show(context,
                                                state.error, ToastType.Error);
                                          }
                                          if (state is LoginSuccess) {
                                            sl<Repository>().setFcmToken();
                                            Navigator.pushReplacementNamed(
                                                context, '/base');
                                          }
                                          if (state is SignUpSuccess) {
                                            sl<Repository>().setFcmToken();
                                            Navigator.pushReplacementNamed(
                                                context, '/base');
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is LoadingLogin ||
                                              state is LoadingSignUp)
                                            return CircularProgressIndicator();
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  colors: [
                                                    AppStyle.primaryColor,
                                                    AppStyle.grediantLightColor
                                                  ]),
                                            ),
                                            height: SizeConfig.h(54),
                                            width: SizeConfig.h(54),
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                              size: SizeConfig.h(24),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/base');
                              },
                              child: Text(
                                S.of(context).continueAsGuest,
                                style: AppStyle.vexa14
                                    .copyWith(color: AppStyle.primaryColor),
                              ),
                            )
                          ],
                        ),
                        buildSocialLogin(context),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: S.of(context).dont_have_account,
                                    style: TextStyle(
                                            color: AppStyle.secondaryColor,
                                            fontSize: SizeConfig.h(12))
                                        .copyWith(fontFamily: "Almaria"),
                                    children: [
                                  TextSpan(
                                      text: " " + S.of(context).singup + " ",
                                      style: TextStyle(
                                              color: AppStyle.primaryColor,
                                              fontWeight: FontWeight.bold)
                                          .copyWith(fontFamily: "Almaria"),
                                      recognizer: tapGestureRecognizer),
                                ]))
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.h(5),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildSocialLogin(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 1,
              color: AppStyle.secondaryColor,
            )),
            Expanded(
                flex: 2,
                child: Center(
                    child: Text(
                  S.of(context).sign_in_with,
                  style:
                      AppStyle.vexa12.copyWith(color: AppStyle.secondaryColor),
                ))),
            Expanded(
                child: Container(
              height: 1,
              color: AppStyle.secondaryColor,
            )),
          ],
        ),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(),
            SizedBox(),
            GestureDetector(
              onTap: () async {
                final result = await sl<Repository>().getFacebookToken();
                result.fold((l) {
                  AppSnackBar.show(context, l.errorMessage, ToastType.Error);
                }, (r) {
                  sl<AuthBloc>().add(LoginSocialEvent(
                      provider: SocialLoginProvider.face, token: r));
                });
              },
              child: Container(
                height: SizeConfig.h(54),
                width: SizeConfig.h(54),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 5),
                        blurRadius: 5)
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/face.svg",
                    height: SizeConfig.h(22),
                    width: SizeConfig.h(22),
                  ),
                ),
              ),
            ),
            // Container(
            //   height: SizeConfig.h(54),
            //   width: SizeConfig.h(54),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white,
            //     border: Border.all(color: Colors.black26),
            //     boxShadow: [
            //       BoxShadow(
            //           color: Colors.black12,
            //           offset: Offset(0.0, 5),
            //           blurRadius: 5)
            //     ],
            //   ),
            //   child: Center(
            //     child: SvgPicture.asset(
            //       "assets/twitter.svg",
            //       height: SizeConfig.h(22),
            //       width: SizeConfig.h(22),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () async {
                final result = await sl<Repository>().getGoogleToken();
                result.fold((l) {
                  AppSnackBar.show(context, l.errorMessage, ToastType.Error);
                }, (r) {
                  sl<AuthBloc>().add(LoginSocialEvent(
                      provider: SocialLoginProvider.google, token: r));
                });
              },
              child: Container(
                height: SizeConfig.h(54),
                width: SizeConfig.h(54),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 5),
                        blurRadius: 5)
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/googleIcon.svg",
                    height: SizeConfig.h(22),
                    width: SizeConfig.h(22),
                  ),
                ),
              ),
            ),
            SizedBox(),
            SizedBox(),
          ],
        ),
        if (Platform.isIOS) AppleButton(),
      ],
    );
  }

  Column buildLoginDialoge() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.h(4),
        ),
        buildTextField(
            S.of(context).e_mail, Icons.person_outline, emailController,
            validator: (v) {
          if (v != null) {
            if (!validEmail(v)) {
              return S.of(context).emailValidator;
            }
          }
          return null;
        }),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        buildTextField(
            S.of(context).password, Icons.lock_outline, passwordController,
            validator: (v) {
          if (v != null && !validPassword(v))
            return S.of(context).passwordValidator;
          return null;
        }, obscureText: true),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ForgotPassword()));
              },
              child: Text(S.of(context).forget_password,
                  style: TextStyle(
                      fontSize: SizeConfig.h(12),
                      color: AppStyle.secondaryColor,
                      decoration: TextDecoration.underline)),
            )
          ],
        )
      ],
    );
  }

  Widget buildSignUpDialoge() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.h(4),
          ),
          buildTextField(
              S.of(context).fullName, Icons.person_outline, nameController,
              validator: (v) {
            if (v != null && v.isEmpty) return S.of(context).nameRequired;
            return null;
          }),
          SizedBox(
            height: SizeConfig.h(15),
          ),
          buildTextField(
              S.of(context).e_mail, Icons.email_outlined, emailController,
              validator: (v) {
            if (v != null) {
              if (!validEmail(v)) {
                return S.of(context).emailValidator;
              }
            }
            return null;
          }),
          SizedBox(
            height: SizeConfig.h(15),
          ),
          buildTextField(
              S.of(context).password, Icons.lock_outline, passwordController,
              validator: (v) {
            if (v != null && !validPassword(v))
              return S.of(context).passwordValidator;
            return null;
          }, obscureText: true),
          SizedBox(
            height: SizeConfig.h(15),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {String? Function(String?)? validator, bool? obscureText}) {
    return SizedBox(
      // height: SizeConfig.h(50),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.h(2),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.primaryColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(100),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.disabledColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(100),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppStyle.primaryColor),
              borderRadius: const BorderRadius.all(
                const Radius.circular(100),
              ),
            ),
            prefixIcon: Icon(
              icon,
            ),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: TextStyle(
              fontSize: SizeConfig.h(14),
            ),
            errorStyle: TextStyle(fontSize: SizeConfig.h(14)),
            fillColor: Colors.white70),
      ),
    );
  }
}

class AppleButton extends StatelessWidget {
  const AppleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await sl<Repository>().logInByApple();
        result.fold((l) {
          AppSnackBar.show(context, l.errorMessage, ToastType.Error);
        }, (r) {
          sl<AuthBloc>().add(
              LoginSocialEvent(provider: SocialLoginProvider.apple, token: r));
        });
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.6,
        height: SizeConfig.h(50),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 3.0),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.2)),
            ],
            borderRadius: BorderRadius.circular(SizeConfig.h(28))),
        child: Row(
          children: [
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.h(17),
                ),
                Icon(FontAwesomeIcons.apple)
              ],
            ),
            SizedBox(
              width: SizeConfig.h(5),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).sign_with_apple, style: AppStyle.vexa12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
