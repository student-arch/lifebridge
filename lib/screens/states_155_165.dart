import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../widgets/components.dart';

class GlobalLoadingScreen extends StatelessWidget {
  const GlobalLoadingScreen({super.key});
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
                  const LbSpinner(size: 28, color: LbColors.accent),
                  const SizedBox(width: 12),
                  const Text('Updating…', style: TextStyle(fontSize: 13, color: LbColors.muted)),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                height: 24,
                width: 220,
                decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.only(right: 80),
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: 160,
                decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 8),
                    Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 200, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 140, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(child: LbBody('Loading usually takes a couple of seconds.', color: LbColors.muted, size: 12, align: TextAlign.center)),
              const SizedBox(height: 16),
              LbButton(label: 'Continue to Home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonLoadingScreen extends StatelessWidget {
  const SkeletonLoadingScreen({super.key});
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
              Container(height: 18, width: 140, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 8),
              Container(height: 14, width: 200, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 24),
              LbCard(
                child: Row(
                  children: [
                    Container(width: 40, height: 40, decoration: const BoxDecoration(color: LbColors.surface2, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 14, width: 130, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 6),
                          Container(height: 12, width: 90, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                child: Row(
                  children: [
                    Container(width: 40, height: 40, decoration: const BoxDecoration(color: LbColors.surface2, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 14, width: 160, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 6),
                          Container(height: 12, width: 110, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                child: Row(
                  children: [
                    Container(width: 40, height: 40, decoration: const BoxDecoration(color: LbColors.surface2, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 14, width: 130, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 6),
                          Container(height: 12, width: 80, decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'View loaded screen', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/app/list', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});
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
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
                  const SizedBox(width: 12),
                  const LbEyebrow('APPLICATIONS'),
                ],
              ),
              const SizedBox(height: 60),
              LbEmptyState(
                title: 'No applications yet.',
                subtitle: "When you apply to a support program, it'll show up here for tracking.",
                icon: Icons.description_outlined,
                ctaLabel: 'Find programs',
                onCta: () => Navigator.pushNamed(context, '/app/create'),
              ),
              const SizedBox(height: 20),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('QUICK START'),
                    SizedBox(height: 8),
                    LbBullet(items: ['Complete your case (5 min)', 'Review AI-suggested matches', 'Tap a program to start an application']),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
                  child: const Text('Back to home', style: TextStyle(color: LbColors.muted, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.wifi_off, color: LbColors.warn, size: 36)),
              const SizedBox(height: 24),
              const LbH1("You're offline.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody('No internet connection right now. Your work is saved locally.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHAT STILL WORKS"),
                    SizedBox(height: 8),
                    LbBullet(items: ['Viewing previously loaded screens', 'Drafting new applications (saved on device)', 'Reading your case history'], dotColor: LbColors.emerald),
                  ],
                ),
              ),
              const Spacer(),
              LbBody("When you reconnect, we'll sync everything automatically.", color: LbColors.muted, size: 13, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});
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
              const LbH1("Couldn't reach LifeBridge.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("A temporary issue with our servers or your connection.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'What happened: ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'The request timed out after 30 seconds. This is usually brief.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const LbMeta('Error: #NET-4080'),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamed(context, '/states/retry')),
              const SizedBox(height: 8),
              LbButton(label: 'Go to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class GenericErrorScreen extends StatelessWidget {
  const GenericErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.cancel_outlined, color: LbColors.danger, size: 36)),
              const SizedBox(height: 24),
              const LbH1('Something went wrong.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("An unexpected issue stopped this from completing.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'What you can do: ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'Try again, or contact support with the error ID below if it keeps happening.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(8)),
                    child: const Text('ERR-7A92-3F18', style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  LbButton(label: 'Copy', variant: LbButtonVariant.ghost, fontSize: 12, height: 32, onTap: () {}),
                ],
              ),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamed(context, '/states/retry')),
              const SizedBox(height: 8),
              LbButton(label: 'Contact support', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/ai/human')),
            ],
          ),
        ),
      ),
    );
  }
}

