enum BadgeVariant { draft, review, submitted, approved, rejected, attention }

class Badge {
  final String label;
  final BadgeVariant variant;
  final bool showDot;
  const Badge(this.label, this.variant, {this.showDot = true});
}

enum PillVariant { success, warn, danger, info, neutral, accent }

class Pill {
  final String label;
  final PillVariant variant;
  const Pill(this.label, this.variant);
}

enum CaseType {
  treatmentFunding,
  hospitalAssistance,
  insuranceGap,
  medicationAssistance,
  travelAccommodation,
  communitySupport,
}

const Map<CaseType, String> caseTypeLabels = {
  CaseType.treatmentFunding: 'Treatment funding',
  CaseType.hospitalAssistance: 'Hospital financial assistance',
  CaseType.insuranceGap: 'Insurance gap',
  CaseType.medicationAssistance: 'Medication assistance',
  CaseType.travelAccommodation: 'Travel & accommodation',
  CaseType.communitySupport: 'Community support',
};

const Map<CaseType, String> caseTypeDescriptions = {
  CaseType.treatmentFunding: 'Help with an upcoming or ongoing procedure.',
  CaseType.hospitalAssistance: 'Charity or discounted care at the hospital.',
  CaseType.insuranceGap: "Costs your plan doesn't cover.",
  CaseType.medicationAssistance: 'Discounts or subsidies for prescriptions.',
  CaseType.travelAccommodation: 'Help with travel and stay near the hospital.',
  CaseType.communitySupport: 'Crowdfunding, social workers, NGO grants.',
};

class User {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String gender;
  final String occupation;
  final String city;
  final String state;
  final String pincode;
  final String role;
  final double income;

