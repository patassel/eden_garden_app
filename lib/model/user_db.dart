import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  late String profileUrl = "";
  late List<dynamic> myGardenPicture = [{},{},{}];


  late Map<String, Map<String, dynamic>> myGarden = {}; // garden User information
  late List<GardenItem> myGardenObject = []; // Garden General information

  late Map<String, dynamic> myCommunity = {'family' : [], 'request' : [], 'group' : []};
  late List<UserDB> myCommunityObject = [];
  //late Map<String, dynamic> groupCommunity = {};


  late int status = 1; // 0 : is not online , 1 : is online or 2 : is busy


  UserDB({required this.id, required this.fullName, this.phone = "phone",  this.pseudo = "pseudo", this.email = "email", this.password = "password"});


  void setID(String newID){
    id = newID;

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

  Future checkGardenPictureIsConform() async{
    bool flag = false;
    for (int i=0; i<myGardenPicture.length; i++){

      if (myGardenPicture[i].isNotEmpty) {
        //print(myGardenPicture[i].toString());
        if (myGardenPicture[i]['locate'] == 'cache') {
          if (global.dataUser.getDouble('garden$i.jpg') == null) {
            myGardenPicture[i].clear();
            flag = true;
          }
        }
      }
    }

    if (flag){
      await dataBaseUpdate(id, 'gardenPicture', myGardenPicture);
    }
  }


  /// Community -----------------------------------------------------------------
  void addEdenCommunity(UserDB newUser){
    myCommunity['family']!.add(newUser.id);
    myCommunityObject.add(newUser);
  }

  void removeEdenCommunity(UserDB newUser){
    myCommunity['family']!.remove(newUser.id);
    myCommunityObject.remove(newUser);

    dataBaseUpdate(id, 'community', myCommunity);
  }

  void receiveRequestCommunity(String type, String idSender, String emailSender, String nameSender,  String url, String message, List<Map<String, String>> members){

    if (type=='group') {
     myCommunity['request'].add(
            {'group' :
            {
              'by' : idSender,
              'email' : emailSender,
              'name' : nameSender,
              'members' : members,
              'message' : message,
              'urlPicture' : url,
              'date' : Timestamp.now(),
            }
            });
    }else{
      myCommunity['request'].add(
          { 'family' :
          {
            'by' : idSender,
            'email' : emailSender,
            'name' : nameSender,
            'message' : message,
            'urlPicture' : url,
            'date' : Timestamp.now(),
          }
          });
    }
    dataBaseSet(id, 'community', myCommunity);
  }

  Future<void> constructCommunityObject() async {
    if (myCommunityObject.isNotEmpty) {
      //print('Not EMPTY');
      for (int i=0; i< myCommunity['family'].length ; i++){
        String item = myCommunity['family'][i];
        UserDB newUser = await dataBaseGetUser(item);
        myCommunityObject[i] = newUser;
      }
    }else {
      //print('EMPTY');
      for (var item in myCommunity['family']){
        //print(item);
        UserDB newUser = await dataBaseGetUser(item);
        myCommunityObject.add(newUser);
      }
    }
  }
  /// Community -----------------------------------------------------------------


  /// Garden -----------------------------------------------------------------
  bool addGardenItem(GardenItem newItem){
    bool ret = false;
    /// Check if Garden item already exist in my garden list
    if (!myGarden.keys.contains(newItem.idKey)){
      if (!myGardenObject.contains(newItem)){
        myGarden[newItem.idKey] = {
          'quantity' : 0,
          'production' : 0,
          'date' : Timestamp.now(),
          'ripe' : 0,
          'rotten' : 0,
          'notification' : [],
          'settings' : [false, false],
        };
        myGardenObject.add(newItem);
        dataBaseUpdate(id, 'garden', myGarden);
        ret = true;
      }
    }
    return ret;
  }

  bool removeGardenItem(GardenItem item){
    bool ret = false;
    /// Check if Garden item exist in my garden list
    if (myGarden.keys.contains(item.idKey)) {
      myGarden.remove(item.idKey);
      myGardenObject.remove(item);
      //print('DATABASE' + myGarden.toString());
      dataBaseUpdate(id, 'garden', myGarden);
      ret = true;
    }
    return ret;
  }

  Future<void> constructGardenObject() async {

    if (global.docGarden.isEmpty) {
      final String response = await rootBundle.loadString('data/jsonData.json');
      global.docGarden = await json.decode(response);
    }

    myGardenObject.clear();
    if (myGarden.isNotEmpty) {
      for (var item in myGarden.keys) {
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
  }
  /// Garden -----------------------------------------------------------------



  Map<String, dynamic> returnJson()  {

    final ret = <String, dynamic>{
      "fullName": fullName,
      "phone": phone,
      "pseudo": pseudo,
      "email": email,
      "password": password,
      "profileUrl" : profileUrl,
      "gardenPicture" : myGardenPicture,
      "status" : status,
      "garden": myGarden,
      "community" : myCommunity,

    };
    return ret;
  }

  void fromJson(Map<String, dynamic> js) {

    fullName = js['fullName'];
    email = js['email'];
    pseudo = js['pseudo'];
    phone = js['phone'];
    password = js['password'];
    profileUrl = js['profileUrl'];
    status = js['status'];
    myGardenPicture = List<dynamic>.from(js['gardenPicture']);
    myGarden = Map<String, Map<String, dynamic>>.from(js['garden']);
    myCommunity = Map<String, dynamic>.from(js['community']);


  }

}