import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/services/app_state.dart';
import 'package:social_network_app/ui/pages/splash/splash_logic.dart';
import 'package:social_network_app/ui/pages/splash/splash_style.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashLogic logic = SplashLogic();
  SplashStyle style = SplashStyle();

  @override
  void initState() {
    logic.init(context: context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText('Keen of Arts',
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 40)),
                          ],
                        ),
                      ),
                      appState.appStatus == AppStatus.login
                          ? Text(
                        'Content de te revoir ' + appState.currentUser.username,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      )
                          : Container(),
                    ]),
              ],
            )),
      ),
    );
  }
}