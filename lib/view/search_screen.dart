import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/garden/article/garden_article.dart';
import 'package:eden_garden/model/garden/article/list_article_garden.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/view/garden_screen.dart';
import 'package:eden_garden/view/home_screen.dart';
import 'package:eden_garden/model/widget/widget_grid_garden_article.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;


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

  late Color colorTextSave = global.ColorTheme().colorFromLight;
  late Color colorTextCancel = global.ColorTheme().colorFromLight;

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late bool prefixIcon = true;

  late GardenArticleList listOfGardenArticle;


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    from = widget.from;

    listOfGardenArticle = GardenArticleList.fromList(
        [
          GardenArticle(title : "Garden tomato"),
          GardenArticle(title : "Lemon",),
    ]);

  }


  initiateSetState() {

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
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(

      key: scaffoldKey,

      drawer:  AppDrawer(from: "search", function: initiateSetState,),

      bottomNavigationBar: SimpleBottomBar(
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
      ),

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
                : global.ColorTheme().colorsViewBackgroundLight,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),


        child: SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: screenHeight*0.2,
                width: screenWidth,

                /// TOP VIEW  --------------------------------------------------
                child: Stack(
                  children: [
                Padding(
                padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                child:
                Center(
                    child: TextField(

                  focusNode: textFocusNode,
                  style: TextStyle(
                        color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,),

                onSubmitted: (val){
                  textFocusNode.unfocus();
                  initiateSetState();
                  },

                    onChanged: (value) {
                      valueField = value;
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
                      prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent,),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: "Enter your search here",
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(20))) :
                  InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: "Enter your search here",
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(20))),
                    ))),


                  ],),
              ),

              ///---------------------------------------------------------------


              /// BODY VIEW  ---------------------------------------------------


              /// GridView of article
              GridGardenArticleWidget(
                height: (global.currentPlatform=='and' || global.currentPlatform=='ios') ? 200 : 500,
                width: (global.currentPlatform=='and' || global.currentPlatform=='ios')? 150: 350,
                widthScreen: 130, myList: listOfGardenArticle,),


              const SizedBox(height: 100,),

            ],
          ),
        ),
      ),
    );
  }
}