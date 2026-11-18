import 'package:flutter/material.dart';

import '../../core/empty_state.dart';
import '../../core/error_state.dart';
import '../../domain/entities/drama.dart';
import '../../domain/repositories/drama_repository.dart';
import '../viewmodels/discovery_state.dart';
import '../viewmodels/discovery_viewmodel.dart';
import '../widgets/category_bar.dart';
import '../widgets/drama_card.dart';
import '../widgets/drama_grid_card.dart';
import 'bookmark_screen.dart';
import 'detail_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key, required this.repository});
  final DramaRepository repository;

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  late final DiscoveryViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = DiscoveryViewModel(repository: widget.repository)..load();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _toggle(String id) async {
    final error = await _vm.toggleBookmark(id);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        final state = _vm.state;

        return Scaffold(
          appBar: AppBar(
            title: const Text('C-Drama Lore Hub'),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: _openBookmarks,
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 600;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildSearchField()),
                    SliverToBoxAdapter(
                      child: CategoryBar(
                        selectedCategory: _vm.selectedCategory,
                        onCategorySelected: _vm.selectCategory,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    switch (state) {
                      DiscoveryLoading() => const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      DiscoveryFailure(:final message) => SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorStateWidget(
                            message: message,
                            onRetry: _vm.load,
                          ),
                        ),
                      DiscoveryEmpty() => const SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyStateWidget(
                            key: Key('empty-state'),
                            message: 'Drama tidak ditemukan',
                          ),
                        ),
                      DiscoveryLoaded(:final dramas) =>
                        isTablet ? _buildGrid(dramas) : _buildList(dramas),
                    },
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                key: const Key('order-button'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Order / Bookmark Drama'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          key: const Key('search-field'),
          decoration: const InputDecoration(
            hintText: 'Cari judul, mandarin, atau pemain...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: _vm.search,
        ),
      );

  Widget _buildGrid(List<Drama> dramas) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 340,
            mainAxisExtent: 190,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final drama = dramas[index];
              return DramaGridCard(
                key: ValueKey('tablet-${drama.id}'),
                drama: drama,
                onTap: () => _openDetail(drama.id),
                onBookmarkToggle: () => _toggle(drama.id),
              );
            },
            childCount: dramas.length,
          ),
        ),
      );

  Widget _buildList(List<Drama> dramas) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final drama = dramas[index];
            return DramaCard(
              drama: drama,
              onTap: () => _openDetail(drama.id),
              onBookmarkToggle: () => _toggle(drama.id),
            );
          },
          childCount: dramas.length,
        ),
      );

  void _openBookmarks() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookmarkScreen(repository: widget.repository),
        ),
      );

  void _openDetail(String dramaId) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            dramaId: dramaId,
            repository: widget.repository,
          ),
        ),
      );
}