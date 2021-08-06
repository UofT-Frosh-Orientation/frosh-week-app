import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
                  textSmaller: "",
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
              for (var dayIndex in data.keys)
                ScheduleList(data: data, dayIndex: dayIndex)
            ],
          ),
        ),
      ),
    );
  }
}

const scheduleColor = {
  "blue": ["break"],
  "green": ["lunch", "dinner"],
  "purple": ["group"],
  "yellow": ["matriculation", "games", "campus tour", "downtown walkaround"],
  "orange": ["faculty events", "class"]
};

const colorToGradient = {
  "blue": [Color(0x8C647CE6), Color(0x946593F5), Color(0x936960EE)],
  "green": [Color(0x8E2EA0A8), Color(0x8E61AC2F), Color(0x8E42D455)],
  "purple": [Color(0x8E6D2EA8), Color(0x8E8F2FAC), Color(0x8E5D42D4)],
  "yellow": [Color(0x93FFAF47), Color(0x96FDE938), Color(0x8EF1CE32)],
  "orange": [Color(0x93FF9147), Color(0x96FD6638), Color(0x8EF1AE32)],
};

determineEventColor(String eventTitle) {
  String colorOut = "purple";
  for (var color in scheduleColor.keys) {
    var scheduleColorNonNull = scheduleColor[color] ?? [];
    for (var keyword in scheduleColorNonNull) {
      if (eventTitle.toLowerCase().contains(keyword)) {
        colorOut = color;
        break;
      }
    }
  }
  return (colorToGradient[colorOut] ?? [Colors.blue]).cast<Color>();
}

class ScheduleList extends StatefulWidget {
  final dynamic data;
  final String dayIndex;
  const ScheduleList({Key? key, required this.data, required this.dayIndex})
      : super(key: key);

  @override
  State<ScheduleList> createState() => ScheduleListState();
}

class ScheduleListState extends State<ScheduleList> {
  int activeIndex = -1;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 10, bottom: 100),
        itemCount: widget.data[widget.dayIndex].length,
        itemBuilder: (BuildContext context, int index) {
          return Box(
            outerMargin: 0.8,
            borderRadius: 7,
            outerPadding: 0,
            fancy: true,
            lightShadow: true,
            colors: determineEventColor(
                widget.data[widget.dayIndex][index]["title"]),
            widget: ExpansionPanelList(
              elevation: 0,
              dividerColor: Colors.black.withOpacity(0),
              expandedHeaderPadding: EdgeInsets.only(top: 10, bottom: 5),
              expansionCallback: (int indexExpansion, bool status) {
                setState(() {
                  activeIndex = activeIndex == index ? -1 : index;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.black.withOpacity(0),
                  canTapOnHeader: true,
                  isExpanded: activeIndex == index,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 13, bottom: 10, left: 23, right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: widget.data[widget.dayIndex][index]["title"],
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                          TextFont(
                            text: widget.data[widget.dayIndex][index]
                                    ["startTime"] +
                                " - " +
                                widget.data[widget.dayIndex][index]["endTime"],
                            fontSize: 16,
                          )
                        ],
                      ),
                    );
                  },
                  body: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeIndex = -1;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 23, bottom: 17, right: 10),
                        child: TextFont(
                          text: widget.data[widget.dayIndex][index]
                              ["description"],
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
