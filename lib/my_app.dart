import 'package:flutter/material.dart';
import 'package:tp_flutter/Screens/pois_screen.dart';
import 'package:tp_flutter/screens/show_map_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/credits_screen.dart';
import 'Screens/locations_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMOV TP2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) => const MyHomePage(title: 'TouristApp'),
        CreditsScreen.routeName: (context) => const CreditsScreen(),
        LocationsScreen.routeName: (context) => const LocationsScreen(),
        PoisScreen.routeName: (context) => const PoisScreen(),
        ShowMapScreen.routeName: (context) => const ShowMapScreen(),
      },
    );
  }
}
