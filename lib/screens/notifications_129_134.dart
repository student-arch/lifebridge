import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

Widget _backHeader(BuildContext context, {String? eyebrow, VoidCallback? onBack}) {
  return Row(
    children: [
      LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: onBack ?? () => Navigator.maybePop(context)),
      if (eyebrow != null) ...[const SizedBox(width: 12), LbEyebrow(eyebrow)],
    ],
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
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
              _backHeader(context, eyebrow: 'NOTIFICATIONS'),
              const SizedBox(height: 12),
              const LbH1('Notifications'),
              const SizedBox(height: 8),
              LbBody('Updates on applications, documents, and follow-ups.', color: LbColors.muted),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    LbPill(label: 'ALL · 7', variant: PillVariant.accent),
                    const SizedBox(width: 8),
                    LbPill(label: 'APPLICATIONS', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'DOCUMENTS', variant: PillVariant.neutral),
                    const SizedBox(width: 8),
                    LbPill(label: 'FOLLOW-UPS', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final n in s.notifications) ...[
                LbCard(
                  onTap: () {
                    s.markNotificationRead(n.id);
                    final target = switch (n.target) {
                      'app' => '/notifications/app-update',
                      'doc' => '/notifications/doc-required',
                      'followup' => '/notifications/followup-reminder',
                      'match' => '/notifications/new-match',
                      'deadline' => '/notifications/deadline',
                      _ => null,
                    };
                    if (target != null) Navigator.pushNamed(context, target);
                  },
                  child: Row(
                    children: [
                      LbIconSquare(
                        icon: _iconFor(n.variant),
                        background: _bgFor(n.variant),
                        foreground: _fgFor(n.variant),
                        size: 36,
                        iconSize: 18,
                        radius: 10,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: n.unread ? LbColors.fg : LbColors.fg2),
                                  ),
                                ),
                                if (n.unread) Container(width: 7, height: 7, decoration: const BoxDecoration(color: LbColors.danger, shape: BoxShape.circle)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(n.meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
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

  IconData _iconFor(String v) {
    switch (v) {
      case 'info': return Icons.assignment_outlined;
      case 'warn': return Icons.description_outlined;
      case 'danger': return Icons.access_time;
      case 'accent': return Icons.add;
      case 'success': return Icons.check_circle_outline;
      default: return Icons.notifications_none;
    }
  }
  Color _bgFor(String v) {
    switch (v) {
      case 'info': return LbColors.infoBg;
      case 'warn': return LbColors.warnBg;
      case 'danger': return LbColors.dangerBg;
      case 'accent': return LbColors.accentSoft;
      case 'success': return LbColors.successBg;
      default: return LbColors.surface2;
    }
  }
  Color _fgFor(String v) {
    switch (v) {
      case 'info': return LbColors.accent;
      case 'warn': return LbColors.warn;
      case 'danger': return LbColors.danger;
      case 'accent': return LbColors.accent;
      case 'success': return LbColors.emerald;
      default: return LbColors.fg;
    }
  }
}

class ApplicationUpdateScreen extends StatelessWidget {
  const ApplicationUpdateScreen({super.key});
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
              _backHeader(context, eyebrow: 'NOTIFICATION'),
              const SizedBox(height: 12),
              Row(
                children: [
                  LbIconTile(icon: Icons.assignment_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Application received', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                        SizedBox(height: 2),
                        Text('22 April · 9:41 AM · HCT-2026-04812', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("Heart Care Trust has received your application and assigned it reference HCT-2026-04812. The team will begin their initial review within 1–2 business days.", color: LbColors.fg2, height: 1.5),
              const SizedBox(height: 16),
              const LbEyebrow("WHAT'S NEXT"),
              const SizedBox(height: 8),
              LbCard(
                child: Column(
                  children: const [
                    _NextRow(label: 'Initial review (1–2 days)', active: true),
                    SizedBox(height: 12),
                    _NextRow(label: 'Full review (up to 14 days)'),
                    SizedBox(height: 12),
                    _NextRow(label: 'Decision notification'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: LbButton(label: 'View application', onTap: () => Navigator.pushNamed(context, '/app/detail'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Apply to more', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/find-alternative'))),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Text('Mark as read', style: TextStyle(fontSize: 13, color: LbColors.muted)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextRow extends StatelessWidget {
  final String label;
  final bool active;
  const _NextRow({required this.label, this.active = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: active ? LbColors.accent : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: active ? LbColors.accent : LbColors.border, width: 2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: active ? LbColors.fg : LbColors.muted))),
      ],
    );
  }
}

class DocumentRequiredScreen extends StatelessWidget {
  const DocumentRequiredScreen({super.key});
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
              _backHeader(context, eyebrow: 'DOCUMENT NEEDED'),
              const SizedBox(height: 12),
              Row(
                children: [
                  LbIconTile(icon: Icons.description_outlined, background: LbColors.warnBg, foreground: LbColors.warn, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Seva Fund needs 1 document', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                        SizedBox(height: 2),
                        Text('21 April · 3:12 PM · SCF-2026-0183', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("To continue reviewing your application, the program needs a recent cost breakdown from the hospital.", color: LbColors.fg2, height: 1.5),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/docs/upload'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: LbColors.warn, width: 1.5, style: BorderStyle.solid)),
                  child: Row(
                    children: [
                      Container(width: 36, height: 36, decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.description_outlined, color: LbColors.warn, size: 18)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cost breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('Itemized estimate from hospital billing', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "Add it to your case — we'll attach it to the application automatically.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Upload document', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
              const SizedBox(height: 8),
              LbButton(label: 'Snooze 24h', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/notifications')),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowupReminderScreen extends StatelessWidget {
  const FollowupReminderScreen({super.key});
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
              _backHeader(context, eyebrow: 'FOLLOW-UP REMINDER'),
              const SizedBox(height: 12),
              Row(
                children: [
                  LbIconTile(icon: Icons.access_time, background: LbColors.dangerBg, foreground: LbColors.danger, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('9 days without a response', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                        SizedBox(height: 2),
                        Text('22 April · 8:00 AM · Seva Community Fund', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("Seva Fund usually responds in 5 days. A polite follow-up often gets a response within 48 hours.", color: LbColors.fg2, height: 1.5),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'Suggested action',
                body: "Send a follow-up today. I can draft it for you to review.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Draft a follow-up', onTap: () => Navigator.pushNamed(context, '/followups/draft')),
              const SizedBox(height: 8),
              LbButton(label: 'View all follow-ups', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class NewSupportMatchScreen extends StatelessWidget {
  const NewSupportMatchScreen({super.key});
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
              _backHeader(context, eyebrow: 'NEW MATCH'),
              const SizedBox(height: 12),
              Row(
                children: [
                  LbIconTile(icon: Icons.add, background: LbColors.accentSoft, foreground: LbColors.accent, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hope Foundation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                        SizedBox(height: 2),
                        Text('20 April · 11:32 AM · 89% match', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                  const LbPill(label: 'NEW', variant: PillVariant.success),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("Hope Foundation funds cardiac care for families earning below ₹8LPA. Up to ₹2,00,000 in aid — higher than your current top match.", color: LbColors.fg2, height: 1.5),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.add_circle_outline, background: LbColors.surface, foreground: LbColors.accent, size: 36, iconSize: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Up to ₹2,00,000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Verified 18 April 2026', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'View program', onTap: () => Navigator.pushNamed(context, '/support/detail')),
              const SizedBox(height: 8),
              LbButton(label: 'Apply now', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

class DeadlineReminderScreen extends StatelessWidget {
  const DeadlineReminderScreen({super.key});
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
              _backHeader(context, eyebrow: 'DEADLINE'),
              const SizedBox(height: 12),
              Row(
                children: [
                  LbIconTile(icon: Icons.access_time, background: LbColors.warnBg, foreground: LbColors.warn, size: 48, iconSize: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Heart Care Trust — 15 days left', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                        SizedBox(height: 2),
                        Text('Application closes 7 May 2026', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LbBody("Your application is already submitted, but the program stops accepting new applications 7 days before the procedure date. Make sure all follow-up documents arrive on time.", color: LbColors.fg2, height: 1.5),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "Respond to any document requests from the program within 5 days, or the application may be put on hold.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'View application', onTap: () => Navigator.pushNamed(context, '/app/detail')),
              const SizedBox(height: 8),
              LbButton(label: 'Snooze for 7 days', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/notifications')),
            ],
          ),
        ),
      ),
    );
  }
}
