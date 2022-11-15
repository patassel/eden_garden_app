import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/garden/garden_item.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/globals.dart' as global;

class UserGardenItemScreen extends StatefulWidget {
  final GardenItem item;
  //final Function()? function;

  const UserGardenItemScreen({Key? key,required this.item}) : super(key: key) ;

  @override
  State<UserGardenItemScreen> createState() => _UserGardenItemScreenState();


}

class _UserGardenItemScreenState extends State<UserGardenItemScreen> {

  late String from;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //late ScrollController controllerView = ScrollController();

  Timer? timer;

  late int nullQuantity;
  late int nullProduction ;
  late int nullRipe;
  late int nullRotten ;
  late List<dynamic> nullNotification = [];
  late Timestamp nullDate;

  late bool flagQuantity = false;
  late bool flagProduction = false;
  late bool flagRipe = false;
  late bool flagRotten = false;
  late bool flagEditSave = true;  // Edit : false , Sav

  // e : true



  @override
  void initState() {
    super.initState();
    nullQuantity = global.currentUser.myGarden[widget.item.idKey]?['quantity'] ?? -1;
    nullProduction = global.currentUser.myGarden[widget.item.idKey]?['production'] ?? -1;
    nullRipe = global.currentUser.myGarden[widget.item.idKey]?['ripe'] ?? -1;
    nullRotten = global.currentUser.myGarden[widget.item.idKey]?['rotten'] ?? -1;
    nullNotification = global.currentUser.myGarden[widget.item.idKey]?['notification'] ?? [];
    nullDate = global.currentUser.myGarden[widget.item.idKey]?['date'] ?? Timestamp(0, 0);



  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    //controllerView.dispose();
    super.dispose();
    //initiateSetState();
  }

  initiateSetState() {setState(() {});}


  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        key: scaffoldKey,

        drawer:  AppDrawer(from: "gardenUser", function: initiateSetState,),


