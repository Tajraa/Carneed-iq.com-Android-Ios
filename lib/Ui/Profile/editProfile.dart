import 'dart:io';

import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '/App/Widgets/AppLoader.dart';
import '/Utils/AppSnackBar.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:image_picker/image_picker.dart';
import '/data/repository/Repository.dart';

import '/generated/l10n.dart';
import '/injections.dart';

import 'package:progiom_cms/auth.dart';

import 'package:progiom_cms/homeSettings.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController nameController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  late PhoneNumber phoneNumber;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: sl<HomesettingsBloc>().settings?.user?.name ?? "");
    final countryCode = CountryPickerUtils.getCountryByPhoneCode(
        sl<HomesettingsBloc>().settings?.user?.countryCode?.substring(1) ??
            '')
        .isoCode;
    // print('cc is ${cc.numeric}');
    phoneNumber = PhoneNumber(
        countryISOCode: countryCode,
        countryCode: sl<HomesettingsBloc>().settings?.user?.countryCode ?? '',
        number: sl<HomesettingsBloc>().settings?.user?.mobile ?? '');
    phoneController.text = sl<HomesettingsBloc>().settings?.user?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            S.of(context).personalInfo,
            style: AppStyle.vexa16,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.h(28),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.h(80),
                      foregroundImage: profilePhotoHandlerPath != null
                          ? FileImage(File(profilePhotoHandlerPath))
                          : null,
                      backgroundImage:
                      (sl<HomesettingsBloc>().settings?.user?.coverImage !=
                          null)
                          ? NetworkImage((sl<HomesettingsBloc>()
                          .settings
                          ?.user
                          ?.coverImage) ??
                          "")
                          : null,
                    ),
                    Positioned(
                      bottom: SizeConfig.h(25),
                      child: Container(
                        height: SizeConfig.h(35),
                        width: SizeConfig.h(35),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: IconButton(
                          onPressed: () {
                            pickImage();
                          },
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppStyle.primaryColor,
                            size: SizeConfig.h(21),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      S.of(context).fullName,
                      style: AppStyle.vexa16,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                          height: SizeConfig.h(60),
                          child: TextFormField(
                            validator: (v) {
                              if (v != null) {
                                if (v.isEmpty) {
                                  return S.of(context).nameRequired;
                                }
                              }
                              return null;
                            },
                            controller: nameController,
                            style: AppStyle.vexa14.copyWith(color: Colors.black),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16))),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),
                Row(
                  children: [
                    Text(
                      S.of(context).e_mail,
                      style: AppStyle.vexa16,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: IntlPhoneField(
                    initialCountryCode: phoneNumber.countryISOCode,
                    searchText: S.of(context).searchHere,
                    dropdownTextStyle: TextStyle(fontSize: SizeConfig.w(12)),
                    style: TextStyle(fontSize: SizeConfig.w(12)),
                    showCountryFlag:
                    phoneNumber.countryCode == '+963' ? false : true,
                    onCountryChanged: (c) {
                      setState(() {
                        phoneNumber.countryCode = '+' + c.dialCode;
                      });
                    },
                    onChanged: (PhoneNumber phoneNumber) {
                      setState(() {
                        phoneNumber.countryCode = phoneNumber.countryCode;
                        phoneNumber.number = '0' + phoneNumber.number;
                      });
                    },
                    controller: phoneController,
                    invalidNumberMessage: S.of(context).mobileValidator,
                    decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        alignLabelWithHint: true,
                        suffixIcon: Icon(Icons.phone_android),
                        labelText: S.of(context).phone_number,
                        contentPadding: EdgeInsets.symmetric(
                          // vertical: SizeConfig.h(2),
                          horizontal: SizeConfig.w(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: AppStyle.primaryColor),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(16),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: AppStyle.disabledColor),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(16),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: AppStyle.primaryColor),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(16),
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: TextStyle(
                          fontSize: SizeConfig.h(14),
                        ),
                        errorStyle: TextStyle(fontSize: SizeConfig.h(14)),
                        fillColor: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.h(10),
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                          height: SizeConfig.h(60),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                            sl<HomesettingsBloc>().settings?.user?.email ?? "",
                            style: AppStyle.vexa14.copyWith(color: Colors.black),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppStyle.disabledColor,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16))),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: SizeConfig.h(50),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: SizeConfig.h(50),
                    ),
                    if (isLoading)
                      AppLoader()
                    else
                      Expanded(
                          child: MainButton(
                              isOutlined: false,
                              onTap: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  editData();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).editProfile,
                                    style: AppStyle.vexa14.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))),
                    SizedBox(
                      width: SizeConfig.h(50),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  var profilePhotoHandlerPath;

  pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        profilePhotoHandlerPath = photo.path;
      });
    }
  }

  editData() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      "name": nameController.text,
      "country_code": phoneNumber.countryCode,
      "mobile": phoneNumber.number,
    };
    if (profilePhotoHandlerPath != null) {
      var url = await sl<Repository>().uploadFile(
        profilePhotoHandlerPath,
      );
      data.putIfAbsent("image", () => url);
    }

    final result = await UpdateProfile(sl()).call(UpdateProfileParams(data));
    setState(() {
      isLoading = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      sl<HomesettingsBloc>().settings?.user?.name = nameController.text;
      Navigator.pop(context, true);
    });
  }
}
