import 'package:flutter/material.dart';
import 'package:tp_flutter/Data/MyLocation.dart';
import 'package:tp_flutter/Data/PointOfInterest.dart';
import 'package:tp_flutter/screens/show_map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/Collections.dart';

class PoisScreen extends StatefulWidget {
  const PoisScreen({super.key});

  static const String routeName = '/PoisScreen';

  @override
  State<PoisScreen> createState() => _PoisScreenState();
}

class _PoisScreenState extends State<PoisScreen> {
  late MyLocation _currentLocation = ModalRoute.of(context)!.settings.arguments as MyLocation;
  bool _isLoading = true;

  bool isLiked = false;
  bool isDisliked = false;
  int numLikes = 0;
  int numDislikes = 0;
  final List<PointOfInterest> _pois = [];

  void getPOIsFromFirebase() async {
    var db = FirebaseFirestore.instance;

    var poisCollection = db
        .collection(Collections.Locations.name)
        .doc("Barcelona")
        .collection('POIs');
    var poisDocs = await poisCollection.get();
    for (var poiDoc in poisDocs.docs) {
      debugPrint("Poi Doc: ${poiDoc.id}");
      _pois.add(PointOfInterest(
        poiDoc.id ?? "",
        poiDoc['Description'] ?? "",
        poiDoc['PhotoUrl'] ?? "",
        poiDoc['Latitude'] ?? 0.0,
        poiDoc['Longitude'] ?? 0.0,
      ));

    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getPOIsFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pois Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                  child: ListView.separated(
                    itemCount: _pois.length,
                    separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                    itemBuilder: (BuildContext context, int index) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Image.network(_pois[index].photoUrl),
                                title: Text(_pois[index].name),
                                subtitle: Text('Longitude: ${_pois[index].longitude} Latitude: ${_pois[index].latitude}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(_currentLocation.name,
                                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(isLiked ? Icons.thumb_up_alt : Icons.thumb_up_off_alt, color: Colors.black),
                                        onPressed: () {
                                          setState(() {
                                            isLiked = !isLiked;
                                          });
                                        },
                                      ),
                                      Text(
                                        '$numLikes',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 8), // Espaçamento entre o primeiro ícone e o texto
                                      IconButton(
                                        icon: Icon(isDisliked ? Icons.thumb_down_alt : Icons.thumb_down_off_alt),
                                        onPressed: () {
                                          setState(() {
                                            isDisliked = !isDisliked;
                                          });
                                        },
                                      ),
                                      Text(
                                        '$numDislikes',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.map),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context,
                                          ShowMapScreen.routeName,
                                          arguments: _pois,
                                      );
                                    },
                                  )
                                ],
                              )

                            ]
                        )
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
