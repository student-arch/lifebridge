import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../services/ai_service.dart';
import '../../widgets/components.dart';

class CreateApplicationScreen extends StatelessWidget {
  const CreateApplicationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final rec = s.supportPrograms.first;
    final others = s.supportPrograms.skip(1).take(3).toList();
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
                  const LbEyebrow('NEW APPLICATION'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Apply to a program.'),
              const SizedBox(height: 8),
              LbBody("We'll prepare a draft for you to review.", color: LbColors.muted),
              const SizedBox(height: 20),
              const LbEyebrow('RECOMMENDED'),
              const SizedBox(height: 8),
              LbCard(
                background: LbColors.accent,
                borderColor: Colors.transparent,
                radius: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const LbIconTile(icon: Icons.favorite, background: Color(0x33FFFFFF), foreground: LbColors.surface, size: 44, iconSize: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rec.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: LbColors.surface)),
                              const SizedBox(height: 2),
                              Text('${rec.amountLabel} · ${rec.matchPercent}% match', style: const TextStyle(fontSize: 12, color: LbColors.surface)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Color(0x33FFFFFF), borderRadius: BorderRadius.circular(999)),
                          child: const Text('BEST FIT', style: TextStyle(color: LbColors.surface, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LbButton(label: 'Use this program', background: LbColors.surface, foreground: LbColors.accent, onTap: () => Navigator.pushNamed(context, '/app/preparation')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow('OTHER MATCHES'),
              const SizedBox(height: 8),
              for (final p in others) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/app/select-program'),
                  child: Row(
                    children: [
                      LbIconSquare(icon: Icons.credit_card, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20, radius: 12),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('${p.matchPercent}% match', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
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

class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({super.key});
  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final list = s.supportPrograms.where((p) => _q.isEmpty || p.name.toLowerCase().contains(_q.toLowerCase())).toList();
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
                  const LbEyebrow('CHOOSE PROGRAM'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Pick a program.'),
              const SizedBox(height: 8),
              LbBody('You can apply to more than one — each is independent.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbSearch(hint: 'Search programs', onChanged: (v) => setState(() => _q = v)),
              const SizedBox(height: 16),
              for (final p in list) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/app/preparation'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('${p.organization} · ${p.documentsNeeded} docs ready', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      LbPill(label: '${p.matchPercent}%', variant: p.pillVariant),
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

class ApplicationPreparationScreen extends StatelessWidget {
  const ApplicationPreparationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('HEART CARE TRUST'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Preparing your draft.'),
              const SizedBox(height: 8),
              LbBody("AI fills what it can from your case. You review before sending.", color: LbColors.muted),
              const SizedBox(height: 16),
              const LbAIBubble(
                title: 'AI is composing your draft',
                message: "This usually takes 30–60 seconds. We use your case data, documents, and the program's requirements.",
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHERE FIELDS COME FROM'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _LegendRow(color: LbColors.infoBg, icon: Icons.folder_outlined, iconColor: LbColors.accent, title: 'From your case profile'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _LegendRow(color: LbColors.successBg, icon: Icons.check, iconColor: LbColors.emerald, title: 'Extracted from your documents'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _LegendRow(color: LbColors.warnBg, icon: Icons.edit, iconColor: LbColors.warn, title: 'AI-drafted (you can edit)'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/app/draft')),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  const _LegendRow({required this.color, required this.icon, required this.iconColor, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(width: 24, height: 24, decoration: BoxDecoration(color: color, shape: BoxShape.circle), alignment: Alignment.center, child: Icon(icon, size: 14, color: iconColor)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class AIDraftScreen extends StatefulWidget {
  const AIDraftScreen({super.key});
  @override
  State<AIDraftScreen> createState() => _AIDraftScreenState();
}

class _AIDraftScreenState extends State<AIDraftScreen> {
  bool _started = false;
  bool _loading = true;
  String? _statement;
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
      final text = await s.askAi(
        task: 'Draft the personal-statement section of this financial-assistance application.',
        messages: const [
          AiChatMessage(
            role: 'user',
            content: 'Write a first-person personal statement (120-180 words, plain dignified language, no markdown headers) '
                'for this assistance application, grounded only in the case data. Do not invent names, amounts, or events.',
          ),
        ],
        maxTokens: 600,
      );
      if (!mounted) return;
      setState(() {
        _statement = text;
        _loading = false;
      });
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong reaching the AI. Check your connection and settings, then try again.';
        _loading = false;
      });
    }
  }

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
                  const LbEyebrow('DRAFT · REVIEW'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Draft is ready.'),
              const SizedBox(height: 8),
              LbBody("Edit anything that doesn't sound like you.", color: LbColors.muted),
              const SizedBox(height: 16),
              const LbAIBubble(
                title: 'Application summary',
                message: '7 fields from your case, 4 from documents, 3 AI-drafted. Total: 14 fields.',
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'PATIENT INFORMATION', pill: 'FROM CASE', pillVariant: PillVariant.success),
              LbCard(
                child: Column(
                  children: const [
                    _KVRow(label: 'PATIENT NAME', value: 'Ramakrishna'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _KVRow(label: 'AGE', value: '41'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _KVRow(label: 'AADHAAR', value: '•••• •••• 4521'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionHeader(title: 'TREATMENT', pill: 'FROM DOCUMENTS', pillVariant: PillVariant.success),
              LbCard(
                child: Column(
                  children: const [
                    _KVRow(label: 'PROCEDURE', value: 'Cardiac catheterization + angioplasty'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _KVRow(label: 'HOSPITAL', value: 'Bhimavaram General Hospital'),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _KVRow(label: 'EST. COST', value: '₹4,80,000', number: true),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionHeader(title: 'PERSONAL STATEMENT', pill: 'AI-DRAFTED', pillVariant: PillVariant.warn),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_loading)
                      const Row(
                        children: [
                          LbSpinner(size: 16, color: LbColors.accent),
                          SizedBox(width: 8),
                          Text('Drafting your statement…', style: TextStyle(fontSize: 13, color: LbColors.muted, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(fontSize: 13, color: LbColors.danger, height: 1.5)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _error = null;
                            _loading = true;
                          });
                          _run();
                        },
                        child: const Text('Try again', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                      ),
                    ],
                    if (_statement != null) ...[
                      Text(_statement!, style: const TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.5)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/app/edit', arguments: {'statement': _statement}),
                        child: const Row(
                          children: [
                            Text('Edit', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_outward, size: 14, color: LbColors.fg),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Continue to review', onTap: () => Navigator.pushNamed(context, '/app/review')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String pill;
  final PillVariant pillVariant;
  const _SectionHeader({required this.title, required this.pill, required this.pillVariant});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: LbColors.muted, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
          const Spacer(),
          LbPill(label: pill, variant: pillVariant),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  final bool number;
  const _KVRow({required this.label, required this.value, this.number = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: LbEyebrow(label)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: LbColors.fg, fontFeatures: number ? const [FontFeature.tabularFigures()] : null)),
          ),
        ],
      ),
    );
  }
}

class ApplicationReviewScreen extends StatelessWidget {
  const ApplicationReviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('HEART CARE TRUST · REVIEW'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Final review.'),
              const SizedBox(height: 8),
              LbBody('14 fields · 3 sections · ~6 minutes to read', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: const [
                    _ReviewRow(title: 'Patient information', subtitle: '4 fields · from your case', ok: true),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _ReviewRow(title: 'Treatment details', subtitle: '5 fields · from your documents', ok: true),
                    Divider(color: LbColors.borderSoft, height: 1),
                    _ReviewRow(title: 'Personal statement', subtitle: '3 paragraphs · AI-drafted', ok: false),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'Anything you change here is saved automatically. The program will only see what you submit.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Looks good', onTap: () => Navigator.pushNamed(context, '/app/checklist')),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool ok;
  const _ReviewRow({required this.title, required this.subtitle, required this.ok});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: ok ? LbColors.successBg : LbColors.surface2, shape: BoxShape.circle, border: Border.all(color: ok ? LbColors.success : LbColors.border)),
            alignment: Alignment.center,
            child: ok ? const Icon(Icons.check, color: LbColors.emerald, size: 14) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          if (!ok)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/app/edit'),
              child: const Text('Review', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class EditApplicationScreen extends StatefulWidget {
  const EditApplicationScreen({super.key});
  @override
  State<EditApplicationScreen> createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  final _ctrl = TextEditingController();
  bool _started = false;
  bool _loading = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    final passed = args is Map ? (args['statement'] as String? ?? '') : '';
    if (passed.trim().isNotEmpty) {
      _ctrl.text = passed;
      return;
    }
    _loading = true;
    _run();
  }

  Future<void> _run() async {
    final s = AppScope.read(context);
    try {
      final text = await s.askAi(
        task: 'Draft the personal-statement section of this financial-assistance application.',
        messages: const [
          AiChatMessage(
            role: 'user',
            content: 'Write a first-person personal statement (120-180 words, plain dignified language, no markdown headers) '
                'for this assistance application, grounded only in the case data. Do not invent names, amounts, or events.',
          ),
        ],
        maxTokens: 600,
      );
      if (!mounted) return;
      setState(() {
        _ctrl.text = text;
        _loading = false;
      });
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong reaching the AI. Check your connection and settings, then try again.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
                  const LbEyebrow('EDIT · AI-DRAFTED'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Edit personal statement'),
              const SizedBox(height: 8),
              LbBody("AI drafted this. Make it sound like you.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'Note. ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.warn)),
                      TextSpan(text: 'This is the part the trust will read first. Tell your story in your own words.', style: TextStyle(color: LbColors.fg2)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('YOUR STATEMENT'),
              const SizedBox(height: 8),
              if (_loading)
                const LbCard(
                  child: Row(
                    children: [
                      LbSpinner(size: 16, color: LbColors.accent),
                      SizedBox(width: 8),
                      Text('Drafting your statement…', style: TextStyle(fontSize: 13, color: LbColors.muted, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              if (_error != null) ...[
                LbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_error!, style: const TextStyle(fontSize: 13, color: LbColors.danger, height: 1.5)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _error = null;
                            _loading = true;
                          });
                          _run();
                        },
                        child: const Text('Try again', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
              if (!_loading && _error == null)
                Container(
                  decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: 12,
                    minLines: 8,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true, contentPadding: EdgeInsets.zero),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: LbButton(label: '↺ Regenerate', variant: LbButtonVariant.ghost, fontSize: 13, height: 44, onTap: () {
                    setState(() {
                      _error = null;
                      _loading = true;
                    });
                    _run();
                  })),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Use original', variant: LbButtonVariant.ghost, fontSize: 13, height: 44, onTap: () => Navigator.pushNamed(context, '/app/draft'))),
                ],
              ),
              const SizedBox(height: 16),
              LbButton(label: 'Save changes', onTap: () => Navigator.pushNamed(context, '/app/review')),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentChecklistScreen extends StatelessWidget {
  const DocumentChecklistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final docs = const ['Aadhaar card', "Doctor's prescription", 'Income certificate'];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('DOCUMENTS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Documents to attach.'),
              const SizedBox(height: 8),
              LbBody('Heart Care Trust needs 3 documents. You have 2.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final d in docs) ...[
                LbCard(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.check, color: LbColors.emerald, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            const Text('Attached from your case', style: TextStyle(fontSize: 12, color: LbColors.emerald)),
                          ],
                        ),
                      ),
                      const LbBadge(label: 'Ready', variant: BadgeVariant.approved),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'All documents auto-attach from your case. To change what\'s included, edit your case.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/app/consent')),
      ),
    );
  }
}

class MissingAppDocsScreen extends StatelessWidget {
  const MissingAppDocsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('ACTION NEEDED'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('2 documents missing.'),
              const SizedBox(height: 8),
              LbBody("The program needs these before they can review your application.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: 'Without these, your application may be auto-rejected or put on hold.',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              _MissingAppDoc(name: 'Cost breakdown', subtitle: 'Detailed estimate from the hospital'),
              const SizedBox(height: 8),
              _MissingAppDoc(name: 'BPL card', subtitle: 'Below Poverty Line certificate'),
              const SizedBox(height: 12),
              LbBody("Not sure what these are? Tap the program to learn.", color: LbColors.muted, size: 12, align: TextAlign.center),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LbButton(label: 'Upload documents', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
            const SizedBox(height: 8),
            LbButton(label: 'Submit without (not recommended)', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/app/consent')),
          ],
        ),
      ),
    );
  }
}

class _MissingAppDoc extends StatelessWidget {
  final String name;
  final String subtitle;
  const _MissingAppDoc({required this.name, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/docs/upload'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LbColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LbColors.warn, width: 1.5, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.description_outlined, color: LbColors.warn, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class ApplicationConsentScreen extends StatefulWidget {
  const ApplicationConsentScreen({super.key});
  @override
  State<ApplicationConsentScreen> createState() => _ApplicationConsentScreenState();
}

class _ApplicationConsentScreenState extends State<ApplicationConsentScreen> {
  bool _confirm = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('FINAL STEP'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Confirm before submitting.'),
              const SizedBox(height: 8),
              LbBody("Read what you're sharing with Heart Care Trust.", color: LbColors.muted),
              const SizedBox(height: 16),
              const LbEyebrow("YOU'RE SHARING"),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _Bullet(text: 'Patient profile (name, age, Aadhaar)'),
                    SizedBox(height: 8),
                    _Bullet(text: 'Treatment and hospital details'),
                    SizedBox(height: 8),
                    _Bullet(text: 'Income summary'),
                    SizedBox(height: 8),
                    _Bullet(text: '3 attached documents'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "Once submitted, LifeBridge will track responses and remind you about follow-ups. You can withdraw any time.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              LbCheckbox(
                label: "I confirm the information is accurate and I'm authorized to share it on behalf of the patient.",
                value: _confirm,
                onChanged: (v) => setState(() => _confirm = v),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Submit application', onTap: () => Navigator.pushNamed(context, '/app/confirm')),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, color: LbColors.fg, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

class SubmitConfirmationScreen extends StatelessWidget {
  const SubmitConfirmationScreen({super.key});
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
                decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.send, color: LbColors.accent, size: 32),
              ),
              const SizedBox(height: 24),
              const LbH1('Ready to send.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Heart Care Trust will receive your application immediately.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Row(
                  children: [
                    const LbIconTile(icon: Icons.favorite, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Heart Care Trust', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('14 fields · 3 documents · ₹4,80,000', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('WHAT HAPPENS NEXT'),
                    SizedBox(height: 8),
                    _NextDot(text: 'Trust receives your application', active: true),
                    SizedBox(height: 6),
                    _NextDot(text: 'Initial review (2–3 days)'),
                    SizedBox(height: 6),
                    _NextDot(text: 'Decision (usually 2 weeks)'),
                    SizedBox(height: 6),
                    _NextDot(text: "We'll notify you at every step"),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Send application', onTap: () => Navigator.pushReplacementNamed(context, '/app/submitting')),
              const SizedBox(height: 8),
              LbButton(label: 'Save as draft', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextDot extends StatelessWidget {
  final String text;
  final bool active;
  const _NextDot({required this.text, this.active = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: active ? LbColors.accent : LbColors.border, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: active ? LbColors.fg : LbColors.muted))),
      ],
    );
  }
}

class SubmittingScreen extends StatefulWidget {
  const SubmittingScreen({super.key});
  @override
  State<SubmittingScreen> createState() => _SubmittingScreenState();
}

class _SubmittingScreenState extends State<SubmittingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/app/submitted');
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
                decoration: BoxDecoration(color: LbColors.accent, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const LbSpinner(size: 48, color: LbColors.surface),
              ),
              const SizedBox(height: 24),
              const LbH1('Sending your application…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Reaching Heart Care Trust's secure portal.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbProcessingRow(text: 'Encrypted your data', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Uploading to Heart Care Trust…', done: false, spinner: true),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Confirming receipt', done: false, spinner: false),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/app/failed'),
                  child: const Text.rich(
                    TextSpan(
                      text: "Taking longer than a minute? See what happens if ",
                      style: TextStyle(fontSize: 12, color: LbColors.muted),
                      children: [TextSpan(text: "the portal can't be reached", style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmittedScreen extends StatelessWidget {
  const SubmittedScreen({super.key});
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
                decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: LbColors.emerald, size: 36),
              ),
              const SizedBox(height: 24),
              const LbH1('Application sent.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Heart Care Trust has your application. We'll track it for you.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: const Text('Heart Care Trust', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                        const LbBadge(label: 'Submitted', variant: BadgeVariant.submitted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('App #HCT-2026-04812 · 22 April 2026 · 9:41 AM', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 12),
                    const LbProgress(value: 0.28),
                    const SizedBox(height: 6),
                    const Text('Typical review: 2–3 weeks', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHAT'S NEXT"),
                    SizedBox(height: 8),
                    _NextDot(text: "LifeBridge will follow up if no response in 7 days", active: true),
                    SizedBox(height: 6),
                    _NextDot(text: 'You can apply to other programs in parallel'),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'View receipt', onTap: () => Navigator.pushNamed(context, '/app/receipt')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmissionFailedScreen extends StatelessWidget {
  const SubmissionFailedScreen({super.key});
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
                decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline, color: LbColors.danger, size: 36),
              ),
              const SizedBox(height: 24),
              const LbH1("Submission didn't go through.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Heart Care Trust's portal is having a brief issue.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'What we know: ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'Connection timed out after 30 seconds. Your draft is safe.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('OPTIONS'),
                    SizedBox(height: 8),
                    _NextDot(text: 'Try again now', active: true),
                    SizedBox(height: 6),
                    _NextDot(text: 'Retry in 15 minutes'),
                    SizedBox(height: 6),
                    _NextDot(text: 'Save as draft and submit later'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbMeta('Error code: #NET-5021'),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamed(context, '/app/submitting')),
              const SizedBox(height: 8),
              LbButton(label: 'Save as draft', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationReceiptScreen extends StatelessWidget {
  const ApplicationReceiptScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('RECEIPT'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const LbIconTile(icon: Icons.favorite, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Heart Care Trust', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Text('Application #HCT-2026-04812', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                            SizedBox(width: 8),
                            LbBadge(label: 'Submitted', variant: BadgeVariant.submitted),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: const [
                    LbKeyValue(label: 'SUBMITTED', value: '22 Apr 9:41 AM'),
                    LbKeyValue(label: 'RESPONSE BY', value: '6 May 2026'),
                    LbKeyValue(label: 'REQUESTED', value: '₹1,50,000', largeValue: true),
                    LbKeyValue(label: 'DOCUMENTS', value: '3 attached'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('DOCUMENTS SUBMITTED'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _Bullet(text: 'Aadhaar card'),
                    SizedBox(height: 8),
                    _Bullet(text: "Doctor's prescription"),
                    SizedBox(height: 8),
                    _Bullet(text: 'Income certificate'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: LbButton(label: 'Download PDF', variant: LbButtonVariant.secondary, fontSize: 13, height: 44, onTap: () => Navigator.pushNamed(context, '/app/detail'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Get help', variant: LbButtonVariant.secondary, fontSize: 13, height: 44, onTap: () => Navigator.pushNamed(context, '/help'))),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Track this application', onTap: () => Navigator.pushNamed(context, '/app/detail')),
      ),
    );
  }
}

class ApplicationsListScreen extends StatelessWidget {
  const ApplicationsListScreen({super.key});
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
                  LbEyebrow('APPLICATIONS · ${s.applications.length}'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Your applications'),
              const SizedBox(height: 8),
              LbBody("Track every program you've applied to.", color: LbColors.muted),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    LbPill(label: 'ALL · ${s.applications.length}', variant: PillVariant.accent),
                    const SizedBox(width: 8),
                    LbPill(label: 'DRAFT', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'SUBMITTED', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'UNDER REVIEW', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'APPROVED', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'REJECTED', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final a in s.applications) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/app/detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(a.programName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                          LbBadge(label: a.status, variant: a.statusVariant),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${a.reference} · ${a.status == 'Draft' ? '4 days ago' : a.status == 'Under review' ? (a.reference == 'STS-2026-7740' ? '1 week ago' : '2 days ago') : ''}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 12),
                      LbProgress(value: a.progress / 100, color: a.status == 'Draft' ? LbColors.border : LbColors.accent),
                      const SizedBox(height: 6),
                      Text(a.status == 'Draft' ? 'Awaiting 1 document to submit' : 'Response expected by ${a.responseBy.day} May', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbButton(label: '+ New application', onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationDetailScreen extends StatelessWidget {
  const ApplicationDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final a = s.applications.first;
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
                  const LbEyebrow('APPLICATION'),
                ],
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.programName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                    const SizedBox(height: 4),
                    Text('${a.reference} · ${s.patient.name}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        LbBadge(label: a.status, variant: a.statusVariant),
                        const SizedBox(width: 8),
                        Text('Day ${_daysFromSubmitted(a)} of 14', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LbProgress(value: 0.14),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('REQUESTED'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbNumber('₹1,50,000', size: 28),
                    SizedBox(height: 4),
                    Text('Maximum program benefit', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('STATUS'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _StatusRow(label: 'Submitted to Heart Care Trust', state: 'done'),
                    SizedBox(height: 12),
                    _StatusRow(label: 'Initial review', state: 'current'),
                    SizedBox(height: 12),
                    _StatusRow(label: 'Decision', state: 'pending'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/app/status'),
                  child: const Text('View all statuses →', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/app/timeline'),
                child: const Row(
                  children: [
                    Expanded(child: Text('View timeline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/app/under-review'),
                child: const Row(
                  children: [
                    Expanded(child: Text('Under review details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/draft'),
                child: const Row(
                  children: [
                    Expanded(child: Text('Send a follow-up (after 7 days)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }

  int _daysFromSubmitted(ApplicationEntity a) {
    return DateTime.now().difference(a.submittedAt).inDays + 1;
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String state;
  const _StatusRow({required this.label, required this.state});
  @override
  Widget build(BuildContext context) {
    Color color;
    if (state == 'done') {
      color = LbColors.emerald;
    } else if (state == 'current') {
      color = LbColors.accent;
    } else {
      color = LbColors.muted;
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: state == 'pending' ? LbColors.muted : LbColors.fg))),
      ],
    );
  }
}

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Draft', 'We helped you write it', 'done'),
      ('Ready for review', 'You approved and sent', 'done'),
      ('Submitted', 'Heart Care Trust received it', 'done'),
      ('Under review', 'Currently happening', 'current'),
      ('More information', 'If they ask for more', 'link'),
      ('Approved / Rejected', 'Final decision', 'link'),
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
                  const LbEyebrow('STATUS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Application status'),
              const SizedBox(height: 8),
              LbBody('Updated by the program and LifeBridge.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LbIconTile(icon: Icons.access_time, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Under review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text("Heart Care Trust is checking your application", style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          SizedBox(height: 8),
                          Text("Typical review: 2–3 weeks. We'll notify you the moment they respond.", style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('ALL STATUSES (IN ORDER)'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      _StatusItemRow(title: items[i].$1, subtitle: items[i].$2, state: items[i].$3, onTap: () {
                        if (items[i].$3 == 'link') {
                          Navigator.pushNamed(context, items[i].$1 == 'More information' ? '/app/info-required' : '/app/approved');
                        }
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to application', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItemRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String state;
  final VoidCallback? onTap;
  const _StatusItemRow({required this.title, required this.subtitle, required this.state, this.onTap});
  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (state == 'done') {
      leading = Container(
        width: 20, height: 20,
        decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: const Icon(Icons.check, color: LbColors.emerald, size: 14),
      );
    } else if (state == 'current') {
      leading = Container(
        width: 20, height: 20,
        decoration: BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle, border: Border.all(color: LbColors.accent)),
        child: Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: LbColors.accent, shape: BoxShape.circle))),
      );
    } else {
      leading = Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: LbColors.border)));
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: state == 'pending' ? LbColors.muted : LbColors.fg)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            if (state == 'link') const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class ApplicationTimelineScreen extends StatelessWidget {
  const ApplicationTimelineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final events = MockData.appTimeline('HCT-04812');
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
                  const LbEyebrow('TIMELINE'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Application timeline'),
              const SizedBox(height: 8),
              LbBody('Everything that happened, in order.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < events.length; i++)
                      LbTimelineItem(
                        title: events[i].title,
                        subtitle: events[i].meta,
                        done: events[i].done,
                        active: events[i].active,
                        isLast: i == events.length - 1,
                        trailing: events[i].pillLabel != null
                            ? LbPill(label: events[i].pillLabel!, variant: events[i].pillVariant ?? PillVariant.success)
                            : null,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "We update this every time something changes. You'll get a notification for each step.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to application', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class AppUnderReviewScreen extends StatelessWidget {
  const AppUnderReviewScreen({super.key});
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
                  const LbEyebrow('UNDER REVIEW'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Heart Care Trust is reviewing your case.'),
              const SizedBox(height: 8),
              LbBody("Day 2 of 14. We'll notify you the moment they respond.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: const Row(
                  children: [
                    LbIconTile(icon: Icons.access_time, background: LbColors.surface, foreground: LbColors.accent, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('In progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text("The program is reviewing your application. We check in on day 7 if they don't respond.", style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _QuickAction(icon: Icons.send_outlined, title: 'Send follow-up', subtitle: 'After day 7', onTap: () => Navigator.pushNamed(context, '/followups/draft'))),
                  const SizedBox(width: 8),
                  Expanded(child: _QuickAction(icon: Icons.edit_outlined, title: 'Update info', subtitle: 'If something changed', onTap: () => Navigator.pushNamed(context, '/app/detail'))),
                  const SizedBox(width: 8),
                  Expanded(child: _QuickAction(icon: Icons.add_box_outlined, title: 'Add backup', subtitle: 'Apply to another', onTap: () => Navigator.pushNamed(context, '/find-alternative'))),
                ],
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHILE YOU WAIT'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbBullet(items: ['Apply to Godavari Charity Care (88% match)', 'Confirm insurance pre-authorization', 'Keep documents up to date']),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to home', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
        child: Column(
          children: [
            LbIconTile(icon: icon, background: LbColors.infoBg, foreground: LbColors.accent, size: 36, iconSize: 18),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: LbColors.muted)),
          ],
        ),
      ),
    );
  }
}

class AppInfoRequiredScreen extends StatelessWidget {
  const AppInfoRequiredScreen({super.key});
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
                  const LbEyebrow('ACTION NEEDED'),
                ],
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: 'Heart Care Trust needs more information.',
                  style: const TextStyle(color: LbColors.fg, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.25),
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: "They've asked for the items below. Please respond by ",
                  children: [const TextSpan(text: '6 May 2026', style: TextStyle(fontWeight: FontWeight.w600))],
                  style: const TextStyle(fontSize: 14, color: LbColors.fg2),
                ),
              ),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'From the program (verbatim):',
                body: '"We need a recent cost breakdown from the hospital showing procedure, length of stay, and itemized charges."',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHAT THEY WANT'),
              const SizedBox(height: 8),
              _RequiredItem(name: 'Itemized cost breakdown', subtitle: 'From the hospital billing office'),
              const SizedBox(height: 8),
              _RequiredItem(name: 'Updated medical certificate', subtitle: 'Issued within the last 30 days'),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'AI suggestion',
                message: 'I can draft a polite response letter for you. Tap below to use it.',
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Add requested documents', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
              const SizedBox(height: 8),
              LbButton(label: 'Reply to program', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredItem extends StatelessWidget {
  final String name;
  final String subtitle;
  const _RequiredItem({required this.name, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: () => Navigator.pushNamed(context, '/docs/upload'),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.description_outlined, color: LbColors.warn, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AppApprovedScreen extends StatelessWidget {
  const AppApprovedScreen({super.key});
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
                width: 80, height: 80,
                decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40),
              ),
              const SizedBox(height: 24),
              const LbH1('Application approved.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Heart Care Trust has approved your request.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Heart Care Trust', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('HCT-2026-04812', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    SizedBox(height: 16),
                    LbKeyValue(label: 'APPROVED AMOUNT', value: '₹1,20,000', valueColor: LbColors.emerald, largeValue: true),
                    LbKeyValue(label: 'DISBURSEMENT', value: 'Within 7 days'),
                    LbKeyValue(label: 'REFERENCE', value: 'HCT-DIS-225'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.successBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'Funding gap updated. ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.emerald)),
                      TextSpan(text: 'New gap: '),
                      TextSpan(text: '₹1,60,000', style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ' (was ₹2,80,000).'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              LbButton(label: 'View updated gap', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
              const SizedBox(height: 8),
              LbButton(label: 'Find more help', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/find-alternative')),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRejectedScreen extends StatelessWidget {
  const AppRejectedScreen({super.key});
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
                width: 80, height: 80,
                decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline, color: LbColors.danger, size: 36),
              ),
              const SizedBox(height: 24),
              const LbH1('Application not approved.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Seva Community Fund was unable to support this case.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seva Community Fund', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LbColors.danger)),
                    SizedBox(height: 4),
                    Text('SCF-2026-0183 · rejected 2 days ago', style: TextStyle(fontSize: 12, color: LbColors.fg2)),
                    SizedBox(height: 12),
                    Text('"We have reviewed your application and regret to inform you that your request does not fit our current funding priorities."', style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("THIS ISN'T THE END"),
                    SizedBox(height: 8),
                    LbBullet(items: ['3 other matched programs are still open', 'You can correct and reapply in some cases', 'Tell LifeBridge if anything has changed']),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'See recovery options', onTap: () => Navigator.pushNamed(context, '/app/rejection-recovery')),
              const SizedBox(height: 8),
              LbButton(label: 'Find alternative support', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/find-alternative')),
            ],
          ),
        ),
      ),
    );
  }
}

class RejectionDetailsScreen extends StatelessWidget {
  const RejectionDetailsScreen({super.key});
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
                  const LbEyebrow('REJECTION DETAILS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Why this happened.'),
              const SizedBox(height: 8),
              LbBody('Knowing the reason helps you move forward.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("PROGRAM'S STATED REASON"),
                    SizedBox(height: 8),
                    Text('"…does not fit our current funding priorities. ', style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4)),
                    Text('Priority for this cycle was given to families in rural districts."', style: TextStyle(fontSize: 13, color: LbColors.fg2, fontWeight: FontWeight.w600, height: 1.4)),
                    SizedBox(height: 8),
                    Text('Received 19 April 2026 · 3:22 PM', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'What this means',
                message: 'This program focuses on rural cases this cycle… We can help you find other programs in the meantime.',
              ),
              const SizedBox(height: 16),
              const LbEyebrow('OPTIONS FOR YOU'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/app/rejection-recovery'),
                child: const Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Correct & reapply', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Possible next cycle · add details they asked for', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/find-alternative'),
                child: const Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Find alternative support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('3 other programs still match', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/need-help'),
                child: const Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Tell LifeBridge what changed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Reassess your case from scratch', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'See recovery options', onTap: () => Navigator.pushNamed(context, '/app/rejection-recovery')),
            ],
          ),
        ),
      ),
    );
  }
}

class RejectionRecoveryScreen extends StatelessWidget {
  const RejectionRecoveryScreen({super.key});
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
                  const LbEyebrow('RECOVERY'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Recovery options'),
              const SizedBox(height: 8),
              LbBody('Most rejections are recoverable. Pick a path forward.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.accent,
                borderColor: Colors.transparent,
                radius: 32,
                onTap: () => Navigator.pushNamed(context, '/app/create'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('RECOMMENDED', style: TextStyle(fontSize: 10, color: LbColors.surface, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                        Spacer(),
                        LbCtaCircle(icon: Icons.arrow_forward, background: LbColors.surface, foreground: LbColors.accent, size: 40),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Correct & reapply', style: TextStyle(fontSize: 18, color: LbColors.surface, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('Seva Fund reopens applications in 8 weeks. Update your case and we\'ll prepare a stronger draft.', style: TextStyle(fontSize: 12, color: LbColors.surface, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _RecoveryCard(title: 'Find alternative support', subtitle: '3 other programs still match your case.', onTap: () => Navigator.pushNamed(context, '/find-alternative')),
              const SizedBox(height: 8),
              _RecoveryCard(title: 'Tell us what changed', subtitle: 'Cost increase, new diagnosis, or new need — we\'ll reassess your case.', onTap: () => Navigator.pushNamed(context, '/followups/need-help')),
              const SizedBox(height: 8),
              _RecoveryCard(title: 'Talk to a human', subtitle: 'Connect with a LifeBridge care specialist.', onTap: () => Navigator.pushNamed(context, '/ai/human')),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _RecoveryCard({required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted, height: 1.4)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
        ],
      ),
    );
  }
}
