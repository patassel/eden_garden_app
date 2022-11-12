import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/garden/article/garden_article.dart';
import 'package:eden_garden/model/garden/article/list_article_garden.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/model/widget/widget_grid_garden_article.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;
import 'package:flutter/services.dart';


// TODO Scrollable listview horizontal
class SearchScreen extends StatefulWidget {
  final String from;

  const SearchScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<SearchScreen> createState() => _SearchScreenState();


}

class _SearchScreenState extends State<SearchScreen> {

  late String from;

  late String valueField;
  final TextEditingController _textFieldController = TextEditingController();
  late FocusNode textFocusNode = FocusNode();
  late bool focus = false;



  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late bool prefixIcon = true;

  late GardenArticleList listOfGardenArticle;
  late GardenArticleList listOfGardenFilter;


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    from = widget.from;

    listOfGardenArticle = GardenArticleList.fromList(
        [
          for (var item in global.docGarden.keys)
          GardenArticle(title : item, information: global.docGarden[item]),
        ]
    );

    listOfGardenFilter = GardenArticleList.fromList(
        [
          for (var item in global.docGarden.keys)
            GardenArticle(title : item, information: global.docGarden[item]),
        ]
    );
    //print('INIT ' + listOfGardenArticle.articleList.length.toString());
  }

  initiateSetState() {

    //print('INIT ' + listOfGardenArticle.articleList.length.toString());

    if (_textFieldController.text.isEmpty){
      //print("EMPTY");
      prefixIcon = true;

    }else {
      //print("FULL");
      prefixIcon = false;

    }
    setState(() {

    });
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
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

          drawer:  AppDrawer(from: "search", function: initiateSetState,),

          bottomNavigationBar: orientationPortrait ? SimpleBottomBar(
            from: "search",
            onPressed: (val){
              global.currentPage = val;

              switch (val) {
                case 0:
                  Navigator.pushReplacement(  // push -> Add route on stack
                    context,
                    FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                      page: const HomeScreen(from: "search"), //ContactScreen(),
                      routeName: '/home',
                    ),
                  );
                  break;
                case 1:
                  Navigator.pushReplacement(  // push -> Add route on stack
                    context,
                    FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                      page: const SearchScreen(from: "search"), //ContactScreen(),
                      routeName: '/search',
                    ),
                  );
                  break;
                case 2:
                  Navigator.pushReplacement(  // push -> Add route on stack
                    context,
                    FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
                      page: const GardenScreen(from: "search"), //ContactScreen(),
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

            decoration:  BoxDecoration(
              gradient: LinearGradient(
                // DEEP BLUE DARK
                colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                    : global.ColorTheme().colorsViewModernBackgroundLight,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),


            child: SingleChildScrollView(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /// TOP VIEW  --------------------------------------------------

                Container(
                  padding: const EdgeInsets.only(top: 10,),
                  height: 105,
                  width: screenWidth,
                  color: Colors.green,
                  child : const Center (
                      child: Padding(
                          padding: EdgeInsets.only(top: 40,),
                          child :Text("Eden garden library",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'meri',
                              fontSize: 24,)))
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    height: 100,
                    width: screenWidth,
                    color: global.themeAppDark ? Colors.black12 : global.ColorTheme().colorFromDark,
                    child :

                Center(
                    child: TextField(
                      focusNode: textFocusNode,
                      style: TextStyle(
                        color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,),

                      onSubmitted: (value){
                        textFocusNode.unfocus();
                        valueField = value;
                        listOfGardenFilter.articleList.clear();

                        if(value.isNotEmpty) {

                          for (int i = 0; i < listOfGardenArticle.articleList.length; i++) {
                            /*print(value);
                            print(listOfGardenArticle.articleList[i].title);
                            print(listOfGardenArticle.articleList[i].title
                                .contains(value));
                            print('\n');

                             */
                            if (listOfGardenArticle.articleList[i].title
                                .contains(value)) {
                              listOfGardenFilter.addArticle(
                                  listOfGardenArticle.articleList[i]);

                            }
                          }
                        }else{
                          listOfGardenFilter = GardenArticleList.fromList(
                              [
                                for (var item in global.docGarden.keys)
                                  GardenArticle(title : item, information: global.docGarden[item]),
                              ]
                          );
                        }
                        initiateSetState();
                        },

                      onChanged: (value) {
                        valueField = value;
                        //listOfGardenFilter.articleList.clear();
                        initiateSetState();
                      },

                      onTap: () {

                        if (textFocusNode.hasFocus){
                          textFocusNode.unfocus();
                          focus=false;
                        }else{
                          textFocusNode.requestFocus();
                          focus=true;
                        }
                        initiateSetState();

                    },

                  controller: _textFieldController,
                  decoration: prefixIcon ? InputDecoration(
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.green,),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: "Enter your search here",
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20))) :
                  InputDecoration(
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: "Enter your search here",
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20))),
                    ))

              ),

              ///---------------------------------------------------------------


              /// BODY VIEW  ---------------------------------------------------


              /// GridView of article
              GridGardenArticleWidget(
                height: (global.currentPlatform=='and' || global.currentPlatform=='ios') ? 200 : 500,
                width: (global.currentPlatform=='and' || global.currentPlatform=='ios')? 150: 350,
                widthScreen: 130, myList: listOfGardenFilter,currentOrientation: orientationPortrait,
              ),




              const SizedBox(height: 100,),

            ],
          ),
        ),
      ),
    ));
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