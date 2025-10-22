import 'package:dodecathlon/models/user.dart';
import 'package:flutter/material.dart';

import '../screens/user_details_screen.dart';

String kDefaultIcon = 'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg?w=360';

class PodiumColumn extends StatelessWidget {
  const PodiumColumn({
    super.key,
    required this.heightFactor,
    required this.barColor,
    required this.user,
    required this.isEvent,
  });

  final double heightFactor;
  final Color barColor;
  final User user;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {

    Widget profileContainer = GestureDetector(
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
    );

    return
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isEvent? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isEvent)
            profileContainer,
          Container(
            width: 200 * heightFactor,
            height: 40,
            alignment: isEvent ? Alignment.centerLeft : Alignment.centerRight,
            margin: isEvent ? EdgeInsets.only(left: 10, bottom: 5, top: 5) : EdgeInsets.only(right: 10, bottom: 5, top: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: isEvent ? BorderRadius.horizontal(left: Radius.circular(30)) : BorderRadius.horizontal(right: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 3),
                  spreadRadius: 1,
                  blurRadius: 3
                )
              ]
            ),
            child: Text(
              isEvent ? user.currentEventPoints[0].toString() : user.currentCompetitionPoints[0].toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          if (!isEvent)
            profileContainer
        ],
      );
  }
}