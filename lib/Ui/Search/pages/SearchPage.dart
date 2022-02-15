import 'package:flutter/material.dart';

import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/App/Widgets/ProductCard.dart';
import '/App/Widgets/Products_shimmer_grid.dart';
import '/Ui/search/bloc/search_bloc.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

import '/generated/l10n.dart';
import '/injections.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'FilterDialoge.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBLoc searchBLoc = SearchBLoc();
  final TextEditingController searchController = TextEditingController();
  bool showResult = false;
  int? maxPriceAllowed;
  int? minPriceAllowed;
  @override
  void dispose() {
    searchBLoc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    maxPriceAllowed =
        sl<HomesettingsBloc>().settings!.filterData?.priceMax ?? 1;
    minPriceAllowed =
        sl<HomesettingsBloc>().settings!.filterData?.priceMin ?? 0;
    getCommonSearches();
    getSearchHistory();
  }

  getSearchHistory() async {
    final result = await GetSearchHistory(sl()).call(NoParams());
    result.fold((l) {
//never happen
    }, (r) {
      setState(() {
        searchHistory = r;
      });
    });
  }

  getCommonSearches() async {
    final result = await GetCommonSearch(sl()).call(NoParams());
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      setState(() {
        commonSearches = r;
      });
    });
  }

  List<String>? searchHistory;
  List<Product>? commonSearches;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBar(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(16)),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.h(20),
                    ),
                    if (searchBLoc.query.length > 1 || showResult)
                      buildSearchResult()
                    else
                      Column(
                        children: [
                          if (commonSearches != null)
                            buildCommonSearch(context)
                          else
                            Center(
                              child: AppLoader(),
                            ),
                          SizedBox(
                            height: SizeConfig.h(20),
                          ),
                          if (searchHistory != null)
                            buildSearchHistory(context),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResult() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.h(14), vertical: SizeConfig.h(10)),
              child: BlocBuilder(
                bloc: searchBLoc,
                builder: (context, state) {
                  if (state is ErrorState) {
                    return AppErrorWidget(text: state.error);
                  }
                  if (state is LoadingState) {
                    return ProductsShimmerGrid(returnCustomScrollView: true);
                  }
                  if (state is SuccessState<List<Product>>) {
                    if (state.items.isEmpty)
                      return EmptyPlacholder(
                        title: S.of(context).no_result,
                        imageName: "assets/noSearch.png",
                        subtitle: S.of(context).no_search_subtitle,
                      );
                    return CustomScrollView(
                      controller: searchBLoc.scrollController,
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  crossAxisSpacing:
                                      0, //cuase the card already taken margin
                                  maxCrossAxisExtent: SizeConfig.h(230),
                                  mainAxisExtent: SizeConfig.h(240),
                                  mainAxisSpacing: SizeConfig.h(13)),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return ProductCard(product: state.items[index]);
                          }, childCount: state.items.length),
                        ),
                        if (!state.hasReachedMax)
                          SliverToBoxAdapter(
                              child: Center(
                            child: AppLoader(),
                          )),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: SizeConfig.h(25),
                          ),
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
    );
  }

  Column buildSearchHistory(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              S.of(context).searchHistory,
              style: AppStyle.vexa16.copyWith(
                  fontWeight: FontWeight.bold, color: AppStyle.secondaryColor),
            ),
          ],
        ),
        Divider(
          height: SizeConfig.h(25),
        ),
        for (String search in searchHistory!)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              searchController.clear();
              searchController.text = search;
              searchBLoc.query = search;
              searchBLoc.add(LoadEvent(""));
              setState(() {});
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    search,
                    style: AppStyle.vexa14,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      searchHistory!.remove(search);
                    });
                    DeleteSearchHistoryItem(sl())
                        .call(DeleteSearchHistoryItemParams(query: search));
                  },
                  icon: Icon(Icons.close),
                  iconSize: SizeConfig.h(18),
                  color: AppStyle.disabledColor,
                )
              ],
            ),
          ),
        Divider(
          height: SizeConfig.h(10),
        ),
      ],
    );
  }

  Column buildCommonSearch(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(S.of(context).commonSearch,
                style: AppStyle.vexa16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppStyle.secondaryColor)),
          ],
        ),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        SizedBox(
          height: SizeConfig.h(150),
          child: Row(
            children: [
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: commonSearches!.length,
                      itemBuilder: (context, index) {
                        return buildCommonSearchCard(commonSearches![index]);
                      }))
            ],
          ),
        )
      ],
    );
  }

  Widget buildCommonSearchCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/productDetails",
          arguments: {"id": product.id.toString(), "goToOptions": false},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.h(5)),
        width: SizeConfig.h(100),
        padding: EdgeInsets.all(SizeConfig.h(8)),
        decoration: BoxDecoration(
            color: AppStyle.disabledColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.coverImage ?? "",
                height: SizeConfig.h(85),
                width: SizeConfig.h(85),
              ),
            ),
            SizedBox(
              height: SizeConfig.h(10),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    maxLines: 2,
                    style:
                        AppStyle.vexa14.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  final Debouncer debouncer = Debouncer();
  Widget buildSearchBar(BuildContext context) {
    return CustomAppBar(
      isCustom: true,
      child: Row(
        children: [
          BackButton(
            color: AppStyle.whiteColor,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(SizeConfig.h(4)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppStyle.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.h(10),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: searchController,
                          onChanged: (v) {
                            setState(() {
                              searchBLoc.query = v;
                            });
                            if (v.trim().isNotEmpty)
                              debouncer.run(() {
                                searchBLoc.add(LoadEvent(""));
                              });
                          },
                          style: AppStyle.vexa14.copyWith(color: Colors.black),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(SizeConfig.h(3)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: SizeConfig.h(10),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.h(18),
                                      width: SizeConfig.h(18),
                                      child: SvgPicture.asset(
                                        "assets/search.svg",
                                        height: SizeConfig.h(18),
                                        width: SizeConfig.h(18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: SizeConfig.h(35),
                                maxWidth: SizeConfig.h(22),
                              ),
                              labelStyle:
                                  AppStyle.vexa14.copyWith(color: Colors.black),
                              hintStyle:
                                  AppStyle.vexa14.copyWith(color: Colors.black),
                              hintText: S.of(context).searchHere,
                              border: InputBorder.none),
                        ),
                        SizedBox(
                          height: SizeConfig.h(11),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30))),
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialoge(
                              currentRangeValues: RangeValues(
                                  (searchBLoc.minPrice ?? minPriceAllowed)
                                          ?.toDouble() ??
                                      0,
                                  (searchBLoc.maxPrice ?? maxPriceAllowed)
                                          ?.toDouble() ??
                                      1),
                              minPriceAllowed: minPriceAllowed ?? 0,
                              maxPriceAllowed: maxPriceAllowed ?? 1,
                              categoryId: searchBLoc.categoryId,
                              rating: searchBLoc.rating,
                              sortBy: searchBLoc.orderColumn +
                                  "-" +
                                  searchBLoc.orderDirection,
                            );
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            searchBLoc.categoryId = value["categoryId"];
                            searchBLoc.maxPrice = value["maxPrice"];
                            searchBLoc.minPrice = value["minPrice"];
                            searchBLoc.orderColumn = value["orderColumn"];
                            searchBLoc.orderDirection = value["orderDir"];
                            searchBLoc.rating = value["rating"];
                            showResult = true;
                          });
                          searchBLoc.add(LoadEvent(""));
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.h(7)),
                      margin: EdgeInsets.all(SizeConfig.h(7)),
                      height: SizeConfig.h(45),
                      width: SizeConfig.h(45),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: (searchBLoc.categoryId != null ||
                                  searchBLoc.maxPrice != null ||
                                  searchBLoc.minPrice != null ||
                                  searchBLoc.rating != null)
                              ? AppStyle.warningColor
                              : AppStyle.secondaryColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icon-filter.svg",
                            height: SizeConfig.h(17),
                            width: SizeConfig.h(17),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
