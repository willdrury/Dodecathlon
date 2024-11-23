import 'package:dodecathlon/models/faq_item.dart';
import 'package:flutter/material.dart';

class FaqDetailsScreen extends StatelessWidget {
  const FaqDetailsScreen({super.key, required this.faq});

  final FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faq.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              Text(faq.body),
            ]
        ),
      ),
    );
  }
}