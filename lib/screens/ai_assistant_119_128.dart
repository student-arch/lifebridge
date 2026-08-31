import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../widgets/components.dart';

Widget _backHeader(BuildContext context, {String? eyebrow, VoidCallback? onBack}) {
  return Row(
    children: [
      LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: onBack ?? () => Navigator.maybePop(context)),
      if (eyebrow != null) ...[const SizedBox(width: 12), LbEyebrow(eyebrow)],
    ],
  );
}

class AIAssistantHomeScreen extends StatelessWidget {
  const AIAssistantHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final suggestions = const [
      ('What should I do next?', Icons.arrow_outward),
      ('Why was this program recommended?', Icons.lightbulb_outline),
      ('What documents am I missing?', Icons.description_outlined),
      ('Help me understand my application.', Icons.assignment_outlined),
      ('Find more assistance.', Icons.search),
      ('What should I do after this rejection?', Icons.help_outline),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'AI ASSISTANT'),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'LifeBridge AI',
                message: "Hi Priya. I can answer questions about Arjun's case, explain recommendations, and help you decide what to do next. What would you like to know?",
              ),
              const SizedBox(height: 20),
              const LbEyebrow('QUICK QUESTIONS'),
              const SizedBox(height: 8),
              for (final s in suggestions) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/ai/chat'),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const LbIconTile(icon: Icons.arrow_outward, background: LbColors.infoBg, foreground: LbColors.accent, size: 32, iconSize: 16),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                      const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
              const SizedBox(height: 16),
              const LbEyebrow('RECENT'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/ai/chat'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('"What happens if Apollo rejects us?"', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text('2 days ago', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: LbButton(label: 'Ask a question', onTap: () => Navigator.pushNamed(context, '/ai/chat')),
      ),
    );
  }
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  final List<_Msg> messages = [
    _Msg(text: 'Hi Priya. What would you like help with today?', fromUser: false),
    _Msg(text: 'What should I do next?', fromUser: true),
    _Msg(text: "Based on your case, I'd suggest one of these next:\n\n1. Upload the income certificate. 3 programs need it and it could unlock up to ₹3.2L in aid. Takes ~5 minutes.\n\n2. Wait for Heart Care Trust's response. Day 2 of 14. No action needed yet.\n\n3. Apply to Apollo Charity Care. 88% match, separate from the others.", fromUser: false),
    _Msg(text: 'Will adding the income certificate really help that much?', fromUser: true),
    _Msg(text: "Yes — but only if you upload it. Without proof of income, three programs can't calculate your eligibility. With it, your total possible aid goes from ₹1.7L to ₹3.2L across open applications.", fromUser: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: _backHeader(context, eyebrow: 'AI ASSISTANT'),
            ),
            Expanded(
              child: ListView.separated(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                itemCount: messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => LbAIBubble(message: messages[i].text, isUser: messages[i].fromUser),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: LbSearch(
                controller: _ctrl,
                hint: 'Ask LifeBridge AI',
                onChanged: (_) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(child: LbButton(label: 'Send', onTap: () {
                    if (_ctrl.text.trim().isEmpty) return;
                    setState(() {
                      messages.add(_Msg(text: _ctrl.text, fromUser: true));
                      _ctrl.clear();
                    });
                    Navigator.pushNamed(context, '/ai/thinking');
                  })),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Sample response', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/ai/response'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool fromUser;
  _Msg({required this.text, required this.fromUser});
}

class AIProcessingScreen extends StatefulWidget {
  const AIProcessingScreen({super.key});
  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/ai/response');
    });
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
              _backHeader(context, eyebrow: 'THINKING…'),
              const SizedBox(height: 12),
              const LbAIBubble(message: 'Why was Heart Care Trust recommended?', isUser: true),
              const SizedBox(height: 8),
              const LbAIBubble(
                extra: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      LbSpinner(size: 16, color: LbColors.accent),
                      SizedBox(width: 8),
                      Text('LifeBridge AI is thinking…', style: TextStyle(fontSize: 12, color: LbColors.muted, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                message: '',
              ),
              const SizedBox(height: 16),
              LbBody('Most answers arrive in under 5 seconds.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'View answer', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushReplacementNamed(context, '/ai/response')),
            ],
          ),
        ),
      ),
    );
  }
}

