import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:flutter/material.dart';


/// Button Rect on View with border color

class ButtonCircle extends StatelessWidget {

  final Icon icon;
  final Function()? onPressed;

  final double height;
  final double width;

  final Color colorBorder;
  final Color colorBackground;


  const ButtonCircle({
    Key? key,
    this.height = 50,
    this.width = 60,
    this.onPressed, this.icon = const Icon(Icons.edit),
    this.colorBorder = const Color(0x73000000), this.colorBackground = Colors.white
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SlideAnimationController(
            delay: 900,
            child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                  color: colorBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorBorder,
                    width: 3,
                  )),
                  child: Center(
                      child:
                      IconButton(
                        onPressed: onPressed,
                        icon: icon,

                      ),

                    ),
        )
    );
  }
}