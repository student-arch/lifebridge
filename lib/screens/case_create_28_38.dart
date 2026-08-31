import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

Widget _backHeader(BuildContext context, {String? eyebrow, VoidCallback? onBack}) {
  return Row(
    children: [
      LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: onBack ?? () => Navigator.maybePop(context)),
      if (eyebrow != null) ...[
        const SizedBox(width: 12),
        LbEyebrow(eyebrow),
      ],
    ],
  );
}

class CreateCaseIntroScreen extends StatelessWidget {
  const CreateCaseIntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final steps = const [
      ('Patient & case type', '~3 min'),
      ('Treatment & hospital', '~4 min'),
      ('Financial details', '~3 min'),
      ('Documents', '~5 min'),
      ('Review & submit', '~1 min'),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, onBack: () => Navigator.pushReplacementNamed(context, '/home')),
              const SizedBox(height: 12),
              const LbEyebrow('New case'),
              const SizedBox(height: 8),
              const LbH1("Let's start a new case."),
              const SizedBox(height: 8),
              LbBody("Tell us about the situation. You'll answer five short sections.", color: LbColors.fg2),
              const SizedBox(height: 20),
              LbCard(
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: LbColors.accentSoft, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add, color: LbColors.accent, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Take your time. You can save and come back.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Your answers stay private. AI helps organize the information; it never submits anything without you.', style: TextStyle(fontSize: 12, color: LbColors.fg2, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow("WHAT YOU'LL COVER"),
              const SizedBox(height: 12),
              for (int i = 0; i < steps.length; i++) ...[
                LbCard(
                  background: LbColors.surface2,
                  borderColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(color: LbColors.accent, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text('${i + 1}', style: const TextStyle(color: LbColors.surface, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(steps[i].$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                      Text(steps[i].$2, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                    ],
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(height: 8),
              ],
              const SizedBox(height: 32),
              LbButton(label: 'Begin', onTap: () => Navigator.pushNamed(context, '/case/type')),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectCaseTypeScreen extends StatefulWidget {
  const SelectCaseTypeScreen({super.key});
  @override
  State<SelectCaseTypeScreen> createState() => _SelectCaseTypeScreenState();
}

class _SelectCaseTypeScreenState extends State<SelectCaseTypeScreen> {
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    final items = caseTypeLabels.entries.toList();
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _backHeader(context, onBack: () => Navigator.pushNamed(context, '/home')),
              const SizedBox(height: 12),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: LbStepProgress(current: 1, total: 5, done: [])),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 1 OF 5'),
              const SizedBox(height: 8),
              const LbH1('What kind of support do you need?'),
              const SizedBox(height: 8),
              LbBody('You can pick more than one.', color: LbColors.muted),
              const SizedBox(height: 20),
              for (final e in items) ...[
                LbChoice(
                  title: e.value,
                  subtitle: caseTypeDescriptions[e.key],
                  checkStyle: true,
                  selected: s.selectedCaseTypes.contains(e.value),
                  onTap: () => setState(() => s.toggleCaseType(e.value)),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 24),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/patient')),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key});
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
              _backHeader(context, onBack: () => Navigator.pop(context)),
              const SizedBox(height: 12),
              const LbStepProgress(current: 1, total: 5, done: []),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 1 OF 5 · PATIENT'),
              const SizedBox(height: 8),
              const LbH1('About the patient.'),
              const SizedBox(height: 8),
              LbBody('Pulled from your profile — adjust if needed.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "We saved these from your profile. Tap any field to edit.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              LbField(label: 'Full name', value: s.patient.name),
              const SizedBox(height: 12),
              LbField(label: 'Age', value: '${s.patient.age}'),
              const SizedBox(height: 12),
              LbField(label: 'Gender', value: s.patient.gender),
              const SizedBox(height: 12),
              LbField(label: 'Relationship to you', value: s.patient.relationship),
              const SizedBox(height: 12),
              LbField(label: 'Primary concern', value: s.patient.concern),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/treatment')),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentDetailsScreen extends StatelessWidget {
  const TreatmentDetailsScreen({super.key});
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
              const LbStepProgress(current: 2, total: 5, done: [true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 2 OF 5 · TREATMENT'),
              const SizedBox(height: 8),
              const LbH1('About the treatment.'),
              const SizedBox(height: 8),
              LbBody('Estimated figures are fine — we\'ll refine later.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbField(label: 'Treatment type', value: s.treatment.type),
              const SizedBox(height: 12),
              LbField(label: 'Diagnosis', value: s.treatment.diagnosis),
              const SizedBox(height: 12),
              LbField(label: 'Estimated cost', value: '₹${s.treatment.estimatedCost}', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              LbField(label: 'Treatment start date', value: '2 May 2026'),
              const SizedBox(height: 12),
              LbField(label: "Doctor's name", value: s.treatment.doctorName),
              const SizedBox(height: 12),
              LbField(label: 'Notes', value: s.treatment.notes, maxLines: 3),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/hospital')),
            ],
          ),
        ),
      ),
    );
  }
}

class HospitalDetailsScreen extends StatelessWidget {
  const HospitalDetailsScreen({super.key});
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
              const LbStepProgress(current: 2, total: 5, done: [true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 2 OF 5 · HOSPITAL'),
              const SizedBox(height: 8),
              const LbH1('Where will treatment happen?'),
              const SizedBox(height: 8),
              LbBody("The hospital often has its own financial-aid office.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbField(label: 'Hospital name', value: s.hospital.name),
              const SizedBox(height: 12),
              LbField(label: 'City', value: s.hospital.city),
              const SizedBox(height: 12),
              LbField(label: 'Department', value: s.hospital.department),
              const SizedBox(height: 12),
              LbField(label: 'Patient ID (if known)', value: s.hospital.patientId, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'Heads up.',
                body: "Many hospitals have charity-care programs that can cut 30–60% of the bill. We'll look for those after you submit.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/financial')),
            ],
          ),
        ),
      ),
    );
  }
}

class FinancialInfoScreen extends StatefulWidget {
  const FinancialInfoScreen({super.key});
  @override
  State<FinancialInfoScreen> createState() => _FinancialInfoScreenState();
}

class _FinancialInfoScreenState extends State<FinancialInfoScreen> {
  bool _family = false, _crowd = true, _employer = false;
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
              const LbStepProgress(current: 3, total: 5, done: [true, true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 3 OF 5 · FINANCIAL'),
              const SizedBox(height: 8),
              const LbH1('A quick financial picture.'),
              const SizedBox(height: 8),
              LbBody('Only used to estimate your funding gap. Never shared without permission.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbField(label: 'Annual household income', value: '₹${s.financial.annualIncome}', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              LbField(label: 'Monthly household expenses', value: '₹${s.financial.monthlyExpenses}', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              LbField(label: 'Savings available for treatment', value: '₹${s.financial.savings}', keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              const LbEyebrow('OTHER FINANCIAL HELP'),
              const SizedBox(height: 8),
              LbCheckbox(label: 'Family support pledged', value: _family, onChanged: (v) => setState(() => _family = v)),
              const SizedBox(height: 8),
              LbCheckbox(label: 'Active crowdfunding campaign', value: _crowd, onChanged: (v) => setState(() => _crowd = v)),
              const SizedBox(height: 8),
              LbCheckbox(label: 'Employer assistance program', value: _employer, onChanged: (v) => setState(() => _employer = v)),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/insurance')),
            ],
          ),
        ),
      ),
    );
  }
}

class InsuranceInfoScreen extends StatelessWidget {
  const InsuranceInfoScreen({super.key});
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
              const LbStepProgress(current: 3, total: 5, done: [true, true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 3 OF 5 · INSURANCE'),
              const SizedBox(height: 8),
              const LbH1('Tell us about insurance.'),
              const SizedBox(height: 8),
              LbBody("Skip if you don't have any — we'll work without it.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbField(label: 'Provider', value: s.insurance.provider),
              const SizedBox(height: 12),
              LbField(label: 'Policy number', value: s.insurance.policyNumber),
              const SizedBox(height: 12),
              LbField(label: 'Coverage amount', value: '₹${s.insurance.coverage}', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              LbField(label: 'Estimated approved amount', value: '₹${s.insurance.approved}', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              LbField(label: 'Status', value: s.insurance.status),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/existing')),
            ],
          ),
        ),
      ),
    );
  }
}

