import 'package:js_code_test/src/data/model/photo_detection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../values/values.dart';

class DetectionCardItem extends StatelessWidget {
  const DetectionCardItem({super.key, required this.detection});
  final PhotoDetection detection;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          FutureBuilder(
            future: getImageUrl(detection.photo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SizedBox(
                    width: 120,
                    height: 100,
                    child: Image.network(
                      snapshot.data as String,
                      fit: BoxFit.cover,
                    ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Container(); // Return an empty container if there is an error
            },
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.padding10),
            child: SizedBox(child: Text(detection.name)),
          ),
        ],
      ),
    );
  }

  //Image Url from Firebase
  Future<String> getImageUrl(String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String downloadURL = await storage.ref(imagePath).getDownloadURL();
    return downloadURL;
  }
}
