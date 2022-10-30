import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:eden_garden/view/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


/// Button Rect on View with border color

class ProfileBodyView extends StatelessWidget {

  final bool profileZoom;
  final double screenWidth;

  const ProfileBodyView({Key? key, required this.profileZoom, required this.screenWidth})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// BODY VIEW  ---------------------------------------------------

        SizedBox(height: profileZoom ? 45 : 100,),

        SizedBox(
          width: screenWidth,
          child: const Divider(
            thickness: 2,
          ),),

        TextButton(
          onPressed: () {
            Navigator.push(  // push -> Add route on stack
              context,
              FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                routeName: '/userInfo',
              ),
            ) ;},
          child: Text(
              "Personal information",
              style: TextStyle(
                color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                fontWeight: FontWeight.w400,
                fontFamily: 'meri',
                fontSize: 24,)),
        ),


        const SizedBox(height: 20,),

        SizedBox(
          width: screenWidth,
          child: const Divider(
            thickness: 2,
          ),),

        TextButton(
            onPressed: () {print("community");},
            child:Text("Community",
                style: TextStyle(
                  color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'meri',
                  fontSize: 24,)
            )
        ),
        const SizedBox(height: 20,),
        SizedBox(
          width: screenWidth,
          child: const Divider(
            thickness: 2,
          ),),


        TextButton(
            onPressed: () {print("stats");},
            child:Text("Garden statistics",
                style: TextStyle(
                  color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'meri',
                  fontSize: 24,)
            )
        ),
        const SizedBox(height: 20,),

        SizedBox(
          width: screenWidth,
          child: const Divider(
            thickness: 2,
          ),),

        ///---------------------------------------------------------------

      ],
    );
  }
}