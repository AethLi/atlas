import 'dart:io';

import 'package:atlas/widgets/Tiles.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ContentView extends StatefulWidget {
  final double height;
  final double width;
  final List<FileSystemEntity> files;
  final mainContentType type;

  const ContentView(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.files,
      @required this.type})
      : super(key: key);

  @override
  State createState() {
    switch (type) {
      case mainContentType.GRID:
        return _ContentGridViewState(height, width, files);
      case mainContentType.LIST:
        return _ContentListViewState(height, width, files);
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
          return DirectoryTile(
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
        itemCount: files.length, gridDelegate: null, itemBuilder: null);
  }
}

enum mainContentType { GRID, LIST }
