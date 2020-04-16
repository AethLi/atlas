import 'dart:async';
import 'dart:io';

import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:atlas/value/globeValue.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ContentView extends StatefulWidget {
  final Function directoryChangeCallBack;
  final String currentPath;
  final State<ContentView> state;

  const ContentView(
      {Key key,
      this.directoryChangeCallBack,
      this.currentPath,
      @required this.state})
      : super(key: key);

  @override
  State createState() {
    return state;
  }

  static Future<List<FileSystemEntity>> initPath() async {
    List<FileSystemEntity> files = List();
    ExternalStoragePath.externalStoragePath.then((value) {
      Directory sdDir = Directory(value);
      Stream<FileSystemEntity> fileStream = sdDir.list();
      fileStream.forEach((element) {
        files.add(element);
      });
      DirectoryStack.push(value);
    });
    return files;
  }
}

class ContentListViewState extends State<ContentView> {
  final double height;
  final double width;
  final Stream<FileSystemEntity> files;

  ContentListViewState(this.height, this.width, this.files);

  @override
  Widget build(BuildContext context) {
    if (files != null) {
      return ListView(
        children: <Widget>[
          StreamBuilder<FileSystemEntity>(
            stream: files,
            builder: (BuildContext context,
                AsyncSnapshot<FileSystemEntity> snapshot) {
              return DirectoryColumnTile(
                name: basename(snapshot.data.path),
                width: width,
              );
            },
          )
        ],
      );
    } else {
      return Container();
    }
  }
}

class ContentGridViewState extends State<ContentView> {
  final double height;
  final double width;

  ContentGridViewState({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: ContentView.initPath(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        List<Widget> children=List();
        if (snapshot.hasData) {
          snapshot.data.forEach((element) {
            print(element.path);
            children.add(DirectoryColumnTile(
                name: basename((element as FileSystemEntity).path),
                width: width));
          });
        } else if (snapshot.hasError) {
          //todo error needs be solved
        } else {
          //todo waiting needs be solved
        }
        return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1.1),
            children: children);
      },
    );
  }
}

enum mainContentType { GRID, LIST }

class DirectoryColumnTile extends StatelessWidget {
  final String name;
  final double width;

  const DirectoryColumnTile(
      {Key key, @required this.name, @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: width,
        child: FlatButton(
          onPressed: () {
            //todo not achieved
          },
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  height: width * 0.7,
                  width: width,
                  child: Center(
                    child: Image.asset(
                      "assets/images/directory.png",
                      fit: BoxFit.contain,
                      width: width * 0.7,
                    ),
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  //todo dynamic font size
                  name,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
