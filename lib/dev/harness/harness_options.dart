import 'package:flutter/material.dart';

enum HarnessScreen {
  small('Small phone', Size(320, 568)),
  large('Large phone', Size(430, 932)),
  tablet('Tablet', Size(800, 1280));

  const HarnessScreen(this.label, this.size);
  final String label;
  final Size size;
}

enum HarnessData {
  normal('Normal'),
  zero('Zero items'),
  many('500 items');

  const HarnessData(this.label);
  final String label;
}

class HarnessConfig {
  const HarnessConfig({
    this.screen = HarnessScreen.small,
    this.landscape = false,
    this.data = HarnessData.normal,
    this.keyboard = false,
    this.dark = false,
    this.notch = false,
  });

  final HarnessScreen screen;
  final bool landscape;
  final HarnessData data;
  final bool keyboard;
  final bool dark;
  final bool notch;

  Size get size {
    final s = screen.size;
    return landscape ? Size(s.height, s.width) : s;
  }

  double get keyboardHeight => landscape ? 180 : 280;

  EdgeInsets get safeInsets {
    if (!notch) return EdgeInsets.zero;
    return landscape
        ? const EdgeInsets.fromLTRB(44, 0, 44, 21)
        : EdgeInsets.fromLTRB(0, 44, 0, keyboard ? 0 : 34);
  }

  HarnessConfig copyWith({
    HarnessScreen? screen,
    bool? landscape,
    HarnessData? data,
    bool? keyboard,
    bool? dark,
    bool? notch,
  }) {
    return HarnessConfig(
      screen: screen ?? this.screen,
      landscape: landscape ?? this.landscape,
      data: data ?? this.data,
      keyboard: keyboard ?? this.keyboard,
      dark: dark ?? this.dark,
      notch: notch ?? this.notch,
    );
  }
}