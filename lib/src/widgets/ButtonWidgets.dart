import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/TextWidgets.dart';

class ButtonRegular extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outline;
  final bool yellow;
  final double? customWidth;

  const ButtonRegular({
    Key? key,
    required this.text,
    required this.onPressed,
    this.outline = false,
    this.yellow = false,
    this.customWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.outline) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: customWidth ?? MediaQuery.of(context).size.width,
          child: Container(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  side: BorderSide(
                      color: yellow
                          ? Theme.of(context).colorScheme.yellowAccent
                          : Theme.of(context)
                              .colorScheme
                              .lightLightPurpleAccent,
                      width: 3),
                  padding: EdgeInsets.all(18)),
              onPressed: onPressed,
              child: TextFont(
                text: text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: customWidth ?? MediaQuery.of(context).size.width,
          child: Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(yellow
                    ? Theme.of(context).colorScheme.yellowAccent
                    : Theme.of(context).colorScheme.lightPurpleAccent),
                padding: MaterialStateProperty.all(EdgeInsets.all(18)),
              ),
              onPressed: onPressed,
              child: TextFont(
                text: text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class DropDownButton extends StatefulWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String>? onChanged;
  const DropDownButton(
      {required this.title,
      required this.items,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  State<DropDownButton> createState() => DropDownButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DropDownButtonState extends State<DropDownButton> {
  String? selectedItem;
  @override
  void initState() {
    super.initState();
    selectedItem = widget.items[0];
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(
            text: widget.title,
            fontSize: 15,
          ),
          Container(height: 5),
          Container(
            width: 1000,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.lightDarkAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11, vertical: 17),
              child: DropdownButton(
                isExpanded: true,
                underline: Container(),
                isDense: true,
                value: selectedItem,
                dropdownColor: Theme.of(context).colorScheme.lightDarkAccent,
                focusColor: Theme.of(context).colorScheme.lightPurpleAccent,
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: TextFont(
                      key: ValueKey<String>(value),
                      text: value,
                      fontSize: 18,
                      textColor: Theme.of(context).colorScheme.black,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) widget.onChanged!(newValue);
                  setState(() {
                    selectedItem = newValue;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
