import 'package:equatable/equatable.dart';

import '../../domain/entities/drama.dart';

sealed class BookmarkState extends Equatable {
  const BookmarkState();
  @override
  List<Object?> get props => const [];
}

final class BookmarkLoading extends BookmarkState {
  const BookmarkLoading();
}

final class BookmarkLoaded extends BookmarkState {
  const BookmarkLoaded(this.dramas);
  final List<Drama> dramas;
  @override
  List<Object?> get props => [dramas];
}

final class BookmarkEmpty extends BookmarkState {
  const BookmarkEmpty();
}

final class BookmarkFailure extends BookmarkState {
  const BookmarkFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}