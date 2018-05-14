import 'package:flutter/material.dart';
import 'package:user_app/common/ui/app_app_bar.dart';

class UserListScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new UserListState();
}


class UserListState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {


    return new Scaffold(

      appBar: new AppAppBar('Users'),

    );


  }
}
