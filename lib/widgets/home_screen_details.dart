import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/screens/competitions_screen.dart';
import 'package:dodecathlon/screens/milestones_screen.dart';
import 'package:dodecathlon/widgets/home_screen_main_challenge_snapshot.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/challenge.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../screens/event_details_screen.dart';

class HomeScreenDetails extends StatefulWidget {
  const HomeScreenDetails({
    super.key,
    required this.challenge,
    required this.user,
    required this.event,
  });

  final Challenge challenge;
  final User user;
  final Event event;

  @override
  State<StatefulWidget> createState() {
    return HomeScreenDetailsState();
  }
}


class HomeScreenDetailsState extends State<HomeScreenDetails> with SingleTickerProviderStateMixin {

  bool hasFeaturedChallenge = true; // TODO: replace

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CompetitionsScreen())
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 5),
                              spreadRadius: 1,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Curent Competition ', style: Theme.of(context).textTheme.labelSmall,),
                              Text('Dodecathlon', style: Theme.of(context).textTheme.labelMedium,), // TODO: Dynamic
                            ],
                          ),
                          SizedBox(width: 15,),
                          CircleAvatar(
                            backgroundColor: widget.event.themeColor.withAlpha(50),
                            backgroundImage: Image.network(
                                widget.challenge.imageUrl!, // TODO: Change to competition image
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(color: widget.event.themeColor,);
                                }
                            ).image,
                          ),
                        ]
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => MilestonesScreen())
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, right: 10),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 5),
                                    spreadRadius: 1,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Icon(Icons.emoji_events_outlined),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 2),
                                    spreadRadius: 1,
                                    blurRadius: 3
                                )
                              ]
                          ),
                          child: Text('Milestones', style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            // shadows: [
                            //   BoxShadow(
                            //     color: Theme.of(context).colorScheme.onSurface,
                            //     offset: Offset(0, 5),
                            //     spreadRadius: 1,
                            //     blurRadius: 5
                            //   )
                            // ]
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Spacer(),

            if (!hasFeaturedChallenge)
              Container(
                margin: EdgeInsets.all(30),
                child: SvgPicture.asset(
                  'assets/images/DodecathlonLogo_Outline_Pink.svg',
                  height: 120,
                  // colorFilter: ColorFilter.mode(_colorTween.value, BlendMode.srcIn),
                ),
              ),
            if (hasFeaturedChallenge)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ChallengeDetailsScreen(
                      challenge: widget.challenge,
                        isCompleted: false,  // TODO: set appropriately
                        event: widget.event
                    ))
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Theme.of(context).colorScheme.primaryContainer, width: 10),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                      )
                    ]
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.event.themeColor.withAlpha(50),
                        backgroundImage: Image.network(
                          widget.challenge.imageUrl!, // Make sure this is always set
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(color: widget.event.themeColor,);
                          }
                        ).image,
                        maxRadius: 100,
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        height: 50,
                        width: 400,
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              'Featured Challenge',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(widget.challenge.name, style: Theme.of(context).textTheme.labelLarge,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20,),
            Container(
              width: constraints.maxWidth * .8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today', style: Theme.of(context).textTheme.labelSmall,),
                  TextButton(
                    style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.only(left: 5)),),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text('Customize', style: Theme.of(context).textTheme.labelSmall,),
                        Icon(Icons.chevron_right, color: Colors.grey,)
                      ],
                    )
                  )
                ],
              ),
            ),
            HomeScreenMainChallengeSnapshot(challenge: widget.challenge, user: widget.user, event: widget.event),
            SizedBox(height: 20,),

            // Main Snapshot
            Container(
              width: constraints.maxWidth * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 5),
                    spreadRadius: 1,
                    blurRadius: 5
                  )
                ]
              ),
              child: Column(
                children: [

                  // TODO: Need to actually implement daily challenge logic
                  // Featured Challenge Container
                  // Container(
                  //   height: 90,
                  //   padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('Featured Challenge', style: Theme.of(context).textTheme.labelMedium,),
                  //             Text('Challenge Name', style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis,),
                  //             Text('Time remaining: ', style: Theme.of(context).textTheme.labelSmall,)
                  //           ],
                  //         ),
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               Text('20 pt', style: Theme.of(context).textTheme.bodyLarge,),
                  //               Icon(Icons.chevron_right, size: 30,)
                  //             ],
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Divider(),

                  // Rank Containers
                  Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Event Rank', style: Theme.of(context).textTheme.labelMedium,),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text('23', style: Theme.of(context).textTheme.displayMedium,)
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(width: 1, color: Theme.of(context).colorScheme.outline,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Competition Rank', style: Theme.of(context).textTheme.labelMedium,),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text('87', style: Theme.of(context).textTheme.displayMedium,)
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).colorScheme.outline),

                  // Event Points Container
                  Container(
                    height: 90,
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Points', style: Theme.of(context).textTheme.labelMedium,),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 20,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12
                              ),
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.only(right: 5),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.lerp(Colors.pinkAccent, Colors.white, .15)!,
                                      Colors.pinkAccent,
                                      Color.lerp(Colors.pinkAccent, Colors.black, .1)!
                                    ]
                                  ),
                                ),
                                // child: Text(
                                //   '23 pt.',
                                //   style: TextStyle(
                                //     height: 1.0,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,)
          ]
        );
      }
    );
  }
}