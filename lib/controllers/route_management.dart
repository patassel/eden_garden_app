import 'package:flutter/material.dart';


class FadeInRoute extends PageRouteBuilder {
  final Widget page;

  /// UPDATE DATE USER STATUT POUR OUVERTURE AUTOMATIQUE SUR BONNE VIEW

  FadeInRoute({required this.page, required String routeName})
      : super(
    settings: RouteSettings(name: routeName),            // set name here
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
     FadeTransition(
      opacity: animation,
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 500),
  );
}


class ZoomInRoute extends PageRouteBuilder {
  final Widget page;

  ZoomInRoute({required this.page, required String routeName})
      : super(
    settings: RouteSettings(name: routeName),            // set name here
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        ),
    transitionDuration: const Duration(milliseconds: 500),
  );
}



class RotationInRoute extends PageRouteBuilder {
  final Widget page;

  RotationInRoute({required this.page, required String routeName})
      : super(
    settings: RouteSettings(name: routeName),            // set name here
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ){
      animation =CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

      return ScaleTransition(
        alignment: Alignment.center,
        scale: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 700),
  );
}









