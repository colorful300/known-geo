import 'package:flutter/material.dart';
import 'file_permission.dart';
import 'file_downloader.dart';

class FloatDownloadButton extends StatefulWidget {
  final Map<String, dynamic> document;
  final FileDownloader saver;

  FloatDownloadButton(this.document, this.saver);

  @override
  State<StatefulWidget> createState() =>
      new _FloatDownloadButtonState(document, saver);
}

class _FloatDownloadButtonState extends State<FloatDownloadButton> {
  bool iconDownload = true;
  bool iconDownloading = false;
  bool iconDownloaded = false;
  bool iconDownloadFail = false;
  final Map<String, dynamic> document;
  final FileDownloader saver;
  static final RegExp imageResolusion = new RegExp(r'(\d+?)×(\d+)');
  static final RegExp badChar = new RegExp(r'[\\/\:\*\?"<>\|]');

  _FloatDownloadButtonState(this.document, this.saver);

  @override
  void initState() {
    saver.onDownloadComplete = () async {
      if (saver.error != null) {
        iconDownloadFail = true;
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(new SnackBar(
            content: new Text(saver.error),
          ));
      } else {
        iconDownloaded = true;
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(new SnackBar(
            content: new Text('已经下载到' + await saver.getFullPath()),
          ));
      }
      setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (iconDownloadFail) {
      return new FloatingActionButton(
        child: Icon(Icons.not_interested),
        onPressed: () async {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(new SnackBar(
              content: new Text(saver.error),
            ));
        },
      );
    }
    if (iconDownloaded) {
      return new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () async {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(new SnackBar(
              content: new Text('已经下载到' + await saver.getFullPath()),
            ));
        },
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
              saver.download(document['datalink'] + 'x_y', valid);
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
}