class RetryScreen extends StatelessWidget {
  const RetryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle)),
                  const LbSpinner(size: 80, color: LbColors.accent),
                  const Icon(Icons.refresh, color: LbColors.accent, size: 32),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Retrying…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody('Attempt 2 of 3 · waiting 4s before next try.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  children: const [
                    _AttemptRow(state: 'failed', label: '1 · just now'),
                    SizedBox(height: 10),
                    _AttemptRow(state: 'active', label: '2 · in progress…'),
                    SizedBox(height: 10),
                    _AttemptRow(state: 'queued', label: '3 · queued'),
                  ],
                ),
              ),
              const Spacer(),
              LbBody("If this keeps failing, contact support with the error ID.", color: LbColors.muted, size: 12, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Cancel and go back', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  final String state;
  final String label;
  const _AttemptRow({required this.state, required this.label});
  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (state == 'failed') {
      leading = Container(width: 16, height: 16, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.close, color: LbColors.danger, size: 10));
    } else if (state == 'active') {
      leading = Container(width: 16, height: 16, alignment: Alignment.center, child: const LbSpinner(size: 16, color: LbColors.accent));
    } else {
      leading = Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: LbColors.border)));
    }
    return Row(
      children: [
        leading,
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: state == 'queued' ? LbColors.muted : LbColors.fg))),
      ],
    );
  }
}

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(color: LbColors.accentSoft, borderRadius: BorderRadius.circular(24)), alignment: Alignment.center, child: const Icon(Icons.camera_alt_outlined, color: LbColors.accent, size: 40)),
              const SizedBox(height: 24),
              const LbH1('Allow camera access?', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We use the camera only when you're capturing documents. Photos never leave your device unless you submit them.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHAT WE'LL DO"),
                    SizedBox(height: 8),
                    LbBullet(items: ['Open the camera in the app', 'Capture and auto-enhance the document', 'Encrypt and add to your case']),
                  ],
                ),
              ),
              const Spacer(),
              LbBody("You can revoke this any time in iOS Settings.", color: LbColors.muted, size: 12, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Allow camera', onTap: () => Navigator.pushNamed(context, '/docs/camera')),
              const SizedBox(height: 8),
              LbButton(label: 'Not now', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.infoBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.lock_outline, color: LbColors.accent, size: 38)),
              const SizedBox(height: 24),
              const LbH1("You've been signed out.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("For your security, sessions end after 15 minutes of inactivity.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbInfoBanner(
                title: 'Your data is safe.',
                body: 'Your case and applications are unchanged. Sign in to continue.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbBody("Frequent sign-outs? Try increasing your session length in Settings.", color: LbColors.muted, size: 12, align: TextAlign.center),
              const SizedBox(height: 16),
              LbButton(label: 'Sign in', onTap: () => Navigator.pushReplacementNamed(context, '/auth')),
              const SizedBox(height: 8),
              LbButton(label: 'Use Face ID', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushReplacementNamed(context, '/auth')),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionSuccessScreen extends StatelessWidget {
  const ActionSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40)),
              const SizedBox(height: 24),
              const LbH1('Done.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody('Your changes are saved.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  children: const [
                    _ConfirmRow(text: 'Saved just now'),
                    SizedBox(height: 10),
                    _ConfirmRow(text: 'Synced across devices'),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String text;
  const _ConfirmRow({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: const BoxDecoration(color: LbColors.emerald, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.check, color: LbColors.surface, size: 10)),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class ActionFailedScreen extends StatelessWidget {
  const ActionFailedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.cancel_outlined, color: LbColors.danger, size: 38)),
              const SizedBox(height: 24),
              const LbH1("Action didn't complete.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Something stopped the update from saving.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'Your input was preserved. ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: "Nothing was lost — you can try again or come back later."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const LbMeta('Error: #ACT-7041'),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushNamed(context, '/states/retry')),
              const SizedBox(height: 8),
              LbButton(label: 'Discard and exit', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}
