import 'dart:async';

import '../../core/error/failure.dart';
import '../../domain/entities/drama.dart';
import '../../domain/repositories/drama_repository.dart';
import '../datasources/drama_data_source.dart';
import '../datasources/bookmark_data_source.dart';

class DramaRepositoryImpl implements DramaRepository {
  DramaRepositoryImpl({
    required this.dramas,
    required this.bookmarks,
  });

  final DramaDataSource dramas;
  final BookmarkDataSource bookmarks;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  void notifyChanged() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Future<List<Drama>> getAll() async {
    try {
      final ids = await bookmarks.load();
      final raw = await dramas.fetchAll();
      return raw
          .map((m) => m.toEntity(isBookmarked: ids.contains(m.id)))
          .toList();
    } catch (_) {
      throw const Failure('Gagal memuat daftar drama. Silakan coba lagi.');
    }
  }

  @override
  Future<List<Drama>> getBookmarked() async =>
      (await getAll()).where((d) => d.isBookmarked).toList();

  @override
  Future<Drama?> getById(String id) async {
    for (final d in await getAll()) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  Future<void> toggleBookmark(String id) async {
    try {
      final ids = await bookmarks.load();
      if (!ids.remove(id)) ids.add(id);
      await bookmarks.save(ids);
    } catch (_) {
      throw const Failure('Gagal menyimpan bookmark. Silakan coba lagi.');
    }
    notifyChanged();
  }

  void dispose() => _changes.close();
}