import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:js_code_test/src/data/model/photo_detection.dart';

class FirebaseDataSource {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Read all PhotoDetections as Unauthenticated
  Stream<Iterable<PhotoDetection>> getPhotoDections() {
    return firestore.collection('detections').snapshots().map(
        (event) => event.docs.map((e) => PhotoDetection.fromMap(e.data())));
  }

  // Create New Detection
  Future<void> uploadNewDetection(String name, Uint8List? image) async {
    final ref = firestore.collection('detections').doc();
    if (image != null) {
      final storageRef = storage.ref().child('${name}_${Timestamp.now().seconds}.png');
      await storageRef.putData(image, SettableMetadata(contentType: 'image/png') );

      final url = await storageRef.getDownloadURL();

      await ref.set({"name": name, "photo": url});
    }
  }
}
