import 'package:atlas/plugin/ExternalStorage.dart';
import 'package:atlas/value/UserActionStack.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dialogs.dart';

class LocalStoragePage extends StatefulWidget {
  @override
  _LocalStoragePageState createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: DropdownButton<String>(
            value: "One",
            dropdownColor: Colors.purple,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (String newValue) {
              setState(() {});
            },
            items:
                <String>['One'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () {
              _layoutSwitch(context);
            },
          )
        ],
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexMenu {
  final String name;
  final Function onPress;
  final String imageAsset;

  _IndexMenu(
      {@required this.imageAsset, @required this.name, @required this.onPress});
}

class _IndexPageState extends State<IndexPage> {
  static List<_IndexMenu> _indexMenus = [
    _IndexMenu(
        name: "主目录",
        onPress: (context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LocalStoragePage();
          }));
        },
        imageAsset: "assets/images/folder.png"),
    _IndexMenu(
        name: "根目录",
        onPress: (context) {},
        imageAsset: "assets/images/folder.png"),
    _IndexMenu(
        name: "局域网共享",
        onPress: (context) {},
        imageAsset: "assets/images/lan.png"),
    _IndexMenu(
        name: "FTP",
        onPress: (context) {},
        imageAsset: "assets/images/ftp.png"),
  ];

  List<Widget> _indexContent = [
    Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1),
          itemCount: _indexMenus.length,
          itemBuilder: (context, index) {
            return FlatButton(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Center(
                          child: ColorFiltered(
                            child: Image.asset(
                              _indexMenus[index].imageAsset,
                              fit: BoxFit.contain,
                            ),
                            colorFilter: ColorFilter.mode(
                                Colors.purple, BlendMode.srcATop),
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      _indexMenus[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              onPressed: () {
                _indexMenus[index].onPress(context);
              },
            );
          }),
    )
  ];

  @override
  Widget build(BuildContext context) {
    ExternalStoragePath.externalSpaceInfo.then((value) {
      if (mounted) {
        _indexContent.insert(
            0,
            CircularPercentIndicator(
              radius: 60,
              lineWidth: 5,
              percent: 0.3,
              center: Text(""),
              progressColor: Colors.purple,
            ));
      }
    });
    _indexContent.insert(
        0,
        Divider(
          height: 5,
          color: Colors.purple,
          thickness: 1,
        ));
    UserActionStack actionStack = UserActionStack();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _indexContent,
    );
  }
}

class ContentContainer extends StatefulWidget {
  @override
  _ContentContainerState createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: DropdownButton<String>(
            value: "One",
            dropdownColor: Colors.purple,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (String newValue) {
              setState(() {});
            },
            items:
                <String>['One'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        actions: [
//          IconButton(
//            icon: Icon(Icons.home),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.grid_on),
//            onPressed: () {
//              _layoutSwitch(context);
//            },
//          )
        ],
      ),
      body: IndexPage(),
    );
  }
}
