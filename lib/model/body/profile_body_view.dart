import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/view/user/user_info_screen.dart';
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
    return
      Container(
        width: screenWidth,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          decoration:
          BoxDecoration(
              gradient: LinearGradient(
                // DEEP BLUE DARK
                colors: global.themeAppDark ? global.ColorTheme().colorsViewSubBackgroundDark
                    : global.ColorTheme().colorsViewNormalBackgroundLight,

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),

      ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// BODY VIEW  ---------------------------------------------------
                ListTile(
                    title: Text("Personal information",

                        style: TextStyle(
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                          fontWeight: FontWeight.w400,
                        fontFamily: 'meri',
                        fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.person, color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more,color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                      onPressed: () {
                        Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );
                      },
                    )),

                SizedBox(
                  width: screenWidth,
                  child: const Divider(
                    color: Colors.black12,
                    thickness: 2,
                  ),),


                ListTile(
                    title: Text("Community",
                        style: TextStyle(
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'meri',
                          fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.people_alt_rounded, color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more,color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                      onPressed: () {
                        /*Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );

                         */
                      },
                    )),
                SizedBox(
                  width: screenWidth,
                  child: const Divider(
                    color: Colors.black12,
                    thickness: 2,
                  ),),

                ListTile(
                    title: Text("Garden statistics",
                        style: TextStyle(
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'meri',
                          fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.bar_chart_sharp, color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more,color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                      onPressed: () {
                        /*Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );

                         */
                      },
                    )),


              SizedBox(
                width: screenWidth,
                child: const Divider(
                  color: Colors.black12,
                  thickness: 10,
                ),),


                ListTile(
                    title: Text("Privacy",
                        style: TextStyle(
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'meri',
                          fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.privacy_tip, color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more,color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                      onPressed: () {
                        /*Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );

                         */
                      },
                    )),
                SizedBox(
                  width: screenWidth,
                  child: const Divider(
                    color: Colors.black12,
                    thickness: 2,
                  ),),

                ListTile(
                    title: Text("Notifications",
                        style: TextStyle(
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'meri',
                          fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.notifications, color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more,color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,),
                      onPressed: () {
                        /*Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );

                         */
                      },
                    )),
                SizedBox(
                  width: screenWidth,
                  child: const Divider(
                    color: Colors.black12,
                    thickness: 10,
                  ),),
                ListTile(
                    title: Text("Delete my account",
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'meri',
                          fontSize: 16,)
                    ),
                    //subtitle: Text(global.currentUser.myGardenObject[index].species),
                    leading: Icon(Icons.no_accounts, color: Colors.red.shade600,),
                    trailing:  IconButton(
                      icon : Icon(Icons.read_more, color: Colors.red.shade600,),
                      onPressed: () {
                        /*Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: UserInfoScreen(from: "home", user: global.currentUser,), //ContactScreen(),
                            routeName: '/userInfo',
                          ),
                        );

                         */
                      },
                    )),

                ///---------------------------------------------------------------

            ],
    ));
  }
}