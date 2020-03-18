import 'package:flutter/material.dart';

class DirectoryTile extends StatelessWidget {
  final String name;
  final double width;

  const DirectoryTile({Key key, @required this.name, @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 5,
              child: Container(
                  height: width * 0.7,
                  width: width,
                  child: Center(
                    child: Image.asset(
                      "assets/images/directory.png",
                      fit: BoxFit.contain,
                      width: width * 0.7,
                    ),
                  )
              )
          ),
          Positioned(
            bottom: 5,
            width: width,
            child: Text(
              name,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
