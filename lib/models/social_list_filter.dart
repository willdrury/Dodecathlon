import 'package:dodecathlon/models/post.dart';

class SocialListFilter {
  String title;
  bool isActive;
  Function(List<Post>) onApply;

  SocialListFilter({
    required this.title,
    required this.isActive,
    required this.onApply,
  });
}