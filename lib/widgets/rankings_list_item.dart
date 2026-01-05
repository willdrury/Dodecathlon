import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/screens/user_details_screen.dart';
import 'package:flutter/material.dart';

class RankingsListItem extends StatelessWidget {
  const RankingsListItem({super.key, required this.user, required this.points});
  
  final User user;
  final int points;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: user))
        );
      },
      leading: user.profileImageUrl != null
        ? CircleAvatar(backgroundImage: NetworkImage(user.profileImageUrl!))
        : CircleAvatar(child: Text(user.userName[0]),),
      title: Text(user.userName),
      trailing: Text(points.toString()),
    );
  }
}