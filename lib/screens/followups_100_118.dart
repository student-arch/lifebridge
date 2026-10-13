import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../services/ai_service.dart';
import '../../widgets/components.dart';

Widget _backHeader(BuildContext context, {String? eyebrow, VoidCallback? onBack}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
    child: Row(
      children: [
        LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: onBack ?? () => Navigator.maybePop(context)),
        if (eyebrow != null) ...[const SizedBox(width: 12), LbEyebrow(eyebrow)],
      ],
    ),
  );
}

class FindAlternativeScreen extends StatelessWidget {
  const FindAlternativeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final progs = [...s.supportPrograms.take(4), s.newMatches[3]];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'ALTERNATIVES · 3'),
              const LbH1('Other programs for you.'),
              const SizedBox(height: 8),
              LbBody("These didn't reject you. Apply to any.", color: LbColors.muted),
              const SizedBox(height: 16),
              for (final p in progs) ...[
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
                      Text(p.amountLabel, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(999)),
                        child: Text(p.deadline == null ? 'Not yet applied · ready to start' : 'Status: ${p.deadline}', style: const TextStyle(fontSize: 11, color: LbColors.fg2)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbButton(label: 'Apply to next program', onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpListScreen extends StatelessWidget {
  const FollowUpListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LbEyebrow('FOLLOW-UPS · ${s.followUps.length}'),
              const SizedBox(height: 8),
              const LbH1('Follow-ups'),
              const SizedBox(height: 8),
              LbBody('Programs that need a nudge. AI can draft a polite note.', color: LbColors.muted),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    LbPill(label: 'OVERDUE · 1', variant: PillVariant.danger),
                    const SizedBox(width: 8),
                    LbPill(label: 'DUE THIS WEEK', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'SENT', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final f in s.followUps) ...[
                LbCard(
                  background: f.isOverdue ? LbColors.dangerBg : LbColors.surface,
                  borderColor: f.isOverdue ? LbColors.danger : LbColors.border,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(f.programName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                          LbBadge(label: f.status, variant: f.statusVariant),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('No response in ${f.daysSince} days', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, size: 12, color: LbColors.accent),
                          const SizedBox(width: 4),
                          const Text('Drafted by LifeBridge AI', style: TextStyle(fontSize: 12, color: LbColors.accent, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/followups/overdue'),
                            child: const Text('Review →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              const LbEyebrow('SENT (RECENT)'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/history'),
                child: Row(
                  children: const [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('State Treatment Scheme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Sent 2 weeks ago · replied 6 days later', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbButton(label: 'View all history', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/followups/history')),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpDetailScreen extends StatelessWidget {
  const FollowUpDetailScreen({super.key});
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
              _backHeader(context, eyebrow: 'SEVA COMMUNITY FUND'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(width: 40, height: 40, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.access_time, color: LbColors.danger, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('No response in 9 days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('SCF-2026-0183 · submitted 13 April', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("Most programs respond within 7 days. A polite follow-up is appropriate now.", color: LbColors.fg2),
              const SizedBox(height: 16),
              const LbAIBubble(
                title: 'LifeBridge recommends following up',
                message: "I drafted a message for you. It references your application, asks for an update, and offers to provide anything missing. You can edit before sending.",
              ),
              const SizedBox(height: 16),
              const LbEyebrow('SUGGESTED MESSAGE'),
              const SizedBox(height: 8),
              LbCard(
                child: Text(MockData.followUpDraft('Seva Community Fund', 'SCF-2026-0183'), style: const TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.5)),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('CHANNELS'),
              const SizedBox(height: 8),
              LbCard(
                child: Row(
                  children: const [
                    LbPill(label: 'EMAIL', variant: PillVariant.accent),
                    SizedBox(width: 8),
                    LbPill(label: 'PORTAL', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'PHONE', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Review AI draft', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
              const SizedBox(height: 8),
              LbButton(label: 'Send as-is', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/followups/sent')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/followups/reminder'),
                  child: const Text('Not ready? Set a reminder instead', style: TextStyle(fontSize: 13, color: LbColors.muted)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpReminderScreen extends StatelessWidget {
  const FollowUpReminderScreen({super.key});
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
              _backHeader(context, eyebrow: 'REMINDER'),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seva Community Fund — 9 days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: LbColors.warn)),
                    SizedBox(height: 4),
                    Text("We recommend sending a follow-up today. A polite nudge often gets a response within 48 hours.", style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHY NOW'),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbBullet(items: ['9 days without a response', 'Average response time is 5 days', 'Treatment date is approaching']),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Send follow-up now', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
              const SizedBox(height: 8),
              LbButton(label: 'Snooze 24h', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class AIFollowUpDraftScreen extends StatefulWidget {
  const AIFollowUpDraftScreen({super.key});
  @override
  State<AIFollowUpDraftScreen> createState() => _AIFollowUpDraftScreenState();
}

class _AIFollowUpDraftScreenState extends State<AIFollowUpDraftScreen> {
  final _subject = TextEditingController(text: 'Following up — SCF-2026-0183');
  final _body = TextEditingController();
  bool _started = false;
  bool _loading = true;
  String? _error;

  static const _styles = {
    'default': 'polite and concise (120-160 words)',
    'shorter': 'very brief, under 80 words',
    'formal': 'formal tone (120-160 words)',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _run('default');
  }

  Future<void> _run(String style) async {
    final s = AppScope.read(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final text = await s.askAi(
        task: 'Draft a follow-up email for this assistance application.',
        messages: [
          AiChatMessage(
            role: 'user',
            content: 'Draft a follow-up email to Seva Community Fund about application SCF-2026-0183. '
                'Style: ${_styles[style] ?? _styles['default']}. Plain text, no markdown headers, '
                'grounded only in the case data. Do not invent decisions or dates.',
          ),
        ],
        maxTokens: 500,
      );
      if (!mounted) return;
      setState(() {
        _body.text = text;
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
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

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
              _backHeader(context, eyebrow: 'AI DRAFT'),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'AI drafted a follow-up',
                message: "Edit anything that doesn't sound like you. I'll re-draft on request.",
              ),
              const SizedBox(height: 16),
              LbField(label: 'Subject', controller: _subject),
              const SizedBox(height: 12),
              const LbEyebrow('MESSAGE'),
              const SizedBox(height: 8),
              if (_loading)
                const LbCard(
                  child: Row(
                    children: [
                      LbSpinner(size: 16, color: LbColors.accent),
                      SizedBox(width: 8),
                      Text('Drafting your follow-up…', style: TextStyle(fontSize: 13, color: LbColors.muted, fontStyle: FontStyle.italic)),
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
                        onTap: () => _run('default'),
                        child: const Text('Try again', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
              if (!_loading && _error == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
                  child: TextField(
                    controller: _body,
                    maxLines: 12,
                    minLines: 8,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true, contentPadding: EdgeInsets.zero),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: LbButton(label: '↺ Regenerate', variant: LbButtonVariant.ghost, fontSize: 12, height: 40, onTap: () => _run('default'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Shorter', variant: LbButtonVariant.ghost, fontSize: 12, height: 40, onTap: () => _run('shorter'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'More formal', variant: LbButtonVariant.ghost, fontSize: 12, height: 40, onTap: () => _run('formal'))),
                ],
              ),
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/followups/confirm')),
            ],
          ),
        ),
      ),
    );
  }
}

class EditFollowUpScreen extends StatefulWidget {
  const EditFollowUpScreen({super.key});
  @override
  State<EditFollowUpScreen> createState() => _EditFollowUpScreenState();
}

class _EditFollowUpScreenState extends State<EditFollowUpScreen> {
  final _subject = TextEditingController(text: 'Following up — SCF-2026-0183');
  final _body = TextEditingController();
  bool _started = false;
  bool _loading = true;
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
        task: 'Draft a follow-up email for this assistance application.',
        messages: const [
          AiChatMessage(
            role: 'user',
            content: 'Draft a polite and concise follow-up email (120-160 words) to Seva Community Fund about application SCF-2026-0183. '
                'Plain text, no markdown headers, grounded only in the case data. Do not invent decisions or dates.',
          ),
        ],
        maxTokens: 500,
      );
      if (!mounted) return;
      setState(() {
        _body.text = text;
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
    _subject.dispose();
    _body.dispose();
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
              _backHeader(context, eyebrow: 'EDIT'),
              const SizedBox(height: 12),
              const LbH1('Make it yours.'),
              const SizedBox(height: 8),
              LbBody('Anything you change here is saved automatically.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbField(label: 'Subject', controller: _subject),
              const SizedBox(height: 12),
              const LbEyebrow('MESSAGE'),
              const SizedBox(height: 8),
              if (_loading)
                const LbCard(
                  child: Row(
                    children: [
                      LbSpinner(size: 16, color: LbColors.accent),
                      SizedBox(width: 8),
                      Text('Drafting your follow-up…', style: TextStyle(fontSize: 13, color: LbColors.muted, fontStyle: FontStyle.italic)),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
                  child: TextField(
                    controller: _body,
                    maxLines: 14, minLines: 10,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true, contentPadding: EdgeInsets.zero),
                  ),
                ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: 'Tip:',
                body: 'adding a specific question can speed up the response.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.lightbulb_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Save & continue', onTap: () => Navigator.pushNamed(context, '/followups/confirm')),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmFollowUpScreen extends StatefulWidget {
  const ConfirmFollowUpScreen({super.key});
  @override
  State<ConfirmFollowUpScreen> createState() => _ConfirmFollowUpScreenState();
}

class _ConfirmFollowUpScreenState extends State<ConfirmFollowUpScreen> {
  bool _cc = true;
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
              _backHeader(context, eyebrow: 'CONFIRM SEND'),
              const SizedBox(height: 12),
              const LbH1('Send to Seva Fund?'),
              const SizedBox(height: 8),
              LbBody("We'll send this and log it in your timeline.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        LbIconTile(icon: Icons.send, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('To: Seva Community Fund', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text('contact@sevacommunity.org', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: LbColors.borderSoft, height: 1),
                    SizedBox(height: 12),
                    LbEyebrow('SUBJECT'),
                    SizedBox(height: 6),
                    Text('Following up — SCF-2026-0183', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 12),
                    LbEyebrow('MESSAGE'),
                    SizedBox(height: 6),
                    Text('"Dear Seva Community Fund team, I\'m following up on behalf of Saikumar regarding application SCF-2026-0183, submitted on 13 April 2026…"', style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCheckbox(label: 'CC me on this email so I have a copy.', value: _cc, onChanged: (v) => setState(() => _cc = v)),
              const SizedBox(height: 16),
              LbButton(label: 'Send follow-up', onTap: () => Navigator.pushNamed(context, '/followups/sent')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/followups/failed'),
                  child: const Text("If sending fails, LifeBridge keeps your draft and retries", style: TextStyle(fontSize: 12, color: LbColors.muted)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpSentScreen extends StatelessWidget {
  const FollowUpSentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.check, color: LbColors.emerald, size: 36)),
              const SizedBox(height: 24),
              const LbH1('Follow-up sent.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We'll let you know the moment Seva Fund responds.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(child: Text('Seva Community Fund', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                        LbBadge(label: 'Follow-up sent', variant: BadgeVariant.submitted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('22 April 2026 · 9:42 AM', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 8),
                    const Text('"Dear Seva Community Fund team, I\'m following up on behalf of Saikumar regarding application SCF-2026-0183…"', style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'Next check-in: 5 days. We\'ll send you a reminder if no response by then.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbButton(label: 'View application', onTap: () => Navigator.pushNamed(context, '/app/detail')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpFailedScreen extends StatelessWidget {
  const FollowUpFailedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.error_outline, color: LbColors.danger, size: 36)),
              const SizedBox(height: 24),
              const LbH1("Couldn't send follow-up.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We hit a temporary issue with the program's portal.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'What happened: ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'Program portal returned a server error. Your draft is safe.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const LbMeta('Error: #NET-5823'),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamed(context, '/followups/confirm')),
              const SizedBox(height: 8),
              LbButton(label: 'Save and retry later', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/followups/history')),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowUpHistoryScreen extends StatelessWidget {
  const FollowUpHistoryScreen({super.key});
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
              _backHeader(context, eyebrow: 'HISTORY'),
              const SizedBox(height: 12),
              const LbH1('Follow-up history'),
              const SizedBox(height: 8),
              LbBody('Every message, every response.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    for (int i = 0; i < s.followUpHistory.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text('${s.followUpHistory[i].programName} — ${s.followUpHistory[i].status.toLowerCase()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                                const Icon(Icons.check, color: LbColors.fg, size: 16),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${s.followUpHistory[i].sentAt?.day ?? 0} April · ${_fmtTime(s.followUpHistory[i].sentAt)}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                            if (s.followUpHistory[i].lastMessage != null) ...[
                              const SizedBox(height: 8),
                              Text('"${s.followUpHistory[i].lastMessage}"', style: const TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Back to follow-ups', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

String _fmtTime(DateTime? d) {
  if (d == null) return '';
  final h = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
  final m = d.minute.toString().padLeft(2, '0');
  final s = d.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $s';
}

class OverdueFollowUpScreen extends StatelessWidget {
  const OverdueFollowUpScreen({super.key});
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
              _backHeader(context, eyebrow: 'OVERDUE'),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: LbColors.danger,
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.access_time, background: LbColors.surface, foreground: LbColors.danger, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seva Community Fund', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('No response in 9 days · 1 follow-up sent', style: TextStyle(fontSize: 12, color: LbColors.fg2)),
                          SizedBox(height: 8),
                          Text("A second follow-up may be appropriate, or consider a phone call to the program.", style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('OPTIONS'),
              const SizedBox(height: 8),
              _OptionRow(icon: Icons.send, title: 'Send a second follow-up', subtitle: 'A gentle second nudge', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
              const SizedBox(height: 8),
              _OptionRow(icon: Icons.call_outlined, title: 'Call the program', subtitle: '+91 8816 927 771 · Mon–Fri 10–5', onTap: () => Navigator.pushNamed(context, '/followups/detail')),
              const SizedBox(height: 8),
              _OptionRow(icon: Icons.add_box_outlined, title: 'Apply to alternatives', subtitle: '3 other programs still open', onTap: () => Navigator.pushNamed(context, '/find-alternative')),
              const SizedBox(height: 24),
              LbButton(label: 'Send second follow-up', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _OptionRow({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: onTap,
      child: Row(
        children: [
          LbIconTile(icon: icon, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
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
          const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
        ],
      ),
    );
  }
}

class NeedMoreHelpScreen extends StatefulWidget {
  const NeedMoreHelpScreen({super.key});
  @override
  State<NeedMoreHelpScreen> createState() => _NeedMoreHelpScreenState();
}

class _NeedMoreHelpScreenState extends State<NeedMoreHelpScreen> {
  final Set<String> selected = {};
  @override
  Widget build(BuildContext context) {
    final items = const [
      'Cost increased',
      'Treatment changed',
      'Application rejected',
      'Application delayed',
      'New financial difficulty',
      'New support need',
      'Other',
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'REASSESS CASE'),
              const SizedBox(height: 12),
              const LbH1('Something changed?'),
              const SizedBox(height: 8),
              LbBody("Tell us and we'll reassess your case. Many programs are designed to support changing circumstances.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "This doesn't cancel anything. Your existing applications stay active.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHAT CHANGED?'),
              const SizedBox(height: 8),
              for (final it in items) ...[
                LbChoice(
                  title: it,
                  checkStyle: true,
                  selected: selected.contains(it),
                  onTap: () => setState(() => selected.contains(it) ? selected.remove(it) : selected.add(it)),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/followups/select-changed')),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectWhatChangedScreen extends StatefulWidget {
  const SelectWhatChangedScreen({super.key});
  @override
  State<SelectWhatChangedScreen> createState() => _SelectWhatChangedScreenState();
}

class _SelectWhatChangedScreenState extends State<SelectWhatChangedScreen> {
  final Set<int> sel = {0, 2};
  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Cost increased', 'Procedure, hospital stay, or medications'),
      ('Treatment changed', 'New diagnosis or revised plan'),
      ('Application rejected', 'One or more programs said no'),
      ('Application delayed', 'Waiting longer than expected'),
      ('New financial difficulty', 'Income or savings changed'),
      ('New support need', 'Travel, equipment, post-op care'),
      ('Other', 'Something not on the list'),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'PICK CHANGES'),
              const SizedBox(height: 12),
              const LbH1('Tell us what changed.'),
              const SizedBox(height: 8),
              LbBody('Pick all that apply.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (int i = 0; i < items.length; i++) ...[
                LbChoice(
                  title: items[i].$1,
                  subtitle: items[i].$2,
                  checkStyle: true,
                  selected: sel.contains(i),
                  onTap: () => setState(() => sel.contains(i) ? sel.remove(i) : sel.add(i)),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/followups/change-details')),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeDetailsScreen extends StatelessWidget {
  const ChangeDetailsScreen({super.key});
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
              _backHeader(context, eyebrow: 'DETAILS'),
              const SizedBox(height: 12),
              const LbH1('Tell us more.'),
              const SizedBox(height: 8),
              LbBody("A short note about each change helps AI find better matches.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        LbIconTile(icon: Icons.add_circle_outline, background: LbColors.warnBg, foreground: LbColors.warn, size: 32, iconSize: 16),
                        SizedBox(width: 8),
                        Text('Cost increased', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const LbField(label: 'New estimated cost', value: '₹5,40,000', keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    const LbField(label: 'Reason (optional)', value: 'Additional tests and 2 extra days of stay', maxLines: 2),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        LbIconTile(icon: Icons.error_outline, background: LbColors.dangerBg, foreground: LbColors.danger, size: 32, iconSize: 16),
                        SizedBox(width: 8),
                        Text('Application rejected', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const LbField(label: 'Which program?', value: 'Seva Community Fund'),
                    const SizedBox(height: 12),
                    const LbField(label: 'Reason (if known)', value: 'Funding priorities — rural first'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/followups/reassessing')),
            ],
          ),
        ),
      ),
    );
  }
}

class ReassessmentProcessingScreen extends StatefulWidget {
  const ReassessmentProcessingScreen({super.key});
  @override
  State<ReassessmentProcessingScreen> createState() => _ReassessmentProcessingScreenState();
}

class _ReassessmentProcessingScreenState extends State<ReassessmentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/followups/updated-gap');
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
              Container(width: 80, height: 80, decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle), alignment: Alignment.center, child: const LbSpinner(size: 48, color: LbColors.accent)),
              const SizedBox(height: 24),
              const LbH1('Reassessing your case…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Looking for new programs and updated matches.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbProcessingRow(text: 'Updated your case details', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Recalculating funding gap…', done: false, spinner: true),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Finding new matches', done: false, spinner: false),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'View updated gap', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushReplacementNamed(context, '/followups/updated-gap')),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdatedGapScreen extends StatelessWidget {
  const UpdatedGapScreen({super.key});
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
              _backHeader(context, eyebrow: 'UPDATED GAP'),
              const SizedBox(height: 12),
              const LbH1('Your updated funding gap.'),
              const SizedBox(height: 8),
              LbBody("Based on the changes you shared.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.accent,
                borderColor: Colors.transparent,
                radius: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('UPDATED GAP', style: TextStyle(fontSize: 11, color: LbColors.surface, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                    const SizedBox(height: 8),
                    const LbNumber('₹3,40,000', size: 36, color: LbColors.surface),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0x33FFFFFF), borderRadius: BorderRadius.circular(999)), child: const Text('Was ₹2,80,000', style: TextStyle(color: LbColors.surface, fontSize: 11, fontWeight: FontWeight.w600))),
                        const SizedBox(width: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0x33FFFFFF), borderRadius: BorderRadius.circular(999)), child: const Text('+₹60,000', style: TextStyle(color: LbColors.surface, fontSize: 11, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('WHY'),
                    SizedBox(height: 8),
                    LbBullet(items: ['Cost went up by ₹60,000 (extra stay + tests)', 'Seva Fund rejected · potential ₹80,000 lost', 'Heart Care Trust approved ₹1,20,000 (pending disbursement)']),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'LifeBridge is finding new options',
                message: '4 new programs match your updated case. 2 of them offer higher benefits than the ones we tried.',
              ),
              const SizedBox(height: 24),
              LbButton(label: 'See new matches', onTap: () => Navigator.pushNamed(context, '/followups/new-matches')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class NewMatchesScreen extends StatelessWidget {
  const NewMatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'NEW MATCHES · ${s.newMatches.length}'),
              const SizedBox(height: 12),
              const LbH1("Programs you haven't tried."),
              const SizedBox(height: 8),
              LbBody("Based on your updated needs and situation.", color: LbColors.muted),
              const SizedBox(height: 16),
              for (final p in s.newMatches) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/support/detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LbIconTile(icon: _iconFor(p.name), background: LbColors.accentSoft, foreground: LbColors.accent, size: 40, iconSize: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(p.organization, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                              ],
                            ),
                          ),
                          LbPill(label: '${p.matchPercent}%', variant: p.pillVariant),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${p.amountLabel} · ${p.deadline ?? "New option"} · ${p.description}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbButton(label: 'Apply to top match', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              LbButton(label: 'Continue assistance', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/followups/reassessment-complete')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/followups/no-matches'),
                  child: const Text('None of these fit? See what LifeBridge does then', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String name) {
  if (name.contains('Hope')) return Icons.add;
  if (name.contains('Manipal')) return Icons.home_outlined;
  if (name.contains('Caring')) return Icons.add_circle_outline;
  if (name.contains('Medication')) return Icons.medication_outlined;
  return Icons.add;
}

class NoMatchesScreen extends StatelessWidget {
  const NoMatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.search, color: LbColors.accent, size: 36)),
              const SizedBox(height: 24),
              const LbH1('No new matches yet.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We searched but didn't find new programs that fit your updated situation.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('WHAT THIS MEANS'),
                    SizedBox(height: 8),
                    LbBullet(items: ['Your existing applications are still active', "We'll keep watching for new programs", 'Updating your details may unlock more']),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbBody("Try uploading additional documents or refining your financial details.", color: LbColors.muted, size: 12, align: TextAlign.center),
              const Spacer(),
              LbButton(label: 'Add documents', onTap: () => Navigator.pushNamed(context, '/docs/center')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class ReassessmentCompleteScreen extends StatelessWidget {
  const ReassessmentCompleteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40)),
              const SizedBox(height: 24),
              const LbH1('Reassessment complete.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Your case is up to date. We'll keep watching for new options.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  children: const [
                    Row(children: [Expanded(child: Text('Updated case', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))), Icon(Icons.check, color: LbColors.emerald, size: 18)]),
                    SizedBox(height: 8),
                    Divider(color: LbColors.borderSoft, height: 1),
                    SizedBox(height: 8),
                    Row(children: [Expanded(child: Text('New funding gap', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))), Text('₹3,40,000', style: TextStyle(color: LbColors.emerald, fontSize: 14, fontWeight: FontWeight.w600))]),
                    SizedBox(height: 8),
                    Divider(color: LbColors.borderSoft, height: 1),
                    SizedBox(height: 8),
                    Row(children: [Expanded(child: Text('New matches', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))), Text('4 found', style: TextStyle(color: LbColors.emerald, fontSize: 14, fontWeight: FontWeight.w600))]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "We'll alert you when new programs open that fit your case.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbButton(label: 'View new matches', onTap: () => Navigator.pushNamed(context, '/followups/new-matches')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}
