import 'package:dodecathlon/constants/boxShadows.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/widgets/event_progress_container.dart';
import 'package:dodecathlon/widgets/home_screen_event_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../providers/challenges_provider.dart';
import '../providers/users_provider.dart';
import '../providers/events_provider.dart';

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
        vsync: this, duration: Duration(milliseconds: 4999));
    _colorTween = ColorTween(begin: Color(0x78977CB7), end: Colors.blueGrey)
        .animate(_animationController);
    changeColors();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future changeColors() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 5), () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (mounted) {
          _animationController.forward();
        }
      });
    }
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

    User user = ref.watch(userProvider)!;
    AsyncValue<List<User>> users = ref.watch(usersProvider);
    AsyncValue<List<Event>> currentEvents = ref.watch(eventProvider);
    if (!currentEvents.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    currentEvents.value!.sort((a, b) => a.startDate.isBefore(b.startDate) ? 1 : 0);

    DateTime now = DateTime.now();
    Event? currentEvent = currentEvents.value!.isEmpty
        ? null
        : currentEvents.value!.where((e) =>
            e.startDate.isBefore(now) & e.endDate.isAfter(now)
          ).firstOrNull;

    if (currentEvent == null) { // TODO: Better error handling. Show screen if there is no event
      return Center(child: Text('Looks like there are no current events'),);
    }

    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    Challenge? mainChallenge;
    if (currentEvent.mainChallengeId != null && currentEvent.mainChallengeId!.isNotEmpty && challenges.hasValue) {
      mainChallenge = challenges.value!.firstWhere((c) => c.id == currentEvent!.mainChallengeId!);
    }

    // Only show posts within the last week that have been highlighted
    AsyncValue<List<Post>> posts = ref.watch(postsProvider);
    List<Post> postHighlights = [];
    if (posts.hasValue) {
      postHighlights = posts.value!.where((p) =>
        p.highlighted == true && p.createdAt.isAfter(DateTime.now().add(Duration(days: -7)))
      ).toList();
    }

    if (users.hasValue) {
      for (Post p in postHighlights) {
        p.user = users.value!.where((u) => u.id == p.userId).first;
      }
    }

    bool showDifficultySelectionButton =
      currentEvent != null
        && currentEvent.hasMultipleDifficulties
        && user.currentEventDifficulty == null;

    if (!hasDismissedNewEventNotification && showDifficultySelectionButton && !newEventNotificationPopupIsVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewEventSelectDialog(context, currentEvent);
      });
    }

    return Container(
      child:
      currentEvent == null
        ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
        : Stack(
        children: [
          // Background dodecahedron image
          AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) => SvgPicture.asset(
              'assets/images/AppBackground.svg',
              colorFilter: ColorFilter.mode(_colorTween.value, BlendMode.srcIn),
              height: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // Main home page content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back ${user.userName}!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              EventProgressContainer(onPageChange: widget.onPageChange,),
              if (showDifficultySelectionButton && currentEvent != null)
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: BoxShadows.cardShadow,
                  ),
                  child: Text('Select a difficulty'),
                ),
              // if (!showDifficultySelectionButton && mainChallenge != null)
              //   HomeScreenEventSnapshot(challenge: mainChallenge,),
            ],
          ),
        ],
      ),
    );
  }
}