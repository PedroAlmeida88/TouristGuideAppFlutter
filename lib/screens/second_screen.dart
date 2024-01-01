import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  static const String routeName = '/SecondScreen';

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late final int _counter = ModalRoute.of(context)!.settings.arguments as int;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello Center $_counter'),
            ElevatedButton(
                onPressed: () { Navigator.pop(context, _counter * 2); },
                child: const Text('Return'))
          ],
        ),
      ),
    );
  }
}
