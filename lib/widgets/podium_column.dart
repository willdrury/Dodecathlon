import 'package:dodecathlon/models/user.dart';
import 'package:flutter/material.dart';

import '../screens/user_details_screen.dart';

String kDefaultIcon = 'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg?w=360';

class PodiumColumn extends StatelessWidget {
  PodiumColumn({
    super.key,
    required this.heightFactor,
    required this.barColor,
    required this.user,
    required this.isEvent,
  });

  final double heightFactor;
  final Color barColor;
  User user;
  bool isEvent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: user))
                );
              },
              child: CircleAvatar(backgroundImage: NetworkImage(
                  user.profileImageUrl != null
                    ? user.profileImageUrl !
                    : kDefaultIcon
              ),),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                isEvent ? user.currentEventPoints[0].toString() : user.currentCompetitionPoints[0].toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 80 * heightFactor,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 3),
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              )
            )
          ],
        )
    );
  }
}