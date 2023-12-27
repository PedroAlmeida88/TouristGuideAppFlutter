import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tp_flutter/data/MyLocation.dart';
import 'package:tp_flutter/Screens/pois_screen.dart';
import 'package:location/location.dart';
import 'package:tp_flutter/utils/location/location_utlis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/Collections.dart';




class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  static const String routeName = '/LocationsScreen';

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  bool _isLoading = true;
  List<MyLocation> _locations = [];

  void getLocationsFromFirebase() async {
    var db = FirebaseFirestore.instance;
    var collection = await db.collection(Collections.Locations.name).get();
    for (var doc in collection.docs) {
      debugPrint("Doc: ${doc.id}"); // doc.data()...
      _locations.add(MyLocation(
        doc.id ?? "",
        doc['Description'] ?? "",
        doc['PhotoUrl'] ?? "",
        doc['Latitude'] ?? 0.0,
        doc['Longitude'] ?? 0.0,
      ));
    }

    // Atualiza o estado para indicar que o carregamento está completo
    setState(() {
      _isLoading = false;
    });
  }

  final LocationUtils _locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();
    getLocationsFromFirebase();
    _locationUtils.getLocation();
    startLocationUpdates();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  StreamSubscription<LocationData>? _locationSubscription;

  void startLocationUpdates() {
    _locationSubscription = _locationUtils.location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationUtils.updateLocation(currentLocation);
      });
    });
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription=null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _locations.sort((a,b) => a.name.compareTo(b.name));
                    });
                  },
                  icon: Icon(Icons.abc),
                  label:const Text('Ordem Alfabética'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _locations = _locationUtils.sortByDistance(_locations);
                    });
                  },
                  icon: Icon(Icons.location_on_rounded),
                  label: const Text('Perto de mim'),
                ),

              ],
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                  child: ListView.separated(
                    itemCount: _locations.length,
                    separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                    itemBuilder: (BuildContext context, int index) => GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          PoisScreen.routeName,
                          arguments: _locations[index]
                        );
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image.network(
                                    _locations[index].photoUrl,
                                    /*
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image is fully loaded
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                   */
                                  ),
                                  title: Text(_locations[index].name),
                                  subtitle: Text('Latitude: ${_locations[index].latitude} Longitude: ${_locations[index].longitude}'),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(_locations[index].description,
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                //Image.asset(_locations[index].photoUrl,width: 300,height: 500,),
                              ]
                          )
                      ),
                    )
                  ),
                )
          ],
        ),
      ),
    );
  }
}
