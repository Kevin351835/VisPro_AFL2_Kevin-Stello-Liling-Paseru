import 'package:flutter/material.dart';

import '../../core/empty_state.dart';
import '../../core/error_state.dart';
import '../../domain/repositories/drama_repository.dart';
import '../viewmodels/bookmark_state.dart';
import '../viewmodels/bookmark_viewmodel.dart';
import '../widgets/drama_card.dart';
import 'detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key, required this.repository});
  final DramaRepository repository;

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late final BookmarkViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = BookmarkViewModel(repository: widget.repository)..load();
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
        return Scaffold(
          appBar: AppBar(title: const Text('Favorit Saya')),
          body: switch (_vm.state) {
            BookmarkLoading() =>
              const Center(child: CircularProgressIndicator()),
            BookmarkEmpty() => const EmptyStateWidget(
                message: 'Belum ada drama favorit yang disimpan',
                icon: Icons.bookmark_border,
              ),
            BookmarkFailure(:final message) =>
              ErrorStateWidget(message: message, onRetry: _vm.load),
            BookmarkLoaded(:final dramas) => ListView.builder(
                itemCount: dramas.length,
                itemBuilder: (context, index) {
                  final drama = dramas[index];
                  return DramaCard(
                    drama: drama,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          dramaId: drama.id,
                          repository: widget.repository,
                        ),
                      ),
                    ),
                    onBookmarkToggle: () => _toggle(drama.id),
                  );
                },
              ),
          },
        );
      },
    );
  }
}