class User {

  Name name;
  Picture picture;
  String email;
  String phone;

  User({this.name, this.picture, this.email, this.phone});

 
}

class Name {

  String last;
  String first;

  Name({this.last, this.first});
}

class Picture {

  String medium;

  Picture({this.medium});
}
