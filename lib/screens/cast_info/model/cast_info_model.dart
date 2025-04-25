import 'dart:convert';

class CastInfoModel {
  final int id;
  final String biography;
  final String birthday;
  final String knownForDepartment;
  final String name;
  final String placeOfBirth;
  final String profilePath;

  CastInfoModel({
    required this.id,
    required this.biography,
    required this.birthday,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.profilePath,
  });

  CastInfoModel copyWith({
    int? id,
    String? biography,
    String? birthday,
    String? knownForDepartment,
    String? name,
    String? placeOfBirth,
    String? profilePath,
  }) {
    return CastInfoModel(
      id: id ?? this.id,
      biography: biography ?? this.biography,
      birthday: birthday ?? this.birthday,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      profilePath: profilePath ?? this.profilePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'biography': biography,
      'birthday': birthday,
      'knownForDepartment': knownForDepartment,
      'name': name,
      'placeOfBirth': placeOfBirth,
      'profilePath': profilePath,
    };
  }

  factory CastInfoModel.fromMap(Map<String, dynamic> map) {
    return CastInfoModel(
      id: map['id'] as int? ?? 0,
      biography: map['biography'] as String? ?? '',
      birthday: map['birthday'] as String? ?? '',
      knownForDepartment: map['known_for_department'] as String? ?? '',
      name: map['name'] as String? ?? '',
      placeOfBirth: map['place_of_birth'] as String? ?? '',
      profilePath: map['profile_path'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CastInfoModel.fromJson(String source) =>
      CastInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CastInfoModel(id: $id, biography: $biography, birthday: $birthday, knownForDepartment: $knownForDepartment, name: $name, placeOfBirth: $placeOfBirth, profilePath: $profilePath)';
  }

  @override
  bool operator ==(covariant CastInfoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.biography == biography &&
        other.birthday == birthday &&
        other.knownForDepartment == knownForDepartment &&
        other.name == name &&
        other.placeOfBirth == placeOfBirth &&
        other.profilePath == profilePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        biography.hashCode ^
        birthday.hashCode ^
        knownForDepartment.hashCode ^
        name.hashCode ^
        placeOfBirth.hashCode ^
        profilePath.hashCode;
  }
}
