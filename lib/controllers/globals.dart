library my_prj.globals;

import 'package:eden_garden/model/user_db.dart';
import 'package:flutter/animation.dart';

String currentPlatform = "web"; // Current platform environment

bool themeAppDark = true; // If true app is on Dark theme else Light theme

int currentPage = 0;

UserDB currentUser = UserDB(fullName: 'user', id: 'id');

bool currentUserExist = false;


class ColorTheme {

  Color colorDeepDark = const Color(0xAAA12121);

  Color colorFromDark = const Color(0xFFFFFFFF);
  Color colorFromDarkSub = const Color(0xFFFF7043);
  Color colorFromLight = const Color(0xFF000000);

  Color buttonFromLight = const Color(0xFF009688);

  Color colorDrawerBackground = const Color(0x73000000);

  List<Color> colorsViewBackgroundDark = [
    const Color(0xFF212121),
    const Color(0xFF112121),
    const Color(0xFF112121),
    const Color(0xFF212121),];

  List<Color> colorsViewBackgroundLight = [
    const Color(0xAFAFFFBB),

    //const Color(0xCCACCABB),
    const Color(0xCCACCABB),
    const Color(0xCCACCABB),

  //const Color(0xAFAFADD2),
    const Color(0xCCACCABB),
  ];

  List<Color> colorsDrawBackgroundLight = [
    const Color(0xFF112121),
    const Color(0xFF112121),
    const Color(0xFF112121),
    const Color(0xAAA12121),];



}