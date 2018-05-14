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
  List<User> users = new List();
  bool isLoadingData = true;

  @override
  void initState() {
    _userListPresenter = new UserListPresenter(this);

    _userListPresenter.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppAppBar("Users"),
      body: _createBodyView(),
    );
  }

  Widget _createBodyView() {
    if (isLoadingData) {
      return new Center(
        child: new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );
    }

    return new ListView.builder(
      itemBuilder: (context, index) => new UserItem(
            user: users[index],
            callback: (users) => {},
          ),
      itemCount: users.length,
      padding: new EdgeInsets.all(20.0),
    );
  }

  @override
  void onLoadUserComplete(List<User> users) {
    setState(() {
      this.users = users;
      isLoadingData = false;
    });
  }

  @override
  void onLoadUserError() {
    setState(() {
      isLoadingData = false;
      users = new List();
    });
  }
}

typedef void OnUserItemClick(User user);

class UserItem extends StatelessWidget {
  User user;
  OnUserItemClick callback;

  UserItem({this.user, this.callback});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 20.0),
      child: new Row(
        children: <Widget>[
          new Container(
            height: 80.0,
            width: 80.0,
            margin: new EdgeInsets.only(right: 20.0),
            child: new CircleAvatar(
              backgroundImage: new NetworkImage(user.picture.medium),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                user.name.first + " " + user.name.last,
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: "OpenSanBold"),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: new Text(
                  user.email,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: "OpenSanRegular"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
