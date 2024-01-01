import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp_flutter/data/PointOfInterest.dart';

class SharedPrefs {
    static late SharedPreferences _sharedPreferences;
    static const String _lastTenPoisString = "LastTenPois";
    late List<String> _lastTenPois = [];

    Future<void> initSharedPreferences() async {
        _sharedPreferences = await SharedPreferences.getInstance();
    }

    Future<void> setLikeInPoi (String poiName, bool like) async {
        _sharedPreferences.setBool(poiName, like);
    }

    Future<bool?> getLikeInPoi (String poiName) async {
        bool? isLiked = _sharedPreferences.getBool(poiName);
        return isLiked;
    }

    Future<void> removeLikeInPoi (String poiName) async {
        _sharedPreferences.remove(poiName);
    }

    Future<void> setLastTenPois (PointOfInterest pointOfInterest) async {
        _lastTenPois = _sharedPreferences.getStringList(_lastTenPoisString) ?? [];
        if(_lastTenPois.length > 10){
            _lastTenPois.remove(_lastTenPois.first);
        }

        String poi = jsonEncode(PointOfInterest.toJson(pointOfInterest));
        for(String poiaux in _lastTenPois) {
            PointOfInterest aux = PointOfInterest.fromJson(jsonDecode(poiaux));
            if(aux.name == pointOfInterest.name) {
                _lastTenPois.remove(poiaux);
            }
        }
        _lastTenPois.add(poi);

        _sharedPreferences.setStringList(_lastTenPoisString, _lastTenPois);
    }

    Future<List<PointOfInterest>> getLastTenPois () async {
        _lastTenPois = _sharedPreferences.getStringList(_lastTenPoisString) ?? [];
        List<PointOfInterest> pointsOfInterest = [];

        for(String poi in _lastTenPois) {
            PointOfInterest pointOfInterest = PointOfInterest.fromJson(jsonDecode(poi));
            pointsOfInterest.add(pointOfInterest);
        }

        return pointsOfInterest;
    }

    Future<void> removeLastTenPoi () async {
        _lastTenPois = [];
        _sharedPreferences.remove(_lastTenPoisString);
    }
}

final sharedPrefs = SharedPrefs();