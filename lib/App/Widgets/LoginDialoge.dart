import 'package:flutter/material.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';

showLoginDialoge(context) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              height: SizeConfig.h(450),
              width: SizeConfig.w(350),
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/colored_logo.png",
                            height: SizeConfig.h(100),
                            width: SizeConfig.w(200),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      Text(
                        S.of(context).not_loggedin_content,
                        style: TextStyle(
                            height: 1.1,
                            fontSize: SizeConfig.w(20),
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: SizeConfig.h(12),
                      ),
                      Text(
                        S.of(context).by_login_dialoge,
                        style: TextStyle(
                            fontSize: SizeConfig.w(17),
                            color: AppStyle.greyColor),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                S.of(context).back,
                                style: TextStyle(
                                    height: 1.1,
                                    fontSize: SizeConfig.w(14),
                                    color: AppStyle.greyColor),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/login",
                                    arguments: true);
                              },
                              child: Text(
                                S.of(context).login,
                                style: TextStyle(
                                    height: 1.1,
                                    fontSize: SizeConfig.w(14),
                                    color: Colors.black),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
}
