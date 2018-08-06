import 'package:flutter/material.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';

class PageImage extends StatefulWidget {
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageImageState(document);
  PageImage(this.document);
}

class _PageImageState extends State<StatefulWidget> {
  Map document;
  FileDownloader downloader = new FileDownloader();
  Widget image;

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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(document['title']),
      ),
      body: new Center(child: child()),
    );
  }

  _PageImageState(this.document);
}
