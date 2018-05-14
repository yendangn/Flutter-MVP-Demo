import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_app/common/error/fetch_data_exception.dart';
import 'package:user_app/schema/user.dart';

abstract class UserListRepository {
  Future<List<User>> fetchUser();
}

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

        throw new FetchDataException("StatusCode:$statusCode, Error:${response.reasonPhrase}");

      }

      final JsonDecoder _decoder = new JsonDecoder();
      final useListContainer = _decoder.convert(jsonBody);
      final List userList = useListContainer['results'];

      return userList.map((userRaw) => new User()).toList();

    });
  }
}
