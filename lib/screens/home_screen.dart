import 'package:flutter/material.dart';
import 'package:tp_flutter/Screens/credits_screen.dart';
import 'package:tp_flutter/screens/last_ten.dart';
import 'locations_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  static const String routeName = '/HomeScreen';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _color = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _color,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                        context, LocationsScreen.routeName
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 60),
                  ),
                  child: const Text('Locations'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                          context, CreditsScreen.routeName
                      );
                      //int i = obj is int ? obj : 0;

                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                    ),
                    child: const Text('CreditsScreen'),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                          context, LastTenPoisScreen.routeName
                      );
                      //int i = obj is int ? obj : 0;
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                    ),
                    child: const Text('LastTenPOIScreen'),
                  )
              ),
            ],
          ),
        ),
      /*
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              heroTag: 'Floating 1',
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ),
          FloatingActionButton(
            heroTag: 'Floating 2',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ]) // This trailing comma makes auto-formatting nicer for build methods.
      */
        );
  }
}
