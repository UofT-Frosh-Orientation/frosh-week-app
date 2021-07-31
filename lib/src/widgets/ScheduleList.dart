import 'package:flutter/material.dart';
import "./ContainersExtensions.dart";
import './TextWidgets.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
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
  final List<Item> data = generateItems(8);

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
        for (var i = 0; i < data.length; i++) {
          data[i].isExpanded = false;
        }
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return GestureDetector(
              onTap: () {
                for (var i = 0; i < data.length; i++) {
                  data[i].isExpanded = false;
                }
                setState(() {
                  item.isExpanded = !item.isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 16, top: 16, bottom: 16),
                child: TextFont(
                  text: "Lunch Time",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  data.removeWhere((Item currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
