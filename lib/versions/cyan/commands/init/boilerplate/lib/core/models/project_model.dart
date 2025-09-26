import 'package:equatable/equatable.dart';

class ProjectModel with EquatableMixin {
  String? id;
  DateTime? createdAt;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  int? progress;

  ProjectModel({
    this.id,
    this.createdAt,
    this.name,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.progress,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    country = json['country'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name?.trim();

    data['city'] = city?.trim();
    data['state'] = state?.trim();
    data['zip_code'] = zipCode;
    data['country'] = country;

    return data;
  }

  ProjectModel copyWith({
    String? id,
    DateTime? createdAt,

    String? name,

    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    int? progress,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,

      name: name ?? this.name,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    name,
    addressLine1,
    addressLine2,
    city,
    state,
    zipCode,
    country,
    progress,
  ];

  bool get isSiteAssessmentPending => (progress ?? 0) == 0;
}
