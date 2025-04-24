import 'dart:convert';

class VideoModel {
  final String id;
  final String name;
  final String key;
  final String site;

  VideoModel({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
  });

  VideoModel copyWith({String? id, String? name, String? key, String? site}) {
    return VideoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      key: key ?? this.key,
      site: site ?? this.site,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'key': key, 'site': site};
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      key: map['key'] as String? ?? '',
      site: map['site'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(id: $id, name: $name, key: $key, site: $site)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.key == key &&
        other.site == site;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ key.hashCode ^ site.hashCode;
  }
}
