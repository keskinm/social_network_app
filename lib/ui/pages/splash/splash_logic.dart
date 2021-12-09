import 'package:flutter/material.dart';
import 'package:social_network/services/app_state.dart';
import 'package:social_network/services/routing.dart';
import 'package:social_network/ui/pages/main/main_page.dart';
import 'package:social_network/ui/pages/register/register_page.dart';

class SplashLogic {
  void init({required BuildContext context}) {
    // Vérification plateforme
    appState.init().then((value) {
      if (appState.appStatus == AppStatus.connected) {
        navigateToPage(page: const MainPage(), context: context);
      } else if (appState.appStatus == AppStatus.disconnected) {
        navigateToPage(page: const RegisterPage(), context: context);
      }
    });
  }
}
