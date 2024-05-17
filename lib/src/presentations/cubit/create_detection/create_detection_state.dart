part of 'create_detection_cubit.dart';

class CreateDetectionState extends Equatable {
  final File? photo;
  final bool isLoading;
  final bool isDone;

  const CreateDetectionState({
    this.photo,
    this.isLoading = false,
    this.isDone = false,
  });

  @override
  List<Object?> get props => [photo?.path, isLoading, isDone];

  CreateDetectionState copyWith({
    File? photo,
    bool? isLoading,
    bool? isDone,
  }) {
    return CreateDetectionState(
      photo: photo ?? this.photo,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
    );
  }
}
