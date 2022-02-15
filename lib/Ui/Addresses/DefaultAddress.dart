import 'package:flutter/material.dart';
import '/App/Widgets/AppLoader.dart';
import '/Ui/Addresses/AddAddressDialoge.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import '/injections.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';

class MyDefaultAddress extends StatefulWidget {
  const MyDefaultAddress({Key? key, this.getAddressCallback}) : super(key: key);
  final Function(Address? address)? getAddressCallback;
  @override
  State<MyDefaultAddress> createState() => _MyDefaultAddressState();
}

class _MyDefaultAddressState extends State<MyDefaultAddress> {
  Address? defaultAddress;
  bool loading = true;
  getDefaultAddress() async {
    final result = await GetDefaultAddress(sl()).call(NoParams());
    setState(() {
      loading = false;
    });
    result.fold((l) {
      // no addresses for user
    }, (r) {
      setState(() {
        defaultAddress = r;
      });
      if (widget.getAddressCallback != null) widget.getAddressCallback!(r);
    });
  }

  @override
  void initState() {
    super.initState();
    getDefaultAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loading)
          Center(
            child: AppLoader(),
          )
        else if (defaultAddress != null)
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: AppStyle.disabledBorderColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppStyle.greyColor)),
                padding: EdgeInsets.all(SizeConfig.h(14)),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          defaultAddress?.name ?? "",
                          style: AppStyle.vexa12
                              .copyWith(color: AppStyle.secondaryColor),
                        ),
                        Text(
                          defaultAddress?.description ?? "",
                          style: AppStyle.vexa12
                              .copyWith(color: AppStyle.greyColor),
                        )
                      ],
                    ),
                  ],
                ),
              ))
            ],
          )
        else
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (contex) => AddAddressDialoge()).then((value) {
                if (value) {
                  getDefaultAddress();
                }
              });
            },
            child: Container(
              child: Text(
                S.of(context).addAddress,
                style: AppStyle.vexa16.copyWith(color: AppStyle.primaryColor),
              ),
            ),
          )
      ],
    );
  }
}
