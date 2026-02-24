class ApplicationJobSummary {
  final int id;
  final String menu;
  final String area;
  final String jobDate;
  final String startTime;
  final String endTime;
  final String? modelType;
  final int price;
  final String priceType;
  final String status;

  const ApplicationJobSummary({
    required this.id,
    required this.menu,
    required this.area,
    required this.jobDate,
    required this.startTime,
    required this.endTime,
    this.modelType,
    required this.price,
    required this.priceType,
    required this.status,
  });

  String get startTimeShort => startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
  String get endTimeShort => endTime.length >= 5 ? endTime.substring(0, 5) : endTime;
  String get timeRange => '$startTimeShort - $endTimeShort';
  bool get isIncome => priceType == 'income';
  String get formattedPrice =>
      isIncome ? '+¥$price' : '-¥$price';

  factory ApplicationJobSummary.fromJson(Map<String, dynamic> json) {
    return ApplicationJobSummary(
      id: json['id'],
      menu: json['menu'],
      area: json['area'],
      jobDate: json['job_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      modelType: json['model_type'],
      price: json['price'],
      priceType: json['price_type'],
      status: json['status'],
    );
  }
}

class ApplicationSalonInfo {
  final int id;
  final String name;
  final String area;
  final String? phone;

  const ApplicationSalonInfo({
    required this.id,
    required this.name,
    required this.area,
    this.phone,
  });

  factory ApplicationSalonInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationSalonInfo(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      phone: json['phone'],
    );
  }
}

class ApplicationModel {
  final int id;
  final int jobId;
  final int modelId;
  final String status; // pending, approved, rejected, completed
  final String? message;
  final String? stylistNote;
  final String appliedAt;
  final String updatedAt;
  final ApplicationJobSummary? job;
  final ApplicationSalonInfo? salon;

  const ApplicationModel({
    required this.id,
    required this.jobId,
    required this.modelId,
    required this.status,
    this.message,
    this.stylistNote,
    required this.appliedAt,
    required this.updatedAt,
    this.job,
    this.salon,
  });

  String get statusLabel {
    switch (status) {
      case 'pending': return '審査中';
      case 'approved': return '承認';
      case 'rejected': return '不採用';
      case 'completed': return '完了';
      default: return status;
    }
  }

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      jobId: json['job_id'],
      modelId: json['model_id'],
      status: json['status'],
      message: json['message'],
      stylistNote: json['stylist_note'],
      appliedAt: json['applied_at'],
      updatedAt: json['updated_at'],
      job: json['job'] != null ? ApplicationJobSummary.fromJson(json['job']) : null,
      salon: json['salon'] != null ? ApplicationSalonInfo.fromJson(json['salon']) : null,
    );
  }
}

class ApplicantModel {
  final int id;
  final String status;
  final String? message;
  final String appliedAt;
  final ApplicantUser model;

  const ApplicantModel({
    required this.id,
    required this.status,
    this.message,
    required this.appliedAt,
    required this.model,
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    return ApplicantModel(
      id: json['id'],
      status: json['status'],
      message: json['message'],
      appliedAt: json['applied_at'],
      model: ApplicantUser.fromJson(json['model']),
    );
  }
}

class ApplicantUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final ApplicantHairInfo? hairInfo;

  const ApplicantUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.hairInfo,
  });

  factory ApplicantUser.fromJson(Map<String, dynamic> json) {
    return ApplicantUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      hairInfo: json['hair_info'] != null
          ? ApplicantHairInfo.fromJson(json['hair_info'])
          : null,
    );
  }
}

class ApplicantHairInfo {
  final String? hairType;
  final String? hairLength;
  final String? bleachHistory;
  final String? straightHistory;

  const ApplicantHairInfo({
    this.hairType,
    this.hairLength,
    this.bleachHistory,
    this.straightHistory,
  });

  List<String> get labels {
    final result = <String>[];
    if (bleachHistory != null) {
      result.add(_bleachLabel(bleachHistory!));
    }
    if (hairType != null) result.add(_typeLabel(hairType!));
    if (hairLength != null) result.add(_lengthLabel(hairLength!));
    if (straightHistory != null && straightHistory != 'none') {
      result.add('縮毛矯正: ${_straightLabel(straightHistory!)}');
    }
    return result;
  }

  String _bleachLabel(String v) {
    switch (v) {
      case 'none': return 'ブリーチなし';
      case 'once': return 'ブリーチ1回';
      case 'multiple': return 'ブリーチ複数回';
      default: return v;
    }
  }

  String _typeLabel(String v) {
    switch (v) {
      case 'normal': return '普通毛';
      case 'fine': return '軟毛';
      case 'thick': return '硬毛';
      case 'curly': return '癖毛';
      default: return v;
    }
  }

  String _lengthLabel(String v) {
    switch (v) {
      case 'short': return 'ショート';
      case 'medium': return 'ミディアム';
      case 'long': return 'ロング';
      case 'very_long': return 'スーパーロング';
      default: return v;
    }
  }

  String _straightLabel(String v) {
    switch (v) {
      case 'within_one_year': return '1年以内';
      case 'over_one_year': return '1年以上前';
      default: return v;
    }
  }

  factory ApplicantHairInfo.fromJson(Map<String, dynamic> json) {
    return ApplicantHairInfo(
      hairType: json['hair_type'],
      hairLength: json['hair_length'],
      bleachHistory: json['bleach_history'],
      straightHistory: json['straight_history'],
    );
  }
}
