import 'dart:typed_data';

import 'package:js_code_test/main.dart';
import 'package:js_code_test/src/data/data_source/firebase_data_source.dart';
import 'package:js_code_test/src/data/model/photo_detection.dart';
import 'package:js_code_test/src/domain/repositories/detection_repository.dart';

class DetectionRepositoryImpl extends DetectionRepository {
  final FirebaseDataSource _dataSource = injector();

  @override
  Stream<Iterable<PhotoDetection>> getPhotoDetections() {
    return _dataSource.getPhotoDections();
  }

  @override
  Future<void> uploadNewDetection(String name, Uint8List? image) {
   return _dataSource.uploadNewDetection(name, image);
  }
}
