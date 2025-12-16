import 'package:dodecathlon/providers/announcement_provider.dart';
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

    AsyncValue<List<Announcement>> announcements = ref.watch(announcementProvider);

    if (!announcements.hasValue) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (announcements.value!.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Text('Looks like you are all caught up!'),
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
                for (Announcement a in announcements.value!)
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
                          leading: SizedBox(
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