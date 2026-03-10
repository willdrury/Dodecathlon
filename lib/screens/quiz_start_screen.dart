import 'package:dodecathlon/models/quiz.dart';
import 'package:dodecathlon/models/quiz_question.dart';
import 'package:dodecathlon/providers/quiz_question_provider.dart';
import 'package:dodecathlon/screens/quiz_question_screen.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizStartScreen extends ConsumerWidget {
  const QuizStartScreen({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<QuizQuestion>> questionStream = ref.watch(quizQuestionProvider);

    if (!questionStream.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    List<QuizQuestion> questions = questionStream.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(quiz.description),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                  QuizQuestionScreen(quiz: quiz, question: questions[0], index: 0)
                ));
              },
              child: Text('Begin')
            )
          ],
        ),
      ),
    );
  }
}