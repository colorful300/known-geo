import 'package:flutter/material.dart';
import 'setting.dart';

class _CollectionButtonState extends State<CollectionButton> {
  final Map data;

  Widget build(BuildContext context) {
    bool isSaved = Setting.collections.containsKey(data['guid']);
    return new IconButton(
      icon: isSaved ? new Icon(Icons.star) : new Icon(Icons.star_border),
      color: Colors.yellow,
      onPressed: () {
        isSaved = !isSaved;
        if (isSaved) {
          Setting.collections[data['guid']] = data;
        } else {
          Setting.collections.remove(data['guid']);
        }
        Setting.saveCollections();
        setState(() {});
      },
    );
  }

  _CollectionButtonState(this.data);
}

class CollectionButton extends StatefulWidget {
  final Map data;

  @override
  createState() => new _CollectionButtonState(data);
  CollectionButton(this.data);
}
