import '../../data/mock_data.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class AIAnalysisScreen extends StatefulWidget {
  const AIAnalysisScreen({super.key});
  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/ai/results');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const LbSpinner(size: 56, color: LbColors.accent),
              ),
              const SizedBox(height: 24),
              const LbH1('Analyzing your case…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We're comparing your situation with 124 verified programs.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 32),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbProcessingRow(text: 'Treatment details understood', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Financial picture mapped', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Documents catalogued', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Matching support programs…', done: false, spinner: true),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: LbBody("AI assists with suggestions. You stay in control.", color: LbColors.muted, size: 12, align: TextAlign.center),
              ),
              const SizedBox(height: 16),
              LbButton(label: 'View analysis', onTap: () => Navigator.pushReplacementNamed(context, '/ai/results')),
            ],
          ),
        ),
      ),
    );
  }
}

class AIResultsScreen extends StatelessWidget {
  const AIResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('ANALYSIS · JUST NOW'),
                ],
              ),
              const SizedBox(height: 16),
              const LbAIBubble(
                title: 'LifeBridge AI',
                message: "Here's what I found for Arjun's case.\n\nBased on the treatment plan, income, and location you shared. I picked the most likely matches — not a guarantee.",
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: LbStatCard(label: 'PROGRAMS', value: '5', caption: 'matched')),
                  SizedBox(width: 12),
                  Expanded(child: LbStatCard(label: 'POSSIBLE', value: '₹3.2L', caption: 'in aid')),
                ],
              ),
              const SizedBox(height: 16),
              const LbEyebrow('IDENTIFIED NEEDS'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: const [
                    _NeedRow(title: 'Hospital financial assistance'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _NeedRow(title: 'Treatment funding gap'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _NeedRow(title: 'Community medical support'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'Missing information.',
                body: '2 documents would unlock more matches.',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LbEyebrow('NEXT BEST ACTION'),
                    SizedBox(height: 6),
                    Text('Upload income certificate', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('3 of 5 matches require proof of income. Adding it now could double your eligible support.', style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'View support matches', onTap: () => Navigator.pushNamed(context, '/support/matches')),
              const SizedBox(height: 8),
              LbButton(label: 'Upload missing documents', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/docs/missing')),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedRow extends StatelessWidget {
  final String title;
  const _NeedRow({required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/ai/needs'),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(right: 12), child: LbDot(color: LbColors.accent)),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class AINeedsScreen extends StatelessWidget {
  const AINeedsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('NEEDS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('What I see you need.'),
              const SizedBox(height: 8),
              LbBody('AI identified these from your case details.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < MockData.aiNeeds.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _NeedDetailRow(icon: _iconFor(MockData.aiNeeds[i].icon), title: MockData.aiNeeds[i].title, description: MockData.aiNeeds[i].description),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'See recommended programs', onTap: () => Navigator.pushNamed(context, '/ai/recommended-support')),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'home': return Icons.home_outlined;
      case 'card': return Icons.credit_card;
      case 'plus_circle': return Icons.add_circle_outline;
      case 'plus': return Icons.add;
      default: return Icons.circle_outlined;
    }
  }
}

class _NeedDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _NeedDetailRow({required this.icon, required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LbIconTile(icon: icon, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AIRecommendedSupportScreen extends StatelessWidget {
  const AIRecommendedSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  LbEyebrow('${s.supportPrograms.length} PROGRAMS FOUND'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Potential support programs.'),
              const SizedBox(height: 8),
              LbBody('Sorted by how well they fit your situation. Eligibility still needs to be confirmed.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final p in s.supportPrograms) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/support/detail'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('${p.amountLabel} · ${p.organization}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      LbPill(label: '${p.matchPercent}%', variant: p.pillVariant),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/ai/recommended-docs')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/support/matches'),
                  child: const Text('Skip ahead to all matches', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AIRecommendedDocsScreen extends StatelessWidget {
  const AIRecommendedDocsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('DOCUMENT PLAN'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Documents to add.'),
              const SizedBox(height: 8),
              LbBody('Each one is asked for by at least one program you matched.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final d in MockData.aiRecommendedDocs) ...[
                _DocPlanRow(doc: d),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              LbButton(label: 'Upload missing documents', onTap: () => Navigator.pushNamed(context, '/docs/missing')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ai/next-steps'),
                  child: const Text('See recommended next steps', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocPlanRow extends StatelessWidget {
  final dynamic doc;
  const _DocPlanRow({required this.doc});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: doc.uploaded ? LbColors.successBg : LbColors.warnBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              doc.uploaded ? Icons.check : Icons.description_outlined,
              color: doc.uploaded ? LbColors.emerald : LbColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  doc.meta,
                  style: TextStyle(fontSize: 12, color: doc.uploaded ? LbColors.emerald : LbColors.muted),
                ),
              ],
            ),
          ),
          if (!doc.uploaded)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/docs/upload'),
              child: const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class AINextStepsScreen extends StatelessWidget {
  const AINextStepsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final steps = const [
      ('Upload income certificate', 'Likely unlocks 3 additional programs. Highest-impact next move.'),
      ('Apply to Heart Care Trust', "Highest match score. I'll prepare the draft when you're ready."),
      ('Confirm insurance pre-auth', 'Call Star Health · approval may reduce your funding gap.'),
      ('Prepare Apollo Charity Care application', 'Hospital-side discount; needs cost breakdown doc.'),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('SUGGESTED PLAN'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('A suggested path forward.'),
              const SizedBox(height: 8),
              LbBody('A practical sequence. You can do these in any order.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < steps.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _StepRow(n: i + 1, title: steps[i].$1, description: steps[i].$2, muted: i == 3),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Start with step 1', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int n;
  final String title;
  final String description;
  final bool muted;
  const _StepRow({required this.n, required this.title, required this.description, this.muted = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: muted ? LbColors.surface : LbColors.accent,
              borderRadius: BorderRadius.circular(12),
              border: muted ? Border.all(color: LbColors.border) : null,
            ),
            alignment: Alignment.center,
            child: Text('$n', style: TextStyle(color: muted ? LbColors.muted : LbColors.surface, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: muted ? LbColors.muted : LbColors.fg)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: muted ? LbColors.muted : LbColors.fg2, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
