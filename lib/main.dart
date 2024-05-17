import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/core/services/doucment_scanner.dart';
import 'src/core/services/firebase_options.dart';
import 'src/navigation/routes.dart';
import 'src/presentations/values/values.dart';

Future<void> main() async {
  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<int> loadData() async {
    return await initDocumentSDK();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConst.kMaterialAppTitle,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.routes,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.colorMainTheme,
      ),
      home: FutureBuilder<int>(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),); // Loading indicator
          }
          Future.microtask(() {
             _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(Routes.home, (r) => false);
          });
          return Container();
        },
      ),
    );
  }
}
