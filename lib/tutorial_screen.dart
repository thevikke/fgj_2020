import 'package:fgj_2020/basic_button.dart';
import 'package:fgj_2020/repair_wall.dart';
import 'package:fgj_2020/reveal_animation.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _tutorialIndex = 0;
  List<String> _tutorialStrings = [
    "On the left there is draggable items",
    "The wall has a picture of the item that it needs",
    "Drag the item from the right to the wall",
    "When enemies hit the wall it loses health, gain health by repairing it!"
  ];
  List<Image> _tutorialImages = [
    Image.asset("assets/TutorialImage1.png"),
    Image.asset("assets/TutorialImage2.png"),
    Image.asset("assets/TutorialImage3.png"),
    Image.asset("assets/TutorialImage4.png"),
  ];
  @override
  void didChangeDependencies() {
    precacheImage(_tutorialImages[0].image, context);
    precacheImage(_tutorialImages[1].image, context);
    precacheImage(_tutorialImages[2].image, context);
    precacheImage(_tutorialImages[3].image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.orangeAccent,
        width: _size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "TUTORIAL",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontFamily: "Frijole",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _tutorialStrings[_tutorialIndex],
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22,
                  fontFamily: "Frijole",
                ),
              ),
            ),
            _tutorialImages[_tutorialIndex],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: _size.width / 2.2,
                  height: 50,
                  child: _tutorialIndex > 0
                      ? BasicButton(
                          () {
                            setState(() {
                              _tutorialIndex -= 1;
                            });
                          },
                          textColor: Colors.blue,
                          color: Colors.white,
                          text: "BACK",
                        )
                      : BasicButton(
                          () {
                            Navigator.of(context).pushReplacement(
                              RevealRoute(
                                  builder: (context) => RepairWallGame(),
                                  transitionColor: Colors.blue),
                            );
                          },
                          textColor: Colors.blue,
                          color: Colors.white,
                          text: "SKIP",
                        ),
                ),
                SizedBox(
                  width: _size.width / 2.2,
                  height: 50,
                  child: _tutorialIndex == 3
                      ? BasicButton(
                          () {
                            Navigator.of(context).pushReplacement(
                              RevealRoute(
                                  builder: (context) => RepairWallGame(),
                                  transitionColor: Colors.blue),
                            );
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          text: "PLAY",
                        )
                      : BasicButton(
                          () {
                            setState(() {
                              _tutorialIndex += 1;
                            });
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          text: "NEXT -->",
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
