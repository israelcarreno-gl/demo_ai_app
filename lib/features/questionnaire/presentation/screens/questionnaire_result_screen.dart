import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionnaireResultScreen extends StatelessWidget {
  const QuestionnaireResultScreen({
    required this.questionnaire,
    required this.correctCount,
    required this.totalLocal,
    required this.perQuestionCorrect,
    required this.responses,
    super.key,
  });
  final QuestionnaireModel? questionnaire;
  final int correctCount;
  final int totalLocal;
  final Map<String, bool> perQuestionCorrect;
  final Map<String, QuestionResponse> responses;

  @override
  Widget build(BuildContext context) {
    final totalQuestions = questionnaire?.questions?.length ?? totalLocal;
    final percentage = (questionnaire?.accuracy != null)
        ? questionnaire!.accuracy!.clamp(0.0, 100.0)
        : (totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        elevation: 0,
        centerTitle: true,
        title: const Text('Results'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Big circular percentage indicator
                Center(
                  child: SizedBox(
                    height: 220,
                    width: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 14,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF7C9BFF),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Overall Score',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Metric cards
                _buildMetricCard(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Correct',
                  value: '$correctCount / $totalQuestions',
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  context,
                  icon: Icons.timer_outlined,
                  label: 'Time',
                  value: questionnaire?.completionTime != null
                      ? _formatElapsed(questionnaire!.completionTime!)
                      : '-',
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  context,
                  icon: Icons.adjust_outlined,
                  label: 'Accuracy',
                  value: '${percentage.toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 12),
                // Try Again and Done actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (questionnaire != null) {
                            GoRouter.of(context).goNamed(
                              'questionnaireResponse',
                              extra: questionnaire,
                            );
                          } else {
                            GoRouter.of(context).goNamed('home');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          backgroundColor: const Color(0xFF0F1720),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'TRY AGAIN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => GoRouter.of(context).goNamed('home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'DONE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Question breakdown header
                const SizedBox(height: 6),
                const Text(
                  'Question Breakdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: perQuestionCorrect.entries.map((entry) {
                    final isCorrect = entry.value;
                    String title = 'Question';
                    String answerText = '-';
                    if (questionnaire?.questions != null) {
                      for (final q in questionnaire!.questions!) {
                        if (q.id == entry.key) {
                          title = q.questionText;
                          final resp = responses[entry.key];
                          if (resp != null) {
                            if (q.questionType == 'argument') {
                              answerText = resp.answerText ?? '-';
                            } else {
                              final sel = resp.selectedOptionIndices ?? [];
                              if (sel.isNotEmpty) {
                                final labels = sel.map((i) {
                                  if (q.options != null &&
                                      i < q.options!.length) {
                                    return q.options![i];
                                  }
                                  // Fallback: show letter for index
                                  return String.fromCharCode(
                                    'A'.codeUnitAt(0) + i,
                                  );
                                }).toList();
                                answerText = labels.join(', ');
                              } else {
                                answerText = '-';
                              }
                            }
                          }
                          break;
                        }
                      }
                    }
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10151A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? const Color(0xFF062C14)
                                  : const Color(0xFF2C0B0B),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  answerText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF10151A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF10151A),
            radius: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2563EB)),
              ),
              child: Center(
                child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // gauge helper removed -- using inline layout in build

  // old stat helper removed -- using _buildMetricCard

  String _formatElapsed(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) return '${minutes}m ${secs}s';
    return '${secs}s';
  }
}
