import 'package:flutter/material.dart';

import 'dialogs.dart';

class LocalStoragePage extends StatefulWidget {
  @override
  _LocalStoragePageState createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("本地"),
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
        name: "主目录", onPress: () {}, imageAsset: "assets/images/folder.png"),
    _IndexMenu(
        name: "根目录", onPress: () {}, imageAsset: "assets/images/folder.png"),
    _IndexMenu(
        name: "局域网共享",
        onPress: () {},
        imageAsset: "assets/images/lan.png"),
    _IndexMenu(
        name: "FTP", onPress: () {}, imageAsset: "assets/images/ftp.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Divider(
          height: 5,
          color: Colors.purple,
          thickness: 1,
        ),
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
                                colorFilter: ColorFilter.mode(Colors.purple, BlendMode.srcATop),
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
                  onPressed: () {},
                );
              }),
        )
      ],
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
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
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
      body: IndexPage(),
    );
  }
}
