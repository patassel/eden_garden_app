import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;


class WidgetGridUserFamily extends StatefulWidget {
  final UserDB user;

  const WidgetGridUserFamily({Key? key, required this.user}) : super(key: key) ;

  @override
  State<WidgetGridUserFamily> createState() => _WidgetGridUserFamilyState();
}

class _WidgetGridUserFamilyState extends State<WidgetGridUserFamily>{

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController controllerView = ScrollController();

  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late List<bool> flagRequestButton = List.filled(widget.user.myCommunity.length, false);


  /// Show dialog --------------------------------------------------------------

  final TextEditingController _textFieldControllerMessage = TextEditingController();
  late FocusNode textFocusNodeMessage = FocusNode();
  late bool focusMessage = false;

  late Color colorTextSave = global.ColorTheme().colorFromLight;
  late Color colorTextCancel = global.ColorTheme().colorFromLight;
  /// Show dialog --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    if (widget.user.myCommunityObject.isEmpty) {
      constructCommunity();
    }
  }

  @override
  void dispose() {
    controllerView.dispose();
    //initiateSetState();
    super.dispose();
  }

  initiateSetState() {
    setState(() {});


  }

  Future<void> constructCommunity() async {
    for (var item in widget.user.myCommunity['family']){
      UserDB newUser = await dataBaseGetUser(item);
      widget.user.myCommunityObject.add(newUser);
      initiateSetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        key: scaffoldKey,

        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration:
            BoxDecoration(
              gradient: LinearGradient(
              // DEEP BLUE DARK
              colors: global.themeAppDark ? global.ColorTheme().colorsViewBackgroundDark
                  : global.ColorTheme().colorsViewModernBackgroundLight,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
                      const SizedBox(height: 100,),

                      SizedBox(
                        width: screenWidth,
                        child:
                      GridView.count(
                        crossAxisCount: orientationPortrait ? 2: 3,
                        mainAxisSpacing: orientationPortrait ? 30 : 0,
                        crossAxisSpacing: orientationPortrait ? 30 : 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: List.generate(widget.user.myCommunityObject.length, (index) {
                          UserDB userFamily = widget.user.myCommunityObject[index];
                          return SlideAnimationController(
                              delay: 1000+(index*100),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onLongPress: (){
                                                    flagRequestButton[index] = !flagRequestButton[index];
                                                    initiateSetState();
                                                  },
                                                  /// ZOOM profile
                                                  onDoubleTap: () {
                                                    if (userFamily.profileUrl.isNotEmpty) {
                                                      showFullImage(userFamily.profileUrl);
                                                    }
                                                  },
                                                  child:
                                                  Hero(
                                                      tag: 'user $index',
                                                      child:
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                          image:
                                                          userFamily.profileUrl.isNotEmpty ?
                                                          DecorationImage(
                                                            image:  NetworkImage(userFamily.profileUrl),
                                                            fit: BoxFit.cover,
                                                          ) :
                                                          const DecorationImage(
                                                            image:  AssetImage('assets/freeAvatar.jpg'),
                                                            fit: BoxFit.cover,
                                                          ) ,

                                                          border: Border.all(
                                                              color:
                                                              userFamily.status==0 ? Colors.grey
                                                                  : userFamily.status==1? Colors.green
                                                                  : userFamily.status==2 ? Colors.red.shade400
                                                                  : Colors.white,
                                                              width: 5),
                                                          borderRadius: const BorderRadius.all(Radius.circular(120.0)),

                                                        ),
                                                      )
                                                  ),
                                                ),

                                                Padding(
                                                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                                                    child:
                                                    SlideAnimationController(
                                                      delay: 800,
                                                      child: Text(
                                                        userFamily.fullName.isNotEmpty? userFamily.fullName : userFamily.email,
                                                        style: TextStyle(
                                                          letterSpacing: 0.25,
                                                          color: global.themeAppDark ? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: 'RobotMono',
                                                          fontSize: 16,),
                                                      ),
                                                    )
                                                )
                                              ]
                                          ),


                                      flagRequestButton[index] ?
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ButtonCircle(
                                                  tag: 'Send1 $index',
                                                  tip: 'Family request',
                                                  icon: Icon(Icons.add_reaction, color: Colors.red.shade400,),
                                                  colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                                                  colorBorder: Colors.transparent,
                                                  onPressed: () async {
                                                    displaySendRequestDialog(userFamily, true);
                                                  },

                                                ),

                                                ButtonCircle(
                                                  tag: 'Send2 $index',
                                                  tip: 'Group family',
                                                  icon: Icon(Icons.group_add, color: Colors.red.shade400,),
                                                  colorBackground: global.themeAppDark ? Colors.white12 : Colors.white,
                                                  colorBorder: Colors.transparent,
                                                  onPressed: () async {
                                                    displaySendRequestDialog(userFamily, false);
                                                  },

                                                ),
                                              ],

                                      ) : const SizedBox(),
                                    ],
                                  )
                              );
                        }),
                      ))
                      ])
            )
        )
    );
  }

  Future<dynamic> showFullImage(String url) async{
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
                            image: NetworkImage(url),
                            fit: BoxFit.cover
                        ),
                      )
                  )
              ),
            );

        }
    );
  }

  /// Show dialog Send firend request
  Future<void> displaySendRequestDialog(UserDB userRequest, bool flagFamily) async {
    return showDialog(
        context: context,
        builder:
            (context) => StatefulBuilder(builder : (context, setState)  => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Center(child :
              Text(
                flagFamily ? "Send Eden family request" : "Send Eden group request",
                style: TextStyle(
                    color: global.ColorTheme().colorFromLight,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'meri',
                    fontSize: 16),
              )),
              content: SizedBox(
                width: orientationPortrait ? screenWidth*0.8 : screenWidth*0.5,
                child :

                  TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSubmitted: (val){
                        textFocusNodeMessage.unfocus();
                        setState(() {});
                      },

                      onTap: () {
                        setState(()
                        {
                          if (textFocusNodeMessage.hasFocus){
                            textFocusNodeMessage.unfocus();
                            focusMessage=false;
                          }else{
                            textFocusNodeMessage.requestFocus();
                            focusMessage=true;
                          }
                        });
                      },

                      controller: _textFieldControllerMessage,
                      decoration: InputDecoration(
                          hintText: "Enter your message",
                          labelText: "Message",
                          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                          labelStyle: TextStyle(
                            color: global.themeAppDark ? Colors.blue : global.ColorTheme().colorFromLight,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,),
                          focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          //hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ))


                  ),
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
                setState(() =>Navigator.pop(context));

              },
              onHoverMouse: (val) {
                if (val) {
                  colorTextCancel = Colors.white;
                }else{
                  colorTextCancel = global.ColorTheme().colorFromLight;
                }
                setState(() {});
              },

            ),



            ButtonRect(
              title: "SEND",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorFromDarkSub,

              onclickButton: () async {

                var newUserEmail = userRequest.email;

                if (newUserEmail!= global.currentUser.email ) {
                  if (await dataBaseCheckUserId(newUserEmail)) {
                    await Future.delayed(
                        const Duration(milliseconds: 400), () {});

                    String id = await dataBaseGetUserID(newUserEmail);
                    await Future.delayed(
                        const Duration(milliseconds: 400), () {});

                    if (id != '0'){
                      UserDB userReceiver = await dataBaseGetUser(id);


                      if (flagFamily) { // Send friend request
                        if (!global.currentUser.myCommunity['family'].contains(id)){
                          userReceiver.receiveRequestCommunity('family', global.currentUser.id, global.currentUser.email, global.currentUser.fullName, global.currentUser.profileUrl, _textFieldControllerMessage.text, []);
                        }
                      } else { // Send group request

                      }

                    }
                  }
                }

                await Future.delayed(
                    const Duration(milliseconds: 400), () {
                  _textFieldControllerMessage.clear();
                  Navigator.pop(context);});

                initiateSetState();
              },

              onHoverMouse: (val) {
                if (val) {
                  colorTextSave = Colors.white;
                }else{
                  colorTextSave = global.ColorTheme().colorFromLight;
                }
                setState(() {});
              },

            )


          ],
        )
        ));
  }

}