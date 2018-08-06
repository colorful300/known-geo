import 'package:flutter/material.dart';
import 'file_service.dart';
import 'texted_widget.dart';
import 'collection_button.dart';
import 'page_image.dart';

class PageFileService extends StatefulWidget {
  final Set collectionMap;
  final FileServiceItem item;
  bool storeCollection = true;
  @override
  State < StatefulWidget > createState() => new _PageFileServiceState(item, collectionMap);
  PageFileService(this.item, this.collectionMap);
}

class _PageFileServiceState extends State < PageFileService > {
  final Set collectionMap;
  FileServiceItem item;
  String string;
  FileService fileService = new FileService();
  bool storeCollection = false;

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
                return new PageImage(fileService.fileList[index], collectionMap);
              }));
            }
          },
        );
      },
    );
  }

  bool setStoreCollection() {
    storeCollection = !storeCollection;
    return !storeCollection;
  }

  @override
  Widget build(BuildContext context) {
    string = item.title;
    return new Scaffold(
      appBar: AppBar(
        title: new Text(item.title),
        actions: < Widget > [
          new CollectionButton(
            isPage: false,
            isSaved: setStoreCollection(),
            container: collectionMap,
            element: this,
          )
        ],
      ),
      body: body()
    );
  }

  _PageFileServiceState(this.item, this.collectionMap);
}