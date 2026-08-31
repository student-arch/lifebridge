import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class CaseCreatedScreen extends StatelessWidget {
  const CaseCreatedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: LbColors.accent, size: 36),
              ),
              const SizedBox(height: 24),
              const LbH1('Case created.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We're analyzing your information now.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(s.mainCase.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                        const LbBadge(label: 'Active', variant: BadgeVariant.submitted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Case #${s.mainCase.id.toUpperCase()}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 12),
                    const LbProgress(value: 0.18),
                    const SizedBox(height: 6),
                    const Text('Analysis in progress · usually 30–60 seconds', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHAT'S HAPPENING"),
                    SizedBox(height: 12),
                    _StepRow(text: 'Reviewing your treatment and financial details', done: false, inProgress: true),
                    SizedBox(height: 10),
                    _StepRow(text: 'Matching against 124 programs', done: false, inProgress: true),
                    SizedBox(height: 10),
                    _StepRow(text: 'Suggesting documents you may need', done: false, inProgress: false),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'View analysis', onTap: () => Navigator.pushNamed(context, '/ai/analysis')),
              const SizedBox(height: 8),
              LbButton(
                label: 'Back to home',
                variant: LbButtonVariant.ghost,
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String text;
  final bool done;
  final bool inProgress;
  const _StepRow({required this.text, required this.done, required this.inProgress});
  @override
  Widget build(BuildContext context) {
    Color dotColor;
    if (done) {
      dotColor = LbColors.success;
    } else if (inProgress) {
      dotColor = LbColors.accent;
    } else {
      dotColor = LbColors.border;
    }
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 13, color: inProgress || done ? LbColors.fg : LbColors.muted)),
        ),
      ],
    );
  }
}
