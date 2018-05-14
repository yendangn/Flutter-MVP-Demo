# Flutter MVP demo

Apply MVP to Flutter project.

To easy understand this project, you can visit my other project first which talk about ListView on Flutter at here:
https://github.com/yendangn/Flutter-Simple-ListView

## UI Overview

My project is using API from https://randomuser.me/ . The UI will show list of use as below. And I also apply MVP to it.

1. Android

![](https://github.com/yendangn/Flutter-MVP-Demo/blob/master/images/android_user_list.png)

2. iOS


![](https://github.com/yendangn/Flutter-MVP-Demo/blob/master/images/iOS_user_list.png)

## Project structure

1. Overview

![](https://github.com/yendangn/Flutter-MVP-Demo/blob/master/images/project_detail.png)

#### a . common 

Where will contain common UI, font, color ,custom exception.

```
fetch_data_exception.dart
```
This class will extend ```Exception```, to handle error when get data from API.

```Dart
class FetchDataException implements Exception{

  String _message;
  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}
```

```
app_app_bar.dart
```
To custom AppBar component,  we will use a lot app bar for project.  So if we create a custom and re-use it, we will save a lot line of code.

```Dart
class AppAppBar extends AppBar {

  String _title;

  AppAppBar(this._title);

  @override
  Color get backgroundColor => Colors.white;

  @override
  bool get centerTitle => true;


  @override
  double get elevation => 2.0;

  @override
  Widget get title => new Text(
        _title.toUpperCase(),
        style: new TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: "Arquitecta"),
      );
}

```
And when you want to use it, just do as below:

```Dart
@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppAppBar("Users"),
    );
  }
```
Don't need modify appbar's attributes to custom

```
app_color.dart
```
This class will help us on convert hex color to Color object on Flutter.

```Dart
class AppColor{

  static Color whiteColor = const Color(0x000000);
  static Color blackColor = const Color(0xFFFFFF);

}
```
#### b. feature
App's functionality , the name will mapping with functionality. Each feature forder will have:
 - Repository : will working with API or database
 - Presenter  : will handle app logic, get data from repository and update view.
 - View : it is responsible for presenting data in a way decided by the presenter.

```
user_list_repository.dart

```
First, we will have a ```abstract class``` which will define method for Repository.

```Dart
abstract class UserListRepository {
  Future<List<User>> fetchUser();
}

```

Then, we will implement above repository by create a class, like that:

```Dart
class UserListRepositoryIml implements UserListRepository {

  final String _api = 'http://api.randomuser.me/?results=50';

  @override
  Future<List<User>> fetchUser() {

    return http
        .get(_api)
        .then((http.Response response) {

      final String jsonBody = response.body;
      final int statusCode = response.statusCode;

      if(statusCode != 200 || jsonBody == null){
        print(response.reasonPhrase);
        throw new FetchDataException("StatusCode:$statusCode, Error:${response.reasonPhrase}");
      }

      final JsonDecoder _decoder = new JsonDecoder();
      final useListContainer = _decoder.convert(jsonBody);
      final List userList = useListContainer['results'];

      return userList.map((contactRaw) => new User.fromJson(contactRaw) )
          .toList();

    });
  }
}
```
I'm using ```http``` https://pub.dartlang.org/packages/http#-installing-tab- to connect and get data from API.
You can learn more at flutter document: https://flutter.io/cookbook/networking/fetch-data/

You can use ```JsonDecoder``` to parse  ```Object ``` from ```Json``` https://flutter.io/json/

```
user_list_presenter.dart

```
Define a  ```abstract class``` , view will implement this.

```Dart
abstract class UserListViewContract {
  void onLoadUserComplete(List<User> users);

  void onLoadUserError();
}

```

Create repository class

```Dart
class UserListPresenter {
  UserListViewContract _view;
  UserListRepository _repository;

  UserListPresenter(this._view) {
    _repository = new Injector().getUserListRepository();
  }

  void loadUser() {

    assert(_view != null && _repository != null);

    _repository
        .fetchUser()
        .then((contacts) => _view.onLoadUserComplete(contacts))
        .catchError((onError) => _view.onLoadUserError());
  }
}

```

You can see, my repository will have  ```UserListViewContract _view;``` and ```UserListRepository _repository;```
I will init ```_repository``` on contructor by ```Injector``` ( see c. id)
 ```Dart
 
  UserListPresenter(this._view) {
    _repository = new Injector().getUserListRepository();
  }
  
 ```
And use    ```_repository``` to get data and update view, like that:
 ```Dart
 
   void loadUsers() {
    assert(_view != null && _repository != null);
    _repository
        .fetchUser()
        .then((contacts) => _view.onLoadUserComplete(contacts))
        .catchError((onError) => _view.onLoadUserError());
  }
}

 ```
 
 View class ```user_list_screen.dart``` ( like Activity/Fragment on Android or UIViewController on iOS).
 
 Will implement view on above step like that
 ```Dart
 class UserListState extends State<UserListScreen>
    implements UserListViewContract{
    
      //Your code
    }
    
 ```
 Define and init presenter
 ```Dart
 
 UserListPresenter _userListPresenter;

  @override
  void initState() {
    _userListPresenter = new UserListPresenter(this);
  }
 ```
 
 And use this presenter to get API:
 
 ```Dart
   _userListPresenter.loadUser();
   
 ```
 
 Finally, handle data: 
 
 ```Dart
 @override
  void onLoadUserComplete(List<User> users) {
   
  }

  @override
  void onLoadUserError() {
   
  }
 ```
 

#### c. di
Dependency injection (just very simple level)

```
dependency_injection.dart

```
```Injector``` class will provide the repository to presenter.

```Dart
class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  UserListRepository getUserListRepository() => new UserListRepositoryIml();
}

```


#### schema

Define data class

```Dart
class User {
  Name name;
  Picture picture;
  String email;
  String phone;

  User({this.name, this.picture, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json)
      : name = new Name.fromJson(json['name']),
        picture = new Picture.fromJson(json['picture']),
        email = json['email'],
        phone = json['phone'];
}

class Name {
  String last;
  String first;

  Name({this.last, this.first});

  Name.fromJson(Map<String, dynamic> json)
      : last = json['last'],
        first = json['first'];
}

class Picture {
  String medium;

  Picture({this.medium});

  Picture.fromJson(Map<String, dynamic> json) : medium = json['medium'];
}

```

#### main.dart
Root of project. 
