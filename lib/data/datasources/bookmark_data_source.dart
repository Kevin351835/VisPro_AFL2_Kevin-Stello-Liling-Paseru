abstract class BookmarkDataSource {
  Future<Set<String>> load();
  Future<void> save(Set<String> ids);
}