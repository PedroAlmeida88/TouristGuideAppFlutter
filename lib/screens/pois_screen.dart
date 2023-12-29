import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tp_flutter/data/MyLocation.dart';
import 'package:tp_flutter/data/PointOfInterest.dart';
import 'package:tp_flutter/data/MyCategory.dart';
import 'package:tp_flutter/screens/show_map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter/utils/shared_preferences.dart';

import '../data/Collections.dart';

class PoisScreen extends StatefulWidget {
  const PoisScreen({super.key});

  static const String routeName = '/PoisScreen';

  @override
  State<PoisScreen> createState() => _PoisScreenState();
}

class _PoisScreenState extends State<PoisScreen> {
  late MyLocation _currentLocation;
  bool _isLoading = true;
  bool _gotCategories = true;
  late List<PointOfInterest> _pois = [];
  late List<PointOfInterest> _poisAux = [];  //guarda uma verão da lista com todos os POIs
  int numLikes = 0;
  int numDislikes = 0;


  final List<MyCategory> _categories = [];
  MyCategory selectedCategory = MyCategory("", "", ""); // Track the selected category


  //desta forma garanto que "_currentLocation" está carregada
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocation = ModalRoute.of(context)!.settings.arguments as MyLocation;
    getPOIsFromFirebase();
  }

  @override
  void initState() {
    getCategoriesFromFirebase();
    updateLikes();
    super.initState();
  }

  void addLikeInPOI(MyLocation myLocation, PointOfInterest poi, int num) async {
    var db = FirebaseFirestore.instance;

    await db
        .collection(Collections.Locations.name)
        .doc(_currentLocation.name)
        .collection('POIs')
        .doc(poi.name)
        .update({'TotalLikes': FieldValue.increment(num)});
  }


  void addDislikeInPOI(MyLocation myLocation, PointOfInterest poi, int num) async {
    var db = FirebaseFirestore.instance;

    await db
        .collection(Collections.Locations.name)
        .doc(_currentLocation.name)
        .collection('POIs')
        .doc(poi.name)
        .update({'TotalDislikes': FieldValue.increment(num)});
  }


  void updateLikes() async {
    var db = FirebaseFirestore.instance;

    for (var poi in _pois) {
      var poiDoc = await db
          .collection(Collections.Locations.name)
          .doc(_currentLocation.name)
          .collection('POIs')
          .doc(poi.name)
          .get();
      //setState(() {
        poi.totalLikes = poiDoc['TotalLikes'] ?? 0;
        poi.totalDislikes = poiDoc['TotalDislikes'] ?? 0;
      //});
    }

    setState(() {});
  }




  void getPOIsFromFirebase() async {
    var db = FirebaseFirestore.instance;
    _pois = [];
    var poisCollection = db
        .collection(Collections.Locations.name)
        .doc(_currentLocation.name)
        .collection('POIs');
    var poisDocs = await poisCollection.get();
    for (var poiDoc in poisDocs.docs) {
      //var categoryDoc = await poisCollection.doc(poiDoc.id).collection('Category').doc('categoryDocId').get();
      var categoryData = poiDoc.get('Category') as Map<String, dynamic>?;
      debugPrint("Poi Doc: ${categoryData}");
      var catName = categoryData?['name']?.toString() ?? "";
      var catIcon = categoryData?['icon']?.toString() ?? "";
      var catDesc = categoryData?['description']?.toString() ?? "";
      _pois.add(PointOfInterest(
        poiDoc.id,
        poiDoc['Description'] ?? "",
        poiDoc['PhotoUrl'] ?? "",
        poiDoc['Latitude'] ?? 0.0,
        poiDoc['Longitude'] ?? 0.0,
        MyCategory(
          catName,catDesc,catIcon
        ),
        await sharedPrefs.getLikeInPoi(poiDoc.id),
        poiDoc['TotalLikes'] ?? 0,
        poiDoc['TotalDislikes'] ?? 0
      ));
    }
    _poisAux = List.from(_pois);
    setState(() {
      _isLoading = false;
    });

  }



  void getCategoriesFromFirebase() async {
    var db = FirebaseFirestore.instance;
    var collection = await db.collection(Collections.Category.name).get();
    for (var doc in collection.docs) {
      debugPrint("Doc: ${doc.id}"); // doc.data()...
      _categories.add(MyCategory(
        doc.id,
        doc['Description'] ?? "",
        doc['Icon'] ?? "",
      ));
    }

    setState(() {
      _gotCategories = false;
    });
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh), // Adicione o ícone desejado
                  onPressed: () {
                    setState(() {
                      selectedCategory = MyCategory("", "", "");
                      _pois = List.from(_poisAux);
                    });
                  },
                ),
                DropdownButton<MyCategory>(
                  hint: const Text('Select a category'),
                  value: selectedCategory.name.isNotEmpty
                      ? _categories.firstWhere((category) => category.name == selectedCategory.name)
                      : null,
                  items: _categories.map((category) {
                    return DropdownMenuItem<MyCategory>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (MyCategory? selectedValue) {
                    setState(() {
                      selectedCategory = selectedValue ?? MyCategory("", "", "");
                      _pois = List.from(_poisAux.where((poi) => selectedCategory.name.isEmpty || poi.category.name == selectedCategory.name));; // Adiciona esta função para atualizar a lista de POIs
                    });
                  },
                ),

              ],
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                  child: _pois.isEmpty
                      ? const Center(
                        child: Text(
                          'No Points of Interest available for this location.',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      )
                      : ListView.separated(
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
                                              icon: Icon(_pois[index].isLiked == true ? Icons.thumb_up_alt : Icons.thumb_up_off_alt, color: Colors.black),
                                              onPressed: () {
                                                setState(() {
                                                    if(_pois[index].isLiked == null || _pois[index].isLiked == false) {
                                                        if(_pois[index].isLiked == false) {
                                                          addDislikeInPOI(_currentLocation, _pois[index], -1);
                                                        }
                                                        _pois[index].isLiked = true;
                                                        sharedPrefs.setLikeInPoi(_pois[index].name, true);
                                                        addLikeInPOI(_currentLocation, _pois[index], 1);
                                                    } else {
                                                      _pois[index].isLiked = null;
                                                      sharedPrefs.removeLikeInPoi(_pois[index].name);
                                                      addLikeInPOI(_currentLocation, _pois[index], -1);
                                                    }
                                                    updateLikes();
                                                });
                                              },
                                            ),
                                            Text(
                                              '${_pois[index].totalLikes}',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(width: 8), // Espaçamento entre o primeiro ícone e o texto
                                            IconButton(
                                              icon: Icon(_pois[index].isLiked == false ? Icons.thumb_down_alt : Icons.thumb_down_off_alt),
                                              onPressed: () {
                                                setState(() {
                                                  if(_pois[index].isLiked == null || _pois[index].isLiked == true) {
                                                    if(_pois[index].isLiked == true) {
                                                      addLikeInPOI(_currentLocation, _pois[index], -1);
                                                    }
                                                    _pois[index].isLiked = false;
                                                    sharedPrefs.setLikeInPoi(_pois[index].name, false);
                                                    addDislikeInPOI(_currentLocation, _pois[index], 1);
                                                  } else {
                                                    _pois[index].isLiked = null;
                                                    sharedPrefs.removeLikeInPoi(_pois[index].name);
                                                    addDislikeInPOI(_currentLocation, _pois[index], -1);
                                                  }
                                                  updateLikes();
                                                });
                                              },
                                            ),
                                            Text(
                                              '${_pois[index].totalDislikes}',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.map),
                                          onPressed: () async {
                                            setState(() {
                                              sharedPrefs.setLastTenPois(_pois[index]);
                                            });

                                            await Navigator.pushNamed(
                                                context,
                                                ShowMapScreen.routeName,
                                                arguments:  {'pois': _pois, 'selectedPoi': _pois[index]},
                                            );
                                          },
                                        )
                                      ],
                                    )//Row dos icons

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
