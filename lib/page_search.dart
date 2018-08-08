import 'package:flutter/material.dart';
import 'file_service.dart';
import 'texted_widget.dart';
import 'page_file_service.dart';
import 'page_collection.dart';
import 'page_setting.dart';

class PageSearch extends StatefulWidget {
  @override
  State < StatefulWidget > createState() => new _PageSearchState();
}

class _PageSearchState extends State < PageSearch > {
  bool centerSearch = true;
  bool zeroItem = false;
  Map < String,
  bool > hasCollected = new Map < String,
  bool > ();
  List < FileServiceItem > fileServiceList = new List < FileServiceItem > ();
  int pageCount;
  TextEditingController textEditingController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  int page = 0;
  String title = 'Known Geo';

  Widget body() {
    if (!FileService.hasInit) {
      FileService.onInitComplete = () {
        setState(() {});
      };
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: < Widget > [
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: < Widget > [
              new CircularProgressIndicator(),
              new Text('文件服务列表加载中')
            ])
        ],
      );
    }
    return new Column(
      mainAxisAlignment:
      centerSearch ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: searchWidgetWithList(),
    );
  }

  Widget searchWidget() {
    return new Container(
      padding: new EdgeInsets.fromLTRB(16.0, 0.0, 32.0, 0.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        //  image:  //  then there should be a image 
      ),
      child: new TextField(
        controller: textEditingController,
        decoration: new InputDecoration(
          icon: new Icon(Icons.search),
          hintText: '搜索关键词，如「成都 地下水」',
        ),
        onChanged: (input) {
          zeroItem = false;
          page = 0;
          if (input.length == 0) {
            setState(() {
              title = 'Known Geo';
              centerSearch = true;
              fileServiceList.clear();
              pageCount = 0;
            });
            return;
          }
          setState(() {
            title = '搜索';
            centerSearch = false;
          });
          List < String > keywords = input.split(' ');
          for (int i = 0; i < keywords.length; ++i) {
            if (keywords[i].length == 0 || keywords[i] == ' ') {
              keywords[i] = keywords.last;
              keywords.removeLast();
              --i;
            }
          }
          if (keywords.length == 0) {
            zeroItem = true;
            return;
          }
          FileService.searchServices(keywords, (serviceList) {
            if (textEditingController.text == input) {
              if (serviceList.length == 0) {
                zeroItem = true;
              }
              setState(() {
                fileServiceList = serviceList;
                pageCount = fileServiceList.length~/ 18 + 1;
                title = '搜索结果(' +
                  (page + 1).toString() +
                  '/' +
                  pageCount.toString() +
                  ')';
              });
            }
          });
        },
      ),
    );
  }

  List < Widget > searchWidgetWithList() {
    List < Widget > list = new List < Widget > ()..add(searchWidget());
    if (!centerSearch) {
      if (fileServiceList.length > 0) {
        list.add(new Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: fileServiceList.length - page * 18 > 18 ?
            20 :
            fileServiceList.length - page * 18,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (page != 0) {
                  return new ListTile(
                    leading: const Icon(Icons.arrow_left),
                      title: new Text('上一页'),
                      onTap: () {
                        setState(() {
                          --page;
                          title = '搜索结果(' +
                            (page + 1).toString() +
                            '/' +
                            pageCount.toString() +
                            ')';
                        });
                        scrollController.jumpTo(0.0);
                      },
                  );
                }
                return new ListTile(
                  title: new Text('全部文档: '),
                );
              }
              if (index != 19) {
                int calculatedIndex = index + page * 18 - 1;
                return new ListTile(
                  leading: new Icon(Icons.folder),
                  title: new Text(fileServiceList[calculatedIndex].title),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new PageFileService(
                          fileServiceList[calculatedIndex],
                          null)));
                  },
                );
              }
              return new ListTile(
                leading: const Icon(Icons.arrow_right),
                  title: new Text('下一页'),
                  onTap: () {
                    setState(() {
                      ++page;
                      title = '搜索结果(' +
                        (page + 1).toString() +
                        '/' +
                        pageCount.toString() +
                        ')';
                    });
                    scrollController.jumpTo(0.0);
                  },
              );
            },
          ),
        ));
      } else {
        list.add(new Expanded(
          child: new Center(
            child: zeroItem ?
            new TextedIcon(Icons.no_sim, text: new Text('空')) :
            new CircleProgress(text: new Text('正在搜索'))
          )
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(title),
      actions: < Widget > [
        new IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new PageCollection();
            }));
          },
        ),
        new IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new PageSetting();
            }));
          },
        )
      ],
    ),
    body: body());
}