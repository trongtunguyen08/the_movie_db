import 'dart:convert';

class CastModel {
  final int id;
  final String name;
  final String profilePath;
  final int castId;

  CastModel({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.castId,
  });

  CastModel copyWith({
    int? id,
    String? name,
    String? profilePath,
    int? castId,
  }) {
    return CastModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePath: profilePath ?? this.profilePath,
      castId: castId ?? this.castId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profilePath': profilePath,
      'castId': castId,
    };
  }

  factory CastModel.fromMap(Map<String, dynamic> map) {
    return CastModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? "",
      profilePath: map['profile_path'] as String? ?? '',
      castId: map['cast_id'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CastModel.fromJson(String source) =>
      CastModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CastModel(id: $id, name: $name, profilePath: $profilePath, castId: $castId)';
  }

  @override
  bool operator ==(covariant CastModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.profilePath == profilePath &&
        other.castId == castId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ profilePath.hashCode ^ castId.hashCode;
  }
}
