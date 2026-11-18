import 'package:flutter_test/flutter_test.dart';
import 'package:lab04/core/error/failure.dart';
import 'package:lab04/data/datasources/asset_drama_data_source.dart';
import 'package:lab04/data/datasources/drama_data_source.dart';
import 'package:lab04/data/datasources/shared_prefs_bookmark_data_source.dart';
import 'package:lab04/data/models/drama_model.dart';
import 'package:lab04/data/repositories/drama_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FailingSource implements DramaDataSource {
  @override
  Future<List<DramaModel>> fetchAll() async => throw Exception('boom');
}

DramaRepositoryImpl build() => DramaRepositoryImpl(
      dramas: AssetDramaDataSource(),
      bookmarks: SharedPrefsBookmarkDataSource(),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => AssetDramaDataSource.mode.value = DramaDataMode.normal);

  test('bookmark bertahan setelah repository dibuat ulang (cold restart)', () async {
    final first = build();
    await first.toggleBookmark('1');
    first.dispose();

    final second = build();
    final saved = await second.getBookmarked();
    second.dispose();

    expect(saved.map((d) => d.id), ['1']);
  });

  test('toggle dua kali menghapus bookmark', () async {
    final repo = build();
    await repo.toggleBookmark('1');
    await repo.toggleBookmark('1');
    expect(await repo.getBookmarked(), isEmpty);
    repo.dispose();
  });

  test('mode empty mengembalikan daftar kosong', () async {
    AssetDramaDataSource.mode.value = DramaDataMode.empty;
    final repo = build();
    expect(await repo.getAll(), isEmpty);
    repo.dispose();
  });

  test('getById id tidak ada mengembalikan null', () async {
    final repo = build();
    expect(await repo.getById('tidak-ada'), isNull);
    repo.dispose();
  });

  test('sumber data gagal menjadi Failure berpesan pengguna', () async {
    final repo = DramaRepositoryImpl(
      dramas: _FailingSource(),
      bookmarks: SharedPrefsBookmarkDataSource(),
    );
    expect(
      repo.getAll(),
      throwsA(isA<Failure>().having((f) => f.message, 'message', contains('Silakan coba lagi'))),
    );
    repo.dispose();
  });
}