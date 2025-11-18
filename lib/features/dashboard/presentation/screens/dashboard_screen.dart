import 'package:demoai/core/di/injection_container.dart';
import 'package:demoai/core/router/app_router.dart';
import 'package:demoai/core/widgets/confirmation_dialog.dart';
import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demoai/features/dashboard/presentation/widgets/activity_section.dart';
import 'package:demoai/features/dashboard/presentation/widgets/questionnaire_card.dart';
import 'package:demoai/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D24),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            _buildAssessmentsTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Screen',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // removed: total questions/time estimate cards - now shown in the bottom sheet
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF252932),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle_outline,
                  iconColor: Color(0xFF8B5CF6),
                  label: 'Completed',
                  value: '12',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.trending_up,
                  iconColor: Color(0xFF10B981),
                  label: 'Average Score',
                  value: '86%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ActivitySection(
            icon: Icons.access_time,
            iconColor: Color(0xFF8B5CF6),
            title: 'Last Activity',
            value: 'Yesterday',
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Start New Assessment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let AI generate a questionnaire from your file.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(AppRoutes.documentUpload);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Choose File',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentsTab() {
    return BlocProvider(
      create: (context) => getIt<QuestionnaireBloc>(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<QuestionnaireBloc>();
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            if (bloc.state is QuestionnaireInitial) {
              bloc.add(GetUserQuestionnairesRequested(authState.user.id));
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
              builder: (context, state) {
                if (state is QuestionnaireLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is QuestionnaireError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is QuestionnaireListLoaded) {
                  final questionnaires = state.questionnaires;
                  if (questionnaires.isEmpty) {
                    return const Center(
                      child: Text(
                        'No assessments yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is Authenticated) {
                        bloc.add(
                          GetUserQuestionnairesRequested(authState.user.id),
                        );
                        // Wait for loading state to change; very small wait to allow bloc to process
                        await Future.delayed(const Duration(milliseconds: 300));
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: questionnaires.length,
                      itemBuilder: (context, index) {
                        final q = questionnaires[index];
                        return QuestionnaireCard(
                          questionnaire: q,
                          onTap: () => _showQuestionnaireSummary(context, q),
                          onTryAgain: () => GoRouter.of(
                            context,
                          ).goNamed('questionnaireResponse', extra: q),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Assessments',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showQuestionnaireSummary(BuildContext context, QuestionnaireModel q) {
    final questions = q.questions ?? [];
    final total = questions.length;
    final Map<String, int> typesCount = {};
    final Map<String, int> difficultyCount = {};
    for (final qq in questions) {
      typesCount[qq.questionType] = (typesCount[qq.questionType] ?? 0) + 1;
      difficultyCount[qq.difficulty] =
          (difficultyCount[qq.difficulty] ?? 0) + 1;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F1720),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (q.summary != null) ...[
                    const Text(
                      'AI Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.summary!,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (q.documentName != null) ...[
                    const Text(
                      'Source Files',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              'documentPreview',
                              extra: {
                                'documentPath':
                                    q.documentPath ??
                                    '${q.userId}/${q.documentName!}',
                                'documentType': q.documentType,
                                'documentName': q.documentName,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  q.documentType != null &&
                                          q.documentType!.contains('pdf')
                                      ? Icons.picture_as_pdf
                                      : Icons.image,
                                  color: const Color(0xFF2563EB),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    q.documentName!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Cards row: Total Questions + Time Estimate
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Questions',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$total',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time Estimate',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                q.estimatedTime != null
                                    ? '${q.estimatedTime} mins'
                                    : '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 'Questions' moved to Total Questions card above
                  const SizedBox(height: 12),
                  const Text(
                    'Question Breakdown',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10151A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: typesCount.entries.map((e) {
                        final typeKey = e.key.replaceAll('_', ' ');
                        IconData iconData;
                        switch (e.key) {
                          case 'multi_choice':
                            iconData = Icons.list_alt;
                          case 'single_choice':
                            iconData = Icons.radio_button_checked;
                          case 'argument':
                            iconData = Icons.edit;
                          default:
                            iconData = Icons.question_answer;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(iconData, color: const Color(0xFF2563EB)),
                              const SizedBox(width: 12),
                              Text(
                                typeKey,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const Spacer(),
                              Text(
                                '${e.value}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Difficulty:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...difficultyCount.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${e.key}: ${e.value}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => GoRouter.of(
                        context,
                      ).goNamed('questionnaireResponse', extra: q),
                      child: const Text('Start/Retry'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userEmail = state is Authenticated ? state.user.email : 'User';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2563EB), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.person, size: 48, color: Color(0xFF2563EB)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildProfileOption(
                icon: Icons.logout,
                title: 'Sign Out',
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  ConfirmationDialog.show(
                    context: context,
                    title: 'Sign Out',
                    message: 'Are you sure you want to sign out?',
                    primaryButtonText: 'Sign Out',
                    secondaryButtonText: 'Cancel',
                    isDangerous: true,
                    onPrimaryAction: () {
                      context.read<AuthBloc>().add(AuthSignOutRequested());
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252932),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.grey[400]),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNav() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF252932),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.assignment_outlined,
                selectedIcon: Icons.assignment,
                label: 'Assessments',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
