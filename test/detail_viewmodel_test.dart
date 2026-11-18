import 'package:flutter_test/flutter_test.dart';
import 'package:lab04/core/error/failure.dart';
import 'package:lab04/presentation/viewmodels/detail_state.dart';
import 'package:lab04/presentation/viewmodels/detail_viewmodel.dart';

import 'support/fake_drama_repository.dart';

void main() {
  test('drama ditemukan menjadi Loaded', () async {
    final vm = DetailViewModel(dramaId: '1', repository: FakeDramaRepository());
    expect(vm.state, const DetailLoading());

    await vm.load();

    expect((vm.state as DetailLoaded).drama.title, 'Eternal Love');
    vm.dispose();
  });

  test('id tidak ada menjadi NotFound', () async {
    final vm = DetailViewModel(dramaId: 'x', repository: FakeDramaRepository());
    await vm.load();
    expect(vm.state, const DetailNotFound());
    vm.dispose();
  });

  test('toggleBookmark mengubah drama menjadi bookmarked', () async {
    final vm = DetailViewModel(dramaId: '1', repository: FakeDramaRepository());
    await vm.load();

    final error = await vm.toggleBookmark();
    await pumpEventQueue();

    expect(error, isNull);
    expect((vm.state as DetailLoaded).drama.isBookmarked, isTrue);
    vm.dispose();
  });

  test('error repository menjadi Failure dengan pesan pengguna', () async {
    final repo = FakeDramaRepository(failure: const Failure('Gagal'));
    final vm = DetailViewModel(dramaId: '1', repository: repo);
    await vm.load();
    expect(vm.state, const DetailFailure('Gagal'));
    vm.dispose();
  });
}