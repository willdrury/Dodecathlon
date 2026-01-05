import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/add_event_screen.dart';
import 'package:dodecathlon/widgets/add_event_tile.dart';
import 'package:dodecathlon/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

final formatter = DateFormat('MMM d');

class CompetitionDetailsScreen extends ConsumerStatefulWidget {
  const CompetitionDetailsScreen({
    super.key,
    required this.competition
  });

  final Competition competition;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CompetitionDetailsScreenState();
  }
}

class _CompetitionDetailsScreenState extends ConsumerState<CompetitionDetailsScreen> {


  @override
  Widget build(BuildContext context) {

    User? user = ref.watch(userProvider);
    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);

    if (!eventStream.hasValue || user == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    List<Event> events = eventStream.value!.where((e) =>
      widget.competition.events.contains(e.id)
    ).toList();

    void onRemove(String eventId) async {
      setState(() {
        widget.competition.events.remove(eventId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.competition.name, style: TextStyle(color: Colors.white),),
        backgroundColor: widget.competition.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Hero(
              tag: widget.competition.id!,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 160,
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
                    radius: 70,
                    backgroundImage: NetworkImage(
                      widget.competition.displayImageUrl != null
                        ? widget.competition.displayImageUrl!
                        : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(widget.competition.description),
            SizedBox(height: 20,),
            Divider(),
            SizedBox(height: 20,),
            Text(
              'Events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  AddEventScreen(competition: widget.competition)
                ));
              },
              icon: Icon(Icons.add)
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (ctx, i) {
                  return EventTile(event: events[i], onRemove: onRemove,);
                }),
            ),
          ],
        ),
      )
    );
  }
}