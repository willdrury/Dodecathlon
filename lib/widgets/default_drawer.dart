import 'package:dodecathlon/screens/event_schedule_screen.dart';
import 'package:dodecathlon/screens/faq_screen.dart';
import 'package:dodecathlon/screens/feedback_screen.dart';
import 'package:dodecathlon/screens/profile_screen.dart';
import 'package:dodecathlon/screens/settings_screen.dart';
import 'package:dodecathlon/widgets/vertical_icon_button.dart';
import 'package:flutter/material.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 130,
      backgroundColor: Colors.white,
      shape: Border(),
      child: ListView(
        children: [
          DrawerHeader(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EventScheduleScreen())
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Image.asset('assets/images/DodecathlonLogoOutline.png'),
                    ),
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.black12,
                    //       borderRadius: BorderRadius.circular(5)
                    //   ),
                    // ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dodecathlon', style: TextStyle(fontSize: 10),),
                          // Icon(Icons.expand_more, size: 15,),
                        ],
                      ),
                    ),
                    // Text('change', style: TextStyle(fontSize: 10, color: Colors.blue),)
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