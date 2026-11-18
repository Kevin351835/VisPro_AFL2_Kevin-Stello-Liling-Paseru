import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/error/failure.dart';
import '../../domain/repositories/drama_repository.dart';
import 'bookmark_state.dart';

class BookmarkViewModel extends ChangeNotifier {
  BookmarkViewModel({required this.repository}) {
    _subscription = repository.changes.listen((_) => load(showLoading: false));
  }

  final DramaRepository repository;
  late final StreamSubscription<void> _subscription;
  bool _disposed = false;

  BookmarkState _state = const BookmarkLoading();
  BookmarkState get state => _state;

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) _emit(const BookmarkLoading());
    try {
      final dramas = await repository.getBookmarked();
      if (_disposed) return;
      _emit(dramas.isEmpty ? const BookmarkEmpty() : BookmarkLoaded(dramas));
    } on Failure catch (e) {
      if (_disposed) return;
      _emit(BookmarkFailure(e.message));
    } catch (_) {
      if (_disposed) return;
      _emit(const BookmarkFailure('Terjadi kesalahan. Silakan coba lagi.'));
    }
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

  void _emit(BookmarkState state) {
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