        /// Footer View
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: ButtonCircle(
          tag: 'edit/save',
          tip: flagEditSave ? 'Edite' : 'Save new management',
          icon: Icon(flagEditSave ? Icons.edit : Icons.save_alt, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
          colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
          colorBorder: Colors.transparent,
          onPressed: () {
            flagEditSave = !flagEditSave;
            flagQuantity = false;
            flagProduction = false;
            flagRipe = false;
            flagRotten = false;

            if(flagEditSave){
              //print("save");
              addToDatabase();
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
                    : global.ColorTheme().colorsViewModernBackgroundLight,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )
          ),

          child:
          SingleChildScrollView(
              //controller: controllerView,
              child:
                  SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child:
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [

                      /// Top View

                        buildTopView(),

                      /// Body management --------------------------------------
                      buildGeneralManagement(),

                      /// RIPE-ROTTEN ------------------------------------------
                      buildRipeRottenWidget(),

                      /// Footer -----------------------------------------------
                      Align(
                        alignment: Alignment.bottomLeft,
                        child :
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 10),
                            child: Text(
                              'Planted ${nullDate.toDate().day} / ${nullDate.toDate().month} / ${nullDate.toDate().year}',
                              style: TextStyle(fontSize: 16, color: global.themeAppDark ? Colors.white70 : Colors.black,
                                  fontWeight: FontWeight.w400, fontFamily: 'meri'),
                            ),
                          )
                      ),

                      /// Footer -----------------------------------------------

                    ],
                  ),
                  )
          ),
        )
    );
  }


  Widget buildRipeRottenWidget(){
    return
      /// RIPE-ROTTEN ------------------------------------------
      Align(
          alignment: orientationPortrait? const Alignment(0,0.5) : const Alignment(0.7,0),
          child :
          SizedBox(
              height: orientationPortrait? 180 : 140,
              width : orientationPortrait ? screenWidth : screenWidth/3,
              child :

              Row(
                mainAxisAlignment: orientationPortrait ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [


                  GestureDetector(
                    onTap: (){
                      flagRipe=!flagRipe;
                      initiateSetState();
                      },
                    child: SizedBox(
                        height: orientationPortrait? 180 : 130,
                      width: orientationPortrait ? screenWidth*0.45: screenWidth*0.15,
                      child:

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(nullRipe.toString(),
                              style:TextStyle(
                                letterSpacing: 0.25,
                                color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: orientationPortrait ? 32 : 24,),
                            ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Ripe",
                                    style: TextStyle(
                                      color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'RobotMono',
                                      fontSize: orientationPortrait ? 24 : 16,)
                                ),
                                Padding(padding: const EdgeInsets.only(top: 20),
                                    child:
                                    Text(' Gram', style: TextStyle(
                                      color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'RobotMono',
                                      fontSize: orientationPortrait ? 16 : 8,))
                                )
                              ]
                          ),

                            (flagRipe&& !flagEditSave)? SlideAnimationController(child:buildValueButtonCircle({'ripe':nullRipe}))
                              : const SizedBox(),

                        ],
                      ))
                  ),


                  VerticalDivider(
                    color: global.themeAppDark ? Colors.white30 : Colors.black12,
                    thickness: 2,
                  ),

                GestureDetector(
                  onTap: (){
                    flagRotten=!flagRotten;
                    initiateSetState();
                  },
                  child: SizedBox(
                      height: orientationPortrait? 180 : 130,
                      width: orientationPortrait ? screenWidth*0.45 : screenWidth*0.15,
                      child:

                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(nullRotten.toString(),
                          style:TextStyle(
                            letterSpacing: 0.25,
                            color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RobotMono',
                            fontSize: orientationPortrait ? 32 : 24,),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Rotten",
                                style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: orientationPortrait ? 24 : 16,)
                            ),
                            Padding(padding: const EdgeInsets.only(top: 20),
                                child:
                                Text(' Gram', style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: orientationPortrait ? 16 : 8,))
                            )
                          ]
                      ),


                        (flagRotten && !flagEditSave)? SlideAnimationController(child: buildValueButtonCircle({'rotten':nullRotten}))
                          : const SizedBox(),
                    ],
                  ))),
                ],
              )
          )
      );
    /// RIPE-ROTTEN ------------------------------------------
  }



  Widget buildTopView(){
    return
      /// TOP View -------------------------------------
      Align(
        alignment: Alignment.topCenter,
        child :
      SizedBox(
        //margin: const EdgeInsets.all(50),
          height: orientationPortrait ? 150 : 100,
          width: screenWidth,
          child:
          Stack(
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  SlideAnimationController(
                    child: Text(
                      widget.item.idKey,
                      style: TextStyle(fontSize: 34, color: Colors.lightGreen.shade300,
                          fontWeight: FontWeight.w400, fontFamily: 'meri'),
                    ),
                  )
              ),

              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: ButtonCircle(
                      tag: 'notification',
                      tip: 'Notification management',
                      icon: Icon(Icons.notifications, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                      colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                      colorBorder: Colors.transparent,
                      onPressed: () {
                        /*
                                                    TODO Notification management show dialog
                                                     */
                      },

                    ),
                  )
              ),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: ButtonCircle(
                      tag: 'setting',
                      tip: 'Settings management',
                      icon: Icon(Icons.settings, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                      colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                      colorBorder: Colors.transparent,
                      onPressed: () {
                        /*
                                                    TODO Settings management show dialog
                                                     */
                      },

                    ),
                  )
              )
            ],
          )
      ));
    /// TOP View -------------------------------------
  }

  Widget buildGeneralManagement(){
    return /// Button General -------------------------------

      Align(
        alignment: orientationPortrait ?  const Alignment(0,-0.3) : Alignment.centerLeft,
        child:
      Container(
        margin: const EdgeInsets.all(40),
        width: orientationPortrait ? screenWidth*0.8 : screenWidth*0.4,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
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
          mainAxisSize: MainAxisSize.min,
          children: [

            AnimatedSize(duration: const Duration(milliseconds: 800), child :
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  GestureDetector(
                    onTap: (){
                      if (!flagEditSave) {
                        flagQuantity = !flagQuantity;
                        flagProduction = false;
                        initiateSetState();
                      }
                    },
                    child: ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Quantity",
                                style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,)
                            ),
                            Padding(padding: const EdgeInsets.only(top: 20),
                                child:
                                Text(nullQuantity>1?' Plants' : ' Plant', style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 8,))
                            )
                          ]
                      ),
                      trailing:
                      Text(nullQuantity.toString(), style: TextStyle(
                        color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'RobotMono',
                        fontSize: 16,)),

                    ),
                  ),

                  flagQuantity && !flagEditSave ?
                  buildValueButtonCircle({'qtty' : nullQuantity}) : const SizedBox()
                ]
            )
            ),


            SizedBox(
              width: screenWidth,
              child: const Divider(
                color: Colors.black12,
                thickness: 10,
              ),),

            AnimatedSize(duration: const Duration(milliseconds: 800), child :
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  GestureDetector(
                    onTap: (){
                      if (!flagEditSave) {
                        flagProduction = !flagProduction;
                        flagQuantity = false;

                        initiateSetState();
                      }
                    },
                    child: ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Production",
                                style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDark  : global.ColorTheme().colorFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 16,)
                            ),
                            Padding(padding: const EdgeInsets.only(top: 20),
                                child:
                                Text(' Gram', style: TextStyle(
                                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 8,)))
                          ]
                      ),

                      trailing:
                      Text(nullProduction.toString(), style: TextStyle(
                        color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub  : global.ColorTheme().buttonFromLight ,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'RobotMono',
                        fontSize: 16,)),

                    ),
                  ),

                  flagProduction && !flagEditSave ?
                  buildValueButtonCircle({'prod':nullProduction}) : const SizedBox()
                ])
            )

          ],
        ),
      ));
  }

  Widget buildValueButtonCircle(Map<String,dynamic> value){
    var res = value[value.keys.first];
    return Container(
      height: orientationPortrait ? 100 : 50,
      padding: (value.keys.first=='qtty' || value.keys.first=='prod') ? const EdgeInsets.only(bottom: 10)
          :  const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: (value.keys.first=='qtty' || value.keys.first=='prod') ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
              onTap: () => setState(() {
                res++;
                switch (value.keys.first) {
                  case 'qtty':
                    nullQuantity = res;
                    break;
                  case 'prod':
                    nullProduction = res;
                    break;
                  case 'ripe':
                    nullRipe = res;
                    break;
                  case 'rotten':
                    nullRotten = res;
                    break;
                }
              }),
              onLongPress: () => setState(() {
                timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {

                  if (timer.tick>50 && timer.tick<80) {
                    setState(() {
                    res+=10;
                    });
                  }else if (timer.tick>80 && timer.tick<120) {
                    setState(() {
                      res+=50;
                    });
                  }else if (timer.tick>120 && timer.tick<180) {
                    setState(() {
                      res+=100;
                    });
                  }else if (timer.tick>180 && timer.tick<230) {
                    setState(() {
                      res+=500;
                    });
                  }else if (timer.tick>230) {
                    setState(() {
                      res+=1000;
                    });
                  }else{
                    setState(() {
                      res++;
                    });
                  }
                  switch (value.keys.first) {
                    case 'qtty':
                      nullQuantity = res;
                      break;
                    case 'prod':
                      nullProduction = res;
                      break;
                    case 'ripe':
                      nullRipe = res;
                      break;
                    case 'rotten':
                      nullRotten = res;
                      break;
                  }
                });
              }),

              onLongPressEnd: (_) => setState(() {
                //print(timer!.tick.toString());
                timer?.cancel();
              }),
              child:
              Container(
                  height: orientationPortrait ? 50 : 25,
                  width: orientationPortrait ? 50 : 25,
                  decoration: BoxDecoration(
                    color: global.themeAppDark ? Colors.white70 : Colors.black12,
                    borderRadius: const BorderRadius.all(Radius.circular(90.0)),
                  ),
                  child:
                  Center(
                    child: Icon(Icons.add_circle_outline, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                  )

              )),

          //(value.keys.first == 'ripe' || value.keys.first == 'rotten') ? const SizedBox(width: 10,) : const SizedBox(),

          GestureDetector(
              onTap: () => setState(() {
                res--;
                if(res<0){res=0;}
                switch (value.keys.first) {
                  case 'qtty':
                    nullQuantity = res;
                    break;
                  case 'prod':
                    nullProduction = res;
                    break;
                  case 'ripe':
                    nullRipe = res;
                    break;
                  case 'rotten':
                    nullRotten = res;
                    break;
                }
              }),
              onLongPress: () => setState(() {
                timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
                  setState(() {

                    if (timer.tick>50 && timer.tick<80) {
                      setState(() {
                        res-=10;
                      });
                    }else if (timer.tick>80 && timer.tick<120) {
                      setState(() {
                        res-=50;
                      });
                    }else if (timer.tick>120 && timer.tick<180) {
                      setState(() {
                        res-=100;
                      });
                    }else if (timer.tick>180 && timer.tick<230) {
                      setState(() {
                        res-=500;
                      });
                    }else if (timer.tick>230) {
                      setState(() {
                        res-=1000;
                      });
                    }else{
                      setState(() {
                        res--;
                      });
                    }
                    if(res<0){res=0;}

                    switch (value.keys.first) {
                      case 'qtty':
                        nullQuantity = res;
                        break;
                      case 'prod':
                        nullProduction = res;
                        break;
                      case 'ripe':
                        nullRipe = res;
                        break;
                      case 'rotten':
                        nullRotten = res;
                        break;
                    }

                  });
                });
              }),

              onLongPressEnd: (_) => setState(() {
                timer?.cancel();
              }),
              child:
              Container(
                  height: orientationPortrait ? 50 : 25,
                  width: orientationPortrait ? 50 : 25,
                  decoration: BoxDecoration(
                    color: global.themeAppDark ? Colors.white70 : Colors.black12,
                    borderRadius: const BorderRadius.all(Radius.circular(90.0)),
                  ),
                  child:
                  Center(
                    child: Icon(Icons.remove_circle_outline, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                  )

              ))
        ],
      ),
    );
  }

  void addToDatabase(){
    global.currentUser.myGarden[widget.item.idKey] =
    {
      'quantity' : nullQuantity,
      'production' : nullProduction,
      'ripe' : nullRipe,
      'rotten' : nullRotten,
      'notification' : nullNotification,
      'date' : nullDate,
    };
    
    try {
      dataBaseUpdate(global.currentUser.id, 'garden', global.currentUser.myGarden);
    } on Exception catch (e) {
      print(e);
    }
    
  }

}
