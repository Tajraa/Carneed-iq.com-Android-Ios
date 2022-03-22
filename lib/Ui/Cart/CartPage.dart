import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/App/Widgets/LoginDialoge.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Cart/bloc/cart_bloc.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/generated/l10n.dart';
import '/injections.dart';
part 'widgets/cart_tutorial.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key, required this.goHome}) : super(key: key);
  final Function()? goHome;
  @override
  _CartPageState createState() => _CartPageState();
}

bool showedCartTutorial = false;

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  GlobalKey checkoutKey = GlobalKey();
  GlobalKey whatsappKey = GlobalKey();
  GlobalKey deleteKey = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus>? targets;

  getPreferences() async {
    final result = await GetPreferences(sl()).call(NoParams());
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      if (mounted)
        setState(() {
          whatsappNumber = r["support_whatsapp"];
        });
    });
  }

  String? whatsappNumber;

  CartModel? cart;
  final Debouncer debouncer = Debouncer(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(isCustom: false),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
                    return Future.delayed(Duration(seconds: 2))
                        .then((value) {});
                  },
                  child: BlocConsumer<CartBloc, CartState>(
                    listener: (pre, cur) {
                      if (cur is ErrorInOperation) {
                        AppSnackBar.show(context, cur.error, ToastType.Error);
                      }
                      if (cur is CartReady) {
                        cart = cur.cartModel;
                        if ((cart?.itemsList.isNotEmpty ?? false) &&
                            sl<AuthBloc>().isFirstLaunch &&
                            !showedCartTutorial) {
                          showedCartTutorial = true;

                          Future.delayed(const Duration(milliseconds: 300))
                              .then((v) {
                            initTargets();
                            showTutorial(
                              tutorialCoachMark: tutorialCoachMark,
                              context: context,
                              targets: targets!,
                            );
                          });
                        }
                      }
                    },
                    buildWhen: (prev, cur) {
                      return (cur is LoadingCart ||
                          cur is CartReady ||
                          cur is ErrorInCart);
                    },
                    builder: (context, state) {
                      if (state is LoadingCart) return AppLoader();
                      if (state is ErrorInCart)
                        return AppErrorWidget(text: state.error);
                      if (state is CartReady) if (cart != null) {
                        if (cart!.itemsList.isEmpty) {
                          return EmptyPlacholder(
                            skipNavBarHeight: true,
                            title: S.of(context).cartEmpty,
                            imageName: "assets/noCart.png",
                            subtitle: S.of(context).cart_empty_subtitle,
                            actionTitle: S.of(context).continueShopping,
                            onActionTap: () {
                              widget.goHome!();
                            },
                          );
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.h(5),
                                      bottom: SizeConfig.h(50)),
                                  itemCount: cart!.itemsList.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index >= cart!.itemsList.length)
                                      return buildTotalWidget(
                                          cart!.subtotalText ?? "",
                                          cart!.discountPriceText,
                                          state.isRefreshing);
                                    return buildCartProduct(
                                        cart!.itemsList[index], index == 0);
                                  }),
                            ),
                            SizedBox(
                              height: SizeConfig.h(
                                  checkoutBottomHieght), // +70 for checkout option hieght
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartReady && (cart?.itemsList.isNotEmpty ?? false))
                return buildCheckoutButtons();
              return Container();
            },
          ),
          // Container(
          //   padding: EdgeInsets.only(top: SizeConfig.h(110)),
          //   alignment: Alignment.topCenter,
          //   child: RefreshProgressIndicator(

          //       // semanticsValue: widget.semanticsValue,
          //       // value: showIndeterminateIndicator ? null : _value.value,
          //       // valueColor: _valueColor,
          //       // backgroundColor: widget.backgroundColor,
          //       // strokeWidth: widget.strokeWidth,

          //       ),
          // ),
        ],
      ),
    );
  }

  Container buildTotalWidget(
      String total, String? discount, bool isRefreshing) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
        color: Colors.white,
        width: SizeConfig.screenWidth,
        height: SizeConfig.h(70),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).total,
                      style: AppStyle.vexa14,
                    )
                  ],
                ),
                if (discount != null && discount.isNotEmpty)
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
                                fontFamily: AppStyle.priceFontFamily(discount)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            discount,
                            style: AppStyle.yaroCut14.copyWith(
                                fontSize: SizeConfig.h(22),
                                fontFamily: AppStyle.priceFontFamily(discount)),
                          ),
                          SizedBox(
                            width: SizeConfig.h(10),
                          ),
                          if (isRefreshing)
                            SizedBox(
                                height: SizeConfig.h(15),
                                width: SizeConfig.h(15),
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                )),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        total,
                        style: AppStyle.yaroCut14.copyWith(
                            fontSize: SizeConfig.h(22),
                            fontFamily: AppStyle.priceFontFamily(total)),
                      ),
                      SizedBox(
                        width: SizeConfig.h(10),
                      ),
                      if (isRefreshing)
                        SizedBox(
                            height: SizeConfig.h(15),
                            width: SizeConfig.h(15),
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            )),
                    ],
                  ),
              ],
            ),
          ],
        ));
  }

  double checkoutBottomHieght = AppStyle.bottomNavHieght + 50;

  Positioned buildCheckoutButtons() {
    return Positioned(
        bottom: SizeConfig.h(checkoutBottomHieght),
        left: SizeConfig.h(24),
        width: SizeConfig.screenWidth - SizeConfig.h(48),
        child: Row(
          children: [
            Expanded(
              child: Container(
                key: checkoutKey,
                height: SizeConfig.h(45),
                child: MainButton(
                  onTap: () {
                    if (sl<AuthBloc>().isGuest) {
                      showLoginDialoge(context);
                    } else
                      Navigator.pushNamed(context, "/checkout", arguments: {
                        "total": cart?.totalText,
                        "discount": cart?.discountPriceText
                      });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: SizeConfig.h(18),
                        color: AppStyle.whiteColor,
                      ),
                      SizedBox(
                        width: SizeConfig.h(7),
                      ),
                      Text(
                        S.of(context).order_by,
                        style: AppStyle.vexaLight12.copyWith(
                            fontSize: SizeConfig.h(14),
                            color: AppStyle.whiteColor),
                      ),
                      Text(
                        S.of(context).app,
                        style: AppStyle.vexa14.copyWith(
                            fontSize: SizeConfig.h(14),
                            color: AppStyle.whiteColor),
                      ),
                    ],
                  ),
                  isOutlined: false,
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.h(7),
            ),
            Expanded(
              child: Container(
                key: whatsappKey,
                height: SizeConfig.h(45),
                child: MainButton(
                  onTap: whatsappNumber != null
                      ? () {
                          String products = "";
                          cart!.itemsList.forEach((e) {
                            String options = "";
                            for (int i = 0;
                                i < (e.optionsData?.length ?? 0);
                                i++) {
                              if (i == 0) {
                                options += "(";
                              }
                              options += e.optionsData![i].allowedOptions[
                                      e.optionsData![i].selectedOption] +
                                  (i == e.optionsData!.length - 1
                                      ? ")"
                                      : " , ");
                            }
                            products += "%0A" +
                                e.title +
                                " $options" +
                                "%0A" +
                                e.qty.toString() +
                                " * " +
                                e.priceText;
                          });
                          sendMessageToWhatsapp(whatsappNumber!,
                              """*التفاصيل*$products%0A%0A*الإجمالي*%0A${cart!.totalText}""");
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/whatsapp.svg",
                          height: SizeConfig.h(24), width: SizeConfig.h(24)),
                      SizedBox(
                        width: SizeConfig.h(7),
                      ),
                      Text(
                        S.of(context).send_to,
                        style: AppStyle.vexaLight12.copyWith(
                            fontSize: SizeConfig.h(14),
                            color: AppStyle.greyDark),
                      ),
                      Text(
                        S.of(context).whatsapp,
                        style: AppStyle.vexa14.copyWith(
                            fontSize: SizeConfig.h(14),
                            color: AppStyle.greenColor),
                      ),
                    ],
                  ),
                  isOutlined: true,
                  color: AppStyle.greenColor,
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildCartProduct(CartItem item, bool isFirst) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        BlocProvider.of<CartBloc>(context).add(DeleteFromCartEvent(item.id));
        cart!.itemsList.removeWhere((element) => element.id == item.id);
        return Future.value(true);
        // showDialog<bool>(
        //     context: context,
        //     builder: (context) {
        //       return CupertinoAlertDialog(
        //         title: Text("حذف"),
        //         content: Text("هل تريد حذف المنتج من السلة ؟"),
        //         actions: [
        //           CupertinoDialogAction(
        //               onPressed: () {
        //                 Navigator.pop(context, false);
        //                 // return false;
        //               },
        //               child: Text("رجوع")),
        //           CupertinoDialogAction(
        //               onPressed: () {
        //                 Navigator.pop(context, true);
        //                 // return true;
        //               },
        //               child: Text("حذف"))
        //         ],
        //       );
        //     });
      },
      background: Row(
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.h(14), right: SizeConfig.h(10)),
              width: SizeConfig.h(41),
              height: SizeConfig.h(70),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppStyle.redColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/trash.svg",
                    width: SizeConfig.h(24),
                    height: SizeConfig.h(24),
                  ),
                  Text(
                    S.of(context).delete,
                    style: AppStyle.vexa14.copyWith(color: AppStyle.redColor),
                  ),
                ],
              )),
        ],
      ),
      child: Container(
          key: isFirst ? deleteKey : null,
          margin: EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
          color: Colors.white,
          width: SizeConfig.screenWidth,
          height: SizeConfig.h(70),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
          child: Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.h(50),
                    child: Image.network(item.coverImage),
                  ),
                  SizedBox(
                    width: SizeConfig.h(10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SizeConfig.w(150),
                        child: Text(item.title,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.vexa14),
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
                      )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cart!.itemsList
                          .firstWhere((element) => element.id == item.id)
                          .qty++;
                    });
                    debouncer.run(() {
                      BlocProvider.of<CartBloc>(context).add(
                          UpdateCartEvent(productId: item.id, qty: item.qty));
                    });
                  },
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: SizeConfig.h(15),
                        color: AppStyle.primaryColor,
                      ),
                    ),
                    width: SizeConfig.h(22),
                    height: SizeConfig.h(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 2, color: AppStyle.disabledColor)),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.h(2),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.qty.toString(),
                        style: AppStyle.yaroCut14.copyWith(
                            fontSize: SizeConfig.h(12),
                            fontWeight: FontWeight.normal,
                            height: 1.0),
                      ),
                    ],
                  ),
                  width: SizeConfig.h(46),
                  height: SizeConfig.h(30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 2, color: AppStyle.disabledColor)),
                ),
                SizedBox(
                  width: SizeConfig.h(2),
                ),
                GestureDetector(
                  onTap: item.qty == 1
                      ? null
                      : () {
                          setState(() {
                            cart!.itemsList
                                .firstWhere((element) => element.id == item.id)
                                .qty--;
                          });
                          debouncer.run(() {
                            BlocProvider.of<CartBloc>(context).add(
                                UpdateCartEvent(
                                    productId: item.id, qty: item.qty));
                          });
                        },
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        size: SizeConfig.h(15),
                        color: item.qty == 1
                            ? AppStyle.greyColor
                            : AppStyle.primaryColor,
                      ),
                    ),
                    width: SizeConfig.h(22),
                    height: SizeConfig.h(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 2, color: AppStyle.disabledColor)),
                  ),
                ),
              ])
            ],
          )),
    );
  }

  void initTargets() {
    targets = [];
    targets!.add(TargetFocus(
      identify: "deleteKey",
      keyTarget: deleteKey,
      shape: ShapeLightFocus.RRect,
      radius: 3,
      enableOverlayTab: true,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition:
              CustomTargetContentPosition(top: SizeConfig.screenHeight * .25),
          builder: (context, controller) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset("assets/swip.png",
                      color: AppStyle.whiteColor,
                      width: SizeConfig.h(45),
                      height: SizeConfig.h(45)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).delete_tour,
                      style: AppStyle.vexa16.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));
    targets!.add(
      buildCartTargetFocus(
          "checkoutKey",
          checkoutKey,
          S.of(context).checkoutCart,
          S.of(context).checkout_tour,
          "assets/call.svg"),
    );
    targets!.add(TargetFocus(
      identify: "whatsappKey",
      keyTarget: whatsappKey,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      radius: 3,
      enableOverlayTab: true,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition:
              CustomTargetContentPosition(top: SizeConfig.screenHeight * .5),
          builder: (context, controller) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("assets/whatsapp.svg",
                      width: SizeConfig.h(45), height: SizeConfig.h(45)),
                  SizedBox(
                    height: SizeConfig.h(10),
                  ),
                  Text(
                    S.of(context).checkout_whatsapp_tour_subtitle,
                    style: AppStyle.vexa20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.grediantLightColor,
                        fontSize: SizeConfig.h(24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).checkout_whatsapp_tour_title,
                      style: AppStyle.vexa16.copyWith(
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));
  }
}
