import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/dialog/show_dialog.dart';
import 'package:eden_garden/model/garden/article/garden_article.dart';
import 'package:eden_garden/model/garden/article/list_article_garden.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/user_db.dart';
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



  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late bool prefixIconColor = true;

  late GardenArticleList listOfGardenArticle;
  late GardenArticleList listOfGardenFilter;


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    from = widget.from;
    global.currentPage = 1;

    listOfGardenArticle = GardenArticleList.fromList(
        [
          for (var item in global.docGarden.keys)
          GardenArticle(item.toLowerCase(), global.docGarden[item]),
        ]
    );

    listOfGardenFilter = GardenArticleList.fromList(
        [
          for (var item in global.docGarden.keys)
            GardenArticle(item.toLowerCase(), global.docGarden[item]),
        ]
    );
    //print('INIT ' + listOfGardenArticle.articleList.length.toString());
  }

  initiateSetState() {

    //print('INIT ' + listOfGardenArticle.articleList.length.toString());

    if (_textFieldController.text.isEmpty){
      //print("EMPTY");
      prefixIconColor = true;

    }else {
      //print("FULL");
      prefixIconColor = false;

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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                  color: global.themeAppDark? Colors.black : Colors.green,
                  child :  Center (
                      child: Padding(
                          padding: const EdgeInsets.only(top: 40,),
                          child :Text("Eden garden library",
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'meri',
                              fontSize: 34,)))
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
                                .contains(value.toLowerCase())) {
                              listOfGardenFilter.addArticle(
                                  listOfGardenArticle.articleList[i]);

                            }
                          }
                        }else{
                          listOfGardenFilter = GardenArticleList.fromList(
                              [
                                for (var item in global.docGarden.keys)
                                  GardenArticle(item.toLowerCase(), global.docGarden[item]),
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
                  decoration: prefixIconColor ? InputDecoration(
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
    return (await AlertDialogApp(
        context: context,
        onAccept: () async {
          await dataBaseUpdate(global.currentUser.id, 'status', 0);
          global.currentUser = UserDB(id: 'id', fullName: 'fullName');
          setState(() =>Navigator.pop(context));
        },

        onRefuse: () async {

        },
        title: 'Are you sure ?\n',
        body: 'Do you want to sign out ?',
        accept: 'YES',
        refuse: 'NO'


    ).normalShowDialog());
  }
}