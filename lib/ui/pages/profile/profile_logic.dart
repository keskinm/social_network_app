import 'package:dio/dio.dart';
import 'package:social_network/services/api/dio.dart';
import 'package:social_network/services/app_state.dart';

class UserSettings {
  // @todo separate User and UserSettings properties and handle
  //  update of User Properties

  // User props
  final String username;
  final String number;
  final String type;

  // User Setting props
  final String foo;

  UserSettings({
    required this.username,
    this.number = '',
    this.type = 'fan',

    this.foo = 'bar',

  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    json.removeWhere((key, value) => value == null);

    return UserSettings(
      username: json['userId']['username'],
      number: json['userId']['number'] ?? '',
      type:json['userId']['type'] ?? 'fan',
      foo:json['foo'] ?? 'bar'

    );
  }

  Map<String, dynamic> getProps() {
    return {
      'username': username,
      'number' : number,
      'type': type,

      'foo': foo,
    };
  }

}


class ProfileLogic{

  List<String> getUserFields() {
    return ['number', 'type'];
  }

  List<String> getUserSettingsFields() {
    return ['foo'];
  }

  Future<UserSettings> getUserSettings() async {
    String userId = appState.currentUser.id ;

    String jsonData = '{"user_id": "$userId"}';

    Response response =
    await dioHttpPost(route: 'getUserSettings', jsonData: jsonData, token: true);

    if (response.statusCode == 200) {
      if (response.data != null)
      {
        return UserSettings.fromJson(response.data);
      }
      else {
        return await createThenGetUserSettings(jsonData);
      }
    } else {
      throw Exception('Failed to load UserSettings');
    }
  }

  Future<UserSettings> createThenGetUserSettings(String jsonData) async {
    
    await dioHttpPost(route: 'createUserSettings', jsonData: jsonData, token: true);
    Response response =
    await dioHttpPost(route: 'getUserSettings', jsonData: jsonData, token: true);
    if (response.statusCode == 200) {
      return UserSettings.fromJson(response.data);
    }
    else {
      throw Exception('Failed to load UserSettings');
    }
  }


  Future<int> updateField(String value, String field, String route) async {

    String userId = appState.currentUser.id ;

    String jsonData = '{"user_id": "$userId", "$field": "$value"}';

    Response response =
        await dioHttpPost(route: route, jsonData: jsonData, token: true);

    if (response.statusCode == 200) {
      return 0;
    }
    else {
      throw Exception('Fail to updateField');
    }

  }


}

