part of 'detection_list_cubit.dart';

class DetectionListState extends Equatable {
  final bool isLoading;
  final Iterable<PhotoDetection> myDetections;

  const DetectionListState({
    this.isLoading = true,
    this.myDetections = const [],
  });

  @override
  List<Object?> get props => [isLoading, myDetections];
}
