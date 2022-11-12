import 'dart:convert';

import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/model/garden/garden_item.dart';
import 'package:flutter/services.dart';

import 'package:eden_garden/controllers/globals.dart' as global;



class UserDB {

  late String fullName;
  late String phone;
  late String email;
  late String password;
  late String pseudo;
  late String id;

  late List<String> myGarden;

  late List<GardenItem> myGardenObject = [];

  late int online = 1; // 0 : is not online , 1 : is online or 2 : is busy


  UserDB({required this.id, required this.fullName, this.phone = "phone",  this.pseudo = "pseudo", this.email = "email", this.password = "password", required this.myGarden});


  void setID(String newID){
    id = newID;
    /*print(fullName);
    print(password);
    print(pseudo);
    print(email);

     */
  }

  void setName(String newFullName){
    fullName = newFullName;
  }

  void setPhone(String newPhone){
    phone = newPhone;
  }

  void setPseudo(String newPs){
    pseudo = newPs;
  }

  void setEmail(String newEmail){
    email = newEmail;
  }

  void setPassword(String newPassword){
    password = newPassword;
  }

  bool addGardenItem(GardenItem newItem){
    bool ret = false;
    /// Check if Garden item already exist in my garden list
    if (!myGarden.contains(newItem.idKey)){
      if (!myGardenObject.contains(newItem)){
        myGarden.add(newItem.idKey);
        myGardenObject.add(newItem);

        dataBaseUpdate(id, 'my garden', myGarden);
        ret = true;
      }
    }
    return ret;
  }

  bool removeGardenItem(GardenItem item){
    bool ret = false;
    /// Check if Garden item exist in my garden list
    if (myGarden.contains(item.idKey)) {
      myGarden.remove(item.idKey);
      myGardenObject.remove(item);
      //print('DATABASE' + myGarden.toString());
      dataBaseUpdate(id, 'my garden', myGarden);
      ret = true;
    }
    return ret;
  }

  Future<void> constructGardenObject() async {
    final String response = await rootBundle.loadString('data/jsonData.json');
    //print(response);
    global.docGarden = await json.decode(response);
    for (var item in myGarden){
      //print(item);
      myGardenObject.add(GardenItem(
        idKey: item,
        description: global.docGarden[item]['description'],
        scientist: global.docGarden[item]['sc'],
        species: global.docGarden[item]['species'],
        product: global.docGarden[item]['product'],
        environment: global.docGarden[item]['environment'],
        farm: global.docGarden[item]['farm'],

        image: global.docGarden[item]['image'].toString().replaceAll(' ', ''),
      ));
    }
  }




  Map<String, dynamic> returnJson()  {

    final ret = <String, dynamic>{
      "fullName": fullName,
      "phone": phone,
      "pseudo": pseudo,
      "email": email,
      "password": password,
      "my garden": myGarden,
    };
    return ret;
  }

  void fromJson(Map<String, dynamic> js) {

    fullName = js['fullName'];
    email = js['email'];
    pseudo = js['pseudo'];
    phone = js['phone'];
    password = js['password'];
    myGarden = List<String>.from(js['my garden']);
  }

}