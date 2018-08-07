import 'dart:async';

import 'package:flutter/services.dart';

class SimplePermissions {
  static const MethodChannel _channel =
      const MethodChannel('simple_permissions');

  static Future<String> get platformVersion async {
    final String platform = await _channel.invokeMethod('getPlatformVersion');
    return platform;
  }

  /// Check a [permission] and return a [Future] with the result
  static Future<bool> checkPermission(Permission permission) async {
    final bool isGranted = await _channel.invokeMethod(
        "checkPermission", {"permission": getPermissionString(permission)});
    return isGranted;
  }

  /// Request a [permission] and return a [Future] with the result
  static Future<bool> requestPermission(Permission permission) async {
    final bool isGranted = await _channel.invokeMethod(
        "requestPermission", {"permission": getPermissionString(permission)});
    return isGranted;
  }

  /// Open app settings on Android and iOs
  static Future<bool> openSettings() async {
    final bool isOpen = await _channel.invokeMethod("openSettings");

    return isOpen;
  }

  static Future<PermissionStatus> getPermissionStatus(
      Permission permission) async {
    final int status = await _channel.invokeMethod(
        "getPermissionStatus", {"permission": getPermissionString(permission)});
    switch (status) {
      case 0:
        return PermissionStatus.notDetermined;
      case 1:
        return PermissionStatus.restricted;
      case 2:
        return PermissionStatus.denied;
      case 3:
        return PermissionStatus.authorized;
      default:
        return PermissionStatus.notDetermined;
    }
  }
}

/// Enum of all available [Permission]
enum Permission {
  RecordAudio,
  Camera,
  WriteExternalStorage,
  ReadExternalStorage,
  AccessCoarseLocation,
  AccessFineLocation,
  WhenInUseLocation,
  AlwaysLocation,
  ReadContacts,
  Vibrate,
  WriteContacts
}

/// Permissions status enum (iOs)
enum PermissionStatus { notDetermined, restricted, denied, authorized }

String getPermissionString(Permission permission) {
  String res;
  switch (permission) {
    case Permission.Camera:
      res = "CAMERA";
      break;
    case Permission.RecordAudio:
      res = "RECORD_AUDIO";
      break;
    case Permission.WriteExternalStorage:
      res = "WRITE_EXTERNAL_STORAGE";
      break;
    case Permission.ReadExternalStorage:
      res = "READ_EXTERNAL_STORAGE";
      break;
    case Permission.AccessFineLocation:
      res = "ACCESS_FINE_LOCATION";
      break;
    case Permission.AccessCoarseLocation:
      res = "ACCESS_COARSE_LOCATION";
      break;
    case Permission.WhenInUseLocation:
      res = "WHEN_IN_USE_LOCATION";
      break;
    case Permission.AlwaysLocation:
      res = "ALWAYS_LOCATION";
      break;
    case Permission.ReadContacts:
      res = "READ_CONTACTS";
      break;
    case Permission.Vibrate:
      res = "VIBRATE";
      break;
    case Permission.WriteContacts:
      res = "WRITE_CONTACTS";
      break;
  }
  return res;
}
