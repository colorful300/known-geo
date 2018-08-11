import 'package:flutter/material.dart';
//import 'package:flutter/animation.dart';
import 'page_search.dart';
import 'setting.dart';
import 'file_service.dart';

void initGlobals() {
  FileService.init();
  Setting.load();
  Setting.loadCollections();
  Setting.loadDownloads();
}

void main() {
  initGlobals();
  
  return runApp(new AppMain());
}

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Known Geo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new PageSearch(),
    );
  }
}
