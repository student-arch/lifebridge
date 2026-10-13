import '../models/models.dart';

class MockData {
  static User currentUser = const User(
    name: 'Saikumar',
    email: 'admin@saikumar.link',
    phone: '+91 98 7654 3210',
    dob: '14 March 1986',
    gender: 'Female',
    occupation: 'Teacher',
    city: 'Bhimavaram',
    state: 'Andhra Pradesh',
    pincode: '534 201',
    role: 'Caregiver / Family',
    income: 640000,
  );

  static Patient patient = const Patient(
    name: 'Ramakrishna',
    age: 41,
    gender: 'Male',
    relationship: 'Uncle',
    concern: 'Cardiac — angiogram scheduled',
    occupation: 'Self-employed · Mechanic',
    maritalStatus: 'Married',
    dependents: 2,
    annualIncome: 360000,
  );

  static TreatmentDetails treatment = TreatmentDetails(
    type: 'Cardiac catheterization + angioplasty',
    diagnosis: 'Triple-vessel coronary artery disease',
    estimatedCost: 480000,
    startDate: _d(2026, 5, 2),
    doctorName: 'Dr. Kavitha Reddy',
    notes: 'Awaiting insurance pre-authorization.',
  );

  static HospitalDetails hospital = const HospitalDetails(
    name: 'Bhimavaram General Hospital',
    city: 'Bhimavaram',
    department: 'Cardiology',
    patientId: 'BGH-234-1983',
  );

  static FinancialInfo financial = const FinancialInfo(
    annualIncome: 640000,
    monthlyExpenses: 42000,
    savings: 50000,
    familySupportPledged: false,
    activeCrowdfunding: true,
    employerAssistance: false,
  );

  static InsuranceInfo insurance = const InsuranceInfo(
    provider: 'Star Health · Family Plan',
    policyNumber: 'SH-2024-918-23',
    coverage: 500000,
    approved: 150000,
    status: 'Pre-authorization pending',
  );

  static List<ExistingAssistance> existingAssistance = const [
    ExistingAssistance(
      name: 'State Treatment Scheme',
      meta: '₹60,000 approved · 8 days ago',
      amount: '₹60,000',
      statusVariant: BadgeVariant.approved,
      statusLabel: 'Approved',
    ),
    ExistingAssistance(
      name: 'Crowdfunding · Milaap',
      meta: '₹38,000 raised of ₹2,00,000',
      amount: '₹38,000',
      statusVariant: BadgeVariant.submitted,
      statusLabel: 'Active',
    ),
  ];

  static List<CaseDocument> documents = [
    CaseDocument(
      id: 'd1',
      name: 'Aadhaar card · Ramakrishna',
      category: 'ID',
      categoryLabel: 'ID proof',
      fileType: 'PDF',
      size: '2.1 MB',
      uploadedAt: _now(),
      meta: 'Uploaded just now',
    ),
    CaseDocument(
      id: 'd2',
      name: "Doctor's prescription",
      category: 'Medical',
      categoryLabel: 'Treatment proof',
      fileType: 'IMG',
      size: '1.4 MB',
      uploadedAt: _now(),
      meta: 'Uploaded just now',
    ),
    CaseDocument(
      id: 'd3',
      name: 'Income certificate',
      category: 'Financial',
      categoryLabel: 'Income',
      fileType: 'PDF',
      size: '1.2 MB',
      uploadedAt: _d(2026, 4, 14),
    ),
    CaseDocument(
      id: 'd4',
      name: 'Insurance pre-authorization',
      category: 'Insurance',
      categoryLabel: 'Insurance',
      fileType: 'PDF',
      size: '0.8 MB',
      uploadedAt: _d(2026, 4, 16),
    ),
  ];

  static CaseEntity mainCase = CaseEntity(
    id: 'c1',
    title: 'Cardiac Treatment Assistance',
    patientName: 'Ramakrishna',
    startedAt: _d(2026, 4, 12),
    types: const [
      CaseType.treatmentFunding,
      CaseType.hospitalAssistance,
    ],
    patient: patient,
    treatment: treatment,
    hospital: hospital,
    financial: financial,
    insurance: insurance,
    existingAssistance: existingAssistance,
    documents: documents,
    fundingGap: 280000,
    progress: 38,
    stage: 'Active',
  );

