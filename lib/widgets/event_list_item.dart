import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {
  EventListItem({
    super.key,
    required this.event,
    required this.columnAlignment,
    required this.textAlignment,
  });

  Event event;
  CrossAxisAlignment columnAlignment;
  TextAlign textAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: columnAlignment,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(event.name.toUpperCase(), style: TextStyle(color: event.themeColor, fontSize: 30, fontWeight: FontWeight.bold, height: .7),),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: event))
              );
            },
            child: Container(
              height: 250,
              width: 320,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: columnAlignment == CrossAxisAlignment.start ? Radius.circular(0) : Radius.circular(20),
                    right: columnAlignment == CrossAxisAlignment.end ? Radius.circular(0) : Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [event.themeColor, ColorUtility().darken(event.themeColor)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorUtility().darken(event.themeColor).withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 10)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: columnAlignment,
                children: [
                  Text(event.description, style: TextStyle(color: Colors.white, fontSize: 20), textAlign: textAlignment,),
                ],
              ),
            ),
          ),
          SizedBox(height: 400,)
          // Container(
          //   height: 50,
          //   width: 300,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //     gradient: LinearGradient(
          //       colors: [ColorUtility().darken(color).withAlpha(100), Colors.transparent],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     )
          //   ),
          // )
        ],
      ),
    );
  }
}