import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import 'harness_options.dart';

class HarnessDeviceFrame extends StatelessWidget {
  const HarnessDeviceFrame({
    super.key,
    required this.config,
    required this.child,
  });

  final HarnessConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = config.size;
    final insets = config.safeInsets;
    final mq = MediaQuery.of(context).copyWith(
      size: size,
      padding: insets,
      viewPadding: insets,
      viewInsets: EdgeInsets.only(
        bottom: config.keyboard ? config.keyboardHeight : 0,
      ),
      platformBrightness: config.dark ? Brightness.dark : Brightness.light,
    );
    final theme = config.dark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(44),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Theme(
              data: theme,
              child: MediaQuery(
                data: mq,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    if (config.notch && !config.landscape) const _NotchPill(),
                    if (config.notch && !config.keyboard) const _GestureBar(),
                    if (config.keyboard)
                      _FakeKeyboard(height: config.keyboardHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotchPill extends StatelessWidget {
  const _NotchPill();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 110,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
      ),
    );
  }
}

class _GestureBar extends StatelessWidget {
  const _GestureBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 120,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _FakeKeyboard extends StatelessWidget {
  const _FakeKeyboard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: IgnorePointer(
        child: ColoredBox(
          color: Colors.blueGrey.shade800,
          child: const Center(
            child: Text(
              'Keyboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}