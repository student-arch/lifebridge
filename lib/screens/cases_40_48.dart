import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class CaseDetailScreen extends StatelessWidget {
  const CaseDetailScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('CASE · LB-2026-00873'),
                ],
              ),
              const SizedBox(height: 12),
              Text(s.mainCase.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.5, height: 1.15)),
              const SizedBox(height: 4),
              Text('For ${s.patient.name} · started 12 April 2026', style: const TextStyle(fontSize: 13, color: LbColors.muted)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: LbStatCard(label: 'FUNDING GAP', value: '₹2.8L')),
                  const SizedBox(width: 12),
                  Expanded(child: LbStatCard(label: 'PROGRESS', value: '38%')),
                ],
              ),
              const SizedBox(height: 20),
              const LbEyebrow('CASE SECTIONS'),
              const SizedBox(height: 12),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SectionRow(icon: Icons.folder_outlined, title: 'Overview', subtitle: 'Patient, treatment, status', onTap: () => Navigator.pushNamed(context, '/case/overview')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _SectionRow(icon: Icons.payments_outlined, title: 'Funding gap', subtitle: '₹2,80,000 to bridge', onTap: () => Navigator.pushNamed(context, '/case/gap')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _SectionRow(icon: Icons.send_outlined, title: 'Applications', subtitle: '3 active · 0 approved', onTap: () => Navigator.pushNamed(context, '/case/applications')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _SectionRow(icon: Icons.folder_outlined, title: 'Documents', subtitle: '4 uploaded · 2 missing', onTap: () => Navigator.pushNamed(context, '/case/documents-list')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _SectionRow(icon: Icons.handshake_outlined, title: 'Support matches', subtitle: '5 programs', onTap: () => Navigator.pushNamed(context, '/case/matches')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _SectionRow(icon: Icons.access_time, title: 'Timeline', subtitle: '8 events', onTap: () => Navigator.pushNamed(context, '/case/timeline')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Apply to a new program', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              LbButton(label: 'Edit case', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/case/edit')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SectionRow({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: LbColors.surface, shape: BoxShape.circle, border: Border.all(color: LbColors.border)),
              alignment: Alignment.center,
              child: Icon(icon, color: LbColors.fg, size: 18),
            ),
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
      ),
    );
  }
}

class CaseOverviewScreen extends StatelessWidget {
  const CaseOverviewScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('OVERVIEW'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Cardiac Treatment Assistance'),
              const SizedBox(height: 8),
              LbBody('Patient, treatment, and status at a glance.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LbEyebrow('PATIENT'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        LbAvatar(text: s.patient.initials, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${s.patient.name}, ${s.patient.age}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('${s.patient.relationship} · ${s.patient.gender} · ${s.hospital.city}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                            ],
                          ),
                        ),
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
                    LbEyebrow('TREATMENT'),
                    SizedBox(height: 8),
                    LbKeyValue(label: 'PROCEDURE', value: 'Cardiac catheterization + angioplasty'),
                    LbKeyValue(label: 'DIAGNOSIS', value: 'Triple-vessel CAD'),
                    LbKeyValue(label: 'HOSPITAL', value: 'Apollo, Bannerghatta'),
                    LbKeyValue(label: 'START DATE', value: '2 May 2026'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('FINANCIAL'),
                    SizedBox(height: 8),
                    LbKeyValue(label: 'EST. COST', value: '₹4,80,000'),
                    LbKeyValue(label: 'INSURANCE', value: '₹1,50,000'),
                    LbKeyValue(label: 'SAVINGS', value: '₹50,000'),
                    LbKeyValue(label: 'GAP', value: '₹2,80,000', valueColor: LbColors.danger, largeValue: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Edit case', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/case/edit')),
            ],
          ),
        ),
      ),
    );
  }
}

class CaseFundingGapScreen extends StatelessWidget {
  const CaseFundingGapScreen({super.key});
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
                  const LbEyebrow('FUNDING GAP'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Where the gap is.'),
              const SizedBox(height: 8),
              LbBody('How we got to ₹2,80,000.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LbEyebrow('ESTIMATED COST'),
                    const SizedBox(height: 6),
                    const LbNumber('₹4,80,000', size: 24),
                    const SizedBox(height: 12),
                    const LbProgress(value: 1.0),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const LbDot(color: LbColors.emerald),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('INSURANCE APPROVED', style: TextStyle(fontSize: 11, color: LbColors.muted, fontWeight: FontWeight.w600, letterSpacing: 0.4))),
                        const LbNumber('₹1,50,000', size: 14, color: LbColors.emerald),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const LbDot(color: LbColors.emerald),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('FAMILY SAVINGS', style: TextStyle(fontSize: 11, color: LbColors.muted, fontWeight: FontWeight.w600, letterSpacing: 0.4))),
                        const LbNumber('₹50,000', size: 14, color: LbColors.emerald),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const LbEyebrow('FUNDING GAP'),
                        const Spacer(),
                        const LbNumber('₹2,80,000', size: 22, color: LbColors.danger),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow("WHAT WE'VE APPLIED FOR"),
              const SizedBox(height: 12),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _AppliedRow(name: 'Heart Care Trust', requested: '₹1,50,000', badge: 'Pending', variant: BadgeVariant.submitted, n: 1),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _AppliedRow(name: 'Seva Community Fund', requested: '₹80,000', badge: 'Draft', variant: BadgeVariant.review, n: 2),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _AppliedRow(name: 'State Treatment Scheme', requested: '₹1,00,000', badge: 'Under review', variant: BadgeVariant.submitted, n: 3),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "Even partial approvals close the gap. We'll keep tracking applications and update the total.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Find more support', onTap: () => Navigator.pushNamed(context, '/find-alternative')),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppliedRow extends StatelessWidget {
  final String name;
  final String requested;
  final String badge;
  final BadgeVariant variant;
  final int n;
  const _AppliedRow({required this.name, required this.requested, required this.badge, required this.variant, required this.n});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          LbCounter(n),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Requested $requested', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          LbBadge(label: badge, variant: variant),
        ],
      ),
    );
  }
}

