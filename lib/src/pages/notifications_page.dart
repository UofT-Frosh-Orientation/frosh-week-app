import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/widgets/Containers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import "../functions.dart";

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

class NotificationsPageParse extends StatefulWidget {
  const NotificationsPageParse({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationsPageParseState createState() => _NotificationsPageParseState();
}

class _NotificationsPageParseState extends State<NotificationsPageParse> {
  List<Notification> notifications = [];

  Future<void> getNotifications() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? rawNotifications = preferences.getStringList('notifications');
    if (rawNotifications == null) {
      return;
    }
    List<Notification> parsedNotifications = rawNotifications.map((notif) {
      Map<String, dynamic> parsed = jsonDecode(notif);
      return Notification(
          title: parsed["title"],
          description: parsed["description"],
          time: parsed["time"]);
    }).toList();
    setState(() {
      notifications = parsedNotifications;
    });
  }

  @override
  initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // return NotificationsPage(notifications: notifications);
    return NotificationsPage(notifications: [
      Notification(
          title: "title really long test",
          description: "description",
          time: "23:00 PM")
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
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
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
    ]));
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
                  text: notification.title.capitalizeFirst,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFont(
                  text: notification.time.capitalizeFirst,
                  fontSize: 15,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          Container(height: 4),
          TextFont(
            text: notification.description.capitalizeFirst,
            fontSize: 16,
          )
        ],
      ),
    ));
  }
}
