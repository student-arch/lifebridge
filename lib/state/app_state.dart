import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/ai_service.dart';

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

  // --- AI backend configuration (Profile > Settings > AI assistant) ---
  // OpenAI-compatible: base URL + API key + model name. Read at call time
  // so switching models takes effect on the very next request.
  //
  // No key is bundled: the user enters a personal key once in the app and it
  // persists on-device. (A hardcoded key would ship inside the APK and the
  // git history, and secret scanners rightly block it.)
  static const String defaultAiBaseUrl = 'https://openrouter.ai/api/v1';
  static const String defaultAiModel = 'openrouter/free';

  String aiBaseUrl = defaultAiBaseUrl;
  String aiApiKey = '';
  String aiModel = defaultAiModel;

  /// The values actually sent with requests.
  String get effectiveAiBaseUrl => aiBaseUrl.trim().isEmpty ? defaultAiBaseUrl : aiBaseUrl.trim();
  String get effectiveAiApiKey => aiApiKey.trim();
  String get effectiveAiModel => aiModel.trim().isEmpty ? defaultAiModel : aiModel.trim();

  bool get aiConfigured => effectiveAiApiKey.isNotEmpty;

  Future<void> loadAiSettings() async {
    try {
      final p = await SharedPreferences.getInstance();
      aiBaseUrl = p.getString('ai_base_url') ?? aiBaseUrl;
      aiApiKey = p.getString('ai_api_key') ?? '';
      aiModel = p.getString('ai_model') ?? aiModel;
    } catch (_) {
      // Storage unavailable: keep in-memory defaults.
    }
    notifyListeners();
  }

  Future<void> saveAiSettings({required String baseUrl, required String apiKey, required String model}) async {
    aiBaseUrl = baseUrl.trim();
    aiApiKey = apiKey.trim();
    aiModel = model.trim();
    notifyListeners();
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('ai_base_url', aiBaseUrl);
      await p.setString('ai_api_key', aiApiKey);
      await p.setString('ai_model', aiModel);
    } catch (_) {
      // Storage unavailable: settings still apply for this session.
    }
  }

  /// Compact, non-sensitive case summary injected into AI system prompts so
  /// answers are grounded in the user's actual application data.
  String aiCaseContext() {
    final programs = supportPrograms.take(5).map((p) => '${p.name} (${p.organization}, ${p.amountLabel}, ${p.matchPercent}% match)').join('; ');
    final docs = documents.take(6).map((d) => d.name).join(', ');
    return '''
User: ${user.name} (${user.email}, ${user.phone}), ${user.city}, ${user.state}.
Patient: ${patient.name}, age ${patient.age}, ${patient.gender}.
Case: ${mainCase.title}. Treatment: ${treatment.type} (${treatment.diagnosis}) at ${hospital.name}; est. cost ${_inr(treatment.estimatedCost)}; funding gap ${_inr(mainCase.fundingGap)}.
Household income: ${_inr(financial.annualIncome)}; insurance: ${insurance.provider} (${insurance.status}).
Top programs: $programs.
Documents on file: $docs.
''';
  }

  static String _inr(double v) {
    final n = v.round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromRight = s.length - i;
      buf.write(s[i]);
      if (fromRight > 1 && (fromRight == 4 || (fromRight > 4 && (fromRight - 4) % 2 == 1))) buf.write(',');
    }
    return '₹$buf';
  }

  String aiSystemPrompt(String role) {
    return 'You are LifeBridge AI, a compassionate patient-assistance helper inside the LifeBridge app. '
        'Answer concisely in plain language (no markdown tables). Never invent program decisions, approvals, or deadlines; '
        'say when something needs confirmation from the program. Do not give medical advice beyond general information. '
        'SCOPE: only answer questions related to this app — patient assistance, support programs, cases, applications, '
        'documents, follow-ups, and using LifeBridge itself. If the user asks about anything else, politely decline in '
        'one sentence and redirect them to what you can help with in the app. '
        'User context:\n${aiCaseContext()}\nTask: $role';
  }

  /// Single entry point for AI text generation. Throws [AiException] with a
  /// user-facing message when unconfigured or when the request fails — callers
  /// must surface it, never silently fall back to static text.
  Future<String> askAi({
    required String task,
    required List<AiChatMessage> messages,
    double temperature = 0.4,
    int maxTokens = 900,
    bool jsonMode = false,
    int keepLastMessages = 10,
    http.Client? client,
  }) {
    return AiService.chat(
      baseUrl: effectiveAiBaseUrl,
      apiKey: effectiveAiApiKey,
      model: effectiveAiModel,
      messages: [AiChatMessage(role: 'system', content: aiSystemPrompt(task)), ..._tail(messages, keepLastMessages)],
      temperature: temperature,
      maxTokens: maxTokens,
      jsonMode: jsonMode,
      client: client,
    );
  }

  // Sliding window: the UI keeps full history, but only the tail is sent,
  // so long conversations stop blowing the model's context limit.
  static List<AiChatMessage> _tail(List<AiChatMessage> messages, int keep) {
    if (messages.length <= keep) return messages;
    return messages.sublist(messages.length - keep);
  }

  /// Structured-output variant of [askAi] for the analysis/extraction screens.
  /// Uses JSON mode, a low temperature, and a generous token budget; if the
  /// first reply still is not parseable JSON, it makes ONE more genuine
  /// request asking for clean JSON before giving up with an honest error.
  Future<Map<String, dynamic>> askAiJson({
    required String task,
    required String userContent,
    int maxTokens = 2200,
    http.Client? client,
  }) async {
    Future<Map<String, dynamic>?> attempt(String content) async {
      final raw = await askAi(
        task: task,
        messages: [AiChatMessage(role: 'user', content: content)],
        temperature: 0.1,
        maxTokens: maxTokens,
        jsonMode: true,
        client: client,
      );
      return AiService.parseJsonObject(raw);
    }

    var parsed = await attempt(userContent);
    parsed ??= await attempt(
      '$userContent\n\nIMPORTANT: your previous reply was not valid JSON. Reply now with ONLY the JSON object — no markdown fences, no prose, no commentary.',
    );
    if (parsed != null) return parsed;
    throw const AiException('The AI returned a response this app could not understand. Try again.');
  }

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
