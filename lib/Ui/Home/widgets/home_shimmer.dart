import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '/App/Widgets/ShimmerProductCard.dart';
import './/Utils/SizeConfig.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: SizeConfig.h(154),
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: SizeConfig.h(23),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: SizeConfig.h(14),
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: SizeConfig.h(15),
                  color: Colors.grey,
                  width: SizeConfig.h(75),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: SizeConfig.h(100),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.h(7)),
                              width: SizeConfig.h(61),
                              height: SizeConfig.h(61),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.h(8),
                          ),
                          SizedBox(
                            width: SizeConfig.h(61),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: SizeConfig.h(10),
                                    color: Colors.grey,
                                    width: SizeConfig.h(50),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: SizeConfig.h(14),
              ),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: SizeConfig.h(15),
                      color: Colors.grey,
                      width: SizeConfig.h(50),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: SizeConfig.h(260),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: SizeConfig.h(3)),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return ProductShimmerCard();
                        }),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: SizeConfig.h(14),
              ),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: SizeConfig.h(15),
                      color: Colors.grey,
                      width: SizeConfig.h(50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
