
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/gardenArticle/garden_article_info_screen.dart';
import 'package:eden_garden/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';

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
  late ScrollController controllerView = ScrollController();

  late bool flagCharts = false;
  late bool flagChartsFilter = false;   // false:Type - true:VFO

  late bool flagGarden = true;

  late List<int> countType = [];

  Map<String, double> dataMapChartType = {
    "Herbs": 5,
    "Trees": 3,
    "Shrubs": 2,
    "Creepers":4,
    "Climbers":2
  };

  Map<String, double> dataMapChartVFO = {
    "Vegetables": 5,
    "Fruits": 3,
    "Flowers": 2,
    "Moss": 4
  };

  final gradientList = const <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      Color.fromRGBO(244, 134, 245, 1.0),
      Color.fromRGBO(254, 154, 239, 1),
    ]
  ];

  @override
  void initState() {
    super.initState();
    from = widget.from;
    //print("My Garden " + global.currentUser.myGarden.toString());
    /// Initiate User Object
    //getUserDB("pfTjVgNet8ggVpNOAfas");
  }

  initiateSetState() {setState(() {});}

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
        onWillPop: () async{ return _onWillPop();},
    child:Scaffold(

        key: scaffoldKey,

        drawer:  AppDrawer(from: "garden", function: initiateSetState,),

        bottomNavigationBar: orientationPortrait ? SimpleBottomBar(
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
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                /// Top View -----------------------------------------------
                Container(
                  padding: const EdgeInsets.only(top: 10,),
                  height: 105,
                  color: Colors.green,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 30,),
                        child :Text("My Eden garden",
                            style: TextStyle(
                              color: Colors.lightGreen.shade300,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'meri',
                              fontSize: 24,))),
                  ),
                ),


                Container(
                    padding: const EdgeInsets.only(bottom: 10,),
                    height: 100,
                    color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
                    child: Center(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// Chart On tap
                            GestureDetector(
                                onTap: () async {
                                  flagCharts = !flagCharts;
                                  flagGarden = false;
                                  flagChartsFilter=true;


                                  final charts = countGardenType();
                                  dataMapChartType["Herbs"] = charts[0].toDouble();
                                  dataMapChartType["Trees"] = charts[1].toDouble();
                                  dataMapChartType["Shrubs"] = charts[2].toDouble();
                                  dataMapChartType["Creepers"] = charts[3].toDouble();
                                  dataMapChartType["Climbers"] = charts[4].toDouble();


                                  initiateSetState();
                                  await Future.delayed(const Duration(milliseconds: 500), () {});

                                  controllerView.jumpTo(controllerView.position.maxScrollExtent);


                                },
                                child :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    global.themeAppDark ? Icon(Icons.pie_chart, size: 35, color: flagCharts ? Colors.lightGreen : Colors.white,) : Icon(Icons.pie_chart, size: 35, color: flagCharts ? Colors.lightGreen : Colors.black,),

                                    AnimatedSize(

                                      duration: const Duration(milliseconds: 500),
                                      child:  Text(
                                          "Charts",
                                          style :TextStyle(
                                            color: (global.themeAppDark && flagCharts) ? Colors.lightGreen : (!global.themeAppDark && flagCharts) ?  Colors.lightGreen : (!global.themeAppDark && !flagCharts) ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'RobotMono',
                                            fontSize: flagCharts ? 24 : 18,)
                                      ),)

                                  ],)
                            ),

                            GestureDetector(
                                onTap: () {
                                  flagGarden = !flagGarden;
                                  flagCharts = false;
                                  initiateSetState();
                                },
                                child :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    global.themeAppDark ? Icon(Icons.playlist_play, size: 35, color: flagGarden ? Colors.lightGreen : Colors.white,) : Icon(Icons.playlist_play, size: 35, color: flagGarden ? Colors.lightGreen : Colors.black,),

                                    AnimatedSize(
                                        duration: const Duration(milliseconds: 500),
                                        child:  Text(
                                            "Garden",
                                            style :TextStyle(
                                              color: (global.themeAppDark && flagGarden) ? Colors.lightGreen : (!global.themeAppDark && flagGarden) ?  Colors.lightGreen : (!global.themeAppDark && !flagGarden) ? Colors.black : Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'RobotMono',
                                              fontSize: flagGarden ? 24 : 18,)
                                        )),
                                  ],)
                            ),
                          ],)
                    )
                ),

                /// Charts Filter
                flagCharts ? Container(
                    padding: const EdgeInsets.only(left: 50,bottom: 10,),
                    height: 50,
                    color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
                    child: Center(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /// Chart On tap
                            GestureDetector(
                                onTap: () async {
                                  flagChartsFilter = !flagChartsFilter;
                                  initiateSetState();
                                  await Future.delayed(const Duration(milliseconds: 500), () {});

                                  controllerView.jumpTo(controllerView.position.maxScrollExtent);
                                },
                                child :
                                AnimatedSize(

                                  duration: const Duration(milliseconds: 500),
                                  child:  Text(
                                      "Species",
                                      style :TextStyle(
                                        color: (global.themeAppDark && flagChartsFilter) ? Colors.lightGreen : (!global.themeAppDark && flagChartsFilter) ?  Colors.lightGreen : (!global.themeAppDark && !flagChartsFilter) ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'RobotMono',
                                        fontSize: flagChartsFilter ? 24 : 18,)
                                  ),)

                            ),

                            const SizedBox(width: 60,),

                            GestureDetector(
                              onTap: () async {
                                flagChartsFilter = !flagChartsFilter;
                                final charts = countGardenType();
                                dataMapChartVFO["Vegetables"] = charts[0].toDouble();
                                dataMapChartVFO["Fruits"] = charts[1].toDouble();
                                dataMapChartVFO["Flowers"] = charts[2].toDouble();
                                dataMapChartVFO["Moss"] = charts[3].toDouble();

                                initiateSetState();
                                await Future.delayed(const Duration(milliseconds: 500), () {});

                                controllerView.jumpTo(controllerView.position.maxScrollExtent);
                              },
                              child :
                              AnimatedSize(
                                  duration: const Duration(milliseconds: 500),
                                  child:  Text(
                                      "Product",
                                      style :TextStyle(
                                        color: (global.themeAppDark && !flagChartsFilter) ? Colors.lightGreen : (!global.themeAppDark && !flagChartsFilter) ?  Colors.lightGreen : (!global.themeAppDark && flagChartsFilter) ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'RobotMono',
                                        fontSize: !flagChartsFilter ? 24 : 18,)
                                  )),
                            ),
                          ],)
                    )
                ) : const SizedBox(),


                ///---------------------------------------------------------
                const SizedBox(height: 50,),
                /// BODY VIEW  ---------------------------------------------------


                /// List of Garden Item ------------------------------------
                flagGarden?ListView.builder(
                  shrinkWrap: true,
                    controller: controllerView,
                    itemCount: global.currentUser.myGarden.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print('HEY ${global.currentUser.myGarden}');
                      return SlideAnimationController(
                          delay: 500+(200*index),
                          child:  Card(
                              child:  ListTile(
                                  title: Text(global.currentUser.myGardenObject[index].idKey),
                                  subtitle: Text(global.currentUser.myGardenObject[index].species),
                                  leading: CircleAvatar(backgroundImage: NetworkImage("https://${global.currentUser.myGardenObject[index].image}")),
                                  trailing:  IconButton(
                                    icon : const Icon(Icons.read_more),
                                    onPressed: () {
                                      /// Push GardenArticle
                                      Navigator.push( // push -> Add route on stack
                                        context,
                                        FadeInRoute( // FadeInRoute  // ZoomInRoute  // RotationInRoute
                                          page: GardenArticleInfoScreen(
                                              from: "garden",
                                              function: initiateSetState,
                                              item: global.currentUser.myGardenObject[index]), //ContactScreen(),
                                          routeName: '/garden/${global.currentUser.myGardenObject[index].idKey}',
                                        ),
                                      );
                                      setState(() {

                                      });
                                    },

                                  ))));

                    }) : const SizedBox(),

                ///---------------------------------------------------------

                /// Circle Charts Shrubs Herbs and Tree
                flagCharts ?

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideAnimationController(
                        delay: 900,
                        child: Padding(
                            padding: orientationPortrait ? const EdgeInsets.only(top: 10) : const EdgeInsets.only(bottom: 50),
                            child : Text(flagChartsFilter ? "Percentage by type of species" : "Percentage by type of product",
                                style: TextStyle(
                                  color: global.themeAppDark ? Colors.greenAccent.shade100 : Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'meri',
                                  fontSize: 24,)))
                    ),

                    SizedBox(height: orientationPortrait ? 50 : 0,),

                    SlideAnimationController(
                        delay: 500,
                        child: PieChart(
                          dataMap: flagChartsFilter? dataMapChartType : dataMapChartVFO,
                          animationDuration: const Duration(milliseconds: 2500),
                          chartLegendSpacing: 32,
                          chartRadius: orientationPortrait ? screenWidth / 2 : screenWidth / 4,
                          //colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: "Total : ${global.currentUser.myGardenObject.length}",
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            //legendShape: BoxShape.rectangle,
                            legendTextStyle: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: true,
                            decimalPlaces: 0,
                          ),
                          //gradientList: gradientList,
                          /* colorList: const [
                                  Color(0xFFB2FF59),
                                  Color(0xFF2962FF),
                                  Color(0xFFFF5252),
                                  Color(0xFF8530FD),
                                  Color(0xE62FF),
                                  //Color(0xFF009688),
                                ],
                                */
                          colorList: const [
                            Color.fromRGBO(0, 255, 0, 1),
                            Color.fromRGBO(75, 0, 130, 1),
                            Color.fromRGBO(255, 0, 0, 1),
                            Color.fromRGBO(0, 0, 255, 1),
                            Color.fromRGBO(255, 255, 0, 1),
                          ],

                        )),
                    orientationPortrait? const SizedBox() : const SizedBox(height: 30,)
                  ],
                ) : const SizedBox(),

                ///---------------------------------------------------------

              ],
            )
              ),
        )
    ));

  }

  List<int> countGardenType(){

    if (flagChartsFilter) {
      //print("BY SPECIES");
      var countHerbs = 0;
      var countTree = 0;
      var countShrubs = 0;
      var countCreepers = 0;
      var countClimbers = 0;

      for (var item in global.currentUser.myGardenObject) {
        //print(item.species);
        if (item.species == "Herbs") {
          countHerbs++;
        } else if (item.species == "Tree") {
          countTree++;
        }else if (item.species == "Shrubs") {
          countShrubs++;
        } else if (item.species == "Creepers") {
          countCreepers++;
        }else {
          countClimbers++;
        }
      }
      //print("Species : ${[countHerbs, countTree, countShrubs, countCreepers, countClimbers]}");
      return [countHerbs, countTree, countShrubs, countCreepers, countClimbers];
    }else{
      var countFruit = 0;
      var countVegetable= 0;
      var countFlower = 0;
      var countMoss = 0;

      for (var item in global.currentUser.myGardenObject) {
        if (item.product == "Fruit") {
          countFruit++;
        } else if (item.product == "Vegetable") {
          countVegetable++;
        } else if (item.product == "Flower") {
          countFlower++;
        } else {
          countMoss++;
        }
      }
      //print("Product : ${[countVegetable, countFruit, countFlower, countMoss]}");

      return [countVegetable, countFruit, countFlower, countMoss];

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