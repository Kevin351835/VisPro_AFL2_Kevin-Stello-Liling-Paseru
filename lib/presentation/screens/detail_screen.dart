import 'package:flutter/material.dart';

import '../../core/empty_state.dart';
import '../../core/error_state.dart';
import '../../domain/entities/drama.dart';
import '../../domain/repositories/drama_repository.dart';
import '../viewmodels/detail_state.dart';
import '../viewmodels/detail_viewmodel.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.dramaId,
    required this.repository,
  });
  final String dramaId;
  final DramaRepository repository;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = DetailViewModel(
      dramaId: widget.dramaId,
      repository: widget.repository,
    )..load();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final error = await _vm.toggleBookmark();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return switch (_vm.state) {
          DetailLoading() => Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            ),
          DetailNotFound() => Scaffold(
              appBar: AppBar(),
              body: const EmptyStateWidget(message: 'Drama tidak ditemukan'),
            ),
          DetailFailure(:final message) => Scaffold(
              appBar: AppBar(),
              body: ErrorStateWidget(message: message, onRetry: _vm.load),
            ),
          DetailLoaded(:final drama) => _buildContent(context, drama),
        };
      },
    );
  }

  Widget _buildContent(BuildContext context, Drama drama) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(drama.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            key: const Key('order-button'),
            icon: Icon(
              drama.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: drama.isBookmarked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: drama.isBookmarked ? 'Hapus Bookmark' : 'Tambah Bookmark',
            onPressed: _toggle,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(drama.mandarinTitle, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Chip(
                label: Text(drama.genre),
                backgroundColor: theme.colorScheme.secondaryContainer,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.movie, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('${drama.totalEpisodes} Eps'),
                  const SizedBox(width: 24),
                  Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Rilis ${drama.releaseYear}'),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Pemeran Utama:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: drama.cast.split(',').map((actor) {
                  return Chip(
                    avatar: const Icon(Icons.person, size: 18),
                    label: Text(actor.trim()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}