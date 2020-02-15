import 'package:fgj_2020/basic_button.dart';
import 'package:flutter/material.dart';

class PauseScreen extends StatelessWidget {
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
              "Paused",
              style: TextStyle(
                color: Colors.white,
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
                  Navigator.of(context).pop();
                },
                text: "RESUME",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}