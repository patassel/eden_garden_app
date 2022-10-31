
import 'package:flutter/material.dart';

/// Button Rect on View with border color

class ButtonRect extends StatelessWidget {

  final String title;
  final Color colorBorder;
  final Color colorBackground;
  final Color colorHover;
  final Color colorText;

  final Function()? onclickButton;
  final Function(bool)? onHoverMouse;


   const ButtonRect({Key? key, required this.title, required this.colorBorder,
    required this.colorBackground , required this.colorHover,  required this.colorText, required this.onclickButton, required this.onHoverMouse})
      : super(key: key);


  @override
  Widget build(BuildContext context) {


    return

      Material(
        color: Colors.transparent,
        child: Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
              color: colorBackground,
              border: Border.all(
                color: colorBorder,
                width: 3,
              )),

          child:

          InkWell(

            onHover: onHoverMouse!,
            hoverColor: colorHover,
            onTap: onclickButton!,

            child: Center(
              child: Text(
                  title,
                  style:
                  TextStyle(
                    color: colorText,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Open Sans',
                    fontSize: 15,)
              ),
            ),
          ),
        )
    ,);

  }

}