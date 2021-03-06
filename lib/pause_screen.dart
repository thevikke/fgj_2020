import 'package:fgj_2020/basic_button.dart';
import 'package:flutter/material.dart';

class PauseScreen extends StatelessWidget {
  final Function restartGame;
  PauseScreen(this.restartGame);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: _size.width,
        color: Colors.orangeAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "REPAIR WALL",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
                fontFamily: "Frijole",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "PAUSED",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontFamily: "Frijole",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: _size.width / 2,
              height: 50,
              child: BasicButton(
                () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                textColor: Colors.blue,
                color: Colors.white,
                text: "QUIT",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: _size.width / 2,
              height: 50,
              child: BasicButton(
                () async {
                  Navigator.of(context).pop();
                  // Wait 500 milliseconds before starting the game again so that the player has time to chill
                  await Future.delayed(
                    const Duration(milliseconds: 500),
                    () {},
                  );
                  restartGame();
                },
                text: "RESUME",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
