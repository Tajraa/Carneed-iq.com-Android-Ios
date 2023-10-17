import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';

import '../../Utils/AppSnackBar.dart';
import '../../injections.dart';
import '../Search/pages/FilterDialoge.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/App/Widgets/ProductCard.dart';
import '/App/Widgets/Products_shimmer_grid.dart';

import '/Ui/Categories/bloc/category_bloc.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

class CategoryProductsPage extends StatefulWidget {
  final Category category;
  final int selectedId;

  CategoryProductsPage(
      {required this.category, required this.selectedId, Key? key})
      : super(key: key);

  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late GetProducatsByCategoryParams selectedCategoryId;
  late final CategoryBloc bloc;
  final homeSettingsBloc = sl<HomesettingsBloc>();
  List<DynamicField>? dynamicFields;
  List<dynamic>? filterValues;
  Map? preferences;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool showResult = false;
  int? maxPriceAllowed;
  int? minPriceAllowed;

  getPreferences() async {
    final result = await GetPreferences(sl()).call(NoParams());
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      if (mounted)
        setState(() {
          preferences = r;
        });
    });
  }

  @override
  void initState() {
    getPreferences();
    maxPriceAllowed =
        sl<HomesettingsBloc>().settings!.filterData?.priceMax ?? 1;
    minPriceAllowed =
        sl<HomesettingsBloc>().settings!.filterData?.priceMin ?? 0;
    selectedCategoryId =
        GetProducatsByCategoryParams(categoryId: widget.selectedId.toString());
    bloc = CategoryBloc(selectedCategoryId);
    bloc.add(
      LoadEvent(
        {
          'categoryId': widget.category.id.toString(),
        },
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: homeSettingsBloc,
      listener: (context, HomesettingsState state) {
        if (state is HomeSettingsReady) {
          setState(() {
            if (widget.category.id.toString() ==
                selectedCategoryId.categoryId) {
              dynamicFields = homeSettingsBloc.settings!.categories!
                  .firstWhere((element) =>
                      element.id.toString() == widget.category.id.toString())
                  .dynamicFilterFields;
              filterValues =
                  state.dynamicFilters != null ? state.dynamicFilters : null;
            } else {
              dynamicFields = homeSettingsBloc.settings!.categories!
                  .firstWhere((element) =>
                      element.id.toString() == widget.category.id.toString())
                  .subCategories!
                  .firstWhere((element) =>
                      element.id.toString() == selectedCategoryId.categoryId)
                  .dynamicFilterFields;
              filterValues =
                  state.dynamicFilters != null ? state.dynamicFilters : null;
            }
          });
        }
      },
      child: BlocBuilder(
          bloc: homeSettingsBloc,
          builder: (context, HomesettingsState state) {
            return Scaffold(
                key: _key,
                backgroundColor: Colors.white,
                drawer: Container(
                  width: SizeConfig.w(200),
                  child: Drawer(
                    backgroundColor: AppStyle.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.w(30), left: SizeConfig.w(20)),
                          child: GestureDetector(
                            onTap: () {
                              if (filterValues != null) {
                                for (int i = 0; i < filterValues!.length; i++) {
                                  filterValues![i] =
                                      filterValues![i] is List ? [] : null;
                                }
                                sl<HomesettingsBloc>()
                                    .add(ChangeDynamicValues(filterValues!));
                              }
                            },
                            child: Text(
                              S.of(context).clear,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppStyle.secondaryColor,
                                fontSize: SizeConfig.h(18),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: (dynamicFields?.length ?? 0) + 1,
                            padding: EdgeInsets.all(SizeConfig.w(30)),
                            itemBuilder: (context, index) {
                              if (dynamicFields == null ||
                                  index == dynamicFields!.length) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Map<int, dynamic> parsedValues = {};
                                    for (int i = 0;
                                        i < filterValues!.length;
                                        i++) {
                                      if (filterValues![i] is String) {
                                        parsedValues[dynamicFields![i].id] =
                                            dynamicFields![i]
                                                .options
                                                .indexOf(filterValues![i]);
                                      } else {
                                        List<int> innerList = [];
                                        if (filterValues?[i] != null) {
                                          for (var e in filterValues?[i]) {
                                            innerList.add(dynamicFields![i]
                                                .options
                                                .indexOf(e));
                                          }
                                        }
                                        parsedValues[dynamicFields![i].id] =
                                            innerList;
                                      }
                                    }
                                    print('parsed values is $parsedValues');
                                    bloc.add(
                                      LoadEvent(
                                        {
                                          'categoryId':
                                              widget.category.id.toString(),
                                          '_field_values': parsedValues,
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppStyle.secondaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(SizeConfig.w(10)),
                                    child: Text(
                                      S.of(context).submit,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppStyle.whiteColor,
                                        fontSize: SizeConfig.h(18),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return dynamicFields![index].type == 'select'
                                  ? Padding(
                                      padding: EdgeInsets.all(SizeConfig.w(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dynamicFields![index].title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppStyle.secondaryColor,
                                              fontSize: SizeConfig.h(18),
                                            ),
                                          ),
                                          DropdownButton<String>(
                                              value: filterValues![index],
                                              isExpanded: true,
                                              items: dynamicFields![index]
                                                  .options
                                                  .map((e) =>
                                                      DropdownMenuItem<String>(
                                                        child: Text(
                                                          e,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppStyle
                                                                .secondaryColor,
                                                            fontSize:
                                                                SizeConfig.h(
                                                                    16),
                                                          ),
                                                        ),
                                                        value: e,
                                                      ))
                                                  .toList(),
                                              onChanged: (String? value) {
                                                filterValues![index] = value!;
                                                homeSettingsBloc.add(
                                                    ChangeDynamicValues(
                                                        filterValues!));
                                              }),
                                        ],
                                      ),
                                    )
                                  : dynamicFields![index].type == 'radio'
                                      ? Padding(
                                          padding:
                                              EdgeInsets.all(SizeConfig.w(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dynamicFields![index].title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppStyle.secondaryColor,
                                                  fontSize: SizeConfig.h(18),
                                                ),
                                              ),
                                              ...dynamicFields![index]
                                                  .options
                                                  .map((e) => RadioListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        groupValue:
                                                            filterValues?[index]
                                                                as String?,
                                                        onChanged:
                                                            (String? value) {
                                                          filterValues![index] =
                                                              value!;
                                                          homeSettingsBloc.add(
                                                              ChangeDynamicValues(
                                                                  filterValues!));
                                                        },
                                                        value: e,
                                                        activeColor: AppStyle
                                                            .secondaryColor,
                                                        title: Text(
                                                          e,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppStyle
                                                                .secondaryColor,
                                                            fontSize:
                                                                SizeConfig.h(
                                                                    16),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ],
                                          ),
                                        )
                                      : dynamicFields![index].type == 'checkbox'
                                          ? Padding(
                                              padding: EdgeInsets.all(
                                                  SizeConfig.w(10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dynamicFields![index].title,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppStyle
                                                          .secondaryColor,
                                                      fontSize:
                                                          SizeConfig.h(18),
                                                    ),
                                                  ),
                                                  ...dynamicFields![index]
                                                      .options
                                                      .map((e) =>
                                                          CheckboxListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            onChanged:
                                                                (bool? value) {
                                                              (filterValues![index]
                                                                          as List)
                                                                      .contains(
                                                                          e)
                                                                  ? (filterValues![
                                                                              index]
                                                                          as List)
                                                                      .remove(e)
                                                                  : (filterValues![
                                                                              index]
                                                                          as List)
                                                                      .add(e);
                                                              homeSettingsBloc.add(
                                                                  ChangeDynamicValues(
                                                                      filterValues!));
                                                            },
                                                            value: (filterValues![
                                                                        index]
                                                                    as List)
                                                                .contains(e),
                                                            activeColor: AppStyle
                                                                .secondaryColor,
                                                            title: Text(
                                                              e,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppStyle
                                                                    .secondaryColor,
                                                                fontSize:
                                                                    SizeConfig
                                                                        .h(16),
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ],
                                              ),
                                            )
                                          : Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: CustomScrollView(
                  controller: bloc.scrollController,
                  slivers: [
                    buildAppBar(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: SizeConfig.h(14),
                      ),
                    ),
                    buildSubCategories(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: SizeConfig.h(30),
                      ),
                    ),
                    BlocBuilder(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return ProductsShimmerGrid(
                            returnCustomScrollView: false,
                          );
                        }
                        if (state is ErrorState) {
                          return SliverFillRemaining(
                              child: AppErrorWidget(text: state.error));
                        }
                        if (state is SuccessState<List<Product>>) {
                          if (state.items.isEmpty) {
                            return SliverFillRemaining(
                                child: EmptyPlacholder(
                              title: S.of(context).no_result,
                              imageName: "assets/noSearch.png",
                              subtitle: S.of(context).no_result_subtitle,
                              actionTitle: S.of(context).continueShopping,
                              onActionTap: () {
                                Navigator.pop(context);
                              },
                            ));
                          }
                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: SizeConfig.h(230),
                                    crossAxisSpacing:
                                        0, //cuase the card already taken margin
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: SizeConfig.h(13)),
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return ProductCard(product: state.items[index]);
                            }, childCount: state.items.length),
                          );
                        }
                        return SliverToBoxAdapter();
                      },
                    ),
                    SliverToBoxAdapter(
                      child: BlocBuilder(
                        bloc: bloc,
                        builder: (context, state) {
                          if (state is SuccessState) if (!state.hasReachedMax)
                            return Center(
                              child: AppLoader(),
                            );
                          return Container();
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: SizeConfig.h(25),
                      ),
                    )
                  ],
                ));
          }),
    );
  }

  SliverToBoxAdapter buildAppBar() {
    return SliverToBoxAdapter(
      child: CustomAppBar(
        isCustom: true,
        child: Row(
          children: [
            Row(
              children: [
                BackButton(
                  color: AppStyle.whiteColor,
                ),
                Text(
                  widget.category.title,
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
            if (preferences != null)
              GestureDetector(
                onTap: () {
                  if (preferences != null)
                    openWhatsapp(preferences!["support_phone"]);
                },
                child: Image.asset(
                  "assets/whatsapp.png",
                  color: AppStyle.primaryColor,
                  height: SizeConfig.w(20),
                  width: SizeConfig.w(20),
                ),
              ),
            SizedBox(
              width: SizeConfig.h(24),
            ),
            GestureDetector(
              onTap: () {
                sl<HomesettingsBloc>().add(AddDynamicFields(
                    widget.category.id.toString(),
                    selectedCategoryId.categoryId));
                // _key.currentState?.openDrawer();
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
                        hasCategories: false,
                        parentId: widget.category.id,
                        currentRangeValues: RangeValues(
                            (bloc.minPrice ?? minPriceAllowed)?.toDouble() ?? 0,
                            (bloc.maxPrice ?? maxPriceAllowed)?.toDouble() ??
                                1),
                        minPriceAllowed: minPriceAllowed ?? 0,
                        maxPriceAllowed: maxPriceAllowed ?? 1,
                        categoryId: int.parse(selectedCategoryId.categoryId),
                        rating: bloc.rating,
                        sortBy: bloc.orderColumn + "-" + bloc.orderDirection,
                      );
                    }).then((value) {
                  if (value != null) {
                    setState(() {
                      bloc.categoryId = value["categoryId"];
                      bloc.maxPrice = value["maxPrice"];
                      bloc.minPrice = value["minPrice"];
                      bloc.orderColumn = value["orderColumn"];
                      bloc.orderDirection = value["orderDir"];
                      bloc.rating = value["rating"];
                      showResult = true;
                    });
                    bloc.add(
                      LoadEvent(
                        {
                          'categoryId': widget.category.id.toString(),
                          '_field_values': value["_field_values"],
                        },
                      ),
                    );
                  }
                });
              },
              child: Icon(
                Icons.filter_list_outlined,
                color: AppStyle.primaryColor,
                size: SizeConfig.w(20),
              ),
            ),
            SizedBox(
              width: SizeConfig.h(24),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSubCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.h(100),
        child: Row(
          children: [
            // SizedBox(
            //   width: SizeConfig.h(7),
            // ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.category.subCategories?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return allProductsSection();
                      final category =
                          widget.category.subCategories![index - 1];
                      final isSelected = selectedCategoryId.categoryId ==
                          category.id.toString();
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = GetProducatsByCategoryParams(
                                categoryId: category.id.toString());
                          });
                          filterValues = null;
                          dynamicFields = null;
                          bloc.add(LoadEvent({
                            'categoryId': selectedCategoryId.categoryId,
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow:
                                isSelected ? [AppStyle.boxShadow3on6] : null,
                            color: isSelected
                                ? AppStyle.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7),
                                width: SizeConfig.h(70),
                                height: SizeConfig.h(70),
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
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.1,
                                          fontSize: 13,
                                          color: isSelected
                                              ? Colors.white
                                              : AppStyle.greyDark),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  allProductsSection() {
    final isSelected =
        selectedCategoryId.categoryId == widget.category.id.toString();
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryId = GetProducatsByCategoryParams(
              categoryId: widget.category.id.toString());
        });
        filterValues = null;
        dynamicFields = null;
        bloc.add(LoadEvent({
          'categoryId': selectedCategoryId.categoryId,
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: isSelected ? [AppStyle.boxShadow3on6] : null,
          color: isSelected ? AppStyle.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              width: SizeConfig.h(70),
              height: SizeConfig.h(70),
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
                  imageUrl: widget.category.coverImage,
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
                    S.of(context).all,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.1,
                        fontSize: 13,
                        color: isSelected ? Colors.white : AppStyle.greyDark),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SortByWidget extends StatefulWidget {
  const SortByWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SortByWidgetState createState() => _SortByWidgetState();
}

class _SortByWidgetState extends State<SortByWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.h(280),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.h(20)),
              topRight: Radius.circular(SizeConfig.h(20)))),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.h(20)),
            topRight: Radius.circular(SizeConfig.h(20))),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.h(27),
            ),
            Text(
              S.of(context).sort_by,
              style: AppStyle.vexa20,
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(1.0),
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2)
                ], stops: [
                  0.2,
                  0.3,
                  0.5,
                  0.6,
                  1.0
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                    .createShader(bounds),
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (value) {
                    // setState(() {
                    //   selectedValue = value;
                    // });
                  },
                  selectionOverlay: Container(),
                  itemExtent: SizeConfig.h(37),
                  children: [
                    Text(
                      'الترتيب الافتراضي',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                    Text(
                      'السعر من الأعلى للأقل',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                    Text(
                      'السعر من الأعلى للأقل',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                    Text(
                      'السعر من الأعلى للأقل',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                    Text(
                      'السعر من الأعلى للأقل',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                    Text(
                      'السعر من الأعلى للأقل',
                      style: AppStyle.vexa16.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
