

import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/article/list_article_garden.dart';
import 'package:flutter/material.dart';

import 'widget_garden_article.dart';
//import 'package:provider/provider.dart';


class GridGardenArticleWidget extends StatelessWidget {

  final GardenArticleList myList ;
  final double height;
  final double width;
  final double widthScreen;

  const GridGardenArticleWidget({Key? key, required this.myList, required this.widthScreen , required this.height , required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
        GridView.count(

              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              // Generate 100 widgets that display their index in the List.
              children: List.generate(myList.articleList.length, (index) {
                return SlideAnimationController(
                    delay: 1000+(index*100),
                    child:Center(
                      child: GardenArticleWidget(
                        height: height,
                        width: width,
                        article: myList.articleList[index],
                      ),
                ));
              }),



    );


  }
}