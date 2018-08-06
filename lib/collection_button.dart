import 'package:flutter/material.dart';

class _CollectionButtonState extends State<CollectionButton> {
  bool isSaved = false;
  Widget build(BuildContext context) {
    return new IconButton(
      icon: isSaved ? new Icon(Icons.star) : new Icon(Icons.star_border),
      onPressed: () {},
    );
  }
}

class CollectionButton extends StatefulWidget {
  @override
  createState() => new _CollectionButtonState();
}
