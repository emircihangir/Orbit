import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dot.dart';
import 'panel_view.dart';

const double dotSize = 70;
final orbitalRingKey = GlobalKey();
late Box appDataBox;
late Box<Dot> dotsBox;

class DotsModel extends ChangeNotifier {
  List<Dot> dots = [];

  DotsModel({required this.dots});

  void addDot(Dot value) {
    dots.add(value);
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DotAdapter());

  appDataBox = await Hive.openBox("appDataBox");
  dotsBox = await Hive.openBox<Dot>("dotsBox");

  runApp(orbitApp());
}

Widget orbitApp() {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrbitalRingRadiusModel()),
        ChangeNotifierProvider(create: (context) => MousePositionModel()),
        ChangeNotifierProvider(create: (context) => DotsModel(dots: dotsBox.values.toList()))
      ],
      builder: (context, child) => Listener(
            onPointerHover: (event) {
              Provider.of<MousePositionModel>(context, listen: false).mousePositionX = event.localPosition.dx;
            },
            onPointerDown: (event) async {
              // print(event.buttons);
              double newDotsAngle = Provider.of<MousePositionModel>(context, listen: false).mousePositionX % 360;
              final int totalDotCount = Hive.box("appDataBox").get("totalDotCount");
              final String newDotID = "dot-${totalDotCount + 1}";
              Dot newDot = Dot(id: newDotID, angle: newDotsAngle);

              await Hive.box<Dot>("dotsBox").put(newDotID, newDot);
              await Hive.box("appDataBox").put("totalDotCount", totalDotCount + 1);

              if (context.mounted) Provider.of<DotsModel>(context, listen: false).addDot(newDot);
            },
            child: MaterialApp(
              theme: ThemeData(scaffoldBackgroundColor: Colors.white, fontFamily: "SFPro"),
              home: Scaffold(
                body: MouseRegion(
                  cursor: SystemMouseCursors.none,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
          ));
}

class OrbitView extends StatelessWidget {
  const OrbitView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = orbitalRingKey.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;

      if (size.height < size.width) {
        Provider.of<OrbitalRingRadiusModel>(context, listen: false).orbitalRingRadius = size.height / 2;
      } else {
        Provider.of<OrbitalRingRadiusModel>(context, listen: false).orbitalRingRadius = size.width / 2;
      }
    });

    return Consumer<DotsModel>(builder: (context, dmValue, child) {
      return Stack(
          alignment: Alignment.center,
          children: [
                orbitalRing(),
                dot()
              ] +
              dmValue.dots
                  .map(
                    (e) => dot(angle: e.angle),
                  )
                  .toList() +
              [
                Consumer<MousePositionModel>(
                  builder: (context, mpmValue, child) {
                    // print(value.mousePositionX);
                    return dot(angle: mpmValue.mousePositionX, color: Colors.black, backgroundColor: Colors.transparent);
                  },
                )
              ]);
    });
  }
}

Widget orbitalRing() {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
