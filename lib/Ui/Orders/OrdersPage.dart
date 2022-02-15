import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/Ui/Orders/bloc/orders_bloc.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '/generated/l10n.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersBloc ordersBloc = OrdersBloc();
  @override
  void initState() {
    ordersBloc.add(LoadEvent(""));

    super.initState();
  }

  @override
  void dispose() {
    ordersBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          CustomAppBar(
            isCustom: true,
            child: Row(
              children: [
                BackButton(
                  color: AppStyle.whiteColor,
                ),
                Text(
                  S.of(context).orderHistory,
                  style: AppStyle.vexa16,
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder(
              bloc: ordersBloc,
              builder: (context, state) {
                if (state is ErrorState) {
                  return AppErrorWidget(text: state.error);
                }
                if (state is LoadingState) {
                  return AppLoader();
                }
                if (state is SuccessState<List<OrderItem>>) {
                  if (state.items.isEmpty) {
                    return EmptyPlacholder(
                      title: S.of(context).no_result,
                      imageName: "assets/noSearch.png",
                      subtitle: S.of(context).no_result_subtitle,
                      actionTitle: S.of(context).continueShopping,
                      onActionTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                  return ListView.builder(
                      controller: ordersBloc.scrollController,
                      padding: EdgeInsets.only(top: SizeConfig.h(7)),
                      itemCount: state.hasReachedMax
                          ? state.items.length
                          : state.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return AppLoader();
                        }
                        final order = state.items[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.h(24),
                              vertical: SizeConfig.h(7)),
                          padding: EdgeInsets.all(SizeConfig.h(14)),
                          decoration: BoxDecoration(
                              color: AppStyle.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 30,
                                    offset: Offset(0.0, 30),
                                    color: Colors.black12)
                              ],
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.h(10))),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (order.createdAt != null)
                                        Text(
                                          intl.DateFormat("yyyy-MMM-dd", "ar")
                                              .format(DateTime.parse(
                                                  order.createdAt!)),
                                          style: AppStyle.vexa14,
                                        ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.h(200),
                                        child: Text(
                                          order.totalText,
                                          style: AppStyle.vexaLight12.copyWith(
                                              fontFamily:
                                                  AppStyle.priceFontFamily(
                                            order.totalText,
                                          )),
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/orderDetails",
                                          arguments: order.id);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          S.of(context).details,
                                          style: AppStyle.vexaLight12.copyWith(
                                              color: AppStyle.primaryColor),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: AppStyle.primaryColor,
                                          size: SizeConfig.h(11),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: SizeConfig.h(5),
                              ),
                              if (order.itemsThumbnails?.isNotEmpty ?? false)
                                SizedBox(
                                  height: SizeConfig.h(60),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                              itemCount: order.itemsThumbnails
                                                      ?.length ??
                                                  0,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  SizeConfig.h(
                                                                      5)),
                                                      width: SizeConfig.h(44),
                                                      height: SizeConfig.h(44),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          SizeConfig.h(10),
                                                        ),
                                                        child: Image.network(
                                                          order.itemsThumbnails![
                                                              index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }))
                                    ],
                                  ),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.items[index].shippingStatusText ??
                                          "",
                                      style: AppStyle.vexaLight12,
                                    ),
                                  ),
                                  // Text(
                                  //   order.status ?? "",
                                  //   style: AppStyle.vexaLight12
                                  //       .copyWith(color: AppStyle.yellowColor),
                                  // )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          )
        ]));
  }
}
