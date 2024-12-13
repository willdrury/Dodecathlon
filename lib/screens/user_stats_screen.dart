import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

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
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView(
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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                  ]
              ),
              child: Text('Joined: ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                  ]
              ),
              child: Text('Highest rank', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                  ]
              ),
              child: Text('Previous events', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                  ]
              ),
              child: Text('Achievements', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}