  static List<SupportProgram> supportPrograms = [
    const SupportProgram(
      id: 'p1',
      name: 'Heart Care Trust',
      organization: 'Cardiac-specific trust · Bhimavaram',
      category: 'NGO',
      description: 'Provides direct financial assistance for cardiac procedures at partner hospitals in Andhra Pradesh. Open to families earning below ₹8 LPA.',
      amount: 150000,
      amountLabel: 'Up to ₹1,50,000',
      matchPercent: 92,
      pillVariant: PillVariant.success,
      deadline: '7 May 2026',
      documentsNeeded: 3,
      verified: true,
      verifiedDate: '12 March 2026',
      eligibility: [
        'Cardiac procedure planned or scheduled',
        'Annual income < ₹8,00,000',
        'Andhra Pradesh resident',
        '3 documents required (see list)',
      ],
      phone: '+91 8816 129 087',
      email: 'contact@heartcaretrust.org',
      location: 'Bhimavaram, AP',
      whyMatch: 'Cardiac-specific fund. They focus on procedures like the one Ramakrishna needs.',
    ),
    const SupportProgram(
      id: 'p2',
      name: 'Godavari Charity Care',
      organization: 'Godavari Hospitals · in-network',
      category: 'Hospital',
      description: '30–60% off billed cost for families below income threshold.',
      amount: 480000,
      amountLabel: '30–60% off',
      matchPercent: 88,
      pillVariant: PillVariant.success,
      documentsNeeded: 2,
      verified: true,
      verifiedDate: '12 March 2026',
      eligibility: [
        'Procedure at Bhimavaram General Hospital',
        'Annual income < ₹6,00,000',
        'Charity-care interview required',
        '2 documents required (see list)',
      ],
      phone: '+91 8816 401 060',
      email: 'charity@godavarihospitals.org',
      location: 'Bhimavaram, AP',
    ),
    const SupportProgram(
      id: 'p3',
      name: 'Seva Community Fund',
      organization: 'Local NGO · family-focused',
      category: 'NGO',
      description: 'Up to ₹80,000 for medical costs, travel, and family support.',
      amount: 80000,
      amountLabel: 'Up to ₹80,000',
      matchPercent: 81,
      pillVariant: PillVariant.info,
      documentsNeeded: 1,
      verified: true,
      verifiedDate: '12 March 2026',
      eligibility: [
        'Family-focused cases',
        'Annual income < ₹5,00,000',
        'Resident of Andhra Pradesh',
      ],
      phone: '+91 8816 927 771',
      email: 'contact@sevacommunity.org',
      location: 'Bhimavaram, AP',
    ),
    const SupportProgram(
      id: 'p4',
      name: 'State Treatment Scheme',
      organization: 'Andhra Pradesh Health Department',
      category: 'Government',
      description: 'Up to ₹1,00,000 · longer review (6–8 weeks).',
      amount: 100000,
      amountLabel: 'Up to ₹1,00,000',
      matchPercent: 74,
      pillVariant: PillVariant.warn,
      documentsNeeded: 5,
      verified: true,
      verifiedDate: '12 March 2026',
      eligibility: [
        'Andhra Pradesh resident',
        'BPL or low-income family',
        'Government hospital procedure',
      ],
      phone: '0866-2482000',
      email: 'sts@ap.gov.in',
      location: 'Andhra Pradesh',
    ),
    const SupportProgram(
      id: 'p5',
      name: "Children's Cardiac Aid",
      organization: 'Travel & accommodation support',
      category: 'NGO',
      description: 'Subsidized stay near hospital; transport reimbursement.',
      amount: 50000,
      amountLabel: 'Travel & stay',
      matchPercent: 68,
      pillVariant: PillVariant.info,
      documentsNeeded: 2,
      verified: true,
      verifiedDate: '12 March 2026',
      eligibility: [
        'Out-of-town treatment',
        'Family accompanies patient',
      ],
      phone: '+91 8816 129 090',
      email: 'help@childrensaid.org',
      location: 'Bhimavaram, AP',
    ),
  ];

