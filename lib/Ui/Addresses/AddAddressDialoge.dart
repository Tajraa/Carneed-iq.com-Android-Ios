import 'package:flutter/material.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/LocationDialoge.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Addresses/bloc/address_bloc.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/generated/l10n.dart';
import '/injections.dart';

class AddAddressDialoge extends StatefulWidget {
  AddAddressDialoge({Key? key}) : super(key: key);

  @override
  _AddAddressDialogeState createState() => _AddAddressDialogeState();
}

class _AddAddressDialogeState extends State<AddAddressDialoge> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CountryModel? selectedCountry;
  CityModel? selectedCity;
  final List<CityModel> cities = [];
  final AddressBloc bloc = AddressBloc();
  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        Container(
          height: SizeConfig.h(70 + topPadding),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                BackButton(
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: SizeConfig.h(24)),
                        child: Material(
                          color: AppStyle.whiteColor,
                          borderRadius: BorderRadius.circular(SizeConfig.h(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.h(14)),
                            decoration: BoxDecoration(
                                color: AppStyle.whiteColor,
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.h(10))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: SizeConfig.h(24),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).addAddress,
                                      style: AppStyle.vexa16.copyWith(
                                          color: AppStyle.secondaryColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(24),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        // height: SizeConfig.h(50),
                                        child: TextFormField(
                                            validator: (v) {
                                              if (v != null && v.isNotEmpty) {
                                                return null;
                                              }
                                              return S
                                                  .of(context)
                                                  .address_name_required;
                                            },
                                            controller: nameController,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                            SizeConfig.h(2),
                                                        horizontal:
                                                            SizeConfig.h(8)),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: AppStyle
                                                          .primaryColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(10),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: AppStyle
                                                          .disabledColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(10),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: AppStyle
                                                          .primaryColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(10),
                                                  ),
                                                ),
                                                labelText: "الاسم: ",
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                labelStyle: TextStyle(
                                                    fontSize: SizeConfig.h(14)),
                                                fillColor: Colors.white70)),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: SizeConfig.h(14),
                                    // ),
                                    // Expanded(child: buildTextField(text: "الكنية"))
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(14),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    LocationDialoge())
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedCountry = value;
                                            });
                                            getCitiesOfCurrentCountry(context);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(SizeConfig.h(14)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              S.of(context).country +
                                                  (selectedCountry != null
                                                      ? (selectedCountry!
                                                              .title ??
                                                          "")
                                                      : ""),
                                              style: AppStyle.vexaLight12
                                                  .copyWith(
                                                      fontSize:
                                                          SizeConfig.h(14)),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              size: SizeConfig.h(18),
                                              color: AppStyle.disabledColor,
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppStyle.disabledColor),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ))
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.h(14),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.h(14)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: DropdownButton<CityModel>(
                                            underline: Container(),
                                            icon: Container(),
                                            hint: Text(
                                              S.of(context).city,
                                              style: AppStyle.vexaLight12
                                                  .copyWith(
                                                      fontSize:
                                                          SizeConfig.h(14)),
                                            ),
                                            isExpanded: true,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedCity = v;
                                              });
                                            },
                                            value: selectedCity,
                                            items: cities.isEmpty
                                                ? null
                                                : cities.map((e) {
                                                    return DropdownMenuItem<
                                                            CityModel>(
                                                        value: e,
                                                        child: Text(
                                                          (e.name ?? ""),
                                                          style: AppStyle.vexa12
                                                              .copyWith(
                                                                  fontSize:
                                                                      SizeConfig
                                                                          .h(14)),
                                                        ));
                                                  }).toList()),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: SizeConfig.h(18),
                                        color: AppStyle.disabledColor,
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppStyle.disabledColor),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                SizedBox(
                                  height: SizeConfig.h(14),
                                ),
                                TextFormField(
                                    controller: addressController,
                                    maxLines: 3,
                                    validator: (v) {
                                      if (v != null && v.isNotEmpty) {
                                        return null;
                                      }
                                      return S.of(context).mustAddAddress;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: AppStyle.primaryColor),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: AppStyle.disabledColor),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: AppStyle.primaryColor),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10),
                                          ),
                                        ),
                                        labelText: S.of(context).addressDetails,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        labelStyle: TextStyle(
                                            fontSize: SizeConfig.h(14)),
                                        fillColor: Colors.white70)),
                                SizedBox(
                                  height: SizeConfig.h(14),
                                ),
                                BlocConsumer(
                                  listener: (context, state) {
                                    if (state is ErrorState) {
                                      AppSnackBar.show(context, state.error,
                                          ToastType.Error);
                                    }
                                    if (state is AddressSuccessState) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                  bloc: bloc,
                                  builder: (context, state) {
                                    if (state is LoadingState)
                                      return Center(
                                        child: AppLoader(),
                                      );
                                    return MainButton(
                                      onTap: () {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          bloc.add(AddAddressEvent(
                                              cityId: selectedCity?.id ??
                                                  0, //! !!!!!!!!!!!
                                              name: nameController.text,
                                              countryId: selectedCountry!.id,
                                              description:
                                                  addressController.text));
                                        }
                                      },
                                      child: SizedBox(
                                        height: SizeConfig.h(44),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              S.of(context).addAddress,
                                              style: AppStyle.vexa16,
                                            )
                                          ],
                                        ),
                                      ),
                                      isOutlined: false,
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                  },
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getCitiesOfCurrentCountry(BuildContext context) async {
    final result = await GetCities(sl())
        .call(GetCitiesParams(countryId: selectedCountry!.id));
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      setState(() {
        cities.clear();
        cities.addAll(r);
        selectedCity = cities.isNotEmpty ? cities.first : null;
      });
    });
  }
}
