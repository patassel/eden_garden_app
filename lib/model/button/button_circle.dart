import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:flutter/material.dart';


/// Button Rect on View with border color

class ButtonCircle extends StatelessWidget {

  final Icon icon;
  final Function()? onPressed;
  final String tag;
  final String tip;


  final Color colorBorder;
  final Color colorBackground;


  const ButtonCircle({
    Key? key,
    this.tag = "",
    this.tip = "",

    this.onPressed, this.icon = const Icon(Icons.edit),
    this.colorBorder = const Color(0x73000000), this.colorBackground = Colors.white
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SlideAnimationController(
            delay: 900,
            child:

              FloatingActionButton(
                heroTag: tag,
                autofocus: true,
                focusElevation: 5,
                backgroundColor: colorBackground,
                tooltip: tip,
                shape: StadiumBorder(
                    side: BorderSide(color: colorBorder, width: 4)
                ),

                onPressed: () {
                  onPressed!();
                },

                child: icon,
              )
    );

  }
}