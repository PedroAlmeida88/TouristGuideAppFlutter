import 'package:tp_flutter/data/MyCategory.dart';

class PointOfInterest {
  final String name;
  final String description;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final MyCategory category;

  PointOfInterest(
    this.name,
    this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    this.category,
  );
}