import 'package:flutter/material.dart';

class _CollectionButtonState extends State<CollectionButton> {
  final Map<String, Map> collections;
  final Map data;

  Widget build(BuildContext context) {
    bool isSaved = collections.containsKey(data['guid']);
    return new IconButton(
      icon: isSaved ? new Icon(Icons.star) : new Icon(Icons.star_border),
      color: Colors.yellow,
      onPressed: () {
        isSaved = !isSaved;
        if (isSaved) {
          collections[data['guid']] = data;
        } else {
          collections.remove(data['guid']);
        }
        setState(() {});
      },
    );
  }

  _CollectionButtonState(this.collections, this.data);
}

class CollectionButton extends StatefulWidget {
  final Map<String, Map> collections;
  final Map data;

  @override
  createState() => new _CollectionButtonState(collections, data);
  CollectionButton(this.collections, this.data);
}
