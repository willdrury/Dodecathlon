import 'package:flutter/Material.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Admin Home'),
            Text('Create News Announcement'),
            Text('Approve in person event requests'),
            Text('Select highlighted post'),
            Text('View reported posts'),
            Text('Create bonus event'),
            Text('More'),
          ],
        ),
      ),
    );
  }
}