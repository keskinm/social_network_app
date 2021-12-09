import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:social_network/services/routing.dart';
import 'package:social_network/ui/pages/register/register_page.dart';
import 'package:social_network/ui/pages/login/login_logic.dart';
import 'package:social_network/ui/pages/login/login_style.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginLogic logic = LoginLogic();
  LoginStyle style = LoginStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(width: MediaQuery.of(context).size.width/3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 90),
                  child: Center(
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Connexion',
                          textStyle: style.colorizeTitleTextStyle,
                          colors: style.colorizeColors,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Form(
                    key: logic.formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) =>
                              logic.validateUsername(value: value),
                          decoration:
                              style.inputDecoration(hintText: 'Nom d\'utilisateur'),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.purple),
                                  top: BorderSide(color: Colors.purple))),
                          child: TextFormField(
                            validator: (value) =>
                                logic.validatePassword(value: value),
                            decoration:
                                style.inputDecoration(hintText: 'Mot de passe'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () => logic.validateLogin(context: context),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.red])),
                    child: const Center(
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  padding: const EdgeInsets.all(40),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mot de passe oublié')),
                    );
                  },
                  child: const Text(
                    'Mot de passe oublié?',
                    style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                ),
                AnimatedTextKit(
                  onTap: () {
                    navigateToPage(page: const RegisterPage(), context: context);
                  },
                  repeatForever: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "Pas encore de compte ? S'inscrire",
                      textStyle: style.colorizeTextStyle,
                      colors: style.colorizeColors,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
