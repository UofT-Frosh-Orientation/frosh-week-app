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
    this.icon,
  });
  String title;
  String contact;
  String description;
  String type;
  IconData? icon;
}

class ResourcesPageParse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResourcesPage(resources: [
      Resource(
          icon: Icons.language,
          title: "Orientation website",
          contact: "https://www.orientation.skule.ca/",
          type: "url",
          description:
              "The F!rosh orientation website. Login to your account here and view full account data."),
      Resource(
          icon: Icons.location_on,
          title: "UofT Map",
          contact: "https://www.utoronto.ca/__shared/assets/3D_Map1103.pdf",
          type: "url",
          description:
              "Don't know the building codes or where buildings are located? View this map!"),
      Resource(
          icon: Icons.file_copy,
          title: "Incident Report Form",
          contact: "https://www.orientation.skule.ca/",
          type: "url",
          description:
              "Report any incidents you experience during F!rosh week here."),
      Resource(
          icon: Icons.badge,
          title: "Campus Police",
          contact: "416-978-2323",
          type: "phone",
          description:
              "For non-urgent reports. UofT campus police phone number."),
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
      ),
      SliverList(
          delegate: SliverChildListDelegate([
        Container(height: 100),
      ])),
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
            Row(
              children: [
                Expanded(
                  child: TextFont(
                    text: resource.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                  ),
                ),
                resource.icon != null
                    ? Row(children: [
                        Icon(
                          resource.icon,
                          size: 38,
                        ),
                        Container(width: 8)
                      ])
                    : Container(),
              ],
            ),
            Container(height: 4),
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
