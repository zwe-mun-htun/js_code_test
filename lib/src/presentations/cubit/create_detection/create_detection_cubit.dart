import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js_code_test/src/domain/repositories/detection_repository.dart';

import '../../../../main.dart';
part 'create_detection_state.dart';

class CreateDetectionCubit extends Cubit<CreateDetectionState> {
  
  final DetectionRepository _detectionRepository = injector();

  CreateDetectionCubit() : super(const CreateDetectionState());

  //Create New Detection 
  Future<void> createDetection(
    String name,
    Uint8List? photo
  ) async {
    emit(state.copyWith(isLoading: true));

    await _detectionRepository.uploadNewDetection(name, photo);
    emit(state.copyWith(isDone: true));
  }

}
