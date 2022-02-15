import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import '/injections.dart';

class AppRatingWidget extends StatefulWidget {
  AppRatingWidget({required this.itemId, Key? key}) : super(key: key);
  final int itemId;
  @override
  _AppRatingWidgetState createState() => _AppRatingWidgetState();
}

class _AppRatingWidgetState extends State<AppRatingWidget> {
  int rating = 3;
  bool loading = false;
  String comment = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.h(100),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
            child: Material(
              color: AppStyle.whiteColor,
              borderRadius: BorderRadius.circular(SizeConfig.h(10)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(14)),
                decoration: BoxDecoration(
                    color: AppStyle.whiteColor,
                    borderRadius: BorderRadius.circular(SizeConfig.h(10))),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.h(24),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).rateOrder,
                          style: AppStyle.vexa16.copyWith(
                              color: AppStyle.secondaryColor,
                              fontSize: SizeConfig.h(18)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.h(24),
                    ),
                    RatingBar(
                      initialRating: rating.toDouble(),
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: AppStyle.yellowColor,
                        ),
                        half: Icon(Icons.star),
                        empty: Icon(
                          Icons.star_border_outlined,
                          color: AppStyle.yellowColor.withOpacity(0.5),
                        ),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (rate) {
                        rating = rate.toInt();
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.h(24),
                    ),
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.h(8)),
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            style: AppStyle.vexa12,
                            onChanged: (v) {
                              setState(() {
                                comment = v;
                              });
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: S.of(context).comment),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.h(14),
                    ),
                    if (loading)
                      AppLoader()
                    else
                      MainButton(
                        onTap: () async {
                          await sendRating(context);
                        },
                        child: SizedBox(
                          height: SizeConfig.h(44),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).rateIt,
                                style: AppStyle.vexa16,
                              )
                            ],
                          ),
                        ),
                        isOutlined: false,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    SizedBox(
                      height: SizeConfig.h(14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendRating(BuildContext context) async {
    setState(() {
      loading = true;
    });
    final result = await ReviewOrderProduct(sl()).call(ReviewOrderProductParams(
        itemId: widget.itemId, comment: comment, rating: rating));
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {});
    setState(() {
      loading = false;
    });
    Navigator.pop(context, true);
  }
}
