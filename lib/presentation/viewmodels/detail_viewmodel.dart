import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/error/failure.dart';
import '../../domain/repositories/drama_repository.dart';
import 'detail_state.dart';

class DetailViewModel extends ChangeNotifier {
  DetailViewModel({required this.dramaId, required this.repository}) {
    _subscription = repository.changes.listen((_) => load(showLoading: false));
  }

  final String dramaId;
  final DramaRepository repository;
  late final StreamSubscription<void> _subscription;
  bool _disposed = false;

  DetailState _state = const DetailLoading();
  DetailState get state => _state;

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) _emit(const DetailLoading());
    try {
      final drama = await repository.getById(dramaId);
      if (_disposed) return;
      _emit(drama == null ? const DetailNotFound() : DetailLoaded(drama));
    } on Failure catch (e) {
      if (_disposed) return;
      _emit(DetailFailure(e.message));
    } catch (_) {
      if (_disposed) return;
      _emit(const DetailFailure('Terjadi kesalahan. Silakan coba lagi.'));
    }
  }

    Future<String?> toggleBookmark() async {
    try {
      await repository.toggleBookmark(dramaId);
      return null;
    } on Failure catch (e) {
      return e.message;
    } catch (_) {
      return 'Gagal menyimpan bookmark. Coba lagi.';
    }
  }

  void _emit(DetailState state) {
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