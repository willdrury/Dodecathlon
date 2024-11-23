import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUtility {
  final storageRef = FirebaseStorage.instance.ref();

  List<File> getUserProfileImages(){
    final imagesRef = storageRef.child('profileImages');
    return [];
  }

  // Returns upload url or null on error
  Future<String?> uploadImage(String path, File file) async {
    final imageRef = storageRef.child("images/$path");
    try {
      await imageRef.putFile(file);
      final String imageUrl = await imageRef.getDownloadURL();
      print('imageUrl: $imageUrl');
      return imageUrl;
    } on FirebaseException catch (e) {
      print('fuckers');
      print(e.toString);
    }
    return null;
  }
}