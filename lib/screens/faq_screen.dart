import 'package:dodecathlon/widgets/faq_list_tile.dart';
import 'package:flutter/material.dart';

import '../data/FAQs.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQs'),
        ),
        body: ListView.builder(
            itemCount: faqs.length,
            itemBuilder: (ctx, i) {
              return FaqListTile(faq: faqs[i]);
            })
    );
  }
}