

class GardenItem {

  late String scientist; // scientist name of Garden Item
  late String idKey;  // name of Garden Item
  late String description;
  late String image;
  late String species; // tree, bush or herbs
  late String product; // vegetable, fruit, plant flowers, alga or moss
  late String environment;
  late String farm; // Culture
  late String sprinkle; // drink water
  late String prune; // keep the plant healthy by cutting
  late String harvest; // harvest of fruit, vegetable or flowers


  GardenItem({this.scientist = "", this.idKey = "", this.description = "", this.species = "", this.product = "", this.environment = "", this.farm = "", this.sprinkle="", this.prune="", this.harvest="", this.image = "https://images.pexels.com/photos/4671829/pexels-photo-4671829.jpeg"});

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
      "type": species,
      "product": product,
      "farm": farm,
      "environment": environment,
      "sprinkle":sprinkle,
      "prune":prune,
      "harvest":harvest,
    };
    return ret;
  }

  void fromJson(Map<String, dynamic> js) {

    scientist = js['scientist'];
    idKey = js['idKey'];
    description = js['description'];
    image = js['image'];
    species = js['species'];
    product = js['product'];
    environment = js['environment'];
    farm = js['farm'];
    sprinkle = js['sprinkle'];
    prune = js['prune'];
    harvest = js['harvest'];


  }
}