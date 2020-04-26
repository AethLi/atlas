import 'package:flutter/material.dart';

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

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 200,
        ),
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.1),
          children: [
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Center(
                      child: Image.asset(
                        "assets/images/directory.png",
                        fit: BoxFit.contain,
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "name",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
