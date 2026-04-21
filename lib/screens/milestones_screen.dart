import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/milestone_container.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

final formatter = DateFormat('yMMMMd');

class MilestonesScreen extends ConsumerStatefulWidget {
  const MilestonesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MilestonesScreenState();
  }
}

class _MilestonesScreenState extends ConsumerState<MilestonesScreen> {

  @override
  Widget build(BuildContext context) {
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }
    User user = userStream.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Milestones'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100,),
              GridView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  MilestoneContainer(
                    name: 'Cool Kid',
                    description: 'Join the app',
                    icon: Icons.account_circle,
                    isCompleted: true,
                    completedDate: user.createdDate,
                  ),
                  MilestoneContainer(
                    name: 'Aspiring Athlete',
                    description: 'Join a competition',
                    icon: Icons.border_color,
                    isCompleted: true
                  ),
                  MilestoneContainer(
                    name: 'Amateur Athlete',
                    description: 'Finish an event',
                    icon: Icons.event,
                    isCompleted: true
                  ),
                  MilestoneContainer(
                    name: 'Experienced Athlete',
                    description: 'Finish a competition',
                    icon: Icons.directions_walk,
                    isCompleted: false
                  ),
                  MilestoneContainer(
                    name: 'Podium Placer',
                    description: 'Win an event',
                    icon: Icons.leaderboard,
                    isCompleted: false
                  ),
                  MilestoneContainer(
                    name: 'Podium Prodigy',
                    description: 'Win a competition',
                    icon: Icons.workspace_premium,
                    isCompleted: false
                  ),
                  MilestoneContainer(
                    name: 'Aspiring Ref',
                    description: 'Approve a submission',
                    icon: Icons.approval,
                    isCompleted: false
                  ),
                  MilestoneContainer(
                    name: 'Little League Ref',
                    description: 'Approve 10 submissions',
                    icon: Icons.badge,
                    isCompleted: false
                  ),
                  MilestoneContainer(
                      name: 'Big League Ref',
                      description: 'Approve 100 submissions',
                      icon: Icons.verified,
                      isCompleted: false
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