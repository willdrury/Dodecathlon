import 'package:dodecathlon/models/quiz.dart';
import 'package:dodecathlon/models/quiz_question.dart';
import 'package:dodecathlon/screens/quiz_results_screen.dart';
import 'package:flutter/Material.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({
    super.key,
    required this.quiz,
    required this.question,
    required this.index,
  });

  final Quiz quiz;
  final QuizQuestion question;
  final int index;

  void onSubmit() {
    // TODO: Implement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question $index of ${quiz.questions.length}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(question.body),
            GridView.count(
              crossAxisCount: 2,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(question.answers[0]!),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(question.answers[1]!),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(question.answers[2]!),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(question.answers[3]!),
                )
              ],
            ),
            if (index < quiz.questions.length - 1)
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                    QuizQuestionScreen(quiz: quiz, question: question, index: index + 1,)
                  ));
                },
                child: Text('Next')
              ),
            if (index == quiz.questions.length - 1)
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                      QuizResultsScreen(quiz: quiz)
                  ));
                },
                child: Text('Submit')
            )
          ],
        ),
      ),
    );
  }
}