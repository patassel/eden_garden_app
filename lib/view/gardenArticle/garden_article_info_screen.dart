import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/garden/garden_item.dart';
import 'package:eden_garden/view/user/user_garden_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/globals.dart' as global;

class GardenArticleInfoScreen extends StatefulWidget {
  final String from;
  final GardenItem item;
  final Function()? function;

  const GardenArticleInfoScreen({Key? key, required this.from, required this.item, required this.function}) : super(key: key) ;

  @override
  State<GardenArticleInfoScreen> createState() => _GardenArticleInfoScreenState();


}

class _GardenArticleInfoScreenState extends State<GardenArticleInfoScreen> {

  late String from;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController controllerView = ScrollController();

  late bool flagDescription = true;
  late bool flagEnvironment = false;
  late bool flagFarm = false;
  late bool flagManagement = false;

  late bool flagDatabaseRequest = false;
  late bool flagReturnDialog = false;

  /*late int nullQuantity;
  late bool nullNotification = false;
  late int nullProduction ;
  late Timestamp nullDate;

   */

  @override
  void initState() {
    super.initState();
    from = widget.from;
    /*nullQuantity = global.currentUser.myGarden[widget.item.idKey]?['quantity'] ?? -1;
    nullProduction = global.currentUser.myGarden[widget.item.idKey]?['production'] ?? -1;
    nullNotification = global.currentUser.myGarden[widget.item.idKey]?['notification'] ?? false;
    nullDate = global.currentUser.myGarden[widget.item.idKey]?['date'] ?? Timestamp(0, 0);

     */

  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    controllerView.dispose();
    super.dispose();
    //initiateSetState();
  }

  initiateSetState() {setState(() {});}

