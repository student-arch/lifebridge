import 'dart:async';
import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = true;
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
              const SizedBox(height: 32),
              const LbH1('Welcome back.'),
              const SizedBox(height: 8),
              LbBody('Continue where you left off.', color: LbColors.fg2),
              const SizedBox(height: 32),
              const LbField(label: 'Email or phone', value: 'admin@saikumar.link'),
              const SizedBox(height: 16),
              const LbField(label: 'Password', value: '••••••••••', obscure: true),
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
              LbButton(label: 'Log in', onTap: () {
                AppScope.read(context).signIn();
                Navigator.pushReplacementNamed(context, '/home');
              }),
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
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/auth', arguments: const {'tab': 1}),
                  child: const Text.rich(
                    TextSpan(
                      text: 'New to LifeBridge? ',
                      style: TextStyle(color: LbColors.muted, fontSize: 13),
                      children: [TextSpan(text: 'Create an account', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600))],
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

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});
  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  bool _agree = true;
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
                  const LbEyebrow('Phone login'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Sign in with your phone.'),
              const SizedBox(height: 8),
              LbBody("We'll send a one-time code.", color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'Phone number', value: '+91 98 7654 3210', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              LbCheckbox(
                label: "I agree to receive a verification code by SMS. Standard rates may apply.",
                value: _agree,
                onChanged: (v) => setState(() => _agree = v),
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Send code', onTap: () => Navigator.pushNamed(context, '/login-otp')),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});
  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final List<TextEditingController> _ctrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  int _secondsLeft = 32;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrls[0].text = '4';
    _ctrls[1].text = '9';
    _ctrls[2].text = '2';
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft = _secondsLeft > 0 ? _secondsLeft - 1 : 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.length > 1) {
      _ctrls[i].text = v.substring(v.length - 1);
    }
    if (v.isNotEmpty && i < 5) {
      _nodes[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus();
    }
  }

  String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(1, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$m:$ss';
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
                  const LbEyebrow('Verify'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Enter the code we sent.'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: LbBody('Sent to +91 98 7654 3210 · expires in ', color: LbColors.muted)),
                  LbNumber(_fmt(_secondsLeft), size: 15),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  final filled = _ctrls[i].text.isNotEmpty;
                  final active = _nodes[i].hasFocus;
                  return SizedBox(
                    width: 44,
                    height: 56,
                    child: TextField(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      onChanged: (v) => _onChanged(i, v),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: filled ? LbColors.surface2 : LbColors.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: active ? LbColors.accent : LbColors.border, width: active ? 2 : 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: LbColors.accent, width: 2),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              LbInfoBanner(
                title: '',
                body: _secondsLeft == 0 ? "Didn't get it? You can resend now." : "Didn't get it? Send again in ${_secondsLeft}s",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Verify and sign in', onTap: () => Navigator.pushNamed(context, '/login-success')),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});
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
                decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40),
              ),
              const SizedBox(height: 24),
              LbH1('Welcome back, ${s.user.name.split(' ').first}.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Your case is right where you left it.", color: LbColors.muted, align: TextAlign.center),
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
                    LbMeta('Last opened 2 days ago'),
                    const SizedBox(height: 12),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const LbEyebrow('FUNDING GAP'),
                        const Spacer(),
                        const LbNumber('₹2,80,000', size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Continue', onTap: () {
                s.signIn();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
