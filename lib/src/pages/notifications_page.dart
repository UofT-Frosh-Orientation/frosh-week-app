import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:frosh_week_2t1/src/widgets/Containers.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/ScheduleList.dart";
import "../widgets/ContainersExtensions.dart";

class Notification {
  Notification(
      {required this.title,
      required this.description,
      this.froshGroup = "",
      this.time = ""});
  String title;
  String description;
  String froshGroup;
  String time;
}

class NotificationsPageParse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationsPage(notifications: [
      Notification(
          title: "Matriculation",
          description: "Please go to SF1105",
          time: "11:00 AM"),
      Notification(
          title: "Another one",
          description: "Please go to bla bla bla",
          time: "1:00 PM")
    ]);
  }
}

class NotificationsPage extends StatelessWidget {
  final List<Notification> notifications;

  const NotificationsPage({
    Key? key,
    required this.notifications,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () => Future.delayed(Duration(seconds: 2), () {
        print("refresh notifications");
      }),
      child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              MainHeader(
                text: 'Notifications',
                textSmaller: "",
                icon: false,
              ),
              notifications.length == 0
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 70),
                      child: TextFont(text: "There are no notifications"),
                    ))
                  : Container()
            ])),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      NotificationBox(notification: notifications[index]),
                  childCount: notifications.length),
            )
          ]),
    ));
  }
}

class NotificationBox extends StatelessWidget {
  final Notification notification;

  const NotificationBox({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Box(
        widget: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: TextFont(
                  text: notification.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFont(
                  text: notification.time,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Container(height: 4),
          TextFont(
            text: notification.description,
            fontSize: 16,
          )
        ],
      ),
    ));
  }
}
