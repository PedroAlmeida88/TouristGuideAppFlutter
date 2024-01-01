import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/PointOfInterest.dart';

class ShowMapScreen extends StatefulWidget {
  const ShowMapScreen({super.key});

  static const String routeName = '/ShowMapScreen';

  @override
  State<ShowMapScreen> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMapScreen> {
  late List<PointOfInterest> _pois;
  late PointOfInterest _currentPoi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _pois = args['pois'];
      _currentPoi = args['selectedPoi'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pois Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(_currentPoi.latitude,  _currentPoi.longitude),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _pois.map((poi) {
                  Color markerColor = poi == _currentPoi ? Colors.red : Colors.black;
                  return Marker(
                    point: LatLng(poi.latitude, poi.longitude),
                    width: 80,
                    height: 80,
                    child: Icon(Icons.location_on, color: markerColor, size: 40),
                  );
                }).toList(),
              )
            ],

          ),
        ],
      ),
    );
  }
}
