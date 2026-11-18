import 'package:flutter/material.dart';

import 'harness_device_frame.dart';
import 'harness_options.dart';
import 'harness_panel.dart';

export 'harness_options.dart';

class DeviceHarness extends StatefulWidget {
  const DeviceHarness({super.key, required this.child, this.onDataChanged});

  final Widget child;
  final ValueChanged<HarnessData>? onDataChanged;

  @override
  State<DeviceHarness> createState() => _DeviceHarnessState();
}

class _DeviceHarnessState extends State<DeviceHarness> {
  final _deviceKey = GlobalKey();

  HarnessConfig _config = const HarnessConfig();
  bool _panelOpen = false;

  void _update(HarnessConfig next) {
    final dataChanged = next.data != _config.data;
    setState(() => _config = next);
    if (dataChanged) widget.onDataChanged?.call(next.data);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, c) {
          final device = Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: KeyedSubtree(
                key: _deviceKey,
                child: HarnessDeviceFrame(
                  config: _config,
                  child: widget.child,
                ),
              ),
            ),
          );
          final panel = HarnessPanel(config: _config, onChanged: _update);

          if (c.maxWidth >= 900) {
            return Row(
              children: [
                SizedBox(width: 380, child: panel),
                const VerticalDivider(width: 1),
                Expanded(
                  child: ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: device,
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: FilledButton.tonal(
                    onPressed: () => setState(() => _panelOpen = !_panelOpen),
                    child: Text(_panelOpen ? 'Show device' : 'Harness'),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Offstage(offstage: _panelOpen, child: device),
                    ),
                    if (_panelOpen) Positioned.fill(child: panel),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}