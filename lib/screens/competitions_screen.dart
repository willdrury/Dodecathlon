import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/competition_creation_screen.dart';
import 'package:dodecathlon/widgets/competition_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/competition.dart';
import '../models/user.dart';

class CompetitionsScreen extends ConsumerWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Competition>> competitionsStream = ref.watch(competitionProvider);
    User? user = ref.watch(userProvider);

    if (!competitionsStream.hasValue || user == null) {
      // TODO: Logging
      return Center(child: CircularProgressIndicator(),);
    }

    void onToggle(String id) async {
      if (user.competitions.contains(id)) {
        user.competitions.remove(id);
      } else {
        user.competitions.add(id);
      }
      await user.update();
    }

    List<Competition> userCompetitions = [];
    List<Competition> nonUserCompetitions = [];
    for (Competition c in competitionsStream.value!) {
      if (user.competitions.contains(c.id)) {
        userCompetitions.add(c);
      } else {
        nonUserCompetitions.add(c);
      }
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Competitions'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Competitions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (userCompetitions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: userCompetitions.length,
                  itemBuilder: (ctx, i) {
                    return CompetitionTile(
                      competition: userCompetitions[i],
                      onToggle: onToggle,
                      isUserComp: true,
                    );
                  }),
              if (userCompetitions.isEmpty)
                Text(
                  'Select a competition from below, or create your own to get started',
                  style: TextStyle(
                    color: Colors.grey
                  )
                ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    'User Competitions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => CompetitionCreationScreen())
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                      )
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: nonUserCompetitions.length,
                itemBuilder: (ctx, i) {
                  return CompetitionTile(
                    competition: nonUserCompetitions[i],
                    onToggle: onToggle,
                    isUserComp: false,
                  );
                }),
            ],
          ),
        )
    );
  }
}