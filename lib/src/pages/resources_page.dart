import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:frosh_week_2t1/src/widgets/Containers.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/ContainersExtensions.dart";
import '../colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Resource {
  Resource({
    required this.title,
    required this.contact,
    required this.description,
    required this.type, //email, phone, website
  });
  String title;
  String contact;
  String description;
  String type;
}

class ResourcesPageParse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResourcesPage(resources: [
      Resource(
          title: "Campus Police",
          contact: "647-123-4567",
          type: "phone",
          description: "call campus police today!"),
      Resource(
          title: "Aidan",
          contact: "scratchanimations123@gmail.com",
          type: "email",
          description: "don't email me!"),
      Resource(
          title: "Url",
          contact: "http://www.google.ca",
          type: "url",
          description: "click me"),
    ]);
  }
}

class ResourcesPage extends StatelessWidget {
  final List<Resource> resources;

  const ResourcesPage({
    Key? key,
    required this.resources,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        MainHeader(
          text: 'Resources',
          textSmaller: "",
          icon: false,
        ),
        resources.length == 0
            ? Center(
                child: Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 70),
                child: TextFont(text: "There are no resources"),
              ))
            : Container()
      ])),
      SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => ResourceBox(resource: resources[index]),
            childCount: resources.length),
      )
    ]));
  }
}

class ResourceBox extends StatelessWidget {
  final Resource resource;

  const ResourceBox({
    Key? key,
    required this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchContact(resource);
      },
      child: Box(
          widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFont(
              text: resource.title,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
            Container(height: 7),
            TextFont(
              text: resource.contact,
              fontSize: 20,
              customTextColor: true,
              textColor: Theme.of(context).colorScheme.purpleText,
            ),
            Container(height: 2),
            TextFont(
              text: resource.description,
              fontSize: 17,
            ),
          ],
        ),
      )),
    );
  }
}

launchContact(Resource resource) async {
  String url = "";
  if (resource.type == "email") {
    url = "mailto::" + resource.contact;
  } else if (resource.type == "url") {
    url = resource.contact;
  } else if (resource.type == "phone") {
    url = "tel://" + resource.contact;
  } else {
    return;
  }
  if (await canLaunch(url)) await launch(url);
}
