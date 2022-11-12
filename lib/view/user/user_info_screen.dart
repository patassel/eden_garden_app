import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:flutter/material.dart';


import 'package:eden_garden/controllers/globals.dart' as global;


class UserInfoScreen extends StatefulWidget {
  final String from;
  final UserDB user;

  const UserInfoScreen({Key? key, required this.from, required this.user}) : super(key: key) ;

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();


}

class _UserInfoScreenState extends State<UserInfoScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late bool themeSwitchVal = global.themeAppDark;  // true = dark


  late double screenWidth ;
  late double screenHeight ;
  late bool orientationPortrait = false;

  late String valueField;
  final TextEditingController _textFieldController = TextEditingController();
  late FocusNode textFocusNode = FocusNode();
  late bool focus = false;
  late Color colorTextSave = global.ColorTheme().colorFromLight;
  late Color colorTextCancel = global.ColorTheme().colorFromLight;


  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    textFocusNode.dispose();

    super.dispose();
  }



  initiateSetState() {setState(() {});}





  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(

        key: scaffoldKey,

        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Personal information', style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: themeSwitchVal? Colors.white : global.ColorTheme().colorFromLight),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: themeSwitchVal? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight),
            onPressed: () {
              Navigator.of(context).pop(context);
              setState(() {
              });
            },
          ),
          backgroundColor: themeSwitchVal? global.ColorTheme().colorFromLight : Colors.white,
        ),


        body: /// BODY -----------------------------------------------------------------

        /// BACKGROUND DECORATION VIEW
        Container(

          height: double.infinity,
          width: double.infinity,

          decoration:  BoxDecoration(
            gradient: LinearGradient(
              // DEEP BLUE DARK
              colors: themeSwitchVal ? global.ColorTheme().colorsViewBackgroundDark
                  : global.ColorTheme().colorsViewModernBackgroundLight,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),


          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// General Info ---------------------------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("General", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: themeSwitchVal ? Colors.white : Colors.green)),
                    ],
                  ),

                  Material(
                    type: MaterialType.transparency,
                    child : ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,

                      leading: Icon(Icons.person, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight ),
                        title: Text("Full name", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight )),
                        subtitle: Text(widget.user.fullName, style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                            : Colors.blueGrey)),
                        onTap: () {
                        _textFieldController.clear();
                        _displayTextInputDialog(context, "name", widget.user.fullName);
                        //initiateSetState();
                        },
                    )
                  ),
                  const Divider(),
                  Material(
                    type: MaterialType.transparency,
                    child : ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,

                      leading: Icon(Icons.perm_contact_cal, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight ),
                        title: Text("Pseudo", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight )),
                      subtitle: Text(widget.user.pseudo, style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                          : Colors.blueGrey)),
                      onTap: () {
                        _textFieldController.clear();
                        _displayTextInputDialog(context, "ps", widget.user.pseudo);
                      },
                    )
                  ),
                  const Divider(),
                  Material(
                    type: MaterialType.transparency,
                    child : ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,

                      leading: Icon(Icons.phone, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight ),
                        title: Text("Phone Number", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight )),
                      subtitle: Text(widget.user.phone, style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                          : Colors.blueGrey)),
                      onTap: () {
                        _textFieldController.clear();
                        _displayTextInputDialog(context, "ph", widget.user.phone);
                      },
                    )
                  ),
                  const Divider(),
                  Material(
                      type: MaterialType.transparency,
                      child : ListTile(
                        hoverColor: global.ColorTheme().buttonFromLight,
                        leading: Icon(Icons.mail, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight ),
                        title: Text("Email", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight )),
                        subtitle: Text(widget.user.email, style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                            : Colors.blueGrey)),
                        onTap: () {
                          _textFieldController.clear();
                          _displayTextInputDialog(context, "e", widget.user.email);
                        },
                        )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Security", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: themeSwitchVal ? Colors.white : Colors.green)),
                    ],
                  ),

                  Material(
                      type: MaterialType.transparency,
                      child : ListTile(
                        hoverColor: global.ColorTheme().buttonFromLight,

                        leading: Icon(Icons.password, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight ),
                        title: Text("Password", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                            : global.ColorTheme().colorFromLight )),
                        subtitle: Text("******", style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                            : Colors.blueGrey)),
                        onTap: () {
                          _textFieldController.clear();
                          _displayTextInputDialog(context, "pw", widget.user.password);
                        },
                      )
                  ),
                  const Divider(),


                  /*Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Security", style: headingStyle),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.phonelink_lock_outlined),
                  title: const Text("Lock app in background"),
                  trailing: Switch(
                      value: ThemeSwitchVal,
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          ThemeSwitchVal = val;
                        });
                      }),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text("Use fingerprint"),
                  trailing: Switch(
                      value: fingerprintSwitchVal,
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          fingerprintSwitchVal = val;
                        });
                      }),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                  trailing: Switch(
                      value: changePassSwitchVal,
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          changePassSwitchVal = val;
                        });
                      }),
                ),

                 */

                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, String title, String oldValue) async {
    return showDialog(
        context: context,
        builder:
            (context) => StatefulBuilder(builder : (context, setState)  => AlertDialog(
          title: Center(child :
          Text(
            title=="name" ? "Enter a new full name" :
            title=="pw" ? "Enter a new password" :
            title=="ps" ? "Enter a new pseudo" :
            title=="e" ? "Enter a new email" :
            title=="ph" ? "Enter a new phone number" : "Error!",
            style: TextStyle(
                color: global.ColorTheme().colorFromLight,
                fontWeight: FontWeight.w400,
                fontFamily: 'meri',
                fontSize: 22),

          )),
          content: SizedBox(
            height: screenHeight*0.1,
            width: screenWidth*0.8,
            child :Center(
                child:TextField(
                  onSubmitted: (val){
                    textFocusNode.unfocus();
                    setState(() {});
                  },

                  onChanged: (value) {
                    valueField = value;
                    setState(() {});
                  },

                  onTap: () {
                    setState(()
                    {
                      if (textFocusNode.hasFocus){
                        textFocusNode.unfocus();
                        focus=false;
                      }else{
                        textFocusNode.requestFocus();
                        focus=true;
                      }
                    });
                  },

                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: oldValue),


                )),
          ),
          actions: <Widget>[

            (!orientationPortrait && !textFocusNode.hasFocus) || (orientationPortrait && !textFocusNode.hasFocus) ? ButtonRect(
              title: "CANCEL",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorDeepDark,
              onclickButton: () {
                setState(() =>Navigator.pop(context));

              },
              onHoverMouse: (val) {

                setState(()
                {
                  if (val) {
                    colorTextCancel = Colors.white;
                  }else{
                    colorTextCancel = global.ColorTheme().colorFromLight;
                  }
                });
              },
            ) : const SizedBox(),
            SizedBox(width: orientationPortrait ?  screenWidth*0.28: screenWidth*0.65,),
            (!orientationPortrait && !textFocusNode.hasFocus) || (orientationPortrait && !textFocusNode.hasFocus) ? ButtonRect(
              title: "SAVE",
              colorBorder: Colors.transparent,
              colorBackground: Colors.transparent,
              colorHover: Colors.black,
              colorText: global.ColorTheme().colorFromDarkSub,

              onclickButton: () {

                switch (title) {
                  case "name":
                    try {
                      dataBaseUpdate(widget.user.id, "fullName", _textFieldController.value.text);
                    } on Exception catch (e) {
                      print(e);
                    }
                    widget.user.setName(_textFieldController.value.text);
                    break;
                  case "ps":

                    try {
                      dataBaseUpdate(widget.user.id, "pseudo", _textFieldController.value.text);
                    } on Exception catch (e) {
                      print(e);
                    }
                    widget.user.setPseudo(_textFieldController.value.text);

                    break;
                  case "ph":
                    try {
                      dataBaseUpdate(widget.user.id, "phone", _textFieldController.value.text);
                    } on Exception catch (e) {
                      print(e);
                    }
                    widget.user.setPhone(_textFieldController.value.text);
                    break;
                  case "e":
                    try {
                      dataBaseUpdate(widget.user.id, "email", _textFieldController.value.text);
                    } on Exception catch (e) {
                      print(e);
                    }
                    widget.user.setEmail(_textFieldController.value.text);
                    break;
                  case "pw":
                    try {
                      dataBaseUpdate(widget.user.id, "password", _textFieldController.value.text);
                    } on Exception catch (e) {
                      print(e);
                    }
                    widget.user.setPassword(_textFieldController.value.text);
                    break;
                }

                initiateSetState();
                Navigator.pop(context);

              },

              onHoverMouse: (val) {
                if (val) {
                  colorTextSave = Colors.white;
                }else{
                  colorTextSave = global.ColorTheme().colorFromLight;
                }
                setState(() {});
              },


            ) : const SizedBox(),


          ],
        )
        ));
  }

}