  static List<SupportProgram> newMatches = [
    const SupportProgram(
      id: 'p6',
      name: 'Hope Foundation',
      organization: 'Cardiac families · Mumbai',
      category: 'NGO',
      description: 'New option · High benefit',
      amount: 200000,
      amountLabel: 'Up to ₹2,00,000',
      matchPercent: 89,
      pillVariant: PillVariant.success,
      documentsNeeded: 3,
      verified: true,
      verifiedDate: '18 April 2026',
      eligibility: ['Cardiac-specific', 'Income below ₹8LPA'],
      phone: '+91 22 4112 9090',
      email: 'help@hopefoundation.org',
      location: 'Mumbai, MH',
    ),
    const SupportProgram(
      id: 'p7',
      name: 'Manipal Hospital Aid',
      organization: 'Hospital-based · 5 locations',
      category: 'Hospital',
      description: '30–50% off · Network includes Godavari Hospitals',
      amount: 240000,
      amountLabel: '30–50% off',
      matchPercent: 84,
      pillVariant: PillVariant.success,
      documentsNeeded: 2,
      verified: true,
      verifiedDate: '18 April 2026',
      eligibility: ['Network hospitals', 'Below income threshold'],
      phone: '+91 866 241 061',
      email: 'aid@manipal.com',
      location: 'Vijayawada, AP',
    ),
    const SupportProgram(
      id: 'p8',
      name: 'Caring Hands Trust',
      organization: 'Family-support focus',
      category: 'NGO',
      description: 'Plus post-op support',
      amount: 100000,
      amountLabel: 'Up to ₹1,00,000',
      matchPercent: 78,
      pillVariant: PillVariant.info,
      documentsNeeded: 2,
      verified: true,
      verifiedDate: '18 April 2026',
      eligibility: ['Family support focus', 'Andhra Pradesh residents'],
      phone: '+91 8816 129 091',
      email: 'care@caringhands.org',
      location: 'Bhimavaram, AP',
    ),
    const SupportProgram(
      id: 'p9',
      name: 'Medication Subsidy',
      organization: 'Post-surgery medication',
      category: 'Pharma',
      description: '6 months of cardiac medication',
      amount: 30000,
      amountLabel: '6mo medication',
      matchPercent: 72,
      pillVariant: PillVariant.info,
      documentsNeeded: 1,
      verified: true,
      verifiedDate: '18 April 2026',
      eligibility: ['Cardiac patient', 'Prescription on file'],
      phone: '+91 8816 129 092',
      email: 'subsidy@medorg.org',
      location: 'Bhimavaram, AP',
    ),
  ];

  static List<ApplicationEntity> applications = [
    ApplicationEntity(
      id: 'a1',
      reference: 'HCT-2026-04812',
      programId: 'p1',
      programName: 'Heart Care Trust',
      requestedAmount: 150000,
      status: 'Under review',
      statusVariant: BadgeVariant.submitted,
      submittedAt: _d(2026, 4, 22),
      responseBy: _d(2026, 5, 6),
      progress: 35,
    ),
    ApplicationEntity(
      id: 'a2',
      reference: 'SCF-2026-0183',
      programId: 'p3',
      programName: 'Seva Community Fund',
      requestedAmount: 80000,
      status: 'Draft',
      statusVariant: BadgeVariant.review,
      submittedAt: _d(2026, 4, 18),
      responseBy: _d(2026, 5, 5),
      progress: 0,
    ),
    ApplicationEntity(
      id: 'a3',
      reference: 'STS-2026-7740',
      programId: 'p4',
      programName: 'State Treatment Scheme',
      requestedAmount: 100000,
      status: 'Under review',
      statusVariant: BadgeVariant.submitted,
      submittedAt: _d(2026, 4, 15),
      responseBy: _d(2026, 5, 14),
      progress: 50,
    ),
  ];

