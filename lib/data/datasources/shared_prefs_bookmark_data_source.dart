import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bookmark_data_source.dart';

class SharedPrefsBookmarkDataSource implements BookmarkDataSource {
  static const _key = 'bookmarked_ids';
  static const _timeout = Duration(seconds: 2);

  Set<String> _memory = {};

  Future<SharedPreferences?> _prefs() async {
    try {
      return await SharedPreferences.getInstance().timeout(_timeout);
    } on MissingPluginException {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  @override
  Future<Set<String>> load() async {
    final prefs = await _prefs();
    if (prefs == null) return {..._memory};
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  @override
  Future<void> save(Set<String> ids) async {
    final prefs = await _prefs();
    if (prefs == null) {
      _memory = {...ids};
      return;
    }
    final ok = await prefs.setStringList(_key, ids.toList());
    if (!ok) throw StateError('Penyimpanan menolak penulisan');
  }
}