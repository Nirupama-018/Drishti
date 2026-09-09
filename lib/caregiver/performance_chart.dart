import 'package:flutter/material.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final scores = [62, 68, 65, 74, 72, 81, 78];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Trend',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Recent cognitive game scores',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: CustomPaint(
                painter: _ChartPainter(scores),
                child: Container(),
              ),
            ),

            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('S1'),
                Text('S2'),
                Text('S3'),
                Text('S4'),
                Text('S5'),
                Text('S6'),
                Text('S7'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<int> scores;

  _ChartPainter(this.scores);

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Y-axis
    canvas.drawLine(
      const Offset(10, 0),
      Offset(10, size.height),
      axisPaint,
    );

    // X-axis
    canvas.drawLine(
      Offset(10, size.height - 10),
      Offset(size.width, size.height - 10),
      axisPaint,
    );

    final path = Path();

    for (int i = 0; i < scores.length; i++) {
      final x = 20 + (i * (size.width - 40) / (scores.length - 1));
      final y = size.height -
          20 -
          ((scores[i] - 50) / 40) * (size.height - 40);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(
        Offset(x, y),
        5,
        pointPaint,
      );
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}