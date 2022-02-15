import 'package:flutter/material.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/Ui/Cart/bloc/cart_bloc.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Addresses/DefaultAddress.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injections.dart';
import 'CheckoutSuccessPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key, required this.total, required this.discount})
      : super(key: key);
  final String total;
  final String? discount;
  @override
  _CheckoutPageState createState() => _CheckoutPageState(total, discount);
}

class _CheckoutPageState extends State<CheckoutPage> {
  String total;
  _CheckoutPageState(this.total, this.discountPrice);
  final TextEditingController noteController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  String? discountPrice;
  bool isLoading = false;
  Address? defaultAddress;
  Key defaultAddressKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CouponAccepted) {
          discountPrice = state.useCouponResponse.newPrice;
          AppSnackBar.show(
              context, S.of(context).coupon_accepted, ToastType.Success);
        }
        if (state is ErrorInCoupon) {
          AppSnackBar.show(
              context, S.of(context).coupon_rejected, ToastType.Error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
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
                            S.of(context).checkoutCart,
                            style: AppStyle.vexa16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.h(14),
                    ),
                    buildAddressWidget(),
                    SizedBox(
                      height: SizeConfig.h(14),
                    ),
                    buildPaymentMethodWidget(),
                    SizedBox(
                      height: SizeConfig.h(15),
                    ),
                    buildCouponWidget(),
                    SizedBox(
                      height: SizeConfig.h(15),
                    ),
                    Container(
                      padding: EdgeInsets.all(SizeConfig.h(24)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 30,
                                offset: Offset(0.0, 10),
                                color: Colors.black26)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).notes,
                            style: AppStyle.vexa16
                                .copyWith(color: AppStyle.secondaryColor),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: SizeConfig.h(130),
                                child: TextFormField(
                                  autofocus: false,
                                  controller: noteController,
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  style: AppStyle.vexa14,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16))),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.h(120),
                    ),
                  ],
                ),
              ),
              buildTotalWidget(),
            ],
          ),
        );
      },
    );
  }

  Container buildAddressWidget() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.h(24)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 30, offset: Offset(0.0, 10), color: Colors.black26)
      ]),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).deliver_address,
                style: AppStyle.vexa16.copyWith(color: AppStyle.secondaryColor),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/myAddresses").then((value) {
                      setState(() {
                        defaultAddressKey = UniqueKey();
                      });
                    });
                  },
                  child: Text(
                    S.of(context).change_address,
                    style:
                        AppStyle.vexa14.copyWith(color: AppStyle.primaryColor),
                  ))
            ],
          ),
          Divider(),
          MyDefaultAddress(
              key: defaultAddressKey,
              getAddressCallback: (v) {
                setState(() {
                  defaultAddress = v;
                });
              }),
        ],
      ),
    );
  }

  Container buildPaymentMethodWidget() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.h(24)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 30, offset: Offset(0.0, 10), color: Colors.black26)
      ]),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).paymentMethod,
                style: AppStyle.vexa16.copyWith(color: AppStyle.secondaryColor),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: AppStyle.disabledBorderColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppStyle.greyColor)),
                padding: EdgeInsets.all(SizeConfig.h(14)),
                child: Row(
                  children: [
                    Text(
                      S.of(context).onDelivery,
                      style: AppStyle.vexa12
                          .copyWith(color: AppStyle.secondaryColor),
                    ),
                    Spacer(),
                    // Icon(
                    //   Icons.arrow_downward,
                    //   color: AppStyle.greyColor,
                    //   size: SizeConfig.h(20),
                    // )
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  Container buildCouponWidget() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.h(24)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 30, offset: Offset(0.0, 10), color: Colors.black26)
      ]),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).coupon,
                style: AppStyle.vexa16.copyWith(color: AppStyle.secondaryColor),
              ),
            ],
          ),
          Divider(),
          Row(children: [
            Expanded(
              child: TextField(
                controller: couponController,
                style: AppStyle.vexa12,
                decoration: InputDecoration(
                    labelText: S.of(context).enterCouponHere,
                    labelStyle: AppStyle.vexa12,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            SizedBox(
              width: SizeConfig.h(20),
            ),
            SizedBox(
              width: SizeConfig.h(75),
              height: SizeConfig.h(45),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CheckingCoupon) return AppLoader();
                  return MainButton(
                      onTap: () {
                        if (couponController.text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<CartBloc>(context)
                              .add(UseCouponEvent(couponController.text));
                        }
                      },
                      child: Center(
                        child: Text(
                          S.of(context).use_coupon,
                          style: AppStyle.vexa14.copyWith(color: Colors.white),
                        ),
                      ),
                      isOutlined: false);
                },
              ),
            )
          ])
        ],
      ),
    );
  }

  Container buildTotalWidget() {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 30, offset: Offset(0.0, 10), color: Colors.black26)
        ]),
        width: SizeConfig.screenWidth,
        height: SizeConfig.h(85),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).total,
                      style: AppStyle.vexa14,
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.h(5),
                ),
                if (discountPrice != null && discountPrice!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            total,
                            style: AppStyle.yaroCut14.copyWith(
                                fontSize: SizeConfig.h(16),
                                decoration: TextDecoration.lineThrough,
                                color: AppStyle.redColor,
                                fontFamily:
                                    AppStyle.priceFontFamily(widget.total)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            discountPrice!,
                            style: AppStyle.yaroCut14.copyWith(
                                fontSize: SizeConfig.h(22),
                                fontFamily:
                                    AppStyle.priceFontFamily(widget.total)),
                          )
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Text(
                        total,
                        style: AppStyle.yaroCut14.copyWith(
                            fontSize: SizeConfig.h(22),
                            fontFamily: AppStyle.priceFontFamily(widget.total)),
                      )
                    ],
                  ),
              ],
            ),
            Spacer(),
            if (isLoading)
              Row(children: [AppLoader()])
            else
              SizedBox(
                width: SizeConfig.h(160),
                height: SizeConfig.h(45),
                child: MainButton(
                    onTap: () async {
                      if (defaultAddress == null) {
                        AppSnackBar.show(context, S.of(context).mustAddAddress,
                            ToastType.Error);
                      } else {
                        await checkout(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        S.of(context).checkoutCart,
                        style: AppStyle.vexa14.copyWith(color: Colors.white),
                      ),
                    ),
                    isOutlined: false),
              )
          ],
        ));
  }

  Future<void> checkout(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final result = await Checkout(sl()).call(CheckoutParams(
        checkoutModel: CheckoutModel(
            addressId: defaultAddress!.id,
            paymentMethod: PaymentMethods.cod,
            notes: noteController.text)));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => CheckoutSuccessPage()));
      BlocProvider.of<CartBloc>(context).add(GetCartEvent());
    });
  }
}
