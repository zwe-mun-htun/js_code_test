
import 'package:flutter/material.dart';
import 'package:js_code_test/src/presentations/views/views.dart';

import '../data/model/document_data.dart';
import '../presentations/views/detection_list/detection_list_page.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const uploadDetection = '/upload';
  static const myUploads = '/my_uploads';

  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    //Routes
    switch (settings.name) {
      case home:
        return buildRoute(const CameraPage());

      case uploadDetection:
        DocumentData data = settings.arguments as DocumentData;
        return buildRoute(CreateDetectionPage(
          documentData: data,
        ));

      case myUploads: 
        return buildRoute(const DetectionListPage());

      default:
        throw Exception('Route does not exists');
    }
  }
}
