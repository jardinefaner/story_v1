import 'dart:math' as math;
import 'package:flutter/material.dart';

class SeamlessWaveform extends StatefulWidget {
  final Color color;
  final int barCount;
  final Duration duration; // Controls the speed of the wave
  final double strokeWidth;

  const SeamlessWaveform({
    super.key,
    this.color = Colors.blueAccent,
    this.barCount = 40,
    this.duration = const Duration(seconds: 2),
    this.strokeWidth = 4.0,
  });

  @override
  State<SeamlessWaveform> createState() => _SeamlessWaveformState();
}

class _SeamlessWaveformState extends State<SeamlessWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // repeat() goes from 0.0 to 1.0 continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder ensures we know the exact width available
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight > 0 ? constraints.maxHeight : 50),
          painter: _SeamlessWavePainter(
            animationValue: _controller,
            color: widget.color,
            barCount: widget.barCount,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _SeamlessWavePainter extends CustomPainter {
  final Animation<double> animationValue;
  final Color color;
  final int barCount;
  final double strokeWidth;

  _SeamlessWavePainter({
    required this.animationValue,
    required this.color,
    required this.barCount,
    required this.strokeWidth,
  }) : super(repaint: animationValue); // Auto-repaints when animation ticks

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double centerY = size.height / 2;
    // Adaptable step size based on current widget width
    final double step = size.width / barCount;

    // We move exactly 2*PI over the course of 0.0 to 1.0 animation
    // This guarantees the loop is seamless (end matches start)
    final double loopPhase = animationValue.value * 2 * math.pi;

    for (int i = 0; i < barCount; i++) {
      // Normalized X position (0.0 to 1.0)
      final double t = i / barCount;

      // 1. Primary Wave: 2 full cycles (4*PI) across the screen
      // 2. Add loopPhase to make it travel
      final double wave1 = math.sin((t * 4 * math.pi) + loopPhase);

      // 3. Secondary Wave: Offset frequency for organic look
      // We do NOT add loopPhase here to keep a "standing wave" effect
      // mixed with the moving one, or add it at different speed.
      // To keep it perfectly seamless, we must use integer multiples of loopPhase.
      final double wave2 = math.sin((t * 2 * math.pi) - loopPhase);

      // Combine and Normalize (-2 to 2) -> (0 to 1)
      final double combined = (wave1 + wave2) / 2;
      // Map -1..1 to 0..1
      final double normalized = (combined + 1) / 2;

      // Scale height (keep within 10% to 90% of height)
      final double barHeight = (normalized * size.height * 0.8) + (size.height * 0.1);

      final double x = i * step + (step / 2);

      canvas.drawLine(
        Offset(x, centerY - (barHeight / 2)),
        Offset(x, centerY + (barHeight / 2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SeamlessWavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.barCount != barCount;
  }
}