import 'package:social_network_app/models/user_model.dart';
import 'package:social_network_app/services/api/auth.dart';
import 'package:social_network_app/services/device.dart' as device;
import 'package:shared_preferences/shared_preferences.dart';


AppState appState = AppState();

enum AppStatus {
  init,
  login,
  connected,
  disconnected,
  unknownPlatform,
}

class AppState {
  AppState();

  late Map<dynamic, dynamic> platformState;

  late String serverUrl;

  late User currentUser = User();
  late SharedPreferences sharedPreferences;
  AppStatus appStatus = AppStatus.init;

  AuthMethods authMethods = AuthMethods();

  Future<AppStatus> init() async {
    if (await checkPlatform()) {
      if (await getCredentials()) {
        appStatus = AppStatus.login;

        await authMethods.firebaseSignInWithEmailAndPassword(currentUser.email, currentUser.password);

        if (checkToken(await authMethods.authenticationToken(
            username: currentUser.username, password: currentUser.password))) {
          final res = await authMethods.getCurrentUser(token: currentUser.token);
          currentUser.setParameters(res);
          appStatus = AppStatus.connected;
          return AppStatus.connected;
        } else {
          appStatus = AppStatus.disconnected;
          print('Can\'t reach token');
          return AppStatus.disconnected;
        }
      } else {
        appStatus = AppStatus.disconnected;
        return AppStatus.disconnected;

      }
    } else {
      appStatus = AppStatus.unknownPlatform;
      print(platformState['error']);
      return AppStatus.unknownPlatform;
    }
  }

  Future<bool> checkPlatform() async {
    final pState = await device.initPlatformState();
    if (pState.containsKey('error')) {
      print(pState['error']);
      return false;
    } else {
      platformState = pState;
      return true;
    }
  }

  Future<bool> getCredentials() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return checkCredentials(keys: sharedPreferences);
  }

  void addCredentials({required Map<String, String> keys}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    keys.forEach((key, value) {
      appState.sharedPreferences.setString(key, value);
    });
  }

  bool checkCredentials({required SharedPreferences keys}) {
    print(keys.getKeys());
    if (keys.containsKey('username') &&
        keys.get('username') != null &&
        keys.containsKey('password') &&
        keys.get('password') != null) {
      currentUser.username = keys.get('username').toString();
      currentUser.password = keys.get('password').toString();
      print('Credentials OK');
      return true;
    } else {
      print('Credentials NOT OK');
      return false;
    }
  }

  bool checkToken(token) {
    if (token.containsKey('token')) {
      currentUser.token = token['token'];
      return true;
    } else {
      return false;
    }
  }
}
