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
import 'bloc/points_products_bloc.dart';

class PointsProducts extends StatefulWidget {
 
  PointsProducts();
  @override
  _PointsProductsState createState() => _PointsProductsState();
}

class _PointsProductsState extends State<PointsProducts> {
  late final PointsProductsBloc bloc;
  _PointsProductsState();
  @override
  void initState() {
    bloc = PointsProductsBloc("");
    bloc.add(LoadEvent(""));
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
                        mainAxisExtent: SizeConfig.h(245),
                        mainAxisSpacing: SizeConfig.h(13)),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(
                        product: state.items[index],
                        forPointSale: true,
                      );
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
                  S.of(context).change_points_with_products,
                  style: AppStyle.vexa16,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.h(24),
            )
          ],
        ),
      ),
    );
  }
}
