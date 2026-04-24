class Billboard {
  final int? id;
  final double latitude;
  final double longitude;
  final String photoPath;
  final String description;
  final String type; // e.g., digital, static, etc.
  final String dimension;
  final String condition; // e.g., good, damaged
  final String dateAdded;

  Billboard({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.photoPath,
    required this.description,
    required this.type,
    required this.dimension,
    required this.condition,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'photoPath': photoPath,
      'description': description,
      'type': type,
      'dimension': dimension,
      'condition': condition,
      'dateAdded': dateAdded,
    };
  }

  factory Billboard.fromMap(Map<String, dynamic> map) {
    return Billboard(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoPath: map['photoPath'],
      description: map['description'],
      type: map['type'],
      dimension: map['dimension'],
      condition: map['condition'],
      dateAdded: map['dateAdded'],
    );
  }
}
