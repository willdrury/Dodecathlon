import 'dart:math';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/widgets/event_schedule_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/competition.dart';
import '../providers/competition_provider.dart';
import '../providers/events_provider.dart';
import '../providers/settings_provider.dart';

class EventScheduleScreen extends ConsumerStatefulWidget {
  const EventScheduleScreen({super.key});

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
    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);

    var settings = ref.watch(settingsProvider);
    if (settings == null || settings['current_competition'] == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    AsyncValue<List<Competition>> competitions = ref.watch(competitionProvider);
    if (!competitions.hasValue || !challenges.hasValue || !eventStream.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    Competition currentCompetition = competitions.value!.firstWhere((c) => c.id == settings['current_competition']);
    List<Event> competitionEvents = eventStream.value!.where((e) =>
        currentCompetition.events.contains(e.id)
    ).toList();


    List<Color> backgroundColors = [];
    backgroundColors = competitionEvents.map((event) => event.themeColor).toList();
    backgroundColors.insert(0, Colors.white);

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
        onNotification: (ScrollNotification notification) => _changeBackground(notification, backgroundColors, competitionEvents.length),
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
                        SizedBox(
                          width: double.infinity,
                          child: Text('2025\nEVENT\nSCHEDULE', style: GoogleFonts.robotoMono(fontSize: 50), textAlign: TextAlign.left,)
                        ),
                        SizedBox(height: 200,),
                        Icon(Icons.arrow_downward),
                      ],
                    ),
                  ),
                  SizedBox(height: 150,),
                  for (int i = 0; i < competitionEvents.length; i++)
                    if (challenges.hasValue)
                      EventScheduleListItem(
                        event: competitionEvents[i],
                        eventChallenges: challenges.value!.where((c) => c.eventId == competitionEvents[i].id).toList(),
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