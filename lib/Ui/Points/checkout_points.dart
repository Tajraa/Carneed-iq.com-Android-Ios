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
import '../Cart/CheckoutSuccessPage.dart';

class CheckoutUsingPointsPage extends StatefulWidget {
  CheckoutUsingPointsPage(
      {Key? key, required this.total, required this.productId, this.options})
      : super(key: key);
  final int total;
  final int productId;
  final Map<String, String>? options;
  @override
  _CheckoutUsingPointsPageState createState() =>
      _CheckoutUsingPointsPageState(total);
}

class _CheckoutUsingPointsPageState extends State<CheckoutUsingPointsPage> {
  int total;
  _CheckoutUsingPointsPageState(this.total);

  bool isLoading = false;
  Address? defaultAddress;
  Key defaultAddressKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
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
                            color: AppStyle.secondaryColor,
                          ),
                          Text(
                            S.of(context).change_points_with_products,
                            style: AppStyle.vexa16
                                .copyWith(color: AppStyle.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.h(14),
                    ),
                    buildAddressWidget(),
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
                Row(
                  children: [
                    Text(
                      "$total " + S.of(context).point,
                      style: AppStyle.yaroCut14.copyWith(
                        fontSize: SizeConfig.h(22),
                      ),
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
                        S.of(context).buyNow,
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
    final result = await CheckoutPoints(sl()).call(CheckoutPointsParams(
        addressId: defaultAddress!.id,
        itemId: widget.productId,
        selectedOptions: widget.options));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(
          context, S.of(context).dont_have_points_enogh, ToastType.Error);
    }, (r) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => CheckoutSuccessPage()));
    });
  }
}
