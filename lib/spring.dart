import 'package:animation/custompainter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';


import 'package:flutter/scheduler.dart';

class Spring extends StatefulWidget {
  const Spring({super.key});

  @override
  State<Spring> createState() => _SpringState();
}

class _SpringState extends State<Spring> with TickerProviderStateMixin {
  late double height;
  late double weight;
  late AnimationController objectController;
  late Animation objectAnimation;
  late GravitySimulation simulation;
  Offset _fallingObject = Offset.zero;
  Offset _thumbOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    simulation = GravitySimulation(
      100.0, // acceleration
      0.0, // starting point
      500, // end point
      5.0, // starting velocity
    );

    objectController = AnimationController(vsync: this, upperBound: 500)
      ..addListener(() {
        setState(() {
          _fallingTick();
          print(_fallingObject.dy);
        });
      });

    objectController.animateWith(simulation);
  }

  void _fallingTick() {
    _fallingObject = Offset(100.0, objectController.value);
  }

  @override
  void dispose() {
    objectController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = (MediaQuery.of(context).size.height -
        (MediaQuery.maybeViewPaddingOf(context)?.vertical ?? 0));
    weight = MediaQuery.sizeOf(context).width;
  }

  final springDescription =
      const SpringDescription(mass: 1.0, stiffness: 500.0, damping: 15.0);

  // late SpringSimulation _springSimulation;
  late SpringSimulation _springSimX;
  late SpringSimulation _springSimY;
  Ticker _ticker = Ticker((elapsed) {});
  void _onPanStart(DragStartDetails details) {
    _endSpring();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _thumbOffset += details.delta;
      // print(details.delta.dy);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _springSimX = SpringSimulation(springDescription, _thumbOffset.dx, 0, 0);
    _springSimY = SpringSimulation(springDescription, _thumbOffset.dy, 0, 0);
    _startSpring();
  }

  void _startSpring() {
    //For Y direction
    _springSimY = SpringSimulation(
        springDescription, _thumbOffset.dy, -_thumbOffset.dy, 0);
    _springSimY = SpringSimulation(springDescription, -_thumbOffset.dy, 0, 0);

    //For X direction
    _springSimX = SpringSimulation(
        springDescription, _thumbOffset.dx, -_thumbOffset.dx, 0);
    _springSimX = SpringSimulation(springDescription, -_thumbOffset.dx, 0, 0);

    _ticker = createTicker(_onTick);
    setState(() {
      // print(-_thumbOffset.dy);
    });
    _ticker.start();
  }

  void _onTick(Duration elapsedTime) {
    final elapsedSecondFraction = elapsedTime.inMilliseconds / 2000.0;
    setState(() {
      _thumbOffset = Offset(
        _springSimX.x(elapsedSecondFraction),
        _springSimY.x(elapsedSecondFraction),
      );
    });
    if (_springSimY.isDone(elapsedSecondFraction)) {
      _endSpring();
    }
  }

  void _endSpring() {
    if (_ticker != null) {
      _ticker.stop();
    }
  }

  // void randomObject() {
  //   Random();
  // }

  void _onPanCancel() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      child: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'android/assets/building.jpg',
                fit: BoxFit.fill,
                color: Colors.red.withOpacity(0.3),
                colorBlendMode: BlendMode.color,
              ),
            ),
            CustomPaint(
              painter: WebPainter(springOffset: _thumbOffset),
              size: Size.infinite,
            ),
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: _thumbOffset,
                child: Image.asset(
                  'android/assets/fox.png',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            AnimatedBuilder(
                animation: objectController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned(
                        height: 40,
                        width: 40,
                        top: _fallingObject.dy,
                        left: _fallingObject.dx,
                        child: Container(
                          child: Image.asset('android/assets/fruits/apple.png'),
                        ),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}

class WebPoints {
  Offset springOffset;
  Paint sprintPaint;
  WebPoints({
    required this.springOffset,
    required this.sprintPaint,
  });
}
