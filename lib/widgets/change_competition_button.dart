import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/competition_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/competitions_screen.dart';

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
    User user = ref.read(userProvider)!;
    AsyncValue<List<Competition>> competitionsStream = ref.watch(competitionProvider);
    var _settings = ref.watch(settingsProvider);

    if (user == null || !competitionsStream.hasValue) {
      return SizedBox(height: 10,); // TODO: Logging and or loading icon?
    }

    List<Competition> competitions = competitionsStream.value!.where((c) =>
      user.competitions!.contains(c.id)
    ).toList();

    print('current competition: ${_settings['current_competition']}');

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
                              _settings = {..._settings, 'current_competition': competitions[i].id};
                              ref.read(settingsProvider.notifier).updateSettings(_settings);
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
                              if (_settings['current_competition'] == competitions[i].id)
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