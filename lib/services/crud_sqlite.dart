
import 'package:cloud_firestore/cloud_firestore.dart';


//cloud firestore db: 
class CloudDB {
  CloudDB._(); 
  static final CloudDB firebaseReference = CloudDB._(); 
  Future<void> addCloudData(thedata) {
   Firestore.instance
   .collection("userscloud")
   .add(thedata)
  .then((value) => print(value))
  .catchError((error) {
    print("il y a une erreur: $error");
  });
  }

  gettheData() async {
    return Firestore.instance.collection("userscloud").getDocuments(); 
  }

}


