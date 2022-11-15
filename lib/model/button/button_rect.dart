
import 'package:flutter/material.dart';

/// Button Rect on View with border color

class ButtonRect extends StatelessWidget {

  final String title;
  final double titleSize;
  final double height;
  final double width;
  final Color colorBorder;
  final Color colorBackground;
  final Color colorHover;
  final Color colorText;

  final Function()? onclickButton;
  final Function(bool)? onHoverMouse;



   const ButtonRect({Key? key, required this.title, this.titleSize = 15, required this.colorBorder, this.height = 50, this.width = 80,
    required this.colorBackground , required this.colorHover,  required this.colorText, required this.onclickButton, required this.onHoverMouse})
      : super(key: key);


  @override
  Widget build(BuildContext context) {


    return

      Material(
        color: Colors.transparent,
        child: Container(
          height: height,
          width: width,
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
                    fontSize: titleSize,)
              ),
            ),
          ),
        )
    ,);

  }

}