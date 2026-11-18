import 'dart:async';

import 'package:lab04/core/error/failure.dart';
import 'package:lab04/domain/entities/drama.dart';
import 'package:lab04/domain/repositories/drama_repository.dart';

List<Drama> sampleDramas() => const [
      Drama(id: '1', title: 'Eternal Love', mandarinTitle: 'A', releaseYear: 2017,
          totalEpisodes: 58, cast: 'Yang Mi, Mark Chao', genre: 'Xianxia / Fantasy'),
      Drama(id: '2', title: 'Nirvana in Fire', mandarinTitle: 'B', releaseYear: 2015,
          totalEpisodes: 54, cast: 'Hu Ge, Wang Kai', genre: 'Wuxia / Historical'),
      Drama(id: '3', title: 'Scarlet Heart', mandarinTitle: 'C', releaseYear: 2011,
          totalEpisodes: 35, cast: 'Liu Shishi', genre: 'Historical / Palace'),
    ];

class FakeDramaRepository implements DramaRepository {
  FakeDramaRepository({this.failure});

  final List<Drama> _dramas = sampleDramas();
  final Set<String> _bookmarked = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  Failure? failure;

  void _throwIfFailing() {
    final f = failure;
    if (f != null) throw f;
  }

  List<Drama> _view() => _dramas
      .map((d) => d.copyWith(isBookmarked: _bookmarked.contains(d.id)))
      .toList();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<List<Drama>> getAll() async {
    _throwIfFailing();
    return _view();
  }

  @override
  Future<List<Drama>> getBookmarked() async {
    _throwIfFailing();
    return _view().where((d) => d.isBookmarked).toList();
  }

  @override
  Future<Drama?> getById(String id) async {
    _throwIfFailing();
    for (final d in _view()) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  Future<void> toggleBookmark(String id) async {
    _throwIfFailing();
    if (!_bookmarked.remove(id)) _bookmarked.add(id);
    _changes.add(null);
  }
}