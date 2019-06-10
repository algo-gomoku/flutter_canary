import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canary/radar_page.dart';
import 'package:flutter_canary/routes.dart';

import 'explore_line_page.dart';
import 'new_line_page.dart';

void main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: ROUTES,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("Radar")),
          BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("New Line")),
          BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("Explore Line")),
        ],
        onTap: (pos) {
          _currentPos = pos;
          setState(() {});
        },
      ),
    );
  }

  buildBody() {
    switch (_currentPos) {
      case 0:
        return RadarPage();
      case 1:
        return NewLinePage();
      case 2:
        return ExploreLinePage();
    }
  }
}
