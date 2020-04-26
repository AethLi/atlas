import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmbContent extends StatefulWidget {
  @override
  _SmbContentState createState() => _SmbContentState();
}

class _SmbContentState extends State<SmbContent> {
  static const MethodChannel _channel = const MethodChannel('smb');
  static final Function layoutSwitchCallBack = () {

  };

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "computersUpdate":
          print(call.arguments);
          break;
        default:
          break;
      }
    });
  }
}
