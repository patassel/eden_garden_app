import 'package:eden_garden/controllers/route_management.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/view/login_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends StatefulWidget {
  final String from;

  const SignupScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: buildButton(),
          title: const Text(
            "Sign up",
            style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              buildText(
                  name: "Sign up with one of following options",
                  choose: const TextStyle(fontSize: 16, color: Colors.grey)),
              buildGoogleAppleFunction(mq),
              buildText(name: "Name", choose: const TextStyle(fontSize: 17, color: Colors.white)),
              buildNameField(),
              buildText(name: "Email", choose: const TextStyle(fontSize: 17, color: Colors.white)),
              buildEmailField(),
              buildText(name: "Password", choose: const TextStyle(fontSize: 17, color: Colors.white)),
              buildPasswordField(),
              const SizedBox(
                height: 25,
              ),
              buildCreateanAccount(),
              buildTaptoLogin(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.grey),
            elevation: 15.0,
            minimumSize: const Size(20, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          //print("Icon Touch");
        },
        child: const Icon(Icons.arrow_back_ios, color: Colors.white));
  }

  Widget buildGoogleAppleFunction(Size mq) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, left: 5, right: 3, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.grey),
                    elevation: 15.0,
                    minimumSize: Size(mq.width * 0.4, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  // print("Icon Google");
                },
                child: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.grey),
                    elevation: 15.0,
                    minimumSize: Size(mq.width * 0.4, 50),
                    // backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  //print("Icon Apple");
                },
                child: const Icon(FontAwesomeIcons.apple, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 3),
      child: TextFormField(
        style: const TextStyle(fontSize: 17, color: Colors.white),
        cursorColor: Colors.white,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(20)),
            hintText: "Full Name",
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 3),
      child: TextFormField(
        style: const TextStyle(fontSize: 17, color: Colors.white),
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "hello@signup.com",
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget buildText({String? name, TextStyle? choose}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10),
      child: Text(
        name!,
        style: choose,
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 3),
      child: TextFormField(
        style: const TextStyle(fontSize: 17, color: Colors.white),
        cursorColor: Colors.white,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(20)),
            hintText: "pick a strong password",
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget buildCreateanAccount() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.purpleAccent[400],
            minimumSize: const Size(500, 48)),
        child: const Text("xCreate Account"),
      ),
    );
  }

  Widget buildTaptoLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account?",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(
            width: 8,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(  // push -> Add route on stack
                  context,
                  FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                    page: const LoginScreen(from: "signup",), //ContactScreen(),
                    routeName: '/login',
                  ),
                ) ;
              },
              child: const Text(
                "Log in",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
