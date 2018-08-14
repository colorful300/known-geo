import 'file_downloader.dart';
import 'dart:convert';
import 'dart:async';

abstract class Setting {
  static FileDownloader fileSaver = new FileDownloader();
  static Map<String, dynamic> settings = {
    'resolusionX': 512,
    'resolusionY': 512,
  };
  static Map<String, dynamic> collections = new Map<String, Map>();
  static List downloads = new List();

  static Future<Null> save() async {
    await fileSaver.write(jsonEncode(settings), 'settings.json');
  }

  static Future<Null> load() async {
    String data = await fileSaver.read('settings.json');
    if (data != null) {
      settings = jsonDecode(data);
    }
  }

  static Future<Null> saveCollections() async {
    await fileSaver.write(jsonEncode(collections), 'collections.json');
  }

  static Future<Null> loadCollections() async {
    String collectionData = await fileSaver.read('collections.json');
    if (collectionData != null) {
      collections = jsonDecode(collectionData);
    }
  }

  static Future<Null> saveDownloads() async {
    await fileSaver.write(jsonEncode(downloads), 'downloads.json');
  }

  static Future<Null> loadDownloads() async {
    String data = await fileSaver.read('downloads.json');
    if (data != null) {
      downloads = jsonDecode(data);
    }
  }
}
