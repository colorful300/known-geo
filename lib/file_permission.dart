import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';

abstract class FilePermission {
  static bool hasPermission = false;
  static void init() async {
    if (await SimplePermissions
        .checkPermission(Permission.WriteExternalStorage)) {
      hasPermission = true;
    }
  }

  static Future<bool> request() async {
    if (!hasPermission) {
      return SimplePermissions
          .requestPermission(Permission.WriteExternalStorage);
    }
    return true;
  }
}
