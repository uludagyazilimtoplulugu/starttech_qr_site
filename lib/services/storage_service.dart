// import 'dart:typed_data';

// import 'package:firebase_storage_web/firebase_storage_web.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// import 'dart:html' as html;

// import 'package:firebase_storage_web/firebase_storage_web.dart';

// class StorageService {
//   // final Reference _storage = FirebaseStorage.instance.ref();
//   // String? resimId;

//   // Future<String> uploadFile(Uint8List list) async {

//   //   resimId = const Uuid().v4();

//   //   String imageUrl = '';
//   //   try {
//   //     UploadTask uploadTask;

//   //     Reference ref = _storage.child('resimler/profil/profil_$resimId.jpg');

//   //     final metadata = SettableMetadata(contentType: 'image/jpeg');

//   //     //uploadTask = ref.putFile(File(file.path));
//   //     uploadTask = ref.putData(list, metadata);

//   //     await uploadTask.whenComplete(() => null);
//   //     imageUrl = await ref.getDownloadURL();
//   //   } catch (e) {
//   //     debugPrint('Hata: $e');
//   //   }
//   //   return imageUrl;
//   // }

// // Assuming you have Firebase initialized in your app

//   Future<String> uploadFile(Uint8List list) async {
//     final ref = FirebaseStorageWeb(bucket: 'gs://starttech-qr.appspot.com').ref(
//       'resimler/profil/profil_${const Uuid().v4()}.jpg',
//     );

//     var ref2 = ref.putData(list);

//     ref2.snapshotEvents.listen((event) {
//       print('Task state: ${event.state}');
//       print('Progress: ${event.totalBytes / event.bytesTransferred}');
//     });

//     var url = await ref2.onComplete;

//     return url.ref.getDownloadURL();
//   }
// }

// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  Future<String> uploadFile(Uint8List list) async {
    String resimId = '${const Uuid().v4()}.jpg';

    await Supabase.instance.client.storage
        .from('profile_photos')
        .uploadBinary(resimId, list);

    final res = Supabase.instance.client.storage
        .from('profile_photos')
        .getPublicUrl(resimId);

    return res;
  }
}
