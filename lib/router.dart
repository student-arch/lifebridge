import 'package:flutter/material.dart';
import 'shell.dart';
import 'screens/splash_01.dart';
import 'screens/get_started_06_07.dart';
import 'screens/login_08.dart';
import 'screens/register_15_21.dart';
import 'screens/home_22_25.dart';
import 'screens/case_create_28_38.dart';
import 'screens/case_created_39.dart';
import 'screens/cases_40_48.dart';
import 'screens/ai_analysis_49_54.dart';
import 'screens/support_55_64.dart';
import 'screens/documents_65_75.dart';
import 'screens/applications_76_99.dart';
import 'screens/followups_100_118.dart';
import 'screens/ai_assistant_119_128.dart';
import 'screens/notifications_129_134.dart';
import 'screens/profile_135_147.dart';
import 'screens/emergency_148_154.dart';
import 'screens/states_155_165.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final r = settings.name ?? '/';
    final builder = _routes[r];
    if (builder != null) {
      return MaterialPageRoute(settings: settings, builder: builder);
    }
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => _MissingRoute(name: r),
    );
  }

  static final Map<String, WidgetBuilder> _routes = {
    '/': (_) => const SplashScreen(),
    '/welcome': (_) => const WelcomeScreen(),
    '/onboarding/1': (_) => const Onboarding1Screen(),
    '/onboarding/2': (_) => const Onboarding2Screen(),
    '/onboarding/3': (_) => const Onboarding3Screen(),
    '/get-started': (_) => const GetStartedScreen(),
    '/user-type': (_) => const UserTypeScreen(),
    '/login': (_) => const LoginScreen(),
    '/login-phone': (_) => const LoginPhoneScreen(),
    '/login-otp': (_) => const LoginOtpScreen(),
    '/forgot': (_) => const ForgotPasswordScreen(),
    '/reset': (_) => const ResetPasswordScreen(),
    '/login-success': (_) => const LoginSuccessScreen(),
    '/create-account': (_) => const CreateAccountScreen(),
    '/personal-info': (_) => const PersonalInfoScreen(),
    '/patient-guardian': (_) => const PatientGuardianScreen(),
    '/patient-info': (_) => const PatientInfoScreen(),
    '/location': (_) => const LocationScreen(),
    '/consent': (_) => const ConsentScreen(),
    '/registration-success': (_) => const RegistrationSuccessScreen(),

    '/home': (_) => const HomeShell(initial: 0),
    '/home/empty': (_) => const HomeEmptyScreen(),
    '/home/active': (_) => const HomeActiveScreen(),
    '/home/attention': (_) => const HomeAttentionScreen(),

    '/case/intro': (_) => const CreateCaseIntroScreen(),
    '/case/type': (_) => const SelectCaseTypeScreen(),
    '/case/patient': (_) => const PatientDetailsScreen(),
    '/case/treatment': (_) => const TreatmentDetailsScreen(),
    '/case/hospital': (_) => const HospitalDetailsScreen(),
    '/case/financial': (_) => const FinancialInfoScreen(),
    '/case/insurance': (_) => const InsuranceInfoScreen(),
    '/case/existing': (_) => const ExistingAssistanceScreen(),
    '/case/documents': (_) => const CaseDocumentUploadScreen(),
    '/case/review': (_) => const ReviewCaseScreen(),
    '/case/consent': (_) => const ConsentSubmitScreen(),
    '/case/created': (_) => const CaseCreatedScreen(),

    '/cases': (_) => const HomeShell(initial: 1),
    '/case/detail': (_) => const CaseDetailScreen(),
    '/case/overview': (_) => const CaseOverviewScreen(),
    '/case/gap': (_) => const CaseFundingGapScreen(),
    '/case/applications': (_) => const CaseApplicationsScreen(),
    '/case/documents-list': (_) => const CaseDocumentsScreen(),
    '/case/matches': (_) => const CaseSupportMatchesScreen(),
    '/case/timeline': (_) => const CaseTimelineScreen(),
    '/case/edit': (_) => const EditCaseScreen(),

    '/ai/analysis': (_) => const AIAnalysisScreen(),
    '/ai/results': (_) => const AIResultsScreen(),
    '/ai/needs': (_) => const AINeedsScreen(),
    '/ai/recommended-support': (_) => const AIRecommendedSupportScreen(),
    '/ai/recommended-docs': (_) => const AIRecommendedDocsScreen(),
    '/ai/next-steps': (_) => const AINextStepsScreen(),

    '/support/sources': (_) => const SupportSourcesScreen(),
    '/support/matches': (_) => const SupportMatchesScreen(),
    '/support/detail': (_) => const SupportSourceDetailScreen(),
    '/support/why': (_) => const WhyThisMatchScreen(),
    '/support/eligibility': (_) => const EligibilityCheckScreen(),
    '/support/eligibility-processing': (_) => const EligibilityProcessingScreen(),
    '/support/eligibility-result': (_) => const EligibilityResultScreen(),
    '/support/required-docs': (_) => const RequiredDocumentsScreen(),
    '/support/verification': (_) => const SupportSourceVerificationScreen(),

    '/docs': (_) => const HomeShell(initial: 2),
    '/docs/center': (_) => const DocumentCenterScreen(),
    '/docs/missing': (_) => const MissingDocumentsScreen(),
    '/docs/upload': (_) => const UploadDocumentScreen(),
    '/docs/source': (_) => const SelectUploadSourceScreen(),
    '/docs/camera': (_) => const CameraFileUploadScreen(),
    '/docs/preview': (_) => const DocumentPreviewScreen(),
    '/docs/category': (_) => const DocumentCategoryScreen(),
    '/docs/extraction': (_) => const AIDocumentExtractionScreen(),
    '/docs/review-extraction': (_) => const ReviewExtractionScreen(),
    '/docs/added': (_) => const DocumentAddedScreen(),
    '/docs/error': (_) => const DocumentErrorScreen(),

    '/app/create': (_) => const CreateApplicationScreen(),
    '/app/select-program': (_) => const SelectProgramScreen(),
    '/app/preparation': (_) => const ApplicationPreparationScreen(),
    '/app/draft': (_) => const AIDraftScreen(),
    '/app/review': (_) => const ApplicationReviewScreen(),
    '/app/edit': (_) => const EditApplicationScreen(),
    '/app/checklist': (_) => const DocumentChecklistScreen(),
    '/app/missing': (_) => const MissingAppDocsScreen(),
    '/app/consent': (_) => const ApplicationConsentScreen(),
    '/app/confirm': (_) => const SubmitConfirmationScreen(),
    '/app/submitting': (_) => const SubmittingScreen(),
    '/app/submitted': (_) => const SubmittedScreen(),
    '/app/failed': (_) => const SubmissionFailedScreen(),
    '/app/receipt': (_) => const ApplicationReceiptScreen(),
    '/app/list': (_) => const ApplicationsListScreen(),
    '/app/detail': (_) => const ApplicationDetailScreen(),
    '/app/status': (_) => const ApplicationStatusScreen(),
    '/app/timeline': (_) => const ApplicationTimelineScreen(),
    '/app/under-review': (_) => const AppUnderReviewScreen(),
    '/app/info-required': (_) => const AppInfoRequiredScreen(),
    '/app/approved': (_) => const AppApprovedScreen(),
    '/app/rejected': (_) => const AppRejectedScreen(),
    '/app/rejection-details': (_) => const RejectionDetailsScreen(),
    '/app/rejection-recovery': (_) => const RejectionRecoveryScreen(),

    '/find-alternative': (_) => const FindAlternativeScreen(),
    '/followups': (_) => const HomeShell(initial: 3),
    '/followups/list': (_) => const FollowUpListScreen(),
    '/followups/detail': (_) => const FollowUpDetailScreen(),
    '/followups/reminder': (_) => const FollowUpReminderScreen(),
    '/followups/draft': (_) => const AIFollowUpDraftScreen(),
    '/followups/edit': (_) => const EditFollowUpScreen(),
    '/followups/confirm': (_) => const ConfirmFollowUpScreen(),
    '/followups/sent': (_) => const FollowUpSentScreen(),
    '/followups/failed': (_) => const FollowUpFailedScreen(),
    '/followups/history': (_) => const FollowUpHistoryScreen(),
    '/followups/overdue': (_) => const OverdueFollowUpScreen(),
    '/followups/need-help': (_) => const NeedMoreHelpScreen(),
    '/followups/select-changed': (_) => const SelectWhatChangedScreen(),
    '/followups/change-details': (_) => const ChangeDetailsScreen(),
    '/followups/reassessing': (_) => const ReassessmentProcessingScreen(),
    '/followups/updated-gap': (_) => const UpdatedGapScreen(),
    '/followups/new-matches': (_) => const NewMatchesScreen(),
    '/followups/no-matches': (_) => const NoMatchesScreen(),
    '/followups/reassessment-complete': (_) => const ReassessmentCompleteScreen(),

    '/ai/assistant': (_) => const AIAssistantHomeScreen(),
    '/ai/chat': (_) => const AIChatScreen(),
    '/ai/thinking': (_) => const AIProcessingScreen(),
    '/ai/response': (_) => const AIResponseScreen(),
    '/ai/action': (_) => const AIActionScreen(),
    '/ai/action-confirm': (_) => const AIActionConfirmationScreen(),
    '/ai/needs-info': (_) => const AINeedsInfoScreen(),
    '/ai/cant-determine': (_) => const AICantDetermineScreen(),
    '/ai/human': (_) => const HumanEscalationScreen(),

    '/notifications': (_) => const NotificationsScreen(),
    '/notifications/app-update': (_) => const ApplicationUpdateScreen(),
    '/notifications/doc-required': (_) => const DocumentRequiredScreen(),
    '/notifications/followup-reminder': (_) => const FollowupReminderScreen(),
    '/notifications/new-match': (_) => const NewSupportMatchScreen(),
    '/notifications/deadline': (_) => const DeadlineReminderScreen(),

    '/profile': (_) => const HomeShell(initial: 4),
    '/profile/view': (_) => const ProfileScreen(),
    '/profile/edit': (_) => const EditProfileScreen(),
    '/settings': (_) => const SettingsScreen(),
    '/settings/notifications': (_) => const NotificationPrefsScreen(),
    '/settings/privacy': (_) => const PrivacyScreen(),
    '/settings/data-sharing': (_) => const DataSharingScreen(),
    '/settings/security': (_) => const SecurityScreen(),
    '/settings/change-password': (_) => const ChangePasswordScreen(),
    '/settings/biometric': (_) => const BiometricScreen(),
    '/settings/connected-orgs': (_) => const ConnectedOrgsScreen(),
    '/help': (_) => const HelpFAQScreen(),
    '/about': (_) => const AboutScreen(),
    '/signout': (_) => const SignOutScreen(),

    '/emergency': (_) => const EmergencyHubScreen(),
    '/emergency/disclaimer': (_) => const EmergencyDisclaimerScreen(),
    '/emergency/hospital': (_) => const HospitalAssistanceScreen(),
    '/emergency/blood': (_) => const BloodSupportScreen(),
    '/emergency/financial': (_) => const EmergencyFinancialScreen(),
    '/emergency/contacts': (_) => const EmergencyContactsScreen(),
    '/emergency/confirm': (_) => const EmergencyConfirmScreen(),

    '/states/loading': (_) => const GlobalLoadingScreen(),
    '/states/skeleton': (_) => const SkeletonLoadingScreen(),
    '/states/empty': (_) => const EmptyScreen(),
    '/states/offline': (_) => const OfflineScreen(),
    '/states/network-error': (_) => const NetworkErrorScreen(),
    '/states/error': (_) => const GenericErrorScreen(),
    '/states/retry': (_) => const RetryScreen(),
    '/states/permission': (_) => const PermissionScreen(),
    '/states/session-expired': (_) => const SessionExpiredScreen(),
    '/states/action-success': (_) => const ActionSuccessScreen(),
    '/states/action-failed': (_) => const ActionFailedScreen(),
  };
}

class _MissingRoute extends StatelessWidget {
  final String name;
  const _MissingRoute({required this.name});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Center(child: Text('Route not found')),
    );
  }
}

class AppNavigator {
  static void push(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void pushReplacement(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  static void pushAndRemoveUntil(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  static void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

class HomeShell extends StatelessWidget {
  final int initial;
  const HomeShell({super.key, this.initial = 0});

  @override
  Widget build(BuildContext context) {
    return MainShell(initial: initial);
  }
}
