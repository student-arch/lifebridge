import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../services/ai_service.dart';
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

  // Greeting only — every answer below it comes from the configured AI.
  final List<_Msg> messages = [
    _Msg(text: "Hi! I'm LifeBridge AI. Ask me anything about the case, programs, documents, or next steps.", fromUser: false),
  ];
  bool _sending = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _sending) return;
    final s = AppScope.read(context);
    setState(() {
      messages.add(_Msg(text: text, fromUser: true));
      _ctrl.clear();
      _sending = true;
    });
    _scrollDown();
    String reply;
    var failed = false;
    try {
      reply = await s.askAi(
        task: "Answer the user's question about their patient-assistance case. Use the earlier conversation for context.",
        messages: [for (final m in messages) AiChatMessage(role: m.fromUser ? 'user' : 'assistant', content: m.text)],
      );
    } on AiException catch (e) {
      reply = e.message;
      failed = true;
    } catch (_) {
      reply = 'Something went wrong reaching the AI. Check your connection and settings, then try again.';
      failed = true;
    }
    if (!mounted) return;
    setState(() {
      messages.add(_Msg(text: reply, fromUser: false, error: failed));
      _sending = false;
    });
    _scrollDown();
  }

  void _clearChat() {
    if (_sending) return;
    setState(() {
      messages
        ..clear()
        ..add(_Msg(text: "Hi! I'm LifeBridge AI. Ask me anything about the case, programs, documents, or next steps.", fromUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    String model = 'your AI model';
    try {
      model = AppScope.read(context).aiModel;
    } catch (_) {}
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(child: _backHeader(context, eyebrow: 'AI ASSISTANT')),
                  LbTextButton(label: 'New chat', onTap: _sending ? null : _clearChat),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                itemCount: messages.length + (_sending ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  if (i >= messages.length) {
                    return const LbAIBubble(
                      message: '',
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
                    );
                  }
                  final m = messages[i];
                  if (m.fromUser) return LbAIBubble(message: m.text, isUser: true);
                  if (m.error) {
                    return LbAIBubble(
                      title: 'Something went wrong',
                      message: m.text,
                      extra: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Fix the issue above, then send your message again.', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ),
                    );
                  }
                  return LbAIBubble(title: 'LifeBridge AI · $model', message: m.text);
                },
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
              child: LbButton(label: _sending ? 'Thinking…' : 'Send', onTap: _sending ? null : _send),
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
  final bool error;
  _Msg({required this.text, required this.fromUser, this.error = false});
}

class AIProcessingScreen extends StatefulWidget {
  const AIProcessingScreen({super.key});
  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    final question = args is Map ? (args['question'] as String? ?? '') : '';
    if (question.trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/ai/response');
      });
      return;
    }
    _run(question);
  }

  Future<void> _run(String question) async {
    final s = AppScope.read(context);
    try {
      final answer = await s.askAi(
        task: 'Answer the user question about their patient-assistance case concisely.',
        messages: [AiChatMessage(role: 'user', content: question)],
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/ai/response', arguments: {'question': question, 'answer': answer});
    } on AiException catch (e) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/ai/response', arguments: {'question': question, 'error': e.message});
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/ai/response', arguments: {'question': question, 'error': 'Something went wrong reaching the AI. Check your connection and settings, then try again.'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final question = args is Map ? (args['question'] as String? ?? 'Thinking…') : 'Thinking…';
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
              LbAIBubble(message: question, isUser: true),
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
              LbButton(label: 'Cancel', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class AIResponseScreen extends StatefulWidget {
  const AIResponseScreen({super.key});
  @override
  State<AIResponseScreen> createState() => _AIResponseScreenState();
}

class _AIResponseScreenState extends State<AIResponseScreen> {
  bool _started = false;
  bool _loading = false;
  String _question = '';
  String? _answer;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _question = (args['question'] as String? ?? '').trim();
      _answer = args['answer'] as String?;
      _error = args['error'] as String?;
    }
    // Arrived with a question but no answer yet: generate it live.
    if (_question.isNotEmpty && _answer == null && _error == null) {
      _loading = true;
      _run(_question);
    }
  }

  Future<void> _run(String question) async {
    final s = AppScope.read(context);
    try {
      final answer = await s.askAi(
        task: 'Answer the user question about their patient-assistance case concisely.',
        messages: [AiChatMessage(role: 'user', content: question)],
      );
      if (!mounted) return;
      setState(() {
        _answer = answer;
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, eyebrow: 'AI ASSISTANT'),
              const SizedBox(height: 12),
              if (_question.isEmpty && _answer == null && _error == null && !_loading) ...[
                const LbAIBubble(
                  title: 'No answer yet',
                  message: 'Ask a question in the AI chat first — answers appear here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Open AI chat', onTap: () => Navigator.pushNamed(context, '/ai/chat')),
              ] else ...[
                if (_question.isNotEmpty) ...[
                  LbAIBubble(message: _question, isUser: true),
                  const SizedBox(height: 8),
                ],
                if (_loading)
                  const LbAIBubble(
                    message: '',
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
                  ),
                if (_error != null) ...[
                  LbAIBubble(title: 'Something went wrong', message: _error!),
                  const SizedBox(height: 16),
                  LbButton(
                    label: 'Try again',
                    onTap: () {
                      setState(() {
                        _error = null;
                        _loading = true;
                      });
                      _run(_question);
                    },
                  ),
                ],
                if (_answer != null) ...[
                  LbAIBubble(title: 'LifeBridge AI', message: _answer!),
                  const SizedBox(height: 8),
                  LbBody('Generated by ${_modelName(context)} for your case. Verify important details with the program.', color: LbColors.muted, size: 12, align: TextAlign.center),
                  const SizedBox(height: 16),
                  LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/ai/action', arguments: {'context': 'Q: $_question\nA: $_answer'})),
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _modelName(BuildContext context) {
    try {
      return AppScope.read(context).aiModel;
    } catch (_) {
      return 'your AI model';
    }
  }
}

class AIActionScreen extends StatefulWidget {
  const AIActionScreen({super.key});
  @override
  State<AIActionScreen> createState() => _AIActionScreenState();
}

class _AIActionScreenState extends State<AIActionScreen> {
  bool _started = false;
  bool _loading = true;
  String? _suggestion;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    final prior = args is Map ? (args['context'] as String? ?? '') : '';
    _run(prior);
  }

  Future<void> _run(String prior) async {
    final s = AppScope.read(context);
    try {
      final text = await s.askAi(
        task: 'Suggest ONE concrete next action for the case (2-4 sentences, plain language). '
            'Ground it in the case data. If prior conversation is given, build on it. Do not invent approvals or deadlines.',
        messages: [AiChatMessage(role: 'user', content: prior.isEmpty ? 'What single action should I take next on this case?' : 'Conversation so far:\n$prior\n\nWhat single action should I take next?')],
      );
      if (!mounted) return;
      setState(() {
        _suggestion = text;
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

  void _retry() {
    final args = ModalRoute.of(context)?.settings.arguments;
    final prior = args is Map ? (args['context'] as String? ?? '') : '';
    setState(() {
      _error = null;
      _loading = true;
    });
    _run(prior);
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
              _backHeader(context, eyebrow: 'SUGGESTED ACTION'),
              const SizedBox(height: 12),
              if (_loading)
                const LbAIBubble(
                  title: 'LifeBridge AI · suggested action',
                  message: '',
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
                ),
              if (_error != null) ...[
                LbAIBubble(title: 'Something went wrong', message: _error!),
                const SizedBox(height: 12),
                LbButton(label: 'Try again', onTap: _retry),
              ],
              if (_suggestion != null)
                LbAIBubble(
                  title: 'LifeBridge AI · suggested action',
                  message: _suggestion!,
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
              LbButton(label: 'Submit', onTap: () {
                const opts = ['After insurance', 'Before insurance', "I'm not sure"];
                final q = 'Funding-gap question: is the gap calculated after insurance or before? '
                    'My clarification: ${opts[_sel]}. Please answer the funding-gap question accordingly.';
                Navigator.pushReplacementNamed(context, '/ai/thinking', arguments: {'question': q});
              }),
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
