import 'dart:async';
import 'dart:math';
import 'package:location/location.dart';

import '../../Data/MyLocation.dart';

class LocationUtils {
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData _locationData = LocationData.fromMap({
    "latitude": 50.00000,
    "longitude": -10.411899,
  });

  Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }
  void updateLocation(LocationData newLocation) {
    _locationData = newLocation;
  }

  double get latitude => _locationData.latitude ?? 0.0;
  double get longitude => _locationData.longitude ?? 0.0;


  //https://www.geeksforgeeks.org/haversine-formula-to-find-distance-between-two-points-on-a-sphere/
  double _toRadians(double degree) {
    return degree * pi / 180.0;
  }

  double haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // raio da Terra em quilômetros
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  List<MyLocation> sortByDistance(List<MyLocation> locations) {
    return locations..sort((location1, location2) {
      double distance1 = haversine(
        latitude,
        longitude,
        location1.latitude,
        location1.longitude,
      );

      double distance2 = haversine(
        latitude,
        longitude,
        location2.latitude,
        location2.longitude,
      );

      return distance1.compareTo(distance2);
    });
  }

}

