import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:dodecathlon/screens/event_schedule_screen.dart';
import 'package:dodecathlon/utilities/custom_color_extension.dart';
import 'package:dodecathlon/widgets/event_progress_container.dart';
import 'package:dodecathlon/widgets/leaderboard_snapshot.dart';
import 'package:dodecathlon/widgets/select_difficulty_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.user, required this.users});

  User user;
  List<User> users;
  int eventIndex = 0;
  Competition competition = competition2025;

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    CustomColorsExtension customColors = Theme.of(context).extension<CustomColorsExtension>()!;
    bool _showDifficultySelectionButton =
        competition2025.events[widget.eventIndex].hasMultipleDifficulties && widget.user.currentEventDifficulty.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: customColors.primaryDim.withAlpha(100),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 10,),
            if (_showDifficultySelectionButton)
              SelectDifficultyContainer(eventIndex: widget.eventIndex),
            if (!_showDifficultySelectionButton)
              EventProgressContainer(user: widget.user),
            SizedBox(height: 10,),
            LeaderboardSnapshop(currentUser: widget.user, users: widget.users),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: widget.competition.events[widget.eventIndex]))
                      );
                    },
                    child: Column(
                      children: [
                        Text('Current Event', style: TextStyle(fontSize: 20),),
                        Spacer(),
                        Icon(Icons.auto_stories, color: widget.competition.events[widget.eventIndex].themeColor, size: 50,),
                        Spacer(),
                        Text(widget.competition.events[widget.eventIndex].name, style: TextStyle(fontSize: 20),),
                        Spacer(),
                        Text('Details', style: TextStyle(color: Theme.of(context).colorScheme.primary),)
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.grey,),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => EventScheduleScreen())
                      );
                    },
                    child: Column(
                      children: [
                        Text('Next Event', style: TextStyle(fontSize: 20),),
                        Spacer(),
                        Icon(widget.competition.events[widget.eventIndex + 1].icon, color: widget.competition.events[widget.eventIndex + 1].themeColor, size: 50,),
                        Spacer(),
                        Text(widget.competition.events[widget.eventIndex + 1].name, style: TextStyle(fontSize: 20),),
                        Spacer(),
                        Text('Full Schedule', style: TextStyle(color: Theme.of(context).colorScheme.primary),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}