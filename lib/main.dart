import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double x = 0, y = 0, z = 0;
  String direction = "none";

  @override
  void initState() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      // print(event);

      x = event.x;
      y = event.y;
      z = event.z;

      //rough calculation, you can use
      //advance formula to calculate the orentation
      if (x > 0) {
        direction = "back";

        setState(() {});
        print("$x+$y");
      } else if (x < 0) {
        direction = "forward";
        setState(() {});
      } else if (y > 0.0) {
        direction = "left";
        setState(() {});
      } else if (z < 0) {
        direction = "right";
        setState(() {});
      }

      // setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyroscope Sensor in Flutter"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Text(
              direction,
              style: const TextStyle(fontSize: 30),
            )
          ])),
    );
  }
}
