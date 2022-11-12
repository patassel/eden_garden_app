import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/view/signUp_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eden_garden/controllers/globals.dart' as global;


class LoginScreen extends StatefulWidget {
  final String from;
  const LoginScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordFieldController = TextEditingController();
  final TextEditingController _emailFieldController = TextEditingController();

  late bool connexionError = false;
  late bool loadingPage = false;
  late bool documentExist = false;
  late String connexionReturn = "";
  late bool orientationPortrait = false;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return loadingPage ? loadingAnimatePage() : SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          //leading: buildButton(),
          title: const Center( child :Text(
            "Welcome to the Eden Garden",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'meri'),
          )),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15, left: 10),
                  child: Center(child :Text(
                      "Log in with one of following options",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )),
              buildGoogleAppleFunction(screenSize),
              buildText(name: "Email", choose: const TextStyle(fontSize: 17, color: Colors.white)),
              buildEmailField(),
              buildText(name: "Password", choose: const TextStyle(fontSize: 17, color: Colors.white)),
              buildPasswordField(),
              const SizedBox(
                height: 25,
              ),
              buildTapToLogin(),
              connexionError ? buildReturnDialog() : const SizedBox(),
              buildTapToSignup(context),
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

  Widget buildText({String? name, TextStyle? choose}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Text(
        name!,
        style: choose,
      ),
    );
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
                  //print("Icon Google");
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

  /// CHECK DATABASE USER
  Widget buildTapToLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Center (
      child : ElevatedButton(
        onPressed: () async {

          var emailValue = _emailFieldController.value.text;
          var passwordValue = _passwordFieldController.value.text;

          /// Check Email exist

          if(emailValue.isNotEmpty) {
            if (await dataBaseCheckUserId(_emailFieldController.text)){
              final snapShot = await FirebaseFirestore.instance
                  .collection('id')
                  .doc(emailValue)
                  .get();
              documentExist=true;
              dataBaseRead(snapShot.data()!['id']);
            }else{
              documentExist=false;
            }
          }

          await Future.delayed(const Duration(milliseconds: 500), () {});

          /// Check password error
          if(documentExist){
            if(global.currentUser.password == passwordValue){
              connexionReturn = "Connexion successful";
            }else {
              connexionReturn = "Password invalid";
              connexionError = true;
            }
          }else{
            connexionReturn = "Email invalid";
            connexionError = true;
          }
            setState(() {});

            if (connexionReturn=="Connexion successful") {
              setState(() {loadingPage = true;});

              await Future.delayed(const Duration(milliseconds: 8000), () {});
              Navigator.push( // push -> Add route on stack
                context,
                FadeInRoute( // FadeInRoute  // ZoomInRoute  // RotationInRoute
                  page: const HomeScreen(from: "login"), //ContactScreen(),
                  routeName: '/home',
                ),
              );

              await Future.delayed(const Duration(milliseconds: 800), () {});

              setState(() {loadingPage = false;});

              connexionError = false;
            }
        },

        style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.green,
            minimumSize: const Size(500, 48)),
        child: const Text("Log in"),
      )),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 3),
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(fontSize: 17, color: Colors.white),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        controller: _passwordFieldController,
        onTap: (){
          connexionReturn="";
          connexionError=false;
          setState(() {

          });
        },

        decoration: InputDecoration(
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20)),
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            hintText: "Enter your password",
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 3),
      child: TextFormField(
        cursorColor: Colors.white,
        controller: _emailFieldController,

        onTap: () {
          connexionReturn="";
          connexionError=false;

          setState(() {

          });
        },
        style: const TextStyle(fontSize: 17, color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20)),
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            hintText: "hello@login.com",
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget buildReturnDialog() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 10),
      child: Center(child :Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [

          const SlideAnimationController(
              delay: 800,
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 38,)
          ),
          const SizedBox(height: 20,),

          const SlideAnimationController(
          delay: 1000,
            child: Text(
              "Oups! connexion failed...\n",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),

          SlideAnimationController(
            delay: 1500,
            child: Text(
              connexionReturn,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          )
        ],
      )),
    );
  }



  Widget buildTapToSignup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
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
                    page: const SignupScreen(from: "login"), //ContactScreen(),
                    routeName: '/signup',
                  ),
                ) ;
              },
              child: const Text(
                "Sign up",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }


  Widget loadingAnimatePage() {
    return Scaffold(
      backgroundColor: Colors.black,
      body:

      Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children :
            [
              const SpinKitPouringHourGlass(
                size: 300,
                color: Colors.green,
                duration: Duration(milliseconds: 3000),

              ),

              SizedBox(height: orientationPortrait ? 100 : 30,),


              SlideAnimationController(
                  delay: 1200,
                  child: Text("Hi ${global.currentUser.pseudo}", style: const TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'meri'),),
              ),

              const SizedBox(height: 20,),

              const SlideAnimationController(
                delay: 1800,
                child: Text("Welcome to the Eden Garden", style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'meri'),),
              )
            ]
      ),

    );
  }

}
