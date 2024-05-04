import 'dart:io';

import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/dialog/show_dialog.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/view/gardenArticle/garden_article_info_screen.dart';
import 'package:eden_garden/view/search_screen.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:eden_garden/controllers/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO
  - CHECK of what I can do with the garden photos (problem with positions)
  -
 */

class GardenScreen extends StatefulWidget {
  final String from;

  const GardenScreen({Key? key, required this.from}) : super(key: key);

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  late String from;

  late double screenWidth;

  late double screenHeight;

  late bool orientationPortrait = false;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late File? androidImageFile;
  late SharedPreferences dataUser;
  final TextEditingController _textFieldControllerMessage =
      TextEditingController();
  late FocusNode textFocusNodeMessage = FocusNode();
  late bool focusMessage = false;
  late Color colorTextSave = global.ColorTheme().colorFromLight;
  late Color colorTextCancel = global.ColorTheme().colorFromLight;

  late ScrollController controllerView = ScrollController();
  late ScrollController controllerListView = ScrollController();

  late bool flagCharts = false;
  late bool flagChartsFilter = false; // false:species - true:VFO
  late bool flagGarden = true;

  late List<bool> focusGardenPicture = List.filled(4, false);

  Map<String, double> dataMapChartSpecies = {
    "Herbs": 5,
    "Trees": 3,
    "Shrubs": 2,
    "Creepers": 4,
    "Climbers": 2
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
    global.currentPage = 2;

    androidImageFile = File('');

    /// Initiate User Data SharedPreference
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      dataUser = sp;
      setState(() {});
    });
  }

  initiateSetState() {
    setState(() {});
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    controllerView.dispose();
    super.dispose();
  }

  void setOffAllValues(int pos) {
    for (int i = 0; i < 3; i++) {
      if (i != pos) {
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
    if (index == 1) {
      controllerListView
          .jumpTo((controllerListView.position.maxScrollExtent / 2));
    } else if (index == 0) {
      controllerListView.jumpTo(controllerListView.position.minScrollExtent);
    } else {
      controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
    }
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
              from: "garden",
              function: initiateSetState,
            ),
            bottomNavigationBar: orientationPortrait
                ? SimpleBottomBar(
                    from: "garden",
                    onPressed: (val) {
                      global.currentPage = val;

                      switch (val) {
                        case 0:
                          Navigator.pushReplacement(
                            // push -> Add route on stack
                            context,
                            FadeInRoute(
                              // FadeInRoute  // ZoomInRoute  // RotationInRoute
                              page: const HomeScreen(from: "garden"),
                              //ContactScreen(),
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
                              page: const SearchScreen(from: "garden"),
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
                              page: const GardenScreen(from: "garden"),
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

                /// BODY view ----------------------------------------------------------

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /// Top View -----------------------------------------------
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        height: 105,
                        color:
                            global.themeAppDark ? Colors.black : Colors.green,
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                              ),
                              child: Text("My Eden garden",
                                  style: TextStyle(
                                    color: Colors.lightGreen.shade300,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'meri',
                                    fontSize: 34,
                                  ))),
                        ),
                      ),

                      /// Top View -----------------------------------------------

                      /// Top ListView -------------------------------------------
                      Container(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          height: 100,
                          color: global.themeAppDark
                              ? Colors.black12
                              : global.ColorTheme().colorFromDark,
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /// Charts
                              GestureDetector(
                                  onTap: () async {
                                    flagCharts = !flagCharts;
                                    flagGarden = false;
                                    flagChartsFilter = true;

                                    final charts = countGardenType();
                                    dataMapChartSpecies["Herbs"] =
                                        charts[0].toDouble();
                                    dataMapChartSpecies["Trees"] =
                                        charts[1].toDouble();
                                    dataMapChartSpecies["Shrubs"] =
                                        charts[2].toDouble();
                                    dataMapChartSpecies["Creepers"] =
                                        charts[3].toDouble();
                                    dataMapChartSpecies["Climbers"] =
                                        charts[4].toDouble();

                                    initiateSetState();
                                    await Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {});

                                    controllerView.jumpTo(controllerView
                                        .position.maxScrollExtent);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      global.themeAppDark
                                          ? Icon(
                                              Icons.pie_chart,
                                              size: 35,
                                              color: flagCharts
                                                  ? Colors.lightGreen
                                                  : Colors.white,
                                            )
                                          : Icon(
                                              Icons.pie_chart,
                                              size: 35,
                                              color: flagCharts
                                                  ? Colors.lightGreen
                                                  : Colors.black,
                                            ),
                                      AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text("Charts",
                                            style: TextStyle(
                                              color: (global.themeAppDark &&
                                                      flagCharts)
                                                  ? Colors.lightGreen
                                                  : (!global.themeAppDark &&
                                                          flagCharts)
                                                      ? Colors.lightGreen
                                                      : (!global.themeAppDark &&
                                                              !flagCharts)
                                                          ? Colors.black
                                                          : Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'RobotMono',
                                              fontSize: flagCharts ? 24 : 18,
                                            )),
                                      )
                                    ],
                                  )),

                              /// List of Garden item(s)
                              GestureDetector(
                                  onTap: () {
                                    flagGarden = !flagGarden;
                                    flagCharts = false;
                                    initiateSetState();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      global.themeAppDark
                                          ? Icon(
                                              Icons.playlist_play,
                                              size: 35,
                                              color: flagGarden
                                                  ? Colors.lightGreen
                                                  : Colors.white,
                                            )
                                          : Icon(
                                              Icons.playlist_play,
                                              size: 35,
                                              color: flagGarden
                                                  ? Colors.lightGreen
                                                  : Colors.black,
                                            ),
                                      AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: Text("Garden",
                                              style: TextStyle(
                                                color: (global.themeAppDark &&
                                                        flagGarden)
                                                    ? Colors.lightGreen
                                                    : (!global.themeAppDark &&
                                                            flagGarden)
                                                        ? Colors.lightGreen
                                                        : (!global.themeAppDark &&
                                                                !flagGarden)
                                                            ? Colors.black
                                                            : Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'RobotMono',
                                                fontSize: flagGarden ? 24 : 18,
                                              ))),
                                    ],
                                  )),
                            ],
                          ))),

                      /// Top ListView -------------------------------------------

                      /// GardenPicture ------------------------------------------
                      (!flagCharts && !flagGarden)
                          ? buildBottomView()
                          : const SizedBox(),

                      /// GardenPicture ------------------------------------------

                      /// Charts Filter ------------------------------------------
                      flagCharts
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: 50,
                                bottom: 10,
                              ),
                              height: 50,
                              color: global.themeAppDark
                                  ? Colors.black12
                                  : global.ColorTheme().colorFromDark,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: orientationPortrait
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  /// Chart On tap
                                  GestureDetector(
                                      onTap: () async {
                                        flagChartsFilter = !flagChartsFilter;
                                        initiateSetState();
                                        await Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {});

                                        controllerView.jumpTo(controllerView
                                            .position.maxScrollExtent);
                                      },
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text("Species",
                                            style: TextStyle(
                                              color: (global.themeAppDark &&
                                                      flagChartsFilter)
                                                  ? Colors.lightGreen
                                                  : (!global.themeAppDark &&
                                                          flagChartsFilter)
                                                      ? Colors.lightGreen
                                                      : (!global.themeAppDark &&
                                                              !flagChartsFilter)
                                                          ? Colors.black
                                                          : Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'RobotMono',
                                              fontSize:
                                                  flagChartsFilter ? 24 : 18,
                                            )),
                                      )),

                                  const SizedBox(
                                    width: 60,
                                  ),

                                  GestureDetector(
                                    onTap: () async {
                                      flagChartsFilter = !flagChartsFilter;
                                      final charts = countGardenType();
                                      dataMapChartVFO["Vegetables"] =
                                          charts[0].toDouble();
                                      dataMapChartVFO["Fruits"] =
                                          charts[1].toDouble();
                                      dataMapChartVFO["Flowers"] =
                                          charts[2].toDouble();
                                      dataMapChartVFO["Moss"] =
                                          charts[3].toDouble();

                                      initiateSetState();
                                      await Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {});

                                      controllerView.jumpTo(controllerView
                                          .position.maxScrollExtent);
                                    },
                                    child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text("Product",
                                            style: TextStyle(
                                              color: (global.themeAppDark &&
                                                      !flagChartsFilter)
                                                  ? Colors.lightGreen
                                                  : (!global.themeAppDark &&
                                                          !flagChartsFilter)
                                                      ? Colors.lightGreen
                                                      : (!global.themeAppDark &&
                                                              flagChartsFilter)
                                                          ? Colors.black
                                                          : Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'RobotMono',
                                              fontSize:
                                                  !flagChartsFilter ? 24 : 18,
                                            ))),
                                  ),
                                ],
                              )))
                          : const SizedBox(),

                      /// Charts Filter ------------------------------------------

                      const SizedBox(
                        height: 50,
                      ),

                      /// BODY VIEW  -------------------------------------------------
                      /// List of Garden Item ------------------------------------
                      flagGarden
                          ? ListView.builder(
                              shrinkWrap: true,
                              controller: controllerView,
                              itemCount: global.currentUser.myGarden.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SlideAnimationController(
                                    delay: 500 + (200 * index),
                                    child: GestureDetector(
                                        onTap: () {
                                          /// Push GardenArticle
                                          Navigator.push(
                                            // push -> Add route on stack
                                            context,
                                            FadeInRoute(
                                              // FadeInRoute  // ZoomInRoute  // RotationInRoute
                                              page: GardenArticleInfoScreen(
                                                  from: "garden",
                                                  function: initiateSetState,
                                                  item: global.currentUser
                                                      .myGardenObject[index]),
                                              //ContactScreen(),
                                              routeName:
                                                  '/garden/${global.currentUser.myGardenObject[index].idKey}',
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: Card(
                                            child: ListTile(
                                                title: Text(global
                                                    .currentUser
                                                    .myGardenObject[index]
                                                    .idKey),
                                                subtitle: Text(global
                                                    .currentUser
                                                    .myGardenObject[index]
                                                    .species),
                                                leading: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        "https://${global.currentUser.myGardenObject[index].image}")),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                      Icons.read_more),
                                                  onPressed: () {
                                                    /// Push GardenArticle
                                                    Navigator.push(
                                                      // push -> Add route on stack
                                                      context,
                                                      FadeInRoute(
                                                        // FadeInRoute  // ZoomInRoute  // RotationInRoute
                                                        page: GardenArticleInfoScreen(
                                                            from: "garden",
                                                            function:
                                                                initiateSetState,
                                                            item: global
                                                                    .currentUser
                                                                    .myGardenObject[
                                                                index]),
                                                        //ContactScreen(),
                                                        routeName:
                                                            '/garden/${global.currentUser.myGardenObject[index].idKey}',
                                                      ),
                                                    );
                                                    setState(() {});
                                                  },
                                                )))));
                              })
                          : const SizedBox(),

                      /// BODY VIEW  ---------------------------------------------

                      /// Circle Charts Shrubs Herbs and Tree ------------------------
                      flagCharts
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SlideAnimationController(
                                    delay: 900,
                                    child: Padding(
                                        padding: orientationPortrait
                                            ? const EdgeInsets.only(top: 10)
                                            : const EdgeInsets.only(bottom: 50),
                                        child: Text(
                                            flagChartsFilter
                                                ? "Percentage by type of species"
                                                : "Percentage by type of product",
                                            style: TextStyle(
                                              color: global.themeAppDark
                                                  ? Colors.greenAccent.shade100
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'meri',
                                              fontSize: 24,
                                            )))),
                                SizedBox(
                                  height: orientationPortrait ? 50 : 0,
                                ),
                                SlideAnimationController(
                                    delay: 500,
                                    child: PieChart(
                                      dataMap: flagChartsFilter
                                          ? dataMapChartSpecies
                                          : dataMapChartVFO,
                                      animationDuration:
                                          const Duration(milliseconds: 2500),
                                      chartLegendSpacing: 32,
                                      chartRadius: orientationPortrait
                                          ? screenWidth / 2
                                          : screenWidth / 4,
                                      //colorList: colorList,
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 32,
                                      centerText:
                                          "Total : ${global.currentUser.myGardenObject.length}",
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
                                      chartValuesOptions:
                                          const ChartValuesOptions(
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
                                orientationPortrait
                                    ? const SizedBox()
                                    : const SizedBox(
                                        height: 30,
                                      )
                              ],
                            )
                          : const SizedBox(),

                      /// Circle Charts Shrubs Herbs and Tree --------------------

                      ///---------------------------------------------------------
                    ],
                  )),
            )));
  }

  Widget buildBottomView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 50,
        ),
        /*Text("",
          style: TextStyle(
          color: global.themeAppDark ? Colors.greenAccent.shade100 : Colors.black87,
          fontWeight: FontWeight.w400,
          fontFamily: 'meri',
          fontSize: 24,)),

           */

        Container(
          height: focusGardenPicture.contains(true) ? 600 : 380,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ListView.separated(
            controller: controllerListView,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return SlideAnimationController(
                  delay: 800 + (400 * index),
                  child: Center(child: buildFrontGardenPicture(index)));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: orientationPortrait ? 15 : 60,
              );
            },
          ),
        ),
        focusGardenPicture.contains(true)
            ? Text(
                (focusGardenPicture[0] &&
                        global.currentUser.myGardenPicture[0].isNotEmpty)
                    ? global.currentUser.myGardenPicture[0]['message']
                    : (focusGardenPicture[1] &&
                            global.currentUser.myGardenPicture[1].isNotEmpty)
                        ? global.currentUser.myGardenPicture[1]['message']
                        : (focusGardenPicture[2] &&
                                global
                                    .currentUser.myGardenPicture[2].isNotEmpty)
                            ? global.currentUser.myGardenPicture[2]['message']
                            : '',
                style: TextStyle(
                  letterSpacing: 0.25,
                  color: global.themeAppDark
                      ? global.ColorTheme().colorFromDark
                      : global.ColorTheme().colorFromLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotMono',
                  fontSize: 16,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildFrontGardenPicture(int index) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 800),
      curve: Curves.ease,
      child: GestureDetector(
        onTap: () async {
          if (global.currentUser.myGardenPicture[index].isNotEmpty) {
            actionTouchPicture(index);
          } else {
            await androidGetFromGallery();
            buildAddGardenPicture('tap', index);
          }
        },
        onDoubleTap: () async {
          if (global.currentUser.myGardenPicture[index].isNotEmpty) {
            if (global.currentUser.myGardenPicture[index]['locate'] == 'db') {
              showFullImage(
                  global.currentUser.myGardenPicture[index]['url'], true);
            } else {
              showFullImage(
                  global.currentUser.myGardenPicture[index]['url'], false);
            }
            actionTouchPicture(index);
          }
        },
        onLongPress: () async {
          if (global.currentUser.myGardenPicture[index].isNotEmpty) {
            buildAddGardenPicture('long', index);
          }
        },
        onVerticalDragStart: (val) async {
          if (global.currentUser.myGardenPicture[index].isNotEmpty) {
            actionTouchPicture(index);
          }
        },
        child: (global.currentUser.myGardenPicture[index].isNotEmpty)
            ? Container(
                height: focusGardenPicture[index] ? 580 : 250,
                width: focusGardenPicture[index] ? 320 : 300,
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  child: global.currentUser.myGardenPicture[index]['locate'] ==
                          'db'
                      ? Image.network(
                          global.currentUser.myGardenPicture[index]['url'],
                          height: focusGardenPicture[index] ? 580 : 250,
                          width: focusGardenPicture[index] ? 320 : 300,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Image.file(
                          File(
                              global.currentUser.myGardenPicture[index]['url']),
                          height: focusGardenPicture[index] ? 580 : 250,
                          width: focusGardenPicture[index] ? 320 : 300,
                          fit: BoxFit.cover,
                        ),
                ),
              )
            : Container(
                height: focusGardenPicture[index] ? 230 : 150,
                width: focusGardenPicture[index] ? 300 : 200,
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: global.themeAppDark ? Colors.white12 : Colors.black12,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                child: const Image(
                  image: AssetImage('assets/addPicture.jpg'),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                )),
      ),
    );
  }

  /// Show dialog Send family request
  Future<void> buildAddGardenPicture(String type, int index) async {
    late bool flagSaveToDatabase = (type == 'long' &&
            global.currentUser.myGardenPicture[index]['type'] == "db")
        ? true
        : false;
    late String namePicture = type == 'long'
        ? global.currentUser.myGardenPicture[index]['path']
        : androidImageFile!.path.split('/').last;

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: Center(
                      child: Text(
                    type == 'long'
                        ? 'Edit the picture'
                        : "Save to database and write a message for this picture ?",
                    style: TextStyle(
                        color: global.ColorTheme().colorFromLight,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'meri',
                        fontSize: 16),
                  )),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //.path.split('/').last
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: Text(namePicture,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'RobotMono',
                              fontSize: 12,
                            )),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            androidGetFromGallery();
                            setState(() {});
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.data_saver_off),
                        title: const Text('Save to database',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'RobotMono',
                              fontSize: 12,
                            )),
                        subtitle: Text(flagSaveToDatabase ? 'Yes' : 'No',
                            style: TextStyle(
                                color: global.themeAppDark
                                    ? global.ColorTheme().colorFromDarkSub
                                    : Colors.green)),
                        trailing: Switch(
                            value: flagSaveToDatabase,
                            activeColor: Colors.redAccent,
                            onChanged: (val) {
                              setState(() {
                                flagSaveToDatabase = val;
                              });
                            }),
                      ),
                      SizedBox(
                        width: orientationPortrait
                            ? screenWidth * 0.8
                            : screenWidth * 0.5,
                        child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            onSubmitted: (val) {
                              textFocusNodeMessage.unfocus();
                              setState(() {});
                            },
                            onTap: () {
                              setState(() {
                                if (textFocusNodeMessage.hasFocus) {
                                  textFocusNodeMessage.unfocus();
                                  focusMessage = false;
                                } else {
                                  textFocusNodeMessage.requestFocus();
                                  focusMessage = true;
                                }
                              });
                            },
                            controller: _textFieldControllerMessage,
                            decoration: InputDecoration(
                                hintText: type == 'long'
                                    ? global.currentUser.myGardenPicture[index]
                                        ['message']
                                    : "Enter your message",
                                labelText: "Message",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10),
                                labelStyle: TextStyle(
                                  color: global.themeAppDark
                                      ? Colors.blue
                                      : global.ColorTheme().colorFromLight,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                //hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ))),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ButtonRect(
                      title: "CANCEL",
                      colorBorder: Colors.transparent,
                      colorBackground: Colors.transparent,
                      colorHover: Colors.black,
                      colorText: global.ColorTheme().colorDeepDark,
                      onclickButton: () {
                        _textFieldControllerMessage.clear();
                        setState(() => Navigator.pop(context));
                      },
                      onHoverMouse: (val) {
                        if (val) {
                          colorTextCancel = Colors.white;
                        } else {
                          colorTextCancel = global.ColorTheme().colorFromLight;
                        }
                        setState(() {});
                      },
                    ),
                    global.currentUser.myGardenPicture[index].isEmpty
                        ? ButtonRect(
                            title: "DELETE",
                            colorBorder: Colors.transparent,
                            colorBackground: Colors.transparent,
                            colorHover: Colors.black,
                            colorText: Colors.green,
                            onclickButton: () async {
                              if (await databaseDeleteGardenPicture(
                                  global.currentUser.id, index)) {
                                initiateSetState();
                                global.currentUser.myGardenPicture[index]
                                    .clear();
                                await dataBaseUpdate(
                                    global.currentUser.id,
                                    'gardenPicture',
                                    global.currentUser.myGardenPicture);
                              } else {
                                print('ERROR DELETING PICTURE');
                              }
                              setState(() => Navigator.pop(context));
                              initiateSetState();
                            },
                            onHoverMouse: (val) {
                              if (val) {
                                colorTextCancel = Colors.white;
                              } else {
                                colorTextCancel =
                                    global.ColorTheme().colorFromLight;
                              }
                              setState(() {});
                            },
                          )
                        : const SizedBox(),
                    ButtonRect(
                      title: "SAVE",
                      colorBorder: Colors.transparent,
                      colorBackground: Colors.transparent,
                      colorHover: Colors.black,
                      colorText: global.ColorTheme().colorFromDarkSub,
                      onclickButton: () async {
                        if (androidImageFile!.path.isNotEmpty) {
                          if (flagSaveToDatabase) {
                            /// Save to database
                            await databaseSaveGardenPicture(
                              global.currentUser.id,
                              androidImageFile!,
                              index,
                              _textFieldControllerMessage.value.text,
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 400), () {});
                          } else {
                            /// Save to App cache

                            await dataUser.setString(
                                'garden$index', androidImageFile!.path);
                            await Future.delayed(
                                const Duration(milliseconds: 200), () {});

                            global.currentUser.myGardenPicture[index] = {
                              'locate': 'cache',
                              'url': dataUser.getString('garden$index')!,
                              'message': _textFieldControllerMessage.value.text,
                              'path': dataUser
                                  .getString('garden$index')!
                                  .split('/')
                                  .last,
                            };

                            await dataBaseUpdate(
                                global.currentUser.id,
                                'gardenPicture',
                                global.currentUser.myGardenPicture);

                            await Future.delayed(
                                const Duration(milliseconds: 400), () {});
                          }
                        }

                        _textFieldControllerMessage.clear();
                        initiateSetState();
                        await Future.delayed(
                            const Duration(milliseconds: 800), () {});
                        initiateSetState();
                        setState(() => Navigator.pop(context));
                      },
                      onHoverMouse: (val) {
                        if (val) {
                          colorTextSave = Colors.white;
                        } else {
                          colorTextSave = global.ColorTheme().colorFromLight;
                        }
                        setState(() {});
                      },
                    ),
                  ],
                )));
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

  String? getGardenPictureCache(int index) {
    String? imageCache = dataUser.getString('garden$index');
    // will be null if never previously saved
    if (imageCache != null) {
      androidImageFile = File(imageCache);
    }
    return imageCache;
  }

  /// Calculate Charts values
  List<int> countGardenType() {
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
        } else if (item.species == "Shrubs") {
          countShrubs++;
        } else if (item.species == "Creepers") {
          countCreepers++;
        } else {
          countClimbers++;
        }
      }
      return [countHerbs, countTree, countShrubs, countCreepers, countClimbers];
    } else {
      var countFruit = 0;
      var countVegetable = 0;
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

  Future<dynamic> showFullImage(String url, bool dbImage) async {
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
                      image: dbImage
                          ? DecorationImage(
                              image: NetworkImage(url), fit: BoxFit.cover)
                          : DecorationImage(
                              image: FileImage(File(url)), fit: BoxFit.cover),
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
            onRefuse: () async {},
            title: 'Are you sure ?\n',
            body: 'Do you want to sign out ?',
            accept: 'YES',
            refuse: 'NO')
        .normalShowDialog());
  }
}
