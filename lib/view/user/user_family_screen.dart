

import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:eden_garden/model/widget/widget_grid_user_family.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;


class UserFamilyScreen extends StatefulWidget {

  final UserDB user ;
  final Function()? function;

  const UserFamilyScreen({Key? key, required this.user, this.function})
      : super(key: key);

  @override
  State<UserFamilyScreen>  createState() => _UserFamilyScreenState();

}


class _UserFamilyScreenState extends State<UserFamilyScreen> {

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController controllerView = ScrollController();
  late ScrollController controllerListView = ScrollController();

  late bool flagProfileZoom = false;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late List<bool> focusGardenPicture = List.filled(4, false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerView.dispose();
    controllerListView.dispose();
    super.dispose();
    //initiateSetState();
  }

  initiateSetState() {
    setState(() {});
  }
  void setOffAllValues(int pos){
    for (int i =0; i<3; i++){
      if (i!=pos) {
        focusGardenPicture[i] = false;
      }
    }
  }

  Future<void> actionTouchPicture(int index) async {
    focusGardenPicture[index] = !focusGardenPicture[index];
    setOffAllValues(index);
    initiateSetState();
    await Future.delayed(const Duration(milliseconds: 300), () {});
    controllerView.jumpTo(controllerView.position.maxScrollExtent);
    if(index==1) {
      controllerListView.jumpTo(
          controllerListView.position.maxScrollExtent / 2);
    }else if(index==0){
      controllerListView.jumpTo(
          controllerListView.position.minScrollExtent);
    }else{
      controllerListView.jumpTo(
          controllerListView.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return
      Scaffold(
          key: scaffoldKey,

          body: Container(
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
                        orientationPortrait ? Column(
                        children: [
                          const SizedBox(height: 45,),

                          /// Top view profile picture User
                          buildTopView(),

                          /// User name
                          buildTitleNameUser(),

                          /// Information user
                          buildGeneralInfoView(),
                        ],
                        ) : Stack(
                        children: [

                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                          /// Information user
                          buildGeneralInfoView(),
                          ),
                          Align(
                            alignment: const Alignment(0.5, 0.5),
                            child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Top view profile picture User
                                buildTopView(),
                                /// User name
                                buildTitleNameUser(),
                            ])),
                        ],
                  ),
                  /// Garden image user
                  buildBottomView(),

                ]
              )
          )
          )
      );
  }

  Widget buildTopView() {
    return
      /// TOP VIEW  --------------------------------------------------------
      /// GESTION PROFILE CONNECTIVITY ---------------------------
      Container(
        margin: const EdgeInsets.only(top: 15),
        height:  orientationPortrait ? 140 : 160,
        width: orientationPortrait ? 140 : 160,
        child:
        Stack(
          children: [
          /// Profile picture
          Align(alignment: Alignment.center,
            child:
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              /// ZOOM profile
              onTap: () async {
                initiateSetState();
              },
              onLongPress: () {
                initiateSetState();
              },

              onDoubleTap: () {
                if (widget.user.profileUrl.isNotEmpty) {
                  showFullImage(widget.user.profileUrl);
                }
              },
              child:
              Hero(
                  tag: 'user Profile',
                  child:
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      image:
                      widget.user.profileUrl.isNotEmpty ?
                      DecorationImage(
                        image:  NetworkImage(widget.user.profileUrl),
                        fit: BoxFit.cover,
                      ) :
                      const DecorationImage(
                        image:  AssetImage('assets/freeAvatar.jpg'),
                        fit: BoxFit.cover,
                      ) ,

                      border: Border.all(color
                          :widget.user.status==0 ? Colors.grey
                          :widget.user.status==1? Colors.green
                          :widget.user.status==2 ? Colors.red.shade400
                          : Colors.white,
                          width: 5),
                      borderRadius: const BorderRadius.all(Radius.circular(120.0)),

                    ),

                  )
              ),),
          ),


        ],
      ));
    /// --------------------------------------------------------
  }

  Widget buildTitleNameUser(){
    return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child:
        SlideAnimationController(
          delay: 800,
          child: Text(
            widget.user.fullName,
            style: TextStyle(
              letterSpacing: 0.25,
              color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
              fontWeight: FontWeight.w400,
              fontFamily: 'RobotMono',
              fontSize: 24,),
          ),
        ));
  }

  Widget buildGeneralInfoView() {
    return
      /// BANNER INFO GENERAL ------------------------------------------
      Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        padding: EdgeInsets.only(bottom: orientationPortrait ? 0 : 50),
        //height: orientationPortrait ? 100 : 110,
        width: orientationPortrait ? screenWidth : screenWidth*0.9,

        child:
        SlideAnimationController(
            delay: 800,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20, left: orientationPortrait ? 80 : 0),
                    height: 180,
                    width: orientationPortrait ? screenWidth*0.8 : screenWidth/2,
                    color: Colors.transparent,
                    alignment: Alignment.topLeft,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person, color: global.themeAppDark ? Colors.white12 : Colors.black45, size: 42,),
                              Text(' ${widget.user.pseudo}',
                                style:TextStyle(
                                  letterSpacing: 0.25,
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,),
                              ),
                            ],
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.email, color: global.themeAppDark ? Colors.white12 : Colors.black45, size: 42,),
                              Text(' ${widget.user.email}',
                                style:TextStyle(
                                  letterSpacing: 0.25,
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,),
                              ),
                            ],
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone, color: global.themeAppDark ? Colors.white12 : Colors.black45, size: 42,),
                              Text(' ${widget.user.phone}',
                                style:TextStyle(
                                  letterSpacing: 0.25,
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,),
                              ),

                            ],
                          ),


                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Icon(Icons.signal_wifi_statusbar_4_bar, color: global.themeAppDark ? Colors.white12 : Colors.black45, size: 42,),
                              Text(widget.user.status==0 ? ' Offline' : widget.user.status==2 ? ' Busy' : ' Online',
                                style:TextStyle(
                                  letterSpacing: 0.25,
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,),
                              ),
                            ],
                          ),
                        ])

                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(widget.user.myGardenObject.length.toString(),
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

                    GestureDetector(
                      onTap: (){
                        Navigator.push(  // push -> Add route on stack
                          context,
                          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                            page: WidgetGridUserFamily(user :widget.user), //ContactScreen(),
                            routeName: '/home/community/${widget.user.pseudo}/family',
                          ),
                        );

                      },
                      child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.user.myCommunity['family'].length.toString(),
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
                        )
                    ),
                  ],
                ),
              ],
            )
        ),
      );
  }

  Widget buildBottomView() {
    return
    Column(

      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          height: focusGardenPicture.contains(true) ? 250 : 190,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child:
          ListView.separated(
            controller: controllerListView,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SlideAnimationController(
                delay: 800+(400*index),
                  child: Center(child: buildFrontGardenPicture(index)));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: orientationPortrait ? 15 : 60,
              );
            },
            itemCount: 3,
          ),
        ),

        focusGardenPicture.contains(true) ?
        Text(
          (focusGardenPicture[0] && widget.user.myGardenPicture[0].isNotEmpty) ? widget.user.myGardenPicture[0]['message']
              :
          (focusGardenPicture[1] && widget.user.myGardenPicture[1].isNotEmpty)? widget.user.myGardenPicture[1]['message']
              :
          (focusGardenPicture[2] && widget.user.myGardenPicture[2].isNotEmpty)? widget.user.myGardenPicture[2]['message'] : '',
          style:TextStyle(
            letterSpacing: 0.25,
            color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
            fontWeight: FontWeight.w400,
            fontFamily: 'RobotMono',
            fontSize: 16,),
        ) : const SizedBox(),
      ],
    );
  }

  Widget buildFrontGardenPicture(int index){
    return AnimatedSize(
      duration: const Duration(milliseconds: 800),
      curve: Curves.ease,
      child:

          GestureDetector(
              onTap: () async {
                actionTouchPicture(index);
              },
              onDoubleTap: () async {
                if (widget.user.myGardenPicture[index]['locate'] == 'db'){
                  showFullImage(widget.user.myGardenPicture[index]['url']);
                  actionTouchPicture(index);
                }
              },

              onVerticalDragStart: (val) async {
                actionTouchPicture(index);
              },
              child:
              (widget.user.myGardenPicture[index].isNotEmpty && widget.user.myGardenPicture[index]['locate']=='db') ?
              Container(
                height: focusGardenPicture[index] ? 230 : 150,
                width: focusGardenPicture[index] ? 300 : 200,
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image:
                  DecorationImage(
                    image:  NetworkImage(widget.user.myGardenPicture[index]['url']),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                )
              ) : Container(
                  height: focusGardenPicture[index] ? 230 : 150,
                  width: focusGardenPicture[index] ? 300 : 200,
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: global.themeAppDark ? Colors.white12 : Colors.black12,
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),

                  child: const Center(child:Image(
                    image:  AssetImage('assets/addPicture.jpg'),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ))
              ),
          ),

      );
  }



  Future<dynamic> showFullImage(String url) async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),

              child: Center(
                  child:
                  Container(
                    //padding: const EdgeInsets.only(bottom: 30,),
                      height: screenHeight,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover
                        ),
                      )
                  )
              ),
            );

        }
    );
  }

}