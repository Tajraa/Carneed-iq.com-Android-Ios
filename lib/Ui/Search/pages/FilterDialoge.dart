import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

import '../../../injections.dart';

class FilterDialoge extends StatefulWidget {
  const FilterDialoge({
    required this.currentRangeValues,
    required this.categoryId,
    required this.rating,
    required this.maxPriceAllowed,
    required this.minPriceAllowed,
    required this.sortBy,
    Key? key,
  }) : super(key: key);
  final RangeValues currentRangeValues;

  final int? categoryId;
  final int? rating;
  final int maxPriceAllowed;
  final int minPriceAllowed;
  final String sortBy;
  @override
  _FilterDialogeState createState() => _FilterDialogeState();
}

class _FilterDialogeState extends State<FilterDialoge> {
  late int maxPriceAllowed;
  late int minPriceAllowed;
  late RangeValues _currentRangeValues;
  String? orderColumn;
  String? orderDirection;
  int? categoryId;
  int? rating;
  String sortBy = "created_at-asc";
  @override
  void initState() {
    maxPriceAllowed = widget.maxPriceAllowed;
    minPriceAllowed = widget.minPriceAllowed;
    _currentRangeValues = widget.currentRangeValues;

    categoryId = widget.categoryId;
    rating = widget.rating;
    sortBy = widget.sortBy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(28)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.h(25),
              ),
              Row(
                children: [
                  Text(
                    S.of(context).filter,
                    style: AppStyle.vexa16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.primaryColor),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.h(15),
              ),
              Row(
                children: [
                  Text(
                    S.of(context).price,
                    style: AppStyle.vexa14,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.h(12),
              ),
              Row(
                children: [
                  Expanded(
                      child: RangeSlider(
                    activeColor: AppStyle.secondaryColor,
                    inactiveColor: AppStyle.greyColor.withOpacity(0.3),
                    values: _currentRangeValues,
                    min: minPriceAllowed.toDouble(),
                    max: maxPriceAllowed.toDouble(),
                    divisions: 100,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString() + "\$",
                      _currentRangeValues.end.round().toString() + "\$",
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ))
                ],
              ),
              SizedBox(
                height: SizeConfig.h(5),
              ),
              buildCategories(context),
              SizedBox(
                height: SizeConfig.h(15),
              ),
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.h(15),
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).sort_by,
                        style: AppStyle.vexa14
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: SizeConfig.h(15),
                      ),
                      Expanded(
                          child: DropdownButton<String>(
                        isExpanded: true,
                        value: sortBy,
                        onChanged: (v) {
                          setState(() {
                            sortBy = v ?? sortBy;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              S.of(context).high_price,
                              style: AppStyle.vexa14,
                            ),
                            value: "price-desc",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              S.of(context).less_price,
                              style: AppStyle.vexa14,
                            ),
                            value: "price-asc",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              S.of(context).newest,
                              style: AppStyle.vexa14,
                            ),
                            value: "created_at-asc",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              S.of(context).oldest,
                              style: AppStyle.vexa14,
                            ),
                            value: "created_at-desc",
                          )
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.h(15),
                  ),
                  Row(
                    children: [
                      Text(S.of(context).rate, style: AppStyle.vexa14),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.h(15),
                  ),
                  Row(
                    children: [
                      RatingBar(
                        initialRating: rating?.toDouble() ?? 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        glow: false,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: AppStyle.warningColor,
                          ),
                          half: Icon(Icons.star),
                          empty: Icon(
                            Icons.star_border_outlined,
                            color: AppStyle.warningColor.withOpacity(0.5),
                          ),
                        ),
                        itemSize: SizeConfig.h(30),
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rate) {
                          if (rate == 0.0)
                            rating = null;
                          else
                            rating = rate.toInt();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.h(15),
                  ),
                  MainButton(
                      isOutlined: false,
                      onTap: () {
                        final Map result = {};
                        final res = sortBy.split("-");
                        orderColumn = res[0];
                        orderDirection = res[1];
                        result.putIfAbsent(
                            "minPrice",
                            () => _currentRangeValues.start != minPriceAllowed
                                ? _currentRangeValues.start.toInt()
                                : null);

                        result.putIfAbsent(
                            "maxPrice",
                            () => _currentRangeValues.end != maxPriceAllowed
                                ? _currentRangeValues.end.toInt()
                                : null);

                        result.putIfAbsent("rating", () => rating);

                        result.putIfAbsent("categoryId", () => categoryId);
                        result.putIfAbsent("orderColumn", () => orderColumn);
                        result.putIfAbsent("orderDir", () => orderDirection);
                        Navigator.pop(context, result);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).applyFilter,
                            style: AppStyle.vexa14.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: SizeConfig.h(15),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildCategories(BuildContext context) {
    final settings = sl<HomesettingsBloc>().settings;
    return Column(
      children: [
        Row(
          children: [
            Text(S.of(context).category, style: AppStyle.vexa14),
          ],
        ),
        SizedBox(
          height: SizeConfig.h(15),
        ),
        Wrap(
          spacing: SizeConfig.h(10),
          runSpacing: SizeConfig.h(10),
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  categoryId = null;
                });
              },
              child: Container(
                padding: EdgeInsets.all(SizeConfig.h(12)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: categoryId == null
                        ? AppStyle.secondaryLight
                        : AppStyle.greyColor.withOpacity(0.3)),
                child: Text(
                  S.of(context).all,
                  style: AppStyle.vexa12.copyWith(color: Colors.white),
                ),
              ),
            ),
            for (Category category in (settings!.categories!))
              GestureDetector(
                onTap: () {
                  setState(() {
                    categoryId = category.id;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.h(12)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: categoryId == category.id
                          ? AppStyle.secondaryLight
                          : AppStyle.greyColor.withOpacity(0.3)),
                  child: Text(
                    category.title,
                    style: AppStyle.vexa12.copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
