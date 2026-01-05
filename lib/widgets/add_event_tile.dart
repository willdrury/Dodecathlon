import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/screens/competition_details_screen.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/competition.dart';
import '../models/event.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');

class AddEventTile extends StatelessWidget {
  const AddEventTile({
    super.key,
    required this.event,
    required this.addEvent
  });

  final Event event;
  final Function(String) addEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                Text(
                  event.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await addEvent(event.id!);
            },
            icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    EventDetailsScreen(event: event, challenges: [],) // TODO: figure out either where to get this or remove
                ));
              },
              icon: Icon(Icons.more_vert)
          )
        ],
      ),
    );
  }
}