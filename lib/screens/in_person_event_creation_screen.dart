import 'dart:io';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import '../utilities/image_utility.dart';
import 'package:uuid/uuid.dart';

final dateFormatter = DateFormat('EEE, MMM d', 'en_US');
final timeFormatter = DateFormat('h:mm a');

Uuid uuid = Uuid();

class InPersonEventCreationScreen extends ConsumerStatefulWidget {
  const InPersonEventCreationScreen({super.key, });

  @override
  ConsumerState<InPersonEventCreationScreen> createState() => _InPersonEventCreationScreenState();
}

class _InPersonEventCreationScreenState extends ConsumerState<InPersonEventCreationScreen> {

  User? currentUser;
  String? _imageUrl;
  File? _selectedImage;
  DateTime? _startTime;
  DateTime? _endTime;

  String? _titleErrorText;
  String? _descriptionErrorText;
  String? _locationErrorText;
  String? _imageErrorText;
  String? _startTimeErrorText;
  String? _endTimeErrorText;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    _imageUrl = await ImageUtility().uploadImage(pickedImage.path, _selectedImage!);
    _imageErrorText == null;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
  }

  Future<DateTime?> _presentDatePicker() async {
    DateTime now = DateTime.now();
    DateTime maxEndDate = DateTime(now.year, now.month + 1, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: maxEndDate,
    );
    return pickedDate;
  }

  void _presentTimePicker(bool startDate, DateTime selectedDate) async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
    );
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    );
    setState(() {
      if (selectedTime !=  null) {
        if (startDate) {
          _startTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          String displayText = dateFormatter.format(_startTime!);
          displayText += ', ${timeFormatter.format(_startTime!)}';
          _startTimeController.text = displayText;
          _startTimeErrorText = null;
        } else {
          _endTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          String displayText = dateFormatter.format(_endTime!);
          displayText += ', ${timeFormatter.format(_endTime!)}';
          _endTimeController.text = displayText;
          _endTimeErrorText = null;
        }
      }
    });
  }

  void uploadEvent(BuildContext ctx, User user) async {
    bool valid = true;
    if (_titleController.text.isEmpty) {
      _titleErrorText = 'Must have a valid title';
      valid = false;
    }
    if (_descriptionController.text.isEmpty) {
      _descriptionErrorText = 'Must have a valid description';
      valid = false;
    }
    if (_locationController.text.isEmpty) {
      _locationErrorText = 'Must have a valid location';
      valid = false;
    }
    if (_imageUrl == null) {
      _imageErrorText = 'Please select a display image';
      valid = false;
    }
    if (_startTime == null) {
      _startTimeErrorText = 'Please select a valid start date';
      valid = false;
    }
    if (_endTime == null) {
      _endTimeErrorText = 'Please select a valid end date';
      valid = false;
    }

    if (!valid) {
      setState(() {});
      return;
    }

    InPersonEvent newEvent = InPersonEvent(
        name: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        startTime: _startTime!,
        endTime: _endTime!,
        host: user.userName,
        attending: [user.id!],
        displayImageUrl: _imageUrl!,
        id: uuid.v4(),
    );

    String? error = await newEvent.upload();
    if (error != null) {
      SnackBar snackBar = SnackBar(content: Text(error));
      if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      return;
    }

    if(ctx.mounted) {
      Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => MainScreen()),
            (Route<dynamic> route) => false,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.read(userProvider)!;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(10),
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Back', style: TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        uploadEvent(context, currentUser!);
                      },
                      child: Text(
                          'Create', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLines: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _titleErrorText = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Title...',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        labelText: 'Title: ',
                        errorText: _titleErrorText,
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _descriptionErrorText = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Description...',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        labelText: 'Description: ',
                        errorText: _descriptionErrorText,
                      ),
                    ),
                    TextField(
                      controller: _locationController,
                      maxLines: null,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _locationErrorText = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Location...',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        labelText: 'Location: ',
                        errorText: _locationErrorText
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: _startTimeController,
                      onTap: () async {
                        DateTime? selectedDate = await _presentDatePicker();
                        if (selectedDate != null) {
                          _presentTimePicker(true, selectedDate);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Start Date: ',
                        errorText: _startTimeErrorText,
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: _endTimeController,
                      onTap: () async {
                        DateTime? selectedDate = await _presentDatePicker();
                        if (selectedDate != null) {
                          _presentTimePicker(false, selectedDate);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'End Date: ',
                        errorText: _endTimeErrorText,
                      ),
                    ),
                    SizedBox(height: 40,),
                    if (_imageUrl == null)
                      Column(
                        children: [
                          if (_imageErrorText != null)
                            Text(_imageErrorText!, style: TextStyle(color: Theme.of(context).colorScheme.error),),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                height: 300,
                                width: 300,
                                color: Colors.black12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Select a display image', style: TextStyle(color: Colors.black45),),
                                    SizedBox(height: 20,),
                                    Icon(Icons.camera, color: Colors.black26,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (_imageUrl != null)
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _takePicture,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                                height: 300,
                                width: 300,
                                frameBuilder: (_, image, loadingBuilder, __) {
                                  if (loadingBuilder == null) {
                                    return const SizedBox(
                                      height: 300,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return image;
                                },
                                loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    height: 300,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _imageUrl = null;
                                  });
                                },
                                icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}