import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text("Animations info:"),
              title: Text(
                "Sun, green man, business man and person, licensed under CC BY 4.0 https://creativecommons.org/licenses/by/4.0/",
              ),
              subtitle: Text("from www.rive.app"),
            ),
            ListTile(
              leading: Text("Other images info:"),
              title: Text(
                "For free, no license",
              ),
              subtitle: Text(
                  "from: https://opengameart.org/content/free-desert-platformer-tileset"),
            ),
            ListTile(
              leading: Text("Music info:"),
              title: Text(
                "Music Infiltrators by Nathaniel Wyvern, licensed under CC BY",
              ),
              subtitle: Text(
                  "from: https://freemusicarchive.org/music/Nathaniel_Wyvern/2019_releases_collection/Nathaniel_Wyvern_-_Infiltrators"),
            ),
            ListTile(
              leading: Text("Game:"),
              title: Text(
                "Game create by Kristian Tuusjärvi, in Game Jam 2020",
              ),
              subtitle: Text("from: ktcoding.com"),
            ),
          ],
        ),
      ),
    );
  }
}
