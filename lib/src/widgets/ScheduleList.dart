import 'package:flutter/material.dart';
import "./ContainersExtensions.dart";
import './TextWidgets.dart';

class Event {
  Event(
      {required this.title,
      required this.time,
      required this.room,
      this.description = "",
      this.froshGroup = ""});
  String title;
  String time;
  String room;
  String description;
  String froshGroup;
}

class Day {
  Day({
    required this.events,
    required this.day,
    this.isExpanded = false,
  });

  List<Event> events;
  String day;
  bool isExpanded;
}

List<Day> getDays() {
  var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  return List<Day>.generate(days.length, (int i) {
    return Day(
      day: days[i],
      events: [
        Event(title: "title", time: "time", room: "room", description: "")
      ],
    );
  });
}

/// This is the stateful widget that the main application instantiates.
class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => ScheduleListState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ScheduleListState extends State<ScheduleList> {
  final List<Day> days = getDays();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        for (var i = 0; i < days.length; i++) {
          days[i].isExpanded = false;
        }
        setState(() {
          days[index].isExpanded = !isExpanded;
        });
      },
      children: days.map<ExpansionPanel>((Day day) {
        return ExpansionPanel(
            isExpanded: day.isExpanded,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return GestureDetector(
                onTap: () {
                  for (var i = 0; i < days.length; i++) {
                    days[i].isExpanded = false;
                  }
                  setState(() {
                    day.isExpanded = !day.isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 16, top: 16, bottom: 16),
                  child: TextFont(
                    text: day.day,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            body: Column(children: [
              for (var event in day.events)
                ContainerEvent(
                    title: event.title,
                    time: event.time,
                    room: event.room,
                    description: event.description)
            ]));
      }).toList(),
    );
  }
}
