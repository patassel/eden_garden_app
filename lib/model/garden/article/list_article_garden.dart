


import 'package:eden_garden/model/garden/article/garden_article.dart';

class GardenArticleList {
  late final List<GardenArticle> articleList ;

  GardenArticleList(){
    articleList = [];
  }

  GardenArticleList.fromList(List<GardenArticle> newArticleList){
    articleList = newArticleList;
  }

  void addArticle(GardenArticle newArticle){ articleList.add(newArticle);}

  void addArticleToIndex(GardenArticle newArticle, int index){
    if (index >= articleList.length){
      articleList[index] = newArticle;
    }
  }

  bool popArticle(GardenArticle newArticle){
    var res = articleList.remove(newArticle);

    return res;
  }

  void popMultiArticle(List<GardenArticle> newArticle){
    for (var item in newArticle) {
      articleList.remove(item);
    }
  }

}