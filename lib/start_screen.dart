import 'dart:math';

import 'package:fgj_2020/basic_button.dart';
import 'package:fgj_2020/hiscores_screen.dart';
import 'package:fgj_2020/info_screen.dart';
import 'package:fgj_2020/tutorial_screen.dart';
import 'package:fgj_2020/repair_wall.dart';
import 'package:fgj_2020/reveal_animation.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:nima/nima_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This is the start screen
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chrome_reader_mode,
          ),
          iconSize: 40,
          onPressed: () {
            Navigator.of(context).push(
              RevealRoute(
                  builder: (context) => TutorialScreen(),
                  transitionColor: Colors.blue),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
            ),
            iconSize: 40,
            onPressed: () {
              Navigator.of(context).push(
                RevealRoute(
                    builder: (context) => InfoScreen(),
                    transitionColor: Colors.blue),
              );
            },
          )
        ],
      ),
      body: Container(
        width: _size.width,
        color: Colors.orangeAccent,
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
                if (!(prefs.getBool("tutorialDone") ?? false)) {
                  prefs.setBool("tutorialDone", true);
                  Navigator.push(
                    context,
                    RevealRoute(
                        builder: (context) => TutorialScreen(),
                        transitionColor: Colors.blue),
                  );
                } else {
                  Navigator.push(
                    context,
                    RevealRoute(
                        builder: (context) => RepairWallGame(),
                        transitionColor: Colors.blue),
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
              () {
                Navigator.push(
                  context,
                  RevealRoute(
                      builder: (context) => Hiscores(),
                      transitionColor: Colors.blue),
                );
              },
              text: "HISCORE",
              color: Colors.white,
              textColor: Colors.blue,
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
        child: NimaActor(
          "assets/Hulk.nima",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Walk",
          clip: false,
        ),
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
