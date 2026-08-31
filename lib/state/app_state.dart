import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  bool signedIn = false;
  bool onboardingDone = false;
  bool registrationDone = false;
  bool hasCase = true;

  User user = MockData.currentUser;
  Patient patient = MockData.patient;
  TreatmentDetails treatment = MockData.treatment;
  HospitalDetails hospital = MockData.hospital;
  FinancialInfo financial = MockData.financial;
  InsuranceInfo insurance = MockData.insurance;
  List<ExistingAssistance> existingAssistance = MockData.existingAssistance;
  List<CaseDocument> documents = List.of(MockData.documents);
  CaseEntity mainCase = MockData.mainCase;
  List<SupportProgram> supportPrograms = MockData.supportPrograms;
  List<SupportProgram> newMatches = MockData.newMatches;
  List<ApplicationEntity> applications = List.of(MockData.applications);
  List<FollowUp> followUps = List.of(MockData.followUps);
  List<FollowUp> followUpHistory = List.of(MockData.followUpHistory);
  List<NotificationItem> notifications = List.of(MockData.notifications);
  List<TimelineEvent> caseTimeline = List.of(MockData.caseTimeline);

  String currentCaseType1 = 'Treatment funding';
  String currentCaseType2 = 'Hospital financial assistance';
  final Set<String> selectedCaseTypes = {'Treatment funding', 'Hospital financial assistance'};

  bool aiThinking = false;
  final List<ChatMessage> chatMessages = [];

  bool notificationsEnabled = true;
  bool emailEnabled = true;
  bool smsEnabled = false;
  bool pushEnabled = true;
  bool biometricEnabled = true;
  bool locationEnabled = true;
  bool cameraEnabled = false;
  bool aiAnalyze = true;
  bool aiExtract = true;
  bool aiDraft = true;
  bool autoSignout = true;
  bool autoDetectReplies = true;
  bool calendarSync = false;
  String quietFrom = '22:00';
  String quietTo = '07:00';

  void signIn() {
    signedIn = true;
    notifyListeners();
  }

  void signOut() {
    signedIn = false;
    onboardingDone = false;
    registrationDone = false;
    notifyListeners();
  }

  void completeOnboarding() {
    onboardingDone = true;
    notifyListeners();
  }

  void completeRegistration() {
    registrationDone = true;
    signedIn = true;
    notifyListeners();
  }

  void toggleCaseType(String name) {
    if (selectedCaseTypes.contains(name)) {
      selectedCaseTypes.remove(name);
    } else {
      selectedCaseTypes.add(name);
    }
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final i = notifications.indexWhere((n) => n.id == id);
    if (i >= 0) {
      notifications[i] = NotificationItem(
        id: notifications[i].id,
        title: notifications[i].title,
        meta: notifications[i].meta,
        date: notifications[i].date,
        variant: notifications[i].variant,
        target: notifications[i].target,
        programName: notifications[i].programName,
        reference: notifications[i].reference,
        bodyText: notifications[i].bodyText,
        unread: false,
      );
      notifyListeners();
    }
  }

  void sendChat(String text) {
    chatMessages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      fromUser: true,
      sentAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void addChat(ChatMessage m) {
    chatMessages.add(m);
    notifyListeners();
  }

  void startAIThinking() {
    aiThinking = true;
    notifyListeners();
  }

  void stopAIThinking() {
    aiThinking = false;
    notifyListeners();
  }

  void addDocument(CaseDocument doc) {
    documents.add(doc);
    notifyListeners();
  }

  void setNotifPrefs({bool? push, bool? email, bool? sms}) {
    if (push != null) pushEnabled = push;
    if (email != null) emailEnabled = email;
    if (sms != null) smsEnabled = sms;
    notifyListeners();
  }

  void setQuiet(String from, String to) {
    quietFrom = from;
    quietTo = to;
    notifyListeners();
  }

  void updateUser({String? name, String? email, String? phone, String? dob, String? city}) {
    user = User(
      name: name ?? user.name,
      email: email ?? user.email,
      phone: phone ?? user.phone,
      dob: dob ?? user.dob,
      gender: user.gender,
      occupation: user.occupation,
      city: city ?? user.city,
      state: user.state,
      pincode: user.pincode,
      role: user.role,
      income: user.income,
    );
    notifyListeners();
  }

  void setBiometric(bool v) {
    biometricEnabled = v;
    notifyListeners();
  }

  void setPush(bool v) {
    pushEnabled = v;
    notifyListeners();
  }

  void setEmail(bool v) {
    emailEnabled = v;
    notifyListeners();
  }

  void setSms(bool v) {
    smsEnabled = v;
    notifyListeners();
  }

  void setLocation(bool v) {
    locationEnabled = v;
    notifyListeners();
  }

  void setCamera(bool v) {
    cameraEnabled = v;
    notifyListeners();
  }

  void setAiAnalyze(bool v) {
    aiAnalyze = v;
    notifyListeners();
  }

  void setAiExtract(bool v) {
    aiExtract = v;
    notifyListeners();
  }

  void setAiDraft(bool v) {
    aiDraft = v;
    notifyListeners();
  }

  void setAutoSignout(bool v) {
    autoSignout = v;
    notifyListeners();
  }

  void setAutoDetect(bool v) {
    autoDetectReplies = v;
    notifyListeners();
  }

  void setCalendar(bool v) {
    calendarSync = v;
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }
}
