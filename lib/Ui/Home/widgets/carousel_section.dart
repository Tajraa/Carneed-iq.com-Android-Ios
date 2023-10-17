import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Utils/SizeConfig.dart';

class CarouselSection extends StatefulWidget {
  CarouselSection({Key? key, required this.slides}) : super(key: key);
  final List<Slide> slides;
  @override
  _CarouselSectionState createState() => _CarouselSectionState();
}

String? spotifyUrl;

class _CarouselSectionState extends State<CarouselSection> {
  int currentCarouselIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.h(154),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (v, reason) {
                    setState(() {
                      currentCarouselIndex = v;
                    });
                  },
                  height: SizeConfig.h(154),
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 7),
                  scrollDirection: Axis.horizontal,
                  viewportFraction: SizeConfig.isWideScreen() ? 0.7 : 1),
              items: [
                for (Slide slide in widget.slides)
                  InkWell(
                    onTap: () async {
                      // if (slide.link != null) {
                      //   if (await canLaunch(slide.link!)) {
                      //     launch(slide.link!);
                      //   }
                      // }
                    },
                    child: Container(
                      margin: SizeConfig.isWideScreen()
                          ? EdgeInsets.symmetric(horizontal: SizeConfig.h(12))
                          : null,
                      height: SizeConfig.h(154),
                      width: SizeConfig.screenWidth,
                      child: GestureDetector(
                        onTap: () async {
                          print(slide.link);
                          if (slide.link != null) {
                            if (await canLaunch(slide.link!)) {
                              launch(slide.link!);
                            }
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: slide.coverImage ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ]),
          Positioned(
            bottom: SizeConfig.h(20),
            child: Row(
              children: [
                ...List.generate(
                    widget.slides.length,
                    (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: index == currentCarouselIndex ? 10 : 5,
                          width: index == currentCarouselIndex ? 10 : 5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
