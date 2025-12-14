import 'dart:math';
import 'package:flutter/material.dart';

class DustEngine extends StatefulWidget {
  const DustEngine({super.key});
  @override
  State<DustEngine> createState() => _DustEngineState();
}

class _DustEngineState extends State<DustEngine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<DustParticle> _particles = [];
  final Random _random = Random();
  // Check the current brightness

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 50; i++) {
      _particles.add(DustParticle(_random));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check the current brightness
    final particleColor = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          CustomPaint(painter: DustPainter(_particles, particleColor), size: Size.infinite),
    );
  }
}

class DustParticle {
  double x, y, speedX, speedY, size, opacity;
  DustParticle(Random random)
    : x = random.nextDouble(),
      y = random.nextDouble(),
      speedX = (random.nextDouble() - 0.5) * 0.0005,
      speedY = (random.nextDouble() - 0.5) * 0.0005,
      size = random.nextDouble() * 2 + 0.5,
      opacity = random.nextDouble() * 0.3 + 0.1;
}

class DustPainter extends CustomPainter {
  final List<DustParticle> particles;
  final Color particleColor;

  DustPainter(this.particles, this.particleColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      p.x += p.speedX;
      p.y += p.speedY;
      if (p.x < 0) p.x = 1;
      if (p.x > 1) p.x = 0;
      if (p.y < 0) p.y = 1;
      if (p.y > 1) p.y = 0;
      paint.color = particleColor.withAlpha((255 * p.opacity).toInt());
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
