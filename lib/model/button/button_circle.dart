import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:flutter/material.dart';


/// Button Rect on View with border color

class ButtonCircle extends StatelessWidget {

  final Function()? onPressed;

  const ButtonCircle({Key? key, this.onPressed})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SlideAnimationController(
        delay: 500,
        child: Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0x73000000),
                width: 3,
              )),
          child: Center(
            child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.edit),
            ),
          ),
        )
    );
  }
}