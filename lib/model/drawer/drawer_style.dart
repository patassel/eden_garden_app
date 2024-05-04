import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:eden_garden/view/settings_screen.dart';
import 'package:eden_garden/view/user/user_community_screen.dart';
import 'package:eden_garden/view/user/user_info_screen.dart';
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
            /// Eden Garden Logo
            currentAccountPicture: Image.asset('assets/edenLogo.jpg', height: 50,),
            decoration:
            BoxDecoration(

                gradient: LinearGradient(
                  // DEEP BLUE DARK
                  colors: global.themeAppDark ? global.ColorTheme().colorsDrawBackgroundLight
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
          /// My account
          DrawerRoute("Account", "/home" , Icon(Icons.home, color: global.ColorTheme().colorFromDark,), const HomeScreen(from: "drawer"), from=="home"? "pushReplacement" : "push", function!),

          /// Garden library
          DrawerRoute("Garden library", "/search" , Icon(Icons.local_library, color: global.ColorTheme().colorFromDark,), const SearchScreen(from: "drawer"), from=="search"? "pushReplacement" : "push", function!),

          /// My Eden garden
          DrawerRoute("Eden garden", "/garden" , Icon(Icons.menu_book, color: global.ColorTheme().colorFromDark,), const GardenScreen(from: "drawer"), from=="garden"? "pushReplacement" : "push", function!),
          Divider(height: 1, color: global.ColorTheme().colorFromDark),
          ///-------------------------------------------------------------------

          /// My account
          DrawerRoute("Personal information", "/$from/userInfo" , Icon(Icons.person, color: global.ColorTheme().colorFromDark,), UserInfoScreen(from: "drawer", user: global.currentUser,), "push", function!),

          /// Garden library
          DrawerRoute("Community", "/$from/community" , Icon(Icons.people_alt_rounded, color: global.ColorTheme().colorFromDark,), UserCommunityScreen(from: "drawer", user: global.currentUser, function: function,), "push", function!),

          /// My Eden garden
          DrawerRoute("Garden statistics", "/$from/statistics" , Icon(Icons.bar_chart_sharp, color: global.ColorTheme().colorFromDark,), const GardenScreen(from: "drawer"), from=="garden"? "pushReplacement" : "push", function!),
          Divider(height: 1, color: global.ColorTheme().colorFromDark),
          ///-------------------------------------------------------------------

          Divider(height: 1, color: global.ColorTheme().colorFromDark),
          DrawerRoute("Settings", "/settings" , Icon(Icons.settings, color: global.ColorTheme().colorFromDark,), SettingsScreen(from: "drawer", function: function!,),  "push", function!),
          /// Contact

          /// Help

        ],
      ),
    );
  }
}