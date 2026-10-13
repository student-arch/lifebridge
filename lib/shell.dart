import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'state/app_state.dart';
import 'widgets/components.dart';
import 'screens/home_22_25.dart';
import 'screens/documents_65_75.dart';
import 'screens/followups_100_118.dart';
import 'screens/profile_135_147.dart';

class MainShell extends StatefulWidget {
  final int initial;
  const MainShell({super.key, this.initial = 0});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initial;
  AppState? _state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s = AppScope.read(context);
    if (s != _state) {
      _state?.removeListener(_onAuthChanged);
      _state = s;
      _state?.addListener(_onAuthChanged);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _enforceAuth();
      });
    }
  }

  @override
  void dispose() {
    _state?.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    _enforceAuth();
  }

  void _enforceAuth() {
    if (!mounted || _state == null) return;
    if (!_state!.signedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: IndexedStack(
        index: _index,
        children: [
          s.hasCase ? const HomeDashboardScreen() : const HomeEmptyScreen(),
          const CasesListScreen(),
          const DocumentCenterScreen(),
          const FollowUpListScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: LbTabBar(
        activeIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          LbTabItem(Icons.home_outlined, 'Home'),
          LbTabItem(Icons.folder_special_outlined, 'Cases'),
          LbTabItem(Icons.folder_outlined, 'Docs'),
          LbTabItem(Icons.notifications_active_outlined, 'Follow-up'),
          LbTabItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
}
