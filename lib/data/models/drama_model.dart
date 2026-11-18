import '../../domain/entities/drama.dart';

class DramaModel {
  const DramaModel({
    required this.id,
    required this.title,
    required this.mandarinTitle,
    required this.releaseYear,
    required this.totalEpisodes,
    required this.cast,
    required this.genre,
  });

  final String id;
  final String title;
  final String mandarinTitle;
  final int releaseYear;
  final int totalEpisodes;
  final String cast;
  final String genre;

  Drama toEntity({bool isBookmarked = false}) => Drama(
        id: id,
        title: title,
        mandarinTitle: mandarinTitle,
        releaseYear: releaseYear,
        totalEpisodes: totalEpisodes,
        cast: cast,
        genre: genre,
        isBookmarked: isBookmarked,
      );
}