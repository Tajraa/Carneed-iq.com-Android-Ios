import 'package:flutter/material.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

import 'package:shimmer/shimmer.dart';

class ProductShimmerCard extends StatefulWidget {
  ProductShimmerCard({Key? key}) : super(key: key);

  @override
  _ProductShimmerCardState createState() => _ProductShimmerCardState();
}

class _ProductShimmerCardState extends State<ProductShimmerCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.h(6.5)),
          width: SizeConfig.h(157),
          // height: SizeConfig.h(239),
          decoration: BoxDecoration(
              color: AppStyle.whiteColor,
              borderRadius: BorderRadius.circular(SizeConfig.h(10)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: Colors.black12)
              ]),
          child: Stack(
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(SizeConfig.h(10)),
                      ),
                      width: SizeConfig.h(147),
                      height: SizeConfig.h(123),
                      // fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.h(8),
                  ),
                  Container(
                    height: SizeConfig.h(97),
                    padding: EdgeInsets.all(SizeConfig.h(10)),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey,
                                  width: SizeConfig.h(50),
                                  height: SizeConfig.h(15),
                                  // fit: BoxFit.fill,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            children: [
                              Container(
                                color: Colors.grey,
                                width: SizeConfig.h(50),
                                height: SizeConfig.h(15),
                                // fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.circular(SizeConfig.h(3)),
                                ),
                                width: SizeConfig.h(50),
                                height: SizeConfig.h(30),
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: SizeConfig.h(111),
                right: AppStyle.isArabic(context) ? SizeConfig.h(4) : null,
                left: AppStyle.isArabic(context) ? null : SizeConfig.h(110),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: Offset(0.0, 3),
                        blurRadius: 6,
                        color: Colors.black12)
                  ], shape: BoxShape.circle, color: Colors.white),
                  width: SizeConfig.h(24),
                  height: SizeConfig.h(24),
                  child: Icon(Icons.favorite_border,
                      color: Colors.grey, size: SizeConfig.h(16)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
