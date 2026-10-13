import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class SupportSourcesScreen extends StatefulWidget {
  const SupportSourcesScreen({super.key});
  @override
  State<SupportSourcesScreen> createState() => _SupportSourcesScreenState();
}

class _SupportSourcesScreenState extends State<SupportSourcesScreen> {
  String _filter = 'All';
  final _filters = const ['All', 'Hospital', 'NGO', 'Government', 'Crowdfunding', 'Pharma'];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final byCat = <String, List<dynamic>>{};
    for (final p in s.supportPrograms) {
      if (_filter != 'All' && p.category != _filter) continue;
      if (_query.isNotEmpty && !p.name.toLowerCase().contains(_query.toLowerCase()) && !p.organization.toLowerCase().contains(_query.toLowerCase())) continue;
      byCat.putIfAbsent(p.category, () => []).add(p);
    }
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
                  const LbEyebrow('BROWSE ALL'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Support sources'),
              const SizedBox(height: 8),
              LbBody('Browse verified programs across categories.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbSearch(
                hint: 'Search programs or organizations',
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in _filters) ...[
                      GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: LbPill(label: f.toUpperCase(), variant: _filter == f ? PillVariant.accent : PillVariant.neutral),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final entry in byCat.entries) ...[
                LbEyebrow(entry.key.toUpperCase()),
                const SizedBox(height: 8),
                for (final p in entry.value) ...[
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
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SupportMatchesScreen extends StatelessWidget {
  const SupportMatchesScreen({super.key});
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
                  LbEyebrow('${s.supportPrograms.length} MATCHES'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Best matches for Ramakrishna.'),
              const SizedBox(height: 8),
              LbBody('Sorted by relevance. Tap any program to see details.', color: LbColors.muted),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    LbPill(label: 'ALL · 5', variant: PillVariant.accent),
                    SizedBox(width: 8),
                    LbPill(label: 'LIKELY MATCH', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'NEEDS REVIEW', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'BY DEADLINE', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final p in s.supportPrograms) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/support/detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                          LbPill(label: '${p.matchPercent}%', variant: p.pillVariant),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(p.organization, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 8),
                      Text(p.description, style: const TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          LbPill(label: 'VERIFIED', variant: PillVariant.success, icon: Icons.check),
                          const SizedBox(width: 8),
                          Text('${p.documentsNeeded} docs needed', style: const TextStyle(fontSize: 11, color: LbColors.muted)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SupportSourceDetailScreen extends StatelessWidget {
  const SupportSourceDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final p = s.supportPrograms.first;
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
                  const LbEyebrow('PROGRAM DETAIL'),
                ],
              ),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const LbIconTile(icon: Icons.handshake_outlined, size: 48, iconSize: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                              const SizedBox(height: 2),
                              Text('${p.organization} · Verified ${p.verifiedDate}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                            ],
                          ),
                        ),
                        LbPill(label: '${p.matchPercent}%', variant: p.pillVariant),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(p.description, style: const TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: LbStatCard(label: 'BENEFIT', value: p.amountLabel.replaceAll('Up to ', ''), caption: 'Maximum aid')),
                  const SizedBox(width: 12),
                  Expanded(child: LbStatCard(label: 'DEADLINE', value: '15d', caption: 'rolling')),
                ],
              ),
              const SizedBox(height: 16),
              const LbEyebrow('ELIGIBILITY QUICK CHECK'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < p.eligibility.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _EligibilityRow(text: p.eligibility[i], warn: i == p.eligibility.length - 1),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/support/why'),
                child: const Row(
                  children: [
                    Expanded(child: Text('Why this was recommended', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/support/verification'),
                child: const Row(
                  children: [
                    Expanded(child: Text('Verification status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Check my eligibility', onTap: () => Navigator.pushNamed(context, '/support/eligibility')),
              const SizedBox(height: 8),
              LbButton(label: 'Prepare application', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  final String text;
  final bool warn;
  const _EligibilityRow({required this.text, this.warn = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: warn ? LbColors.warnBg : LbColors.successBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(warn ? Icons.help_outline : Icons.check, color: warn ? LbColors.warn : LbColors.emerald, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class WhyThisMatchScreen extends StatelessWidget {
  const WhyThisMatchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final reasons = const [
      ('Matches your treatment type', 'Cardiac-specific fund. They focus on procedures like the one Ramakrishna needs.'),
      ('Income within their range', 'Household income ₹6.4L is below their ₹8L threshold.'),
      ('Verified by LifeBridge', 'We contacted Heart Care Trust on 12 March 2026 and confirmed active intake.'),
      ('Treatment date fits their window', 'Applications close 7 days before procedure. You have time.'),
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
                  const LbEyebrow('REASONING'),
                ],
              ),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'Why this match',
                message: 'Heart Care Trust fits your case well because of four reasons below. None of this is a guarantee — the trust still reviews every application.',
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < reasons.length; i++) ...[
                LbCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text('${i + 1}', style: const TextStyle(color: LbColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reasons[i].$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(reasons[i].$2, style: const TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbBody('LifeBridge does not guarantee approval. The trust reviews each application independently.', color: LbColors.muted, size: 12, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Back to program', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class EligibilityCheckScreen extends StatefulWidget {
  const EligibilityCheckScreen({super.key});
  @override
  State<EligibilityCheckScreen> createState() => _EligibilityCheckScreenState();
}

class _EligibilityCheckScreenState extends State<EligibilityCheckScreen> {
  int _sel = 0;
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
                  const LbEyebrow('ELIGIBILITY'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Quick eligibility check.'),
              const SizedBox(height: 8),
              LbBody("Six short questions. Saves you time if you don't qualify.", color: LbColors.muted),
              const SizedBox(height: 16),
              Row(
                children: List.generate(6, (i) {
                  Color c = i < 2 ? LbColors.accent : LbColors.borderSoft;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i == 5 ? 0 : 6),
                      height: 4,
                      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              LbMeta('QUESTION 3 OF 6'),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Is the patient a resident of Andhra Pradesh?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3)),
                    const SizedBox(height: 16),
                    for (int i = 0; i < 3; i++) ...[
                      LbChoice(
                        title: const ['Yes', "No, but seeking treatment there", 'No'][i],
                        selected: _sel == i,
                        onTap: () => setState(() => _sel = i),
                      ),
                      if (i < 2) const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'Your answers stay private and are only used for this eligibility check.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/support/eligibility-processing')),
            ],
          ),
        ),
      ),
    );
  }
}

class EligibilityProcessingScreen extends StatefulWidget {
  const EligibilityProcessingScreen({super.key});
  @override
  State<EligibilityProcessingScreen> createState() => _EligibilityProcessingScreenState();
}

class _EligibilityProcessingScreenState extends State<EligibilityProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/support/eligibility-result');
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const LbSpinner(size: 48, color: LbColors.accent),
              ),
              const SizedBox(height: 24),
              const LbH1('Checking your eligibility…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Comparing your answers with Heart Care Trust's criteria.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbProcessingRow(text: 'Residency confirmed', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Income range matches', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Verifying treatment plan…', done: false, spinner: true),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Final review', done: false, spinner: false),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'View result', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushReplacementNamed(context, '/support/eligibility-result')),
            ],
          ),
        ),
      ),
    );
  }
}

class EligibilityResultScreen extends StatelessWidget {
  const EligibilityResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: LbColors.emerald, size: 32),
              ),
              const SizedBox(height: 20),
              const LbH1('Likely eligible', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody('Based on your answers, you meet most requirements.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 20),
              LbInfoBanner(
                title: 'Reminder.',
                body: 'Eligibility is determined by the trust, not LifeBridge. We can\'t guarantee approval.',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 20),
              const LbEyebrow('REQUIREMENTS CHECK'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _ResultRow(text: 'Resident of Andhra Pradesh', warn: false),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _ResultRow(text: 'Cardiac procedure planned', warn: false),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _ResultRow(text: 'Income < ₹8L', warn: false),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _ResultRow(text: "Aadhaar verified (you'll need to upload it)", warn: true),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/support/required-docs'),
                child: const Row(
                  children: [
                    LbIconSquare(icon: Icons.description_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 36, iconSize: 18, radius: 10),
                    SizedBox(width: 12),
                    Expanded(child: Text('See required documents (3)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Start my application', onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String text;
  final bool warn;
  const _ResultRow({required this.text, this.warn = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: warn ? LbColors.warnBg : LbColors.successBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(warn ? Icons.priority_high : Icons.check, color: warn ? LbColors.warn : LbColors.emerald, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class RequiredDocumentsScreen extends StatelessWidget {
  const RequiredDocumentsScreen({super.key});
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
                  const LbEyebrow('3 DOCUMENTS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Documents Heart Care Trust needs.'),
              const SizedBox(height: 8),
              LbBody('Some you may already have.', color: LbColors.muted),
              const SizedBox(height: 16),
              _DocChecklistRow(name: 'Aadhaar card', meta: 'Uploaded · from your case', ready: true),
              const SizedBox(height: 8),
              _DocChecklistRow(name: "Doctor's prescription", meta: 'Uploaded · from your case', ready: true),
              const SizedBox(height: 8),
              _DocChecklistRow(name: 'Income certificate', meta: 'Not yet uploaded', ready: false, onUploadTap: () => Navigator.pushNamed(context, '/docs/upload')),
              const SizedBox(height: 24),
              LbButton(label: 'Proceed to application', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              LbButton(label: 'Upload income certificate', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/docs/upload')),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocChecklistRow extends StatelessWidget {
  final String name;
  final String meta;
  final bool ready;
  final VoidCallback? onUploadTap;
  const _DocChecklistRow({required this.name, required this.meta, required this.ready, this.onUploadTap});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: ready ? LbColors.successBg : LbColors.warnBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(ready ? Icons.check : Icons.description_outlined, color: ready ? LbColors.emerald : LbColors.warn, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(meta, style: TextStyle(fontSize: 12, color: ready ? LbColors.emerald : LbColors.muted)),
              ],
            ),
          ),
          if (ready) const LbBadge(label: 'Ready', variant: BadgeVariant.approved) else GestureDetector(onTap: onUploadTap, child: const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class SupportSourceVerificationScreen extends StatelessWidget {
  const SupportSourceVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = const [
      'Organization exists',
      'Registration & tax status',
      'Active intake for 2026',
      'Direct program contact',
      'No user reports of fraud',
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
                  const LbEyebrow('VERIFICATION'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const LbIconTile(icon: Icons.handshake_outlined, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Heart Care Trust', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        LbBadge(label: 'Verified by LifeBridge', variant: BadgeVariant.approved),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LbBody("We contact every program we list and re-check annually. Here's what we verified:", color: LbColors.fg2),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: LbColors.emerald, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text(items[i], style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LbEyebrow('LAST VERIFIED'),
                    SizedBox(height: 6),
                    Text('12 March 2026 by LifeBridge Trust Team', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text('Phone: +91 8816 129 087 · Email: contact@heartcaretrust.org', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "Verification doesn't guarantee the program will approve your application. Always read program terms.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to program', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
