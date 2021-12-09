import 'package:flutter/material.dart';
import 'package:social_network/services/app_state.dart';
import 'package:social_network/services/routing.dart';
import 'package:social_network/ui/pages/main/main_page.dart';
import 'package:social_network/ui/widgets/forms/validator.dart';

class LoginLogic {

  final formKey = GlobalKey<FormState>();
  late String username;
  late String password;

  Validator validator = Validator();

  String? validatePassword({required String? value}) {
    if (!validator.validatePassword(value: value)) {
      return 'Doit contenir au moins 8 caractères.';
    } else {
      password = value!;
      return null;
    }
  }

  String? validateUsername({required String? value}) {
    if (!validator.validateUsername(value: value)) {
      return 'Doit contenir au moins 4 caractères.';
    } else {
      username = value!;
      return null;
    }
  }

  Future<void >validateLogin({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {

      final bool res = appState.checkToken(
          await appState.authMethods.authenticationToken(username: username, password: password));

      if (res) {
        //Stockage des infos pour connexion auto
        appState.addCredentials(
            keys: {'username': username, 'password': password});
        final res = await appState.authMethods.getCurrentUser(token: appState.currentUser.token);

        await appState.authMethods.firebaseSignInWithEmailAndPassword(res['email'], password);

        appState.currentUser.setParameters(res);
        appState.appStatus = AppStatus.connected;
        //Lancement app
        navigateToPage(page: const MainPage(), context: context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion impossible')),
        );
      }
    }
  }


}



