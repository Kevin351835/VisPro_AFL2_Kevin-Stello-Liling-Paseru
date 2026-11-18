import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'data/datasources/asset_drama_data_source.dart';
import 'data/datasources/bookmark_data_source.dart';
import 'data/datasources/drama_data_source.dart';
import 'data/datasources/shared_prefs_bookmark_data_source.dart';
import 'data/repositories/drama_repository_impl.dart';
import 'dev/harness/device_harness.dart';
import 'presentation/screens/discovery_screen.dart';

class App extends StatefulWidget {
  static const bool _harnessFlag = bool.fromEnvironment('HARNESS');

  const App({
    super.key,
    this.dramaSource,
    this.bookmarkSource,
    this.useHarness = _harnessFlag,
  });

  final DramaDataSource? dramaSource;

  final BookmarkDataSource? bookmarkSource;

  final bool useHarness;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final DramaRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    _repository = DramaRepositoryImpl(
      dramas: widget.dramaSource ?? AssetDramaDataSource(),
      bookmarks: widget.bookmarkSource ?? SharedPrefsBookmarkDataSource(),
    );
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  void _applyHarnessData(HarnessData mode) {
    AssetDramaDataSource.mode.value = switch (mode) {
      HarnessData.normal => DramaDataMode.normal,
      HarnessData.zero => DramaDataMode.empty,
      HarnessData.many => DramaDataMode.many,
    };
    _repository.notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C-Drama Lore Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: widget.useHarness
          ? (context, child) =>
              DeviceHarness(onDataChanged: _applyHarnessData, child: child!)
          : null,
      home: DiscoveryScreen(repository: _repository),
    );
  }
}