import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUtility {
  final storageRef = FirebaseStorage.instance.ref();

  // Returns upload url or null on error
  Future<String?> uploadImage(String path, File file) async {
    final imageRef = storageRef.child("images/$path");
    try {
      // Check if image with specified path already exists
      String? imageUrl = await imageRef.getMetadata()
        .then((metadata) async {
          print('Found existing file with specified path');
          final String imageUrl = await imageRef.getDownloadURL();
          return imageUrl;
        })
        .catchError((error) {
          print('No existing file with specified path');
          return null;
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