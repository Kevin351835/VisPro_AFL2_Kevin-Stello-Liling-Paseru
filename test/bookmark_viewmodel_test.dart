import 'package:flutter_test/flutter_test.dart';
import 'package:lab04/core/error/failure.dart';
import 'package:lab04/presentation/viewmodels/bookmark_state.dart';
import 'package:lab04/presentation/viewmodels/bookmark_viewmodel.dart';

import 'support/fake_drama_repository.dart';

void main() {
  test('awalnya Loading, lalu Empty bila belum ada bookmark', () async {
    final vm = BookmarkViewModel(repository: FakeDramaRepository());
    expect(vm.state, const BookmarkLoading());

    await vm.load();

    expect(vm.state, const BookmarkEmpty());
    vm.dispose();
  });

  test('bookmark ditambah dari luar membuat state Loaded', () async {
    final repo = FakeDramaRepository();
    final vm = BookmarkViewModel(repository: repo);
    await vm.load();

    await repo.toggleBookmark('2');
    await pumpEventQueue();

    expect((vm.state as BookmarkLoaded).dramas.single.id, '2');
    vm.dispose();
  });

  test('menghapus bookmark terakhir kembali ke Empty', () async {
    final repo = FakeDramaRepository();
    final vm = BookmarkViewModel(repository: repo);
    await repo.toggleBookmark('1');
    await vm.load();

    await vm.toggleBookmark('1');
    await pumpEventQueue();

    expect(vm.state, const BookmarkEmpty());
    vm.dispose();
  });

  test('error menjadi Failure', () async {
    final repo = FakeDramaRepository(failure: const Failure('Gagal'));
    final vm = BookmarkViewModel(repository: repo);
    await vm.load();
    expect(vm.state, const BookmarkFailure('Gagal'));
    vm.dispose();
  });
}