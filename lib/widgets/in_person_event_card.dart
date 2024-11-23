import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/screens/in_person_event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('MMM d');

class InPersonEventCard extends StatelessWidget {
  InPersonEventCard({super.key, required this.event});

  InPersonEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  event.host.profileImageUrl != null
                      ? event.host.profileImageUrl!
                      : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
              ),
            ),
            title: Text(event.host.userName),
            subtitle: Text('Starts: ${formatter.format(event.startTime)}, ${event.startTime.hour}:${event.startTime.minute}',),
            // trailing: IconButton(
            //     onPressed: () {
            //
            //     },
            //     icon: Icon(Icons.more_vert)
            // ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Image.network(event.displayImageUrl, fit: BoxFit.fill,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                            tag: event.displayImageUrl,
                            child: Image.network(event.displayImageUrl, fit: BoxFit.fill,)
                        )
                    );
                  },
                  loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text('Location: ${event.location}'),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ],
              )
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Attending: ${event.attending.length}', style: TextStyle(color: Colors.grey),),
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => InPersonEventDetailsScreen(event: event))
                      );
                    },
                    child: Text('details')
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}