class HairInfoModel {
  final int id;
  final int userId;
  final String? hairType;      // normal, fine, thick, curly
  final String? hairLength;    // short, medium, long, very_long
  final String? bleachHistory; // none, once, multiple
  final String? straightHistory; // none, within_one_year, over_one_year
  final String? notes;

  const HairInfoModel({
    required this.id,
    required this.userId,
    this.hairType,
    this.hairLength,
    this.bleachHistory,
    this.straightHistory,
    this.notes,
  });

  String get hairTypeLabel {
    switch (hairType) {
      case 'normal': return '普通毛';
      case 'fine': return '軟毛';
      case 'thick': return '硬毛';
      case 'curly': return '癖毛';
      default: return '未設定';
    }
  }

  String get hairLengthLabel {
    switch (hairLength) {
      case 'short': return 'ショート';
      case 'medium': return 'ミディアム';
      case 'long': return 'ロング';
      case 'very_long': return 'スーパーロング';
      default: return '未設定';
    }
  }

  String get bleachHistoryLabel {
    switch (bleachHistory) {
      case 'none': return 'なし';
      case 'once': return '1回';
      case 'multiple': return '複数回';
      default: return '未設定';
    }
  }

  String get straightHistoryLabel {
    switch (straightHistory) {
      case 'none': return 'なし';
      case 'within_one_year': return '1年以内';
      case 'over_one_year': return '1年以上前';
      default: return '未設定';
    }
  }

  factory HairInfoModel.fromJson(Map<String, dynamic> json) {
    return HairInfoModel(
      id: json['id'],
      userId: json['user_id'],
      hairType: json['hair_type'],
      hairLength: json['hair_length'],
      bleachHistory: json['bleach_history'],
      straightHistory: json['straight_history'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (hairType != null) 'hair_type': hairType,
    if (hairLength != null) 'hair_length': hairLength,
    if (bleachHistory != null) 'bleach_history': bleachHistory,
    if (straightHistory != null) 'straight_history': straightHistory,
    if (notes != null) 'notes': notes,
  };
}
