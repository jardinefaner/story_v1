import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class DustEngine extends StatefulWidget {
  final int particleCount;
  final Color? particleColor;

  const DustEngine({
    super.key,
    this.particleCount = 50,
    this.particleColor,
  });

  @override
  State<DustEngine> createState() => _DustEngineState();
}

class _DustEngineState extends State<DustEngine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DustParticleSystem _particleSystem;

  @override
  void initState() {
    super.initState();
    // Initialize particles
    _particleSystem = DustParticleSystem(widget.particleCount);

    // Initialize controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // Clock logic
    )..repeat();

    // PERFORMANCE FIX:
    // We update physics in a listener. This runs every frame,
    // but DOES NOT trigger 'setState' or 'build'.
    // The CustomPainter listens to the controller separately to handle drawing.
    _controller.addListener(_updatePhysics);
  }

  void _updatePhysics() {
    _particleSystem.update();
  }

  @override
  void didUpdateWidget(DustEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize particles only if count changes
    if (oldWidget.particleCount != widget.particleCount) {
      _particleSystem = DustParticleSystem(widget.particleCount);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePhysics);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine color here. Since we removed AnimatedBuilder, this build method
    // only runs when the parent changes or Theme changes, NOT every animation frame.
    final color = widget.particleColor ?? Theme.of(context).colorScheme.primary;

    return CustomPaint(
      // We pass the controller as the 'repaint' argument.
      // This tells Flutter: "Repaint the canvas when this controller ticks,
      // but do not rebuild the widget tree."
      painter: DustPainter(
        particles: _particleSystem,
        particleColor: color,
        repaint: _controller,
      ),
      size: Size.infinite,
    );
  }
}

/// Particle system logic (CPU optimized using TypedData)
class DustParticleSystem {
  final int count;
  // Using Float32List reduces memory overhead per particle significantly
  late final Float32List _x;
  late final Float32List _y;
  late final Float32List _speedX;
  late final Float32List _speedY;
  late final Float32List _size;
  late final Float32List _opacity;

  DustParticleSystem(this.count) {
    _x = Float32List(count);
    _y = Float32List(count);
    _speedX = Float32List(count);
    _speedY = Float32List(count);
    _size = Float32List(count);
    _opacity = Float32List(count);

    final random = Random();
    for (int i = 0; i < count; i++) {
      _x[i] = random.nextDouble();
      _y[i] = random.nextDouble();
      // Normalized speed
      _speedX[i] = (random.nextDouble() - 0.5) * 0.0005;
      _speedY[i] = (random.nextDouble() - 0.5) * 0.0005;
      _size[i] = random.nextDouble() * 2 + 0.5;
      _opacity[i] = random.nextDouble() * 0.3 + 0.1;
    }
  }

  void update() {
    for (int i = 0; i < count; i++) {
      _x[i] += _speedX[i];
      _y[i] += _speedY[i];

      // Wrap around screen edges
      if (_x[i] < 0) _x[i] = 1;
      if (_x[i] > 1) _x[i] = 0;
      if (_y[i] < 0) _y[i] = 1;
      if (_y[i] > 1) _y[i] = 0;
    }
  }

  // Getters for the painter
  Float32List get x => _x;
  Float32List get y => _y;
  Float32List get size => _size;
  Float32List get opacity => _opacity;
}

class DustPainter extends CustomPainter {
  final DustParticleSystem particles;
  final Color particleColor;

  // Instance-level Paint object to prevent allocation in the loop
  // but avoid static issues if multiple DustEngines exist with different settings.
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  DustPainter({
    required this.particles,
    required this.particleColor,
    required Listenable repaint,
  }) : super(repaint: repaint); // Triggers paint() when controller ticks

  @override
  void paint(Canvas canvas, Size size) {
    final count = particles.count;
    final x = particles.x;
    final y = particles.y;
    final sizes = particles.size;
    final opacities = particles.opacity;

    final width = size.width;
    final height = size.height;

    // Direct memory access is fast
    for (int i = 0; i < count; i++) {
      // Update the alpha of the single Paint instance
      _paint.color = particleColor.withAlpha((255 * opacities[i]).toInt());

      canvas.drawCircle(
        Offset(x[i] * width, y[i] * height),
        sizes[i],
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(DustPainter oldDelegate) {
    // We return false here because the animation is handled by the
    // 'repaint' Listenable passed to super().
    // We only need to return true if the structural configuration changed
    // (e.g., the user updated the widget with a new color).
    return oldDelegate.particleColor != particleColor ||
        oldDelegate.particles != particles;
  }
}