import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/MainButton.dart';
import '/App/Widgets/ProductCard.dart';
import '/Ui/ProductDetails/bloc/productdetails_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Ui/ProductDetails/photo_zoom.dart';
import '/Ui/ProductDetails/widgets/FavouriteButton.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/HeroDialoge.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import '/generated/l10n.dart';
import '../../injections.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsDetailsPage extends StatefulWidget {
  final String id;
  final bool goToOptions;
  final bool forPointSale;

  ProductsDetailsPage(
      {required this.id,
      Key? key,
      required this.goToOptions,
      this.forPointSale: false})
      : super(key: key);

  @override
  _ProductsDetailsPageState createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  final ProductdetailsBloc bloc = ProductdetailsBloc();

  @override
  void initState() {
    bloc.add(GetDetails(widget.id));
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  final optionsKey = GlobalKey();
  bool showSelectOptions = false;
  Map<String, String> selectedOptions = {};
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BlocConsumer(
        bloc: bloc,
        listener: (prev, curr) async {
          if (widget.goToOptions) if (curr is DetailsReady) {
            await Future.delayed(const Duration(milliseconds: 200));
            Scrollable.ensureVisible(optionsKey.currentContext!,
                duration: const Duration(milliseconds: 350),
                curve: Curves.fastOutSlowIn,
                alignment: 0.5);
            AppSnackBar.show(
                context, S.of(context).selectOptions, ToastType.Info);
          }
        },
        builder: (context, state) {
          if (state is LoadingDetails) {
            return Column(
              children: [
                Container(child: buildAppBar(false, null)),
                Expanded(child: AppLoader())
              ],
            );
          } else if (state is ErrorInDetails)
            return Center(
              child: AppErrorWidget(text: state.error),
            );
          else if (state is DetailsReady) {
            final product = state.product;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        //appbar hieght
                        height: SizeConfig.h(70 + topPadding),
                      ),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              HeroDialogRoute(
                                builder: (context) => GallaryPage(
                                  images: product.imagesBag ?? [],
                                  currentIndex: currentIndex,
                                ),
                              ),
                            );
                          },
                          child: buildCarousel(product.imagesBag ?? [])),
                      SizedBox(
                        height: SizeConfig.h(16),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.h(24)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ...List.generate(
                                        product.rating ?? 0,
                                        (index) => Icon(
                                              Icons.star,
                                              color: AppStyle.yellowColor,
                                              size: SizeConfig.h(12),
                                            ))
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      product.title,
                                      style: AppStyle.vexa16.copyWith(
                                          color: AppStyle.secondaryColor),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          actionShare(product.publicLink ?? "",
                                              SizeConfig.screenWidth);
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(SizeConfig.h(2)),
                                          child: Center(
                                            child: Icon(
                                              Icons.share_outlined,
                                              size: SizeConfig.h(18),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppStyle.secondaryColor
                                                .withOpacity(0.1),
                                          ),
                                          height: SizeConfig.h(24),
                                          width: SizeConfig.h(24),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                SelectableLinkify(
                                  text: _parseHtmlString(
                                      product.description ?? ""),
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      launch(link.url);
                                    } else {}
                                  },
                                  linkStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppStyle.secondaryColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: SizeConfig.h(12),
                                  ),
                                  style: AppStyle.vexaLight12.copyWith(
                                    backgroundColor: Colors.transparent,
                                    // whiteSpace: WhiteSpace.PRE,
                                    // lineHeight: LineHeight(1.5),
                                    height: 1.5,
                                    color: Color(0xFF444444),
                                  ),
                                ),
                                // SelectableHtml(
                                //   data: product.description ?? "",
                                //   style: {
                                //     "*": Style.fromTextStyle(
                                //         AppStyle.vexaLight12)
                                //         .copyWith(
                                //         backgroundColor: Colors.transparent,
                                //         whiteSpace: WhiteSpace.PRE,
                                //         lineHeight: LineHeight(1.5),
                                //         color: Color(0xFF444444),
                                //     )
                                //   },
                                // ),
                                if (product.optionsData != null &&
                                    product.optionsData!.isNotEmpty)
                                  Column(
                                    key: optionsKey,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.h(7),
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          Text(
                                            S.of(context).options,
                                            style: AppStyle.vexa16.copyWith(
                                                color: AppStyle.secondaryColor),
                                          ),
                                        ],
                                      ),
                                      for (OptionData option
                                          in product.optionsData!)
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: SizeConfig.h(7),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  option.title + " :",
                                                  style: AppStyle.vexa14,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: SizeConfig.h(7),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Wrap(
                                                  spacing: 4,
                                                  children: [
                                                    for (var i in option
                                                        .allowedOptions.entries)
                                                      RawChip(
                                                          selectedColor:
                                                              AppStyle
                                                                  .primaryColor,
                                                          checkmarkColor:
                                                              AppStyle
                                                                  .whiteColor,
                                                          onSelected:
                                                              (isSelected) {
                                                            if (isSelected) {
                                                              setState(() {
                                                                if (!selectedOptions
                                                                    .containsKey(option
                                                                        .optionId
                                                                        .toString())) {
                                                                  selectedOptions.putIfAbsent(
                                                                      option
                                                                          .optionId
                                                                          .toString(),
                                                                      () => i
                                                                          .key
                                                                          .toString());
                                                                } else {
                                                                  selectedOptions[
                                                                      option
                                                                          .optionId
                                                                          .toString()] = i
                                                                      .key
                                                                      .toString();
                                                                }
                                                              });
                                                            }
                                                          },
                                                          selected:
                                                              isOptionSelected(
                                                                  option,
                                                                  i.key
                                                                      .toString()),
                                                          label: Text(
                                                            i.value.toString(),
                                                            style: AppStyle.vexa12.copyWith(
                                                                color: isOptionSelected(
                                                                        option,
                                                                        i.key
                                                                            .toString())
                                                                    ? AppStyle
                                                                        .whiteColor
                                                                    : AppStyle
                                                                        .secondaryColor),
                                                          ))
                                                  ],
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      SizedBox(
                                        height: SizeConfig.h(7),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                Divider(),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).total,
                                      style: AppStyle.vexa16.copyWith(
                                          color: AppStyle.secondaryColor),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          product.presalePriceText != null &&
                                                  product.presalePriceText!
                                                          .substring(0, 4) !=
                                                      '0.00'
                                              ? product.presalePriceText!
                                              : "",
                                          style: AppStyle.yaroCut14.copyWith(
                                              fontSize: SizeConfig.h(12),
                                              fontFamily:
                                                  AppStyle.priceFontFamily(
                                                product.presalePriceText!,
                                              ),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.normal,
                                              color: AppStyle.redColor),
                                        ),
                                        Text(
                                          product.priceText,
                                          style: AppStyle.yaroCut14.copyWith(
                                              fontFamily:
                                                  AppStyle.priceFontFamily(
                                                      product.priceText),
                                              fontSize: SizeConfig.h(22)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                Divider(),
                                SizedBox(
                                  height: SizeConfig.h(7),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).related_products,
                                      style: AppStyle.vexa14,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.h(14),
                          ),
                          buildProductsSection(product.relatedItems ?? []),
                          SizedBox(
                            height: SizeConfig.h(25),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.h(45),
                      )
                    ],
                  ),
                ),
                Container(child: buildAppBar(product.isFavorite, product.id)),
                buildAddToCart(product),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  bool isOptionSelected(OptionData option, i) {
    return selectedOptions.containsKey(option.optionId.toString()) &&
        selectedOptions[option.optionId.toString()] == i;
  }

  bool loadingCart = false;
  int count = 1;
  final Debouncer debouncer = Debouncer();

  void addToCart() async {
    setState(() {
      loadingCart = true;
    });
    final result = await AddToCart(sl()).call(AddToCartParams(
        productId: int.parse(widget.id),
        qty: count,
        selectedOptions: selectedOptions));
    setState(() {
      loadingCart = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      AppSnackBar.show(context, S.of(context).addedToCart, ToastType.Success);
    });
  }

  Widget buildAddToCart(Product product) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, boxShadow: [AppStyle.boxShadow3on6]),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.h(24), vertical: SizeConfig.h(12)),
        child: Row(
          children: [
            if (!widget.forPointSale)
              GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: SizeConfig.h(25),
                      color: AppStyle.primaryColor,
                    ),
                  ),
                  width: SizeConfig.h(30),
                  height: SizeConfig.h(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 2, color: AppStyle.disabledColor)),
                ),
              ),
            if (!widget.forPointSale)
              SizedBox(
                width: SizeConfig.h(6),
              ),
            if (!widget.forPointSale)
              Container(
                child: Center(
                    child: Text(
                  count.toString(),
                  style: AppStyle.yaroCut14,
                )),
                width: SizeConfig.h(46),
                height: SizeConfig.h(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(width: 2, color: AppStyle.disabledColor)),
              ),
            if (!widget.forPointSale)
              SizedBox(
                width: SizeConfig.h(6),
              ),
            if (!widget.forPointSale)
              GestureDetector(
                onTap: () {
                  if (count > 1) {
                    setState(() {
                      count--;
                    });
                  }
                },
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      size: SizeConfig.h(25),
                      color: AppStyle.primaryColor,
                    ),
                  ),
                  width: SizeConfig.h(30),
                  height: SizeConfig.h(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 2, color: AppStyle.disabledColor)),
                ),
              ),
            if (!widget.forPointSale)
              SizedBox(
                width: SizeConfig.h(17),
              ),
            Expanded(
              child: MainButton(
                  onTap: loadingCart
                      ? null
                      : () {
                          if (product.optionsData != null &&
                              product.optionsData!.isNotEmpty &&
                              selectedOptions.keys.length !=
                                  product.optionsData!.length) {
                            Scrollable.ensureVisible(optionsKey.currentContext!,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.fastOutSlowIn,
                                alignment: 0.5);
                            AppSnackBar.show(context,
                                S.of(context).selectOptions, ToastType.Info);
                          } else {
                            if (widget.forPointSale) {
                              Navigator.pushNamed(context, "/checkout_points",
                                  arguments: {
                                    "total": product.pointsPrice ?? 0,
                                    "product_id": product.id,
                                    "options": selectedOptions
                                  });
                            } else
                              addToCart();
                          }
                        },
                  child: Container(
                    height: SizeConfig.h(26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.forPointSale
                              ? S.of(context).buyNow
                              : S.of(context).addToCart,
                          style: AppStyle.vexa16,
                        ),
                        if (loadingCart)
                          Row(
                            children: [
                              SizedBox(
                                width: SizeConfig.h(10),
                              ),
                              SizedBox(
                                width: SizeConfig.h(15),
                                height: SizeConfig.h(15),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  isOutlined: false),
            ),
          ],
        ),
      ),
    );
  }

  Container buildProductsSection(List<Product> relatedProducts) {
    return Container(
      height: SizeConfig.h(260),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: relatedProducts[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel(List<String> images) {
    double hieght = 250;
    return Container(
      width: double.infinity,
      height: SizeConfig.h(hieght),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  enableInfiniteScroll: true,
                  height: SizeConfig.h(hieght),
                  autoPlay: true,
                  // aspectRatio: 3.45555555 / 2,
                  autoPlayInterval: Duration(seconds: 7),
                  scrollDirection: Axis.horizontal,
                  viewportFraction: SizeConfig.isWideScreen() ? 0.7 : 1),
              items: [
                for (String url in images)
                  Container(
                    margin: SizeConfig.isWideScreen()
                        ? EdgeInsets.symmetric(horizontal: SizeConfig.h(12))
                        : null,
                    height: SizeConfig.h(hieght),
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                    ),
                  ),
              ]),
          Positioned(
            bottom: SizeConfig.h(20),
            child: Row(
              children: [
                ...List.generate(
                    images.length,
                    (index) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: SizeConfig.h(7)),
                          height: 2,
                          width: SizeConfig.h(50),
                          decoration: BoxDecoration(
                            color: index == currentIndex
                                ? AppStyle.secondaryColor
                                : AppStyle.disabledBorderColor,
                          ),
                        ))
              ],
            ),
          )
        ],
      ),
    );
  }

  CustomAppBar buildAppBar(bool isFavorite, int? id) {
    return CustomAppBar(
      isCustom: true,
      child: Row(
        children: [
          Row(
            children: [
              BackButton(
                color: AppStyle.whiteColor,
              ),
              Text(
                S.of(context).product_details,
                style: AppStyle.vexa16,
              ),
            ],
          ),
          Spacer(),
          if (id != null)
            FavoriteButton(
              isFavorite: isFavorite,
              id: id,
            ),
          SizedBox(
            width: SizeConfig.h(24),
          )
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? "";
    return parsedString.replaceAll('\n', '\n\n');
  }
}
