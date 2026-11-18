import 'package:equatable/equatable.dart';

class Drama extends Equatable {
  const Drama({
    required this.id,
    required this.title,
    required this.mandarinTitle,
    required this.releaseYear,
    required this.totalEpisodes,
    required this.cast,
    required this.genre,
    this.isBookmarked = false,
  });

  final String id;
  final String title;
  final String mandarinTitle;
  final int releaseYear;
  final int totalEpisodes;
  final String cast;
  final String genre;
  final bool isBookmarked;

  Drama copyWith({bool? isBookmarked}) => Drama(
        id: id,
        title: title,
        mandarinTitle: mandarinTitle,
        releaseYear: releaseYear,
        totalEpisodes: totalEpisodes,
        cast: cast,
        genre: genre,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        mandarinTitle,
        releaseYear,
        totalEpisodes,
        cast,
        genre,
        isBookmarked,
      ];
}