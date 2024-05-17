import 'package:flutter/material.dart';
import 'package:flutter_document_scan_sdk/document_result.dart';
import 'package:flutter_document_scan_sdk/flutter_document_scan_sdk.dart';
import 'package:flutter_document_scan_sdk/template.dart';
import 'dart:ui' as ui;

import '../../presentations/values/values.dart';
import '../utils/configs.dart';

FlutterDocumentScanSdk docScanner = FlutterDocumentScanSdk();

Future<int> initDocumentSDK() async {
  int? ret = await docScanner.init(
      Configs.kScannerKey);
  await docScanner.setParameters(Template.color);
  return ret ?? -1;
}

Widget createOverlay(
  List<DocumentResult>? documentResults,
) {
  return CustomPaint(
    painter: OverlayPainter(null, documentResults),
  );
}

class OverlayPainter extends CustomPainter {
  ui.Image? image;
  List<DocumentResult>? results;

  OverlayPainter(this.image, this.results);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kPrimaryColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    if (image != null) {
      canvas.drawImage(image!, Offset.zero, paint);
    }

    Paint circlePaint = Paint()
      ..color = AppColors.kPrimaryColor
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    if (results == null) return;

    for (var result in results!) {
      canvas.drawLine(result.points[0], result.points[1], paint);
      canvas.drawLine(result.points[1], result.points[2], paint);
      canvas.drawLine(result.points[2], result.points[3], paint);
      canvas.drawLine(result.points[3], result.points[0], paint);

      if (image != null) {
        double radius = 40;
        canvas.drawCircle(result.points[0], radius, circlePaint);
        canvas.drawCircle(result.points[1], radius, circlePaint);
        canvas.drawCircle(result.points[2], radius, circlePaint);
        canvas.drawCircle(result.points[3], radius, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => true;
}

List<DocumentResult> rotate90document(List<DocumentResult>? input, int height) {
  if (input == null) {
    return [];
  }

  List<DocumentResult> output = [];
  for (DocumentResult result in input) {
    double x1 = result.points[0].dx;
    double x2 = result.points[1].dx;
    double x3 = result.points[2].dx;
    double x4 = result.points[3].dx;
    double y1 = result.points[0].dy;
    double y2 = result.points[1].dy;
    double y3 = result.points[2].dy;
    double y4 = result.points[3].dy;

    List<Offset> points = [
      Offset(height - y1, x1),
      Offset(height - y2, x2),
      Offset(height - y3, x3),
      Offset(height - y4, x4)
    ];
    DocumentResult newResult = DocumentResult(result.confidence, points, []);

    output.add(newResult);
  }

  return output;
}
