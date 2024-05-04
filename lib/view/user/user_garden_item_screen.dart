import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/model/button/button_rect.dart';
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
  late Timestamp nullDate;

  late List<dynamic> checkSave;

  late List<dynamic> nullNotification = []; // default : []
  late List<dynamic> nullSettings = []; // default : [false, false, Timestamp.now(),],

  /// General values
  late bool flagQuantity = false;
  late bool flagProduction = false;
  late bool flagRipe = false;
  late bool flagRotten = false;

  /// Settings values
  late bool flagSize = false; /// false = gram
  late bool flagShowDate = false;

  /// Saving mode
  late bool flagSave = false;  // Edit : false , Sav


  @override
  void initState() {
    super.initState();
    nullQuantity = global.currentUser.myGarden[widget.item.idKey]?['quantity'] ?? -1;
    nullProduction = global.currentUser.myGarden[widget.item.idKey]?['production'] ?? -1;
    nullRipe = global.currentUser.myGarden[widget.item.idKey]?['ripe'] ?? -1;
    nullRotten = global.currentUser.myGarden[widget.item.idKey]?['rotten'] ?? -1;
    nullDate = global.currentUser.myGarden[widget.item.idKey]?['date'] ?? Timestamp(0, 0);

    nullNotification = global.currentUser.myGarden[widget.item.idKey]?['notification'] ?? [];
    nullSettings = global.currentUser.myGarden[widget.item.idKey]?['settings'] ?? [];

    checkSave=[nullQuantity, nullProduction, nullRipe, nullRotten, nullDate];
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    //controllerView.dispose();
    super.dispose();
    //initiateSetState();
  }

  initiateSetState() {

    if (!checkSave.contains(nullQuantity) || !checkSave.contains(nullProduction) || !checkSave.contains(nullRipe) || !checkSave.contains(nullRotten) || !checkSave.contains(nullDate)){
      flagSave = true;
    }else{
      flagSave = false;
    }
    setState(() {});
  }


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
        floatingActionButton: flagSave ? ButtonCircle(
          tag: 'save',
          tip: 'Save new management',
          icon: Icon(Icons.save_alt, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
          colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
          colorBorder: Colors.transparent,
          onPressed: () {
            flagQuantity = false;
            flagProduction = false;
            flagRipe = false;
            flagRotten = false;
            addToDatabase();
            checkSave=[nullQuantity, nullProduction, nullRipe, nullRotten, nullDate];
            initiateSetState();
          },

        ) : const SizedBox(),


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
                      /// Top View

                      /// Body management --------------------------------------
                      buildGeneralManagement(),
                      /// Body management --------------------------------------

                      /// RIPE-ROTTEN ------------------------------------------
                      buildRipeRottenWidget(),
                      /// RIPE-ROTTEN ------------------------------------------

                      /// Footer -----------------------------------------------
                      buildFooterView(),
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

                            (flagRipe)? SlideAnimationController(child:buildValueButtonCircle({'ripe':nullRipe}))
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


                        (flagRotten)? SlideAnimationController(child: buildValueButtonCircle({'rotten':nullRotten}))
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
                        showDialogSettingsManagement();
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
                        flagQuantity = !flagQuantity;
                        flagProduction = false;
                        initiateSetState();
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

                  flagQuantity?
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
                        flagProduction = !flagProduction;
                        flagQuantity = false;

                        initiateSetState();

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

                  flagProduction ?
                  buildValueButtonCircle({'prod':nullProduction}) : const SizedBox()
                ])
            )

          ],
        ),
      ));
  }

  Widget buildFooterView() {
    return Align(
        alignment: Alignment.bottomLeft,
        child :
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10),
          child: Text(
            'Planted ${nullDate.toDate().day.toString().padLeft(2, '0')}/${nullDate.toDate().month.toString().padLeft(2, '0')}/${nullDate.toDate().year} at ${nullDate.toDate().hour.toString().padLeft(2, '0')} : ${nullDate.toDate().minute.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 16, color: global.themeAppDark ? Colors.white70 : Colors.black,
                fontWeight: FontWeight.w400, fontFamily: 'meri'),
          ),
        )
    );
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

                initiateSetState();
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
                initiateSetState();
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
                initiateSetState();
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
                initiateSetState();
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


  Future<void> showDialogSettingsManagement() {
    late bool flagSizeValue = nullSettings[0];
    late bool flagShowDate = nullSettings[0];

    TimeOfDay? timePlanted = TimeOfDay.fromDateTime(nullDate.toDate());
    DateTime? datePlanted = nullDate.toDate();

    return showDialog(
        context: context,
        builder:
        (context) => StatefulBuilder(builder : (context, setState)  =>  AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: const Center(child:
        SlideAnimationController(
            delay: 300,
            child:
            Text('Settings management', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'RobotMono',
              fontSize: 24,)),
        ),),

        content: SlideAnimationController(
            delay: 800,
            child:
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               children: [

                 ListTile(
                   leading: const Icon(Icons.science),
                   title: const Text('Change size', style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.w400,
                     fontFamily: 'RobotMono',
                     fontSize: 12,)),
                   subtitle: Text(flagSizeValue ? 'Kilogram' : 'Gram', style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                       : Colors.green)),
                   trailing: Switch(
                       value: flagSizeValue,
                       activeColor: Colors.redAccent,
                       onChanged: (val) {
                         setState(() {
                           flagSizeValue = val;
                         });
                       }),
                 ),

                 ListTile(
                   leading: const Icon(Icons.slideshow),
                   title: const Text('Show date', style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.w400,
                     fontFamily: 'RobotMono',
                     fontSize: 12,)),
                   subtitle: Text(flagShowDate ? 'Yes' : 'No', style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                       : Colors.green)),
                   trailing: Switch(
                       value: flagShowDate,
                       activeColor: Colors.redAccent,
                       onChanged: (val) {
                         setState(() {
                           flagShowDate = val;
                         });
                       }),
                 ),

                 ListTile(
                   leading: const Icon(Icons.slideshow),
                   title: const Text('Planted date', style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.w400,
                     fontFamily: 'RobotMono',
                     fontSize: 12,)),
                   subtitle: Text(
                       '${datePlanted!.day.toString().padLeft(2, '0')}/${datePlanted!.month.toString().padLeft(2, '0')}/${datePlanted!.year}',
                       style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                       : Colors.green, fontSize: 12)
                   ),
                   trailing: IconButton(
                     icon: const Icon(Icons.date_range),
                     onPressed: ()  async
                     {
                       datePlanted = await showDatePicker(context: context, initialDate: nullDate.toDate(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime(DateTime.now().year+5));
                       setState(() {
                       });
                     },
                   ),
                 ),

                 ListTile(
                   leading: const Icon(Icons.slideshow),
                   title: const Text('Planted time', style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.w400,
                     fontFamily: 'RobotMono',
                     fontSize: 12,)),
                   subtitle: Text('${timePlanted!.hour.toString().padLeft(2, '0')} :${timePlanted!.minute.toString().padLeft(2, '0')}', style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                       : Colors.green, fontSize: 12)
                   ),
                   trailing: IconButton(
                     icon: const Icon(Icons.access_time),
                     onPressed: ()
                     async {
                       timePlanted = await showTimePicker(context: context, initialTime: TimeOfDay(hour: nullDate.toDate().hour, minute: nullDate.toDate().minute));
                       setState(() {
                       });

                       },
                   ),
                 ),
               ],
             )
        ),

        actions: <Widget>[
          ButtonRect(
              title: "Cancel",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorDeepDark,
              onclickButton: () {
                setState(() =>Navigator.pop(context));
              },
              onHoverMouse: (val) {}
          ),

          ButtonRect(
              title: "Apply",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorDeepDark,
              onclickButton: () {
                nullDate = Timestamp.fromDate(DateTime(datePlanted!.year, datePlanted!.month, datePlanted!.day, timePlanted!.hour, timePlanted!.minute));
                initiateSetState();

                setState(() =>Navigator.pop(context));

              },
              onHoverMouse: (val) {}
          ),

        ],
      ),
    ));
  }

  void addToDatabase(){
    global.currentUser.myGarden[widget.item.idKey] =
    {
      'quantity' : nullQuantity,
      'production' : nullProduction,
      'ripe' : nullRipe,
      'rotten' : nullRotten,
      'date' : nullDate,
      'notification' : nullNotification,
      'settings' : nullSettings,
    };
    
    try {
      dataBaseUpdate(global.currentUser.id, 'garden', global.currentUser.myGarden);
    } on Exception catch (e) {
      print(e);
    }
    
  }

}
