import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// void main() => runApp(PhysicsAnimation());

class PhysicsAnimation extends StatefulWidget {
  const PhysicsAnimation({super.key});

  @override
  _PhysicsAnimation createState() => _PhysicsAnimation();
}

class _PhysicsAnimation extends State<PhysicsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late GravitySimulation simulation;
  Offset fallingObjectPosition = const Offset(0, 0);

  @override
  void initState() {
    super.initState();

    simulation = GravitySimulation(
      100.0, // acceleration
      0.0, // starting point
      500.0, // end point
      0.0, // starting velocity
    );

    controller = AnimationController(vsync: this, upperBound: 500)
      ..addListener(() {
        setState(() {
          _onTick();
          print(fallingObjectPosition.dy);
        });
      });

    controller.animateWith(simulation);
  }

  void _onTick() {
    fallingObjectPosition = Offset(50, controller.value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Positioned(
            left: fallingObjectPosition.dx,
            top: fallingObjectPosition.dy,
            height: 10,
            width: 10,
            child: Container(
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
