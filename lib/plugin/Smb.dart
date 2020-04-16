import 'package:flutter/services.dart';

class Smb {
  static const MethodChannel _channel = const MethodChannel('smb');

  static Future<List> get externalStoragePath async {
    final List lanComputers = await _channel.invokeMethod('getLanComputers');
    return lanComputers;
  }
}
