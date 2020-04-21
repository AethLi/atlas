import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Smb {
  static const MethodChannel _channel = const MethodChannel('smb');

  static Future<Map> get lanInfo async {
    final Map lanInfo = await _channel.invokeMapMethod("getLanInfo");
    return lanInfo;
  }

  static Future<List> getLanComputers(List<int> ips) async {
    final List lanComputers =
        await _channel.invokeMethod('getLanComputers', ips);
    print(ips);
    return lanComputers;
  }

  static Future<List> get lanComputerSimply async {
    final List lanComputers = await _channel.invokeMethod('getLanComputers');
    return lanComputers;
  }

  static Future<void> lanComputerSimplyInvoke(Function callBack) async {
    lanComputerSimply.then((value) => callBack(value));
  }

  static Future<void> lanComputerInvoke(Function callBack) async {
    //get lanInfo
    lanInfo.then((value) {
      //convert to int
      Uint8List ipv4Uint8List = value['ipv4'];
      int prefixLength = (value['prefixLength']) as int;
      for (int i = 0; i < 32 - prefixLength; i++) {
        ipv4Uint8List[32 - 1 - i] = 0;
      }
      int ipv4Int = 0;
      for (int i = 0; i < ipv4Uint8List.length; i++) {
        ipv4Int += ipv4Uint8List[i] * pow(2, (32 - 1 - i));
      }
      //list ip that needs scan
      List<int> ips = List();
      int frequency = pow(2, (32 - prefixLength));
      //start from gateway
      ipv4Int += 1;
      lanComputerInvokeRecursive(callBack, frequency, ipv4Int);
//      for (int i = 1, j = 0; i < pow(2, (32 - prefixLength)) - 1; i++) {
//        if (j > 10) {
//          ips.add(ipv4Int + i);
//          getLanComputers(ips).then((value) => callBack(value));
//          ips.removeRange(0, ips.length - 1);
//        } else {
//          ips.add(ipv4Int + i);
//        }
//      }
//      getLanComputers(ips).then((value) => callBack(value));
    });
  }

  static Future<void> lanComputerInvokeRecursive (
      Function callBack, int frequency, int ipv4Int) async {
    List<int> ips = List();
    if (frequency >= 10) {
      for (int i = 0; i < 10; i++) {
        ips.add(ipv4Int + i);
      }
      frequency -= 10;
      getLanComputers(ips).then((value) {
        callBack(value);
        if (frequency >= 0) {
          lanComputerInvokeRecursive(callBack, frequency, ips.last);
        }
      });
    } else {
      for (int i = 0; i < 10; i++) {
        ips.add(ipv4Int + i);
      }
      getLanComputers(ips).then((value) => callBack(value));
    }
  }
}
