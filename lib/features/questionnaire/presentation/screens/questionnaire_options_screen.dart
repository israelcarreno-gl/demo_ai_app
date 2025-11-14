import 'dart:io';

import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuestionnaireOptionsScreen extends StatefulWidget {
  const QuestionnaireOptionsScreen({
    required this.documentFile,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    super.key,
  });

  final File documentFile;
  final String fileName;
  final int fileSize;
  final String fileType;

  @override
  State<QuestionnaireOptionsScreen> createState() =>
      _QuestionnaireOptionsScreenState();
}

class _QuestionnaireOptionsScreenState
    extends State<QuestionnaireOptionsScreen> {
  QuestionType _selectedType = QuestionType.multiChoice;
  int _numberOfQuestions = 10;
  QuestionDifficulty _selectedDifficulty = QuestionDifficulty.medium;

  void _generateQuestionnaire() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to generate a questionnaire'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = QuestionnaireGenerationRequest(
      documentFile: widget.documentFile,
      documentName: widget.fileName,
      documentSize: widget.fileSize,
      documentType: widget.fileType,
      questionType: _selectedType,
      numberOfQuestions: _numberOfQuestions,
      difficulty: _selectedDifficulty,
      userId: authState.user.id,
    );

    // TODO(Isra): Send request to edge function
    // For now, just show the generated request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request ready: ${request.toJson()}'),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    // Navigate back to dashboard
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'New Questionnaire',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Select Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypeSelector(),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Number of Questions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_numberOfQuestions',
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF2563EB),
                        inactiveTrackColor: const Color(0xFF252932),
                        thumbColor: const Color(0xFF2563EB),
                        overlayColor: const Color(
                          0xFF2563EB,
                        ).withValues(alpha: 0.2),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(),
                      ),
                      child: Slider(
                        value: _numberOfQuestions.toDouble(),
                        min: 5,
                        max: 30,
                        divisions: 25,
                        onChanged: (value) {
                          setState(() {
                            _numberOfQuestions = value.round();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Difficulty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultySelector(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildTypeChip(label: 'Multi-Choice', type: QuestionType.multiChoice),
        _buildTypeChip(label: 'Single-Choice', type: QuestionType.singleChoice),
        _buildTypeChip(label: 'Argument', type: QuestionType.argument),
        _buildTypeChip(label: 'Random', type: QuestionType.random),
      ],
    );
  }

  Widget _buildTypeChip({required String label, required QuestionType type}) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF252932),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: [
        Expanded(
          child: _buildDifficultyButton(
            label: 'Easy',
            difficulty: QuestionDifficulty.easy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDifficultyButton(
            label: 'Medium',
            difficulty: QuestionDifficulty.medium,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDifficultyButton(
            label: 'Hard',
            difficulty: QuestionDifficulty.hard,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyButton({
    required String label,
    required QuestionDifficulty difficulty,
  }) {
    final isSelected = _selectedDifficulty == difficulty;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDifficulty = difficulty;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF252932),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF252932),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _generateQuestionnaire,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Generate Questionnaire',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
