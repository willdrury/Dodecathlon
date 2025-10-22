import 'dart:math';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/events_provider.dart';

class EventScheduleScreen extends ConsumerStatefulWidget {
  EventScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventScheduleScreenState();
}

class _EventScheduleScreenState extends ConsumerState<EventScheduleScreen> {

  ScrollController? _scrollController;
  Color _backgroundColor = Colors.white;

  bool _changeBackground(ScrollNotification notification, List<Color> backgroundColors, int numSections) {
    if (_scrollController == null) return true;
    double maxExtent = _scrollController!.position.maxScrollExtent;
    double currentPixels = _scrollController!.position.pixels;
    setState(() {
      double sectionHeight = maxExtent/numSections;
      int aboveIndex = (numSections*currentPixels/maxExtent).floor();
      int belowIndex = min((numSections*currentPixels/maxExtent).ceil(), numSections);
      Color above = backgroundColors[aboveIndex];
      Color below = backgroundColors[belowIndex];
      double remainder = currentPixels%sectionHeight/sectionHeight;
      _backgroundColor = Color.lerp(Color.lerp(above, below, remainder)!, Colors.white, .85)!;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = ref.read(eventProvider);
    AsyncValue<List<Challenge>> challenges = ref.read(challengesProvider);
    List<Color> _backgroundColors = events.map((event) => event.themeColor).toList();
    _backgroundColors.insert(0, Colors.white);

    final List<CrossAxisAlignment> boxAlignments = [
      CrossAxisAlignment.center,
      CrossAxisAlignment.start,
      CrossAxisAlignment.end,
      CrossAxisAlignment.center,
      CrossAxisAlignment.end,
      CrossAxisAlignment.start,
      CrossAxisAlignment.end,
      CrossAxisAlignment.center,
      CrossAxisAlignment.end,
      CrossAxisAlignment.start,
      CrossAxisAlignment.end,
      CrossAxisAlignment.center,
    ];

    final List<TextAlign> textAlignments = [
      TextAlign.center,
      TextAlign.start,
      TextAlign.end,
      TextAlign.center,
      TextAlign.end,
      TextAlign.start,
      TextAlign.end,
      TextAlign.center,
      TextAlign.end,
      TextAlign.start,
      TextAlign.end,
      TextAlign.center,
    ];

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) => _changeBackground(notification, _backgroundColors, events.length),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(backgroundColor: _backgroundColor,)
            ];
          },
          body: Builder(
            builder: (context) {
              _scrollController = PrimaryScrollController.of(context);
              return ListView(
                children: [
                  Container(
                    height: 600,
                    padding: EdgeInsets.only(left: 20),
                    width: 300,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text('2025\nEVENT\nSCHEDULE', style: GoogleFonts.robotoMono(fontSize: 50), textAlign: TextAlign.left,)
                        ),
                        SizedBox(height: 200,),
                        Icon(Icons.arrow_downward),
                      ],
                    ),
                  ),
                  SizedBox(height: 150,),
                  for (int i = 0; i < events.length; i++)
                    if (challenges.hasValue)
                      EventListItem(
                        event: events[i],
                        eventChallenges: challenges.value!.where((c) => c.eventId == events[i].id).toList(),
                        columnAlignment: boxAlignments[i],
                        textAlignment: textAlignments[i],
                      ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}