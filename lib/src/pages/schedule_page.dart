import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/ScheduleList.dart";
import "../widgets/TextWidgets.dart";
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "../widgets/Containers.dart";
import 'dart:convert';
import '../colors.dart';

class SchedulePageParse extends StatelessWidget {
  Future<String> parseData(context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/data/schedule.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: parseData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = json.decode(snapshot.data ?? "");
          return SchedulePage(data: data);
        } else {
          return Container();
        }
      },
    );
  }
}

class SchedulePage extends StatelessWidget {
  final dynamic data;

  const SchedulePage({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ];
    DateTime date = DateTime.now();
    int initialIndex = 0;
    for (int i = 0; i < days.length; i++) {
      if (days[i] == DateFormat('EEEE').format(date)) {
        initialIndex = i;
        break;
      }
    }

    print([data.keys]);

    return Scaffold(
      body: DefaultTabController(
        initialIndex: initialIndex,
        length: days.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([
                MainHeader(
                  text: 'Schedule',
                  textSmaller: "2T1",
                  icon: false,
                ),
              ])),
              SliverAppBar(
                backgroundColor: Theme.of(context).canvasColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: TabBar(
                    labelColor: Theme.of(context).colorScheme.black,
                    isScrollable: true,
                    tabs: [for (var day in days) Tab(text: day)],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              for (var dayData in data.keys)
                ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    for (var event in data[dayData])
                      ContainerSchedule(
                        title: event["title"],
                        time: event["startTime"] + " - " + event["endTime"],
                        room: event["eventType"],
                        description: event["description"],
                      )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerSchedule extends StatelessWidget {
  final String title;
  final String time;
  final String room;
  final String description;

  const ContainerSchedule({
    Key? key,
    required this.title,
    required this.time,
    required this.room,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Box(
      outerPadding: 0,
      fancy: true,
      colors: [Color(0xAF64E69A), Color(0xB66580F5), Color(0xB6EE6097)],
      widget: Theme(
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
        child: ExpansionTile(
            iconColor: Colors.white,
            tilePadding: EdgeInsets.only(right: 10),
            expandedAlignment: Alignment.centerLeft,
            childrenPadding: EdgeInsets.only(left: 20, bottom: 17, right: 10),
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 9, left: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFont(
                    text: title,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                  TextFont(
                    text: time,
                    fontSize: 16,
                  )
                ],
              ),
            ),
            children: [
              TextFont(
                text: description,
                fontSize: 15,
              ),
            ]),
      ),
    );
  }
}
