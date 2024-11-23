import 'package:dodecathlon/models/faq_item.dart';

FaqItem scoring = FaqItem(
    title: 'How does scoring work?',
    body: 'Uh, it\'s complicated...'
);

FaqItem rankings = FaqItem(
    title: 'How do the rankings work?',
    body: 'Uh, it\'s complicated...'
);

FaqItem friends = FaqItem(
    title: 'How do I make friends?',
    body: 'Great question. If you find out, please tell me.'
);

FaqItem privacy = FaqItem(
    title: 'What about privacy',
    body: 'Don\'t worry about it!'
);

FaqItem aiFeatures = FaqItem(
    title: 'Do you have AI?',
    body: 'No. Stop asking'
);

List<FaqItem> faqs = [
  scoring,
  rankings,
  friends,
  privacy,
  aiFeatures
];