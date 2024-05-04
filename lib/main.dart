
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/user_db.dart';
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

  /// Infinite LOOP
  /// Reload last data of the current User
  scheduleMicrotask(() {
    asyncDataUser(global.currentUser);
  });
  /// Infinite LOOP



  runApp(
    MaterialApp(
      title: 'Eden Garden',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/init',
      debugShowCheckedModeBanner: false,
      navigatorKey: global.navState,

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


/// Async function initialize data in real time
/*
TODO
  - CHECK WHY SOMETIMES USER = NONE
 */
Future<void> asyncDataUser(UserDB user) async {

  while(true){

    await Future.delayed(const Duration(seconds: 5), () async {

      if (await checkNetworkActivity()) {

        print("NETWORK AVAILABLE");

        if (user.id != "id" && user.email != "email") {
          /*
        String id = user.id;
        await dataBaseRead(id);
         */

          UserDB updateUser = await dataBaseGetUser(user.id);
          global.currentUser.fromJson(updateUser.returnJson());
          global.currentUser.constructCommunityObject();
          print("REFRESH USER");
          print(global.currentUser.myGardenObject);
          print(global.currentUser.myGardenObject.length);

        }
      } else{}

    });

  }
}


/// Async function Check Network activity
Future<bool> checkNetworkActivity() async {

    final result =
    await (Connectivity().checkConnectivity());

    if (result == ConnectivityResult.none) {
      if(global.dialogNetworkActivity!=true) {
        showDialogErrorNetworkActivity();
        global.dialogNetworkActivity = true;
      }
      return false;
    } else {
      global.dialogNetworkActivity = false;
      //displaySendRequestDialog();
      return true;
    }

}

Future<void> showDialogErrorNetworkActivity() {
  return showDialog(
    context: global.navState.currentContext!,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(
            child: SlideAnimationController(
                delay: 300,
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 38,
                )),
          ),
          content: const SlideAnimationController(
              delay: 800,
              child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    '\nPlease check your\ninternet connection...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ))),
          actions: <Widget>[
            ButtonRect(
                title: "Ok",
                colorBorder: Colors.transparent,
                colorBackground: Colors.transparent,
                colorHover: Colors.black,
                colorText: global.ColorTheme().colorDeepDark,
                onclickButton: () {
                  global.dialogNetworkActivity = false;
                  setState(() => Navigator.pop(context));
                },
                onHoverMouse: (val) {}),
          ],
        )),
  );
}








