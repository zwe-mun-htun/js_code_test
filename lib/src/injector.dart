part of '../main.dart';

final injector = GetIt.instance;

// Helper function to inject dependencies
Future<void> injectDependencies() async {
  // Datasource
  injector.registerLazySingleton(() => FirebaseDataSource());

  // Repository
  injector.registerLazySingleton<DetectionRepository>(
      () => DetectionRepositoryImpl());

  // Cubit
  injector.registerLazySingleton<CreateDetectionCubit>(
      () => CreateDetectionCubit());
}
