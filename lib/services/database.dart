import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference for users
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String uid, String name, String email,
      String channelNumber, String mobileNumber) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'Name': name,
      'email': email,
      'channel': channelNumber,
      'mobile': mobileNumber
    });
  }

  //getting user stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
