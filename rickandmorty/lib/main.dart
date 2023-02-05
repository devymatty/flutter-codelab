import 'package:flutter/material.dart';
import 'package:rickandmorty/personwidget.dart';
import 'package:rickandmorty/dataLoader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person>? persons = null;
  Exception? error = null;

  void loadData() async {
    try {
      var personLoad = await loadPersons();
      setState(() {
        persons = personLoad;
      });
    } on Exception catch (exeption) {
      setState(() {
        error = exeption;
        print("Oops, we catch warning");
      });
    }
    print("End of loading");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final List<Person>? currentPersons = persons;
    final Exception? exception = error;

    if (currentPersons != null)
      content = personsList(context, currentPersons);
    else if (exception != null)
      content = exceptionStub(context, exception);
    else
      content = loader(context);

    return Scaffold(
      body: Center(child: content),
    );
  }

  Widget personsList(BuildContext context, List<Person> persons) {
    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (context, index) => Row(
        children: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PersonDetailsPage(id: persons[index].id),
                ),
              ),
            },
            icon: Icon(Icons.person),
          ),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                persons[index].id.toString(),
                style: TextStyle(fontSize: 25),
              )),
          Flexible(
            child: Text(
              persons[index].name + persons[index].status,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget loader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Load data...',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }

  Widget exceptionStub(BuildContext context, Exception exception) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'OOOPS ERROR IS ${exception.toString()}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
