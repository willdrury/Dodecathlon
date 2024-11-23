import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:dodecathlon/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventScheduleScreen extends StatefulWidget {
  EventScheduleScreen({super.key});

  @override
  State<EventScheduleScreen> createState() => _EventScheduleScreenState();
}

class _EventScheduleScreenState extends State<EventScheduleScreen> {
  List<Event> events = competition2025.events;

  late List<Color> _backgroundColors;

  ScrollController? _scrollController;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _backgroundColors = events.map((event) => event.themeColor).toList();
    _backgroundColors.insert(0, Colors.white);
  }

  bool _changeBackground(ScrollNotification notification) {
    if (_scrollController == null) return true;
    double maxExtent = _scrollController!.position.maxScrollExtent;
    double currentPixels = _scrollController!.position.pixels;
    setState(() {
      double sectionHeight = maxExtent/12;
      int aboveIndex = (12*currentPixels/maxExtent).floor();
      int belowIndex = (12*currentPixels/maxExtent).ceil();
      Color above = _backgroundColors[aboveIndex];
      Color below = _backgroundColors[belowIndex];
      double remainder = currentPixels%sectionHeight/sectionHeight;
      _backgroundColor = Color.lerp(Color.lerp(above, below, remainder)!, Colors.white, .85)!;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _changeBackground,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(backgroundColor: _backgroundColor,)
            ];
          },
          body: Builder(
            builder: (context) {
              _scrollController = PrimaryScrollController.of(context);
              return ListView(
                children: [
                  Container(
                    height: 600,
                    padding: EdgeInsets.only(left: 20),
                    width: 300,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text('2025\nEVENT\nSCHEDULE', style: GoogleFonts.robotoMono(fontSize: 50), textAlign: TextAlign.left,)
                        ),
                        SizedBox(height: 200,),
                        Icon(Icons.arrow_downward),
                      ],
                    ),
                  ),
                  SizedBox(height: 150,),
                  EventListItem(
                    event: events[0],
                    columnAlignment: CrossAxisAlignment.center,
                    textAlignment: TextAlign.center,
                  ),
                  EventListItem(
                    event: events[1],
                    columnAlignment: CrossAxisAlignment.start,
                    textAlignment: TextAlign.start,
                  ),
                  EventListItem(
                    event: events[2],
                    columnAlignment: CrossAxisAlignment.end,
                    textAlignment: TextAlign.end,
                  ),
                  EventListItem(
                    event: events[3],
                    columnAlignment: CrossAxisAlignment.center,
                    textAlignment: TextAlign.center,
                  ),
                  EventListItem(
                    event: events[4],
                    columnAlignment: CrossAxisAlignment.end,
                    textAlignment: TextAlign.end,
                  ),
                  EventListItem(
                    event: events[5],
                    columnAlignment: CrossAxisAlignment.start,
                    textAlignment: TextAlign.start,
                  ),
                  EventListItem(
                    event: events[6],
                    columnAlignment: CrossAxisAlignment.end,
                    textAlignment: TextAlign.end,
                  ),

                  EventListItem(
                    event: events[7],
                    columnAlignment: CrossAxisAlignment.center,
                    textAlignment: TextAlign.center,
                  ),
                  EventListItem(
                    event: events[8],
                    columnAlignment: CrossAxisAlignment.end,
                    textAlignment: TextAlign.end,
                  ),
                  EventListItem(
                    event: events[9],
                    columnAlignment: CrossAxisAlignment.start,
                    textAlignment: TextAlign.start,
                  ),
                  EventListItem(
                    event: events[10],
                    columnAlignment: CrossAxisAlignment.end,
                    textAlignment: TextAlign.end,
                  ),
                  EventListItem(
                    event: events[11],
                    columnAlignment: CrossAxisAlignment.center,
                    textAlignment: TextAlign.center,
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}