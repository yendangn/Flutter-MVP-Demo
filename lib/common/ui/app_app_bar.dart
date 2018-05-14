import 'package:flutter/material.dart';

class AppAppBar extends AppBar {

  String _title;

  AppAppBar(this._title);

  @override
  Color get backgroundColor => Colors.white;

  @override
  bool get centerTitle => true;

  @override
  Widget get title => new Text(
        _title,
        style: new TextStyle(fontSize: 20.0, color: Colors.black),
      );
}
