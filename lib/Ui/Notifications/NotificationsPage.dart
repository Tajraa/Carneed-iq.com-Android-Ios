import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/notifications.dart';
import '/App/Widgets/AppErrorWidget.dart';
import '/App/Widgets/AppLoader.dart';
import '/App/Widgets/CustomAppBar.dart';
import '/App/Widgets/EmptyPlacholder.dart';
import '/Ui/Notifications/bloc/notifications_bloc.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../injections.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Color unReadColor = const Color(0xFFEAEAEA);
  final NotificationsBLoc bloc = NotificationsBLoc();

  @override
  void initState() {
    bloc.add(LoadEvent(""));
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(
            isCustom: true,
            child: Row(
              children: [
                BackButton(
                  color: Colors.white,
                ),
                Text(
                  S.of(context).notifications,
                  style: AppStyle.vexa16.copyWith(color: AppStyle.whiteColor),
                )
              ],
            ),
          ),
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
                if (state is SuccessState<List<ServerNotification>>) {
                  if (state.items.isEmpty) {
                    return EmptyPlacholder(
                      title: S.of(context).no_notifications,
                      imageName: "assets/noNotifications.png",
                      subtitle: S.of(context).no_notifications_subtitle,
                      actionTitle: S.of(context).continueShopping,
                      onActionTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                  return ListView.builder(
                      controller: bloc.scrollController,
                      padding: EdgeInsets.only(top: SizeConfig.h(5)),
                      itemCount: state.hasReachedMax
                          ? state.items.length
                          : state.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.items.length)
                          return Center(
                            child: AppLoader(),
                          );
                        final noti = state.items[index];
                        final color = noti.notificationType == "danger"
                            ? AppStyle.redColor
                            : noti.notificationType == "info"
                                ? AppStyle.secondaryColor
                                : noti.notificationType == "success"
                                    ? AppStyle.greenColor
                                    : AppStyle.warningColor;
                        return GestureDetector(
                          onTap: () {
                            if (!noti.isRead) {
                              SetNotificationAsRead(sl()).call(
                                  SetNotificationAsReadParams(
                                      notificationId: noti.id));
                            }

                            if (noti.entityType == "post") {
                              Navigator.pushNamed(
                                context,
                                "/productDetails",
                                arguments: {
                                  "id": noti.entityId.toString(),
                                  "goToOptions": false
                                },
                              );
                            }
                            if (noti.entityType == "order") {
                              Navigator.pushNamed(context, "/orderDetails",
                                  arguments: noti.entityId);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.h(24),
                                vertical: SizeConfig.h(14)),
                            width: SizeConfig.screenWidth,
                            color: !noti.isRead
                                ? unReadColor
                                : AppStyle.whiteColor,
                            margin:
                                EdgeInsets.symmetric(vertical: SizeConfig.h(5)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          noti.notificationTitle,
                                          style: AppStyle.vexa14.copyWith(
                                              color: AppStyle.secondaryColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: SizeConfig.h(15),
                                                  vertical: SizeConfig.h(5)),
                                              child: Text(
                                                noti.notificationType ==
                                                        "danger"
                                                    ? S.of(context).danger
                                                    : noti.notificationType ==
                                                            "info"
                                                        ? S.of(context).info
                                                        : noti.notificationType ==
                                                                "success"
                                                            ? S
                                                                .of(context)
                                                                .success
                                                            : S
                                                                .of(context)
                                                                .warning,
                                                style: AppStyle.vexaLight12
                                                    .copyWith(
                                                        color: color,
                                                        fontSize:
                                                            SizeConfig.h(10)),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border:
                                                      Border.all(color: color)),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.h(11),
                                            ),
                                            if (noti.link != null)
                                              GestureDetector(
                                                onTap: () async {
                                                  if (await canLaunch(
                                                      noti.link!)) {
                                                    launch(noti.link!);
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/foreign.svg",
                                                  height: SizeConfig.h(19),
                                                  width: SizeConfig.h(19),
                                                ),
                                              )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        noti.notificationText,
                                        style: AppStyle.vexaLight12.copyWith(
                                          fontSize: SizeConfig.h(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (noti.image != null)
                                  SizedBox(
                                    height: SizeConfig.h(18),
                                  ),
                                if (noti.image != null)
                                  AspectRatio(
                                    aspectRatio: 3 / 1,
                                    child: Image.network(
                                      noti.image!,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
