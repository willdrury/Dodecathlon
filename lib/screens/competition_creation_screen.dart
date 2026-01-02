import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/competition.dart';

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

  var _enteredName = '';
  var _enteredDescription = '';

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
          title: const Text('Select a theme color'),
          content: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
          actions: <Widget>[
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
                });
              },
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
        themeColor: Colors.black38, // TODO: replace with color picker
        id: uuid.v4()
    );

    try {
      await comp.upload();
      // TODO: Navigate to competition details screen
      // TODO: Add competition to users current competition?
    } catch (e) {
      // TODO: Logging
      print('Error uploading competition: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a new competition'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
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
                  TextButton(
                      onPressed: () {
                        _dialogBuilder(context);
                      },
                      child: Text('Choose Color')
                  ),
                  TextButton(
                    onPressed: _submit,
                    child: Text('Create')
                  )
                ],
              )
            ),
          ),
        )
    );
  }
}