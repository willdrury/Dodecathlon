import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.onRemove,
  });

  final Event event;
  final Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            EventDetailsScreen(event: event, challenges: [],) // TODO: figure out either where to get this or remove
        ));
      },
      child: Container(
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
              onPressed: () {
                onRemove(event.id!);
              },
              icon: Icon(Icons.remove)
            )
          ],
        ),
      ),
    );
  }
}