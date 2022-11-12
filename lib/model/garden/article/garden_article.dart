import 'package:flutter/material.dart';


class GardenArticle {

   late final String title;
   late final Map<String, dynamic> information;

   GardenArticle({this.title = "", required this.information});


   void setTitle(String newTitle){
     title = newTitle;
   }

   void setDescription(String newDescription){
     information['description'] = newDescription;
   }

   void setImage(AssetImage newImage){
     information['image'] = newImage;
   }
}