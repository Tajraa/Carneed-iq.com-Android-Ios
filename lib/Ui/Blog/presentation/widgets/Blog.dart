import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progiom_cms/Getit_instance.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tajra/App/Widgets/CustomAppBar.dart';
import 'package:tajra/App/Widgets/EmptyPlacholder.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBlogCategory.dart';
import 'package:tajra/Ui/Blog/domain/model/modelBloge.dart';
import 'package:tajra/Ui/Blog/domain/usecases/get_categories.dart';
import 'package:tajra/Ui/Blog/presentation/bloc/bloc.dart';
import 'package:tajra/Ui/Blog/presentation/bloc/homesettings_bloc.dart';
import 'package:tajra/Ui/Blog/presentation/widgets/BlogDetailsPage.dart';
import 'package:tajra/Utils/SizeConfig.dart';
import 'package:tajra/Utils/Style.dart';
import 'package:tajra/generated/l10n.dart';

class BlogPage extends StatefulWidget {
  BlogPage() : super();

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  GetPreferences() async {
    final result = await GetLsitCategories(sl()).call(NoParams());
    result.fold((l) {}, (r) {
      setState(() {
        categorys = r;
        Categoryview = true;
        selectedCategoryId = GetProducatsByCategoryParams(categoryId: "9999");
      });
    });
  }

  BlogBloc blog = BlogBloc();

  late GetProducatsByCategoryParams selectedCategoryId;
  late BlogBlocpaje blogBlocpaje;
  final homeSettingsBloc = sl<HomesettingsBloc>();

  @override
  void initState() {
    GetPreferences();
    blogBlocpaje =
        BlogBlocpaje(GetProducatsByCategoryParams(categoryId: "9999"));
    // blogBlocpaje.add(
    //   LoadEvent(
    //     {
    //       'parent_id': selectedCategoryId.categoryId,
    //     },
    //   ),
    // );

    blog.add(GetBlogs(""));
    // BlocProvider.of<BlogBlocpaje>(context)
    //     .add(LoadEvent({'parent_id': selectedCategoryId.categoryId}));
    // blogBlocpaje.add(LoadEvent({
    //   'parent_id': selectedCategoryId.categoryId,
    // }));
    super.initState();
  }

  List<Data> categorys = [];
  List<dynamic> blogs = [];

  bool Categoryview = false;
  bool blogview = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: blog,
      listener: (context, BlogState state) {
        if (state is BlogReady) {
          setState(() {
            blogs = state.blogs;
            blogview = true;
          });
        } else {
          blogview = false;
        }
      },
      child: BlocBuilder(
          bloc: blog,
          builder: (context, BlogState state) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: CustomScrollView(
                  physics:
                      blogs.isNotEmpty ? null : NeverScrollableScrollPhysics(),
                  controller: blogBlocpaje.scrollController,
                  slivers: [
                    buildAppBar(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: SizeConfig.h(14),
                      ),
                    ),
                    if (Categoryview) buildSubCategories(categorys),
                    !blogview
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : blogs.isNotEmpty
                            ? buildBlogs(blogs as List<DataBlog>)
                            : SliverFillRemaining(
                                child: EmptyPlacholder(
                                skipNavBarHeight: true,
                                title: S.of(context).no_result,
                                imageName: "assets/noSearch.png",
                                subtitle: "",
                                actionTitle: S.of(context).continueShopping,
                                onActionTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      "/base", ModalRoute.withName('/'));
                                },
                              )),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: SizeConfig.h(30),
                      ),
                    ),
                  ],
                ));
          }),
    );
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
                  S.of(context).blog,
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
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSubCategories(List<Data> categorys) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.h(40),
        child: Row(
          children: [
            SizedBox(
              width: SizeConfig.h(7),
            ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categorys.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return allProductsSection(categorys);
                      final category = categorys[index - 1];
                      final isSelected =
                          selectedCategoryId.categoryId.toString() ==
                              category.id.toString();
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = GetProducatsByCategoryParams(
                                categoryId: category.id.toString());
                          });
                          blog.add(GetBlogs(selectedCategoryId.categoryId));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              boxShadow:
                                  isSelected ? [AppStyle.boxShadow3on6] : null,
                              color: isSelected
                                  ? AppStyle.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: 70,
                              child: Center(
                                child: Text(
                                  category.title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1.1,
                                      fontSize: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : AppStyle.greyDark),
                                ),
                              ),
                            )),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildBlogs(List<DataBlog> dataBlogs) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.h(7),
            ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: dataBlogs.length,
                    itemBuilder: (context, index) {
                      final dataBlog = dataBlogs[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlogsDetailsPage(
                                      id: dataBlog.id!.toString(),
                                    )));
                          },
                          child: Container(
                            width: SizeConfig.h(90),
                            height: SizeConfig.h(90),
                            decoration: BoxDecoration(
                              boxShadow: [AppStyle.boxShadow3on6],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 7),
                                  width: SizeConfig.h(70),
                                  height: SizeConfig.h(70),
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
                                      imageUrl: dataBlog.coverImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth / 1.5,
                                      child: Text(
                                        dataBlog.title!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            height: 1.1,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth / 1.5,
                                      child: Text(
                                        dataBlog.metaDescription!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            height: 1.1,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  allProductsSection(List<Data> categorys) {
    final isSelected = selectedCategoryId.categoryId.toString() == "9999";
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryId = GetProducatsByCategoryParams(categoryId: "9999");
        });

        blog.add(GetBlogs(selectedCategoryId.categoryId));
      },
      child: Container(
          decoration: BoxDecoration(
            boxShadow: isSelected ? [AppStyle.boxShadow3on6] : null,
            color: isSelected ? AppStyle.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 70,
            child: Center(
              child: Text(
                S.of(context).all,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 13,
                    color: isSelected ? Colors.white : AppStyle.greyDark),
              ),
            ),
          )),
    );
  }
}
