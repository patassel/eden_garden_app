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
                  : global.ColorTheme().colorsViewBackgroundLight,
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
                        onTap: () {print("full name button");},
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
                      onTap: () {print("Pseudo button");},
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
                      onTap: () {print("phone button");},
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
                        onTap: () {print("gmail button");},
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
                        onTap: () {print("password button");},
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Services", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: themeSwitchVal ? Colors.white : Colors.green)),
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
                        onTap: () {print("language button");},

                      )),
                ],
              ),
            ),
          ),
        )
    );
  }

}