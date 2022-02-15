import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

import '../../injections.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final settings = sl<HomesettingsBloc>().settings!;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(isCustom: false),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.h(14), vertical: SizeConfig.h(14)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).categories,
                        style: AppStyle.vexa14
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.h(14),
                  ),
                  Expanded(
                      child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: SizeConfig.h(110),
                        crossAxisSpacing: 0.0,
                        mainAxisExtent: SizeConfig.h(100),
                        mainAxisSpacing: SizeConfig.h(10)),
                    children: [
                      for (Category category in settings.categories!)
                        buildCategoryCard(category),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/categoryProducts',
            arguments: {"category": category, "id": category.id});
      },
      child: Column(
        children: [
          Container(
            width: SizeConfig.h(71),
            height: SizeConfig.h(71),
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
            height: SizeConfig.h(3),
          ),
          SizedBox(
            width: SizeConfig.h(71),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  category.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: AppStyle.vexa12,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
