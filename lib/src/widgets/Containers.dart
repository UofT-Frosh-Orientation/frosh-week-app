import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../colors.dart';
import 'package:simple_animations/simple_animations.dart';

class ExitButton extends StatelessWidget {
  final VoidCallback onTap;
  const ExitButton({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Exit',
        onPressed: onTap,
      ),
    );
  }
}

class Box extends StatelessWidget {
  final Widget widget;
  final bool fancy;
  final bool animated;
  final bool lightShadow;
  final List<Color> colors;
  final Color animatedColor;
  final double outerPadding;
  final double outerMargin;
  final double borderRadius;

  const Box({
    Key? key,
    required this.widget,
    this.fancy = false,
    this.animated = false,
    this.lightShadow = false,
    this.colors = const [
      const Color(0xB48C2EA8),
      const Color(0xBE442FAC),
      const Color(0xB7CA42D4)
    ],
    this.animatedColor = Colors.purple,
    this.outerPadding = 23.0,
    this.outerMargin = 1,
    this.borderRadius = 7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.animated) {
      return Container(
          margin: EdgeInsets.only(
              left: 15.0 * outerMargin,
              right: 15 * outerMargin,
              top: 8 * outerMargin,
              bottom: 8 * outerMargin),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(this.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: lightShadow
                      ? Theme.of(context).colorScheme.shadowColorLight
                      : Theme.of(context).colorScheme.shadowColor,
                  offset: Offset(0, 4.0),
                  blurRadius: 6.0,
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(this.borderRadius),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBackground(color: this.animatedColor),
                ),
                Padding(
                  padding: EdgeInsets.all(this.outerPadding),
                  child: widget,
                ),
              ],
            ),
          ));
    }
    if (this.fancy)
      return Container(
        margin: EdgeInsets.only(
            left: 15.0 * outerMargin,
            right: 15 * outerMargin,
            top: 8 * outerMargin,
            bottom: 8 * outerMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(this.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(-1.09, -2.98),
            end: Alignment(1.0, 2.66),
            colors: colors,
            stops: [0.0, 0.468, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: lightShadow
                  ? Theme.of(context).colorScheme.shadowColorLight
                  : Theme.of(context).colorScheme.shadowColor,
              offset: Offset(0, 4.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(this.outerPadding),
          child: widget,
        ),
      );
    else
      return Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(this.borderRadius),
            color: Theme.of(context).colorScheme.lightDarkAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 3.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget,
          ),
        ),
      );
  }
}

class AnimatedBackground extends StatelessWidget {
  final Color color;
  const AnimatedBackground({
    Key? key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PlasmaRenderer(
      type: PlasmaType.infinity,
      particles: 10,
      color: Theme.of(context).colorScheme.animatedBackground,
      blur: 0.5,
      size: 1.4,
      speed: 2.9,
      offset: 0,
      blendMode: BlendMode.screen,
      particleType: ParticleType.atlas,
      variation1: 0.20,
      variation2: 0,
      variation3: 0,
      rotation: 0,
    );
  }
}
