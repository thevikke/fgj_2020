import 'dart:math';

import 'package:fgj_2020/basic_button.dart';
import 'package:fgj_2020/help_screen.dart';
import 'package:fgj_2020/repair_wall.dart';
import 'package:fgj_2020/reveal_animation.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:nima/nima_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key key}) : super(key: key);

  final Image imageStoneWallBlock = Image.asset(
    "assets/StoneBlock.png",
    color: Colors.brown,
    colorBlendMode: BlendMode.softLight,
  );
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      color: Colors.orangeAccent,
      child: Padding(
        padding: EdgeInsets.only(top: _size.height / 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(children: [
              CircularText(
                children: [
                  TextItem(
                    text: Text(
                      "REPAIR WALL",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                        fontFamily: "Frijole",
                      ),
                    ),
                    space: 20,
                    startAngle: -90,
                    startAngleAlignment: StartAngleAlignment.center,
                    direction: CircularTextDirection.clockwise,
                  ),
                ],
                radius: 150,
                position: CircularTextPosition.inside,
                backgroundPaint: Paint()..color = Colors.orangeAccent,
              ),
              ..._buildWall(_size.width),
              ..._buildCharacters(_size.width)
            ]),
            ..._buildButtons(_size, context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons(Size size, BuildContext context) {
    return [
      Column(
        children: <Widget>[
          SizedBox(
            width: size.width / 2,
            height: 50,
            child: BasicButton(
              () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // Check if tutorial has been shown
                prefs.clear();
                if (!(prefs.getBool("tutorialDone") ?? false)) {
                  prefs.setBool("tutorialDone", true);
                  Navigator.push(
                    context,
                    RevealRoute(
                        builder: (context) => TutorialScreen(),
                        transitionColor: Colors.orangeAccent),
                  );
                } else {
                  Navigator.push(
                    context,
                    RevealRoute(
                        builder: (context) => RepairWallGame(),
                        transitionColor: Colors.orangeAccent),
                  );
                }
              },
              text: "START",
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          SizedBox(
            width: size.width / 2,
            height: 50,
            child: BasicButton(
              () {},
              text: "HISCORE",
            ),
          )
        ],
      )
    ];
  }

  List<Widget> _buildCharacters(double width) {
    return [
      Positioned(
        width: 150,
        height: 150,
        bottom: 0,
        child: const FlareActor("assets/walking.flr",
            alignment: Alignment.bottomLeft,
            fit: BoxFit.contain,
            animation: "walking"),
      ),
      Positioned(
        bottom: 0,
        left: width / 3,
        width: 150,
        height: 150,
        child: const NimaActor("assets/Hulk.nima",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "Walk"),
      ),
    ];
  }

  List<Widget> _buildWall(double width) {
    return [
      Positioned(
        bottom: 0,
        width: width / 1.65,
        height: 70,
        child: imageStoneWallBlock,
      ),
      Positioned(
        bottom: 70,
        width: width / 1.65,
        height: 70,
        child: imageStoneWallBlock,
      ),
      Positioned(
        bottom: 140,
        width: width / 1.65,
        height: 70,
        child: imageStoneWallBlock,
      ),
    ];
  }
}
