import 'package:flutter/material.dart';
import '/App/Widgets/ShimmerProductCard.dart';
import '/Utils/SizeConfig.dart';
class ProductsShimmerGrid extends StatefulWidget {
  ProductsShimmerGrid({Key? key, required this.returnCustomScrollView})
      : super(key: key);
  final bool returnCustomScrollView;
  @override
  _ProductsShimmerGridState createState() => _ProductsShimmerGridState();
}

class _ProductsShimmerGridState extends State<ProductsShimmerGrid> {
  @override
  Widget build(BuildContext context) {
    if (widget.returnCustomScrollView)
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: SizeConfig.h(15),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: SizeConfig.h(230),
                crossAxisSpacing: 0, //cuase the card already taken margin
                mainAxisExtent: SizeConfig.h(240),
                mainAxisSpacing: SizeConfig.h(13)),
            delegate: SliverChildBuilderDelegate((context, index) {
              return ProductShimmerCard();
            }, childCount: 4),
          ),
        ],
      );
    else
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: SizeConfig.h(230),
            crossAxisSpacing: 0, //cuase the card already taken margin
            mainAxisExtent: SizeConfig.h(240),
            mainAxisSpacing: SizeConfig.h(13)),
        delegate: SliverChildBuilderDelegate((context, index) {
          return ProductShimmerCard();
        }, childCount: 4),
      );
  }
}
