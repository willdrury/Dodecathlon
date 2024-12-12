import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/data/demo_data/demo_in_person_events.dart';
import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:dodecathlon/utilities/custom_color_extension.dart';
import 'package:dodecathlon/widgets/event_progress_container.dart';
import 'package:dodecathlon/widgets/home_page_shortcuts.dart';
import 'package:dodecathlon/widgets/in_person_event_card.dart';
import 'package:dodecathlon/widgets/post_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../providers/users_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  int eventIndex = 0;
  Competition competition = competition2025;
  List<InPersonEvent> inPersonEvents = demoInPersonEvents.sublist(0,1);

  @override
  ConsumerState<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    User user = ref.watch(userProvider)!;
    List<User> users = ref.watch(usersProvider);

    // Only show posts within the last week that have been highlighted
    List<Post> _postHighlights = ref.watch(postsProvider).where((p) =>
      p.highlighted == true && p.createdAt.isAfter(DateTime.now().add(Duration(days: -7)))
    ).toList();

    for (Post p in _postHighlights) {
      p.user = users.where((u) => u.id == p.userId).first;
    }

    bool _showDifficultySelectionButton =
        competition2025.events[widget.eventIndex].hasMultipleDifficulties && user.currentEventDifficulty.isEmpty;

    CustomColorsExtension customColors = Theme.of(context).extension<CustomColorsExtension>()!;

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Welcome back ${user.userName}!', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
          if (_showDifficultySelectionButton)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: widget.competition.events[widget.eventIndex],))
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, ColorUtility().lighten(Theme.of(context).colorScheme.primary, .4)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    child: Text('Click here to get started this month!'),
                  ),
                )
              ],
            ),
          if (!_showDifficultySelectionButton)
            EventProgressContainer(),
          Stack(
            children: [
              Container(
                height: 200,
                color: ColorUtility().lighten(Theme.of(context).colorScheme.primary, .4),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, -1),
                      spreadRadius: 1,
                      blurRadius: 7,
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text('What\'s New', style:
                        TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Upcoming Events Near you', style:
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      for (InPersonEvent event in widget.inPersonEvents)
                        InPersonEventCard(event: event),
                      SizedBox(height: 20,),
                      // Text('News', style:
                      //   TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text('Nothing here right now...'),
                      SizedBox(height: 20,),
                      Text('Highlights', style:
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      for (Post post in _postHighlights)
                        PostContainer(post: post),
                      SizedBox(height: 20,),
                      Text('Jump to', style:
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      HomePageShortcuts(currentEvent: widget.competition.events[widget.eventIndex], nextEvent: widget.competition.events[widget.eventIndex + 1],),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}