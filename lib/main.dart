import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/settings_screen.dart';
import 'package:eden_garden/view/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

import 'package:eden_garden/controllers/globals.dart' as global;

import 'package:firebase_core/firebase_core.dart';
import 'controllers/firebase_options.dart';

Future<void> main() async {

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

    /*await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

     */

  }
  runApp(
    MaterialApp(
      title: 'Eden Garden',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,

      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const HomeScreen(from: "main"),
        '/userInfo': (context) => const UserInfoScreen(from: "main"),
        '/settings': (context) => const SettingsScreen(from: "main"),







      },

    ),
  );
}

