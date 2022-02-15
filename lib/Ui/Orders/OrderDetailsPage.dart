import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Orders/bloc/orderdetails_bloc.dart';
import '/Ui/Orders/widgets/RatingWidget.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '/generated/l10n.dart';

class OrderDetailsPage extends StatefulWidget {
  OrderDetailsPage({required this.orderId, Key? key}) : super(key: key);
  final int orderId;
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrderdetailsBloc bloc = OrderdetailsBloc();
  @override
  void initState() {
    bloc.add(GetOrderDetailsEvent(widget.orderId));
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          CustomAppBar(
            isCustom: true,
            child: Row(
              children: [
                BackButton(
                  color: AppStyle.whiteColor,
                ),
                Text(
                  S.of(context).product_details,
                  style: AppStyle.vexa16,
                )
              ],
            ),
          ),
          BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is ErrorInDetails) {
                return AppErrorWidget(text: state.error);
              }
            else  if (state is LoadingDetails) {
                return AppLoader();
              }
             else if (state is OrderDetailsReady) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.h(24),
                          vertical: SizeConfig.h(14)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 30,
                                offset: Offset(0.0, 10))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      padding: EdgeInsets.all(SizeConfig.h(12)),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).orderNumber,
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                S.of(context).order_date,
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                S.of(context).order_details,
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                S.of(context).order_details,
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.h(10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.order.uuid.toString(),
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                intl.DateFormat("yyyy-MMM-dd", "ar").format(
                                    DateTime.parse(state.order.createdAt!)),
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                state.order.shippingStatusText ?? "",
                                style: AppStyle.vexa12,
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                              Text(
                                state.order.totalText,
                                style: AppStyle.vexa12.copyWith(
                                    fontFamily: AppStyle.priceFontFamily(
                                  state.order.totalText,
                                )),
                              ),
                              SizedBox(
                                height: SizeConfig.h(14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    for (OrderProduct item in (state.order.itemsList ?? []))
                      buildOrderProductCard(item)
                  ],
                );
              }
              return Container();
            },
          )
        ]),
      ),
    );
  }

  Widget buildOrderProductCard(OrderProduct item) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/productDetails",
            arguments: {"id": item.itemId.toString(), "goToOptions": false},
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.h(24), vertical: SizeConfig.h(5)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 30,
                    offset: Offset(0.0, 10))
              ],
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          padding: EdgeInsets.all(SizeConfig.h(15)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppStyle.disabledBorderColor)),
                    height: SizeConfig.h(119),
                    width: SizeConfig.h(90),
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(10)),
                    child: Image.network(
                      item.coverImage,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.h(14),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? "",
                        style: AppStyle.vexa14,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                        SizedBox(
                          width: SizeConfig.w(150),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Wrap(
                                spacing: 3,
                                children: [
                                  for (int i = 0;
                                      i < (item.optionsData?.length ?? 0);
                                      i++)
                                    Text(
                                        item.optionsData![i].allowedOptions[item
                                                .optionsData![i].selectedOption] +
                                            (i == item.optionsData!.length - 1
                                                ? ""
                                                : " , "),
                                        style: AppStyle.vexa12)
                                ],
                              ))
                            ],
                          ),
                        ),
                      SizedBox(
                        width: SizeConfig.h(190),
                        child: Html(
                          data: item.description,
                          style: {
                            "*": Style.fromTextStyle(AppStyle.vexa12).copyWith(
                              maxLines: 2,
                            )
                          },
                        ),
                      ),
                      Text(item.priceText,
                          style: AppStyle.yaroCut14.copyWith(
                              fontSize: SizeConfig.h(16),
                              fontFamily:
                                  AppStyle.priceFontFamily(item.priceText))),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.h(14),
              ),
              if (item.canReview ?? false)
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AppRatingWidget(itemId: item.orderItemId);
                        }).then((value) {
                      if (value != null && value)
                        bloc.add(GetOrderDetailsEvent(widget.orderId));
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: MainButton(
                            child: Container(
                              height: SizeConfig.h(26),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).rateOrder,
                                    style: AppStyle.vexa16
                                        .copyWith(color: AppStyle.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            isOutlined: true),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ));
  }

  //? old Design
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       children: [
  //         CustomAppBar(
  //           isCustom: true,
  //           child: Row(
  //             children: [
  //               BackButton(
  //                 color: AppStyle.whiteColor,
  //               ),
  //               Text(
  //                 "3 نيسان 2020",
  //                 style: AppStyle.vexa16,
  //               )
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //             child: ListView.builder(
  //                 padding: EdgeInsets.only(top: SizeConfig.h(5)),
  //                 itemCount: 5,
  //                 itemBuilder: (context, index) {
  //                   if (index == 4) return buildTotalWidget();
  //                   return buildProductCard();
  //                 })),
  //         buildCheckoutButtons(),
  //         SizedBox(
  //           height: SizeConfig.h(50),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Container buildTotalWidget() {
  //   return Container(
  //       margin: EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
  //       color: Colors.white,
  //       width: SizeConfig.screenWidth,
  //       height: SizeConfig.h(70),
  //       padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Row(
  //             children: [
  //               Text(
  //                 "الإجمالي",
  //                 style: AppStyle.vexa14,
  //               )
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               Text(
  //                 "340,65 Tl",
  //                 style:
  //                     AppStyle.yaroCut14.copyWith(fontSize: SizeConfig.h(22)),
  //               )
  //             ],
  //           ),
  //         ],
  //       ));
  // }

  // Widget buildCheckoutButtons() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
  //     child: SizedBox(
  //       height: SizeConfig.h(44),
  //       child: Row(
  //         children: [
  //           Expanded(
  //               child: MainButton(
  //             isOutlined: true,
  //             child: Center(
  //               child: Text(
  //                 "متابعة الطلب",
  //                 style: AppStyle.vexa16.copyWith(color: AppStyle.primaryColor),
  //               ),
  //             ),
  //           ))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildProductCard() {
  //   return Container(
  //       margin: EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
  //       color: Colors.white,
  //       width: SizeConfig.screenWidth,
  //       height: SizeConfig.h(70),
  //       padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
  //       child: Row(
  //         children: [
  //           Row(
  //             children: [
  //               SizedBox(
  //                 width: SizeConfig.h(50),
  //                 child: Image.asset("assets/eggs.png"),
  //               ),
  //               Text("صحن بيض 100 غرام", style: AppStyle.vexa14),
  //             ],
  //           ),
  //         ],
  //       ));
  // }
}
