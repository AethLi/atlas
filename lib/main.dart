import 'dart:io';

import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:atlas/widgets/MainContent.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String thisTitle = "首页";
  static var activeNavigate = 0;
  Widget mainContent;

  Stream<FileSystemEntity> files;

  void directoryChangeCallBack(String directoryName) {
    setState(() {
      thisTitle = directoryName;
    });
  }

  static var globeThemeData = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.purple,
      ));

  Future<void> initPath() async {
    String sdPath;
    ExternalStoragePath.externalStoragePath.then((value){
      sdPath=value;
      Directory sdDir = Directory(sdPath);
      files = sdDir.list();
      setState(() {
        mainContent = ContentView(
          height: 60,
          width: 80,
          files: files,
          type: mainContentType.GRID,
          directoryChangeCallBack: directoryChangeCallBack,
          currentPath: sdPath,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    sleep(Duration(seconds: 2));
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
          padding: EdgeInsets.all(10.0),
          child: mainContent,
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
