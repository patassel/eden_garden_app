


import 'package:eden_garden/model/article/garden_article.dart';
import 'package:eden_garden/model/button/button_text_underline.dart';
import 'package:flutter/material.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


class GardenArticleWidget extends StatefulWidget {

  final GardenArticle article;
  final double height;
  final double width;

  const GardenArticleWidget(
      {Key? key, required this.article, this.height = 300, this.width = 250})
      : super(key: key);

  @override
  State<GardenArticleWidget>  createState() => _GardenArticleWidgetState();

}
  class _GardenArticleWidgetState extends State<GardenArticleWidget> {

  late bool flagOnHover = false;


  @override
  Widget build(BuildContext context) {
    return Container(

      height: widget.height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),

        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
                height: (global.currentPlatform=='and' || global.currentPlatform=='ios') ? widget.height*0.5 :  widget.height/2,
                width: widget.width,

                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.article.image,
                      fit: BoxFit.cover
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),                )
          ),

           SizedBox(
            width: widget.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    Text(
                        widget.article.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'meri',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        )
                          ),

                ButtonTextDivider(
                  title: 'Learn More',
                  colorText: flagOnHover? const Color(0xFFFF7043) : Colors.black,
                  colorDivider: flagOnHover? const Color(0xFFFF7043) : Colors.black,
                  onclickButton: () {
                    flagOnHover= !flagOnHover;
                    setState(() {

                    });
                  },
                  widthDivider: flagOnHover? 60 : 30,
                  onHoverMouse: (val ) {
                      flagOnHover = val;
                      setState(() {

                      });
                  },
                ),



              ],
            ),
          )

        ],
      )
    );
  }

}