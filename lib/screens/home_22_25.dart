import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HomeHeader(),
              const SizedBox(height: 12),
              const _Greeting(),
              const SizedBox(height: 16),
              const _HeroCaseCard(),
              const SizedBox(height: 12),
              const _NextStepCard(),
              const SizedBox(height: 20),
              const _ApplicationsSection(),
              const SizedBox(height: 20),
              const _RecommendedSection(),
              const SizedBox(height: 20),
              const _UpcomingSection(),
              const SizedBox(height: 16),
              const _ReassessCard(),
              const SizedBox(height: 12),
              const _AskAICard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final unread = s.notifications.where((n) => n.unread).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        children: [
          const Text('LifeBridge', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
          const Spacer(),
          LbCircleButton(
            icon: Icons.chat_bubble_outline,
            background: LbColors.surface,
            foreground: LbColors.fg,
            size: 44,
            semanticLabel: 'Ask LifeBridge AI',
            onTap: () => Navigator.pushNamed(context, '/ai/assistant'),
          ),
          const SizedBox(width: 6),
          LbCircleButton(
            icon: Icons.notifications_none,
            background: LbColors.surface,
            foreground: LbColors.fg,
            size: 44,
            semanticLabel: 'Notifications, $unread unread',
            badge: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: LbColors.danger,
                shape: BoxShape.circle,
                border: Border.all(color: LbColors.surface, width: 1.5),
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          const SizedBox(width: 6),
          LbCircleButton(
            icon: Icons.person,
            background: LbColors.fg,
            foreground: LbColors.surface,
            size: 44,
            semanticLabel: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile/view'),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final hour = DateTime.now().hour;
    final partOfDay = hour < 12
        ? 'morning'
        : hour < 17
            ? 'afternoon'
            : 'evening';
    final firstName = s.user.name.split(' ').first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: LbH1('Good $partOfDay,\n$firstName.'),
    );
  }
}

class _HeroCaseCard extends StatelessWidget {
  const _HeroCaseCard();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return LbCard(
      padding: const EdgeInsets.all(24),
      radius: 32,
      background: LbColors.accent,
      onTap: () => Navigator.pushNamed(context, '/case/detail'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Color(0x2EFFFFFF), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.favorite, color: LbColors.surface, size: 22),
              ),
              const SizedBox(width: 12),
              const Text('Your case', style: TextStyle(color: LbColors.surface, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(s.mainCase.title, style: const TextStyle(color: LbColors.surface, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Color(0x2EFFFFFF), borderRadius: BorderRadius.circular(999)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: LbColors.surface, size: 6),
                SizedBox(width: 6),
                Text('Action needed', style: TextStyle(color: LbColors.surface, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const LbNumber('₹2,80,000', size: 34, color: LbColors.surface),
          const SizedBox(height: 4),
          const Text('funding gap remaining', style: TextStyle(color: LbColors.surface, fontSize: 12)),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('Support journey', style: TextStyle(color: LbColors.surface, fontSize: 12, fontWeight: FontWeight.w500)),
              Spacer(),
              Text('3 of 6 steps', style: TextStyle(color: LbColors.surface, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(color: Color(0x33FFFFFF), borderRadius: BorderRadius.circular(999)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              child: Container(decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(999))),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next: upload income certificate', style: TextStyle(color: LbColors.surface, fontSize: 13, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text('3 programs need this to confirm eligibility', style: TextStyle(color: LbColors.surface, fontSize: 11)),
                  ],
                ),
              ),
              LbCtaCircle(icon: Icons.arrow_outward, background: LbColors.surface, foreground: LbColors.accent, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard();
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: () => Navigator.pushNamed(context, '/docs/upload'),
      child: Row(
        children: [
          const LbIconTile(icon: Icons.cloud_upload_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 48, iconSize: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload your income document', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('Needed for 2 applications · 5 min', style: TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          const LbCtaCircle(icon: Icons.arrow_forward, size: 44),
        ],
      ),
    );
  }
}

class _ApplicationsSection extends StatelessWidget {
  const _ApplicationsSection();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final apps = s.applications;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const LbEyebrow('APPLICATIONS IN PROGRESS'),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/app/list'),
                child: const Text('See all', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < apps.length; i++) ...[
                if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                _AppRow(app: apps[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AppRow extends StatelessWidget {
  final dynamic app;
  const _AppRow({required this.app});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/app/detail'),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            LbIconSquare(icon: _appIcon(app.programName), background: _appBg(app.programName), foreground: LbColors.fg, size: 40, iconSize: 20, radius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.programName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(_appSubtitle(app), style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            LbBadge(label: app.status, variant: app.statusVariant),
          ],
        ),
      ),
    );
  }
}

IconData _appIcon(String name) {
  if (name.contains('Hospital')) return Icons.local_hospital_outlined;
  if (name.contains('Trust')) return Icons.favorite_outline;
  if (name.contains('State')) return Icons.account_balance_outlined;
  return Icons.description_outlined;
}

Color _appBg(String name) {
  if (name.contains('Hospital')) return LbColors.dangerBg;
  if (name.contains('Trust')) return LbColors.warnBg;
  if (name.contains('State')) return LbColors.infoBg;
  return LbColors.surface2;
}

String _appSubtitle(dynamic app) {
  if (app.programName.contains('Hospital')) return 'Apollo Hospitals · Updated 2h ago';
  if (app.programName.contains('Trust')) return 'Seva Trust · 1 document missing';
  return 'Awaiting department response';
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: LbEyebrow('RECOMMENDED FOR YOU')),
        const SizedBox(height: 12),
        LbCard(
          onTap: () => Navigator.pushNamed(context, '/support/detail'),
          child: Row(
            children: [
              const LbIconTile(icon: Icons.favorite_outline, background: LbColors.accentSoft, foreground: LbColors.accent, size: 48, iconSize: 22),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text('Heart Care Trust', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                        SizedBox(width: 8),
                        LbPill(label: '92% match', variant: PillVariant.success),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('Up to ₹1,50,000 · Verified · Deadline 30 Apr', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LbCard(
            padding: const EdgeInsets.all(16),
            onTap: () => Navigator.pushNamed(context, '/followups/draft'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    LbDot(color: LbColors.warn),
                    SizedBox(width: 6),
                    Text('Follow-up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: LbColors.warn)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('No response · 4 days', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text('Seva Trust', style: TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LbCard(
            padding: const EdgeInsets.all(16),
            background: LbColors.dangerBg,
            borderColor: LbColors.dangerBg,
            onTap: () => Navigator.pushNamed(context, '/emergency'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    LbDot(color: LbColors.danger),
                    SizedBox(width: 6),
                    Text('Emergency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: LbColors.danger)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Hospital helpline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text('Available 24/7', style: TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReassessCard extends StatelessWidget {
  const _ReassessCard();
  @override
  Widget build(BuildContext context) {
    return LbCard(
      background: LbColors.surface2,
      borderColor: Colors.transparent,
      onTap: () => Navigator.pushNamed(context, '/followups/need-help'),
      child: Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Something changed?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("Cost, treatment, or new need — we'll reassess your case", style: TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: LbColors.muted),
        ],
      ),
    );
  }
}

class _AskAICard extends StatelessWidget {
  const _AskAICard();
  @override
  Widget build(BuildContext context) {
    return LbCard(
      background: LbColors.accent,
      borderColor: Colors.transparent,
      radius: 32,
      onTap: () => Navigator.pushNamed(context, '/ai/assistant'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Color(0x2EFFFFFF), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.auto_awesome, color: LbColors.surface, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ask LifeBridge', style: TextStyle(color: LbColors.surface, fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('"What should I do next?"', style: TextStyle(color: LbColors.surface, fontSize: 12)),
              ],
            ),
          ),
          const LbCtaCircle(icon: Icons.arrow_forward, background: LbColors.surface, foreground: LbColors.accent, size: 40),
        ],
      ),
    );
  }
}

class HomeEmptyScreen extends StatelessWidget {
  const HomeEmptyScreen({super.key});
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
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: LbMeta('TUESDAY · 22 APRIL')),
              const SizedBox(height: 8),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: LbH1('Hi, Priya.')),
              const SizedBox(height: 16),
              LbCard(
                padding: const EdgeInsets.all(22),
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: Column(
                  children: [
                    const LbIconTile(icon: Icons.add, background: LbColors.accent, foreground: LbColors.surface, size: 56, iconSize: 28),
                    const SizedBox(height: 16),
                    LbH2('No active case yet.', align: TextAlign.center),
                    const SizedBox(height: 8),
                    LbBody(
                      'Create a case to find programs, prepare applications, and get support along the way.',
                      color: LbColors.fg2,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LbButton(label: 'Start a case', onTap: () => Navigator.pushNamed(context, '/case/intro')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: LbEyebrow('WHAT YOU CAN DO')),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  children: [
                    _BulletRow(text: 'Find programs that fit your situation'),
                    _BulletRow(text: 'Organize your documents once, reuse forever'),
                    _BulletRow(text: 'Track every application and follow-up'),
                    _BulletRow(text: 'Reassess your case as things change'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: LbEyebrow('EMERGENCY?')),
              const SizedBox(height: 12),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/emergency'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.emergency_outlined, background: LbColors.dangerBg, foreground: LbColors.danger, size: 44, iconSize: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emergency hub', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: LbColors.danger)),
                          SizedBox(height: 2),
                          Text('Hospital · blood · financial — 24/7', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted),
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

class _BulletRow extends StatelessWidget {
  final String text;
  const _BulletRow({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 7, right: 10), child: LbDot(color: LbColors.accent)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: LbColors.fg))),
        ],
      ),
    );
  }
}

class HomeActiveScreen extends StatelessWidget {
  const HomeActiveScreen({super.key});
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
              const Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: LbMeta('TUESDAY · 22 APRIL')),
              const SizedBox(height: 8),
              const LbH1('Hi, Priya.'),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        LbMeta(s.mainCase.title, color: LbColors.fg),
                        const Spacer(),
                        const LbBadge(label: 'On track', variant: BadgeVariant.approved),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('${s.patient.name} · ${s.hospital.city}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: LbColors.fg2)),
                    const SizedBox(height: 12),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LbEyebrow('FUNDING GAP'),
                              SizedBox(height: 6),
                              LbNumber('₹2,80,000', size: 20),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LbEyebrow('REVIEW'),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                
                                children: const [
                                  LbNumber('Day 2', size: 20),
                                  SizedBox(width: 4),
                                  Text(' of 14', style: TextStyle(color: LbColors.muted, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: LbEyebrow('NEXT BEST STEP')),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: LbColors.surface, shape: BoxShape.circle, border: Border.all(color: LbColors.border)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.send_outlined, color: LbColors.fg, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Apply to Apollo Charity Care', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text('88% match · ₹4.8L potential benefit', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LbButton(
                      label: 'Start application',
                      fontSize: 14,
                      height: 44,
                      onTap: () => Navigator.pushNamed(context, '/app/create'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: LbEyebrow('ALSO HELPFUL')),
              const SizedBox(height: 12),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/change-details'),
                padding: EdgeInsets.zero,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      LbIconSquare(icon: Icons.phone_outlined, background: LbColors.surface2, foreground: LbColors.fg, size: 32, iconSize: 18, radius: 8),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confirm insurance pre-auth', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('Call Star Health · may reduce your gap', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: LbColors.muted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/ai/assistant'),
                padding: EdgeInsets.zero,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      LbIconSquare(icon: Icons.auto_awesome, background: LbColors.accentSoft, foreground: LbColors.accent, size: 32, iconSize: 18, radius: 8),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ask LifeBridge AI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('"What should I do next?"', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: LbColors.muted),
                    ],
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

class HomeAttentionScreen extends StatelessWidget {
  const HomeAttentionScreen({super.key});
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
              const Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: Text('TUESDAY · 22 APRIL', style: TextStyle(color: LbColors.danger, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.4))),
              const SizedBox(height: 8),
              const LbH1('Hi, Priya.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: LbColors.danger, width: 2)),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.error_outline, color: LbColors.danger, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your case needs attention', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: LbColors.danger)),
                          SizedBox(height: 2),
                          Text('2 items require action', style: TextStyle(fontSize: 12, color: LbColors.danger)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow('FUNDING GAP'),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbNumber('₹2,80,000', size: 28, color: LbColors.danger),
                    SizedBox(height: 4),
                    Text('Treatment 2 May 2026', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow('ACTION NEEDED'),
              const SizedBox(height: 12),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/docs/upload'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.description_outlined, background: LbColors.accentSoft, foreground: LbColors.accent, size: 36, iconSize: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload cost breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Seva Fund needs this to continue review', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/draft'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.send_outlined, background: LbColors.dangerBg, foreground: LbColors.danger, size: 36, iconSize: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Follow up with Seva Fund', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('9 days without a response', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow('WHY?'),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'Both items block progress on applications that could close up to ₹80,000 of your funding gap.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              const SizedBox(height: 16),
              LbButton(label: 'Start with cost breakdown', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
            ],
          ),
        ),
      ),
    );
  }
}

