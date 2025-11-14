import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.onPrimaryAction,
    this.secondaryButtonText,
    this.onSecondaryAction,
    this.isDangerous = false,
    super.key,
  });

  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryAction;
  final bool isDangerous;

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimaryAction,
    String? secondaryButtonText,
    VoidCallback? onSecondaryAction,
    bool isDangerous = false,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ConfirmationDialog(
          title: title,
          message: message,
          primaryButtonText: primaryButtonText,
          onPrimaryAction: onPrimaryAction,
          secondaryButtonText: secondaryButtonText,
          onSecondaryAction: onSecondaryAction,
          isDangerous: isDangerous,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

class _ConfirmationDialogState extends State<ConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handlePrimaryAction() {
    if (widget.isDangerous) {
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.onPrimaryAction();
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      widget.onPrimaryAction();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value * 0.5, 0),
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF252932),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.isDangerous
                        ? Colors.red.withValues(alpha: 0.2)
                        : const Color(0xFF2563EB).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isDangerous
                        ? Icons.warning_rounded
                        : Icons.help_outline_rounded,
                    color: widget.isDangerous
                        ? Colors.red
                        : const Color(0xFF2563EB),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (widget.secondaryButtonText != null) ...[
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              widget.onSecondaryAction?.call();
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(
                                color: Colors.grey[700]!,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              widget.secondaryButtonText!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handlePrimaryAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isDangerous
                                ? Colors.red
                                : const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.primaryButtonText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
