/*
  static init() async {
    ReceivePort receivePort = new ReceivePort();
    Isolate.spawn(_initEx, receivePort.sendPort);
    int step = 0;
    receivePort.listen((data) async {
      if (step == 0) {
        ++step;
        SendPort sendPort = data;
        sendPort.send(await rootBundle.loadString('assets/txt/service_list.txt'));
      } else {
        fileServiceList = data;
        hasInit = true;
        receivePort.close();
        if (onInitComplete != null) onInitComplete();
      }
    });
  }

  static _initEx(SendPort sendPort) async {
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);
    List<FileServiceItem> list = new List<FileServiceItem>();
    receivePort.listen((data) async {
      listRegExp.allMatches(data).forEach((match) {
        list.add(new FileServiceItem(int.parse(match.group(1)), match.group(2),
            match.group(3), match.group(4)));
      });
      sendPort.send(list);
      receivePort.close();
    });
  }
*/

/*
  static init() async {
    String fileData =
        await rootBundle.loadString('assets/txt/service_list.txt');
    FileService.listRegExp.allMatches(fileData).forEach((match) {
      FileService.fileServiceList.add(new FileServiceItem(
          int.parse(match.group(1)),
          match.group(2),
          match.group(3),
          match.group(4)));
    });
    FileService.hasInit = true;
    if (onInitComplete != null) onInitComplete();
  }
*/

/*
  static void searchServices(
      List<String> keywords, _CallbackList callback) async {
    ReceivePort receivePort = new ReceivePort();
    Isolate.spawn(_searchServicesEx, receivePort.sendPort);
    SendPort sendPort;
    int step = 0;
    receivePort.listen((data) {
      if (step == 0) {
        ++step;
        sendPort = data;
        sendPort.send(keywords);
        sendPort.send(fileServiceList);
      } else {
        callback(data);
        receivePort.close();
      }
    });
  }

  static void _searchServicesEx(SendPort sendPort) async {
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);
    List<FileServiceItem> services = new List<FileServiceItem>();
    List<String> keywords;
    List<FileServiceItem> serviceList;
    int step = 0;
    receivePort.listen((data) {
      if (step == 0) {
        step++;
        keywords = data;
      } else {
        serviceList = data;
        for (FileServiceItem item in serviceList) {
          bool flag = true;
          for (String keyword in keywords) {
            if (!item.title.contains(keyword)) {
              flag = false;
              break;
            }
          }
          if (!flag) continue;
          services.add(item);
        }
        sendPort.send(services);
        receivePort.close();
      }
    });
  }
*/
