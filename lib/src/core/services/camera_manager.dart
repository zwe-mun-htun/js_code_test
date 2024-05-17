import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:camera_windows/camera_windows.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scan_sdk/document_result.dart';

import '../../data/model/document_data.dart';
import '../../navigation/routes.dart';
import 'doucment_scanner.dart';

class CameraManager {
  BuildContext context;
  CameraController? controller;
  late List<CameraDescription> _cameras;
  Size? previewSize;
  List<DocumentResult>? documentResults;
  bool isDriverLicense = true;
  bool isFinished = false;
  StreamSubscription<FrameAvailabledEvent>? _frameAvailableStreamSubscription;
  int cameraIndex = 0;
  bool isReadyToGo = false;
  bool _isWebFrameStarted = false;

  CameraManager(
      {required this.context,
      required this.cbRefreshUi,
      required this.cbIsMounted,
      required this.cbNavigation});

  Function cbRefreshUi;
  Function cbIsMounted;
  Function cbNavigation;

  void initState() {
    initCamera();
  }

  void resumeCamera() {
    toggleCamera(cameraIndex);
  }

  void pauseCamera() {
    stopVideo();
  }

  Future<void> waitForStop() async {
    while (true) {
      if (_isWebFrameStarted == false) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 10));
    }
  }


  Future<void> stopVideo() async {
    isFinished = true;
    if (kIsWeb) {
      await waitForStop();
    }
    if (controller == null) return;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await controller!.stopImageStream();
    }

    controller!.dispose();
    controller = null;

    _frameAvailableStreamSubscription?.cancel();
    _frameAvailableStreamSubscription = null;
  }

  //Web Camera Setup for image creation and detection
  Future<void> webCamera() async {
    _isWebFrameStarted = true;
    while (!(controller == null || isFinished || cbIsMounted() == false)) {
      XFile file = await controller!.takePicture();
      var results = await docScanner.detectFile(file.path);
      if (!cbIsMounted()) break;

      documentResults = results;
      cbRefreshUi();

      if (isReadyToGo && results!.isEmpty) {
        isFinished = true;
        final data = await file.readAsBytes();
        ui.Image sourceImage = await decodeImageFromList(data);
        goToCreateDetection(sourceImage);
      } else {
        if (isReadyToGo && results != null && results.isNotEmpty) {
          if (!isFinished) {
            isFinished = true;

            final data = await file.readAsBytes();
            ui.Image sourceImage = await decodeImageFromList(data);
            cbNavigation(DocumentData(
              image: sourceImage,
              documentResults: documentResults!,
            ));
          }
        }
      }
    }
    _isWebFrameStarted = false;
  }

  //Start Camera
  Future<void> startVideo() async {
    documentResults = null;

    isFinished = false;

    cbRefreshUi();

    if (kIsWeb) {
      webCamera();
    }
  }

  Future<void> initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      if (!kIsWeb) {
        toggleCamera(cameraIndex);
      } else {
        if (_cameras.length > 1) {
          cameraIndex = 1;
          toggleCamera(cameraIndex);
        } else {
          toggleCamera(cameraIndex);
        }
      }
    } on CameraException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget getPreview() {
    if (controller == null || !controller!.value.isInitialized || isFinished) {
      return const Text('No camera available!');
    }

    return CameraPreview(controller!);
  }

  Future<void> toggleCamera(int index) async {
    ResolutionPreset preset = ResolutionPreset.high;
    controller = CameraController(_cameras[index], preset);
    controller!.initialize().then((_) {
      if (!cbIsMounted()) {
        return;
      }

      previewSize = controller!.value.previewSize;

      startVideo();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }
  
  void goToCreateDetection(ui.Image image) {

    Navigator.pushReplacementNamed(context, Routes.uploadDetection, arguments: DocumentData(
                  image: image,
                  documentResults: null,
                ));
  
  }
}
