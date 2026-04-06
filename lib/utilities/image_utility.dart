import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUtility {
  final storageRef = FirebaseStorage.instance.ref();

  // Returns upload url or null on error
  Future<String?> uploadImage(String path, File file) async {
    final imageRef = storageRef.child("images/$path");
    try {
      // Check if image with specified path already exists
      String? imageUrl;
      await imageRef.getMetadata()
        .then((metadata) async {
          imageUrl = await imageRef.getDownloadURL();
        }).catchError((error) {
          imageUrl = null;
        });

      if (imageUrl != null) {
        return imageUrl;
      }

      await imageRef.putFile(file);
      imageUrl = await imageRef.getDownloadURL();
      return imageUrl;

    } on FirebaseException catch (e) {
      print(e.toString);
    }
    return null;
  }
}