import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  Function onPressed;
  final String text;
  final Color color;
  final Color textColor;
  BasicButton(
    this.onPressed, {
    this.text = " ",
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 22,
          fontFamily: "Frijole",
        ),
      ),
      color: color,
      onPressed: onPressed,
    );
  }
}
