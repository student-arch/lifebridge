import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

/// Single authentication entry point reached straight after the splash.
///
/// Two tabs share one screen:
///   tab 0 — Log in (email/phone + password, the essentials only)
///   tab 1 — Sign up (name + email/phone + password, the essentials only)
///
/// Everything else (date of birth, city, patient details, permissions) is
/// deliberately NOT asked here — it can be completed later via
/// Profile > Edit profile, Settings, or the case-creation flow.
///
/// Open a specific tab with:
///   Navigator.pushNamed(context, '/auth', arguments: {'tab': 1});
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _tab = 0;
  bool _tabInit = false;

  // Log-in fields.
  final _loginId = TextEditingController(text: 'arjun.rao@example.com');
  final _loginPass = TextEditingController(text: '••••••••••');
  bool _remember = true;

  // Sign-up fields (essentials only).
  final _name = TextEditingController();
  final _signupId = TextEditingController();
  final _signupPass = TextEditingController();
  bool _agree = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tabInit) {
      _tabInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['tab'] == 1) _tab = 1;
    }
  }

  @override
  void dispose() {
    _loginId.dispose();
    _loginPass.dispose();
    _name.dispose();
    _signupId.dispose();
    _signupPass.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  void _logIn() {
    AppScope.read(context).signIn();
    _goHome();
  }

  void _signUp() {
    final s = AppScope.read(context);
    final id = _signupId.text.trim();
    final name = _name.text.trim().isEmpty ? 'New User' : _name.text.trim();
    if (id.contains('@')) {
      s.updateUser(name: name, email: id);
    } else {
      s.updateUser(name: name, phone: id);
    }
    s.completeRegistration();
    s.completeOnboarding();
    _goHome();
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
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: LbColors.accent, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.health_and_safety_outlined, color: LbColors.surface, size: 28),
                ),
              ),
              const SizedBox(height: 24),
              LbH1(_tab == 0 ? 'Welcome back.' : 'Create your account.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody(
                _tab == 0 ? 'Continue where you left off.' : 'One quick step — the rest can wait.',
                color: LbColors.fg2,
                align: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _SegmentedTab(
                selected: _tab,
                onTap: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 24),
              if (_tab == 0) ..._loginBody(context) else ..._signupBody(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _loginBody(BuildContext context) {
    return [
      LbField(label: 'Email or phone', controller: _loginId),
      const SizedBox(height: 16),
      LbField(label: 'Password', controller: _loginPass, obscure: true),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: LbCheckbox(
              label: 'Remember me',
              value: _remember,
              onChanged: (v) => setState(() => _remember = v),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/forgot'),
            child: const Text('Forgot password?', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      const SizedBox(height: 24),
      LbButton(label: 'Log in', onTap: _logIn),
      const SizedBox(height: 20),
      Row(
        children: [
          const Expanded(child: Divider(color: LbColors.borderSoft, height: 1)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: LbMeta('or')),
          const Expanded(child: Divider(color: LbColors.borderSoft, height: 1)),
        ],
      ),
      const SizedBox(height: 20),
      LbButton(
        label: 'Continue with phone',
        variant: LbButtonVariant.secondary,
        leadingIcon: Icons.grid_view_outlined,
        onTap: () => Navigator.pushNamed(context, '/login-phone'),
      ),
    ];
  }

  List<Widget> _signupBody(BuildContext context) {
    return [
      LbField(label: 'Full name', hint: 'e.g. Priya Rao', controller: _name, autofocus: true),
      const SizedBox(height: 16),
      LbField(label: 'Email or phone', hint: 'e.g. priya.rao@example.com', controller: _signupId, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 16),
      LbField(label: 'Password', hint: 'At least 10 characters with a number', controller: _signupPass, obscure: true),
      const SizedBox(height: 16),
      LbCheckbox(
        label: 'I agree to the Terms of Service and Privacy Policy.',
        value: _agree,
        onChanged: (v) => setState(() => _agree = v),
      ),
      const SizedBox(height: 24),
      LbButton(label: 'Create account', onTap: _signUp),
      const SizedBox(height: 16),
      LbBody('You can add details like date of birth and city later in Profile.', color: LbColors.muted, size: 13, align: TextAlign.center),
    ];
  }
}

class _SegmentedTab extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _SegmentedTab({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(999)),
      child: Row(
        children: [
          _segItem(0, 'Log in'),
          _segItem(1, 'Sign up'),
        ],
      ),
    );
  }

  Widget _segItem(int index, String label) {
    final active = selected == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? LbColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: active ? Border.all(color: LbColors.border) : null,
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: active ? LbColors.fg : LbColors.muted),
          ),
        ),
      ),
    );
  }
}
