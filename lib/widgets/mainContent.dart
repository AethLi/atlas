import 'dart:async';
import 'dart:io';

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
  StreamController controller=StreamController();


  ContentGridViewState({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    Stream<List> filesList=controller.stream;
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 1.1),
      children: <Widget>[
        StreamBuilder<List>(
          stream: filesList,
          builder:
              (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Select lot');
              case ConnectionState.waiting:
                print("waiting");
                return Text('Awaiting bids...');
              case ConnectionState.active:
                print(snapshot.data.path + "active");
                return DirectoryColumnTile(
                  name: basename(snapshot.data.path),
                  width: width,
                );
              case ConnectionState.done:
                print(snapshot.data.path);
                return DirectoryColumnTile(
                  name: basename(snapshot.data.path),
                  width: width,
                );
            }
            return Container();
          },
        )
      ],
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
                  //todo 动态计算字体大小
                  name,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
