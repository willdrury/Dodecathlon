import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../models/user.dart';
import '../providers/challenges_provider.dart';
import '../providers/in_person_event_provider.dart';
import '../widgets/current_event_details.dart';

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

    print('Building event screen: ${selectedEvent}');
    if (selectedEvent != null) {
      print('Selected event name: ${selectedEvent!.name}');
    }

    // User
    User currentUser = ref.read(userProvider)!;
    bool hasSelectedDifficulty = currentUser.currentEventDifficulty != null;

    // Submissions
    List<Submission> submissions = ref.watch(submissionsProvider);
    List<String> completedChallengeIds = submissions.map((s) => s.challengeId).toList();

    // In-person events
    List<InPersonEvent> inPersonEvents = ref.watch(inPersonEventProvider);

    // Events
    List<Event> events = ref.watch(eventProvider);
    events.sort((a, b) => a.startDate.isBefore(b.startDate) ? 1 : 0);
    Event currentEvent = events.where((e) =>
      e.startDate.isBefore(now) & e.endDate.isAfter(now)
    ).first;
    selectedEvent = selectedEvent ?? currentEvent;
    int selectedEventIndex = events.indexOf(selectedEvent!);

    // Challenges
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    List<Challenge> eventChallenges = [];
    if (challenges.hasValue) {
      eventChallenges = challenges.value!.where((c) => c.eventId == selectedEvent!.id).toList();
    }
    List<Challenge> bonusChallenges = [];
    List<Challenge> mainChallenges = [];
    if (hasSelectedDifficulty && challenges.hasValue) {
      bonusChallenges = eventChallenges.where((c) =>
      c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.startDate.isBefore(now) &&
          c.endDate.isAfter(now) &&
          c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
          c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
          (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
      ).toList();
      mainChallenges = eventChallenges.where((c) =>
      !c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.startDate.isBefore(now) &&
          c.endDate.isAfter(now) &&
          c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
          c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
          (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
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
                      selectedEvent = events[selectedEventIndex - 1];
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
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
                            backgroundImage: NetworkImage(selectedEvent!.displayImageUrl),
                            maxRadius: 50,
                          ),
                        ],
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
                  ],
                ),
                Spacer(),
                selectedEventIndex < events.length - 1
                  ? IconButton(
                      onPressed: () {
                        selectedEvent = events[selectedEventIndex + 1];
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
          CurrentEventDetails(
            hasSelectedDifficulty: hasSelectedDifficulty,
            currentEvent: selectedEvent!,
            bonusChallenges: bonusChallenges,
            mainChallenges: mainChallenges,
            inPersonEvents: inPersonEvents,
          ),
        ],
      ),
    );
  }
}