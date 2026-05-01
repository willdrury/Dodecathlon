import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/screens/competitions_screen.dart';
import 'package:dodecathlon/screens/milestones_screen.dart';
import 'package:dodecathlon/widgets/home_screen_main_challenge_snapshot.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
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
    required this.mainPoints,
    required this.bonusPoints,
    required this.eventRank,
    required this.competitionRank,
    required this.onPageChange,
  });

  final Challenge challenge;
  final User user;
  final Event event;
  final int mainPoints;
  final int bonusPoints;
  final int eventRank;
  final int competitionRank;
  final Function(int, BuildContext) onPageChange;

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
            // Competition, Milestone, and Featured challenge containers
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // Competition and Milestone Containers
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Competition Container
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => CompetitionsScreen())
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
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
                                Text('Current Competition ', style: Theme.of(context).textTheme.labelSmall,),
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
                    // Milestone Container
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
                                  color: Theme.of(context).colorScheme.tertiaryContainer,
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

                // Featured Challenge / Fallback container
                if (!hasFeaturedChallenge)
                  Container(
                    margin: EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      'assets/images/DodecathlonLogo_Outline_Pink.svg',
                      height: 160,
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 250,
                          width: 250,
                          margin: EdgeInsets.only(top: 90),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            // border: Border.all(color: Theme.of(context).colorScheme.primaryContainer, width: 5),
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                // color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(100),
                                color: Colors.black12,
                                offset: Offset(0, 10),
                                spreadRadius: 1,
                                blurRadius: 10
                              ),
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
                                maxRadius: 150,
                              ),
                              Container(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                height: 70,
                                width: 400,
                                padding: EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Text(widget.challenge.name, style: Theme.of(context).textTheme.bodyLarge,),
                                    Text(
                                      'Featured Challenge',
                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100)
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Spacer(),
            Container(
              width: constraints.maxWidth * .85,
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
              width: constraints.maxWidth * .9,
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

                  // Rank Containers
                  GestureDetector(
                    onTap: () {
                      widget.onPageChange(4, context);
                    },
                    child: Container(
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Event Rank', style: Theme.of(context).textTheme.labelMedium,),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(widget.eventRank.toString(), style: Theme.of(context).textTheme.displayMedium,)
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(width: 1, color: Theme.of(context).colorScheme.outline,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Competition Rank', style: Theme.of(context).textTheme.labelMedium,),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(widget.competitionRank.toString(), style: Theme.of(context).textTheme.displayMedium,)
                                    )
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).colorScheme.outline),

                  // Event Points Container
                  GestureDetector(
                    onTap: () {
                      widget.onPageChange(1, context);
                    },
                    child: Container(
                      height: 90,
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Event Points', style: Theme.of(context).textTheme.labelMedium,),
                              Spacer(),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        'Main Points (${widget.mainPoints})',
                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        'Bonus Points (${widget.bonusPoints})',
                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Progress bar
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black12
                                ),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: (widget.bonusPoints + widget.mainPoints) / MAX_ADVANCED_POINTS, // TODO: change based on user difficulty
                                      child: Container(
                                        width: 100,
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.only(right: 5),
                                        alignment: Alignment.centerRight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color.lerp(Colors.blue, Colors.white, .15)!,
                                                Colors.blue,
                                                Color.lerp(Colors.blue, Colors.black, .1)!
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: widget.mainPoints / MAX_ADVANCED_POINTS, // TODO: change based on user difficulty
                                      child: Container(
                                        width: 100,
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.only(right: 5),
                                        alignment: Alignment.centerRight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.lerp(Theme.of(context).colorScheme.secondary, Colors.white, .2)!,
                                              Theme.of(context).colorScheme.secondary,
                                              Color.lerp(Theme.of(context).colorScheme.secondary, Colors.black, .2)!
                                              // Color.lerp(Colors.pinkAccent, Colors.white, .15)!,
                                              // Colors.pinkAccent,
                                              // Color.lerp(Colors.pinkAccent, Colors.black, .1)!
                                            ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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