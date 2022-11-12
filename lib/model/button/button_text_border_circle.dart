import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:flutter/material.dart';


/// Button Rect on View with border color

class ButtonTextCircleBorder extends StatelessWidget {

  final String textTitle;
  final double textSize;
  final Color? textColor;

  final Function()? onPressed;
  final Color colorBorder;

  const ButtonTextCircleBorder({Key? key, required this.textTitle, required this.textSize, required this.textColor, this.onPressed, required this.colorBorder})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SlideAnimationController(
        delay: 500,
        child: Container(
          //width: 100,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: colorBorder, width: 3),
          ),
          child:
          TextButton(
              onPressed: onPressed!,
              child: AnimatedSize(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 800),
                child : Text(
                  textTitle,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'RobotMono',
                    fontWeight: FontWeight.w800,
                    fontSize: textSize,
                  )
              ),
            )),
          ),
    );
  }
}