class ExistingAssistanceScreen extends StatelessWidget {
  const ExistingAssistanceScreen({super.key});
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
              const LbStepProgress(current: 3, total: 5, done: [true, true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 3 OF 5 · EXISTING HELP'),
              const SizedBox(height: 8),
              const LbH1('Any help already lined up?'),
              const SizedBox(height: 8),
              LbBody("Tell us so we don't double-apply.", color: LbColors.muted),
              const SizedBox(height: 16),
              for (final a in s.existingAssistance) ...[
                LbCard(
                  child: Row(
                    children: [
                      LbIconTile(icon: Icons.home_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(a.meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      LbBadge(label: a.statusLabel, variant: a.statusVariant),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              LbCard(
                background: LbColors.surface,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: LbColors.surface2, shape: BoxShape.circle, border: Border.all(color: LbColors.border)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add, color: LbColors.fg, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text('Add another', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/documents')),
            ],
          ),
        ),
      ),
    );
  }
}

class CaseDocumentUploadScreen extends StatelessWidget {
  const CaseDocumentUploadScreen({super.key});
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
              const LbStepProgress(current: 4, total: 5, done: [true, true, true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 4 OF 5 · DOCUMENTS'),
              const SizedBox(height: 8),
              const LbH1('Upload what you have.'),
              const SizedBox(height: 8),
              LbBody("You can add more later. We'll auto-categorize.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/docs/upload'),
                background: LbColors.surface,
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle, border: Border.all(color: LbColors.cardWarnBorder, style: BorderStyle.solid)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.cloud_upload_outlined, color: LbColors.accent, size: 26),
                    ),
                    const SizedBox(height: 12),
                    const Text('Upload a document', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    LbMeta('Photo, scan, or PDF · up to 25 MB'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final d in s.documents.take(2)) ...[
                _UploadedRow(name: d.name, meta: d.meta ?? '', tag: d.fileType),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbInfoBanner(
                title: 'Suggested next:',
                body: 'Income certificate unlocks 3 programs.',
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/case/review')),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadedRow extends StatelessWidget {
  final String name;
  final String meta;
  final String tag;
  const _UploadedRow({required this.name, required this.meta, required this.tag});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.check, color: LbColors.emerald, size: 18),
          ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(999), border: Border.all(color: LbColors.border)),
            child: Text(tag, style: const TextStyle(fontSize: 11, color: LbColors.muted, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class ReviewCaseScreen extends StatelessWidget {
  const ReviewCaseScreen({super.key});
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
              const LbStepProgress(current: 5, total: 5, done: [true, true, true, true]),
              const SizedBox(height: 12),
              const LbEyebrow('STEP 5 OF 5 · REVIEW'),
              const SizedBox(height: 8),
              const LbH1('Review your case.'),
              const SizedBox(height: 8),
              LbBody('Tap any section to edit.', color: LbColors.muted),
              const SizedBox(height: 16),
              _ReviewSectionCard(
                title: 'Patient',
                value: '${s.patient.name}, ${s.patient.age}',
                meta: '${s.patient.relationship} · ${s.patient.gender}',
                onEdit: () => Navigator.pushNamed(context, '/case/patient'),
              ),
              const SizedBox(height: 8),
              _ReviewSectionCard(
                title: 'Treatment',
                value: s.treatment.type,
                meta: '${s.hospital.name} · Starts 2 May',
                onEdit: () => Navigator.pushNamed(context, '/case/treatment'),
                extra: Row(
                  children: [
                    Expanded(child: _MiniStat(label: 'EST. COST', value: '₹4,80,000')),
                    Expanded(child: _MiniStat(label: 'INSURANCE', value: '₹1,50,000')),
                    Expanded(child: _MiniStat(label: 'SAVINGS', value: '₹50,000')),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _ReviewSectionCard(
                title: 'Documents',
                value: '2 uploaded · Aadhaar, prescription',
                meta: "We may suggest more after analysis.",
                onEdit: () => Navigator.pushNamed(context, '/case/documents'),
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Looks good — continue', onTap: () => Navigator.pushNamed(context, '/case/consent')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSectionCard extends StatelessWidget {
  final String title;
  final String value;
  final String meta;
  final VoidCallback onEdit;
  final Widget? extra;
  const _ReviewSectionCard({required this.title, required this.value, required this.meta, required this.onEdit, this.extra});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
              GestureDetector(
                onTap: onEdit,
                child: const Text('Edit', style: TextStyle(fontSize: 13, color: LbColors.accent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 2),
          Text(meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
          if (extra != null) ...[
            const SizedBox(height: 12),
            const Divider(color: LbColors.borderSoft, height: 1),
            const SizedBox(height: 12),
            extra!,
          ],
        ],
      ),
    );
  }
}

class ConsentSubmitScreen extends StatefulWidget {
  const ConsentSubmitScreen({super.key});
  @override
  State<ConsentSubmitScreen> createState() => _ConsentSubmitScreenState();
}

class _ConsentSubmitScreenState extends State<ConsentSubmitScreen> {
  bool _ai = true, _extract = true, _weekly = false;
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
              const LbEyebrow('FINAL STEP'),
              const SizedBox(height: 8),
              const LbH1('Share with LifeBridge.'),
              const SizedBox(height: 8),
              LbBody("One consent now — you decide what each program sees later.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: LbColors.accentSoft, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add, color: LbColors.accent, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                          children: [
                            TextSpan(text: 'We use this information to ', style: TextStyle(color: LbColors.fg2)),
                            TextSpan(text: 'find matching programs', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.fg)),
                            TextSpan(text: ' and prepare your applications. We never share with a program until you say so.', style: TextStyle(color: LbColors.fg2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbCheckbox(label: 'Allow AI to analyze my case and suggest matches.', value: _ai, onChanged: (v) => setState(() => _ai = v)),
              const SizedBox(height: 8),
              LbCheckbox(label: 'Allow AI to extract information from my uploaded documents.', value: _extract, onChanged: (v) => setState(() => _extract = v)),
              const SizedBox(height: 8),
              LbCheckbox(label: 'Email me weekly progress summaries.', value: _weekly, onChanged: (v) => setState(() => _weekly = v)),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12, color: LbColors.muted),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to LifeBridge\'s '),
                      const TextSpan(text: 'Terms', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600)),
                      const TextSpan(text: ' and '),
                      const TextSpan(text: 'Privacy Policy', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Submit & create my case', onTap: () => Navigator.pushNamed(context, '/case/created')),
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
