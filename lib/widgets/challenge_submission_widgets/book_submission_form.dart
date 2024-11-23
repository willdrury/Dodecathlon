import 'package:flutter/material.dart';

class BookSubmissionForm extends StatefulWidget {
  const BookSubmissionForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BookSubmissionFormState();
  }
}

class _BookSubmissionFormState extends State<BookSubmissionForm> {

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 250, 248, 198),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1, offset: Offset(0, 10))
              ]
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              for (var i = 0; i < 18; i++)
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Divider(color: Colors.grey.withAlpha(50),),
                ),
            ],
          ),
        ),
        Container(
          height: 500,
          width: 300,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primary.withAlpha(100)),
                  border: InputBorder.none,
                ),
              ),
              TextField(
                controller: _authorController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
                  hintText: 'Author',
                  hintStyle: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primary.withAlpha(100)),
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 50,),
              TextField(
                controller: _reviewController,
                maxLines: 7,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
                  hintText: 'Review (optional)',
                    hintStyle: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary.withAlpha(100)),
                    border: InputBorder.none
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}