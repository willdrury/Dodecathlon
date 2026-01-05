import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/user_event_rankings_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/rankings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EventRankSnapshot extends ConsumerWidget {

  const EventRankSnapshot({super.key, required this.onPageChange});

  final Function(int, BuildContext) onPageChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider)!;
    AsyncValue<List<User>> users = ref.read(usersProvider);
    AsyncValue<List<(String, int)>> userRankings = ref.watch(userEventRankingsProvider);

    if (user == null || !userRankings.hasValue || !users.hasValue) {
      return Center(child: CircularProgressIndicator(),); // TODO: Replace with better loading
    }

    if (userRankings.value!.isEmpty) {
      return Center(child: CircularProgressIndicator(),); // TODO: Replace with better loading
    }

    List<String> userRankingsById = userRankings.value!.map((e) => e.$1).toList();
    int prevRank = user.currentEventRank[0] + 1;
    int currRank = userRankingsById.indexOf(user.id!) + 1;
    int rankDiff = prevRank - currRank;
    bool showDiffIcon = rankDiff != 0;
    Color textColor;

    if (rankDiff == 0) {
      textColor = Colors.grey;
    } else if (rankDiff > 0) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        onPageChange(4, context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 5, right: 5),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                    ]
                ),
                child: Text(
                  currRank.toString(),
                  style: GoogleFonts.shareTech(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              if (showDiffIcon)
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    rankDiff > 0 ? '+${rankDiff.toString()}' : rankDiff.toString(),
                    style: GoogleFonts.shareTech(
                        color: Colors.white,
                        fontSize: 10
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10,),
          Text('Rank')
        ],
      ),
    );
  }
}