import 'dart:async';

import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/model/garden/article/garden_article.dart';
import 'package:eden_garden/model/button/button_text_underline.dart';
import 'package:eden_garden/model/garden/garden_item.dart';
import 'package:eden_garden/view/gardenArticle/garden_article_info_screen.dart';
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
  void initState() {
    super.initState();

  }

  initiateSetState() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

        onTap: () async {
          flagOnHover= true;
          setState(() {

          });
          gardenArticleWidget();
        },
        child : Container(
            height: widget.height,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFF),

            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Container(
                    height: (global.currentPlatform=='and' || global.currentPlatform=='ios') ? widget.height*0.5 :  widget.height/2,
                    width: widget.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage("https://${widget.article.information['image']}"),
                          fit: BoxFit.cover
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),)
                ),

                SizedBox(
                  width: widget.width,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          widget.article.title,
                          style: const TextStyle(
                            color:  Colors.black,
                            fontFamily: 'meri',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          )
                      ),

                      ButtonTextDivider(
                        title: 'Learn More',
                        colorText: flagOnHover  ? Colors.green : Colors.black,
                        colorDivider: flagOnHover  ? Colors.green : Colors.black,
                        onclickButton: () async {
                          flagOnHover= true;
                          setState(() {

                          });

                          gardenArticleWidget();
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
        ));
  }


  Future<void> gardenArticleWidget() async{

    return
      await Future.delayed(const Duration(milliseconds: 800), () {setState(() {
        flagOnHover=false;

        Navigator.push( // push -> Add route on stack
          context,
          FadeInRoute( // FadeInRoute  // ZoomInRoute  // RotationInRoute
            page: GardenArticleInfoScreen(
                from: "search",
                function: initiateSetState,
                item: GardenItem(
                  idKey: widget.article.title,
                  scientist:  widget.article.information['sc'],
                  species:  widget.article.information['species'],
                  product:  widget.article.information['product'],
                  description:  widget.article.information['description'],
                  environment: widget.article.information['environment'],
                  farm: widget.article.information['farm'],
                  sprinkle: widget.article.information['sprinkle'],
                  prune: widget.article.information['prune'],
                  harvest: widget.article.information['harvest'],
                  image: widget.article.information['image'],
                )), //ContactScreen(),
            routeName: '/search/${widget.article.title}',
          ),
        );});});



  }

}