import 'package:flutter/material.dart';
import 'collection_button.dart';
import 'file_downloader.dart';
import 'texted_widget.dart';
import 'dart:io';
import 'setting.dart';
import 'file_permission.dart';
import 'drawer_data_detail.dart';

class PageOpenFile extends StatefulWidget {
  final Map document;
  @override
  State<StatefulWidget> createState() => new _PageOpenFileState(document);
  PageOpenFile(this.document);
}

class _PageOpenFileState extends State<StatefulWidget>
    with TickerProviderStateMixin {
  static final RegExp imageResolusion = new RegExp(r'(\d+?)×(\d+)');
  final Map document;
  FileDownloader downloader = new FileDownloader()..cd('cache')..cd('images');
  FileDownloader saver = new FileDownloader()
    ..switchToExternalStorage()
    ..cd('Download')
    ..cd('known_geo_downloads');
  Widget loaded;
  String string;
  String error;
  bool waitForSave = false;
  RegExp badChar = new RegExp(r'[\\/\:\*\?"<>\|]');
  File file;
  bool iconDownload = true;
  bool iconDownloading = false;
  bool iconDownloaded = false;
  bool iconDownloadFail = false;

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
    saver.onDownloadComplete = () {
      if (saver.error != null) {
        iconDownloadFail = true;
      } else {
        iconDownloaded = true;
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

  Widget floating() {
    if (iconDownloadFail) {
      return new FloatingActionButton(
        child: Icon(Icons.not_interested),
        onPressed: () {},
      );
    }
    if (iconDownloaded) {
      return new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () {},
      );
    }
    if (iconDownloading) {
      return new FloatingActionButton(
        child: new CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        onPressed: () {},
      );
    }
    return new FloatingActionButton(
      child: new Icon(Icons.file_download),
      onPressed: () async {
        if (await FilePermission.request()) {
          setState(() {
            iconDownloading = true;
          });
          String valid = (document['title'] + '.' + document['format'])
              .replaceAll(badChar, '');
          valid = valid.length > 255 ? valid.substring(0, 254) : valid;
          if (document['format'] == 'jpg') {
            Match match = imageResolusion.firstMatch(document['pages']);
            if (match == null) {
              saver.download(document['datalink'] + '2560_2560', valid);
            } else {
              saver.download(
                  document['datalink'] + match.group(1) + '_' + match.group(2),
                  valid);
            }
          } else if (document['format'] == 'pdf') {
            saver.download(document['datalink'], valid);
          } else {
            saver.download(document['datalink'], valid);
          }
        } else {
          setState(() {
            iconDownloadFail = true;
          });
        }
      },
    );
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
      drawer: new DrawerDataDetail(document),
      floatingActionButton: floating(),
    );
  }
}
