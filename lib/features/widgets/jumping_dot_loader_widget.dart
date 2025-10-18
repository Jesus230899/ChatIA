import 'package:flutter/material.dart';

class JumpingDotLoader extends StatefulWidget {
  final double dotSize;
  final double jumpHeight;
  final Color dotColor;
  final double spacing;

  const JumpingDotLoader({
    super.key,
    this.dotSize = 5.0,
    this.jumpHeight = 8.0,
    this.dotColor = Colors.white70,
    this.spacing = 2.0,
  });

  @override
  JumpingDotLoaderState createState() => JumpingDotLoaderState();
}

class JumpingDotLoaderState extends State<JumpingDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animations = List.generate(3, (index) {
      final start = index * 0.33;
      final end = start + 0.33;
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: widget.spacing),
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            color: widget.dotColor,
            borderRadius: BorderRadius.circular(widget.dotSize / 2),
          ),
          transform: Matrix4.translationValues(
            0,
            -animation.value * widget.jumpHeight,
            0,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _animations.map(_buildDot).toList(),
    );
  }
}
