import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  static const String routeName = '/CreditsScreen';

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}
class Student {
  final String name;
  final String imageUrl;
  final String id;

  Student(this.name, this.imageUrl, this.id);
}

class _CreditsScreenState extends State<CreditsScreen> {
  final List<Student> _students = [
    Student("Acácio Agabalayeve Coutinho", "images/acacio.jpg", "2020141948"),
    Student("José Pedro Sousa Almeida", "images/pedro.jpg", "2020141980"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start  ,
          children: [
            SizedBox(height:120, child: Image.asset("images/isec_logo.png")),
            const Text('Departamento de Engenharia Informática e de Sistemas'),
            const SizedBox(height: 20),
            const Text('Pratical Work Nº1 - Mobile Arquitecture',style: TextStyle(fontSize: 20),),
            const SizedBox(height: 20),
            const Text('Done By:',style: TextStyle(fontSize: 20),),

            Expanded(
              child: ListView.separated(
                itemCount: _students.length,
                separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                itemBuilder: (BuildContext context, int index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  child: ListTile(
                    title: Text(_students[index].name),
                    subtitle: Text(_students[index].id),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(_students[index].imageUrl),
                    ),
                  )
                ),
              ),
            )

            /*
            ElevatedButton(
                onPressed: () { Navigator.pop(context, _counter * 2); },
                child: const Text('Return'))
            */
          ],
        ),
      ),
    );
  }
}
