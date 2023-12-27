import 'package:tp_flutter/data/MyCategory.dart';

class PointOfInterest {
  final String name;
  final String description;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final MyCategory category;
  bool? isLiked;

  PointOfInterest(
    this.name,
    this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    this.category,
    this.isLiked,
  );

  PointOfInterest.fromJson(Map<String, dynamic> json) :
      name = json['name'],
      description = json['description'],
      photoUrl = json['photoUrl'],
      latitude = json['latitude'],
      longitude = json['longitude'],
      category = MyCategory.fromJson(json['category']),
      isLiked = json['isLiked'];

  static Map<String, dynamic> toJson (PointOfInterest poi) => {
      'name' : poi.name,
      'description' : poi.description,
      'photoUrl' : poi.photoUrl,
      'latitude' : poi.latitude,
      'longitude' : poi.longitude,
      'category' : MyCategory.toJson(poi.category),
      'isLiked' : poi.isLiked
  };
}