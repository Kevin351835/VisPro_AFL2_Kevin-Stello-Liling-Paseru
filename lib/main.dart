import 'package:flutter/material.dart';

import 'app.dart';
import 'data/datasources/asset_drama_data_source.dart';
import 'data/datasources/shared_prefs_bookmark_data_source.dart';

void main() {
  runApp(
    App(
      dramaSource: AssetDramaDataSource(), 
      bookmarkSource: SharedPrefsBookmarkDataSource(),
    ),
  );
}