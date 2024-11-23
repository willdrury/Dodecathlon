import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class InPersonEventDetailsScreen extends StatelessWidget {
  const InPersonEventDetailsScreen({super.key, required this.event});

  final InPersonEvent event;

  @override
  Widget build(BuildContext context) {

    String _statusText = '';

    if (DateTime.now().isAfter(event.startTime) && DateTime.now().isBefore(event.endTime)) {
      _statusText = 'In Progress';
    } else if (DateTime.now().isAfter(event.endTime)) {
      _statusText = 'Completed';
    } else {
      _statusText = 'Starts on ${event.startTime.month}.${event.startTime.day}.${event.startTime.year}';
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(event.name,),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: event.displayImageUrl,
                child: Image.network(event.displayImageUrl, fit: BoxFit.cover,),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status:', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(_statusText),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description:', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(event.description),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location:', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(event.location),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attending:', style: TextStyle(fontWeight: FontWeight.bold),),
                    for(User u in event.attending)
                      Text(u.userName),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        )
    );
  }
}