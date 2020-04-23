import 'package:flutter/services.dart';

class Smb {
  static const MethodChannel _channel = const MethodChannel('smb');

  static Future<void> getLanComputers() async {
    _channel.invokeMethod('getLanComputers');
  }
}
