import 'dart:io';

import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:atlas/widgets/MainContent.dart';
import 'package:atlas/widgets/Tiles.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//import 'package:flutter/rendering.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String thisTitle = "首页";
  static var activeNavigate = 0;

  Stream<FileSystemEntity> files;

  static var globeThemeData = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.purple,
      ));

  List<Widget> mainContent = <Widget>[];

  Future<void> initPath() async {
    String sdPath;
    sdPath = await ExternalStoragePath.externalStoragePath;
    Directory sdDir = Directory(sdPath);
    files = sdDir.list();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPath();
  }

  @override
  Widget build(BuildContext context) {
//    debugPaintSizeEnabled = true;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            thisTitle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.grid_on),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          key: Key("contentView"),
          padding: EdgeInsets.all(10.0),
        ),
        drawer: MainDrawerWidget(
          globeThemeData: globeThemeData,
        ),
      ),
      theme: globeThemeData,
    );
  }
}

class MainDrawerWidget extends StatelessWidget {
  final ThemeData globeThemeData;

  static var activeNavigate = 0;

  const MainDrawerWidget({Key key, @required this.globeThemeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Row(
                children: <Widget>[],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('首页'),
                    selected: activeNavigate == 0,
                    onTap: () {
                      activeNavigate = 0;
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.forum),
                    title: const Text('讨论'),
                    selected: activeNavigate == 1,
                    onTap: () {
                      activeNavigate = 1;
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('设置'),
                    selected: activeNavigate == 2,
                    onTap: () {
                      activeNavigate = 2;
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
