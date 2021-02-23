
import 'package:cloud_firestore/cloud_firestore.dart';


//cloud firestore db: 
class CloudDB {
  CloudDB._(); 
  static final CloudDB firebaseReference = CloudDB._(); 
  Future<void> addCloudData(thedata) {
    CollectionReference collectionreference = Firestore.instance.collection("userscloud");
   return collectionreference
   .add(thedata)
  .then((value) => print(value))
  .catchError((error) {
    print("il y a une erreur: $error");
  });
  }

  gettheData() async {
    CollectionReference collectionreference = Firestore.instance.collection("userscloud");
    return collectionreference.getDocuments(); 
  }

  deleteData() async {
    CollectionReference collectionreference = Firestore.instance.collection("userscloud");
    QuerySnapshot querysnapshot = await collectionreference.getDocuments();
    querysnapshot.documents[0].reference.delete();
    //à vérifier
  }

  //reflechir à l'implémentation de cette methode
  updtateData( theupdateData) async {
    CollectionReference collectionreference = Firestore.instance.collection("userscloud");
    QuerySnapshot querysnapshot = await collectionreference.getDocuments();
    querysnapshot.documents[0].reference.updateData(theupdateData);
  } 
  //autre méthodes ? 
}

 




