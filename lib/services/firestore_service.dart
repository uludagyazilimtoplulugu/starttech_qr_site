import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starttech_qr/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // check there is a user with the given uid
  Future<bool> checkUserWithUid(String uid) async {
    var result = await _db.collection('users').doc(uid).get();
    return result.exists;
  }

  // add user to firestore
  Future<void> addUserToFirestore({
    required String uid,
    required String email,
    required String phoneNumber,
    required String name,
    required String photoUrl,
  }) async {
    // create random number between 100000 and 999999
    // check every user's qrCode, if the number is unique, use it
    // if the number is not unique, create new one
    var random = 100000 + (DateTime.now().millisecondsSinceEpoch % 900000);
    var qrCode = random.toString();
    var result =
        await _db.collection('users').where('qrCode', isEqualTo: qrCode).get();
    while (result.docs.isNotEmpty) {
      random = 100000 + (DateTime.now().millisecondsSinceEpoch % 900000);
      qrCode = random.toString();
      result = await _db
          .collection('users')
          .where('qrCode', isEqualTo: qrCode)
          .get();
    }

    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'qrCode': qrCode,
      'scannedQrCodes': [],
      'point': 0,
    });
  }

  // update user's details
  Future<void> updateUserDetails({
    required String id,
    required String email,
    required String phoneNumber,
    required String name,
    required String photoUrl,
  }) async {
    await _db.collection('users').doc(id).update({
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // get user from firestore
  Future<FirestoreUser?> getUser({
    required String uid,
  }) async {
    debugPrint('uid: $uid');
    var result = await _db.collection('users').doc(uid.toString()).get();
    if (result.exists) {
      return FirestoreUser.fromDoc(result);
    } else {
      return null;
    }
  }

  // update user's point and scannedQrCodes
  Future<void> updateUserPointAndScannedQrCodes({
    required String uid,
    required int point,
    required String scannedQrCode,
  }) async {
    await _db.collection('users').doc(uid).update({
      'point': point,
      'scannedQrCodes': FieldValue.arrayUnion([scannedQrCode]),
    });
  }
}
