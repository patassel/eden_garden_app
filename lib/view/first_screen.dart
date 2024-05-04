


import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/view/login_screen.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:eden_garden/controllers/globals.dart' as global;


import 'package:shared_preferences/shared_preferences.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key) ;

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

/// First screen displayed when the user open the application
class _FirstScreenState extends State<FirstScreen> with SingleTickerProviderStateMixin {

  /// Animation Ticker with Time Control and Optional style
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

  @override
  void initState() {
    super.initState();

    /// Initiate User Data SharedPreference
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      global.dataUser = sp;
    });

    /// Initiate Init PushReplacement
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, FadeInRoute( // FadeInRoute  // ZoomInRoute  // RotationInRoute
        page: const LoginScreen(from: "init"), //ContactScreen(),
        routeName: '/login',
      ),);
    }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    //initiateSetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body:

      Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            /// Style Transform Style Animation
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: child,
            );
          },
          /// Logo
          child: Image.asset('assets/edenLogo.jpg', height: 200,),
        ))
    );
  }

}