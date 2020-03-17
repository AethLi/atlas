import 'dart:io';

import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String thisTitle = "首页";
  static var activeNavigate = 0;

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

    setState(() {
      mainContent.add(Text(sdPath));
    });
  }

  @override
  void initState() {
    super.initState();
    initPath();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            thisTitle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            )
          ],
        ),
        body: ListView.builder(
          itemCount: mainContent.length,
          itemBuilder: (context, index) {
            return mainContent[index];
          },
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
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipOval(
                            child: Image.network(
                              "https://avatars0.githubusercontent.com/u/25505798?s=460&u=89655f6863ad2cb2d4fb46dd19db4ccf2ba09d56&v=4",
                              width: 80.0,
                              height: 80.0,
                            ),
                          ),
                        ),
                        Text(
                          "未登录",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
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