  const User({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.occupation,
    required this.city,
    required this.state,
    required this.pincode,
    required this.role,
    required this.income,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class Patient {
  final String name;
  final int age;
  final String gender;
  final String relationship;
  final String concern;
  final String occupation;
  final String maritalStatus;
  final int dependents;
  final double annualIncome;

  const Patient({
    required this.name,
    required this.age,
    required this.gender,
    required this.relationship,
    required this.concern,
    required this.occupation,
    required this.maritalStatus,
    required this.dependents,
    required this.annualIncome,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class TreatmentDetails {
  final String type;
  final String diagnosis;
  final double estimatedCost;
  final DateTime startDate;
  final String doctorName;
  final String notes;
  const TreatmentDetails({
    required this.type,
    required this.diagnosis,
    required this.estimatedCost,
    required this.startDate,
    required this.doctorName,
    required this.notes,
  });
}

class HospitalDetails {
  final String name;
  final String city;
  final String department;
  final String patientId;
  const HospitalDetails({
    required this.name,
    required this.city,
    required this.department,
    required this.patientId,
  });
}

class FinancialInfo {
  final double annualIncome;
  final double monthlyExpenses;
  final double savings;
  final bool familySupportPledged;
  final bool activeCrowdfunding;
  final bool employerAssistance;
  const FinancialInfo({
    required this.annualIncome,
    required this.monthlyExpenses,
    required this.savings,
    required this.familySupportPledged,
    required this.activeCrowdfunding,
    required this.employerAssistance,
  });
}

class InsuranceInfo {
  final String provider;
  final String policyNumber;
  final double coverage;
  final double approved;
  final String status;
  const InsuranceInfo({
    required this.provider,
    required this.policyNumber,
    required this.coverage,
    required this.approved,
    required this.status,
  });
}

class ExistingAssistance {
  final String name;
  final String meta;
  final String amount;
  final BadgeVariant statusVariant;
  final String statusLabel;
  const ExistingAssistance({
    required this.name,
    required this.meta,
    required this.amount,
    required this.statusVariant,
    required this.statusLabel,
  });
}

class CaseEntity {
  final String id;
  final String title;
  final String patientName;
  final DateTime startedAt;
  final List<CaseType> types;
  final Patient patient;
  final TreatmentDetails treatment;
  final HospitalDetails hospital;
  final FinancialInfo financial;
  final InsuranceInfo? insurance;
  final List<ExistingAssistance> existingAssistance;
  final List<CaseDocument> documents;
  final double fundingGap;
  final double progress;
  final String stage;
  const CaseEntity({
    required this.id,
    required this.title,
    required this.patientName,
    required this.startedAt,
    required this.types,
    required this.patient,
    required this.treatment,
    required this.hospital,
    required this.financial,
    required this.insurance,
    required this.existingAssistance,
    required this.documents,
    required this.fundingGap,
    required this.progress,
    required this.stage,
  });
}

class CaseDocument {
  final String id;
  final String name;
  final String category;
  final String categoryLabel;
  final String fileType;
  final String size;
  final String? status;
  final BadgeVariant? statusVariant;
  final DateTime? uploadedAt;
  final String? meta;
  const CaseDocument({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.fileType,
    required this.size,
    this.status,
    this.statusVariant,
    this.uploadedAt,
    this.meta,
  });
}

class SupportProgram {
  final String id;
  final String name;
  final String organization;
  final String category;
  final String description;
  final double amount;
  final String amountLabel;
  final int matchPercent;
  final PillVariant pillVariant;
  final String? deadline;
  final int documentsNeeded;
  final bool verified;
  final String verifiedDate;
  final List<String> eligibility;
  final String phone;
  final String email;
  final String location;
  final String? whyMatch;
  const SupportProgram({
    required this.id,
    required this.name,
    required this.organization,
    required this.category,
    required this.description,
    required this.amount,
    required this.amountLabel,
    required this.matchPercent,
    required this.pillVariant,
    this.deadline,
    required this.documentsNeeded,
    required this.verified,
    required this.verifiedDate,
    required this.eligibility,
    required this.phone,
    required this.email,
    required this.location,
    this.whyMatch,
  });
}

class ApplicationEntity {
  final String id;
  final String reference;
  final String programId;
  final String programName;
  final double requestedAmount;
  final double? approvedAmount;
  final String status;
  final BadgeVariant statusVariant;
  final DateTime submittedAt;
  final DateTime responseBy;
  final int progress;
  final String? notes;
  const ApplicationEntity({
    required this.id,
    required this.reference,
    required this.programId,
    required this.programName,
    required this.requestedAmount,
    this.approvedAmount,
    required this.status,
    required this.statusVariant,
    required this.submittedAt,
    required this.responseBy,
    required this.progress,
    this.notes,
  });
}

class FollowUp {
  final String id;
  final String programName;
  final String programId;
  final String reference;
  final String status;
  final BadgeVariant statusVariant;
  final int daysSince;
  final String? lastMessage;
  final DateTime? sentAt;
  final DateTime? repliedAt;
  final bool isOverdue;
  const FollowUp({
    required this.id,
    required this.programName,
    required this.programId,
    required this.reference,
    required this.status,
    required this.statusVariant,
    required this.daysSince,
    this.lastMessage,
    this.sentAt,
    this.repliedAt,
    this.isOverdue = false,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String meta;
  final String date;
  final String variant;
  final String? target;
  final String? programName;
  final String? reference;
  final String? bodyText;
  final bool unread;
  const NotificationItem({
    required this.id,
    required this.title,
    required this.meta,
    required this.date,
    required this.variant,
    this.target,
    this.programName,
    this.reference,
    this.bodyText,
    this.unread = false,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool fromUser;
  final DateTime sentAt;
  const ChatMessage({
    required this.id,
    required this.text,
    required this.fromUser,
    required this.sentAt,
  });
}

class AINeed {
  final String title;
  final String description;
  final String icon;
  const AINeed(this.title, this.description, this.icon);
}

class AIRecommendedDoc {
  final String name;
  final String meta;
  final bool uploaded;
  final String? confidence;
  const AIRecommendedDoc({
    required this.name,
    required this.meta,
    required this.uploaded,
    this.confidence,
  });
}

class TimelineEvent {
  final String id;
  final String title;
  final String meta;
  final DateTime at;
  final bool done;
  final bool active;
  final bool danger;
  final PillVariant? pillVariant;
  final String? pillLabel;
  const TimelineEvent({
    required this.id,
    required this.title,
    required this.meta,
    required this.at,
    this.done = false,
    this.active = false,
    this.danger = false,
    this.pillVariant,
    this.pillLabel,
  });
}
