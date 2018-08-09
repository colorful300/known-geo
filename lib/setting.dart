import 'file_downloader.dart';
import 'dart:convert';

abstract class Setting {
  static FileDownloader fileSaver = new FileDownloader();
  static Map<String, dynamic> settings = {
    'resolusionX': 512,
    'resolusionY': 512,
  };
  static Map<String, dynamic> collections = new Map<String, Map>();
  static List downloads = new List();

  static void save() async {
    await fileSaver.write(jsonEncode(settings), 'settings.json');
  }

  static void load() async {
    String data = await fileSaver.read('settings.json');
    if (data != null) {
      settings = jsonDecode(data);
    }
  }

  static void saveCollections() async {
    await fileSaver.write(jsonEncode(collections), 'collections.json');
  }

  static void loadCollections() async {
    String collectionData = await fileSaver.read('collections.json');
    if (collectionData != null) {
      collections = jsonDecode(collectionData);
    }
  }

  static void saveDownloads() async {
    await fileSaver.write(jsonEncode(downloads), 'downloads.json');
  }

  static void loadDownloads() async {
    String data = await fileSaver.read('downloads.json');
    if (data != null) {
      downloads = jsonDecode(data);
    }
  }
}
