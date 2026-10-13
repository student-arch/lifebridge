import '../../models/models.dart';
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
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
              const LbEyebrow('PROFILE'),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  children: [
                    LbAvatar(text: s.user.initials, size: 64),
                    const SizedBox(height: 12),
                    Text(s.user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Text('${s.user.role.split(' / ').first} · ${s.user.city}, ${_stateAbbrev(s.user.state)}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 12),
                    LbButton(label: 'Edit profile', variant: LbButtonVariant.secondary, fontSize: 13, height: 40, onTap: () => Navigator.pushNamed(context, '/profile/edit')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('PATIENT'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/case/detail'),
                child: Row(
                  children: [
                    LbAvatar(text: s.patient.initials, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.patient.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${s.patient.relationship} · Age ${s.patient.age}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    const Text('View case →', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('ACCOUNT'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.settings_outlined, title: 'Settings', subtitle: 'Preferences, privacy, security', onTap: () => Navigator.pushNamed(context, '/settings')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.notifications_none, title: 'Notifications', subtitle: 'Channels, events, quiet hours', onTap: () => Navigator.pushNamed(context, '/settings/notifications')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.shield_outlined, title: 'Security', subtitle: 'Password, biometrics, devices', onTap: () => Navigator.pushNamed(context, '/settings/security')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('SUPPORT'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.help_outline, title: 'Help & FAQ', subtitle: 'Common questions', onTap: () => Navigator.pushNamed(context, '/help')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.info_outline, title: 'About LifeBridge', subtitle: 'Version, principles', onTap: () => Navigator.pushNamed(context, '/about')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbButton(label: 'Sign out', variant: LbButtonVariant.danger, onTap: () => Navigator.pushNamed(context, '/signout')),
            ],
          ),
        ),
      ),
    );
  }
}

String _stateAbbrev(String s) {
  switch (s) {
    case 'Karnataka': return 'KA';
    default: return s;
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _phone = TextEditingController();
  late final TextEditingController _dob = TextEditingController();
  late final TextEditingController _city = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = AppScope.read(context);
    _name.text = s.user.name;
    _email.text = s.user.email;
    _phone.text = s.user.phone;
    _dob.text = s.user.dob;
    _city.text = '${s.user.city}, ${s.user.state}';
  }

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
              _backHeader(context, eyebrow: 'EDIT PROFILE'),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    LbAvatar(text: s.user.initials, size: 80),
                    const SizedBox(height: 8),
                    LbButton(label: 'Change photo', variant: LbButtonVariant.ghost, fontSize: 13, height: 40, onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbField(label: 'Full name', controller: _name),
              const SizedBox(height: 12),
              LbField(label: 'Email', controller: _email),
              const SizedBox(height: 12),
              LbField(label: 'Phone', controller: _phone),
              const SizedBox(height: 12),
              LbField(label: 'Date of birth', controller: _dob),
              const SizedBox(height: 12),
              LbField(label: 'City', controller: _city),
              const SizedBox(height: 32),
              LbButton(label: 'Save changes', onTap: () {
                s.updateUser(name: _name.text, email: _email.text, phone: _phone.text, dob: _dob.text, city: _city.text.split(',').first.trim());
                Navigator.pop(context);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
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
              _backHeader(context, eyebrow: 'SETTINGS'),
              const SizedBox(height: 16),
              const LbEyebrow('PREFERENCES'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.notifications_none, title: 'Notifications', subtitle: 'Push, email, in-app', onTap: () => Navigator.pushNamed(context, '/settings/notifications')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.history, title: 'Recent notifications', subtitle: 'Last 7 days', onTap: () => Navigator.pushNamed(context, '/notifications')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.shield_outlined, title: 'Privacy & consent', subtitle: 'Data sharing, AI usage', onTap: () => Navigator.pushNamed(context, '/settings/privacy')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.extension_outlined, title: 'Data sharing', subtitle: 'Connected organizations', onTap: () => Navigator.pushNamed(context, '/settings/data-sharing')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(
                      icon: Icons.smart_toy_outlined,
                      title: 'AI assistant',
                      subtitle: s.aiConfigured ? 'Model · ${s.aiModel}' : 'Not configured',
                      onTap: () => Navigator.pushNamed(context, '/settings/ai'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('SECURITY'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.lock_outline, title: 'Password', subtitle: 'Last changed 3 months ago', onTap: () => Navigator.pushNamed(context, '/settings/change-password')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.fingerprint, title: 'Biometric login', subtitle: 'Face ID · enabled', onTap: () => Navigator.pushNamed(context, '/settings/biometric')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.extension, title: 'Connected services', subtitle: '2 active · 1 pending', onTap: () => Navigator.pushNamed(context, '/settings/connected-orgs')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: LbColors.danger,
                onTap: () => Navigator.pushNamed(context, '/emergency'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.wb_sunny, background: LbColors.surface, foreground: LbColors.danger, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emergency', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: LbColors.danger)),
                          SizedBox(height: 2),
                          Text('Hospital, blood, financial — 24/7', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbButton(label: 'Sign out', variant: LbButtonVariant.danger, onTap: () => Navigator.pushNamed(context, '/signout')),
              const SizedBox(height: 8),
              LbButton(label: 'About LifeBridge', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/about')),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationPrefsScreen extends StatefulWidget {
  const NotificationPrefsScreen({super.key});
  @override
  State<NotificationPrefsScreen> createState() => _NotificationPrefsScreenState();
}

class _NotificationPrefsScreenState extends State<NotificationPrefsScreen> {
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Notification preferences'),
              const SizedBox(height: 8),
              LbBody('Choose what you hear about and how.', color: LbColors.muted),
              const SizedBox(height: 20),
              const LbEyebrow('CHANNELS'),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Push notifications', icon: Icons.notifications_active, value: s.pushEnabled, onChanged: s.setPush),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Email', icon: Icons.mail_outline, value: s.emailEnabled, onChanged: s.setEmail),
              const SizedBox(height: 8),
              LbToggleRow(title: 'SMS', icon: Icons.sms_outlined, value: s.smsEnabled, onChanged: s.setSms),
              const SizedBox(height: 16),
              const LbEyebrow('EVENTS'),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Application updates', icon: Icons.assignment_outlined, value: true, onChanged: (_) {}),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Document requests', icon: Icons.description_outlined, value: true, onChanged: (_) {}),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Follow-up reminders', icon: Icons.access_time, value: true, onChanged: (_) {}),
              const SizedBox(height: 8),
              LbToggleRow(title: 'New support matches', icon: Icons.add, value: true, onChanged: (_) {}),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Deadlines', icon: Icons.event, value: true, onChanged: (_) {}),
              const SizedBox(height: 16),
              const LbEyebrow('QUIET HOURS'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: LbField(label: 'From', value: s.quietFrom, keyboardType: TextInputType.datetime)),
                  const SizedBox(width: 12),
                  Expanded(child: LbField(label: 'To', value: s.quietTo, keyboardType: TextInputType.datetime)),
                ],
              ),
              const SizedBox(height: 12),
              LbBody('Urgent program updates will still come through quiet hours.', color: LbColors.muted, size: 12),
              const SizedBox(height: 24),
              LbButton(label: 'Save preferences', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});
  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  final _url = TextEditingController();
  final _key = TextEditingController();
  final _model = TextEditingController();
  bool _init = false;
  bool _fetching = false;
  List<String>? _models;
  String? _fetchError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      _init = true;
      final s = AppScope.read(context);
      _url.text = s.aiBaseUrl;
      _key.text = s.aiApiKey;
      _model.text = s.aiModel;
    }
  }

  @override
  void dispose() {
    _url.dispose();
    _key.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _fetchModels() async {
    if (_fetching) return;
    setState(() {
      _fetching = true;
      _fetchError = null;
    });
    try {
      final ids = await AiService.fetchModels(baseUrl: _url.text, apiKey: _key.text);
      if (!mounted) return;
      setState(() {
        _models = ids;
        _fetching = false;
      });
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() {
        _fetchError = e.message;
        _fetching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _fetchError = 'Could not fetch models. Check the base URL and key, or type the model name manually.';
        _fetching = false;
      });
    }
  }

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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('AI assistant setup'),
              const SizedBox(height: 8),
              LbBody('Connect any OpenAI-compatible AI. Every assistant, analysis, and draft in the app uses these settings.', color: LbColors.muted),
              const SizedBox(height: 20),
              LbField(label: 'Base URL', hint: 'https://api.openai.com/v1', controller: _url, keyboardType: TextInputType.url),
              const SizedBox(height: 16),
              LbField(label: 'Model', hint: 'e.g. gpt-4o-mini', controller: _model),
              const SizedBox(height: 12),
              LbButton(
                label: _fetching ? 'Fetching models…' : 'Fetch available models',
                variant: LbButtonVariant.secondary,
                onTap: _fetching ? null : _fetchModels,
              ),
              if (_fetching) ...[
                const SizedBox(height: 12),
                const Row(
                  children: [
                    LbSpinner(size: 16, color: LbColors.accent),
                    SizedBox(width: 8),
                    Text('Asking the provider for its model list…', style: TextStyle(fontSize: 13, color: LbColors.muted, fontStyle: FontStyle.italic)),
                  ],
                ),
              ],
              if (_fetchError != null) ...[
                const SizedBox(height: 12),
                LbAIBubble(title: 'Could not fetch models', message: _fetchError!),
              ],
              if (_models != null) ...[
                const SizedBox(height: 16),
                LbEyebrow('AVAILABLE MODELS · ${_models!.length}'),
                const SizedBox(height: 8),
                for (final id in _models!) ...[
                  LbChoice(
                    title: id,
                    selected: _model.text.trim() == id,
                    onTap: () => setState(() => _model.text = id),
                  ),
                  const SizedBox(height: 8),
                ],
                LbBody('Tap a model to select it, then save below. All AI features use the saved model.', color: LbColors.muted, size: 12),
              ],
              const SizedBox(height: 16),
              LbField(label: 'API key', hint: 'Stored only on this device', controller: _key, obscure: true),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: s.aiConfigured ? 'Status: configured (model · ${s.aiModel}).' : 'Status: not configured.',
                body: 'Your key stays on this phone and is sent only to the base URL above. It is never shown, logged, or shared.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.shield_outlined,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Save AI settings', onTap: () {
                AppScope.read(context).saveAiSettings(baseUrl: _url.text, apiKey: _key.text, model: _model.text);
                Navigator.pop(context);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Privacy & consent'),
              const SizedBox(height: 8),
              LbBody('Your information, your rules.', color: LbColors.muted),
              const SizedBox(height: 20),
              const LbEyebrow('AI ASSISTANCE'),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Analyze my case with AI', subtitle: 'Required for matching programs', icon: Icons.auto_awesome, value: s.aiAnalyze, onChanged: s.setAiAnalyze),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Extract document fields', subtitle: 'Auto-fill applications', icon: Icons.description_outlined, value: s.aiExtract, onChanged: s.setAiExtract),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Draft application responses', subtitle: 'You review before sending', icon: Icons.edit_outlined, value: s.aiDraft, onChanged: s.setAiDraft),
              const SizedBox(height: 16),
              const LbEyebrow('DATA'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.extension_outlined, title: 'Data sharing', subtitle: 'Programs, integrations', onTap: () => Navigator.pushNamed(context, '/settings/data-sharing')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.download_outlined, title: 'Download my data', subtitle: 'Export everything', onTap: () => Navigator.pushNamed(context, '/help')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.delete_outline, title: 'Delete my account', subtitle: 'Permanent', onTap: () => Navigator.pushNamed(context, '/help'), trailingWidget: const SizedBox.shrink()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'AI assists with suggestions. You confirm every action that touches an external system.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Save preferences', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class DataSharingScreen extends StatefulWidget {
  const DataSharingScreen({super.key});
  @override
  State<DataSharingScreen> createState() => _DataSharingScreenState();
}

class _DataSharingScreenState extends State<DataSharingScreen> {
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Data sharing'),
              const SizedBox(height: 8),
              LbBody('Where your information goes when you submit an application.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "We never share with a program until you tap Submit. You can withdraw any application.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              const LbEyebrow('CONNECTED ORGANIZATIONS'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/settings/connected-orgs'),
                child: Row(
                  children: const [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Heart Care Trust', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Application submitted', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    LbPill(label: 'ACTIVE', variant: PillVariant.info),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/settings/connected-orgs'),
                child: Row(
                  children: const [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('State Treatment Scheme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Application submitted', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    ])),
                    LbPill(label: 'ACTIVE', variant: PillVariant.info),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('INTEGRATIONS'),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Email (Gmail)', subtitle: 'Auto-detect follow-up replies', icon: Icons.mail_outline, value: s.autoDetectReplies, onChanged: s.setAutoDetect),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Calendar (iCal)', subtitle: 'Add deadlines to your calendar', icon: Icons.calendar_today_outlined, value: s.calendarSync, onChanged: s.setCalendar),
              const SizedBox(height: 24),
              LbButton(label: 'Back to privacy', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Security'),
              const SizedBox(height: 8),
              LbBody('Keep your account and documents safe.', color: LbColors.muted),
              const SizedBox(height: 20),
              const LbEyebrow('LOGIN'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    LbListRow(icon: Icons.lock_outline, title: 'Change password', subtitle: 'Last changed 3 months ago', onTap: () => Navigator.pushNamed(context, '/settings/change-password')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    LbListRow(icon: Icons.fingerprint, title: 'Biometric login', subtitle: 'Face ID · enabled', onTap: () => Navigator.pushNamed(context, '/settings/biometric')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('DEVICES'),
              const SizedBox(height: 8),
              LbCard(
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.check, color: LbColors.emerald, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('This iPhone 15 Pro', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('iOS 18 · Bengaluru · Active now', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    const LbPill(label: 'CURRENT', variant: PillVariant.success),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('SESSION'),
              const SizedBox(height: 8),
              LbToggleRow(title: 'Auto sign-out', subtitle: 'After 15 minutes of inactivity', icon: Icons.access_time, value: s.autoSignout, onChanged: s.setAutoSignout),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "If you ever lose your phone, use Find My iPhone and change your password immediately.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Done', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Change password'),
              const SizedBox(height: 8),
              LbBody("Make sure it's at least 10 characters.", color: LbColors.muted),
              const SizedBox(height: 20),
              const LbField(label: 'Current password', obscure: true, value: '••••••••••••'),
              const SizedBox(height: 12),
              const LbField(label: 'New password', obscure: true, value: '••••••••••••', helper: '10+ chars · number · symbol', helperColor: LbColors.emerald),
              const SizedBox(height: 12),
              const LbField(label: 'Confirm new password', obscure: true, value: '••••••••••••', helper: 'Passwords match.', helperColor: LbColors.emerald),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "You'll stay signed in on this device, but we'll sign you out everywhere else.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Update password', onTap: () => Navigator.pushNamed(context, '/settings/security')),
            ],
          ),
        ),
      ),
    );
  }
}

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Use Face ID to sign in.'),
              const SizedBox(height: 8),
              LbBody("Faster and more secure than typing your password.", color: LbColors.muted),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  children: const [
                    LbAvatar(text: '😊', size: 84),
                    SizedBox(height: 12),
                    Text('Face ID is enabled', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text("You'll use it next time you open LifeBridge", style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('HOW IT WORKS'),
                    SizedBox(height: 8),
                    LbBullet(items: ['Face data stays on your device', 'LifeBridge never sees or stores it', 'You can switch back to password any time']),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Done', onTap: () => Navigator.pop(context)),
              const SizedBox(height: 8),
              LbButton(label: 'Disable Face ID', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectedOrgsScreen extends StatelessWidget {
  const ConnectedOrgsScreen({super.key});
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
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('Connected organizations'),
              const SizedBox(height: 8),
              LbBody("Programs with access to your case data. You can revoke any time.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(child: Text('Heart Care Trust', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                        LbPill(label: 'ACTIVE', variant: PillVariant.info),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('App HCT-2026-04812 · patient profile + 3 docs', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: LbButton(label: 'View data shared', variant: LbButtonVariant.secondary, fontSize: 12, height: 40, onTap: () {})),
                        const SizedBox(width: 8),
                        Expanded(child: LbButton(label: 'Revoke', variant: LbButtonVariant.secondary, fontSize: 12, height: 40, foreground: LbColors.danger, onTap: () {})),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(child: Text('State Treatment Scheme', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                        LbPill(label: 'ACTIVE', variant: PillVariant.info),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('App STS-2026-7740 · patient profile + 4 docs', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: LbButton(label: 'View data shared', variant: LbButtonVariant.secondary, fontSize: 12, height: 40, onTap: () {})),
                        const SizedBox(width: 8),
                        Expanded(child: LbButton(label: 'Revoke', variant: LbButtonVariant.secondary, fontSize: 12, height: 40, foreground: LbColors.danger, onTap: () {})),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Row(
                  children: [
                    LbIconTile(icon: Icons.add, background: LbColors.surface, foreground: LbColors.muted, size: 40, iconSize: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Apollo Charity Care', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Apply to share your data with them', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    const Text('Apply →', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Done', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpFAQScreen extends StatelessWidget {
  const HelpFAQScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = const [
      ('How do I know my data is safe?', '/ai/human'),
      ('My situation changed — what do I do?', '/followups/need-help'),
      ('Can I opt out of AI suggestions?', '/settings/privacy'),
      ('How do I revoke access for a program?', '/settings/connected-orgs'),
      ('Troubleshooting: what if something fails?', '/states/network-error'),
      ('What if I get signed out unexpectedly?', '/states/session-expired'),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context),
              const SizedBox(height: 12),
              const LbH1('How can we help?'),
              const SizedBox(height: 8),
              LbBody('Common questions or talk to a human.', color: LbColors.muted),
              const SizedBox(height: 16),
              const LbSearch(hint: 'Search the help center'),
              const SizedBox(height: 16),
              const LbEyebrow('POPULAR QUESTIONS'),
              const SizedBox(height: 8),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      LbListRow(icon: Icons.help_outline, title: items[i].$1, onTap: () => Navigator.pushNamed(context, items[i].$2), trailing: null),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/ai/human'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.support_agent_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chat with a specialist', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Avg response: 6 min', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Contact support', onTap: () => Navigator.pushNamed(context, '/ai/human')),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(color: LbColors.accent, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, color: LbColors.surface, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: LbH1('LifeBridge')),
              const SizedBox(height: 4),
              const Center(child: Text('Version 1.0.0 · Build 2026.04', style: TextStyle(fontSize: 12, color: LbColors.muted))),
              const SizedBox(height: 16),
              LbBody('Compassionate assistance, made simple. We help patients and caregivers find and apply to financial, medical, and community support — without the overwhelm.', color: LbColors.fg2, align: TextAlign.center, height: 1.5),
              const SizedBox(height: 20),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('OUR PRINCIPLES'),
                    SizedBox(height: 8),
                    LbBullet(items: ['AI assists, you decide', 'Your data stays yours', 'Every program is verified', 'No fake medical claims']),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: LbButton(label: 'Help', variant: LbButtonVariant.secondary, fontSize: 13, height: 40, onTap: () => Navigator.pushNamed(context, '/help'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Privacy', variant: LbButtonVariant.secondary, fontSize: 13, height: 40, onTap: () => Navigator.pushNamed(context, '/settings/privacy'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Terms', variant: LbButtonVariant.secondary, fontSize: 13, height: 40, onTap: () => Navigator.pushNamed(context, '/help'))),
                ],
              ),
              const SizedBox(height: 16),
              const Center(child: Text('© 2026 LifeBridge Foundation', style: TextStyle(fontSize: 11, color: LbColors.muted))),
              const SizedBox(height: 16),
              LbButton(label: 'Done', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.logout, color: LbColors.warn, size: 36)),
              const SizedBox(height: 24),
              const LbH1('Sign out of LifeBridge?', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("You'll need your password to sign back in. Face ID will be disabled until you re-enable it.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbInfoBanner(
                title: '',
                body: 'Active applications and follow-up reminders will continue running on our server — your case data stays safe.',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbButton(label: 'Sign out', variant: LbButtonVariant.danger, onTap: () {
                AppScope.read(context).signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
              }),
              const SizedBox(height: 8),
              LbButton(label: 'Cancel', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
