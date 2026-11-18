import 'package:flutter/material.dart';

import 'harness_options.dart';

class HarnessPanel extends StatelessWidget {
  const HarnessPanel({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final HarnessConfig config;
  final ValueChanged<HarnessConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = config.size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lab 04 · device harness', style: t.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Try every combination. Keep the debug console open: '
            '"A RenderFlex overflowed by … pixels" names the widget, '
            'the axis and the amount.',
            style: t.bodyLarge,
          ),
          const SizedBox(height: 24),
          _Section(title: 'Screen', chips: [
            for (final v in HarnessScreen.values)
              _chip(v.label, config.screen == v,
                  () => onChanged(config.copyWith(screen: v))),
          ]),
          _Section(title: 'Orientation', chips: [
            _chip('Portrait', !config.landscape,
                () => onChanged(config.copyWith(landscape: false))),
            _chip('Landscape', config.landscape,
                () => onChanged(config.copyWith(landscape: true))),
          ]),
          _Section(title: 'Data', chips: [
            for (final v in HarnessData.values)
              _chip(v.label, config.data == v,
                  () => onChanged(config.copyWith(data: v))),
          ]),
          _Section(title: 'Conditions', chips: [
            _chip('Keyboard open', config.keyboard,
                () => onChanged(config.copyWith(keyboard: !config.keyboard))),
            _chip('Dark mode', config.dark,
                () => onChanged(config.copyWith(dark: !config.dark))),
            _chip('Notch + gesture bar', config.notch,
                () => onChanged(config.copyWith(notch: !config.notch))),
          ]),
          Text(
            'Screen: ${s.width.toInt()} × ${s.height.toInt()} dp',
            style: t.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.chips});

  final String title;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: chips),
        ],
      ),
    );
  }
}