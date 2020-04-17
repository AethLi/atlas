import 'package:flutter/services.dart';

class Smb {
  static const MethodChannel _channel = const MethodChannel('smb');

  static Future<Map> get lanInfo async {
    final Map lanInfo = await _channel.invokeMapMethod("getLanInfo");
    return lanInfo;
  }

  static Future<List> get lanComputers async {
    final List lanComputers = await _channel.invokeMethod('getLanComputers');
    return lanComputers;
  }

  static Future<List> get lanComputerSimply async {
    final List lanComputers = await _channel.invokeMethod('getLanComputers');
    return lanComputers;
  }
}
