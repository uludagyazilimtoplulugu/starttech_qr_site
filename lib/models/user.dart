import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final String phoneNumber;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String qrCode;
  final List scannedQrCodes;
  final int point;

  FirestoreUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.qrCode,
    required this.scannedQrCodes,
    required this.point,
  });

  factory FirestoreUser.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FirestoreUser(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      qrCode: data['qrCode'],
      scannedQrCodes: data['scannedQrCodes'],
      point: data['point'],
    );
  }
}