  static List<FollowUp> followUps = [
    FollowUp(
      id: 'f1',
      programName: 'Seva Community Fund',
      programId: 'p3',
      reference: 'SCF-2026-0183',
      status: 'Overdue',
      statusVariant: BadgeVariant.rejected,
      daysSince: 9,
      lastMessage: "Dear Seva Community Fund team, I'm following up on behalf of Saikumar regarding application SCF-2026-0183...",
      isOverdue: true,
    ),
    FollowUp(
      id: 'f2',
      programName: 'Godavari Charity Care',
      programId: 'p2',
      reference: '',
      status: 'Due in 3d',
      statusVariant: BadgeVariant.review,
      daysSince: 4,
    ),
  ];

  static List<FollowUp> followUpHistory = [
    FollowUp(
      id: 'fh1',
      programName: 'Seva Community Fund',
      programId: 'p3',
      reference: 'SCF-2026-0183',
      status: 'Sent',
      statusVariant: BadgeVariant.submitted,
      daysSince: 0,
      sentAt: _d(2026, 4, 22),
      lastMessage: "Dear Seva Community Fund team, I'm following up on behalf of Saikumar...",
    ),
    FollowUp(
      id: 'fh2',
      programName: 'State Treatment Scheme',
      programId: 'p4',
      reference: 'STS-2026-7740',
      status: 'Replied',
      statusVariant: BadgeVariant.approved,
      daysSince: 6,
      sentAt: _d(2026, 4, 9),
      repliedAt: _d(2026, 4, 16),
      lastMessage: 'Your case is now under departmental review.',
    ),
    FollowUp(
      id: 'fh3',
      programName: 'State Treatment Scheme',
      programId: 'p4',
      reference: 'STS-2026-7740',
      status: 'Sent',
      statusVariant: BadgeVariant.submitted,
      daysSince: 13,
      sentAt: _d(2026, 4, 9),
      lastMessage: 'Following up on STS-2026-7740...',
    ),
  ];

  static List<NotificationItem> notifications = [
    const NotificationItem(
      id: 'n1',
      title: 'Heart Care Trust received your application',
      meta: '22 April · 9:41 AM',
      date: '22 April · 9:41 AM',
      variant: 'info',
      target: 'app',
      programName: 'Heart Care Trust',
      reference: 'HCT-2026-04812',
      unread: true,
    ),
    const NotificationItem(
      id: 'n2',
      title: 'Seva Fund needs 1 more document',
      meta: '21 April · 3:12 PM',
      date: '21 April · 3:12 PM',
      variant: 'warn',
      target: 'doc',
      programName: 'Seva Fund',
      reference: 'SCF-2026-0183',
      unread: true,
    ),
    const NotificationItem(
      id: 'n3',
      title: 'Seva Fund has not responded in 9 days',
      meta: '22 April · 8:00 AM',
      date: '22 April · 8:00 AM',
      variant: 'danger',
      target: 'followup',
      programName: 'Seva Fund',
      unread: true,
    ),
    const NotificationItem(
      id: 'n4',
      title: 'New match: Hope Foundation (89%)',
      meta: '20 April · 11:32 AM',
      date: '20 April · 11:32 AM',
      variant: 'accent',
      target: 'match',
      programName: 'Hope Foundation',
    ),
    const NotificationItem(
      id: 'n5',
      title: 'Heart Care Trust deadline in 15 days',
      meta: '19 April · 9:00 AM',
      date: '19 April · 9:00 AM',
      variant: 'warn',
      target: 'deadline',
      programName: 'Heart Care Trust',
    ),
    const NotificationItem(
      id: 'n6',
      title: 'Welcome to LifeBridge',
      meta: '12 April · 4:32 PM',
      date: '12 April · 4:32 PM',
      variant: 'success',
    ),
  ];

  static List<AINeed> aiNeeds = const [
    AINeed('Hospital financial assistance',
        "Godavari Hospitals has a charity-care program that can reduce cardiac procedure costs by 30–60%.", 'home'),
    AINeed('Treatment funding',
        'Estimated ₹2.8L gap after insurance and savings.', 'card'),
    AINeed('Community medical support',
        'Two local NGOs in Bhimavaram specifically fund cardiac care.', 'plus_circle'),
    AINeed('Travel & accommodation',
        'Hospital partner offers subsidized stay for patient families during procedure.', 'plus'),
  ];

