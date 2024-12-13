import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/providers/announcement_provider.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/widgets/bonus_challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement.dart';

class AnnouncementsCarousel extends ConsumerStatefulWidget {
  const AnnouncementsCarousel({super.key});

  @override
  ConsumerState<AnnouncementsCarousel> createState() {
    return _AnnouncementsCarouselState();
  }
}

class _AnnouncementsCarouselState extends ConsumerState<AnnouncementsCarousel> {
  @override
  Widget build(BuildContext context) {

    List<Announcement> announcements = ref.watch(announcementProvider);

    if (announcements.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Text('Nothing here...'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: CarouselView(
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemExtent: 350,
              shrinkExtent: 350,
              children: [
                for (Announcement a in announcements)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black26)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(a.title, style: TextStyle(fontWeight: FontWeight.bold),),
                          leading: Container(
                            height: 30,
                            child: Image.asset('assets/images/DodecathlonLogoOutline.png')
                          ),
                          shape: Border(bottom: BorderSide(color: Colors.black26)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(a.body),
                        )
                      ],
                    ),
                  )
              ]
          ),
        )
      ],
    );
  }
}