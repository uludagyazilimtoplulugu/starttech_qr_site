import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starttech_qr/models/qr_code.dart';
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

  // did user scan the qrCode before
  Future<bool> didUserScanTheQrCodeBefore({
    required String uid,
    required String qrCode,
  }) async {
    
    FirestoreUser? user = await getUser(uid: uid);
    for (var element in user!.scannedQrCodes) {
      if (element == qrCode) {
        return true;
      }
    }
    return false;
  }

  // get User from firestore with the given qrCode
  Future<FirestoreUser?> getUserWithQrCode({
    required String qrCode,
  }) async {
    var result =
        await _db.collection('users').where('qrCode', isEqualTo: qrCode).get();
    if (result.docs.isNotEmpty) {
      return FirestoreUser.fromDoc(result.docs.first);
    } else {
      return null;
    }
  }

  // kullanıcının taradığı kullanıcı qr kodları
  Future<List<FirestoreUser>> getCurrentUserScannedQrCodes({
    required String uid,
  }) async {
    FirestoreUser? user = await getUser(uid: uid);

    List<FirestoreUser> returnedUsers = [];
    List<FirestoreUser> allUsers = [];
    var result = await _db.collection('users').get();
    for (var doc in result.docs) {
      allUsers.add(FirestoreUser.fromDoc(doc));
    }

    debugPrint('allUsers: ${allUsers.length}');

    for (var qrCode in user!.scannedQrCodes) {
      for (var user in allUsers) {
        if (user.qrCode == qrCode) {
          returnedUsers.add(user);
        }
      }
    }

    return returnedUsers;
  }

  // kullanıcının taradığı qr kodları, qr_codes collection'dan al
  Future<List<CustomQRCode>> getCurrentUserScannedQrCodesFromQrCodes({
    required String uid,
  }) async {
    FirestoreUser? user = await getUser(uid: uid);
    List<CustomQRCode> qrCodes = [];
    for (var qrCode in user!.scannedQrCodes) {
      var result = await _db
          .collection('qr_codes')
          .where('qrCode', isEqualTo: qrCode)
          .get();
      if (result.docs.isNotEmpty) {
        qrCodes.add(CustomQRCode.fromDoc(result.docs.first));
      }
    }
    return qrCodes;
  }

  // kullanıcının qr kodunu taryana kullanıcılar
  Future<List<FirestoreUser>> getScannedUsersWithQrCode({
    required String qrCode,
  }) async {
    var result = await _db
        .collection('users')
        .where('scannedQrCodes', arrayContains: qrCode)
        .get();
    List<FirestoreUser> users = [];
    for (var doc in result.docs) {
      users.add(FirestoreUser.fromDoc(doc));
    }
    return users;
  }

  // get User from firestore with the given qrCode
  Future<CustomQRCode?> getCustomQRWithQRCode({
    required String qrCode,
  }) async {
    var result = await _db
        .collection('qr_codes')
        .where('qrCode', isEqualTo: qrCode)
        .get();
    if (result.docs.isNotEmpty) {
      return CustomQRCode.fromDoc(result.docs.first);
    } else {
      return null;
    }
  }

  // stream point
  Stream<int> streamPoint({
    required String uid,
  }) {
    return _db.collection('users').doc(uid).snapshots().map((event) {
      return event['point'];
    });
  }

  // update user's point and scannedQrCodes
  Future<void> updateUserPointAndScannedQrCodes({
    required String uid,
    required String scannedQrCode,
    required int point,
  }) async {
    debugPrint('point: $point');
    await _db.collection('users').doc(uid).update({
      'point': FieldValue.increment(point),
      'scannedQrCodes': FieldValue.arrayUnion([scannedQrCode]),
    });
  }
}
