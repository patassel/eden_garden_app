
import 'dart:io';

import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/body/profile_body_view.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:eden_garden/controllers/dataBase_controller.dart';
//import 'package:eden_garden/controllers/route_management.dart';

import 'package:eden_garden/controllers/globals.dart' as global;



class HomeScreen extends StatefulWidget {
  final String from;

  const HomeScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  late String from;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late bool flagProfileEdit = false;
  late bool flagProfileZoom = false;
  late bool flagErrorDataException = false;
  late bool flagStatusConnexion = false;

  late File? androidImageFile;
  late String? imagePath= "";
  //late XFile? iosImageFile;

  // Data user shared preferences.
  late SharedPreferences dataUser;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController controllerView = ScrollController();


  @override
  void initState() {
    super.initState();
    from = widget.from;
    androidImageFile = File('');
    //iosImageFile = XFile('');

    /// Initiate User Data SharedPreference
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      dataUser = sp;
      imagePath = dataUser.getString('profile');
      // will be null if never previously saved
      if (imagePath!=null){
        androidImageFile = File(imagePath!);
      }
      setState(() {});
    });
  }

  initiateSetState() async {
    await Future.delayed(const Duration(milliseconds: 200), () {});

    setState(() {});
    if(flagProfileZoom){
      await Future.delayed(const Duration(milliseconds: 1000), () {});
      controllerView.jumpTo(controllerView.position.minScrollExtent);
    }
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    controllerView.dispose();
    super.dispose();
    //initiateSetState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
        onWillPop: () async{
          return _onWillPop();
          },

        child:Scaffold(
            key: scaffoldKey,

            drawer:  AppDrawer(from: "home", function: initiateSetState,),

            bottomNavigationBar: orientationPortrait?  SimpleBottomBar(
              from: "home",
              onPressed: (val){
                global.currentPage = val;

                switch (val) {
                  case 0:
                    Navigator.pushReplacement(  // push -> Add route on stack
                      context,
                      FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                        page: const HomeScreen(from: "home"), //ContactScreen(),
                        routeName: '/home',
                      ),
                    );
                    break;
                  case 1:
                    Navigator.pushReplacement(  // push -> Add route on stack
                      context,
                      FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                        page: const SearchScreen(from: "home"), //ContactScreen(),
                        routeName: '/search',
                      ),
                    );
                    break;
                  case 2:
                    Navigator.pushReplacement(  // push -> Add route on stack
                      context,
                      FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                        page: const GardenScreen(from: "home"), //ContactScreen(),
                        routeName: '/myGarden',
                      ),
                    );
                    break;
                }
                initiateSetState();
              },
            ) : const SizedBox(),


            body:
            /// BODY -----------------------------------------------------------------

            /// BACKGROUND DECORATION VIEW

            GestureDetector(
            onTap: () {
              if (!flagStatusConnexion) {
                flagProfileEdit = false;
                flagProfileZoom = false;
                flagStatusConnexion = false;
              }
              initiateSetState();
          },
            child:
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration:
                  BoxDecoration(
                    gradient: LinearGradient(
                      // DEEP BLUE DARK
                      colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                          : global.ColorTheme().colorsViewModernBackgroundLight,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  ),

                child:
                SingleChildScrollView(
                    controller: controllerView,

                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    /// TOP VIEW  --------------------------------------------------

                    /// Top view Banner
                    Container(
                      padding: const EdgeInsets.only(top: 10,),
                      height: 105,
                      color: global.themeAppDark? Colors.black : Colors.green,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30,),
                          child :Text("My account",
                            style: TextStyle(
                              color: Colors.greenAccent.shade100,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'meri',
                              fontSize: 34,)),
                      )),
                    ),

                    const SizedBox(height: 50,),

                    /// GESTION PROFILE CONNECTIVITY ---------------------------
                    Stack(
                      children: [
                    /// Profile picture
                        Align(alignment: Alignment.center,child:
                        GestureDetector(
                      behavior: HitTestBehavior.translucent,

                      /// ZOOM profile
                      onTap: () async {

                        if (flagProfileEdit){flagProfileEdit = false; flagStatusConnexion = false;}
                        else{
                          flagProfileZoom = !flagProfileZoom;

                        }
                        initiateSetState();
                      },
                      onLongPress: () {
                        if (flagProfileZoom){flagProfileZoom = false;}
                        else{
                          flagProfileEdit = !flagProfileEdit;
                        }
                        initiateSetState();
                      },
                      child:
                      AnimatedSize(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.decelerate,
                          child:
                          Hero(
                              tag: 'user',
                              child:
                                  Container(
                                    width: (orientationPortrait && flagProfileZoom) ? screenWidth*0.8 : (!orientationPortrait && flagProfileZoom) ? screenWidth*0.4 : 150,
                                    height: (orientationPortrait && flagProfileZoom) ? screenHeight*0.4 : (!orientationPortrait && flagProfileZoom) ? screenHeight*0.8:  150,
                                    decoration: BoxDecoration(
                                      image: androidImageFile!.path.isEmpty ?
                                      DecorationImage(
                                          image:  const AssetImage('assets/profile.jpg') ,
                                          fit: flagProfileZoom ? BoxFit.fill : BoxFit.cover,
                                      ) :
                                      DecorationImage(
                                        image: FileImage(androidImageFile!),
                                        fit: flagProfileZoom ? BoxFit.fill : BoxFit.cover,
                                      ),
                                        border: Border.all(color
                                            :flagProfileZoom ? Colors.transparent
                                            :global.currentUser.online==0 ? Colors.grey
                                            :global.currentUser.online==1? Colors.green
                                            :global.currentUser.online==2 ? Colors.red.shade400
                                            : Colors.white,
                                            width: 5),
                                      borderRadius: const BorderRadius.all(Radius.circular(120.0)),

                                    ),

                              )
                          )),
                    ),),

                        /// EDIT profile
                        flagProfileEdit? Align(alignment: const Alignment(0.8,0.8),
                            child:

                            ButtonCircle(
                              tag: 'Edit photo',
                              tip: 'Edit photo from gallery',
                              icon: Icon(Icons.edit, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                              colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                              colorBorder: Colors.transparent,
                              onPressed: () async {
                                  await androidGetFromGallery();
                                  initiateSetState();
                                  await dataUser.setString('profile', androidImageFile!.path);
                                },

                              ),
                            ): const SizedBox(),

                        flagProfileEdit? Align(alignment: const Alignment(-0.8,0.8),
                            child:
                                SizedBox(
                                  width: 100,
                                  child :
                                  Column(
                                  children: [
                                    ButtonCircle(
                                      tag: 'status',
                                      tip: 'Change status connexion',
                                      icon: Icon(Icons.arrow_drop_down_circle_sharp, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                                      colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                                      colorBorder: Colors.transparent,
                                      onPressed: () {
                                        flagStatusConnexion = !flagStatusConnexion;
                                        initiateSetState();
                                      },
                                    ),

                                    flagStatusConnexion?
                                    SlideAnimationController(
                                        delay: 500,
                                        child:
                                        Column(
                                              children: [
                                                GestureDetector(
                                                    onTap: (){global.currentUser.online=0; initiateSetState();},
                                                    child :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            height: 15,
                                                            width: 15,
                                                            margin: const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                  width: 3,
                                                                ))
                                                        ),

                                                        Text('Offline',
                                                          style: TextStyle(
                                                            letterSpacing: 0.25,
                                                            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'RobotMono',
                                                            fontSize: 16,),),

                                                      ],
                                                    )),
                                                GestureDetector(
                                                    onTap: (){global.currentUser.online=1; initiateSetState();},
                                                    child :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            height: 15,
                                                            width: 15,
                                                            margin: const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                color: Colors.green,
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: Colors.green,
                                                                  width: 3,
                                                                ))
                                                        ),

                                                        Text('Online',
                                                          style: TextStyle(
                                                            letterSpacing: 0.25,
                                                            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'RobotMono',
                                                            fontSize: 16,),),

                                                      ],
                                                    )),
                                                GestureDetector(
                                                    onTap: (){global.currentUser.online=2; initiateSetState();},
                                                    child :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            height: 15,
                                                            width: 15,
                                                            margin: const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                color: Colors.red.shade400,
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: Colors.red.shade400,
                                                                  width: 3,
                                                                ))
                                                        ),

                                                        Text('Busy',
                                                          style: TextStyle(
                                                            letterSpacing: 0.25,
                                                            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'RobotMono',
                                                            fontSize: 16,),),

                                                      ],
                                                    ))
                                              ],

                                        )) : const SizedBox(),
                                  ],
                                ))
                        )

                         : const SizedBox(),




                      ],
                    ),
                    /// --------------------------------------------------------



                    !flagProfileZoom ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child:

                    SlideAnimationController(
                      delay: 800,
                      child: Text(
                        global.currentUser.fullName,
                        style: TextStyle(
                          letterSpacing: 0.25,
                          color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'RobotMono',
                          fontSize: 24,),
                      ),
                    ))
                     : const SizedBox(),


              ///---------------------------------------------------------------
                    Container(
                      height: 10,
                      color: Colors.black12,

                    ),
              /// BANNER INFO GENERAL ------------------------------------------
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(bottom: orientationPortrait ? 0 : 50),
                height: orientationPortrait ? 100 : 110,
                width: screenWidth,

                child:
                SlideAnimationController(
                  delay: 800,
                  child:
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(global.currentUser.myGardenObject.length.toString(),
                          style:TextStyle(
                            letterSpacing: 0.25,
                            color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RobotMono',
                            fontSize: 32,),
                        ),


                        Text('Garden Item ',
                          style:TextStyle(
                            letterSpacing: 0.25,
                            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RobotMono',
                            fontSize: 16,),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text('0',
                          style:TextStyle(
                            letterSpacing: 0.25,
                            color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RobotMono',
                            fontSize: 32,),
                        ),


                        Text('Community ',
                          style:TextStyle(
                            letterSpacing: 0.25,
                            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RobotMono',

                            fontSize: 16,),
                        ),
                      ],
                    ),
                  ],
                )),
                ),

              ///---------------------------------------------------------------
                    Container(
                    height: 10,
                    color: Colors.black12,

                ),
              /// BODY VIEW  ---------------------------------------------------
                    ProfileBodyView(profileZoom: flagProfileZoom, screenWidth: screenWidth),
              ///---------------------------------------------------------------


              //const SizedBox(height: 30,),

            ],
          )),
      ))
    ));
  }

  /// Get from Gallery
  Future androidGetFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        androidImageFile = File(pickedFile.path);
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure ?\n'),
        content: const Text('Do you want to sign out and exit Eden garden ?'),
        actions: <Widget>[
          ButtonRect(
              title: "No",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorDeepDark,
              onclickButton: () {
                setState(() =>Navigator.pop(context));

              },
              onHoverMouse: (val) {}
            /* setState(()
              {
                if (val) {
                  colorTextCancel = Colors.white;
                }else{
                  colorTextCancel = global.ColorTheme().colorFromLight;
                }
              });
            },
              */
          ),
          SizedBox(width: orientationPortrait ?  screenWidth*0.28: screenWidth*0.38,),
          /*TextButton(
            //onPressed: () => Navigator.of(context).pop(true),
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),

           */
          ButtonRect(
              title: "Yes",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorDeepDark,
              onclickButton: () => SystemNavigator.pop(),
              onHoverMouse: (val) {}

          ),
        ],
      ),
    ));
  }


}