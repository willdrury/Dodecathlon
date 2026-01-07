import 'dart:async';

import 'package:dodecathlon/screens/admin_login_screen.dart';
import 'package:dodecathlon/screens/competitions_screen.dart';
import 'package:dodecathlon/screens/event_schedule_screen.dart';
import 'package:dodecathlon/screens/faq_screen.dart';
import 'package:dodecathlon/screens/feedback_screen.dart';
import 'package:dodecathlon/screens/profile_screen.dart';
import 'package:dodecathlon/widgets/change_competition_button.dart';
import 'package:dodecathlon/widgets/vertical_icon_button.dart';
import 'package:flutter/material.dart';

class DefaultDrawer extends StatelessWidget {
  DefaultDrawer({super.key});

  Timer? _timer;

  void _startOperation(BuildContext context) {
    _timer = Timer(const Duration(seconds: 5), () {
      _timer!.cancel();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => AdminLoginScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 130,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: Border(),
      child: ListView(
        children: [
          DrawerHeader(
            child: GestureDetector(
              onTapDown: (_) {
                _startOperation(context);
              },
              onTapUp: (_) {
                _timer!.cancel();
              },
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => CompetitionsScreen())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset('assets/images/DodecathlonLogoOutline.png'),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Competition:',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => CompetitionsScreen())
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dodecathlon', style: TextStyle(fontSize: 10),),
                        // Icon(Icons.expand_more, size: 15,),
                      ],
                    ),
                  ),
                  ChangeCompetitionButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30,),
          VerticalIconButton(
              icon: Icon(Icons.account_circle),
              label: 'Account',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ProfileScreen())
                );
              },
          ),
          const SizedBox(height: 30,),
          VerticalIconButton(
              icon: Icon(Icons.help_outline),
              label: 'FAQ',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const FaqScreen())
                );
              }
          ),
          const SizedBox(height: 30,),
          VerticalIconButton(
              icon: Icon(Icons.question_answer),
              label: 'Feedback',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const FeedbackScreen())
                );
              }
          ),
          // const SizedBox(height: 30,),
          // VerticalIconButton(
          //     icon: Icon(Icons.settings),
          //     label: 'Settings',
          //     onPressed: () {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (ctx) => const SettingsScreen())
          //       );
          //     }
          // ),
        ],
      ),
    );
  }
}