import 'package:flutter/material.dart';
import 'collection_button.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';
import 'setting.dart';

class PageImage extends StatefulWidget {
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageImageState(document);
  PageImage(this.document);
}

class _PageImageState extends State<StatefulWidget> {
  final Map document;
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
      File file = new File((await downloader.getFullPath()) + document['guid']);
      if (!Setting.downloads.contains(document['guid'])) {
        Setting.downloads.add(document['guid']);
        Setting.saveDownloads();
      }
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
      ..download(
          document['datalink'] +
              Setting.settings['resolusionX'].toString() +
              '_' +
              Setting.settings['resolusionY'].toString(),
          document['guid']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    string = document['title'];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(document['title']),
        actions: <Widget>[new CollectionButton(document)],
      ),
      body: new Center(child: child()),
    );
  }

  _PageImageState(this.document);
}
