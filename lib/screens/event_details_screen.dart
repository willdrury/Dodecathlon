import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {

    List<Challenge> challenges = competition2025Challenges.where((c) => c.event == event).toList();

    String _statusText = '';

    if (DateTime.now().isAfter(event.startDate) && DateTime.now().isBefore(event.endDate)) {
      _statusText = 'In Progress';
    } else if (DateTime.now().isAfter(event.endDate)) {
      _statusText = 'Completed';
    } else {
      _statusText = 'Starts on ${event.startDate.month}.${event.startDate.day}.${event.startDate.year}';
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(event.name, style: TextStyle(color: Colors.white),),
        backgroundColor: event.themeColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: event.themeColor,
              ),
              child: Icon(event.icon, color: Colors.white,),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Text('Status:\n$_statusText'),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Text('Description:\n${event.description}'),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Text('Has multiple difficulties:\n${event.hasMultipleDifficulties}'),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sample event list:'),
                for (int i = 0; i < challenges.length && i < 3; i++)
                  Text(challenges[i].name),
                if (challenges.length > 3)
                  Text('... ${challenges.length - 3} more'),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Text('Prizes:\n${event.prize}'),
          ),
        ],
      )
    );
  }
}