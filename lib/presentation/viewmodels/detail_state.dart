import 'package:equatable/equatable.dart';

import '../../domain/entities/drama.dart';

sealed class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => const [];
}

final class DetailLoading extends DetailState {
  const DetailLoading();
}

final class DetailLoaded extends DetailState {
  const DetailLoaded(this.drama);
  final Drama drama;
  @override
  List<Object?> get props => [drama];
}

final class DetailNotFound extends DetailState {
  const DetailNotFound();
}

final class DetailFailure extends DetailState {
  const DetailFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}