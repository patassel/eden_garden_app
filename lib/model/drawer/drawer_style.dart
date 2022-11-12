import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/drawer_route.dart';

import 'package:eden_garden/controllers/globals.dart' as global;



// DRAWER MODEL WIDGET
class AppDrawer extends StatelessWidget {
  final String from;

  final Function()? function; // setState on parent widget

  const AppDrawer({Key? key, required this.from, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: global.ColorTheme().colorDrawerBackground,

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          UserAccountsDrawerHeader(
            decoration:
            BoxDecoration(

                gradient: LinearGradient(
                  // DEEP BLUE DARK
                  colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                      : global.ColorTheme().colorsViewModernBackgroundLight,

                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
            ),
            accountName: Text(
                global.currentUser.pseudo,
                style: TextStyle(
                  color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CherryDance',
                  fontSize: 32,)
            ),

            accountEmail: Text(
                global.currentUser.email,
                style: TextStyle(
                  color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotMono',
                  fontSize: 14,)
            ),

            //currentAccountPicture: ,

          ),
          Divider(height: 0, color: global.ColorTheme().colorFromLight),
          DrawerRoute("Home", "/home" , Icon(Icons.home, color: global.ColorTheme().colorFromDark,), const HomeScreen(from: "drawer"), from=="home"? "pushReplacement" : "push", function!),

          Divider(height: 0, color: global.ColorTheme().colorFromLight),
          DrawerRoute("Settings", "/settings" , Icon(Icons.settings, color: global.ColorTheme().colorFromDark,), SettingsScreen(from: "drawer", function: function!,),  "push", function!),


        ],
      ),
    );
  }
}