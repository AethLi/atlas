import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ContentView extends StatefulWidget {
  final double height;
  final double width;
  final Stream<FileSystemEntity> files;
  final mainContentType type;
  final Function directoryChangeCallBack;
  final String currentPath;

  const ContentView(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.files,
      @required this.type,
      this.directoryChangeCallBack,
      @required this.currentPath})
      : super(key: key);

  @override
  State createState() {
    List<FileSystemEntity> entities = List();
    directoryChangeCallBack(currentPath);
    files.forEach((element) {
      entities.add(element);
    });
    switch (type) {
      case mainContentType.GRID:
        return _ContentGridViewState(height, width, entities);
      case mainContentType.LIST:
        return _ContentListViewState(height, width, entities);
    }
    return null;
  }
}

class _ContentListViewState extends State<ContentView> {
  final double height;
  final double width;
  final List<FileSystemEntity> files;

  _ContentListViewState(this.height, this.width, this.files);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return DirectoryColumnTile(
            name: basename(files[index].path),
            width: width,
          );
        });
  }
}

class _ContentGridViewState extends State<ContentView> {
  final double height;
  final double width;
  final List<FileSystemEntity> files;

  _ContentGridViewState(this.height, this.width, this.files);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: files.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //todo 动态计算每行显示多少个
            childAspectRatio: 1.1 //todo 动态计算宽高比
            ),
        itemBuilder: (context, index) {
          return DirectoryColumnTile(
            name: basename(files[index].path),
            width: width,
          );
        });
  }
}

enum mainContentType { GRID, LIST }

class DirectoryColumnTile extends StatelessWidget {
  final String name;
  final double width;

  const DirectoryColumnTile(
      {Key key, @required this.name, @required this.width})
      : super(key: key);

  Function inToChildDir({@required String name}) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: width,
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            inToChildDir(name: name);
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
