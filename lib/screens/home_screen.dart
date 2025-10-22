import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:dodecathlon/widgets/event_progress_container.dart';
import 'package:dodecathlon/widgets/home_screen_event_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../providers/users_provider.dart';
import '../providers/events_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  final int eventIndex = 0;

  @override
  ConsumerState<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation _colorTween;

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
      await new Future.delayed(const Duration(seconds: 5), () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    User user = ref.watch(userProvider)!;
    AsyncValue<List<User>> users = ref.watch(usersProvider);
    List<Event>? currentEvents = ref.read(eventProvider);
    if (currentEvents !=  null) {
      currentEvents.sort((a, b) => a.startDate.isBefore(b.startDate) ? 1 : 0);
    }

    DateTime now = DateTime.now();
    Event? currentEvent = currentEvents == null || currentEvents.isEmpty
        ? null
        : currentEvents.firstWhere((e) => e.startDate.isBefore(now) & e.endDate.isAfter(now));

    AsyncValue<List<Challenge>> challenges = ref.read(challengesProvider);
    List<Challenge> eventChallenges = [];
    if (challenges.hasValue) {
      eventChallenges = challenges.value!.where((c) => c.eventId == currentEvent?.id).toList();
    }

    // Only show posts within the last week that have been highlighted
    List<Post> _postHighlights = ref.watch(postsProvider).where((p) =>
      p.highlighted == true && p.createdAt.isAfter(DateTime.now().add(Duration(days: -7)))
    ).toList();

    if (users.hasValue) {
      for (Post p in _postHighlights) {
        p.user = users.value!.where((u) => u.id == p.userId).first;
      }
    }

    bool _showDifficultySelectionButton =
      currentEvent != null
        && currentEvent.hasMultipleDifficulties
        && user.currentEventDifficulty != null;

    bool isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      child:
      currentEvent == null
        ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
        : Stack(
        children: [
          AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) => SvgPicture.asset(
              'assets/images/AppBackground.svg',
              colorFilter: ColorFilter.mode(_colorTween.value, BlendMode.srcIn),
              height: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),
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
              if (_showDifficultySelectionButton)
                Container(
                  height: 400,
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Theme.of(context).colorScheme.surface, ColorUtility().lighten(Theme.of(context).colorScheme.primary, .4)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80,),
                      Text('A new event has started!', style: TextStyle(fontSize: 30),),
                      SizedBox(height: 10,),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: currentEvent,))
                            );
                          },
                          icon: Icon(currentEvent.icon, size: 50, color: currentEvent.themeColor,)
                      ),
                      SizedBox(height: 10,),
                      Text('Click to learn more', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(
                      //         MaterialPageRoute(builder: (ctx) => FaqDetailsScreen(faq: eventDifficulties))
                      //     );
                      //   },
                      //   child: Text('How do difficulties work?', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                      // ),
                      SizedBox(height: 80,),
                    ],
                  ),
                ),
              if (!_showDifficultySelectionButton)
                EventProgressContainer(),
              if (!_showDifficultySelectionButton)
                HomeScreenEventSnapshot(),
              // Stack(
              //   children: [
              //     Container(
              //       height: 200,
              //       color: isLight ? ColorUtility().lighten(Theme.of(context).colorScheme.primary, .4) : ColorUtility().darken(Theme.of(context).colorScheme.primary, .5)
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Theme.of(context).colorScheme.surface,
              //         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black38,
              //             offset: Offset(0, -1),
              //             spreadRadius: 1,
              //             blurRadius: 7,
              //           )
              //         ]
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(15.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SizedBox(height: 10,),
              //             Text('What\'s New', style:
              //               TextStyle(
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             SizedBox(height: 10,),
              //             Text('News', style:
              //               TextStyle(
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             SizedBox(height: 10,),
              //             AnnouncementsCarousel(),
              //             SizedBox(height: 30,),
              //             if (inPersonEvents.isNotEmpty)
              //               Column(
              //                 children: [
              //                   Text('Upcoming Events Near you', style:
              //                     TextStyle(
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   SizedBox(height: 20,),
              //                   for (InPersonEvent event in inPersonEvents)
              //                     InPersonEventCard(event: event),
              //                   SizedBox(height: 20,),
              //                 ],
              //               ),
              //             if (_postHighlights.isNotEmpty)
              //               Column(
              //                 children: [
              //                   Text('Featured Posts', style:
              //                   TextStyle(
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                   ),
              //                   SizedBox(height: 10,),
              //                   for (Post post in _postHighlights)
              //                     PostContainer(post: post),
              //                   SizedBox(height: 20,),
              //                 ],
              //               ),
              //             Text('Jump to', style:
              //               TextStyle(
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             HomePageShortcuts(currentEvent: currentEvent, eventChallenges: eventChallenges, nextEvent: nextEvent,),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}