import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:js_code_test/src/data/model/photo_detection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../../../domain/repositories/detection_repository.dart';

part 'detection_list_state.dart';

class DetectionListCubit extends Cubit<DetectionListState> {

  final DetectionRepository _detectionRepository = injector();
  StreamSubscription? _detectionSubscription;

  DetectionListCubit() : super(const DetectionListState());

  Future<void> init() async {
    _detectionSubscription = _detectionRepository.getPhotoDetections().listen(myDetectionsListen);
  }

  //Detections List 
  void myDetectionsListen(Iterable<PhotoDetection> detections) async {
    emit(DetectionListState(
      isLoading: false,
      myDetections: detections,
    ));
  }

  @override
  Future<void> close() {
    _detectionSubscription?.cancel();
    return super.close();
  }
}
