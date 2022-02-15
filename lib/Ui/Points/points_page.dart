import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tajra/App/Widgets/AppLoader.dart';
import 'package:tajra/App/Widgets/CustomAppBar.dart';
import 'package:tajra/App/Widgets/MainButton.dart';
import 'package:tajra/Ui/Profile/blocs/bloc/points_bloc.dart';
import 'package:tajra/Utils/SizeConfig.dart';
import 'package:tajra/Utils/Style.dart';
import 'package:tajra/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../injections.dart';

class MyPointsPage extends StatefulWidget {
  MyPointsPage({Key? key}) : super(key: key);

  @override
  _MyPointsPageState createState() => _MyPointsPageState();
}

class _MyPointsPageState extends State<MyPointsPage> {
  final PointsBloc bloc = PointsBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(GetMyPointEvent());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          child: Column(
            children: [
              CustomAppBar(
                isCustom: true,
                child: Row(
                  children: [
                    BackButton(
                      color: AppStyle.whiteColor,
                    ),
                    Text(
                      S.of(context).my_points,
                      style: AppStyle.vexa16,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.h(16),
              ),
              Expanded(
                  child: BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is LoadingPoints) {
                    return Column(
                      children: [AppLoader()],
                    );
                  }
                  if (state is ErrorInPoints) {
                    return Text(
                      state.error,
                      style: AppStyle.vexa12,
                    );
                  }
                  if (state is PointReady) {
                    return Column(
                      children: [
                        Image.asset(
                          "assets/myPoints.png",
                          height: SizeConfig.h(200),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: S.of(context).carneed_points,
                                          style: AppStyle.vexa13.copyWith(
                                              color: AppStyle.primaryColor,
                                              fontFamily: "Almaria"),
                                          children: [
                                            TextSpan(
                                              text: S
                                                  .of(context)
                                                  .carneed_points_desc,
                                              style: AppStyle.vexa13.copyWith(
                                                  color: Colors.black),
                                            )
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.h(40),
                              ),
                              Container(
                                padding: EdgeInsets.all(SizeConfig.h(8)),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFEFDEB),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/coin.png",
                                      height: SizeConfig.h(46),
                                      width: SizeConfig.h(46),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.h(16),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).current_points_balance,
                                          style: AppStyle.vexa12,
                                        ),
                                        SizedBox(
                                          height: SizeConfig.h(4),
                                        ),
                                        Text(
                                          (state.pointsResponse.currentPoints ??
                                                      "")
                                                  .toString() +
                                              " " +
                                              S.of(context).point,
                                          style: AppStyle.vexa16.copyWith(
                                              color: AppStyle.yellowColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.h(16),
                              ),
                              Container(
                                padding: EdgeInsets.all(SizeConfig.h(8)),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF5F6FE),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/usedPoints.png",
                                      height: SizeConfig.h(46),
                                      width: SizeConfig.h(46),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.h(16),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).used_points,
                                          style: AppStyle.vexa12,
                                        ),
                                        SizedBox(
                                          height: SizeConfig.h(4),
                                        ),
                                        Text(
                                          (state.pointsResponse.usedPoints ??
                                                      "")
                                                  .toString() +
                                              " " +
                                              S.of(context).point,
                                          style: AppStyle.vexa16.copyWith(
                                              color: AppStyle.yellowColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.h(16),
                              ),
                              Container(
                                padding: EdgeInsets.all(SizeConfig.h(8)),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFF5F6),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/totalPoints.png",
                                      height: SizeConfig.h(46),
                                      width: SizeConfig.h(46),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.h(16),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).total_saving,
                                          style: AppStyle.vexa12,
                                        ),
                                        SizedBox(
                                          height: SizeConfig.h(4),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              (state.pointsResponse
                                                              .totalSaving ??
                                                          "")
                                                      .toString() +
                                                  " ",
                                              style: AppStyle.vexa16.copyWith(
                                                  fontFamily: AppStyle
                                                      .priceFontFamily(state
                                                              .pointsResponse
                                                              .totalSaving ??
                                                          ""),
                                                  color: AppStyle.yellowColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.h(16),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pushNamed(context, '/change_points',
                              //         arguments:
                              //             state.pointsResponse.currentPoints);
                              //   },
                              //   child: Container(
                              //     width: SizeConfig.screenWidth * 0.5,
                              //     padding: EdgeInsets.all(SizeConfig.h(8)),
                              //     decoration: BoxDecoration(
                              //         color: AppStyle.primaryColor,
                              //         borderRadius: BorderRadius.circular(12)),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         SvgPicture.asset(
                              //           "assets/foreign.svg",
                              //           height: SizeConfig.h(35),
                              //           width: SizeConfig.h(35),
                              //           color: AppStyle.whiteColor,
                              //         ),
                              //         SizedBox(
                              //           width: SizeConfig.h(4),
                              //         ),
                              //         Text(
                              //           S.of(context).share_to_get_points,
                              //           style: AppStyle.vexa16.copyWith(
                              //               color: AppStyle.whiteColor,
                              //               fontWeight: FontWeight.bold),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: SizeConfig.h(16),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/change_points',
                                  );
                                },
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.5,
                                  padding: EdgeInsets.all(SizeConfig.h(8)),
                                  decoration: BoxDecoration(
                                      color: AppStyle.primaryColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/cart.svg",
                                        height: SizeConfig.h(35),
                                        width: SizeConfig.h(35),
                                        color: AppStyle.whiteColor,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.h(4),
                                      ),
                                      Text(
                                        S
                                            .of(context)
                                            .change_points_with_products,
                                        style: AppStyle.vexa16.copyWith(
                                            color: AppStyle.whiteColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.h(16),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    S.of(context).share_to_get_points,
                                    textAlign: TextAlign.center,
                                    style: AppStyle.vexa14
                                        .copyWith(color: Colors.black),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.h(16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  actionShare(
                                      sl<HomesettingsBloc>()
                                              .settings
                                              ?.user
                                              ?.refLink ??
                                          "",
                                      SizeConfig.screenWidth);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MainButton(
                                        child: SizedBox(
                                          width: SizeConfig.screenWidth * 0.5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/foreign.svg",
                                                height: SizeConfig.h(18),
                                                width: SizeConfig.h(18),
                                                color: AppStyle.primaryColor,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.h(4),
                                              ),
                                              Text(S.of(context).shareApp,
                                                  style: AppStyle.vexa16
                                                      .copyWith(
                                                          color: AppStyle
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        isOutlined: true)
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }

                  return SizedBox();
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
