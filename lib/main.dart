import 'package:eden_garden/view/first_screen.dart';
import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/login_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:eden_garden/view/settings_screen.dart';
import 'package:eden_garden/view/signUp_screen.dart';
import 'package:eden_garden/view/user/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

import 'package:eden_garden/controllers/globals.dart' as global;
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kIsWeb){
    global.currentPlatform = "web";
  }
  else{
    if(Platform.isAndroid) {
      global.currentPlatform = "and";
    }
    if(Platform.isWindows){
      global.currentPlatform = "win";
    }

    if(Platform.isIOS){
      global.currentPlatform = "ios";

    }
  }


  runApp(
    MaterialApp(
      title: 'Eden Garden',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/init',
      debugShowCheckedModeBanner: false,

      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/init': (context) => const FirstScreen(),
        '/login': (context) => const LoginScreen(from: "main"),
        '/signup': (context) => const SignupScreen(from: "main"),
        '/home': (context) => const HomeScreen(from: "main"),
        '/search': (context) => const SearchScreen(from: "main"),
        '/userInfo': (context) => UserInfoScreen(from: "main", user:global.currentUser),
        '/myGarden': (context) => const GardenScreen(from: "main"),
        '/settings': (context) => const SettingsScreen(from: "main"),


      },

    ),
  );
}




