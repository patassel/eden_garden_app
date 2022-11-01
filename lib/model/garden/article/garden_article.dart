import 'package:flutter/material.dart';


class GardenArticle {

   late final String title;
   late final String description;
   late final NetworkImage image;

   GardenArticle({this.title = "", this.description = "", this.image = const NetworkImage("https://images.pexels.com/photos/4671829/pexels-photo-4671829.jpeg")});


   void setTitle(String newTitle){
     title = newTitle;
   }

   void setDescription(String newDescription){
     description = newDescription;
   }

   void setImage(NetworkImage newImage){
     image = newImage;
   }
}