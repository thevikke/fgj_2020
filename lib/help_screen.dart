import 'package:fgj_2020/basic_button.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  void didChangeDependencies() {
    precacheImage(AssetImage("assets/Ohje.png"), context);
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
          children: <Widget>[
            Text(
              "TUTORIAL",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontFamily: "Frijole",
              ),
            ),
            Image.asset("assets/Ohje.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: _size.width / 2.2,
                  height: 50,
                  child: BasicButton(
                    () {},
                    textColor: Colors.blue,
                    color: Colors.white70,
                    text: "SKIP",
                  ),
                ),
                SizedBox(
                  width: _size.width / 2.2,
                  height: 50,
                  child: BasicButton(
                    () {},
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
