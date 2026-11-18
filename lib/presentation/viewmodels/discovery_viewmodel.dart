import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/drama.dart';
import '../../domain/repositories/drama_repository.dart';
import 'discovery_state.dart';

class DiscoveryViewModel extends ChangeNotifier {
  DiscoveryViewModel({required this.repository}) {
    _subscription = repository.changes.listen((_) => load(showLoading: false));
  }

  final DramaRepository repository;
  late final StreamSubscription<void> _subscription;
  bool _disposed = false;

  DiscoveryState _state = const DiscoveryLoading();
  List<Drama> _all = const [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  DiscoveryState get state => _state;
  String get selectedCategory => _selectedCategory;

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) _emit(const DiscoveryLoading());
    try {
      final dramas = await repository.getAll();
      if (_disposed) return;
      _all = dramas;
      _emit(_derive());
    } on Failure catch (e) {
      if (_disposed) return;
      _emit(DiscoveryFailure(e.message));
    } catch (_) {
      if (_disposed) return;
      _emit(const DiscoveryFailure('Terjadi kesalahan. Silakan coba lagi.'));
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _refilter();
  }

  void search(String query) {
    _searchQuery = query;
    _refilter();
  }

  Future<String?> toggleBookmark(String id) async {
    try {
      await repository.toggleBookmark(id);
      return null;
    } on Failure catch (e) {
      return e.message;
    } catch (_) {
      return 'Gagal menyimpan bookmark. Coba lagi.';
    }
  }
  void _refilter() {
    final s = _state;
    if (s is DiscoveryLoaded || s is DiscoveryEmpty) {
      _emit(_derive());
    } else if (!_disposed) {
      notifyListeners();
    }
  }

  DiscoveryState _derive() {
    final query = _searchQuery.toLowerCase();
    final result = _all.where((d) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          d.genre.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = d.title.toLowerCase().contains(query) ||
          d.mandarinTitle.toLowerCase().contains(query) ||
          d.cast.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
    return result.isEmpty ? const DiscoveryEmpty() : DiscoveryLoaded(result);
  }

  void _emit(DiscoveryState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}