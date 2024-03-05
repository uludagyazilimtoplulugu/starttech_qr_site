import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final Reference _storage = FirebaseStorage.instance.ref();
  String? resimId;

  Future<String> uploadFile(Uint8List list) async {
    resimId = const Uuid().v4();

    String imageUrl = '';
    try {
      UploadTask uploadTask;

      Reference ref = _storage.child('resimler/profil/profil_$resimId.jpg');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      //uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(list, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Hata: $e');
    }
    return imageUrl;
  }
}
