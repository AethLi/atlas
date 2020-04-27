import 'package:atlas/widgets/page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MainWidget(),
    ));

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  static var globeThemeData = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.purple,
      ));

  final Function directoryChangeCallBack = (String title) {
    title = title;
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContentContainer(),
      theme: globeThemeData,
    );
  }
}
