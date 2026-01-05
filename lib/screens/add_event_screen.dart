import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/add_event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/competition.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../providers/challenges_provider.dart';
import '../widgets/select_difficulty_container.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key, required this.competition});

  final Competition competition;

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {

  @override
  Widget build(BuildContext context) {

    AsyncValue<List<Event>> eventsStream = ref.watch(eventProvider);

    if (!eventsStream.hasValue) {
      return Center(child: CircularProgressIndicator());
    }

    void onAdd(String eventId) {
      setState(() {
        widget.competition.events.add(eventId);
        widget.competition.upload();
      });
    }

    List<Event> events = eventsStream.value!.where((e) =>
      !widget.competition.events.contains(e.id)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (ctx, i) =>
                  AddEventTile(
                    event: events[i],
                    addEvent: onAdd
                  )
              ),
            ),
          ],
        ),
      )
    );
  }
}