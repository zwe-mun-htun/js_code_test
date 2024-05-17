import 'dart:typed_data';

import 'package:js_code_test/src/data/model/photo_detection.dart';

abstract class DetectionRepository {
  //Photo Detections List
  Stream<Iterable<PhotoDetection>> getPhotoDetections();

  //Create New Photo Detection
  Future<void> uploadNewDetection(String name, Uint8List? image);
}
