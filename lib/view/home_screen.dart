import 'dart:io';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/dialog/show_dialog.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/body/profile_body_view.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:eden_garden/controllers/globals.dart' as global;

class HomeScreen extends StatefulWidget {
  final String from;

  const HomeScreen({Key? key, required this.from}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String from;

  late double screenWidth;

  late double screenHeight;

  late bool orientationPortrait = false;

  late bool flagProfileEdit = false;
  late bool flagProfileZoom = false;
  late bool flagErrorDataException = false;
  late bool flagStatusConnexion = false;

  late File? androidImageFile;
  late String? imageCache;

  //late XFile? iosImageFile;

  // Data user shared preferences.

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController controllerView = ScrollController();

  //late final NotificationApi service = NotificationApi();

  @override
  void initState() {
    super.initState();
    from = widget.from;
    global.currentPage = 0;

    //service.initialize();

    androidImageFile = File('');
    //iosImageFile = XFile('');

    /// Initiate User Data SharedPreference
    imageCache = global.dataUser.getString('profile');
    // will be null if never previously saved
    if (imageCache != null) {
      androidImageFile = File(imageCache!);
    }
  }

  initiateSetState() async {
    await Future.delayed(const Duration(milliseconds: 200), () {});

    setState(() {});
    if (flagProfileZoom) {
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
    orientationPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
        onWillPop: () async {
          return _onWillPop();
        },
        child: Scaffold(
            key: scaffoldKey,
            drawer: AppDrawer(
              from: "home",
              function: initiateSetState,
            ),
            bottomNavigationBar: orientationPortrait
                ? SimpleBottomBar(
                    from: "home",
                    onPressed: (val) {
                      global.currentPage = val;

                      switch (val) {
                        case 0:
                          Navigator.pushReplacement(
                            // push -> Add route on stack
                            context,
                            FadeInRoute(
                              // FadeInRoute  // ZoomInRoute  // RotationInRoute
                              page: const HomeScreen(
                                  from: "home"), //ContactScreen(),
                              routeName: '/home',
                            ),
                          );
                          break;
                        case 1:
                          Navigator.pushReplacement(
                            // push -> Add route on stack
                            context,
                            FadeInRoute(
                              // FadeInRoute  // ZoomInRoute  // RotationInRoute
                              page: const SearchScreen(from: "home"),
                              //ContactScreen(),
                              routeName: '/search',
                            ),
                          );
                          break;
                        case 2:
                          Navigator.pushReplacement(
                            // push -> Add route on stack
                            context,
                            FadeInRoute(
                              // FadeInRoute  // ZoomInRoute  // RotationInRoute
                              page: const GardenScreen(from: "home"),
                              //ContactScreen(),
                              routeName: '/myGarden',
                            ),
                          );
                          break;
                      }
                      initiateSetState();
                    },
                  )
                : const SizedBox(),
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        // DEEP BLUE DARK
                        colors: global.themeAppDark
                            ? global.ColorTheme().colorsViewBackgroundDark
                            : global.ColorTheme()
                                .colorsViewModernBackgroundLight,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      child: SingleChildScrollView(
                          controller: controllerView,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              /// TOP VIEW  --------------------------------------------------

                              /// Top view Banner
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                height: 105,
                                color: global.themeAppDark
                                    ? Colors.black
                                    : Colors.green,
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                  ),
                                  child: Text("My account",
                                      style: TextStyle(
                                        color: Colors.greenAccent.shade100,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'meri',
                                        fontSize: 34,
                                      )),
                                )),
                              ),

                              const SizedBox(
                                height: 50,
                              ),

                              /// MANAGEMENT PROFILE CONNECTIVITY ---------------------------
                              Stack(
                                children: [
                                  /// Profile picture
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,

                                      /// ZOOM profile
                                      onTap: () async {
                                        if (flagProfileEdit) {
                                          flagProfileEdit = false;
                                          flagStatusConnexion = false;
                                        } else {
                                          flagProfileZoom = !flagProfileZoom;
                                        }
                                        initiateSetState();
                                      },
                                      onLongPress: () {
                                        if (flagProfileZoom) {
                                          flagProfileZoom = false;
                                        } else {
                                          flagProfileEdit = !flagProfileEdit;
                                        }
                                        initiateSetState();
                                      },

                                      onDoubleTap: () {
                                        showFullImage();
                                      },
                                      child: AnimatedSize(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve: Curves.decelerate,
                                          child: Hero(
                                              tag: 'user',
                                              child: Container(
                                                width: (orientationPortrait &&
                                                        flagProfileZoom)
                                                    ? screenWidth * 0.8
                                                    : (!orientationPortrait &&
                                                            flagProfileZoom)
                                                        ? screenWidth * 0.4
                                                        : 150,
                                                height: (orientationPortrait &&
                                                        flagProfileZoom)
                                                    ? screenHeight * 0.4
                                                    : (!orientationPortrait &&
                                                            flagProfileZoom)
                                                        ? screenHeight * 0.8
                                                        : 150,
                                                decoration: BoxDecoration(
                                                  image: global.currentUser
                                                          .profileUrl.isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                              global.currentUser
                                                                  .profileUrl),
                                                          fit: flagProfileZoom
                                                              ? BoxFit.cover
                                                              : BoxFit.cover,
                                                        )
                                                      : androidImageFile!
                                                              .path.isEmpty
                                                          ? DecorationImage(
                                                              image: const AssetImage(
                                                                  'assets/freeAvatar.jpg'),
                                                              fit: flagProfileZoom
                                                                  ? BoxFit.fill
                                                                  : BoxFit
                                                                      .cover,
                                                            )
                                                          : DecorationImage(
                                                              image: FileImage(
                                                                  androidImageFile!),
                                                              fit: flagProfileZoom
                                                                  ? BoxFit.fill
                                                                  : BoxFit
                                                                      .cover,
                                                            ),
                                                  border: Border.all(
                                                      color: flagProfileZoom
                                                          ? Colors.transparent
                                                          : global.currentUser
                                                                      .status ==
                                                                  0
                                                              ? Colors.grey
                                                              : global.currentUser
                                                                          .status ==
                                                                      1
                                                                  ? Colors.green
                                                                  : global.currentUser
                                                                              .status ==
                                                                          2
                                                                      ? Colors
                                                                          .red
                                                                          .shade400
                                                                      : Colors
                                                                          .white,
                                                      width: 5),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              120.0)),
                                                ),
                                              ))),
                                    ),
                                  ),

                                  /// EDIT profile
                                  flagProfileEdit
                                      ? Align(
                                          alignment: const Alignment(0.8, 0.8),
                                          child: ButtonCircle(
                                            tag: 'Edit photo',
                                            tip: 'Edit photo from gallery',
                                            icon: Icon(
                                              Icons.edit,
                                              color: global.themeAppDark
                                                  ? global.ColorTheme()
                                                      .colorFromDarkSub
                                                  : global.ColorTheme()
                                                      .colorDeepDark,
                                            ),
                                            colorBackground: global.themeAppDark
                                                ? Colors.white12
                                                : Colors.white,
                                            colorBorder: Colors.transparent,
                                            onPressed: () async {
                                              String olPath =
                                                  androidImageFile!.path;
                                              String newPath = '';
                                              await androidGetFromGallery();
                                              initiateSetState();
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                newPath =
                                                    androidImageFile!.path;
                                                if (olPath != newPath) {
                                                  /// ShowDialog Save profile picture
                                                  AlertDialogApp(
                                                          context: context,
                                                          onAccept: () async {
                                                            /// Save to database
                                                            databaseSaveProfilePicture(
                                                                global
                                                                    .currentUser
                                                                    .id,
                                                                androidImageFile!);
                                                            await Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                                () {});
                                                          },
                                                          onRefuse: () async {
                                                            /// Save to App cache
                                                            await global
                                                                .dataUser
                                                                .setString(
                                                                    'profile',
                                                                    androidImageFile!
                                                                        .path);
                                                          },
                                                          title:
                                                              'Share to Eden garden community ?',
                                                          body:
                                                              '\nThe photo will be public\nand save to Eden garden database',
                                                          accept: 'ACCEPT',
                                                          refuse: 'REFUSE')
                                                      .normalShowDialog();
                                                }
                                              });

                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                initiateSetState();
                                              });
                                            },
                                          ),
                                        )
                                      : const SizedBox(),

                                  flagProfileEdit
                                      ? Align(
                                          alignment: const Alignment(-0.8, 0.8),
                                          child: SizedBox(
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  ButtonCircle(
                                                    tag: 'status',
                                                    tip:
                                                        'Change status connexion',
                                                    icon: Icon(
                                                      Icons
                                                          .arrow_drop_down_circle_sharp,
                                                      color: global.themeAppDark
                                                          ? global.ColorTheme()
                                                              .colorFromDarkSub
                                                          : global.ColorTheme()
                                                              .colorDeepDark,
                                                    ),
                                                    colorBackground:
                                                        global.themeAppDark
                                                            ? Colors.white12
                                                            : Colors.white,
                                                    colorBorder:
                                                        Colors.transparent,
                                                    onPressed: () {
                                                      flagStatusConnexion =
                                                          !flagStatusConnexion;
                                                      initiateSetState();
                                                    },
                                                  ),
                                                  flagStatusConnexion
                                                      ? SlideAnimationController(
                                                          delay: 500,
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    global
                                                                        .currentUser
                                                                        .status = 0;
                                                                    initiateSetState();
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});
                                                                    dataBaseUpdate(
                                                                        global
                                                                            .currentUser
                                                                            .id,
                                                                        'status',
                                                                        0);
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});

                                                                    initiateSetState();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.grey,
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: Colors.grey,
                                                                                width: 3,
                                                                              ))),
                                                                      Text(
                                                                        'Offline',
                                                                        style:
                                                                            TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          color: global.themeAppDark
                                                                              ? global.ColorTheme().colorFromDark
                                                                              : global.ColorTheme().colorFromLight,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              'RobotMono',
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    global
                                                                        .currentUser
                                                                        .status = 1;
                                                                    initiateSetState();
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});
                                                                    dataBaseUpdate(
                                                                        global
                                                                            .currentUser
                                                                            .id,
                                                                        'status',
                                                                        1);
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});
                                                                    initiateSetState();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.green,
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: Colors.green,
                                                                                width: 3,
                                                                              ))),
                                                                      Text(
                                                                        'Online',
                                                                        style:
                                                                            TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          color: global.themeAppDark
                                                                              ? global.ColorTheme().colorFromDark
                                                                              : global.ColorTheme().colorFromLight,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              'RobotMono',
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    global
                                                                        .currentUser
                                                                        .status = 2;
                                                                    initiateSetState();
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});
                                                                    dataBaseUpdate(
                                                                        global
                                                                            .currentUser
                                                                            .id,
                                                                        'status',
                                                                        2);
                                                                    await Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        () {});
                                                                    initiateSetState();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.red.shade400,
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: Colors.red.shade400,
                                                                                width: 3,
                                                                              ))),
                                                                      Text(
                                                                        'Busy',
                                                                        style:
                                                                            TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          color: global.themeAppDark
                                                                              ? global.ColorTheme().colorFromDark
                                                                              : global.ColorTheme().colorFromLight,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              'RobotMono',
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))
                                                            ],
                                                          ))
                                                      : const SizedBox(),
                                                ],
                                              )))
                                      : const SizedBox(),
                                ],
                              ),

                              /// --------------------------------------------------------

                              !flagProfileZoom
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, top: 10),
                                      child: SlideAnimationController(
                                        delay: 800,
                                        child: Text(
                                          global.currentUser.fullName,
                                          style: TextStyle(
                                            letterSpacing: 0.25,
                                            color: global.themeAppDark
                                                ? global.ColorTheme()
                                                    .colorFromDark
                                                : global.ColorTheme()
                                                    .colorFromLight,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'RobotMono',
                                            fontSize: 24,
                                          ),
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
                                padding: EdgeInsets.only(
                                    bottom: orientationPortrait ? 0 : 50),
                                height: orientationPortrait ? 100 : 110,
                                width: screenWidth,
                                child: SlideAnimationController(
                                    delay: 800,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              global.currentUser.myGardenObject
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                letterSpacing: 0.25,
                                                color: global.themeAppDark
                                                    ? global.ColorTheme()
                                                        .colorFromDarkSub
                                                    : global.ColorTheme()
                                                        .colorDeepDark,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'RobotMono',
                                                fontSize: 32,
                                              ),
                                            ),
                                            Text(
                                              'Garden Item ',
                                              style: TextStyle(
                                                letterSpacing: 0.25,
                                                color: global.themeAppDark
                                                    ? global.ColorTheme()
                                                        .colorFromDark
                                                    : global.ColorTheme()
                                                        .colorFromLight,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'RobotMono',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              global.currentUser
                                                  .myCommunityObject.length
                                                  .toString(),
                                              style: TextStyle(
                                                letterSpacing: 0.25,
                                                color: global.themeAppDark
                                                    ? global.ColorTheme()
                                                        .colorFromDarkSub
                                                    : global.ColorTheme()
                                                        .colorDeepDark,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'RobotMono',
                                                fontSize: 32,
                                              ),
                                            ),
                                            Text(
                                              'Community ',
                                              style: TextStyle(
                                                letterSpacing: 0.25,
                                                color: global.themeAppDark
                                                    ? global.ColorTheme()
                                                        .colorFromDark
                                                    : global.ColorTheme()
                                                        .colorFromLight,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'RobotMono',
                                                fontSize: 16,
                                              ),
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
                              ProfileBodyView(
                                profileZoom: flagProfileZoom,
                                screenWidth: screenWidth,
                                function: initiateSetState,
                              ),

                              ///---------------------------------------------------------------
                            ],
                          )),
                    ))));
  }

  /// Get from Gallery
  Future androidGetFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        androidImageFile = File(result.files.first.path!);
      });
    }
  }

  Future<dynamic> showFullImage() async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
                child: Container(
                    //padding: const EdgeInsets.only(bottom: 30,),
                    height: screenHeight,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(global.currentUser.profileUrl),
                          fit: BoxFit.cover),
                    ))),
          );
        });
  }

  Future<bool> _onWillPop() async {
    return (await AlertDialogApp(
            context: context,
            onAccept: () async {
              await dataBaseUpdate(global.currentUser.id, 'status', 0);
              global.currentUser = UserDB(id: 'id', fullName: 'fullName');
              setState(() => Navigator.pop(context));
            },
            onRefuse: () async {
              /*await service.showNotification(
            title: 'Title',
            body: 'Body',
            payloadDestination: 'UserCommunity',
            contextReceive: context,
          );

           */
            },
            title: 'Are you sure ?\n',
            body: 'Do you want to sign out ?',
            accept: 'YES',
            refuse: 'NO')
        .normalShowDialog());
  }
}
