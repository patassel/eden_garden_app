import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


final docUser = FirebaseFirestore.instance;


/// Create newUser
Future dataBaseWriteToUser(String id, Map<String, dynamic> js) async{

  await docUser.collection('users').doc(id).set(js);

}

/// Create new Id : key for newUser
Future dataBaseWriteToId(String id, Map<String, dynamic> js) async{
  await docUser.collection('id').doc(id).set(js);

}

/// Update current User
Future dataBaseUpdate(String id, String idKey, dynamic valueKey) async{
  await docUser.collection('users').doc(id).update(
      {idKey : valueKey,}
  );

}

/// Update and connect Current User
Future dataBaseRead(String id) async{
  final docRef = docUser.collection('users').doc(id);
  global.currentUser.setID(id);
  Map<String, dynamic>? data ;
  docRef.get().then(
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>?;
          global.currentUser.fromJson(data!); /// Construct User Object
          global.currentUser.setID(id);
          global.currentUser.constructGardenObject(); /// Construct Garden Object

    },
    onError: (e) => print("Error getting document: $e"),
  );


}

/// Check if User Id exist in Database
Future<bool> dataBaseCheckUserId(String email) async{
  final snapShot = await FirebaseFirestore.instance
      .collection('id')
      .doc(email) // varuId in your case
      .get();

  if (snapShot.exists) {
    //print("EXIST ${snapShot.data()!['id']}");
    return true;
  }

  return false;

}