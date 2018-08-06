import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  final Text text;

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return new CircularProgressIndicator();
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[new CircularProgressIndicator(), text],
    );
  }

  CircleProgress({this.text});
}

class TextedIcon extends StatelessWidget {
  final Text text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return new Icon(iconData);
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[new Icon(iconData), text],
    );
  }

  TextedIcon(this.iconData, {this.text});
}