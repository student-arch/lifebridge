import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../widgets/components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progress = 0;
  Timer? _timer;
  bool _navigated = false;
  late final AnimationController _anim;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _start();
  }

  void _go() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _progress += 0.04);
      if (_progress >= 1) {
        t.cancel();
        _go();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final shortest = mq.size.shortestSide;
    final logo = (shortest * 0.26).clamp(72.0, 104.0);
    final iconSize = (shortest * 0.12).clamp(36.0, 52.0);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: _go,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [LbColors.surface, LbColors.bg],
                  ),
                ),
              ),
              Positioned(
                top: -shortest * 0.18,
                right: -shortest * 0.18,
                child: Container(
                  width: shortest * 0.6,
                  height: shortest * 0.6,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: LbColors.accentSoft),
                ),
              ),
              Positioned(
                bottom: -shortest * 0.22,
                left: -shortest * 0.22,
                child: Container(
                  width: shortest * 0.65,
                  height: shortest * 0.65,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: LbColors.infoBg),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    ScaleTransition(
                      scale: _scale,
                      child: FadeTransition(
                        opacity: _fade,
                        child: Container(
                          width: logo,
                          height: logo,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [LbColors.accent2, LbColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: LbColors.accent.withValues(alpha: 0.35),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.health_and_safety_outlined, color: LbColors.surface, size: iconSize),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _fade,
                      child: const LbH1('LifeBridge'),
                    ),
                    const SizedBox(height: 8),
                    FadeTransition(
                      opacity: _fade,
                      child: LbBody('Compassionate assistance, made simple.', color: LbColors.muted, align: TextAlign.center),
                    ),
                    const Spacer(flex: 4),
                    LbMeta('Getting things ready…', color: LbColors.muted),
                    const SizedBox(height: 12),
                    Container(
                      width: 160,
                      height: 5,
                      decoration: BoxDecoration(color: LbColors.borderSoft, borderRadius: BorderRadius.circular(999)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progress.clamp(0, 1),
                        child: Container(decoration: BoxDecoration(color: LbColors.accent, borderRadius: BorderRadius.circular(999))),
                      ),
                    ),
                    const SizedBox(height: 24),
                    LbMeta('v1.0.0', color: LbColors.muted),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final shortest = mq.size.shortestSide;
    final illustrationSize = (shortest * 0.45).clamp(140.0, 220.0);
    final iconSize = (shortest * 0.13).clamp(40.0, 64.0);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: illustrationSize,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(24)),
                        alignment: Alignment.center,
                        child: Icon(Icons.favorite_outline, size: iconSize, color: LbColors.accent),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const LbEyebrow('Welcome'),
                    const SizedBox(height: 10),
                    const LbH1('Support for the moments that matter most.'),
                    const SizedBox(height: 12),
                    LbBody(
                      'LifeBridge helps patients and caregivers find financial, medical, and community assistance — and stay organized while doing it.',
                      color: LbColors.fg2,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LbButton(label: 'Get started', onTap: () => Navigator.pushReplacementNamed(context, '/auth', arguments: const {'tab': 1})),
                  const SizedBox(height: 8),
                  LbButton(
                    label: 'I already have an account',
                    variant: LbButtonVariant.ghost,
                    onTap: () => Navigator.pushReplacementNamed(context, '/auth', arguments: const {'tab': 0}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingShell extends StatelessWidget {
  final int step;
  final String eyebrow;
  final String title;
  final String body;
  final String nextRoute;
  final Widget? illustration;
  final List<Widget>? extra;
  const _OnboardingShell({
    required this.step,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.nextRoute,
    this.illustration,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final shortest = mq.size.shortestSide;
    final illustrationSize = (shortest * 0.42).clamp(120.0, 200.0);
    final iconSize = (shortest * 0.16).clamp(48.0, 80.0);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: LbTextButton(
                  label: 'Skip',
                  onTap: () => Navigator.pushNamed(context, '/get-started'),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: illustrationSize,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(24)),
                        alignment: Alignment.center,
                        child: illustration ?? Icon(Icons.search, size: iconSize, color: LbColors.accent),
                      ),
                    ),
                    const SizedBox(height: 24),
                    LbEyebrow(eyebrow),
                    const SizedBox(height: 8),
                    LbH1(title, align: TextAlign.center),
                    const SizedBox(height: 12),
                    LbBody(body, color: LbColors.fg2, align: TextAlign.center),
                    if (extra != null) ...[
                      const SizedBox(height: 20),
                      ...extra!,
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PageDots(current: step, total: 3),
                  const SizedBox(height: 12),
                  LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, nextRoute)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int current;
  final int total;
  const _PageDots({required this.current, required this.total});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i + 1 == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? LbColors.accent : LbColors.border,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.16;
    return _OnboardingShell(
      step: 1,
      eyebrow: 'Step 1 of 3',
      title: 'Find programs that fit your situation.',
      body: 'We match you with hospital, community, and government support based on your real needs.',
      nextRoute: '/onboarding/2',
      illustration: Icon(Icons.travel_explore_outlined, size: size.clamp(48.0, 80.0), color: LbColors.accent),
    );
  }
}

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.16;
    return _OnboardingShell(
      step: 2,
      eyebrow: 'Step 2 of 3',
      title: 'An assistant that explains, never decides.',
      body: 'AI helps draft applications, summarize documents, and suggest next steps — but you always confirm.',
      nextRoute: '/onboarding/3',
      illustration: Icon(Icons.auto_awesome, size: size.clamp(48.0, 80.0), color: LbColors.accent),
    );
  }
}

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.16;
    return _OnboardingShell(
      step: 3,
      eyebrow: 'Step 3 of 3',
      title: 'Your information stays yours.',
      body: 'Documents are encrypted, and you choose exactly what to share with each program.',
      nextRoute: '/get-started',
      illustration: Icon(Icons.shield_outlined, size: size.clamp(48.0, 80.0), color: LbColors.accent),
      extra: [
        _TrustRow(icon: Icons.lock_outline, title: 'End-to-end encryption', meta: 'Documents are stored with AES-256.'),
        const SizedBox(height: 8),
        _TrustRow(icon: Icons.check_circle_outline, title: 'You approve every share', meta: 'No data leaves without your tap.'),
      ],
    );
  }
}

class _TrustRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String meta;
  const _TrustRow({required this.icon, required this.title, required this.meta});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: icon == Icons.check_circle_outline ? LbColors.successBg : LbColors.infoBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: icon == Icons.check_circle_outline ? LbColors.emerald : LbColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: LbColors.fg, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
