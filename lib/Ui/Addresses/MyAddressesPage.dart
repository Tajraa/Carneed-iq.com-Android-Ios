import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/App/Widgets/MainButton.dart';
import '/Ui/Addresses/AddAddressDialoge.dart';
import '/Ui/Addresses/bloc/my_addresses_bloc.dart'
    as myAddressesBloc;
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/generated/l10n.dart';
import '/injections.dart';

import 'bloc/address_bloc.dart' as addressesBloc;

class MyAddressesPage extends StatefulWidget {
  MyAddressesPage({Key? key}) : super(key: key);

  @override
  _MyAddressesPageState createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  final myAddressesBloc.MyAddressesBloc bloc =
      myAddressesBloc.MyAddressesBloc();
  final addressesBloc.AddressBloc addressBloc = addressesBloc.AddressBloc();

  @override
  void initState() {
    bloc.add(LoadEvent(""));
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer(
          bloc: addressBloc,
          listener: (context, state) {
            if (state is addressesBloc.ErrorState) {
              AppSnackBar.show(context, state.error, ToastType.Error);
            }
            if (state is addressesBloc.AddressSuccessState) {
              bloc.add(LoadEvent(""));
            }
          },
          builder: (context, state) {
            return (state is addressesBloc.LoadingState)
                ? Column(
                    children: [
                      CustomAppBar(
                        isCustom: true,
                        child: Row(
                          children: [
                            BackButton(
                              color: AppStyle.whiteColor,
                            ),
                            Text(
                              S.of(context).my_addresses,
                              style: AppStyle.vexa16,
                            )
                          ],
                        ),
                      ),
                      Expanded(child: AppLoader()),
                    ],
                  )
                : Column(children: [
                    // if
                    //
                    // else
                    CustomAppBar(
                      isCustom: true,
                      child: Row(
                        children: [
                          BackButton(
                            color: AppStyle.whiteColor,
                          ),
                          Text(
                            S.of(context).my_addresses,
                            style: AppStyle.vexa16,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.h(21),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.h(24),
                        ),
                        Text(
                          S.of(context).my_registered_addresses,
                          style: AppStyle.vexa16
                              .copyWith(color: AppStyle.secondaryColor),
                        )
                      ],
                    ),
                    // if (state is addressesBloc.LoadingState)
                    //   AppLoader()
                    // else
                    Expanded(
                      child: BlocBuilder(
                        bloc: bloc,
                        builder: (context, state) {
                          if (state is ErrorState) {
                            return AppErrorWidget(text: state.error);
                          }
                          if (state is LoadingState) {
                            return AppLoader();
                          }
                          if (state is SuccessState<List<Address>>) {
                            if (state.items.isEmpty)
                              return EmptyPlacholder(
                                title: S.of(context).noAddresses,
                                imageName: "assets/noAddresses.png",
                                subtitle: S.of(context).add_address_subtitle,
                              );
                            return ListView.builder(
                                padding: EdgeInsets.only(top: SizeConfig.h(7)),
                                itemCount: state.hasReachedMax
                                    ? state.items.length
                                    : state.items.length + 1,
                                itemBuilder: (context, index) {
                                  if (index >= state.items.length)
                                    return Center(
                                      child: AppLoader(),
                                    );

                                  final address = state.items[index];
                                  return buildAddressCard(address, index == 0);
                                });
                          }
                          return Container();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.h(24),
                        ),
                        Expanded(
                            child: SizedBox(
                          height: SizeConfig.h(44),
                          child: MainButton(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: AddAddressDialoge(),
                                    );
                                  }).then((value) {
                                if (value != null && value) {
                                  bloc.add(LoadEvent(""));
                                }
                              });
                            },
                            color: AppStyle.primaryColor,
                            isOutlined: true,
                            borderRadius: BorderRadius.circular(5),
                            child: Center(
                                child: Text(
                              S.of(context).addAddress,
                              style: AppStyle.vexa16
                                  .copyWith(color: AppStyle.primaryColor),
                            )),
                          ),
                        )),
                        SizedBox(
                          width: SizeConfig.h(24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.h(40),
                    )
                  ]);
          },
        ));
  }

  Container buildAddressCard(Address address, bool selected) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.h(24), vertical: SizeConfig.h(7)),
      padding: EdgeInsets.all(SizeConfig.h(14)),
      decoration: BoxDecoration(
          color: AppStyle.whiteColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 30, offset: Offset(0.0, 30), color: Colors.black12)
          ],
          borderRadius: BorderRadius.circular(SizeConfig.h(10))),
      child: Row(
        children: [
          Radio<bool>(
              value: selected,
              groupValue: true,
              onChanged: (v) {
                // if ((v ?? false) && !selected)
                addressBloc
                    .add(addressesBloc.SetDefaultAddressEvent(address.id));
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                style: AppStyle.vexa14,
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: SizeConfig.h(200),
                child: Text(
                  address.description ?? "",
                  style: AppStyle.vexaLight12,
                ),
              )
            ],
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.h(24),
            height: SizeConfig.h(24),
            child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert,
                  color: AppStyle.greyColor,
                  size: SizeConfig.h(24),
                ),
                onSelected: (v) async {
                  if (v == "0") {
                    addressBloc
                        .add(addressesBloc.DeleteAddressEvent(address.id));
                  } else {}
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      height: SizeConfig.h(25.25),
                      value: "0",
                      textStyle: TextStyle(
                        color: Color(0xff707070),
                        fontSize: SizeConfig.w(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/trash.svg",
                            height: SizeConfig.h(15),
                            width: SizeConfig.h(15),
                          ),
                          SizedBox(
                            width: SizeConfig.h(10),
                          ),
                          Text(S.of(context).delete,
                              style: AppStyle.vexaLight12
                                  .copyWith(color: AppStyle.redColor)),
                        ],
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   height: SizeConfig.h(25.25),
                    //   value: "1",
                    //   textStyle: TextStyle(
                    //     color: Color(0xff707070),
                    //     fontSize: SizeConfig.w(12),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       SvgPicture.asset(
                    //         "assets/edit.svg",
                    //         height: SizeConfig.h(15),
                    //         width: SizeConfig.h(15),
                    //       ),
                    //       SizedBox(
                    //         width: SizeConfig.h(10),
                    //       ),
                    //       Text("تعديل",
                    //           style: AppStyle.vexaLight12
                    //               .copyWith(
                    //                   color: AppStyle
                    //                       .secondaryColor)),
                    //     ],
                    //   ),
                    // )
                  ];
                }),
          ),
        ],
      ),
    );
  }
}
