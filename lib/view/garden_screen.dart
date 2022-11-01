
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:flutter/material.dart';

//import 'package:eden_garden/controllers/dataBase_controller.dart';
//import 'package:eden_garden/controllers/route_management.dart';

import 'package:eden_garden/controllers/globals.dart' as global;



class GardenScreen extends StatefulWidget {
  final String from;

  const GardenScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<GardenScreen> createState() => _GardenScreenState();


}

class _GardenScreenState extends State<GardenScreen> {

  late String from;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    from = widget.from;

    /// Initiate User Object
    //getUserDB("pfTjVgNet8ggVpNOAfas");
  }


  initiateSetState() {setState(() {});}


  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(

        key: scaffoldKey,

        drawer:  AppDrawer(from: "garden", function: initiateSetState,),

        bottomNavigationBar: SimpleBottomBar(
          from: "garden",
          onPressed: (val){
            global.currentPage = val;

            switch (val) {
              case 0:
                Navigator.pushReplacement(  // push -> Add route on stack
                  context,
                  FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                    page: const HomeScreen(from: "garden"), //ContactScreen(),
                    routeName: '/home',
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(  // push -> Add route on stack
                  context,
                  FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                    page: const SearchScreen(from: "garden"), //ContactScreen(),
                    routeName: '/search',
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(  // push -> Add route on stack
                  context,
                  FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                    page: const GardenScreen(from: "garden"), //ContactScreen(),
                    routeName: '/myGarden',
                  ),
                );
                break;
            }
            initiateSetState();
          },
        ),


        body:
        /// BODY -----------------------------------------------------------------

        /// BACKGROUND DECORATION VIEW


        Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
          BoxDecoration(
              gradient: LinearGradient(
                // DEEP BLUE DARK
                colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                    : global.ColorTheme().colorsViewBackgroundLight,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )
          ),


              child: SingleChildScrollView(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    /// Top View -----------------------------------------------


                    ///---------------------------------------------------------

                    /// BODY VIEW  ---------------------------------------------------
                    /// GridView of article

                    ///---------------------------------------------------------------



                  ],
                ),
              ),
            )
    );
  }
}