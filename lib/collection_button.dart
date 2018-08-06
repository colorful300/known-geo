import 'package:flutter/material.dart';

class CollectionButtonState extends State < CollectionButton > {
  bool _isSaved = false;
  Widget build(BuildContext context) {
    return new IconButton(
      icon: _isSaved ? new Icon(Icons.star) : new Icon(Icons.star_border),  
      onPressed: (){},
    );
  }
}

class CollectionButton extends StatefulWidget {
  @override
  createState() => new CollectionButtonState();
}