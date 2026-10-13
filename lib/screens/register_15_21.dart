import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/components.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
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
                  const LbEyebrow('Forgot password'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Forgot your password?'),
              const SizedBox(height: 8),
              LbBody("Enter your email and we'll send a reset link.", color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'Email', value: 'admin@saikumar.link'),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: 'The link is valid for 30 minutes. Check your spam folder if you don\'t see it.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Send reset link', onTap: () => Navigator.pushNamed(context, '/reset')),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
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
                  const LbEyebrow('Reset'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Set a new password.'),
              const SizedBox(height: 8),
              LbBody('Make it at least 10 characters with a number.', color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'New password', obscure: true, value: '••••••••••••'),
              const SizedBox(height: 16),
              const LbField(label: 'Confirm new password', obscure: true, value: '••••••••••••'),
              const SizedBox(height: 32),
              LbButton(label: 'Update password', onTap: () => Navigator.pushNamed(context, '/login-success')),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});
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
                  const LbEyebrow('Step 1 of 4'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Create your account'),
              const SizedBox(height: 8),
              LbBody('It takes about three minutes.', color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'Full name', value: 'Saikumar'),
              const SizedBox(height: 12),
              const LbField(label: 'Email', value: 'admin@saikumar.link', helper: 'Looks good.', helperColor: LbColors.emerald),
              const SizedBox(height: 12),
              const LbField(label: 'Phone', value: '+91 98 7654 3210', keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              const LbField(label: 'Password', obscure: true, value: '••••••••••••', helper: 'At least 10 characters with a number.'),
              const SizedBox(height: 16),
              const LbCheckbox(
                label: 'I agree to the Terms of Service and Privacy Policy.',
                value: true,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/personal-info')),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});
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
                  const LbEyebrow('Step 2 of 4 · Personal'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('A few details about you.'),
              const SizedBox(height: 8),
              LbBody('Helps programs verify your application.', color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'Date of birth', value: '14 March 1986'),
              const SizedBox(height: 12),
              const LbField(label: 'Gender', value: 'Female'),
              const SizedBox(height: 12),
              const LbField(label: 'Occupation', value: 'Teacher'),
              const SizedBox(height: 12),
              const LbField(label: 'Annual household income', value: '₹6,40,000', keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/patient-guardian')),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientGuardianScreen extends StatefulWidget {
  const PatientGuardianScreen({super.key});
  @override
  State<PatientGuardianScreen> createState() => _PatientGuardianScreenState();
}

class _PatientGuardianScreenState extends State<PatientGuardianScreen> {
  int _selected = 0;
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
                  const LbEyebrow('Step 3 of 4 · Patient'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1("Who's the patient?"),
              const SizedBox(height: 8),
              LbBody("This is who we'll be helping.", color: LbColors.fg2),
              const SizedBox(height: 24),
              LbChoice(
                title: 'Ramakrishna',
                subtitle: 'Uncle · Age 41 · Male',
                selected: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
              const SizedBox(height: 8),
              LbChoice(
                title: 'Add another patient',
                subtitle: 'Parent, child, or dependent.',
                selected: _selected == 1,
                onTap: () => setState(() => _selected = 1),
              ),
              const SizedBox(height: 20),
              const LbField(label: 'Patient full name', value: 'Ramakrishna'),
              const SizedBox(height: 12),
              const LbField(label: 'Relationship to you', value: 'Uncle'),
              const SizedBox(height: 12),
              const LbField(label: 'Patient date of birth', value: '22 August 1983'),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/location')),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({super.key});
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
                  const LbEyebrow('Step 3 of 4 · Patient details'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Tell us about Ramakrishna.'),
              const SizedBox(height: 8),
              LbBody('You can update these later.', color: LbColors.fg2),
              const SizedBox(height: 24),
              LbCard(
                child: Row(
                  children: [
                    const LbAvatar(text: 'RA', size: 40),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ramakrishna', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Age 41 · Male', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const LbField(label: 'Occupation', value: 'Self-employed · Mechanic'),
              const SizedBox(height: 12),
              const LbField(label: 'Marital status', value: 'Married'),
              const SizedBox(height: 12),
              const LbField(label: 'Dependents', value: '2 (ages 7 and 4)'),
              const SizedBox(height: 12),
              const LbField(label: 'Annual income', value: '₹3,60,000', keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/location')),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _useCurrent = true;
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
                  const LbEyebrow('Step 4 of 4 · Location'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('Where are you based?'),
              const SizedBox(height: 8),
              LbBody('Helps us find programs in your region.', color: LbColors.fg2),
              const SizedBox(height: 24),
              const LbField(label: 'City', value: 'Bhimavaram'),
              const SizedBox(height: 12),
              const LbField(label: 'State', value: 'Andhra Pradesh'),
              const SizedBox(height: 12),
              const LbField(label: 'PIN code', value: '534 201', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              LbCheckbox(
                label: 'Use my current location for hospital distances.',
                value: _useCurrent,
                onChanged: (v) => setState(() => _useCurrent = v),
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/consent')),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});
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
                  const LbEyebrow('Final step'),
                ],
              ),
              const SizedBox(height: 24),
              const LbH1('A few permissions.'),
              const SizedBox(height: 8),
              LbBody('You can change these any time in Settings.', color: LbColors.fg2),
              const SizedBox(height: 24),
              LbToggleRow(
                title: 'Location (optional)',
                subtitle: 'Find hospitals and programs near you.',
                icon: Icons.place_outlined,
                value: s.locationEnabled,
                onChanged: s.setLocation,
              ),
              const SizedBox(height: 8),
              LbToggleRow(
                title: 'Notifications',
                subtitle: 'Application and follow-up reminders.',
                icon: Icons.access_time,
                value: s.pushEnabled,
                onChanged: s.setPush,
              ),
              const SizedBox(height: 8),
              LbToggleRow(
                title: 'Camera access (later)',
                subtitle: 'Asked when you upload a document.',
                icon: Icons.camera_alt_outlined,
                value: s.cameraEnabled,
                onChanged: s.setCamera,
              ),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: 'Privacy reminder.',
                body: "LifeBridge shares documents only with programs you choose. AI assistance is suggested, not automatic.",
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 32),
              LbButton(label: 'Finish setup', onTap: () {
                s.completeRegistration();
                Navigator.pushReplacementNamed(context, '/registration-success');
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});
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
              LbH1("You're all set, ${s.user.name.split(' ').first}.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Your account is ready. Let's start with your first case.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LbEyebrow('QUICK CHECKLIST'),
                    const SizedBox(height: 12),
                    _ChecklistRow(label: 'Account verified', done: true),
                    const SizedBox(height: 10),
                    _ChecklistRow(label: 'Patient profile added', done: true),
                    const SizedBox(height: 10),
                    _ChecklistRow(label: 'Create your first case', done: false),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Open dashboard', onTap: () {
                s.completeOnboarding();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final String label;
  final bool done;
  const _ChecklistRow({required this.label, required this.done});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: done ? LbColors.successBg : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: done ? LbColors.success : LbColors.border, width: 2),
          ),
          alignment: Alignment.center,
          child: done ? const Icon(Icons.check, color: LbColors.emerald, size: 12) : null,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: done ? LbColors.fg : LbColors.muted))),
      ],
    );
  }
}
