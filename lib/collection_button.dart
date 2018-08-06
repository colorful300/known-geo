import 'package:flutter/material.dart';

class _CollectionButtonState extends State < CollectionButton > {
  bool _isSaved;
  final bool isPage;
  final Set container;
  final element;

  Widget build(BuildContext context) {
    _isSaved = container.contains(element);
    return !isPage ? new IconButton(
      icon: _isSaved ? new Icon(Icons.star) : new Icon(Icons.star_border),
      color: Colors.red,
      onPressed: () {
        _isSaved = !_isSaved;
        if (_isSaved) {
          container.add(element);
        } else {
          container.remove(element);
        }
        setState(() {});
      },
    ) : new IconButton(
      icon: new Icon(Icons.list),
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              final tiles = container.map((collections) {
                return ListTile(
                  title: new Text(collections.string),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) {
                          return collections.build(context);
                        }
                      )
                    );
                  },
                );
              });
              final divided = ListTile.divideTiles(context: context, tiles: tiles, ).toList();
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text('我的收藏'),
                ),
                body: new ListView(
                  children: divided,
                ),
              );
            }
          ),
        );
      },
    );
  }

  _CollectionButtonState({
    this.isPage,
    this.container,
    this.element,
  });
}

class CollectionButton extends StatefulWidget {
  final bool isPage;
  final Set container;
  final element;

  @override
  createState() => new _CollectionButtonState(isPage: isPage, container: container, element: element,);
  CollectionButton({
    this.isPage,
    this.container,
    this.element,
  });
}