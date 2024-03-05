import 'package:cloud_firestore/cloud_firestore.dart';

class CustomQRCode {
  final String id;
  final String qrCode;
  final String type;
  // speaker or stant
  final String title;
  final String description;
  final String photoUrl;
  final int point;

  CustomQRCode({
    required this.id,
    required this.qrCode,
    required this.type,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.point,
  });

  factory CustomQRCode.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CustomQRCode(
      id: data['id'],
      qrCode: data['qrCode'],
      type: data['type'],
      title: data['title'],
      description: data['description'],
      photoUrl: data['photoUrl'],
      point: data['point'],
    );
  }
}
