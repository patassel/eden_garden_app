library my_prj.globals;

import 'package:eden_garden/model/user_db.dart';
import 'package:flutter/animation.dart';

String currentPlatform = "web"; // Current platform environment
bool themeAppDark = true; // If true app is on Dark theme else Light theme
bool currentUserExist = false; // true if User exist
int currentPage = 0; // 0 Account - 1 Search - 2 Garden
UserDB currentUser = UserDB(fullName: 'user', id: 'id', myGarden: {}); // Current User object
Map<String, dynamic> docGarden = {}; // Data Json about garden item



class ColorTheme {

  Color colorDeepDark = const Color(0xAAA12121);
  Color colorFromDark = const Color(0xFFFFFFFF);
  Color colorFromDarkSub = const Color(0xFFFF7043);
  Color colorFromLight = const Color(0xFF000000);

  Color buttonFromLight = const Color(0xFF009688);

  Color colorDrawerBackground = const Color(0x73000000);

  List<Color> colorsViewBackgroundDark = [

    const Color.fromRGBO(14, 14, 14, 1),
    const Color.fromRGBO(14, 14, 14, 1),
    const Color.fromRGBO(14, 14, 14, 1),
    const Color.fromRGBO(14, 14, 14, 1),
    const Color.fromRGBO(14, 14, 14, 1),
    const Color.fromRGBO(14, 14, 14, 1),

    const Color(0xFF000000),

  ];

  List<Color> colorsViewSubBackgroundDark = [
    const Color.fromRGBO(20, 20, 20, 1),

    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),
    const Color.fromRGBO(34, 34, 34, 1),

    const Color.fromRGBO(20, 20, 20, 1),


  ];
  List<Color> colorsHomeBackgroundLight = [
    const Color(0xAFAFFFBB),

    //const Color(0xCCACCABB),
    const Color(0xAFAFFFDD),
    const Color(0xAFAFFFDD),

  //const Color(0xAFAFADD2),
    const Color(0xAFAFFFBB),
  ];

  List<Color> colorsViewModernBackgroundLight = [
    const Color(0xAAFFEEEF),

    //const Color(0xCCACCABB),
    const Color(0xAAFFEEEF),
    const Color(0xAAFFEEEF),

    //const Color(0xAFAFADD2),
    const Color(0xAAFFEEEF),
  ];

  List<Color> colorsViewNormalBackgroundLight = [
    const Color(0xFFFFFFFF),

    //const Color(0xCCACCABB),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),

    //const Color(0xAFAFADD2),
    const Color(0xFFFFFFFF),
  ];

  List<Color> colorsDrawBackgroundLight = [
    const Color(0x73000000),

    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),
    const Color.fromRGBO(34, 34, 34, 0.5),


    const Color(0x73000000),
  ];



}