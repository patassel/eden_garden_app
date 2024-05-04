import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;


class AlertDialogApp{
  final BuildContext context;
  final Function? onAccept;
  final Function? onRefuse;
  final String title;
  final String body;
  final String accept;
  final String refuse;

  AlertDialogApp({required this.context, required this.onAccept, required this.onRefuse, this.title = 'title', this.body = 'body', this.accept = 'Accept', this.refuse = 'Refuse', });

  Future normalShowDialog() {

    return showDialog(
        context: context,
        builder:
            (context) => StatefulBuilder(builder : (context, setState)  =>  AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title:
              SlideAnimationController(
                  delay: 300,
                  child:
                  Center(child:Text(title,
                    style:const TextStyle(fontSize: 16, color: Colors.black,),
                  ))
              ),

              content: SlideAnimationController(
                  delay: 800,
                  child:
                  Padding(
                      padding: const EdgeInsets.only(left:20),child:
                  Text(body,
                    style:const TextStyle(fontSize: 16, color: Colors.black,),
                  ))
              ),

              actions: <Widget>[
                ButtonRect(
                    title: refuse,
                    colorBorder: Colors.transparent,
                    colorBackground: Colors.transparent,
                    colorHover: Colors.black,
                    colorText: global.ColorTheme().colorDeepDark,
                    onclickButton: () {
                      onRefuse!();
                      setState(() =>Navigator.pop(context));
                    },
                    onHoverMouse: (val) {}

                ),

                ButtonRect(
                    title: accept,
                    colorBorder: Colors.transparent,
                    colorBackground: Colors.transparent,
                    colorHover: Colors.black,
                    colorText: global.ColorTheme().colorDeepDark,
                    onclickButton: () {
                      onAccept!();
                      setState(() =>Navigator.pop(context));
                    },
                    onHoverMouse: (val) {}

                ),
              ],
            ))
    );
  }


}