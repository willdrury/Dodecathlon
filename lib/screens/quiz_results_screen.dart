import 'package:dodecathlon/models/quiz.dart';
import 'package:flutter/Material.dart';

class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({
    required this.quiz,
    super.key,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Results:'),
          ],
        ),
      ),
    );
  }
}