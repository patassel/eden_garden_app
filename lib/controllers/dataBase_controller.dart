import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


final docUser = FirebaseFirestore.instance;


Future dataBaseWrite(String id, Map<String, dynamic> js) async{

  await docUser.collection('users').doc(id).set(js);

}

Future dataBaseUpdate(String id, String idKey, String valueKey) async{

  await docUser.collection('users').doc(id).update(
      {idKey : valueKey,}
  );

}


Future dataBaseRead(String id) async{

  final docRef = docUser.collection('users').doc(id);
  global.currentUser.setID(id);
  Map<String, dynamic>? data ;
  docRef.get().then(
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>?;
          global.currentUser.fromJson(data!);
    },
    onError: (e) => print("Error getting document: $e"),
  );


}

Future dataBaseCheck(String email) async{


  final snapShot = await FirebaseFirestore.instance
      .collection('id')
      .doc(email) // varuId in your case
      .get();

  if (snapShot.exists) {

    //print("EXIST ${snapShot.data()!['id']}");
    dataBaseRead(snapShot.data()!['id']);
  }

}