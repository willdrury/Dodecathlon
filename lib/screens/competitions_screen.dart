import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/competition_creation_screen.dart';
import 'package:dodecathlon/widgets/faq_list_tile.dart';
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

    List<Competition> competitions = competitionsStream.value!.where((c) =>
      user.competitions!.contains(c.id)
    ).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Competitions'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => CompetitionCreationScreen())
                  );
                },
                child: Text('Create a new Competition')
              ),
              Container( // TODO: Make sure this is scrollable if there are more competitions than possible
                height: 400,
                child: ListView.builder(
                    itemCount: competitions.length,
                    itemExtent: 100,
                    itemBuilder: (ctx, i) {
                      return Text(competitions[i].name);
                    }),
              ),
            ],
          ),
        )
    );
  }
}