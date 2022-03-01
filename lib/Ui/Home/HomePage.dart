import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '/App/App.dart';
import '/App/Widgets/AppLoader.dart';
import '/Ui/Home/widgets/carousel_section.dart';
import '/Ui/Home/widgets/home_shimmer.dart';
import '/generated/l10n.dart';
import './/App/Widgets/CustomAppBar.dart';
import './/App/Widgets/ProductCard.dart';
import './/Utils/SizeConfig.dart';
import './/Utils/Style.dart';
import '../../injections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    UniLinks.initDynamicLinks((id) {
      Navigator.pushNamed(context, "/productDetails", arguments: id);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    var settings = sl<HomesettingsBloc>().settings!;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          sl<HomesettingsBloc>().add(GetSettings());
          return Future.delayed(Duration(seconds: 1)).then((value) {});
        },
        child: BlocBuilder(
          bloc: sl<HomesettingsBloc>(),
          builder: (context, state) {
            if (state is LoadingSettings) {
              return Column(
                children: [
                  CustomAppBar(
                    isCustom: false,
                  ),
                  HomePageShimmer()
                ],
              );
            }
            settings = sl<HomesettingsBloc>().settings!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    isCustom: false,
                  ),
                  if (settings.slides?.isNotEmpty ?? false)
                    CarouselSection(slides: settings.slides!),
                  SizedBox(
                    height: 23,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSectionLabel(S.of(context).categories, () {},
                          hasSeeAll: false),
                      buildCategoriesSection(settings),
                      SizedBox(height: 20),
                      ...[
                        for (CategoryFeatured section
                            in settings.categoriesFeatured ?? [])
                          if (section.posts.data.isNotEmpty)
                            Column(
                              children: [
                                buildSectionLabel(section.title, () {
                                  for (Category cat
                                      in settings.categories ?? []) {
                                    if (cat.id == section.id) {
                                      Navigator.pushNamed(
                                          context, "/categoryProducts",
                                          arguments: {
                                            "category": cat,
                                            "id": section.id
                                          });
                                      return;
                                    } else {
                                      for (Category subCat
                                          in cat.subCategories ?? []) {
                                        if (subCat.id == section.id) {
                                          Navigator.pushNamed(
                                              context, "/categoryProducts",
                                              arguments: {
                                                "category": cat,
                                                "id": section.id
                                              });
                                          return;
                                        }
                                      }
                                    }
                                  }
                                }),
                                buildProductsSection(section),
                              ],
                            )
                      ],
                      SizedBox(
                        height: SizeConfig.h(AppStyle.bottomNavHieght),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container buildCategoriesSection(SettingsModel settings) {
    return Container(
      height: 110,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: settings.categories?.length ?? 0,
                itemBuilder: (context, index) {
                  return buildCategoryCard(settings.categories![index]);
                }),
          ),
        ],
      ),
    );
  }

  Container buildProductsSection(CategoryFeatured section) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(3)),
                scrollDirection: Axis.horizontal,
                itemCount: section.posts.data.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: section.posts.data[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/categoryProducts",
            arguments: {"category": category, "id": category.id});
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 6,
                      color: Colors.black12)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: category.coverImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  category.title,
                  // overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        height: 1.1, fontSize: 13, color: AppStyle.greyDark),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSectionLabel(String title, Function() onTap,
      {bool? hasSeeAll}) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 14,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                height: 1.1,
                fontSize: 14,
                color: AppStyle.secondaryColor,
                fontWeight: FontWeight.w700),
          ),
          if (hasSeeAll ?? true)
            GestureDetector(
              onTap: onTap,
              child: Text(
                S.of(context).see_all,
                style: TextStyle(
                    height: 1.1, fontSize: 12, color: AppStyle.greyColor),
              ),
            ),
        ],
      ),
    );
  }
}
