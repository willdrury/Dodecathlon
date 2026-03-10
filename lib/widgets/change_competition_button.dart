import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/competition_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeCompetitionButton extends ConsumerStatefulWidget {
  const ChangeCompetitionButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChangeCompetitionButtonState();
  }
}

class _ChangeCompetitionButtonState extends ConsumerState<ChangeCompetitionButton> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }
    User user = userStream.value!;
    AsyncValue<List<Competition>> competitionsStream = ref.watch(competitionProvider);
    var settings = ref.watch(settingsProvider);

    if (!competitionsStream.hasValue) {
      return SizedBox(height: 10,); // TODO: Logging and or loading icon?
    }

    List<Competition> competitions = competitionsStream.value!.where((c) =>
      user.competitions.contains(c.id)
    ).toList();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Active Competitions',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: competitions.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              settings = {...settings, 'current_competition': competitions[i].id};
                              ref.read(settingsProvider.notifier).updateSettings(settings);
                            });
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                  competitions[i].displayImageUrl != null
                                    ? competitions[i].displayImageUrl!
                                    : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                                ),
                              ),
                              SizedBox(width: 20,),
                              Text(
                                competitions[i].name,
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              if (settings['current_competition'] == competitions[i].id)
                                Icon(Icons.check, color: Colors.blue,)
                            ],
                          ),
                        ),
                      );
                    }),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CompetitionCreationScreen())
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.grey,)
                  )
                ],
              ),
            );
          },
        );
      },
      child: Text(
        'Change',
        style: TextStyle(
            color: Colors.blue,
            fontSize: 10
        ),
      ),
    );
  }
}