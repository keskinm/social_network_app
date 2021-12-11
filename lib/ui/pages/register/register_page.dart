import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/services/routing.dart';
import 'package:social_network_app/ui/pages/login/login_page.dart';
import 'package:social_network_app/ui/pages/register/register_logic.dart';
import 'package:social_network_app/ui/pages/register/register_style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterLogic logic = RegisterLogic();
  RegisterStyle style = RegisterStyle();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'Inscription',
                  textStyle: style.colorizeTextStyle(size: 20),
                  colors: style.colorizeColors,
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Form(
                key: logic.formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) =>
                          logic.validateUsername(value: value),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.purple)),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.purple))),
                      child: TextFormField(
                        validator: (value) => logic.validateEmail(value: value),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.purple)),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.purple),
                              top: BorderSide(color: Colors.purple))),
                      child: TextFormField(
                        obscureText: obscureText,
                        validator: (value) =>
                            logic.validatePassword(value: value),
                        decoration:  InputDecoration(suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
                            border: InputBorder.none,
                            hintText: 'Mot de passe',
                            hintStyle: const TextStyle(color: Colors.purple)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => logic.validateRegister(context: context),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.red])),
                child: const Center(
                  child: Text(
                    'Démarrer l\'inscription',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            AnimatedTextKit(
              onTap: () {
                navigateToPage(page: const LoginPage(), context: context);
              },
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'Connexion',
                  textStyle: style.colorizeTextStyle(size: 20),
                  colors: style.colorizeColors,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
