class SalonSummary {
  final int id;
  final String name;
  final String area;
  final String? phone;

  const SalonSummary({
    required this.id,
    required this.name,
    required this.area,
    this.phone,
  });

  factory SalonSummary.fromJson(Map<String, dynamic> json) {
    return SalonSummary(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      phone: json['phone'],
    );
  }
}

class JobModel {
  final int id;
  final int salonId;
  final String menu;
  final String area;
  final String jobDate;   // "2026-02-27"
  final String startTime; // "16:00:00"
  final String endTime;   // "19:00:00"
  final String? modelType; // "trainee" | "experienced"
  final int price;
  final String priceType; // "income" | "deduction"
  final String? description;
  final String status; // "open" | "closed" | "completed"
  final SalonSummary salon;
  final int applicantCount;

  const JobModel({
    required this.id,
    required this.salonId,
    required this.menu,
    required this.area,
    required this.jobDate,
    required this.startTime,
    required this.endTime,
    this.modelType,
    required this.price,
    required this.priceType,
    this.description,
    required this.status,
    required this.salon,
    this.applicantCount = 0,
  });

  /// Returns "HH:MM" format
  String get startTimeShort => startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
  String get endTimeShort => endTime.length >= 5 ? endTime.substring(0, 5) : endTime;

  String get timeRange => '$startTimeShort - $endTimeShort';

  bool get isIncome => priceType == 'income';

  String get formattedPrice =>
      isIncome ? '+¥${_formatYen(price)}' : '-¥${_formatYen(price)}';

  String _formatYen(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  String get modelTypeLabel {
    switch (modelType) {
      case 'trainee': return '研修生用モデル';
      case 'experienced': return '実績用モデル';
      default: return '';
    }
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      salonId: json['salon_id'],
      menu: json['menu'],
      area: json['area'],
      jobDate: json['job_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      modelType: json['model_type'],
      price: json['price'],
      priceType: json['price_type'],
      description: json['description'],
      status: json['status'],
      salon: SalonSummary.fromJson(json['salon']),
      applicantCount: json['applicant_count'] ?? 0,
    );
  }
}

class DashboardStats {
  final int openCount;
  final int closedCount;
  final int completedCount;

  const DashboardStats({
    required this.openCount,
    required this.closedCount,
    required this.completedCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      openCount: json['open_count'],
      closedCount: json['closed_count'],
      completedCount: json['completed_count'],
    );
  }
}
