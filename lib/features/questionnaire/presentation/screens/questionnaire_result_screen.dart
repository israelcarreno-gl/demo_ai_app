import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:demoai/core/router/app_router.dart';

class QuestionnaireResultScreen extends StatelessWidget {
  const QuestionnaireResultScreen({
    required this.questionnaire,
    required this.correctCount,
    required this.totalLocal,
    required this.perQuestionCorrect,
    super.key,
  });
  final QuestionnaireModel? questionnaire;
  final int correctCount;
  final int totalLocal;
  final Map<String, bool> perQuestionCorrect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        elevation: 0,
        title: const Text('Results'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Score',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                '$correctCount / $totalLocal',
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Question Breakdown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: perQuestionCorrect.entries.map((e) {
                    final isCorrect = e.value;
                    String title = e.key;
                    if (questionnaire?.questions != null) {
                      for (final q in questionnaire!.questions!) {
                        if (q.id == e.key) {
                          title = q.questionText;
                          break;
                        }
                      }
                    }
                    return ListTile(
                      trailing: Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (questionnaire != null) {
                          // Retry: navigate to questionnaireResponse with the questionnaire extra
                          GoRouter.of(context).goNamed(
                            'questionnaireResponse',
                            extra: questionnaire,
                          );
                        } else {
                          GoRouter.of(context).goNamed('home');
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => GoRouter.of(context).goNamed('home'),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
