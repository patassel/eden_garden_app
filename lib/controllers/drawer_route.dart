import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/route_management.dart';

import 'package:eden_garden/controllers/globals.dart' as global;
/// Route Management on Drawer menu

class DrawerRoute extends StatelessWidget {

  final String name;
  final String route;
  final Icon icon;
  final Widget widget;
  final String push;

  final Function()? function; // setState on parent widget


  const DrawerRoute(this.name,this.route,this.icon,this.widget,this.push, this.function, {Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    //final ThemeData _theme = Theme.of(context);
    //final _textTheme = _theme.textTheme;
    //final _colorScheme = _theme.colorScheme;

    return ListTile(

      leading: icon,
      title: OutlinedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: global.themeAppDark ? global.ColorTheme().colorFromDark
                : global.ColorTheme().colorFromLight,
            foregroundColor: Colors.black45,
            backgroundColor: Colors.white,
            //shadowColor: Colors.white,
            elevation: 10,
            // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

        onPressed: () {
          //print("MenuDrawer: $name");

          push == "push" ?
          Navigator.push(  // push -> Add route on stack
            context,
            FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
              page: widget, //ContactScreen(),
              routeName: route,
            ),
          ):
          Navigator.pushReplacement(  // pushReplacement -> Replace current route on Stack by a new routeName
            context,
            FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
              page: widget, //ContactScreen(),
              routeName: route,
            ),
          );



        },
        child: Text(
            name,
            style: TextStyle(
              color: global.ColorTheme().colorFromLight,
              fontWeight: FontWeight.w400,
              fontFamily: 'Open Sans',
              fontSize: 15,)
        ),
      ),
      onTap: () {

        push == "push" ?
        Navigator.push(
          context,
          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
            page: widget, //ContactScreen(),
            routeName: route,
          ),
        ):
        Navigator.pushReplacement(
          context,
          FadeInRoute(  // FadeInRoute  // ZoomInRoute  // RotationInRoute
            page: widget, //ContactScreen(),
            routeName: route,
          ),
        );

        function!();

      },
    );
  }

}



