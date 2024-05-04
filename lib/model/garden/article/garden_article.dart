import 'package:flutter/material.dart';


class GardenArticle {

   late final String title;
   late final Map<String, dynamic> information;

   GardenArticle(String newTitle, Map<String, dynamic> information){
     var split = newTitle.split(" ");

     if (split.length==1){
       newTitle = "${newTitle[0].toUpperCase()}${newTitle.substring(1,newTitle.length)}";
     }else{
       var temp = [];
       for (var item in split) {
         item = "${item[0].toUpperCase()}${item.substring(1,item.length)}";
         temp.add(item);
       }
       newTitle = temp.join(" ").toString();
     }
     this.title = newTitle;
     this.information = information;
   }



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