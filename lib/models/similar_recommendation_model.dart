class RecommendedMovieModel {
  final List<int> recommendedMovieIds;

  RecommendedMovieModel({required this.recommendedMovieIds});

  factory RecommendedMovieModel.fromJson(Map<String, dynamic> json) {
    return RecommendedMovieModel(
      recommendedMovieIds: List<int>.from(json['recommended_movie_ids']),
    );
  }
}
