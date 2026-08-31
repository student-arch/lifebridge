import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../widgets/components.dart';

class EmergencyHubScreen extends StatelessWidget {
  const EmergencyHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: LbColors.danger,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.danger, foreground: LbColors.surface, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
                        const SizedBox(width: 12),
                        const LbEyebrow('EMERGENCY', color: LbColors.surface),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: LbH1('Emergency help', color: LbColors.surface),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('If this is a life-threatening emergency, call 112 immediately. The resources below are not a substitute for emergency services.', style: TextStyle(color: LbColors.surface, fontSize: 13, height: 1.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: LbColors.danger, width: 2)),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: LbColors.danger, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('LifeBridge does not replace emergency medical services. For life-threatening situations, call 112 or go to the nearest emergency room.', style: TextStyle(fontSize: 12, color: LbColors.fg, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: LbEyebrow('IMMEDIATE HELP')),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    _EmergencyRow(icon: Icons.local_hospital_outlined, title: 'Hospital assistance', subtitle: 'Connect with hospital finance · 24/7', target: '/emergency/hospital'),
                    SizedBox(height: 8),
                    _EmergencyRow(icon: Icons.water_drop_outlined, title: 'Blood support', subtitle: 'Find donors · blood banks', target: '/emergency/blood'),
                    SizedBox(height: 8),
                    _EmergencyRow(icon: Icons.payments_outlined, title: 'Emergency financial aid', subtitle: 'Crowdfunding within hours', target: '/emergency/financial'),
                    SizedBox(height: 8),
                    _EmergencyRow(icon: Icons.contact_phone_outlined, title: 'Emergency contacts', subtitle: 'Hospitals, ambulance, helplines', target: '/emergency/contacts'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
                    const SizedBox(height: 8),
                    LbButton(label: 'Read full disclaimer', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/emergency/disclaimer')),
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

class _EmergencyRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String target;
  const _EmergencyRow({required this.icon, required this.title, required this.subtitle, required this.target});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: () => Navigator.pushNamed(context, target),
      child: Row(
        children: [
          LbIconTile(icon: icon, background: LbColors.dangerBg, foreground: LbColors.danger, size: 44, iconSize: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: LbColors.danger, size: 18),
        ],
      ),
    );
  }
}

class EmergencyDisclaimerScreen extends StatelessWidget {
  const EmergencyDisclaimerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 88, height: 88, decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.error_outline, color: LbColors.danger, size: 44)),
              const SizedBox(height: 24),
              const LbH1('Please read.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("A reminder about how LifeBridge can and can't help.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 20),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('LifeBridge helps you find and apply to financial, medical, and community support.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4)),
                    SizedBox(height: 12),
                    Text('LifeBridge is not:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    LbBullet(items: ['A substitute for emergency services', 'A medical advice provider', 'A guarantee of program approval']),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'If this is a life-threatening emergency, ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'call 112 now. Don\'t wait for an app to respond.', style: TextStyle(color: LbColors.danger)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              LbButton(label: 'I understand', variant: LbButtonVariant.danger, onTap: () => Navigator.pushNamed(context, '/emergency')),
            ],
          ),
        ),
      ),
    );
  }
}

