import 'package:flutter/material.dart';
import 'collection_button.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';

class PageImage extends StatefulWidget {
  final Set collectionMap;
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageImageState(document, collectionMap);
  PageImage(this.document, this.collectionMap);
}

class _PageImageState extends State<StatefulWidget> {
  Map document;
  final Set collectionMap;
  FileDownloader downloader = new FileDownloader();
  Widget image;
  String string;

  Widget child() {
    if (image != null) {
      return image;
    }
    return new CircleProgress(text: new Text('图片加载中'));
  }

  @override
  void dispose() {
    downloader.onDownloadComplete = null;
    super.dispose();
  }

  @override
  void initState() {
    downloader.onDownloadComplete = () async {
      print('download success');
      File file = new File((await downloader.getFullPath()) + document['guid']);
      if (file.lengthSync() < 32) {
        image = new TextedIcon(Icons.cancel, text: new Text('未在服务器上找到图片！'));
      } else {
        image = Image.file(file);
      }
      setState(() {});
    };
    downloader
      ..cd('cache')
      ..cd('images')
      ..download(document['datalink'] + '1920_1080', document['guid']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    string = document['title'];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(document['title']),
        actions: <Widget>[
          new CollectionButton(
            isPage: false,
            container: collectionMap,
            element: this,
          )
        ],
      ),
      body: new Center(child: child()),
    );
  }

  _PageImageState(this.document, this.collectionMap);
}
