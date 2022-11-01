

class GardenItem {

  late String scientist; // scientist name of Garden Item
  late String idKey;  // name of Garden Item
  late String description;
  late String image;
  late String type;

  GardenItem({this.scientist = "", this.idKey = "", this.description = "", this.type = "", this.image = "https://images.pexels.com/photos/4671829/pexels-photo-4671829.jpeg"});

  void setIdKey(String newIdKey){
    idKey = newIdKey;
  }
  void setTitle(String newTitle){
    scientist = newTitle;
  }

  void setDescription(String newDescription){
    description = newDescription;
  }

  void setImage(String newImage){
    image = newImage;
  }

  Map<String, dynamic> returnJson()  {

    final ret = <String, dynamic>{
      "scientist": scientist,
      "idKey": idKey,
      "description": description,
      "image": image,
      "type": type,
    };
    return ret;
  }

  void fromJson(Map<String, dynamic> js) {

    scientist = js['scientist'];
    idKey = js['idKey'];
    description = js['description'];
    image = js['image'];
    type = js['type'];


  }
}