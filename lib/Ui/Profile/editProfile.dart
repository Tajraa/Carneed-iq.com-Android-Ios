import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: sl<HomesettingsBloc>().settings?.user?.name ?? "");
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
