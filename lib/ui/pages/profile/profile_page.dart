import 'package:social_network_front/ui/pages/profile/profile_logic.dart';
import 'package:social_network_front/ui/pages/profile/profile_style.dart';
import 'package:social_network_front/services/routing.dart';

import 'dart:async';

import 'package:flutter/material.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String title = 'Profile';

  ProfileLogic logic = ProfileLogic();
  ProfileStyle style = ProfileStyle();

  late Future<UserSettings> userSettings;

  @override
  void initState() {
    super.initState();
    userSettings = logic.getUserSettings();
  }

  void delayAndPushReplacement() async {
    await Future.delayed(const Duration(milliseconds: 100));
    navigateToPage(page: super.widget, context: context);
  }

  List<Widget> buildWraps(BuildContext context, List<String> fields, String route) {
    List<Widget> r = [];

    for (final String field in fields) {
      TextEditingController _controller = TextEditingController();
      Widget w = FutureBuilder<UserSettings>(
        future: userSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData)

          {
            return Wrap(spacing: 8.0,
              runSpacing: 4.0,
              children: [Text('$field: '),
                Text(snapshot.data!.getProps()[field]),
                TextField(
                  controller: _controller,
                  onSubmitted: (String value) {
                    logic.updateField(value, field, route);
                    delayAndPushReplacement();
                  },)]
              ,);
          }

          else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          else {
            return const Text('');
          }
        },
      );
      r.add(w);
    }
  return r;
  }

  @override
  Widget build(BuildContext context) {
    Widget userParameters = const Text('Paramètres utilisateur');
    Widget userSettingsParameters = const Text('Réglages utilisateur');


    return MaterialApp(
      title: 'Réglages',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Réglages'),
          ),
          body: Column(children:
              <Widget>[Column(children: [userParameters] + buildWraps(context, logic.getUserFields(), 'updateUserField'))] +
                  <Widget>[const Padding(padding: EdgeInsets.all(60),)] +
                  <Widget>[Column(children: [userSettingsParameters] + buildWraps(context, logic.getUserSettingsFields(), 'updateUserSettingsField'))]
          )
      ),
    );

  }
}