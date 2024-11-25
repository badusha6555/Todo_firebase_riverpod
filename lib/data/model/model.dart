class Model {
  final String id;
  final String name;
  final String description;

  Model({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map, String descriptionId) {
    return Model(
      id: descriptionId,
      name: map['name'] ?? "",
      description: map['description'] ?? "",
    );
  }
}
