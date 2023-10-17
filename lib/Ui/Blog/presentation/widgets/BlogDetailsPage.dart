import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogDetails.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_blog_det.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../injections.dart';
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
import 'package:html/parser.dart' show parse;
import '/generated/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogsDetailsPage extends StatefulWidget {
  final String id;

  BlogsDetailsPage({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _BlogsDetailsPageState createState() => _BlogsDetailsPageState();
}

late YoutubePlayerController _controller;

class _BlogsDetailsPageState extends State<BlogsDetailsPage> {
  DataBlogDetalse? BlogDetails;
  bool viewBlogDetails = false;
  GetBlogDet() async {
    final result = await GeBlogdeta(sl()).call(widget.id);
    result.fold((l) {}, (r) {
      setState(() {
        BlogDetails = r;
        viewBlogDetails = true;
        if (BlogDetails!.videoUrl! != null)
          _controller = YoutubePlayerController(
            initialVideoId: BlogDetails!.videoUrl!,
          );
      });
    });
  }

  @override
  void initState() {
    GetBlogDet();

    super.initState();
  }

  @override
  void dispose() {
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
        body: !viewBlogDetails
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(alignment: Alignment.topCenter, children: [
                SingleChildScrollView(
                    child: Column(children: [
                  buildAppBar(BlogDetails!.title!),
                  buildCarousel(BlogDetails!.coverImage!),
                  SizedBox(
                    height: SizeConfig.h(16),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.h(7),
                        ),
                        Row(
                          children: [
                            Text(
                              BlogDetails!.title!,
                              style: AppStyle.vexa16
                                  .copyWith(color: AppStyle.secondaryColor),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  actionShare(BlogDetails!.link!,
                                      SizeConfig.screenWidth);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(SizeConfig.h(2)),
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
                          text:
                              _parseHtmlString(BlogDetails!.description ?? ""),
                          linkStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppStyle.secondaryColor,
                            decoration: TextDecoration.underline,
                            fontSize: SizeConfig.h(12),
                          ),
                          style: AppStyle.vexaLight12.copyWith(
                            backgroundColor: Colors.transparent,
                            height: 1.5,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: SizeConfig.w(30)),
                        if (BlogDetails!.videoUrl != null)
                          Center(
                            child: YoutubePlayerIFrame(
                              controller: _controller,
                            ),
                          ),
                      ],
                    ),
                  )
                ]))
              ]));
  }

  bool isOptionSelected(OptionData option, i) {
    return selectedOptions.containsKey(option.optionId.toString()) &&
        selectedOptions[option.optionId.toString()] == i;
  }

  bool loadingCart = false;
  int count = 1;
  final Debouncer debouncer = Debouncer();
  Container buildProductsSection(List<Product> relatedProducts) {
    return Container(
      height: SizeConfig.h(280),
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

  Widget buildCarousel(String images) {
    double hieght = 250;
    return Container(
      width: double.infinity,
      height: SizeConfig.h(hieght),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (index, reason) {},
                  enableInfiniteScroll: false,
                  height: SizeConfig.h(hieght),
                  autoPlay: false,
                  // aspectRatio: 3.45555555 / 2,
                  autoPlayInterval: Duration(seconds: 7),
                  scrollDirection: Axis.horizontal,
                  viewportFraction: SizeConfig.isWideScreen() ? 0.7 : 1),
              items: [
                Container(
                  margin: SizeConfig.isWideScreen()
                      ? EdgeInsets.symmetric(horizontal: SizeConfig.h(12))
                      : null,
                  height: SizeConfig.h(hieght),
                  width: SizeConfig.screenWidth,
                  color: Colors.white,
                  child: Image.network(
                    images,
                    fit: BoxFit.contain,
                  ),
                ),
              ]),
          Positioned(
            bottom: SizeConfig.h(20),
            child: Row(
              children: [
                ...List.generate(
                    0,
                    (index) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: SizeConfig.h(7)),
                          height: 2,
                          width: SizeConfig.h(50),
                          decoration: BoxDecoration(
                            color: AppStyle.secondaryColor,
                          ),
                        ))
              ],
            ),
          )
        ],
      ),
    );
  }

  buildAppBar(String title) {
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
                title,
                style: AppStyle.vexa16,
              ),
              SizedBox(
                width: 5,
              ),
              // Text(
              //   "(150 منتج)",
              //   style: AppStyle.vexa16.copyWith(color: AppStyle.primaryColor),
              // )
            ],
          ),
          Spacer(),
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