class AIResponseScreen extends StatelessWidget {
  const AIResponseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final reasons = const [
      'Cardiac-specific — focuses on procedures like Arjun\'s',
      'Income threshold met (₹6.4L < ₹8L cap)',
      'Karnataka resident match',
      'Verified by LifeBridge on 12 March 2026',
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'AI ASSISTANT'),
              const SizedBox(height: 12),
              const LbAIBubble(message: 'Why was Heart Care Trust recommended?', isUser: true),
              const SizedBox(height: 8),
              const LbAIBubble(
                message: 'Heart Care Trust came up because of four reasons. None of them are guarantees — the trust still reviews every application independently.',
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < reasons.length; i++) ...[
                LbCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text('${i + 1}', style: const TextStyle(color: LbColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(reasons[i], style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbBody('Match score: 92%. The strongest fit we found.', color: LbColors.muted, size: 12, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/ai/action')),
              const SizedBox(height: 8),
              LbButton(label: 'Ask another question', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/ai/assistant')),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ai/cant-determine'),
                  child: const Text.rich(
                    TextSpan(
                      text: "LifeBridge brings in a ",
                      style: TextStyle(fontSize: 12, color: LbColors.muted),
                      children: [TextSpan(text: 'human advisor', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600)), TextSpan(text: ' when needed')],
                    ),
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

class AIActionScreen extends StatelessWidget {
  const AIActionScreen({super.key});
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
              _backHeader(context, eyebrow: 'SUGGESTED ACTION'),
              const SizedBox(height: 12),
              const LbAIBubble(
                title: 'LifeBridge AI · suggested action',
                message: 'Send a follow-up to Seva Community Fund.\n\n9 days without a response. A polite follow-up is appropriate and can speed up decisions by an average of 6 days.',
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHAT I'LL DO IF YOU CONFIRM"),
                    SizedBox(height: 8),
                    LbBullet(items: ['Draft a polite follow-up email', 'Wait for you to review and edit', "Send it through the program's portal", 'Log the action in your timeline']),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "This affects an external system. I won't send anything until you tap Confirm.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Confirm and continue', onTap: () => Navigator.pushNamed(context, '/ai/action-confirm')),
              const SizedBox(height: 8),
              LbButton(label: 'Not now', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/ai/chat')),
            ],
          ),
        ),
      ),
    );
  }
}

class AIActionConfirmationScreen extends StatefulWidget {
  const AIActionConfirmationScreen({super.key});
  @override
  State<AIActionConfirmationScreen> createState() => _AIActionConfirmationScreenState();
}

class _AIActionConfirmationScreenState extends State<AIActionConfirmationScreen> {
  bool _review = false;
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
              _backHeader(context, eyebrow: 'CONFIRM'),
              const SizedBox(height: 12),
              const LbH1('Send the follow-up?'),
              const SizedBox(height: 8),
              LbBody("It will go to Seva Community Fund via their portal.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbKeyValue(label: 'ACTION', value: 'Send follow-up'),
                    LbKeyValue(label: 'TO', value: 'Seva Community Fund'),
                    LbKeyValue(label: 'APPLICATION', value: 'SCF-2026-0183'),
                    LbKeyValue(label: 'CHANNEL', value: 'Program portal'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCheckbox(label: "I want to review the message before it's sent.", value: _review, onChanged: (v) => setState(() => _review = v)),
              const SizedBox(height: 16),
              LbButton(label: 'Confirm and draft', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
              const SizedBox(height: 8),
              LbButton(label: 'Cancel', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/ai/chat')),
            ],
          ),
        ),
      ),
    );
  }
}

class AINeedsInfoScreen extends StatefulWidget {
  const AINeedsInfoScreen({super.key});
  @override
  State<AINeedsInfoScreen> createState() => _AINeedsInfoScreenState();
}

class _AINeedsInfoScreenState extends State<AINeedsInfoScreen> {
  int _sel = 0;
  bool _remember = false;
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
              _backHeader(context, eyebrow: 'NEED MORE INFO'),
              const SizedBox(height: 12),
              const LbAIBubble(message: "To answer well, I need one more detail from you."),
              const SizedBox(height: 12),
              const LbH1('Quick question.'),
              const SizedBox(height: 8),
              LbBody('Helps me give a more accurate answer.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Are you asking about the funding gap after insurance, or before?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3)),
                    const SizedBox(height: 16),
                    for (int i = 0; i < 3; i++) ...[
                      LbChoice(title: ['After insurance', 'Before insurance', "I'm not sure"][i], selected: _sel == i, onTap: () => setState(() => _sel = i)),
                      if (i < 2) const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCheckbox(label: 'Remember my preference for next time.', value: _remember, onChanged: (v) => setState(() => _remember = v)),
              const SizedBox(height: 16),
              LbButton(label: 'Submit', onTap: () => Navigator.pushNamed(context, '/ai/response')),
            ],
          ),
        ),
      ),
    );
  }
}

class AICantDetermineScreen extends StatelessWidget {
  const AICantDetermineScreen({super.key});
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
              _backHeader(context, eyebrow: 'LIMITS'),
              const SizedBox(height: 12),
              const LbAIBubble(message: "I'm not able to answer that question. Here's why and what to do next."),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: 'WHY',
                body: "I don't have access to the final cost for your specific procedure. Hospital billing varies and depends on choices made during the surgery. I'd rather not guess — incorrect estimates could mislead your funding plan.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHAT TO DO'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/help'),
                child: Row(
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Call Apollo billing office', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('+91 80 4040 1060 · Mon–Sat 9–5', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/ai/human'),
                child: Row(
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Talk to a human', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Connect with a LifeBridge specialist', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Ask another question', onTap: () => Navigator.pushNamed(context, '/ai/chat')),
            ],
          ),
        ),
      ),
    );
  }
}

class HumanEscalationScreen extends StatelessWidget {
  const HumanEscalationScreen({super.key});
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
              _backHeader(context, eyebrow: 'TALK TO A HUMAN'),
              const SizedBox(height: 12),
              const LbH1('Talk to a care specialist.'),
              const SizedBox(height: 8),
              LbBody("For complex situations, our team can help directly.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Row(
                  children: const [
                    LbAvatar(text: 'LB', size: 44),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LifeBridge care team', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Mon–Sat 9 AM – 7 PM IST · response in ~30 min', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          SizedBox(height: 6),
                          Text('A specialist reviews your case end-to-end and replies with next steps.', style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('HOW TO REACH US'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/ai/chat'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.chat_bubble_outline, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('In-app chat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Fastest · attached to your case', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () {},
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.call_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('+91 80 4567 8900 · free call', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () {},
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.mail_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('care@lifebridge.app · reply in 4h', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Open in-app chat', onTap: () => Navigator.pushNamed(context, '/ai/chat')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}
