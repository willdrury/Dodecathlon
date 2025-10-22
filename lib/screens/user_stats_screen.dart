import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

final formatter = DateFormat('yMMMMd');

class UserStatsScreen extends ConsumerStatefulWidget {
  UserStatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserStatsScreenState();
  }
}

class _UserStatsScreenState extends ConsumerState<UserStatsScreen> {

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider)!;
    List<String> achievements = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(title: Text('Joined'), subtitle: Text(formatter.format(user.createdDate)),),
              ListTile(title: Text('Highest Rank'),),
              ListTile(title: Text('Previous Events'), trailing: Icon(Icons.chevron_right), onTap: () {},),
              ListTile(title: Text('Achievements:'),),
              GridView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  for(String s in achievements)
                    Container(
                      height: 200,
                      child: Column(
                        children: [
                          Icon(Icons.celebration, size: 60, color: Colors.pink,),
                          Text(s)
                        ],
                      ),
                    )
                ]
              ),
            ]
          ),
        ),
      )
    );
  }
}