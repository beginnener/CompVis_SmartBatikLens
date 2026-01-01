import 'package:flutter/material.dart';
import '../../services/tflite_service.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Recognition> recognitions;
  final Size imageSize;
  final Size screenSize;

  BoundingBoxPainter({
    required this.recognitions,
    required this.imageSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;

    final Paint textBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;

    for (var recognition in recognitions) {
      // Convert normalized coordinates to screen coordinates
      final left = recognition.location[0] * screenSize.width;
      final top = recognition.location[1] * screenSize.height;
      final width = recognition.location[2] * screenSize.width;
      final height = recognition.location[3] * screenSize.height;

      // Draw bounding box
      final rect = Rect.fromLTWH(left, top, width, height);
      canvas.drawRect(rect, paint);

      // Draw label background
      final textSpan = TextSpan(
        text:
            '${recognition.label} ${(recognition.confidence * 100).toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelRect = Rect.fromLTWH(
        left,
        top - 20,
        textPainter.width + 8,
        20,
      );
      canvas.drawRect(labelRect, textBackgroundPaint);

      // Draw label text
      textPainter.paint(canvas, Offset(left + 4, top - 18));
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.recognitions != recognitions;
  }
}
