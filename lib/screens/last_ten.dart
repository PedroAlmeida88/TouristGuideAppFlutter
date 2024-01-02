import 'package:flutter/material.dart';
import 'package:tp_flutter/data/PointOfInterest.dart';
import 'package:tp_flutter/screens/show_map_screen.dart';
import 'package:tp_flutter/utils/shared_preferences.dart';

class LastTenPoisScreen extends StatefulWidget {
  const LastTenPoisScreen({super.key});

  static const String routeName = '/LastTenPoisScreen';

  @override
  State<LastTenPoisScreen> createState() => _LastTenPoisScreenState();
}

class _LastTenPoisScreenState extends State<LastTenPoisScreen> {
  bool _isLoading = true;
  late List<PointOfInterest> _pois = [];
  bool isLiked = false;
  bool isDisliked = false;
  int numLikes = 0;
  int numDislikes = 0;

  @override
  void initState() {
    getPoisFromSharedPrefs();
    super.initState();
  }

  void getPoisFromSharedPrefs() async {
    _pois = await sharedPrefs.getLastTenPois();

    setState(() {
      _isLoading = false;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      sharedPrefs.removeLastTenPoi();
                      _pois = [];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 60),
                  ),
                  child: const Text('Reset Last Ten POI'),
                )
            ),
            _isLoading
                ? const CircularProgressIndicator()
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
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