library views;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../core/services/camera_manager.dart';
import '../../core/services/doucment_scanner.dart';
import '../../core/utils/utils.dart';
import '../../data/model/document_data.dart';
import '../../navigation/routes.dart';
import '../cubit/create_detection/create_detection_cubit.dart';
import '../values/values.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_document_scan_sdk/document_result.dart';
import 'package:flutter_document_scan_sdk/flutter_document_scan_sdk_platform_interface.dart';
import 'package:flutter_document_scan_sdk/template.dart';
import 'package:flutter_document_scan_sdk/normalized_image.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/responsive.dart';

part 'camera/camera_page.dart';
part 'create_detection/create_detection_page.dart';