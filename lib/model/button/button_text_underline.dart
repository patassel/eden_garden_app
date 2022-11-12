
import 'package:flutter/material.dart';

/// Button Text + Divider on View with color onHover

class ButtonTextDivider extends StatelessWidget {

  final String title;
  final double titleSize;

  final double widthDivider;
  final int speedDivider;

  final Color colorHover;
  final Color colorText;
  final Color colorDivider;

  final Function()? onclickButton;
  final Function(bool)? onHoverMouse;


  const ButtonTextDivider({Key? key, required this.title, this.titleSize=12, this.widthDivider = 50, this.speedDivider = 500,
    this.colorHover = const Color(0xFFFF7043), this.colorText = Colors.black, this.colorDivider = Colors.black,
    required this.onclickButton, required this.onHoverMouse})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return

      Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 50,
          width: 100,
          child:
          InkWell(

            onHover: onHoverMouse,
            hoverColor: Colors.transparent,
            onTap: onclickButton!,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children : [
                Center(
                  child: Text(
                      title,
                      style:
                      TextStyle(
                        color: colorText,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotMono',
                        fontSize: titleSize,)
                  ),
                ),
                AnimatedSize(
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: speedDivider),
                    child: SizedBox(
                        width: widthDivider,
                        child:
                        Divider(
                          thickness: 3,
                          color: colorDivider,
                        )
                  ),)

            ]),
          ),
        )
        ,);

  }

}