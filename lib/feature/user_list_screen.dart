import 'package:flutter/material.dart';
import 'package:user_app/common/ui/app_app_bar.dart';
import 'package:user_app/feature/user_list_presenter.dart';
import 'package:user_app/schema/user.dart';

class UserListScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new UserListState();
}


class UserListState extends State<UserListScreen>
    implements UserListViewContract {

  UserListPresenter _userListPresenter;


  @override
  void initState() {

    _userListPresenter = new UserListPresenter(this);

    _userListPresenter.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppAppBar('Users'),

    );
  }

  @override
  void onLoadUserComplete(List<User> users) {

    print(users.toString());

  }

  @override
  void onLoadUserError() {
    // TODO: implement onLoadUserError
  }
}
