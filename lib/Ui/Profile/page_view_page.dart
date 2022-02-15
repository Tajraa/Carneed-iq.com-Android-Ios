import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:progiom_cms/homeSettings.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';

import '../../injections.dart';

class PageViewScreen extends StatefulWidget {
  final int pageId;
  PageViewScreen(this.pageId, {Key? key}) : super(key: key);

  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  PageModel? pageDetails;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.secondaryColor,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          pageDetails == null ? "" : pageDetails!.title,
          style: AppStyle.vexa14
              .copyWith(fontSize: SizeConfig.h(14), color: Colors.white),
        ),
      ),
      body: pageDetails == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Html(
                      data: pageDetails!.description ?? "",
                      style: {
                        "*": Style.fromTextStyle(AppStyle.vexa16.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400))
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  getData() async {
    final result = await GetPageDetails(sl())
        .call(GetPageDetailsParams(id: widget.pageId));
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      setState(() {
        pageDetails = r;
      });
    });
  }
}
