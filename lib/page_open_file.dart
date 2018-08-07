import 'package:flutter/material.dart';
import 'collection_button.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';
import 'setting.dart';

class PageOpenFile extends StatefulWidget {
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageOpenFileState(document);
  PageOpenFile(this.document);
}

class _PageOpenFileState extends State<StatefulWidget> {
  static final RegExp imageResolusion = new RegExp(r'(\d+?)×(\d+)');
  final Map document;
  FileDownloader downloader = new FileDownloader()..cd('cache')..cd('images');
  Widget loaded;
  String string;
  String error;


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
    super.dispose();
  }

  @override
  void initState() {
    downloader.onDownloadComplete = () async {
      if (downloader.error != null) {
        error = downloader.error;
      } else {
        File file =
            new File((await downloader.getFullPath()) + document['guid']);
        if (!Setting.downloads.contains(document['guid'])) {
          Setting.downloads.add(document['guid']);
          Setting.saveDownloads();
        }
        if (document['format'] == 'jpg') {
          try {
            loaded = Image.file(file);
          } catch (e) {
            error = e;
          }
        } else {
          loaded = new TextedIcon(Icons.broken_image,text: new Text('没有预览'));
        }
      }
      setState(() {});
    };
    if (document['format'] == 'jpg') {
      Match match = imageResolusion.firstMatch(document['pages']);
      if (match == null) {
        error = '服务器资源错误';
      } else {
        downloader.download(
            document['datalink'] + match.group(1) + '_' + match.group(2),
            document['guid']);
      }
    } else {
      downloader.download(document['datalink'], document['guid']);
    }
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
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.file_download),
        onPressed: (){},
      ),
    );
  }
}
