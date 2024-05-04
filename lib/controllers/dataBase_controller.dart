import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eden_garden/controllers/globals.dart' as global;
import 'package:eden_garden/model/user_db.dart';


final docUser = FirebaseFirestore.instance;
final docStorage = FirebaseStorage.instance;

/// Firestore Database ---------------------------------------------------------

/// Create newUser
Future dataBaseWriteToUser(String id, Map<String, dynamic> js) async{

  await docUser.collection('users').doc(id).set(js);

}

/// Create new Id : key for newUser
Future dataBaseWriteToId(String id, Map<String, dynamic> js) async{
  await docUser.collection('id').doc(id).set(js);

}

/// Update value to UserID key
Future dataBaseUpdate(String id, String idKey, dynamic valueKey) async{
  await docUser.collection('users').doc(id).update(
      {idKey : valueKey,}
  );

}

/// Set value to UserID key with merging
Future dataBaseSet(String id, String idKey, dynamic valueKey) async{
  await docUser.collection('users').doc(id).set(
      {idKey : valueKey,}, SetOptions(merge: true)
  );



}

/// Update and connect Current User
Future dataBaseRead(String id) async{
  final docRef = docUser.collection('users').doc(id);
  global.currentUser.setID(id);
  Map<String, dynamic>? data ;
  docRef.get().then(
        (DocumentSnapshot doc) async {
          data = doc.data() as Map<String, dynamic>?;
          global.currentUser.fromJson(data!); /// Construct User Object
          global.currentUser.setID(id);
          global.currentUser.constructGardenObject(); /// Construct Garden Object
          global.currentUser.checkGardenPictureIsConform();

          if (global.currentUser.myCommunity['family'].isNotEmpty) {
            global.currentUser.constructCommunityObject();  /// Construct community
          }

          await Future.delayed(const Duration(milliseconds: 200), () {});

        },
    onError: (e) => print("Error getting document: $e"),
  );


}

/// get User object from database User email
Future<UserDB> dataBaseGetUser(String id) async{

  final docRef = docUser.collection('users').doc(id);
  UserDB newUser = UserDB(id: 'id', fullName: '');

  Map<String, dynamic>? data ;
  docRef.get().then(
        (DocumentSnapshot doc) async {
      data = doc.data() as Map<String, dynamic>?;
      newUser.fromJson(data!); /// Construct newUser Object
      newUser.setID(id); /// set newUser ID
      newUser.constructGardenObject(); /// Construct newUser Garden Object

      return newUser;
    },
    onError: (e) => print("Error getting document: $e"),
  );
  await Future.delayed(const Duration(milliseconds: 800), () {});

  return newUser;


}

/// get UserID from database User email
Future<String> dataBaseGetUserID(String email) async{
  //final docRef = docUser.collection('id').doc(email);


  String res = "";

  if (await dataBaseCheckUserId(email)) {
    final snapShot = await docUser.collection('id')
        .doc(email) // varuId in your case
        .get();
    if (snapShot.exists) {
      res = snapShot
          .data()!
          .values
          .first as String;
      //print("EXIST ${snapShot.data()!['id']}");
      return res;
    }
  }else{
    res = '0';
  }

  return res;

}

/// Check if User Id exist in Database
Future<bool> dataBaseCheckUserId(String email) async{
  final snapShot = await docUser.collection('id')
      .doc(email) // varuId in your case
      .get();

  if (snapShot.exists) {
    //print("EXIST ${snapShot.data()!['id']}");
    return true;
  }

  return false;

}

/// Firestore Database ---------------------------------------------------------


/// Storage Database -----------------------------------------------------------

Future databaseSaveProfilePicture(String userID, File imageFile) async{
  docStorage.ref().child('users/$userID/profile.jpg').putFile(imageFile);

  await Future.delayed(const Duration(milliseconds: 400), () {});

  global.currentUser.profileUrl = await databaseUploadProfilePicture(userID);

  await Future.delayed(const Duration(milliseconds: 400), () {});

  dataBaseUpdate(userID, 'profileUrl', global.currentUser.profileUrl);
}

Future<String> databaseUploadProfilePicture(String userID) async{

  // Create a reference with an initial file path and name
  final imageUrl = await docStorage.ref().child('users/$userID/profile.jpg').getDownloadURL();


  await Future.delayed(const Duration(milliseconds: 800), () {});


  return imageUrl;
}

Future<bool> databaseCheckProfilePicture(String userID) async {

  bool res = false;
  docStorage.ref().child('users/$userID/profile.jpg')
      .getDownloadURL()
      .then((response) => {
        res = true
  },
      onError: (e) => print("Error getting document: $e"),

  );
  await Future.delayed(const Duration(milliseconds: 800), () {});

  return res;
}


Future databaseSaveGardenPicture(String userID, File imageFile, int index, String message) async{
  await docStorage.ref().child('users/$userID/gardenPicture/garden$index.jpg').putFile(imageFile);


  global.currentUser.myGardenPicture[index] =
  {
    'locate' : 'db',
    'url' : await databaseUploadGardenPicture(userID, index),
    'message' : message,
    'path' : imageFile.path.split('/').last,
  };

  await Future.delayed(const Duration(milliseconds: 400), () {});

  dataBaseUpdate(userID, 'gardenPicture', global.currentUser.myGardenPicture);

  await Future.delayed(const Duration(milliseconds: 400), () {});

}

Future<String> databaseUploadGardenPicture(String userID, int index) async{
  // Create a reference with an initial file path and name
  final imageUrl = await docStorage.ref().child('users/$userID/gardenPicture/garden$index.jpg').getDownloadURL();

  await Future.delayed(const Duration(milliseconds: 800), () {});

  return imageUrl;
  }

Future<bool> databaseDeleteGardenPicture(String userID, int index) async{
  // Create a reference with an initial file path and name
  bool res = false;
  final fileToDelete = docStorage.ref().child('users/$userID/gardenPicture/garden$index.jpg');

  await fileToDelete.delete().then((response) => {
    res = true
  },
    onError: (e) => print("Error deleting document: $e"),

  );

  await Future.delayed(const Duration(milliseconds: 300), () {});

  return res;
}

/// Storage Database -----------------------------------------------------------
