import 'package:dodecathlon/data/demo_data/demo_users.dart';
import 'package:dodecathlon/models/in_person_event.dart';

InPersonEvent bookClub = InPersonEvent(
    name: 'Book Club Meeting',
    description: 'Come discuss the book "Into the Wild" with us!',
    location: 'Loki Coffee',
    startTime: DateTime(2025, 1, 5, 8, 30),
    endTime: DateTime(2025, 1, 5, 10, 0),
    host: biw,
    attending: [biw, kamala, bill, trump],
    displayImageUrl: 'https://lh3.googleusercontent.com/p/AF1QipNdICJmuSjc5_8KuzKno6rppMHz7RdRKZ1ByOQL=s680-w680-h510'
);

InPersonEvent bookClub2 = InPersonEvent(
    name: 'Book Club Meeting',
    description: 'Come discuss the book "Art of the Deal!"',
    location: 'Some back ally',
    startTime: DateTime(2025, 1, 12, 8, 30),
    endTime: DateTime(2025, 1, 12, 10, 0),
    host: trump,
    attending: [],
    displayImageUrl: 'https://burst.shopifycdn.com/photos/grungy-back-alley-in-the-city.jpg?exif=0&iptc=0'
);

List<InPersonEvent> demoInPersonEvents = [
  bookClub,
  bookClub2
];