import 'package:flutter/material.dart';

class LayoutSwitcher extends StatelessWidget {
  final double width;

  const LayoutSwitcher({Key key, @required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingValue = width * 0.04;
    double titleFontSize = width * 0.07;
    double childFontSize = width * 0.06;
    TextStyle childTitleStyle = TextStyle(fontSize: childFontSize);
    double iconSize = width * 0.16;
    TextStyle sortTypeStyle = TextStyle(fontSize: width * 0.05);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return;
      },
      child: Dialog(
        child: Container(
            width: width,
//                height: height,
            child: Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "视图设置",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  Divider(),
                  Text(
                    "布局",
                    textAlign: TextAlign.center,
                    style: childTitleStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: paddingValue, bottom: paddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {},
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.grid_on,
                                  size: iconSize,
                                ),
                                Divider(
                                  height: 5,
                                ),
                                Text("网格")
                              ],
                            )),
                        FlatButton(
                          onPressed: () {},
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.format_list_bulleted,
                                size: iconSize,
                              ),
                              Divider(
                                height: 5,
                              ),
                              Text("列表")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Text(
                    "大小",
                    textAlign: TextAlign.center,
                    style: childTitleStyle,
                  ),
                  Container(
                    child: _LayoutSizeChangeSlider(),
                  ),
                  Divider(),
                  Text(
                    "排序",
                    textAlign: TextAlign.center,
                    style: childTitleStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: paddingValue, bottom: paddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: width * 0.2,
                          child: FlatButton(
                            onPressed: () {},
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file,
                                  size: iconSize,
                                ),
                                Divider(
                                  height: 5,
                                ),
                                Text(
                                  "类型",
                                  style: sortTypeStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: width * 0.2,
                          child: FlatButton(
                            onPressed: () {},
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: iconSize,
                                ),
                                Divider(
                                  height: 5,
                                ),
                                Text(
                                  "修改时间",
                                  style: sortTypeStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                        ButtonTheme(
                            minWidth: width * 0.2,
                            child: FlatButton(
                              onPressed: () {},
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.sd_storage,
                                    size: iconSize,
                                  ),
                                  Divider(
                                    height: 5,
                                  ),
                                  Text(
                                    "大小",
                                    style: sortTypeStyle,
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: paddingValue, bottom: paddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text("保存"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("取消"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class _LayoutSizeChangeSlider extends StatefulWidget {
  @override
  _LayoutSizeChangeSliderState createState() => _LayoutSizeChangeSliderState();
}

class _LayoutSizeChangeSliderState extends State<_LayoutSizeChangeSlider> {
  double value = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Slider(
          min: 1,
          max: 10,
          value: value,
          divisions: 9,
          onChanged: (value) {
            setState(() {
              this.value = value;
            });
          },
        ),
        Text("当前大小:" + value.toStringAsFixed(0))
      ],
    );
  }
}
