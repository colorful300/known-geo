import 'package:flutter/material.dart';
import 'file_service.dart';
import 'texted_widget.dart';
import 'collection_button.dart';
import 'page_image.dart';

class PageFileService extends StatefulWidget {
  final FileServiceItem item;
  @override
  State<StatefulWidget> createState() => new _PageFileServiceState(item);
  PageFileService(this.item);
}

class _PageFileServiceState extends State<PageFileService> {
  FileServiceItem item;
  FileService fileService = new FileService();

  @override
  void dispose() {
    fileService.onLoadComplete = null;
    super.dispose();
  }

  Widget body() {
    if (!fileService.hasLoad) {
      fileService.onLoadComplete = (service) {
        setState(() {});
      };
      fileService.loadService(item.url);
      return new Center(child: new CircleProgress(text: new Text('资料查询中')));
    }
    return new ListView.builder(
      itemCount: fileService.fileList.length,
      itemBuilder: (context, index) {
        return new ListTile(
          leading: new Icon(Icons.assessment),
          title: new Text(fileService.fileList[index]['title']),
          subtitle: new Text('文件类型: ' + fileService.fileList[index]['format']),
          onTap: () {
            if (fileService.fileList[index]['format'] == 'jpg') {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new PageImage(fileService.fileList[index]);
              }));
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text(item.title),
          actions: <Widget>[new CollectionButton()],
        ),
        body: body());
  }

  _PageFileServiceState(this.item);
}
