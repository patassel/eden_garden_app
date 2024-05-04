import 'package:eden_garden/model/user_db.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;

import '../controllers/dataBase_controller.dart';


class SettingsScreen extends StatefulWidget {
  final String from;
  final Function()? function;

  const SettingsScreen({Key? key, required this.from, this.function }) : super(key: key) ;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();


}

class _SettingsScreenState extends State<SettingsScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool themeSwitchVal = global.themeAppDark;  // true = dark




  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldKey,

      appBar: AppBar(
        title: Text(
          'Settings', style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800, color: themeSwitchVal? Colors.white : global.ColorTheme().colorFromLight),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeSwitchVal? global.ColorTheme().colorFromDark : global.ColorTheme().colorFromLight),
          onPressed: () {
                Navigator.of(context).pop(context);
                setState(() {
                  widget.function!();
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
            colors: themeSwitchVal ? global.ColorTheme().colorsViewSubBackgroundDark
                : global.ColorTheme().colorsViewModernBackgroundLight,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),


        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    /// General settings ---------------------------------------
                    Text(
                      "General",

                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: themeSwitchVal ? Colors.white : Colors.black),
                    ),
                  ],
                ),

                Material(
                  type: MaterialType.transparency,
                    child : ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,

                      leading: Icon(Icons.language, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight ),
                      title: Text("Language", style: TextStyle(color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight),),
                      subtitle: Text("English", style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                          : Colors.green)),
                      onTap: () {print("language button");},
                    )),

                const Divider(),

                Material(
                  type: MaterialType.transparency,
                  child :
                  ListTile(
                    hoverColor: global.ColorTheme().buttonFromLight,
                    leading: Icon(Icons.cloud, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                        : global.ColorTheme().colorFromLight ),
                      title: Text("Environment", style: TextStyle(color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight),),
                      subtitle: Text("Production", style: TextStyle( color : global.themeAppDark ? global.ColorTheme().colorFromDarkSub
                          : Colors.green)),
                    onTap: () {print("language button");},


                  )),

                const Divider(),

                // Theme Dark/Light Switch
                Material(
                  type: MaterialType.transparency,
                  child :
                    ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,
                      leading: Icon(Icons.invert_colors_on_outlined, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight ),
                      title: Text("Theme", style: TextStyle(color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight),),
                      subtitle:  themeSwitchVal ?  Text("Dark", style: TextStyle( color : global.ColorTheme().colorFromDarkSub
                      )) : const Text("Light", style: TextStyle( color : Colors.green)),
                      trailing: Switch(
                          value: themeSwitchVal,
                          activeColor: Colors.redAccent,
                          onChanged: (val) {
                            setState(() {
                              themeSwitchVal = val;
                              global.themeAppDark = themeSwitchVal;
                            });
                          }),
                      onTap: () {setState(() {
                        themeSwitchVal = !themeSwitchVal;
                        global.themeAppDark = themeSwitchVal;

                      });},

                    )),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Services", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: themeSwitchVal ? Colors.white : Colors.black)),
                  ],
                ),
                Material(
                    type: MaterialType.transparency,
                    child :ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,
                      leading: Icon(Icons.file_open_outlined, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight ),
                      title: Text("Terms of Service", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight )),
                      onTap: () {print("language button");},

                    )),
                const Divider(),
                Material(
                    type: MaterialType.transparency,
                    child :ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,
                      leading: Icon(Icons.file_copy_outlined, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight ),
                      title: Text("Open Source and Licences", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight )),
                      onTap: () {print("language button");},

                    )),
                const Divider(),
                Material(
                    type: MaterialType.transparency,
                    child :ListTile(
                      hoverColor: global.ColorTheme().buttonFromLight,
                      leading: Icon(Icons.exit_to_app, color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight ),
                      title: Text("Sign Out", style: TextStyle( color: global.themeAppDark ? global.ColorTheme().colorFromDark
                          : global.ColorTheme().colorFromLight )),
                      onTap: () {
                        dataBaseUpdate(global.currentUser.id, 'status', 0);
                        global.currentUser = UserDB(id: 'id', fullName: 'fullName');
                        Navigator.of(context).popUntil(ModalRoute.withName('/login'));

                      },

                    )),
                  ],
            ),
          ),
        ),
      )
    );
  }
}