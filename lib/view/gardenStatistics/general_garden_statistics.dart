import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';


import 'package:eden_garden/controllers/globals.dart' as global;
//import 'dart:math' as math;


class GeneralGardenStatistics extends StatefulWidget {
  final String from;

  const GeneralGardenStatistics({Key? key, required this.from}) : super(key: key);

  @override
  State<GeneralGardenStatistics> createState() =>
      _GeneralGardenStatisticsState();
}

class _GeneralGardenStatisticsState extends State<GeneralGardenStatistics> {
  late String from;
  late double screenWidth ;
  late double screenHeight ;

  late bool orientationPortrait = false;
  late bool flagCharts = false;
  late bool flagChartsFilter = false;   // false:species - true:VFO

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController controllerView = ScrollController();

  Map<String, double> dataMapChartSpecies = {
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

  @override
  void initState() {
    super.initState();
    final charts = countGardenType();
    dataMapChartVFO["Vegetables"] = charts[0].toDouble();
    dataMapChartVFO["Fruits"] = charts[1].toDouble();
    dataMapChartVFO["Flowers"] = charts[2].toDouble();
    dataMapChartVFO["Moss"] = charts[3].toDouble();
  }

  initiateSetState() {setState(() {});}


  @override
  void dispose() {
    controllerView.dispose();
    //initiateSetState();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        key: scaffoldKey,

        appBar: AppBar(
          backgroundColor: global.themeAppDark ? Colors.black : Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.greenAccent.shade100),
            onPressed: () {
              Navigator.of(context).pop(context);
            },
          ),

          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: flagChartsFilter ? "Percentage by type of species" : "Percentage by type of product",
                style : const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.00,
                  fontFamily: 'RobotMono',
                ),
            ),
          ),
        ),

        body:
            /// BODY -----------------------------------------------------------------

            /// BACKGROUND DECORATION VIEW
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  // DEEP BLUE DARK
                  colors: global.themeAppDark
                      ? global.ColorTheme().colorsViewBackgroundDark
                      : global.ColorTheme().colorsViewModernBackgroundLight,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
                child: SingleChildScrollView(
                    controller: controllerView,
                    child: orientationPortrait?  orientationViewPortrait() : orientationViewLandscape(),
                )
            )
    );
  }


  Widget orientationViewLandscape(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[


          SizedBox(
            width: screenWidth,
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(left: 120),
                    child: circleCharts(),
                  ),

                  /// BANNER INFO GENERAL ------------------------------------------
                  generalTopView(),
                  /// BANNER INFO GENERAL ------------------------------------------


                  /// BOOLEAN BUTTON Charts Filter ------------------------------------------
                  Container(
                      height: screenHeight,
                      width: 100,
                      color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Chart On tap
                          GestureDetector(
                              onTap: () async {
                                flagChartsFilter = !flagChartsFilter;
                                final charts = countGardenType();
                                dataMapChartSpecies["Herbs"] = charts[0].toDouble();
                                dataMapChartSpecies["Trees"] = charts[1].toDouble();
                                dataMapChartSpecies["Shrubs"] = charts[2].toDouble();
                                dataMapChartSpecies["Creepers"] = charts[3].toDouble();
                                dataMapChartSpecies["Climbers"] = charts[4].toDouble();
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

                          const SizedBox(height: 80,),

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

                        /// Charts Filter ------------------------------------------

                  )
                ]
            ),
            )

        ]

    );}


  Widget orientationViewPortrait(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          /// Top View -----------------------------------------------------

          /// BANNER INFO GENERAL ------------------------------------------
          generalTopView(),
          /// BANNER INFO GENERAL ------------------------------------------


          /// BOOLEAN BUTTON Charts Filter ------------------------------------------
          Container(
              height: 120,
              color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Chart On tap
                  GestureDetector(
                      onTap: () async {
                        flagChartsFilter = !flagChartsFilter;
                        final charts = countGardenType();
                        dataMapChartSpecies["Herbs"] = charts[0].toDouble();
                        dataMapChartSpecies["Trees"] = charts[1].toDouble();
                        dataMapChartSpecies["Shrubs"] = charts[2].toDouble();
                        dataMapChartSpecies["Creepers"] = charts[3].toDouble();
                        dataMapChartSpecies["Climbers"] = charts[4].toDouble();
                        initiateSetState();
                        await Future.delayed(const Duration(milliseconds: 500), () {});
                        controllerView.jumpTo(controllerView.position.maxScrollExtent);
                      },
                      child :
                      AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
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
          ),
          /// Charts Filter ------------------------------------------

          const SizedBox(height: 50,),
          /// Circle Charts Shrubs Herbs and Tree -----------------------
          circleCharts(),
          /// Circle Charts Shrubs Herbs and Tree --------------------



        ]
    );
  }


  Widget circleCharts(){
    return /// Circle Charts Shrubs Herbs and Tree -----------------------
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*SlideAnimationController(
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

           */

          SizedBox(height: orientationPortrait ? 50 : 0,),

          SlideAnimationController(
              delay: 500,
              child: PieChart(
                dataMap: flagChartsFilter? dataMapChartSpecies : dataMapChartVFO,
                animationDuration: const Duration(milliseconds: 2500),
                chartLegendSpacing: 32,
                chartRadius: orientationPortrait ? screenWidth / 2 : screenWidth / 4,
                //colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                //centerText: "Total : ${global.currentUser.myGardenObject.length}",
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
      );
    /// Circle Charts Shrubs Herbs and Tree --------------------
  }


  Widget generalTopView(){
    return /// BANNER INFO GENERAL ------------------------------------------
      Container(
        margin: EdgeInsets.only(top: orientationPortrait ? 10 : 20),
        height: orientationPortrait ? 120 : 140,
        width: orientationPortrait ? screenWidth : 100,
        child:
        SlideAnimationController(
          delay: 800,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(global.currentUser.myGardenObject.length.toString(),
                style:TextStyle(
                  letterSpacing: 0.25,
                  color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorDeepDark,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotMono',
                  fontSize: 64,),
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
        ),
      );
    /// BANNER INFO GENERAL ------------------------------------------

  }



  /// Calculate Charts values
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

      return [countVegetable, countFruit, countFlower, countMoss];

    }

  }
}
