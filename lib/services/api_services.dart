import 'dart:convert';
import 'dart:developer';
import 'package:flexify/common/utils.dart';
import 'package:flexify/models/base_recommendation_movie.dart';
import 'package:flexify/models/movie_detail_model.dart';
import 'package:flexify/models/movie_series_model.dart';
import 'package:flexify/models/search_movie_model.dart';
import 'package:flexify/models/upcoming_movie_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success data :" + response.body.toString());
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success data :" + response.body.toString());
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load now playing movies");
  }

  Future<MovieSeriesModel> getTopRatedMovies() async {
    endPoint = "movie/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success data :${response.body.toString()}");
      return MovieSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Top rated movies");
  }

  Future<SearchModel> getSearchMovie(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    log("search Url $url");
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDg3ODY2Y2I0ZmZjZjRkMDgyOTkyMWNkMTJjYWM5ZiIsInN1YiI6IjY0NTYwOGI0OTFmMGVhMDEzZDA0YWI2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2Y6_s6PUT0CglEBgiylDY8U4igf9l-U9b7G3eA5n7zw"
    });

    if (response.statusCode == 200) {
      log("success movie Search :${response.body.length}");
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Searched movies");
  }

  Future<BaseRecommendationModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint";
    log("search Url $url");
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDg3ODY2Y2I0ZmZjZjRkMDgyOTkyMWNkMTJjYWM5ZiIsInN1YiI6IjY0NTYwOGI0OTFmMGVhMDEzZDA0YWI2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2Y6_s6PUT0CglEBgiylDY8U4igf9l-U9b7G3eA5n7zw"
    });

    if (response.statusCode == 200) {
      log("success movie Search :${response.body.length}");
      return BaseRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Popular movies");
  }

  Future<MovieDetailModel> getMovieDetail(int id) async {
    endPoint = 'movie/$id';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<BaseRecommendationModel> getMovieRecommendation(int id) async {
    endPoint = 'movie/$id/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return BaseRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie recommendations');
  }

  Future<List<MovieDetailModel>> getRecommendedMovies(
      List<int> movieIds) async {
    List<MovieDetailModel> recommendedMovies = [];

    for (int id in movieIds) {
      try {
        final movieDetail = await getMovieDetail(id);
        recommendedMovies.add(movieDetail);
      } catch (e) {
        log('Error fetching movie details for ID: $id');
      }
    }
    return recommendedMovies;
  }
}
