import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/competition.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../providers/challenges_provider.dart';
import '../providers/competition_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/user_competition_rankings_provider.dart';
import '../providers/user_data_providers.dart';
import '../providers/events_provider.dart';
import '../providers/user_event_rankings_provider.dart';
import '../widgets/home_screen_details.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onPageChange});

  final int eventIndex = 0;
  final Function(int, BuildContext) onPageChange;

  @override
  ConsumerState<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation _colorTween;
  bool hasDismissedNewEventNotification = false;
  bool newEventNotificationPopupIsVisible = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 4999)
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    _colorTween = ColorTween(
      begin: primaryColor,
      end: secondaryColor,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNewEventSelectDialog(BuildContext context, Event currentEvent) {
    newEventNotificationPopupIsVisible = true;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('A New Event has Started'),
          content: const Text('Select an event difficulty to begin seeing new challenges.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                hasDismissedNewEventNotification = true;
                newEventNotificationPopupIsVisible = false;
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: currentEvent,))
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // Provider Data
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    User user = userStream.value!;
    Map<dynamic, dynamic> settings = ref.watch(settingsProvider);
    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);
    AsyncValue<List<Competition>> competitions = ref.watch(competitionProvider);
    AsyncValue<(int, int)?> eventPointsStream = ref.watch(userEventPointProvider);
    AsyncValue<List<(String, int)>> userEventRankingsStream = ref.watch(userEventRankingsProvider);
    AsyncValue<List<(String, int)>> userCompetitionRankingsStream = ref.watch(userCompetitionRankingsProvider);

    if (!competitions.hasValue ||
        !eventStream.hasValue ||
        settings['current_competition'] == null ||
        !eventPointsStream.hasValue || eventPointsStream.value == null ||
        !userEventRankingsStream.hasValue || userEventRankingsStream.value == null ||
        !userCompetitionRankingsStream.hasValue || userCompetitionRankingsStream.value == null
    ) {
      return Center(child: CircularProgressIndicator(),);
    }

    Competition? currentCompetition = competitions.value!.where((c) => c.id == settings['current_competition']).firstOrNull;
    if (currentCompetition == null) {
      return Center(child: Text('Join a competition to get started!'),); // TODO: Improve ui
    }

    List<Event> competitionEvents = eventStream.value!.where((e) =>
        currentCompetition.events.contains(e.id)
    ).toList();

    DateTime now = DateTime.now();
    Event? currentEvent = competitionEvents.isEmpty
        ? null
        : competitionEvents.where((e) =>
            e.startDate.isBefore(now) & e.endDate.isAfter(now)
          ).firstOrNull;

    if (currentEvent == null) { // TODO: Better error handling. Show screen if there is no event
      return Center(child: Text('Looks like there are no current events'),);
    }

    List<String> userEventRankingsById = userEventRankingsStream.value!.map((e) => e.$1).toList();
    List<String> userCompetitionRankingsById = userCompetitionRankingsStream.value!.map((e) => e.$1).toList();
    int eventRank = userEventRankingsById.indexOf(user.id!) + 1;
    int competitionRank = userCompetitionRankingsById.indexOf(user.id!) + 1;

    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    Challenge? mainChallenge;
    if (currentEvent.mainChallengeId != null && currentEvent.mainChallengeId!.isNotEmpty && challenges.hasValue) {
      mainChallenge = challenges.value!.firstWhere((c) => c.id == currentEvent.mainChallengeId!);
    }

    bool showDifficultySelectionButton =
      currentEvent.hasMultipleDifficulties
        && user.currentEventDifficulty == null;

    if (!hasDismissedNewEventNotification && showDifficultySelectionButton && !newEventNotificationPopupIsVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewEventSelectDialog(context, currentEvent);
      });
    }

    return HomeScreenDetails(
      challenge: mainChallenge!,
      user: user,
      event: currentEvent,
      mainPoints: eventPointsStream.value!.$1,
      bonusPoints: eventPointsStream.value!.$2,
      eventRank: eventRank,
      competitionRank: competitionRank,
      onPageChange: widget.onPageChange,
    );

    // return Stack(
    //   children: [
    //     // Background dodecahedron image
    //     AnimatedBuilder(
    //       animation: _colorTween,
    //       builder: (context, child) => SvgPicture.asset(
    //         'assets/images/AppBackground.svg',
    //         colorFilter: ColorFilter.mode(_colorTween.value, BlendMode.srcIn),
    //         height: double.infinity,
    //         alignment: Alignment.bottomCenter,
    //       ),
    //     ),
    //
    //     // Main home page content
    //     Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 20),
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 // Text('Welcome back ${user.userName}!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
    //               ],
    //             ),
    //           ),
    //         ),
    //         if (!showDifficultySelectionButton)
    //           EventProgressContainer(onPageChange: widget.onPageChange,),
    //         if (showDifficultySelectionButton)
    //           Container(
    //             height: 100,
    //             width: double.infinity,
    //             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    //             margin: EdgeInsets.all(20),
    //             decoration: BoxDecoration(
    //               color: Colors.white70,
    //               borderRadius: BorderRadius.circular(10),
    //               boxShadow: BoxShadows.cardShadow,
    //             ),
    //             child: Text('Select a difficulty'),
    //           ),
    //         Spacer(),
    //         if (!showDifficultySelectionButton && mainChallenge != null)
    //           HomeScreenMainChallengeSnapshot(challenge: mainChallenge, user: user, event: currentEvent,)
    //       ],
    //     ),
    //   ],
    // );
  }
}