class HospitalAssistanceScreen extends StatelessWidget {
  const HospitalAssistanceScreen({super.key});
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
                  const LbEyebrow('EMERGENCY · HOSPITAL', color: LbColors.danger),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Hospital assistance'),
              const SizedBox(height: 8),
              LbBody("Connect with the hospital's financial-aid team. Most have 24/7 hotlines.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.local_hospital_outlined, background: LbColors.dangerBg, foreground: LbColors.danger, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Apollo Hospitals, Bannerghatta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Your treatment hospital', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: LbColors.border)),
                        child: Column(
                          children: const [
                            LbIconTile(icon: Icons.call, background: LbColors.successBg, foreground: LbColors.emerald, size: 44, iconSize: 22),
                            SizedBox(height: 8),
                            Text('Call billing', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('+91 80 4040 1060', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/emergency'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: LbColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: LbColors.border)),
                        child: Column(
                          children: const [
                            LbIconTile(icon: Icons.home_outlined, background: LbColors.accent, foreground: LbColors.surface, size: 44, iconSize: 22),
                            SizedBox(height: 8),
                            Text('Visit ER desk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('Ground floor · open 24/7', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const LbEyebrow('WHAT TO SAY'),
              const SizedBox(height: 8),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.5),
                    children: [
                      TextSpan(text: '"I\'m seeking emergency financial assistance for an upcoming procedure. Can I speak to a financial counselor?"\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(text: 'Mention you have a '),
                      TextSpan(text: 'LifeBridge case #LB-2026-00873', style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ' ready to share.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "Most hospitals can offer 30–60% off billed cost for families below income thresholds. Ask specifically about charity care.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Call hospital now', variant: LbButtonVariant.success, onTap: () {}),
              const SizedBox(height: 8),
              LbButton(label: 'Log this call →', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamed(context, '/emergency/confirm')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to emergency', variant: LbButtonVariant.ghost, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class BloodSupportScreen extends StatelessWidget {
  const BloodSupportScreen({super.key});
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
                  const LbEyebrow('EMERGENCY · BLOOD', color: LbColors.danger),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Blood support'),
              const SizedBox(height: 8),
              LbBody('Find donors and blood banks near you.', color: LbColors.muted),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: LbCard(
                  background: LbColors.danger,
                  borderColor: Colors.transparent,
                  child: Row(
                    children: const [
                      LbIconTile(icon: Icons.call, background: LbColors.surface, foreground: LbColors.danger, size: 44, iconSize: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Call 104 — Health helpline', style: TextStyle(color: LbColors.surface, fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('24/7 · free · multi-language', style: TextStyle(color: LbColors.surface, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: LbColors.surface, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const LbEyebrow('BLOOD BANKS NEAR YOU'),
              const SizedBox(height: 8),
              _BloodBankRow(name: 'Rotary Blood Bank', meta: '2.4 km · open 24/7', phone: '+918022334455'),
              const SizedBox(height: 8),
              _BloodBankRow(name: 'Sanjeevini Blood Centre', meta: '3.8 km · open until 11 PM', phone: '+918025667788'),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: 'LifeBridge can also help post a verified donor request on social media — once the immediate need is met.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Call 104 now', variant: LbButtonVariant.danger, onTap: () {}),
              const SizedBox(height: 8),
              LbButton(label: 'Back to emergency', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BloodBankRow extends StatelessWidget {
  final String name;
  final String meta;
  final String phone;
  const _BloodBankRow({required this.name, required this.meta, required this.phone});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      child: Row(
        children: [
          const LbIconTile(icon: Icons.water_drop_outlined, background: LbColors.dangerBg, foreground: LbColors.danger, size: 40, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('Call', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyFinancialScreen extends StatelessWidget {
  const EmergencyFinancialScreen({super.key});
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
                  const LbEyebrow('EMERGENCY · FINANCIAL', color: LbColors.danger),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Emergency financial aid'),
              const SizedBox(height: 8),
              LbBody('Quickest routes when funds are needed within hours.', color: LbColors.muted),
              const SizedBox(height: 16),
              _FinancialOption(icon: Icons.credit_card, title: 'Milaap Medical', subtitle: 'Free crowdfunding · typically ₹1–3L in 24–48h', highlight: true, onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              _FinancialOption(icon: Icons.add_circle_outline, title: 'PMJAY / Ayushman Bharat', subtitle: 'Government scheme · check eligibility', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              _FinancialOption(icon: Icons.home_outlined, title: 'Hospital charity care', subtitle: '30–60% off billed cost · same-day decision', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "LifeBridge can prepare a crowdfunding draft for you in under 2 minutes. You stay in control of the messaging and the page.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Start crowdfunding', onTap: () => Navigator.pushNamed(context, '/app/create')),
              const SizedBox(height: 8),
              LbButton(label: 'Back to emergency', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinancialOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool highlight;
  final VoidCallback onTap;
  const _FinancialOption({required this.icon, required this.title, required this.subtitle, this.highlight = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      background: highlight ? LbColors.infoBg : LbColors.surface,
      borderColor: highlight ? LbColors.cardWarnBorder : LbColors.border,
      onTap: onTap,
      child: Row(
        children: [
          LbIconTile(icon: icon, background: highlight ? LbColors.accent : LbColors.infoBg, foreground: highlight ? LbColors.surface : LbColors.accent, size: 40, iconSize: 20),
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
    );
  }
}

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});
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
                  const LbEyebrow('EMERGENCY · CONTACTS', color: LbColors.danger),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Emergency contacts'),
              const SizedBox(height: 8),
              LbBody('Quick access. Tap to call.', color: LbColors.muted),
              const SizedBox(height: 16),
              const LbEyebrow('NATIONAL'),
              const SizedBox(height: 8),
              _ContactRow(name: '112 — Emergency', subtitle: 'All emergencies · 24/7 · free', highlight: true, phone: 'tel:112'),
              const SizedBox(height: 8),
              _ContactRow(name: '104 — Health helpline', subtitle: 'Health info · 24/7', phone: 'tel:104'),
              const SizedBox(height: 16),
              const LbEyebrow('YOUR HOSPITAL'),
              const SizedBox(height: 8),
              _ContactRow(name: 'Apollo Hospitals, Bannerghatta', subtitle: '+91 80 4040 1060 · ER & billing', phone: 'tel:08040401060', showChevron: true),
              const SizedBox(height: 8),
              _ContactRow(name: '108 — Ambulance', subtitle: 'Free · 24/7', phone: 'tel:108', icon: Icons.swap_horiz, showChevron: true),
              const SizedBox(height: 24),
              LbButton(label: 'Back to emergency', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final String phone;
  final bool highlight;
  final IconData icon;
  final bool showChevron;
  const _ContactRow({required this.name, required this.subtitle, required this.phone, this.highlight = false, this.icon = Icons.call_outlined, this.showChevron = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: LbCard(
        background: highlight ? LbColors.dangerBg : LbColors.surface,
        borderColor: highlight ? LbColors.danger : LbColors.border,
        child: Row(
          children: [
            LbIconTile(icon: icon, background: highlight ? LbColors.surface : LbColors.infoBg, foreground: highlight ? LbColors.danger : LbColors.accent, size: 40, iconSize: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: highlight ? LbColors.danger : LbColors.fg)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            if (highlight) const LbPill(label: 'TAP TO CALL', variant: PillVariant.danger) else if (icon == Icons.call_outlined || icon == Icons.swap_horiz) Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: LbColors.accentSoft, borderRadius: BorderRadius.circular(999)),
              child: const Text('Tap to call', style: TextStyle(color: LbColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            if (showChevron) const SizedBox(width: 8),
            if (showChevron) const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class EmergencyConfirmScreen extends StatelessWidget {
  const EmergencyConfirmScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle), alignment: Alignment.center, child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40)),
              const SizedBox(height: 24),
              const LbH1('Action confirmed.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Calling Apollo Hospitals billing now.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow("WHILE YOU'RE ON THE CALL"),
                    SizedBox(height: 8),
                    LbBullet(items: [
                      'Ask for the financial counseling office',
                      'Share LifeBridge case #LB-2026-00873',
                      'Ask specifically about charity care',
                      'Note who you spoke to and any reference number',
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: "When you hang up, log the outcome in your case — we'll update your funding gap automatically.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbButton(label: 'Log outcome later', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
              const SizedBox(height: 8),
              LbButton(label: 'Back to home', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}
