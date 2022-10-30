import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/model/drawer/drawer_style.dart';
import 'package:eden_garden/model/body/profile_body_view.dart';
import 'package:eden_garden/model/bottomNavigation/simpleBottomBar.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;



class HomeScreen extends StatefulWidget {
  final String from;

  const HomeScreen({Key? key, required this.from}) : super(key: key) ;

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  late String from;
  late TextTheme textTheme;
  late double screenWidth ;
  late double screenHeight ;

  late bool profileEdit = false;
  late bool profileZoom = false;
  late bool orientationPortrait = false;
  late bool errorDataException = false;


  int count = 0;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    from = widget.from;

    /// Initiate User Object
    getUserDB("pfTjVgNet8ggVpNOAfas");
  }


  initiateSetState() {setState(() {});}

   getUserDB(String id) {

    try {
          dataBaseRead(id);
    } on Exception catch (e) {
      errorDataException = true;
    }

  }


  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(

      key: scaffoldKey,

      drawer:  AppDrawer(from: "home", function: initiateSetState,),

      bottomNavigationBar: SimpleBottomBar(
        onPressed: (val){
          global.currentPage = val;

          switch (val) {
            case 0:
              //print('PROFILE ${val}');
              break;
            case 1:
              //print('SEARCH ${val}');
              break;
            case 2:
              //print('GARDEN ${val}');
              break;
          }
          initiateSetState();
        },
      ),


      body:
      /// BODY -----------------------------------------------------------------

      /// BACKGROUND DECORATION VIEW

      GestureDetector(
      onTap: () {
        profileEdit = false;
        profileZoom = false;
        initiateSetState();
    },
      child:
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
              BoxDecoration(
                gradient: LinearGradient(
                  // DEEP BLUE DARK
                  colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                      : global.ColorTheme().colorsViewBackgroundLight,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              ),



        child: SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: profileZoom ? 400: 200,
                width: screenWidth,

                /// TOP VIEW  --------------------------------------------------
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /// DRAWER BUTTON DESIGN if not mobile

                    if (global.currentPlatform!="and" && global.currentPlatform!="ios")
                      Positioned(
                        left: 10,
                        top: 20,
                        child: IconButton(
                          icon:  const Icon(Icons.menu,color: Colors.black,),
                          onPressed: () => scaffoldKey.currentState?.openDrawer(),
                        ),

                      ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child:  GestureDetector(

                        behavior: HitTestBehavior.translucent,
                        onTap: () {

                          if (profileEdit){profileEdit = false;}
                          else{profileZoom = !profileZoom;}

                          initiateSetState();
                        },

                        onLongPress: () {
                          if (profileZoom){profileZoom = false;}
                          else{
                            profileEdit = !profileEdit;

                          }
                          initiateSetState();
                        },
                        child:
                        AnimatedSize(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child:
                            Hero(
                              tag: 'user',
                              child: ClipOval(
                                    child : Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/eden-garden-bcf0f.appspot.com/o/Users%2Fuser1.jpg?alt=media&token=eb3fdca0-1520-49bb-bcaa-9793655b5657',
                                      width: profileZoom ? screenWidth*0.8: 150,
                                      height: profileZoom ? screenHeight*0.4:  150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              )),
                      )
                    ),

                    profileEdit?
                    Align(
                          alignment: const Alignment(0.8, 0),
                          child:
                            ButtonCircle(
                              onPressed: (){
                              },
                            )
                        ) : const SizedBox(),

                    ///---------------------------------------------------------
                  ],),
              ),

              ///---------------------------------------------------------------

              /// BODY VIEW  ---------------------------------------------------
              ProfileBodyView(profileZoom: profileZoom, screenWidth: screenWidth),
              ///---------------------------------------------------------------



            ],
          ),
        ),
      ))
    );
  }
}



/// WRITE TO DB
/*

    final newUser = UserDB(
      fullName: 'Fayssal Ben Hammou',
      pseudo: 'pata',
      password: 'p',
      phone: '04',
      email: '@gmail',
    );



    await docUser.doc('pfTjVgNet8ggVpNOAfas').set(newUser.returnJson());


 */





/// READ TO DB
/*

    final docRef = docUser.doc("ffejVgNet8ggVpNOAfas");

    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data['fullName']);
      },
      onError: (e) => print("Error getting document: $e"),
    );

 */