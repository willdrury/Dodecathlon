import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EventRankSnapshot extends ConsumerWidget {

  EventRankSnapshot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider)!;
    int prevRank = 22;
    int currRank = 20;
    int rankDiff = prevRank - currRank;
    bool showDiffIcon = rankDiff != 0;
    Color textColor;

    if (rankDiff == 0) {
      textColor = Colors.grey;
    } else if (rankDiff > 1) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }

    return Column(
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
                  color: Colors.white,
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
                  rankDiff > 1 ? '+${rankDiff.toString()}' : rankDiff.toString(),
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
    );
  }
}