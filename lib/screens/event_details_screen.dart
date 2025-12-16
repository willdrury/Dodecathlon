import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

final formatter = DateFormat('MMM d');

class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({super.key, required this.event, required this.challenges});

  final Event event;
  final List<Challenge> challenges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    String statusText = '';
    DateTime now = DateTime.now();
    User? user = ref.watch(userProvider);

    if (user == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    if (DateTime.now().isAfter(event.startDate) && DateTime.now().isBefore(event.endDate)) {
      statusText = 'In Progress';
    } else if (DateTime.now().isAfter(event.endDate)) {
      statusText = 'Completed';
    } else {
      statusText = 'Starts on ${event.startDate.month}.${event.startDate.day}.${event.startDate.year}';
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(event.name, style: TextStyle(color: Colors.white),),
        backgroundColor: event.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Hero(
                tag: event.id!,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        height: (2 * MediaQuery.widthOf(context) / 4) + 30,
                        width: (2 * MediaQuery.widthOf(context) / 4) + 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular((2 * MediaQuery.widthOf(context) / 2.2) + 20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 5),
                                  spreadRadius: 1,
                                  blurRadius: 5
                              )
                            ]
                        )
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(event!.displayImageUrl),
                      maxRadius: MediaQuery.widthOf(context) / 4,
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 30,),
              // Center(
              //   child: Container(
              //     height: 60,
              //     width: 60,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: event.themeColor,
              //     ),
              //     child: Icon(event.icon, color: Colors.white,),
              //   ),
              // ),
              SizedBox(height: 30,),
              Text(
                '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              Text(
                '($statusText)',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 30,),
              Text(event.description),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 10,),
              if (event.hasMultipleDifficulties)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Selected Difficulty:'),
                        SizedBox(width: 20,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 5),
                                  spreadRadius: 1,
                                  blurRadius: 5
                              )
                            ]
                          ),
                          child: Text(
                              user.currentEventDifficulty == null
                                  ? 'None'
                                  : user.currentEventDifficulty!.name.substring(0, 1).toUpperCase() + user.currentEventDifficulty!.name.substring(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Divider(),
                  ],
                ),
              SizedBox(height: 10,),
              if (event.startDate.isBefore(now) && event.endDate.isAfter(now))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Challenges',
                      style: Theme.of(context).textTheme.titleMedium
                    ),
                  ],
                ),
              // SizedBox(height: 10,),
              // Container(
              //   width: double.infinity,
              //   color: Colors.white,
              //   child: Text('Prizes:\n${event.prize}'),
              // ),
            ],
          ),
        ),
      )
    );
  }
}