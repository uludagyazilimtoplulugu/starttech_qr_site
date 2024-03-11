import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // check there is a user with the given uid
  Future<bool> checkAdminWithUid(String uid) async {
    var result = await _db.collection('admins').doc(uid).get();
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
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoUrl);

    await _db.collection('users').doc(id).update({
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'updatedAt': DateTime.now(),
    });
  }

  //update user's password
  Future<void> updateUserPassword({
    required String password,
    required String uid,
  }) async {
    await _db.collection('users').doc(uid).update({
      'password': password,
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

  // get all users from firestore
  Future<List<FirestoreUser>> getAllUsers() async {
    var result = await _db.collection('users').get();
    List<FirestoreUser> users = [];
    for (var doc in result.docs) {
      users.add(FirestoreUser.fromDoc(doc));
    }
    return users;
  }

  // get all users order by point
  Future<List<FirestoreUser>> getAllUsersOrderByPoint() async {
    var result = await _db
        .collection('users')
        .orderBy('point', descending: true)
        .get();
    List<FirestoreUser> users = [];
    for (var doc in result.docs) {
      users.add(FirestoreUser.fromDoc(doc));
    }
    return users;
  }

  // get all stants from firestore
  Future<List<CustomQRCode>> getStants() async {
    var result = await _db
        .collection('qr_codes')
        .where('type', isEqualTo: 'stant')
        .get();
    List<CustomQRCode> stants = [];
    for (var doc in result.docs) {
      stants.add(CustomQRCode.fromDoc(doc));
    }
    return stants;
  }

  // add stant to firestore
  Future<void> addStantToFirestore({
    required String title,
    required String description,
    required String photoUrl,
    required int point,
  }) async {
    var random = 1000000 + (DateTime.now().millisecondsSinceEpoch % 9000000);
    var qrCode = random.toString();
    var result = await _db
        .collection('qr_codes')
        .where('qrCode', isEqualTo: qrCode)
        .get();
    while (result.docs.isNotEmpty) {
      random = 1000000 + (DateTime.now().millisecondsSinceEpoch % 9000000);
      qrCode = random.toString();
      result = await _db
          .collection('qr_codes')
          .where('qrCode', isEqualTo: qrCode)
          .get();
    }

    await _db.collection('qr_codes').add({
      'title': title,
      'description': description,
      'photoUrl': photoUrl,
      'type': 'stant',
      'point': point,
      'qrCode': qrCode,
      'id': '',
    });

    // update id
    await _db.collection('qr_codes').where('qrCode', isEqualTo: qrCode).get();

    await _db.collection('qr_codes').doc(result.docs.first.id).update({
      'id': result.docs.first.id,
    });
  }

  // get all speakers from firestore
  Future<List<CustomQRCode>> getSpeakers() async {
    var result = await _db
        .collection('qr_codes')
        .where('type', isEqualTo: 'speaker')
        .get();
    List<CustomQRCode> stants = [];
    for (var doc in result.docs) {
      stants.add(CustomQRCode.fromDoc(doc));
    }
    return stants;
  }

  // add stant to firestore
  Future<void> addSpeakerToFirestore({
    required String title,
    required String description,
    required String photoUrl,
    required int point,
  }) async {
    var random = 1000000 + (DateTime.now().millisecondsSinceEpoch % 9000000);
    var qrCode = random.toString();
    var result = await _db
        .collection('qr_codes')
        .where('qrCode', isEqualTo: qrCode)
        .get();
    while (result.docs.isNotEmpty) {
      random = 1000000 + (DateTime.now().millisecondsSinceEpoch % 9000000);
      qrCode = random.toString();
      result = await _db
          .collection('qr_codes')
          .where('qrCode', isEqualTo: qrCode)
          .get();
    }
    await _db.collection('qr_codes').add({
      'title': title,
      'description': description,
      'photoUrl': photoUrl,
      'point': point,
      'qrCode': qrCode,
      'type': 'speaker',
      'id': '',
    });
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

  // kullanıcının taradığı qr kodları, qr_codes collection'dan al
  Future<List<CustomQRCode>> getCurrentUserScannedQrCodesSpeaker({
    required String uid,
  }) async {
    FirestoreUser? user = await getUser(uid: uid);
    List<CustomQRCode> qrCodes = [];
    for (var qrCode in user!.scannedQrCodes) {
      var result = await _db
          .collection('qr_codes')
          .where('qrCode', isEqualTo: qrCode)
          .where('type', isEqualTo: 'speaker')
          .get();
      if (result.docs.isNotEmpty) {
        qrCodes.add(CustomQRCode.fromDoc(result.docs.first));
      }
    }
    return qrCodes;
  }

  // kullanıcının taradığı qr kodları, qr_codes collection'dan al
  Future<List<CustomQRCode>> getCurrentUserScannedQrCodesStant({
    required String uid,
  }) async {
    FirestoreUser? user = await getUser(uid: uid);
    List<CustomQRCode> qrCodes = [];
    for (var qrCode in user!.scannedQrCodes) {
      var result = await _db
          .collection('qr_codes')
          .where('qrCode', isEqualTo: qrCode)
          .where('type', isEqualTo: 'stant')
          .get();
      if (result.docs.isNotEmpty) {
        qrCodes.add(CustomQRCode.fromDoc(result.docs.first));
      }
    }
    return qrCodes;
  }

  // kullanıcının qr kodunu taryana kullanıcılar
  Future<List<FirestoreUser>> getScannedUsersWithQrCode() async {
    FirestoreUser? user =
        await getUser(uid: FirebaseAuth.instance.currentUser!.uid);
    var result = await _db
        .collection('users')
        .where('scannedQrCodes', arrayContains: user!.qrCode)
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
      'updatedAt': DateTime.now(),
    });
  }

  // send feedback
  Future<void> sendFeedback({
    required String uid,
    required String feedback,
  }) async {
    await _db.collection('feedbacks').add({
      'uid': uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'photoUrl': FirebaseAuth.instance.currentUser!.photoURL,
      'email': FirebaseAuth.instance.currentUser!.email,
      'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
      'feedback': feedback,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
