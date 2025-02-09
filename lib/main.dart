import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

const double dotSize = 70;
final orbitalRingKey = GlobalKey();

class Dot {
  String id;
  String? title;
  String? content;
  double? angle;
  String? childOf;
  List<String>? children;

  Dot({required this.id, this.title, this.content, this.angle, this.childOf, this.children});
}

class DotsModel extends ChangeNotifier {
  List<Dot> _dots = [];
  List<Dot> get dots => _dots;

  void addDot(Dot value) {
    _dots.add(value);
    notifyListeners();
  }
}

class OrbitalRingRadiusModel extends ChangeNotifier {
  double? _orbitalRingRadius;
  double? get orbitalRingRadius => _orbitalRingRadius;
  set orbitalRingRadius(double? value) {
    _orbitalRingRadius = value;
    notifyListeners();
  }
}

class MousePositionModel extends ChangeNotifier {
  double _mousePositionX = 0;
  double get mousePositionX => _mousePositionX;
  set mousePositionX(double value) {
    _mousePositionX = value;
    notifyListeners();
  }
}

void main() {
  runApp(orbitApp());
}

Widget orbitApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => OrbitalRingRadiusModel()),
      ChangeNotifierProvider(create: (context) => MousePositionModel()),
      ChangeNotifierProvider(create: (context) => DotsModel())
    ],
    builder: (context, child) => Listener(
      onPointerHover: (event) {
        Provider.of<MousePositionModel>(context, listen: false).mousePositionX = event.localPosition.dx;
      },
      onPointerDown: (event) {
        // print(event.buttons);
        double newDotsAngle = Provider.of<MousePositionModel>(context, listen: false).mousePositionX % 360;
        Dot newDot = Dot(id: "someid", angle: newDotsAngle);
        Provider.of<DotsModel>(context, listen: false).addDot(newDot);
      },
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
          body: MouseRegion(
            cursor: SystemMouseCursors.none,
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: OrbitView(),
                ),
                Expanded(flex: 1, child: panelView())
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class OrbitView extends StatelessWidget {
  const OrbitView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = orbitalRingKey.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;

      //TODO: update on resize.
      if (size.height < size.width) {
        Provider.of<OrbitalRingRadiusModel>(context, listen: false).orbitalRingRadius = size.height / 2;
      } else {
        Provider.of<OrbitalRingRadiusModel>(context, listen: false).orbitalRingRadius = size.width / 2;
      }
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        orbitalRing(),
        dot(),
        dot(angle: 315),
        Consumer<MousePositionModel>(
          builder: (context, value, child) {
            // print(value.mousePositionX);
            return dot(angle: value.mousePositionX, color: Colors.black, backgroundColor: Colors.transparent);
          },
        )
      ],
    );
  }
}

Widget panelView() {
  return const Placeholder(
    child: Center(),
  );
}

Widget orbitalRing() {
  return Padding(
    padding: const EdgeInsets.all(32),
    child: Container(
      key: orbitalRingKey,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: const Color.fromRGBO(0, 0, 0, 0.1))),
    ),
  );
}

Widget dot({double? angle, Color color = Colors.grey, Color backgroundColor = Colors.white}) {
  final container = Container(
    width: dotSize,
    height: dotSize,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: color), color: backgroundColor),
    child: const Center(),
  );

  if (angle == null) {
    return container;
  }

  return Consumer<OrbitalRingRadiusModel>(builder: (context, value, child) {
    return Transform.translate(
      offset: Offset(cos(angle * pi / 180) * (value.orbitalRingRadius ?? 0), sin(angle * pi / 180) * (value.orbitalRingRadius ?? 0)),
      child: container,
    );
  });
}
