import 'package:js_code_test/src/presentations/cubit/detection_list/detection_list_cubit.dart';
import 'package:js_code_test/src/presentations/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../navigation/routes.dart';
import 'components/detection_card_item.dart';

class DetectionListPage extends StatefulWidget {
  const DetectionListPage({super.key});

  @override
  State<DetectionListPage> createState() => _DetectionListPageState();
}

class _DetectionListPageState extends State<DetectionListPage> {
  @override
  Widget build(BuildContext context) {
    return _getDetectionListScaffold;
  }

  //Detection List Scaffold
  Scaffold get _getDetectionListScaffold => Scaffold(
        appBar: _getAppBar,
        body: _getDetectionListContainer,
      );

  //App Bar
  AppBar get _getAppBar => AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          StringConst.kDetectionsListTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () => backtoScanner(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.kWhiteColor,
            )),
      );
  
  //Detection List Container
  Widget get _getDetectionListContainer => BlocProvider(
          create: (context) => DetectionListCubit()..init(),
          child: BlocBuilder<DetectionListCubit, DetectionListState>(
            builder: (context, state) {
              return ResponsiveGridList(
                  desiredItemWidth: 120,
                  minSpacing: 10,
                  children:
                      List.generate(state.myDetections.length, (index) => index)
                          .map((i) {
                    final detection = state.myDetections.elementAt(i);
                    return DetectionCardItem(detection: detection,);
                  }).toList());
            },
          ),
        );


  //Back to Scan Page
  void backtoScanner() {
    Navigator.pushReplacementNamed(context, Routes.home);
  }
}
