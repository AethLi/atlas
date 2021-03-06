import 'dart:async';

import 'package:atlas/plugin/Smb.dart';
import 'package:atlas/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import 'widgets/mainContent.dart';

void main() => runApp(MaterialApp(
      home: MainWidget(),
    ));

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String title = "首页";
  final State<ContentView> contentViewState = ContentGridViewState(
    height: 60,
    width: 80,
  );

  static var globeThemeData = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.purple,
      ));

  Future<void> _layoutSwitch(BuildContext context) async {
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

  final Function directoryChangeCallBack = (String title) {
    title = title;
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("首页"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              onPressed: () {
                _layoutSwitch(context);
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ContentView(
              directoryChangeCallBack: directoryChangeCallBack,
              state: contentViewState),
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
                    title: const Text('局域网Smb'),
                    selected: activeNavigate == 1,
                    onTap: () {
                      Smb.getLanComputers();
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
