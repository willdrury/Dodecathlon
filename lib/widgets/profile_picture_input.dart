import 'dart:io';

import 'package:dodecathlon/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureInput extends StatefulWidget {
  ProfilePictureInput({super.key, required this.user});

  User user;

  @override
  State<StatefulWidget> createState() {
    return _ProfilePictureInputState();
  }
}

class _ProfilePictureInputState extends State<ProfilePictureInput> {

  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    await widget.user.updateProfileImage(_selectedImage!, '${widget.user.id}.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _takePicture,
      child: widget.user.profileImageUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(widget.user.profileImageUrl!), radius: 50)
          : CircleAvatar(radius: 50, child: Text(widget.user.userName[0]),),
    );
  }
}