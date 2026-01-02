import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:dodecathlon/screens/event_schedule_screen.dart';
import 'package:dodecathlon/widgets/next_event_details.dart';
import 'package:dodecathlon/widgets/previous_event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/challenge.dart';
import '../models/user.dart';
import '../providers/challenges_provider.dart';
import '../providers/in_person_event_provider.dart';
import '../widgets/current_event_details.dart';

final formatter = DateFormat('MMM d');

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() {
    return _EventsScreenState();
  }
}

class _EventsScreenState extends ConsumerState<EventsScreen> {

  Event? selectedEvent;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    // Events
    AsyncValue<List<Event>> events = ref.watch(eventProvider);
    if (!events.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    events.value!.sort((a, b) => a.startDate.isAfter(b.startDate) ? 1 : 0);
    Event? currentEvent = events.value!.where((e) =>
      e.startDate.isBefore(now) & e.endDate.isAfter(now)
    ).firstOrNull;
    if (currentEvent == null) {
      return Center(child: Text('Looks like there are no current events')); // TODO: Better logging, screen, etc.
    }

    selectedEvent = selectedEvent ?? currentEvent;
    int currentEventIndex = events.value!.indexOf(currentEvent!);
    int selectedEventIndex = events.value!.indexOf(selectedEvent!);

    // User
    User currentUser = ref.read(userProvider)!;
    bool hasSelectedDifficulty = currentUser.currentEventDifficulty != null;

    // Submissions
    AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);
    List<String> completedChallengeIds = [];
    if (submissions.hasValue) {
      List<Submission> userSubmissions = submissions.value!.where((s) =>
        s.userId == currentUser.id
      ).toList();
      completedChallengeIds = userSubmissions.map((s) => s.challengeId).toList();
    }

    // In-person events
    AsyncValue<List<InPersonEvent>> inPersonEvents = ref.watch(inPersonEventProvider);
    List<InPersonEvent> upcommingInPersonEvents = [];
    if (inPersonEvents.hasValue) {
      upcommingInPersonEvents = inPersonEvents.value!.where((e) =>
          e.startTime.isAfter(DateTime.now())
      ).toList();
    }

    // Challenges
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    List<Challenge> eventChallenges = [];
    if (challenges.hasValue) {
      eventChallenges = challenges.value!.where((c) =>
        c.eventId == selectedEvent!.id &&
        c.startDate.isBefore(now) &&
        c.endDate.isAfter(now)
      ).toList();
    }

    print('eventChallenges: $eventChallenges');

    List<Challenge> bonusChallenges = [];
    List<Challenge> mainChallenges = [];
    List<Challenge> completedChallenges = [];
    if (hasSelectedDifficulty && challenges.hasValue) {
      bonusChallenges = eventChallenges.where((c) =>
      c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
          c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
          (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
      ).toList();
      mainChallenges = eventChallenges.where((c) =>
      !c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
          c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
          (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
      ).toList();
      completedChallenges = eventChallenges.where((c) =>
        completedChallengeIds.contains(c.id)
      ).toList();
    }
    
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Page header
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedEventIndex > 0
                  ? IconButton(
                    onPressed: () {
                      selectedEvent = events.value![selectedEventIndex - 1];
                      setState(() {});
                    },
                    icon: Icon(Icons.chevron_left)
                  ) :
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.chevron_left, color: Colors.transparent)
                  ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: selectedEvent!, challenges: eventChallenges,))
                        );
                      },
                      child: Hero(
                        tag: currentEvent.id!,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                // border: Border.all(color: selectedEvent!.themeColor.withAlpha(100)),
                                boxShadow: [
                                  BoxShadow(
                                      color: selectedEvent!.themeColor.withAlpha(100),
                                      offset: Offset(0, 5),
                                      spreadRadius: 1,
                                      blurRadius: 5
                                  )
                                ]
                              )
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(selectedEvent!.displayImageUrl),
                              maxRadius: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        selectedEvent = currentEvent;
                        setState(() {});
                      },
                      child: Text(
                        selectedEvent == currentEvent ? 'Current Event' : '(Return to Current Event)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      )
                    ),
                    Text(
                      selectedEvent!.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      '${formatter.format(selectedEvent!.startDate)} - ${formatter.format(selectedEvent!.endDate)}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                selectedEventIndex < events.value!.length - 1
                  ? IconButton(
                      onPressed: () {
                        selectedEvent = events.value![selectedEventIndex + 1];
                        setState(() {});
                      },
                      icon: Icon(Icons.chevron_right)
                  ) :
                  IconButton(
                      onPressed: null,
                      icon: Icon(Icons.chevron_right, color: Colors.transparent)
                  ),
                ],
            ),
          ),

          // Page Body
          SizedBox(height: 20,),
          if (events.hasValue && inPersonEvents.hasValue && selectedEvent == currentEvent)
            CurrentEventDetails(
              hasSelectedDifficulty: hasSelectedDifficulty,
              currentEvent: selectedEvent!,
              bonusChallenges: bonusChallenges,
              mainChallenges: mainChallenges,
              completedChallenges: completedChallenges,
              inPersonEvents: upcommingInPersonEvents,
            ),
          if (events.hasValue && selectedEventIndex < currentEventIndex)
            PreviousEventDetails(
              currentEvent: currentEvent,
              challenges: eventChallenges,
            ),
          if (events.hasValue && selectedEventIndex > currentEventIndex)
            NextEventDetails(currentEvent: currentEvent),
          Container(
            margin: EdgeInsets.symmetric(vertical: 80),
            alignment: Alignment.center,
            child: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EventScheduleScreen())
                  );
                },
                child: Text('View Full Competition Schedule')
            ),
          ),
        ],
      ),
    );
  }
}