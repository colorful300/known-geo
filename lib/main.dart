import 'package:flutter/material.dart';
import 'page_search.dart';

void initGlobals() {
  //FileService.init();
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
