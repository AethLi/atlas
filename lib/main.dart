import 'dart:io';

import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:atlas/value/globeValue.dart';
import 'package:atlas/widgets/dialogs.dart';
import 'package:atlas/widgets/mainContent.dart';
import 'package:flutter/material.dart';

///布局边缘信息
//import 'package:flutter/rendering.dart';

void main() => runApp(MaterialApp(
      home: MainWidget(),
    ));

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
    thisTitle = directoryName;
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
    ExternalStoragePath.externalStoragePath.then((value) {
      Directory sdDir = Directory(value);
      files = sdDir.list();
      setState(() {
        mainContent = ContentView(
          height: 60,
          width: 80,
          files: files,
          type: mainContentType.GRID,
          directoryChangeCallBack: directoryChangeCallBack,
          currentPath: value,
        );
      });
      DirectoryStack.push(value);
    });
  }

  @override
  void initState() {
    super.initState();
    initPath();
  }

  Future<void> _layoutSwitch() async {
    if (await showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width * 0.7;
          return LayoutSwitcher(
            width: width,
          );
        },
        barrierDismissible: false)) {}
  }

  @override
  Widget build(BuildContext context) {
    ///布局边缘信息
//    debugPaintSizeEnabled = true;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            thisTitle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              onPressed: () {
                _layoutSwitch();
              },
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
                    title: const Text('本地'),
                    selected: activeNavigate == 0,
                    onTap: () {
                      activeNavigate = 0;
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.forum),
                    title: const Text('局域网'),
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
