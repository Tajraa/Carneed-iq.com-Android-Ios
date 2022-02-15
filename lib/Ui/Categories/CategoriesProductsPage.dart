import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';

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

  @override
  void initState() {
    selectedCategoryId =
        GetProducatsByCategoryParams(categoryId: widget.selectedId.toString());
    bloc = CategoryBloc(selectedCategoryId);
    bloc.add(LoadEvent(selectedCategoryId));
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
        backgroundColor: Colors.white,
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
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: SizeConfig.h(230),
                        crossAxisSpacing:
                            0, //cuase the card already taken margin
                        mainAxisExtent: 239,
                        mainAxisSpacing: SizeConfig.h(13)),
                    delegate: SliverChildBuilderDelegate((context, index) {
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
            // GestureDetector(
            //   onTap: () {
            //     showModalBottomSheet(
            //         backgroundColor: Colors.transparent,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(SizeConfig.h(20))),
            //         context: context,
            //         builder: (BuildContext context) {
            //           return SortByWidget();
            //         });
            //   },
            //   child: SvgPicture.asset(
            //     "assets/sort-down.svg",
            //     height: SizeConfig.h(16),
            //     width: SizeConfig.h(16),
            //   ),
            // ),
            SizedBox(
              width: SizeConfig.h(24),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSubCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.h(85),
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
                          bloc.add(LoadEvent(selectedCategoryId));
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.h(14)),
                              height: SizeConfig.h(77),
                              width: SizeConfig.h(53),
                              decoration: BoxDecoration(
                                boxShadow: isSelected
                                    ? [AppStyle.boxShadow3on6]
                                    : null,
                                color: isSelected
                                    ? AppStyle.primaryColor
                                    : Colors.white,
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: AppStyle.disabledBorderColor,
                                      ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        category.coverImage,
                                        height: SizeConfig.h(20),
                                        width: SizeConfig.h(20),
                                      ),
                                    ),
                                    height: SizeConfig.h(37),
                                    width: SizeConfig.h(37),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppStyle.whiteColor
                                            : null,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: isSelected
                                                ? AppStyle.whiteColor
                                                : AppStyle
                                                    .disabledBorderColor)),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.h(50),
                                    height: SizeConfig.h(25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: AppStyle.vexa12.copyWith(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppStyle.disabledColor),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.h(6),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
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
        bloc.add(LoadEvent(selectedCategoryId));
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.h(14)),
            height: SizeConfig.h(77),
            width: SizeConfig.h(53),
            decoration: BoxDecoration(
              boxShadow: isSelected ? [AppStyle.boxShadow3on6] : null,
              color: isSelected ? AppStyle.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: isSelected
                  ? null
                  : Border.all(
                      color: AppStyle.disabledBorderColor,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      widget.category.coverImage,
                      height: SizeConfig.h(20),
                      width: SizeConfig.h(20),
                    ),
                  ),
                  height: SizeConfig.h(37),
                  width: SizeConfig.h(37),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: isSelected ? AppStyle.whiteColor : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? AppStyle.whiteColor
                              : AppStyle.disabledBorderColor)),
                ),
                SizedBox(
                  width: SizeConfig.h(50),
                  height: SizeConfig.h(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).all,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: AppStyle.vexa12.copyWith(
                            color: isSelected
                                ? AppStyle.whiteColor
                                : AppStyle.disabledColor),
                      ),
                      SizedBox(
                        height: SizeConfig.h(6),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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