  void initiateInfoValues(){
    flagDescription = false;
    flagEnvironment = false;
    flagFarm = false;
    flagManagement = false;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: global.themeAppDark? Colors.black : Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.from=="search" ? Colors.green.shade800 : Colors.lightGreen.shade300),
            onPressed: () {
              Navigator.of(context).pop(context);
              setState(() {
                widget.function!();
              });
            },
          ),
          centerTitle: true,
          title: Text(
            widget.item.idKey,
            style: TextStyle(fontSize: 34, color: widget.from=="search" ? Colors.green.shade800 : Colors.lightGreen.shade300,
                fontWeight: FontWeight.w400, fontFamily: 'meri'),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (!flagDescription && !flagFarm && !flagEnvironment && !flagManagement) ?

        SlideAnimationController( delay: 800, child:

            Container(
              height: 100,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child:

            Stack(

              children: [
                (!flagDescription && !flagFarm && !flagEnvironment && from=='garden')?
                    Align(
                      alignment: Alignment.bottomLeft,
                      child:
                      FloatingActionButton(
                        heroTag: 'Management',
                        autofocus: true,
                        focusElevation: 5,
                        backgroundColor: global.themeAppDark ? Colors.white12 : Colors.white,
                        tooltip: 'Open ${widget.item.idKey} management',
                        child: Icon(Icons.inventory, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),

                        /*shape: StadiumBorder(
                            side: BorderSide(
                                color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorFromLight,
                                width: 4)),

                         */
                        onPressed: () {
                          Navigator.push(  // push -> Add route on stack
                            context,
                            FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                              page: UserGardenItemScreen(item: widget.item), //ContactScreen(),
                              routeName: 'garden/${widget.item.idKey}/management',
                            ),
                          );
                        },

                      )) : const SizedBox(),

                      Align(
                        alignment: Alignment.bottomRight,
                        child:
                        FloatingActionButton(
                        heroTag: 'Action',
                        autofocus: true,
                        focusElevation: 5,
                        backgroundColor: global.themeAppDark ? Colors.white12 : Colors.white,
                        tooltip: from=='search' ? 'Add to my Eden garden' : 'Snatch from my Eden garden',
                        /*shape: StadiumBorder(
                            side: BorderSide(
                                color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorFromLight,
                                width: 4)),
                         */
                        onPressed: () async {
                          if (from=='search'){
                            /// Check if Garden item already exist in my garden list
                            flagDatabaseRequest = global.currentUser.addGardenItem(widget.item);
                          }else {
                            /// Check if Garden item doesn't exist in my garden list
                            flagDatabaseRequest =
                                global.currentUser.removeGardenItem(widget.item);
                          }
                          initiateInfoValues();
                          flagReturnDialog = true;
                          await Future.delayed(const Duration(milliseconds: 100), () {});
                          initiateSetState();
                          await Future.delayed(const Duration(milliseconds: 500), () {});

                          controllerView.jumpTo(
                          controllerView.position.maxScrollExtent);
                        },

                        child: Icon(from=="search" ? Icons.add_circle : Icons.delete, color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,),
                      )),
              ],
            ))


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
              controller: controllerView,
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  /// Top View -----------------------------------------------------

                  Container(
                  padding: const EdgeInsets.only(bottom: 10,),
                  height: 100,
                  color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
                  child: Center(
                      child:ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: orientationPortrait ? 50 : 150, right: orientationPortrait ? 50: 150, top: 20),
                        children: <Widget>[


                          GestureDetector(
                              onTap: () async {
                                flagDescription = !flagDescription;
                                flagEnvironment = false;
                                flagFarm = false;
                                flagManagement = false;

                                flagReturnDialog = false;
                                await Future.delayed(const Duration(milliseconds: 100), () {});
                                initiateSetState();

                                if(flagDescription) {
                                  controllerView.jumpTo(
                                      controllerView.position.maxScrollExtent);
                                }else{
                                  controllerView.jumpTo(
                                      controllerView.position.minScrollExtent);
                                }
                                await Future.delayed(const Duration(milliseconds: 900), () {});

                              },
                              child :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  global.themeAppDark ? Icon(Icons.info_outline, size: 35, color: flagDescription ? Colors.lightGreen : Colors.white,) : Icon(Icons.info_outline, size: 35, color: flagDescription ? Colors.lightGreen : Colors.black,),

                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 500),
                                    child: Text(
                                        "Description",
                                        style :TextStyle(
                                          color: (global.themeAppDark && flagDescription) ? Colors.lightGreen : (!global.themeAppDark && flagDescription) ?  Colors.lightGreen : (!global.themeAppDark && !flagDescription) ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'RobotMono',
                                          fontSize: flagDescription ? 24 : 18,)
                                    ),)

                                ],)
                          ),
                          SizedBox(width: orientationPortrait ? screenWidth*0.3 : screenWidth*0.4,),
                          GestureDetector(
                              onTap: () async {
                                flagEnvironment = !flagEnvironment;
                                flagDescription = false;
                                flagFarm = false;
                                flagManagement = false;
                                flagReturnDialog = false;
                                await Future.delayed(const Duration(milliseconds: 100), () {});
                                initiateSetState();

                                if(flagEnvironment) {
                                  controllerView.jumpTo(
                                      controllerView.position.maxScrollExtent);
                                }else{
                                  controllerView.jumpTo(
                                      controllerView.position.minScrollExtent);
                                }
                                await Future.delayed(const Duration(milliseconds: 900), () {});

                              },
                              child :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  global.themeAppDark ? Icon(Icons.terrain_outlined, size: 35, color: flagEnvironment ? Colors.lightGreen : Colors.white,) : Icon(Icons.terrain_outlined, size: 35, color: flagEnvironment ? Colors.lightGreen : Colors.black,),

                                  AnimatedSize(
                                      duration: const Duration(milliseconds: 500),
                                      child:  Text(
                                          "Environment",
                                          style :TextStyle(
                                            color: (global.themeAppDark && flagEnvironment) ? Colors.lightGreen : (!global.themeAppDark && flagEnvironment) ?  Colors.lightGreen : (!global.themeAppDark && !flagEnvironment) ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'RobotMono',
                                            fontSize: flagEnvironment ? 24 : 18,)
                                      )),
                                ],)
                          ),

                          SizedBox(width: screenWidth*0.38,),
                          GestureDetector(
                              onTap: () async {
                                flagFarm = !flagFarm;
                                flagDescription = false;
                                flagEnvironment = false;
                                flagManagement = false;

                                flagReturnDialog = false;
                                await Future.delayed(const Duration(milliseconds: 100), () {});
                                initiateSetState();

                                if(flagFarm) {
                                  controllerView.jumpTo(
                                      controllerView.position.maxScrollExtent);
                                }else{
                                  controllerView.jumpTo(
                                      controllerView.position.minScrollExtent);
                                }
                                await Future.delayed(const Duration(milliseconds: 900), () {});

                              },
                              child :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  global.themeAppDark ? Icon(Icons.grass, size: 35, color: flagFarm ? Colors.lightGreen : Colors.white,) : Icon(Icons.grass, size: 35, color: flagFarm ? Colors.lightGreen : Colors.black,),

                                  AnimatedSize(
                                      duration: const Duration(milliseconds: 500),
                                      child:  Text(
                                          "Farm",
                                          style :TextStyle(
                                            color: (global.themeAppDark && flagFarm) ? Colors.lightGreen : (!global.themeAppDark && flagFarm) ?  Colors.lightGreen : (!global.themeAppDark && !flagFarm) ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'RobotMono',
                                            fontSize: flagFarm ? 24 : 18,)
                                      )),
                                ],)
                          ),

                        ],
                      ),
                  )
              ),
              /// --------------------------------------------------------------

                  /// Image of Garden item
                  flagDescription || (!flagDescription && !flagFarm && !flagEnvironment && !flagManagement)?
                  GestureDetector(
                    onLongPress: () async {
                      await showFullImage();
                    },
                    child:

                    AnimatedSize(
                      duration: const Duration(seconds: 1),
                      child:
                        Container(
                          margin: EdgeInsets.only(top: orientationPortrait ? 30 : 0, bottom: 10,),
                          height: (!flagDescription && !flagFarm && !flagEnvironment && !flagManagement) ? 300 : 200,
                          width: screenWidth,
                          decoration : BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("https://${widget.item.image}"),
                                fit: BoxFit.cover
                            ),
                            gradient: LinearGradient(
                              // DEEP BLUE DARK
                              colors: global.themeAppDark ? global.ColorTheme().colorsViewNormalBackgroundLight
                                  : global.ColorTheme().colorsViewNormalBackgroundLight,

                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),

                          ),
                        )),
                  ) : const SizedBox(),






                  /// general description
                  flagDescription? SlideAnimationController(delay: 500, child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: EdgeInsets.only(left: 20, bottom: 5, top: 20),
                              child:Text("Scientific name",
                                  style: TextStyle(
                                    color: Colors.green,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 24,))),
                          ),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: const EdgeInsets.only(left : 20, bottom: 10),
                              child: Text(widget.item.scientist,
                                  style: TextStyle(
                                    color: global.themeAppDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 16,)),
                            ),
                          ),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                              child: Text("Species",
                                  style: TextStyle(
                                    color: Colors.green,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 24,)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                              child: Text(widget.item.species,
                                  style: TextStyle(
                                    color: global.themeAppDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 16,)),
                            ),
                          ),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                              child: Text("Product",
                                  style: TextStyle(
                                    color: Colors.green,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 24,)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                              child: Text(widget.item.product,
                                  style: TextStyle(
                                    color: global.themeAppDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 16,)),
                            ),
                          ),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                              child: Text("Description",
                                  style: TextStyle(
                                    color: Colors.green,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 24,)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                              child: Text(widget.item.description,
                                  style: TextStyle(
                                    color: global.themeAppDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'RobotMono',
                                    fontSize: 16,)),
                            ),
                          ),


                        ],
                      )
                    ],
                  )) : const SizedBox(),

              /// Environment
              flagEnvironment? SlideAnimationController(delay: 500, child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(left: 20, bottom: 5, top: 20),
                            child:Text("Cultivation",
                                style: TextStyle(
                                  color: Colors.green,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 24,))),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: const EdgeInsets.only(left : 20, bottom: 10),
                          child: Text(widget.item.environment,
                              style: TextStyle(
                                color: global.themeAppDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 16,)),
                        ),
                      ),


                    ],
                      )
                    ],
                  )) : const SizedBox(),

              /// Farm instruction
              flagFarm? SlideAnimationController(delay: 500, child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(left: 20, bottom: 5, top: 20),
                            child:Text("Sprinkle",
                                style: TextStyle(
                                  color: Colors.green,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'RobotMono',
                                  fontSize: 24,))),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: const EdgeInsets.only(left : 20, bottom: 10),
                          child: Text(widget.item.sprinkle,
                              style: TextStyle(
                                color: global.themeAppDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 16,)),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                          child: Text("Prune",
                              style: TextStyle(
                                color: Colors.green,
                                letterSpacing: 0.25,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 24,)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                          child: Text(widget.item.prune,
                              style: TextStyle(
                                color: global.themeAppDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 16,)),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                          child: Text("Harvest",
                              style: TextStyle(
                                color: Colors.green,
                                letterSpacing: 0.25,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 24,)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                          child: Text(widget.item.harvest,
                              style: TextStyle(
                                color: global.themeAppDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 16,)),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: EdgeInsets.only(left : 20, bottom: 5),
                          child: Text("Farm",
                              style: TextStyle(
                                color: Colors.green,
                                letterSpacing: 0.25,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 24,)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(padding: const EdgeInsets.only(left : 20 , bottom: 10),
                          child: Text(widget.item.farm,
                              style: TextStyle(
                                color: global.themeAppDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotMono',
                                fontSize: 16,)),
                        ),
                      ),
                    ],
                  )
                ],
              )) : const SizedBox(),

              /// Return dialog
              flagReturnDialog ? SlideAnimationController(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, left: 10),
                    child: Center(child :Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        SlideAnimationController(
                            delay: 800,
                            child: flagDatabaseRequest ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 38,) : const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 38,)
                        ),
                        const SizedBox(height: 20,),

                        SlideAnimationController(
                          delay: 1000,
                          child: flagDatabaseRequest ? const Text(
                            "Database request done with success!\n",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ) : const Text(
                            "Sorry! Database request failed...\n",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ),

                        SlideAnimationController(
                          delay: 1500,
                          child: Text(
                              (widget.from=="search" && !flagDatabaseRequest) ?
                              "${widget.item.idKey} already exist in your garden" :
                              (widget.from=="garden" && !flagDatabaseRequest) ?
                              "Database cannot delete ${widget.item.idKey}, try again." :
                              (widget.from=="search" && flagDatabaseRequest) ?
                                  "${widget.item.idKey} have been added to your garden" :
                              (widget.from=="garden" && flagDatabaseRequest) ?
                              "${widget.item.idKey} have been deleted from garden" : "Hello World",
                          style:TextStyle(fontSize: 16, color: flagDatabaseRequest ? Colors.green : Colors.red,)),

                        )
                      ],
                    )),
                  )
              ) : const SizedBox(),


                  SizedBox(height: flagReturnDialog? 50 : 0,)

                  ///---------------------------------------------------------



            ],
          )),
        )
    );
  }

  Future<dynamic> showFullImage() async{
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
                            image: NetworkImage("https://${widget.item.image}"),
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
