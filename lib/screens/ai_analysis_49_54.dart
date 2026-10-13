import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../services/ai_service.dart';
import '../../widgets/components.dart';

/// Safe JSON readers for AI-generated analysis maps.
String _jstr(Map m, String key) => m[key] is String ? (m[key] as String) : '';
int _jint(Map m, String key) => m[key] is int ? (m[key] as int) : 0;
List<Map<String, dynamic>> _jlist(Map m, String key) {
  final v = m[key];
  if (v is! List) return const [];
  return [for (final e in v) if (e is Map<String, dynamic>) e];
}

class AIAnalysisScreen extends StatefulWidget {
  const AIAnalysisScreen({super.key});
  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  bool _started = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _run();
  }

  Future<void> _run() async {
    final s = AppScope.read(context);
    try {
      final analysis = await s.askAiJson(
        task: 'Analyze this patient-assistance case for support-program matching. '
            'Reply with ONLY valid JSON shaped exactly like: '
            '{"summary":"2-3 sentence plain-language summary","matchedPrograms":<int>,"possibleAid":"e.g. ₹3.2L",'
            '"needs":[{"title":...,"description":...}] (3-5 items),'
            '"missingDocs":<int>,"missingDocsDetail":"...",'
            '"nextAction":{"title":...,"detail":...},'
            '"docPlan":[{"name":...,"meta":...,"uploaded":bool}] (3-5 items),'
            '"steps":[{"title":...,"description":...}] (3-4 items)}. '
            'Ground every number in the case data. Never invent approvals, deadlines, or program decisions.',
        userContent: 'Analyze my case and return the JSON matching plan.',
      );
      if (!mounted) return;
      if (_jstr(analysis, 'summary').isEmpty) {
        setState(() => _error = 'The AI returned a response this app could not understand. Try again.');
        return;
      }
      Navigator.pushReplacementNamed(context, '/ai/results', arguments: {'analysis': analysis});
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Something went wrong reaching the AI. Check your connection and settings, then try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: LbColors.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const LbSpinner(size: 40, color: LbColors.accent),
                ),
                const SizedBox(height: 16),
                const LbH1('Analysis hit a snag.', align: TextAlign.center),
                const SizedBox(height: 8),
                LbAIBubble(title: 'Something went wrong', message: _error!),
                const SizedBox(height: 16),
                LbButton(label: 'Try again', onTap: () {
                  setState(() => _error = null);
                  _started = false;
                  _run();
                }),
                const SizedBox(height: 8),
                LbButton(label: 'Go back', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      );
    }
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
              LbBody("Your AI model is comparing the case with available programs.", color: LbColors.muted, align: TextAlign.center),
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
              LbButton(label: 'Cancel', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
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
    final args = ModalRoute.of(context)?.settings.arguments;
    final analysis = args is Map && args['analysis'] is Map<String, dynamic>
        ? args['analysis'] as Map<String, dynamic>
        : null;
    if (analysis == null || _jstr(analysis, 'summary').isEmpty) {
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
                    const LbEyebrow('ANALYSIS'),
                  ],
                ),
                const SizedBox(height: 16),
                const LbAIBubble(
                  title: 'No analysis yet',
                  message: 'Run a fresh analysis first — results appear here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Run analysis', onTap: () => Navigator.pushReplacementNamed(context, '/ai/analysis')),
              ],
            ),
          ),
        ),
      );
    }
    final needs = _jlist(analysis, 'needs');
    final next = analysis['nextAction'] is Map<String, dynamic> ? analysis['nextAction'] as Map<String, dynamic> : <String, dynamic>{};
    final matched = _jint(analysis, 'matchedPrograms');
    final aid = _jstr(analysis, 'possibleAid');
    final missing = _jint(analysis, 'missingDocs');
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
              LbAIBubble(
                title: 'LifeBridge AI',
                message: _jstr(analysis, 'summary'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: LbStatCard(label: 'PROGRAMS', value: matched > 0 ? '$matched' : '–', caption: 'matched')),
                  const SizedBox(width: 12),
                  Expanded(child: LbStatCard(label: 'POSSIBLE', value: aid.isEmpty ? '–' : aid, caption: 'in aid')),
                ],
              ),
              const SizedBox(height: 16),
              const LbEyebrow('IDENTIFIED NEEDS'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (int i = 0; i < needs.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _NeedRow(title: _jstr(needs[i], 'title').isEmpty ? 'Need ${i + 1}' : _jstr(needs[i], 'title'), analysis: analysis),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'Missing information.',
                body: missing > 0 ? '$missing document${missing == 1 ? '' : 's'} would unlock more matches. ${_jstr(analysis, 'missingDocsDetail')}' : 'Your documents look complete for now.',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LbEyebrow('NEXT BEST ACTION'),
                    const SizedBox(height: 6),
                    Text(_jstr(next, 'title').isEmpty ? 'Review the plan below' : _jstr(next, 'title'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(_jstr(next, 'detail'), style: const TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
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
  final Map<String, dynamic> analysis;
  const _NeedRow({required this.title, this.analysis = const {}});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/ai/needs', arguments: {'analysis': analysis}),
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
    final args = ModalRoute.of(context)?.settings.arguments;
    final analysis = args is Map && args['analysis'] is Map<String, dynamic>
        ? args['analysis'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final list = _jlist(analysis, 'needs');
    if (list.isEmpty) {
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
                const LbAIBubble(
                  title: 'No needs identified yet',
                  message: 'Run a fresh analysis first — identified needs appear here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Run analysis', onTap: () => Navigator.pushReplacementNamed(context, '/ai/analysis')),
              ],
            ),
          ),
        ),
      );
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
                    for (int i = 0; i < list.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _NeedDetailRow(icon: Icons.circle_outlined, title: _jstr(list[i], 'title').isEmpty ? 'Need ${i + 1}' : _jstr(list[i], 'title'), description: _jstr(list[i], 'description')),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'See recommended programs', onTap: () => Navigator.pushNamed(context, '/ai/recommended-support', arguments: {'analysis': analysis})),
            ],
          ),
        ),
      ),
    );
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
    final args = ModalRoute.of(context)?.settings.arguments;
    final analysis = args is Map && args['analysis'] is Map<String, dynamic>
        ? args['analysis'] as Map<String, dynamic>
        : const <String, dynamic>{};
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
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/ai/recommended-docs', arguments: {'analysis': analysis})),
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
    final args = ModalRoute.of(context)?.settings.arguments;
    final analysis = args is Map && args['analysis'] is Map<String, dynamic>
        ? args['analysis'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final docs = _jlist(analysis, 'docPlan');
    if (docs.isEmpty) {
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
                const LbAIBubble(
                  title: 'No document plan yet',
                  message: 'Run a fresh analysis first — the document plan appears here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Run analysis', onTap: () => Navigator.pushReplacementNamed(context, '/ai/analysis')),
              ],
            ),
          ),
        ),
      );
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
                  const LbEyebrow('DOCUMENT PLAN'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Documents to add.'),
              const SizedBox(height: 8),
              LbBody('Each one is asked for by at least one program you matched.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final d in docs) ...[
                _DocPlanRow(doc: d),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              LbButton(label: 'Upload missing documents', onTap: () => Navigator.pushNamed(context, '/docs/missing')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ai/next-steps', arguments: {'analysis': analysis}),
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
  final Map<String, dynamic> doc;
  const _DocPlanRow({required this.doc});
  @override
  Widget build(BuildContext context) {
    final uploaded = doc['uploaded'] == true;
    final name = _jstr(doc, 'name').isEmpty ? 'Document' : _jstr(doc, 'name');
    final meta = _jstr(doc, 'meta');
    return LbCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: uploaded ? LbColors.successBg : LbColors.warnBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              uploaded ? Icons.check : Icons.description_outlined,
              color: uploaded ? LbColors.emerald : LbColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: TextStyle(fontSize: 12, color: uploaded ? LbColors.emerald : LbColors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (!uploaded)
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
    final args = ModalRoute.of(context)?.settings.arguments;
    final analysis = args is Map && args['analysis'] is Map<String, dynamic>
        ? args['analysis'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final steps = _jlist(analysis, 'steps');
    if (steps.isEmpty) {
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
                const LbAIBubble(
                  title: 'No plan yet',
                  message: 'Run a fresh analysis first — the suggested plan appears here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Run analysis', onTap: () => Navigator.pushReplacementNamed(context, '/ai/analysis')),
              ],
            ),
          ),
        ),
      );
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
                      _StepRow(n: i + 1, title: _jstr(steps[i], 'title').isEmpty ? 'Step ${i + 1}' : _jstr(steps[i], 'title'), description: _jstr(steps[i], 'description'), muted: i == steps.length - 1),
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
