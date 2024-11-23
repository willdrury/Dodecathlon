import 'package:dodecathlon/models/faq_item.dart';
import 'package:dodecathlon/screens/faq_details_screen.dart';
import 'package:dodecathlon/screens/notification_details_screen.dart';
import 'package:flutter/material.dart';


class FaqListTile extends StatelessWidget {
  FaqListTile({super.key, required this.faq});

  FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(faq.title, style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(faq.body, overflow: TextOverflow.ellipsis,),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => FaqDetailsScreen(faq: faq,))
        );
      },
      trailing: Icon(Icons.chevron_right),
    );
  }
}