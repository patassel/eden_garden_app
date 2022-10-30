import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eden_garden/controllers/globals.dart' as global;


final docUser = FirebaseFirestore.instance.collection('users');


Future dataBaseWrite(String id, Map<String, dynamic> js) async{

  await docUser.doc(id).set(js);

}

Future dataBaseRead(String id) async{

  final docRef = docUser.doc(id);
  Map<String, dynamic>? data ;
  docRef.get().then(
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>?;
          global.currentUser.fromJson(data!);
    },
    onError: (e) => print("Error getting document: $e"),
  );


}