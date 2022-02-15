import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

class GallaryPage extends StatefulWidget {
  final List<String> images;
  final int currentIndex;

  const GallaryPage(
      {Key? key, required this.currentIndex, required this.images})
      : super(key: key);

  @override
  _GallaryPageState createState() => _GallaryPageState();
}

class _GallaryPageState extends State<GallaryPage> {
  void onPageChanged(int index) {
    setState(() {
      outerIndex = index;
    });
  }

  int outerIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentIndex);
    outerIndex = widget.currentIndex;
  }

  late final PageController pageController;
  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  widget.images[index],
                ),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.currentIndex),
              );
            },
            itemCount: widget.images.length,
            backgroundDecoration: BoxDecoration(color: Colors.black38),
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            onPageChanged: onPageChanged,
          ),
          Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                " ${outerIndex + 1}/${widget.images.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.only(top: topPadding),
                width: double.infinity,
                height: SizeConfig.h(70 + topPadding),
                child: Row(children: [
                  BackButton(
                    color: AppStyle.whiteColor,
                  )
                ])),
          )
        ],
      ),
    );
  }
}
