import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Center(
        child: RadarChart(
          sides: 6,
          values: const [0.4, 0.5, 0.6, 0.7, 0.8, 0.3],
          maxValue: 1.0,
        ),
      ),
    );
  }
}

class RadarChart extends StatelessWidget {
  final int sides;
  final List<double> values;
  final double maxValue;
  const RadarChart({
    Key? key,
    required this.sides,
    required this.values,
    this.maxValue = 1.0,
  })  : assert(sides == values.length),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: RadarChartPainter(sides: sides, values: values, maxValue: maxValue),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final int sides;
  final List<double> values;
  final double maxValue;
  RadarChartPainter({required this.sides, required this.values, required this.maxValue});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final angle = 2 * pi / sides;
    final path = Path();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue; // Draw radar chart
    for (int i = 0; i < sides; i++) {
      double x = center.dx + radius * values[i] / maxValue * cos(angle * i - pi / 2);
      double y = center.dy + radius * values[i] / maxValue * sin(angle * i - pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint); // Draw lines from center to vertices
    paint.color = Colors.grey;
    for (int i = 0; i < sides; i++) {
      double x = center.dx + radius * cos(angle * i - pi / 2);
      double y = center.dy + radius * sin(angle * i - pi / 2);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
