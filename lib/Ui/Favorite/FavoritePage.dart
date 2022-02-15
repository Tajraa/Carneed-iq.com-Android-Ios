import 'package:flutter/material.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '../../injections.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/App/Widgets/ProductCard.dart';
import '/App/Widgets/Products_shimmer_grid.dart';
import '/Ui/Favorite/bloc/favorite_bloc.dart';
import '/Utils/SizeConfig.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/generated/l10n.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key, required this.goHome}) : super(key: key);

  final Function()? goHome;

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(isCustom: false),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.h(14),
              ),
              child: BlocBuilder<FavoriteBloc, SimpleBlocState>(
             
                builder: (context, state) {
                  if (state is ErrorState) {
                    return Center(child: Text(state.error));
                  }
                  if (state is LoadingState) {
                    return ProductsShimmerGrid(
                      returnCustomScrollView: true,
                    );
                  }
                  if (state is SuccessState<List<FavoriteItem>>) {
                    if (state.items.isEmpty)
                      return EmptyPlacholder(
                        skipNavBarHeight: true,
                        title: S.of(context).no_favorite,
                        imageName: "assets/noFavorite.png",
                        subtitle: S.of(context).no_favorite_subtitle,
                        actionTitle: S.of(context).continueShopping,
                        onActionTap: () {
                          widget.goHome!();
                        },
                      );
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: SizeConfig.h(15),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: SizeConfig.h(230),
                                  crossAxisSpacing:
                                      0, //cuase the card already taken margin
                                  mainAxisExtent: SizeConfig.h(240),
                                  mainAxisSpacing: SizeConfig.h(13)),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return ProductCard(
                                product: state.items[index].item);
                          }, childCount: state.items.length),
                        ),
                        if (!state.hasReachedMax)
                          SliverToBoxAdapter(
                              child: Center(
                            child: AppLoader(),
                          )),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: SizeConfig.h(15),
                          ),
                        ),
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
}
