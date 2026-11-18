import 'package:flutter_test/flutter_test.dart';
import 'package:lab04/core/error/failure.dart';
import 'package:lab04/presentation/viewmodels/discovery_state.dart';
import 'package:lab04/presentation/viewmodels/discovery_viewmodel.dart';

import 'support/fake_drama_repository.dart';

void main() {
  test('load: Loading lalu Loaded berisi semua drama', () async {
    final vm = DiscoveryViewModel(repository: FakeDramaRepository());
    expect(vm.state, const DiscoveryLoading());

    await vm.load();

    expect((vm.state as DiscoveryLoaded).dramas.length, 3);
    vm.dispose();
  });

  test('kategori tanpa hasil menjadi Empty, pencarian menyaring', () async {
    final vm = DiscoveryViewModel(repository: FakeDramaRepository());
    await vm.load();

    vm.selectCategory('Wuxia / Martial Arts');
    expect(vm.state, const DiscoveryEmpty());

    vm.selectCategory('Semua');
    vm.search('scarlet');
    expect((vm.state as DiscoveryLoaded).dramas.single.id, '3');
    vm.dispose();
  });

  test('gagal memuat menjadi Failure, coba lagi berhasil', () async {
    final repo = FakeDramaRepository(failure: const Failure('Gagal'));
    final vm = DiscoveryViewModel(repository: repo);

    await vm.load();
    expect(vm.state, const DiscoveryFailure('Gagal'));

    repo.failure = null;
    await vm.load();
    expect(vm.state, isA<DiscoveryLoaded>());
    vm.dispose();
  });

  test('bookmark memperbarui state lewat stream changes', () async {
    final vm = DiscoveryViewModel(repository: FakeDramaRepository());
    await vm.load();

    final error = await vm.toggleBookmark('1');
    await pumpEventQueue();

    expect(error, isNull);
    final dramas = (vm.state as DiscoveryLoaded).dramas;
    expect(dramas.firstWhere((d) => d.id == '1').isBookmarked, isTrue);
    vm.dispose();
  });

  test('bookmark gagal mengembalikan pesan dan daftar tetap tampil', () async {
    final repo = FakeDramaRepository();
    final vm = DiscoveryViewModel(repository: repo);
    await vm.load();

    repo.failure = const Failure('Gagal menyimpan');
    final error = await vm.toggleBookmark('1');

    expect(error, 'Gagal menyimpan');
    expect(vm.state, isA<DiscoveryLoaded>());
    vm.dispose();
  });
}