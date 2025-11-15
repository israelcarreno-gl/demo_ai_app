import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionnaireCard extends StatelessWidget {
  const QuestionnaireCard({
    required this.questionnaire,
    required this.onTap,
    required this.onTryAgain,
    super.key,
  });

  final QuestionnaireModel questionnaire;
  final VoidCallback onTap;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final updatedAt = questionnaire.updatedAt;
    final dateText = updatedAt != null
        ? DateFormat.yMMMd().format(updatedAt)
        : 'Unknown';

    // Determine status colors
    final status = questionnaire.status;
    Color statusColor;
    switch (status) {
      case 'completed':
        statusColor = Colors.green;
      case 'processing':
        statusColor = Colors.amber;
      default:
        statusColor = Colors.blueGrey;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF10151A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionnaire.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Completed: $dateText',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      if (questionnaire.estimatedTime != null)
                        Text(
                          'Estimated: ${_formatSeconds(questionnaire.estimatedTime!)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      if (questionnaire.summary != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          questionnaire.summary!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${status[0].toUpperCase()}${status.substring(1)}',
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onTryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Try Again', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    if (seconds <= 0) return '0m';
    final minutes = seconds ~/ 60;
    return '${minutes}m ${seconds % 60}s';
  }
}
