import 'package:equatable/equatable.dart';

class PhotoDetection extends Equatable {
  final String name;
  final String photo;

  const PhotoDetection({required this.name, required this.photo});

  @override
  List<Object?> get props => [name, photo];

  Map<String, Object?> toMap() {
    return <String, Object>{'name': name, 'photo': photo};
  }

  PhotoDetection.fromMap(Map<String, Object?> data)
      : name = data['name'] as String,
        photo = data['photo'] as String;

}
