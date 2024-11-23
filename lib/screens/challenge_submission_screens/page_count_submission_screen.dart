import 'package:dodecathlon/screens/main_screen.dart';
import 'package:flutter/material.dart';

class PageCountSubmissionScreen extends StatefulWidget {
  const PageCountSubmissionScreen({super.key});

  @override
  State<PageCountSubmissionScreen> createState() => _PageCountSubmissionScreenState();
}

class _PageCountSubmissionScreenState extends State<PageCountSubmissionScreen> {

  bool _shareEnabled = false;

  @override
  Widget build(BuildContext context) {
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
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => MainScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                          'Upload', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Text('How many pages have you read?', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                ListTile(
                  leading: const Icon(Icons.groups),
                  title: const Text('Share With Friends'),
                  trailing: Switch(
                    onChanged: (bool? value) {
                      setState(() {
                        _shareEnabled = value!;
                      });
                    },
                    value: _shareEnabled,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}