import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../widgets/components.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  int _selected = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BackHeader(onBack: () => Navigator.pop(context)),
                    const SizedBox(height: 12),
                    const LbEyebrow('Almost there'),
                    const SizedBox(height: 8),
                    const LbH1("Let's set up your account."),
                    const SizedBox(height: 8),
                    LbBody('First, tell us who you are.', color: LbColors.fg2),
                    const SizedBox(height: 24),
                    const LbEyebrow('I AM THE…'),
                    const SizedBox(height: 12),
                    LbChoice(
                      title: 'Patient',
                      subtitle: 'Applying for support for myself.',
                      selected: _selected == 0,
                      onTap: () => setState(() => _selected = 0),
                    ),
                    const SizedBox(height: 8),
                    LbChoice(
                      title: 'Caregiver / Family',
                      subtitle: 'Applying on behalf of a family member.',
                      selected: _selected == 1,
                      onTap: () => setState(() => _selected = 1),
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
                  LbButton(label: 'Create my account', onTap: () => Navigator.pushNamed(context, '/user-type')),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: LbColors.muted, fontSize: 13),
                          children: [TextSpan(text: 'Log in', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600))],
                        ),
                      ),
                    ),
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

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});
  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  int _selected = 1;
  final _nameC = TextEditingController(text: 'Arjun Rao');
  final _relC = TextEditingController(text: 'Spouse');
  @override
  void dispose() {
    _nameC.dispose();
    _relC.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BackHeader(onBack: () => Navigator.pop(context)),
                    const SizedBox(height: 12),
                    const LbEyebrow('Continue setup'),
                    const SizedBox(height: 8),
                    const LbH1('Who are you helping?'),
                    const SizedBox(height: 8),
                    LbBody('You can always add another case later.', color: LbColors.fg2),
                    const SizedBox(height: 24),
                    LbChoice(
                      title: 'Myself',
                      subtitle: 'I am the patient.',
                      selected: _selected == 0,
                      onTap: () => setState(() => _selected = 0),
                    ),
                    const SizedBox(height: 8),
                    LbChoice(
                      title: 'A family member',
                      subtitle: 'Parent, child, spouse, or dependent.',
                      selected: _selected == 1,
                      onTap: () => setState(() => _selected = 1),
                    ),
                    const SizedBox(height: 20),
                    LbField(label: 'Their name', controller: _nameC),
                    const SizedBox(height: 16),
                    LbField(label: 'Relationship to you', controller: _relC),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/create-account')),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackHeader extends StatelessWidget {
  final VoidCallback? onBack;
  const _BackHeader({this.onBack});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LbCircleButton(
          icon: Icons.chevron_left,
          size: 44,
          background: LbColors.surface,
          foreground: LbColors.fg,
          onTap: onBack ?? () => Navigator.maybePop(context),
        ),
      ],
    );
  }
}