  static List<AIRecommendedDoc> aiRecommendedDocs = const [
    AIRecommendedDoc(name: 'Income certificate', meta: 'Required by 3 programs', uploaded: false),
    AIRecommendedDoc(name: 'Estimated cost breakdown', meta: 'Required by 2 programs', uploaded: false),
    AIRecommendedDoc(name: 'Aadhaar card', meta: 'Already uploaded · 2 min ago', uploaded: true),
    AIRecommendedDoc(name: "Doctor's prescription", meta: 'Already uploaded · 2 min ago', uploaded: true),
  ];

  static List<TimelineEvent> caseTimeline = [
    TimelineEvent(id: 't1', title: 'Case created', meta: '12 April · 4:32 PM', at: _d(2026, 4, 12), done: true),
    TimelineEvent(id: 't2', title: 'AI analysis complete', meta: '12 April · 4:33 PM · 5 programs matched · 2 documents needed', at: _d(2026, 4, 12), done: true),
    TimelineEvent(id: 't3', title: 'Income certificate uploaded', meta: '14 April · 9:18 AM', at: _d(2026, 4, 14), done: true),
    TimelineEvent(id: 't4', title: 'Application sent: Heart Care Trust', meta: '22 April · 9:41 AM', at: _d(2026, 4, 22), done: true),
    TimelineEvent(id: 't5', title: 'Follow-up sent: Seva Community Fund', meta: '22 April · 9:42 AM', at: _d(2026, 4, 22), done: true),
    TimelineEvent(id: 't6', title: 'Waiting for State Treatment Scheme', meta: 'In progress', at: _d(2026, 4, 23), active: true),
    TimelineEvent(id: 't7', title: 'Treatment date — 2 May 2026', meta: 'Upcoming', at: _d(2026, 5, 2)),
  ];

  static List<TimelineEvent> appTimeline(String ref) {
    return [
      TimelineEvent(
        id: 'at1',
        title: 'Application submitted',
        meta: '22 April · 9:41 AM',
        at: _d(2026, 4, 22),
        done: true,
        pillLabel: 'Receipt #$ref',
        pillVariant: PillVariant.success,
      ),
      TimelineEvent(
        id: 'at2',
        title: 'Received by Heart Care Trust',
        meta: '22 April · 11:02 AM · auto-confirmation',
        at: _d(2026, 4, 22),
        done: true,
      ),
      TimelineEvent(
        id: 'at3',
        title: 'Initial review',
        meta: 'Started 22 April · 4:18 PM',
        at: _d(2026, 4, 22),
        active: true,
      ),
      TimelineEvent(
        id: 'at4',
        title: 'Decision',
        meta: 'Expected by 6 May 2026',
        at: _d(2026, 5, 6),
      ),
    ];
  }

  static String followUpDraft(String programName, String reference) {
    return "Dear $programName team,\n\n"
        "I'm following up on behalf of Saikumar regarding application $reference, "
        "submitted on 13 April 2026 for assistance with my uncle Ramakrishna's cardiac procedure "
        "at Bhimavaram General Hospital, Bhimavaram. We understand you're reviewing many requests, "
        "and we appreciate the time you're taking.\n\n"
        "We wanted to check whether any additional information would be helpful, and confirm "
        "that the procedure is scheduled for 2 May 2026. Please let us know if we can provide "
        "anything further.\n\n"
        "With gratitude,\nSaikumar (caregiver for Ramakrishna)";
  }

  static String personalStatementDraft() {
    return "I am writing to request financial assistance for my uncle Ramakrishna, who has been diagnosed with triple-vessel coronary artery disease. He is 41.\n\n"
        "The recommended procedure — cardiac catheterization with angioplasty — is scheduled for 2 May at Bhimavaram General Hospital, Bhimavaram. The estimated cost is ₹4,80,000. Our insurance pre-authorization covers only ₹1,50,000, and we have ₹50,000 in savings.\n\n"
        "Any support you can offer would help us bridge the remaining gap… We are grateful for your consideration.";
  }
}

DateTime _d(int y, int m, int day) => DateTime(y, m, day);
DateTime _now() => DateTime(2026, 4, 22, 9, 41);
