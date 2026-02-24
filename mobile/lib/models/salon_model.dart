class SalonModel {
  final int id;
  final int stylistId;
  final String name;
  final String area;
  final String? address;
  final String? phone;
  final String? description;

  const SalonModel({
    required this.id,
    required this.stylistId,
    required this.name,
    required this.area,
    this.address,
    this.phone,
    this.description,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id'],
      stylistId: json['stylist_id'],
      name: json['name'],
      area: json['area'],
      address: json['address'],
      phone: json['phone'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'area': area,
    if (address != null) 'address': address,
    if (phone != null) 'phone': phone,
    if (description != null) 'description': description,
  };
}
