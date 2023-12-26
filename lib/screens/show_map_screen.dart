import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../Data/PointOfInterest.dart';

class ShowMapScreen extends StatefulWidget {
  const ShowMapScreen({super.key});

  static const String routeName = '/ShowMapScreen';

  @override
  State<ShowMapScreen> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMapScreen> {
  late List<PointOfInterest> _pois = ModalRoute.of(context)!.settings.arguments as List<PointOfInterest>;

  //final _mapController = MapController();


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pois Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(48.8566,  2.3522),
              initialZoom: 4,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _pois.map((poi) {
                  return Marker(
                    point: LatLng(poi.latitude, poi.longitude),
                    width: 80,
                    height: 80,
                    child: Icon(Icons.location_on, color: Colors.black, size: 40),
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
