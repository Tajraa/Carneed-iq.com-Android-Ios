import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import '../../../data/sharedPreferences/SharedPrefHelper.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injections.dart';

class FilterDialoge extends StatefulWidget {
  const FilterDialoge({
    required this.currentRangeValues,
    required this.categoryId,
    this.parentId,
    required this.rating,
    required this.maxPriceAllowed,
    required this.minPriceAllowed,
    required this.sortBy,
    this.hasCategories = true,
    Key? key,
  }) : super(key: key);
  final RangeValues currentRangeValues;

  final int? categoryId;
  final int? parentId;
  final int? rating;
  final int maxPriceAllowed;
  final int minPriceAllowed;
  final String sortBy;
  final bool hasCategories;

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
  final homeSettingsBloc = sl<HomesettingsBloc>();

  List<DynamicField>? dynamicFields;
  List<dynamic>? filterValues;
  String? selectedCurrency;

  @override
  void initState() {
    getCurrency();
    maxPriceAllowed = widget.maxPriceAllowed;
    minPriceAllowed = widget.minPriceAllowed;
    _currentRangeValues = widget.currentRangeValues;

    // categoryId = widget.categoryId;
    rating = widget.rating;
    sortBy = widget.sortBy;
    super.initState();
  }

  getCurrency() async {
    selectedCurrency = await sl<PrefsHelper>().loadCurrencyFromSharedPref();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.w(400),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(28)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: SizeConfig.h(25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).filter,
                  style: AppStyle.vexa16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppStyle.primaryColor),
                ),
                GestureDetector(
                  onTap: () {
                    if (filterValues != null) {
                      for (int i = 0; i < filterValues!.length; i++) {
                        filterValues![i] = filterValues![i] is List ? [] : null;
                      }
                      sl<HomesettingsBloc>()
                          .add(ChangeDynamicValues(filterValues!));
                    }
                  },
                  child: Text(
                    S.of(context).clear,
                    style: AppStyle.vexa16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.primaryColor),
                  ),
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
                    child: Theme(
                      data: ThemeData(
                          textTheme:
                          TextTheme(bodyText1: TextStyle(color: Colors.white))),
                      child: RangeSlider(
                        activeColor: AppStyle.secondaryColor,
                        inactiveColor: AppStyle.greyColor.withOpacity(0.3),
                        values: _currentRangeValues,
                        min: minPriceAllowed.toDouble(),
                        max: maxPriceAllowed.toDouble(),
                        divisions: 100,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString() +
                              " ${selectedCurrency ?? 'USD'}",
                          _currentRangeValues.end.round().toString() +
                              " ${selectedCurrency ?? 'USD'}",
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: SizeConfig.h(5),
            ),
            if (widget.hasCategories) buildCategories(context),
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
                      style:
                      AppStyle.vexa14.copyWith(fontWeight: FontWeight.bold),
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
                if (!widget.hasCategories || categoryId != null)
                  BlocListener(
                    bloc: homeSettingsBloc,
                    listener: (context, HomesettingsState state) {
                      if (state is HomeSettingsReady) {
                        setState(() {
                          print(
                              'category id ${widget.categoryId} ${widget.parentId}');
                          if ((widget.categoryId.toString() ==
                              widget.parentId.toString()) ||
                              categoryId != null) {
                            dynamicFields = homeSettingsBloc
                                .settings!.categories!
                                .firstWhere((element) =>
                            element.id.toString() ==
                                (categoryId?.toString() ??
                                    widget.categoryId.toString()))
                                .dynamicFilterFields;
                            filterValues = state.dynamicFilters != null
                                ? state.dynamicFilters
                                : null;
                          } else {
                            dynamicFields = homeSettingsBloc
                                .settings!.categories!
                                .firstWhere((element) =>
                            element.id.toString() ==
                                widget.parentId.toString())
                                .subCategories!
                                .firstWhere((element) =>
                            element.id == widget.categoryId)
                                .dynamicFilterFields;
                            filterValues = state.dynamicFilters != null
                                ? state.dynamicFilters
                                : null;
                          }
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        dynamicFields == null
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container(),
                        Column(
                          children: [
                            for (int index = 0;
                            index < (dynamicFields?.length ?? 0);
                            index++)
                              dynamicFields![index].type == 'select'
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
                                        hint: Text(
                                            S.of(context).choose_value),
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
                                        .map((e) => SizedBox(
                                      width: double.maxFinite,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
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
                                          Radio(
                                            // contentPadding:
                                            //     EdgeInsets.zero,
                                            groupValue:
                                            filterValues?[
                                            index]
                                            as String?,
                                            onChanged:
                                                (String?
                                            value) {
                                              filterValues![
                                              index] =
                                              value!;
                                              homeSettingsBloc.add(
                                                  ChangeDynamicValues(
                                                      filterValues!));
                                            },
                                            value: e,
                                            activeColor: AppStyle
                                                .secondaryColor,
                                          ),
                                        ],
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
                                  : Container()
                          ],
                        )
                      ],
                    ),
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
                      Map<int, dynamic> parsedValues = {};
                      if (filterValues != null) {
                        for (int i = 0; i < filterValues!.length; i++) {
                          if (filterValues![i] is String) {
                            parsedValues[dynamicFields![i].id] =
                                dynamicFields![i]
                                    .options
                                    .indexOf(filterValues![i]);
                          } else {
                            List<int> innerList = [];
                            if (filterValues?[i] != null) {
                              for (var e in filterValues?[i]) {
                                innerList
                                    .add(dynamicFields![i].options.indexOf(e));
                              }
                            }
                            parsedValues[dynamicFields![i].id] = innerList;
                          }
                        }
                      }
                      result.putIfAbsent("_field_values", () => parsedValues);
                      Navigator.pop(context, result);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).applyFilter,
                          style: AppStyle.vexa14.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                    sl<HomesettingsBloc>().add(AddDynamicFields(
                        categoryId.toString(), categoryId.toString()));
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
