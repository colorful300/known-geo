import 'package:flutter/material.dart';
import 'collection_button.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';
import 'setting.dart';
import 'drawer_data_detail.dart';
import 'float_download_button.dart';

class PageOpenFile extends StatefulWidget {
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageOpenFileState(document);
  PageOpenFile(this.document);
}

class _PageOpenFileState extends State<StatefulWidget>
    with TickerProviderStateMixin {
  final Map document;
  FileDownloader downloader = new FileDownloader()..cd('cache')..cd('images');
  final FileDownloader saver = new FileDownloader()
    ..switchToExternalStorage()
    ..cd('Download')
    ..cd('known_geo_downloads');
  Widget loaded;
  String error;
  bool waitForSave = false;
  File file;

  _PageOpenFileState(this.document);

  Widget child() {
    if (error != null) {
      return new TextedIcon(Icons.cancel, text: new Text(error));
    }
    if (loaded != null) {
      return loaded;
    }
    return new CircleProgress(text: new Text('文件加载中'));
  }

  @override
  void dispose() {
    downloader.onDownloadComplete = null;
    saver.onDownloadComplete = null;
    super.dispose();
  }

  @override
  void initState() {
    downloader.onDownloadComplete = () async {
      if (downloader.error != null) {
        error = downloader.error;
      } else {
        file = new File((await downloader.getFullPath()) + document['guid']);
        if (!Setting.downloads.contains(document['guid'])) {
          Setting.downloads.add(document['guid']);
          Setting.saveDownloads();
        }
        try {
          loaded = Image.file(file);
        } catch (e) {
          error = e;
        }
      }
      setState(() {});
    };
    if (document['format'] == 'jpg') {
      downloader.download(document['datalink'] + '512_512', document['guid']);
    } else {
      loaded = new TextedIcon(Icons.broken_image, text: new Text('没有预览'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(document['title']),
        actions: <Widget>[new CollectionButton(document)],
      ),
      body: new Center(child: child()),
      drawer: new DrawerDataDetail(document),
      floatingActionButton: new FloatDownloadButton(document, saver),
    );
  }
}
