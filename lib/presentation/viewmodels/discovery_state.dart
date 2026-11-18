import 'package:equatable/equatable.dart';

import '../../domain/entities/drama.dart';

sealed class DiscoveryState extends Equatable {
  const DiscoveryState();
  @override
  List<Object?> get props => const [];
}

final class DiscoveryLoading extends DiscoveryState {
  const DiscoveryLoading();
}

final class DiscoveryLoaded extends DiscoveryState {
  const DiscoveryLoaded(this.dramas);
  final List<Drama> dramas;
  @override
  List<Object?> get props => [dramas];
}

final class DiscoveryEmpty extends DiscoveryState {
  const DiscoveryEmpty();
}

final class DiscoveryFailure extends DiscoveryState {
  const DiscoveryFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}