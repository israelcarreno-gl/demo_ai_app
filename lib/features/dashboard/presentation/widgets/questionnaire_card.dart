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
                          'Estimated: ${_formatMinutes(questionnaire.estimatedTime!)}',
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(height: 8),
                    _AccuracyBadge(accuracy: questionnaire.accuracy),
                  ],
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

  String _formatMinutes(int minutes) {
    if (minutes <= 0) return '0m';
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }
}

class _AccuracyBadge extends StatelessWidget {
  const _AccuracyBadge({this.accuracy});
  final double? accuracy;

  Color _badgeColor(double? pct) {
    if (pct == null) return const Color(0xFF64748B); // grey
    if (pct >= 90) return const Color(0xFF16A34A); // green
    if (pct >= 75) return const Color(0xFFB45309); // amber/brown
    if (pct >= 50) return const Color(0xFFF59E0B); // orange-ish for 50-75
    return const Color(0xFFEF4444); // red
  }

  @override
  Widget build(BuildContext context) {
    final pct = accuracy?.round();
    final color = _badgeColor(pct?.toDouble());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: 14, color: color),
          const SizedBox(width: 8),
          Text(
            pct != null ? '$pct%' : '-',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
