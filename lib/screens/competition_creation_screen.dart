import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/competition.dart';
import '../utilities/image_utility.dart';

Uuid uuid = Uuid();

class CompetitionCreationScreen extends ConsumerStatefulWidget {
  const CompetitionCreationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CompetitionCreationScreenState();
  }
}

class _CompetitionCreationScreenState extends ConsumerState<CompetitionCreationScreen> {

  final _form = GlobalKey<FormState>();
  final String compId = uuid.v4();

  var _enteredName = '';
  var _enteredDescription = '';
  File? _selectedImage;
  String? _imageUrl;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select a theme color'),
          content: Container(
            height: 500,
            width: 300,
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ),
                  child: const Text('Select'),
                  onPressed: () {
                    setState(() {
                      currentColor = pickerColor;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    Competition comp = Competition(
        name: _enteredName,
        description: _enteredDescription,
        createdAt: DateTime.now(),
        events: [],
        themeColor: currentColor,
        displayImageUrl: _imageUrl,
        id: compId
    );

    try {
      await comp.upload();
      Navigator.of(context).pop();
    } catch (e) {
      // TODO: Logging
      print('Error uploading competition: ${e.toString()}');
    }
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    _imageUrl = await ImageUtility().uploadImage('competitionImages/$compId.jpg', _selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Competition'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Text(
                    'Display Image',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 20,),
                  FormField( // TODO: Add validation
                    validator: (value) {
                      if (_imageUrl == null) {
                        return 'Select a display image';
                      }
                    },
                    builder: (state) {
                      return Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: _takePicture,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                      color: state.errorText != null
                                        ? Theme.of(context).colorScheme.error
                                        : Colors.transparent
                                    )
                                  ),
                                ),
                                _imageUrl != null
                                    ? CircleAvatar(backgroundImage: NetworkImage(_imageUrl!), radius: 50)
                                    : CircleAvatar(radius: 50, child: Icon(Icons.edit),),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: state.errorText != null
                              ? Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12
                                  ),
                                )
                              : null
                          )
                        ],
                      );
                    }
                  ),
                  GestureDetector(
                    onTap: () {
                      _dialogBuilder(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Theme Color',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid name for this competition';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid description for this competition';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredDescription = value!;
                    },
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  FilledButton(
                    onPressed: _submit,
                    child: Text('Create'),
                  )
                ],
              )
            ),
          ),
        )
    );
  }
}