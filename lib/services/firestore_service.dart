import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // check there is a user with the given email
  Future<bool> checkUserWithEmail(String email) async {
    var result =
        await _db.collection('users').where('email', isEqualTo: email).get();
    return result.docs.isNotEmpty;
  }

  // check there is a user with the given phone number
  Future<bool> checkUserWithPhoneNumber(String phoneNumber) async {
    var result = await _db
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    return result.docs.isNotEmpty;
  }

  // add user to firestore
  Future<void> addUserToFirestore(
    String email,
    String phoneNumber,
    String name,
    String photoUrl,
  ) async {
    await _db.collection('users').add({
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // update user's details
  Future<void> updateUserDetails(
    String id,
    String email,
    String phoneNumber,
    String name,
    String photoUrl,
  ) async {
    await _db.collection('users').doc(id).update({
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