class CaseApplicationsScreen extends StatelessWidget {
  const CaseApplicationsScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  LbEyebrow('APPLICATIONS · ${s.applications.length}'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Applications in this case'),
              const SizedBox(height: 8),
              LbBody('Each program reviews independently.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final a in s.applications) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/app/detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(a.programName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                          LbBadge(label: a.status, variant: a.statusVariant),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${a.reference} · requested ₹${_fmt(a.requestedAmount)}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                      const SizedBox(height: 12),
                      LbProgress(value: a.progress / 100),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbButton(label: '+ New application', onTap: () => Navigator.pushNamed(context, '/app/create')),
            ],
          ),
        ),
      ),
    );
  }
}

String _fmt(double v) {
  if (v == v.toInt()) return v.toInt().toString();
  return v.toStringAsFixed(0);
}

class CaseDocumentsScreen extends StatelessWidget {
  const CaseDocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final grouped = <String, List<dynamic>>{};
    for (final d in s.documents) {
      grouped.putIfAbsent(d.categoryLabel, () => []).add(d);
    }
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
                  const LbEyebrow('CASE DOCUMENTS'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('All case documents'),
              const SizedBox(height: 8),
              LbBody('Organized by category. Auto-attached to relevant applications.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final entry in grouped.entries) ...[
                LbEyebrow(entry.key.toUpperCase()),
                const SizedBox(height: 8),
                for (final d in entry.value) ...[
                  LbCard(
                    onTap: () => Navigator.pushNamed(context, '/docs/preview'),
                    child: Row(
                      children: [
                        LbIconSquare(icon: Icons.description_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20, radius: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('${d.fileType} · ${d.size}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
              ],
              LbButton(label: '+ Upload document', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
            ],
          ),
        ),
      ),
    );
  }
}

class CaseSupportMatchesScreen extends StatelessWidget {
  const CaseSupportMatchesScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  LbEyebrow('MATCHES · ${s.supportPrograms.length}'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Programs that fit this case.'),
              const SizedBox(height: 8),
              LbBody('Tap any to see details or apply.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final p in s.supportPrograms) ...[
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
                      Text('${p.amountLabel} · ${p.description.split('.').first}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
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
}

class CaseTimelineScreen extends StatelessWidget {
  const CaseTimelineScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('TIMELINE'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Case timeline'),
              const SizedBox(height: 8),
              LbBody('Every action, every update.', color: LbColors.muted),
              const SizedBox(height: 20),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < s.caseTimeline.length; i++)
                      LbTimelineItem(
                        title: s.caseTimeline[i].title,
                        subtitle: s.caseTimeline[i].meta,
                        done: s.caseTimeline[i].done,
                        active: s.caseTimeline[i].active,
                        isLast: i == s.caseTimeline.length - 1,
                      ),
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

class EditCaseScreen extends StatelessWidget {
  const EditCaseScreen({super.key});
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
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('EDIT CASE'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Edit case details'),
              const SizedBox(height: 8),
              LbBody('Changes update your funding gap and matches.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbEyebrow('QUICK EDIT'),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/followups/change-details'),
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.attach_money, background: LbColors.warnBg, foreground: LbColors.warn, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cost changed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Quick update + reassess', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _EditRow(title: 'Patient details', value: '${s.patient.name}, ${s.patient.age}', onTap: () => Navigator.pushNamed(context, '/case/patient')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _EditRow(title: 'Treatment details', value: s.treatment.type, onTap: () => Navigator.pushNamed(context, '/case/treatment')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _EditRow(title: 'Hospital details', value: s.hospital.name, onTap: () => Navigator.pushNamed(context, '/case/hospital')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _EditRow(title: 'Financial information', value: '₹6.4L income · ₹50K savings', onTap: () => Navigator.pushNamed(context, '/case/financial')),
                    const Divider(color: LbColors.borderSoft, height: 1),
                    _EditRow(title: 'Insurance', value: '${s.insurance.provider} · ₹1.5L approved', onTap: () => Navigator.pushNamed(context, '/case/insurance')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'Deleting the case ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'removes all linked applications, follow-ups, and documents. Active applications will be withdrawn.', style: TextStyle(color: LbColors.fg2)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Done', onTap: () => Navigator.pop(context)),
              const SizedBox(height: 8),
              LbButton(label: 'Delete case', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/help')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const _EditRow({required this.title, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}