class CasesListScreen extends StatelessWidget {
  const CasesListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final hasCase = s.hasCase;
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LbEyebrow('CASES · ${hasCase ? 1 : 0}'),
              const SizedBox(height: 8),
              const LbH1('Cases'),
              const SizedBox(height: 8),
              LbBody("Each case is a separate situation you can apply to support for.", color: LbColors.muted),
              const SizedBox(height: 16),
              if (hasCase) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/case/detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.mainCase.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3)),
                      const SizedBox(height: 6),
                      Text('${s.patient.name} · Case #${s.mainCase.id}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 8),
                      const LbBadge(label: 'Active', variant: BadgeVariant.submitted),
                      const SizedBox(height: 16),
                      const Divider(color: LbColors.borderSoft, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _MiniStat(label: 'FUNDING GAP', value: '₹2,80,000')),
                          Expanded(child: _MiniStat(label: 'APPLICATIONS', value: '3')),
                          Expanded(child: _MiniStat(label: 'DOCS', value: '4')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LbProgress(value: s.mainCase.progress / 100),
                      const SizedBox(height: 6),
                      Text('${s.mainCase.progress}% complete', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              LbCard(
                padding: const EdgeInsets.all(20),
                onTap: () => Navigator.pushNamed(context, '/case/intro'),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle, border: Border.all(color: LbColors.cardWarnBorder, style: BorderStyle.solid)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add, color: LbColors.accent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasCase ? 'Start a new case' : 'Create your first case',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: LbColors.muted, size: 18),
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
                    LbEyebrow('MULTIPLE CASES?'),
                    SizedBox(height: 6),
                    Text('Each case is independent. You can have one for yourself and others for family members.', style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4)),
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

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LbEyebrow(label),
        const SizedBox(height: 4),
        LbNumber(value, size: 16),
      ],
    );
  }
}
