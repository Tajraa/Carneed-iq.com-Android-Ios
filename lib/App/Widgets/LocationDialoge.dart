import 'package:flutter/material.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '../../Utils/AppSnackBar.dart';
import '../../Utils/SizeConfig.dart';
import '/generated/l10n.dart';

import '../../injections.dart';

class LocationDialoge extends StatefulWidget {
  LocationDialoge({Key? key}) : super(key: key);

  @override
  _LocationDialogeState createState() => _LocationDialogeState();
}

class _LocationDialogeState extends State<LocationDialoge> {
  int? selectedCountry;
  List<CountryModel>? countries;
  getSelectedLocation() async {
    final result = await GetCountries(sl()).call(NoParams());
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      countries = r;
    });
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  @override
  void initState() {
    getSelectedLocation();
    super.initState();
  }

  String query = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: SizeConfig.screenWidth * 0.8,
          height: SizeConfig.screenHeight * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(S.of(context).select_country),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: TextStyle(fontSize: SizeConfig.h(12)),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: SizeConfig.h(12)),
                        prefixIcon: Icon(Icons.search)),
                  ))
                ],
              ),
              countries == null
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: countries!.length,
                          itemBuilder: (context, index) {
                            if ((query.startsWith("ا")
                                    ? ((countries![index].title ?? "")
                                        .toLowerCase()
                                        .replaceFirst("أ", "ا")
                                        .replaceFirst("إ", "ا"))
                                    : countries![index].title?.toLowerCase())!
                                .contains(query.toLowerCase()))
                              return Column(
                                children: [
                                  ListTile(
                                      onTap: () {
                                        // sl<PrefsHelper>().setLocation(
                                        //     countries[index].id,
                                        //     countries[index].title);
                                        setState(() {
                                          selectedCountry =
                                              countries![index].id;
                                        });
                                        Navigator.pop(
                                            context, countries![index]);
                                      },
                                      selected: countries![index].id ==
                                          (selectedCountry ?? 0),
                                      title: Row(
                                        children: [
                                          Text(countries![index].title ?? "",
                                              style: TextStyle(
                                                fontSize: SizeConfig.h(12),
                                              )),
                                          Spacer(),
                                          if (countries![index].id ==
                                              (selectedCountry ?? 0))
                                            Icon(
                                              Icons.check,
                                              color: Colors.blue,
                                              size: SizeConfig.h(20),
                                            ),
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.black38,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            return Container();
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
