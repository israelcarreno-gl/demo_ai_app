import 'dart:async';

import 'package:demoai/features/questionnaire/data/models/question_model.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_bloc.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_event.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuestionnaireResponseScreen extends StatefulWidget {
  const QuestionnaireResponseScreen({required this.questionnaire, super.key});
  final QuestionnaireModel questionnaire;

  @override
  State<QuestionnaireResponseScreen> createState() =>
      _QuestionnaireResponseScreenState();
}

class _QuestionnaireResponseScreenState
    extends State<QuestionnaireResponseScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  @override
  void initState() {
    super.initState();
    // Start the questionnaire when screen is initialized
    context.read<QuestionnaireResponseBloc>().add(
      StartQuestionnaire(widget.questionnaire),
    );
    // Start a periodic timer to update elapsed seconds for UI
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final state = context.read<QuestionnaireResponseBloc>().state;
      if (state is QuestionnaireResponseInProgress) {
        final startedAt = state.startedAt;
        final elapsed = DateTime.now().difference(startedAt).inSeconds;
        setState(() {
          _elapsedSeconds = elapsed;
        });
      }
    });
  }

  String _formatDuration(int elapsedSeconds) {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      body: SafeArea(
        child: BlocConsumer<QuestionnaireResponseBloc, QuestionnaireResponseState>(
          listener: (context, state) {
            if (state is QuestionnaireResponseError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is QuestionnaireResponseSubmitted) {
              // Navigate to result screen (replace current route)
              GoRouter.of(context).goNamed(
                'questionnaireResult',
                extra: {
                  'correctCount': state.correctCount,
                  'totalLocal': state.totalLocal,
                  'perQuestionCorrect': state.perQuestionCorrect,
                  'questionnaire': state.questionnaire,
                },
              );
            }
          },
          builder: (context, state) {
            if (state is QuestionnaireResponseInProgress) {
              final q = state.questionnaire;
              final questions = q.questions ?? [];
              final currentIndex = state.currentIndex;
              final currentQuestion = questions[currentIndex];
              final QuestionResponse? currentResponse =
                  state.responses[currentQuestion.id];
              return Column(
                children: [
                  AppBar(
                    backgroundColor: const Color(0xFF0F1720),
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Center(
                        child: Text(
                          _formatDuration(_elapsedSeconds),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    title: const Text('Questionnaire'),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => GoRouter.of(context).goNamed('home'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: LinearProgressIndicator(
                      value: state.progress,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF2563EB),
                      minHeight: 6,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${currentIndex + 1} of ${questions.length}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentQuestion.questionText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (currentQuestion.questionType == 'multi_choice')
                            _buildMultiChoice(currentQuestion, currentResponse),
                          if (currentQuestion.questionType == 'single_choice')
                            _buildSingleChoice(
                              currentQuestion,
                              currentResponse,
                            ),
                          if (currentQuestion.questionType == 'argument')
                            _buildArgument(currentQuestion, currentResponse),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomNavigation(state, questions.length),
                ],
              );
            }
            if (state is QuestionnaireResponseSubmitted) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }

  Widget _buildMultiChoice(QuestionModel question, QuestionResponse? response) {
    final options = question.options ?? [];
    final selected = response?.selectedOptionIndices ?? <int>[];
    final screenWidth = MediaQuery.of(context).size.width;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.asMap().entries.map((entry) {
        final idx = entry.key;
        final label = entry.value;
        final isSelected = selected.contains(idx);
        return InkWell(
          onTap: () {
            final newSelected = List<int>.from(selected);
            if (isSelected) {
              newSelected.remove(idx);
            } else {
              newSelected.add(idx);
            }
            context.read<QuestionnaireResponseBloc>().add(
              AnswerSelected(
                questionId: question.id,
                selectedIndices: newSelected,
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Prevent a single option from expanding beyond the screen width
              maxWidth: screenWidth - 64,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF15202B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (isSelected)
                    const Icon(Icons.check, color: Colors.white, size: 16)
                  else
                    const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  // Allow the label to wrap and not overflow horizontally
                  Flexible(
                    child: Text(
                      label,
                      softWrap: true,
                      // Allow the label to expand vertically to show full content
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChoice(
    QuestionModel question,
    QuestionResponse? response,
  ) {
    final options = question.options ?? [];
    final selectedList = response?.selectedOptionIndices;
    final selected = (selectedList != null && selectedList.isNotEmpty)
        ? selectedList.first
        : -1;

    return Column(
      children: options.asMap().entries.map((entry) {
        final idx = entry.key;
        final label = entry.value;
        final isSelected = idx == selected;
        return ListTile(
          onTap: () {
            context.read<QuestionnaireResponseBloc>().add(
              AnswerSelected(questionId: question.id, selectedIndices: [idx]),
            );
          },
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              border: Border.all(
                color: isSelected ? const Color(0xFF2563EB) : Colors.white24,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          title: Text(
            label,
            softWrap: true,
            style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildArgument(QuestionModel question, QuestionResponse? response) {
    final controller = TextEditingController(text: response?.answerText ?? '');
    // Leave validation TODO (AI validation)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: 6,
          minLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type your response here... (TODO: Validate with AI)',
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: const Color(0xFF10151A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) => context.read<QuestionnaireResponseBloc>().add(
            AnswerSelected(questionId: question.id, answerText: value),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(
    QuestionnaireResponseInProgress state,
    int total,
  ) {
    final currentIndex = state.currentIndex;
    final questions = state.questionnaire.questions ?? [];
    final currentQuestion = questions[currentIndex];
    final QuestionResponse? currentResponse =
        state.responses[currentQuestion.id];
    final bool isAnswered = () {
      if (currentResponse == null) return false;
      if (currentQuestion.questionType == 'argument') {
        return (currentResponse.answerText ?? '').trim().isNotEmpty;
      }
      return currentResponse.selectedOptionIndices != null &&
          currentResponse.selectedOptionIndices!.isNotEmpty;
    }();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0F14),
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: currentIndex > 0
                  ? () => context.read<QuestionnaireResponseBloc>().add(
                      const PreviousQuestionRequested(),
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10151A),
              ),
              child: const Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isAnswered
                  ? () {
                      if (currentIndex == total - 1) {
                        // Submit
                        context.read<QuestionnaireResponseBloc>().add(
                          const SubmitResponsesRequested(),
                        );
                      } else {
                        context.read<QuestionnaireResponseBloc>().add(
                          const NextQuestionRequested(),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnswered
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF1E293B),
              ),
              child: Text(
                currentIndex == total - 1 ? 'Submit' : 'Next',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
