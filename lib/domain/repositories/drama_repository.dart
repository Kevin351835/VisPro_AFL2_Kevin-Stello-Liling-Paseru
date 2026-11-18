import '../entities/drama.dart';

abstract class DramaRepository {
  Future<List<Drama>> getAll();
  Future<List<Drama>> getBookmarked();
  Future<Drama?> getById(String id);
  Future<void> toggleBookmark(String id);

  Stream<void> get changes;
}