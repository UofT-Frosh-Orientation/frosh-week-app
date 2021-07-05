import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final String froshName;

  const HomePage({
    Key? key,
    required this.froshName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            title: Text('Welcome to F!rosh week, $froshName'),
          )
        ],
      )
    );
  }
}
