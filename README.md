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


#### di
Dependency injection (just very simple level)

#### feature
App's functionality , the name will mapping with functionality.

#### schema
Define data class

#### main.dart
Root of project. 
