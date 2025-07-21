import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flexify/common/utils.dart';
import 'dart:convert';
import 'package:flexify/models/movie_detail_model.dart';
import 'package:flexify/screens/movie_detail_screen.dart';
import 'package:flexify/services/api_services.dart';
import 'package:flexify/widgets/recommend_movie_card.dart';

class RecommendScreen extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendScreen> {
  TextEditingController _searchController = TextEditingController();
  List<int> _recommendedMovieIds = [];
  ApiServices apiServices = ApiServices();

  Future<void> _recommendMovies() async {
    final String baseUrl = 'http://10.0.130.55:8080/recommend';
    final String movieName = _searchController.text;
    final url = '$baseUrl?movieName=$movieName';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _recommendedMovieIds =
            List<int>.from(jsonData['recommended_movie_ids']);
      });
    } else {
      setState(() {
        _recommendedMovieIds = [];
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch recommended movies.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoSearchTextField(
                controller: _searchController,
                padding: const EdgeInsets.all(10.0),
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.3),
                onSubmitted: (value) {},
                placeholder: 'Search movie...',
              ),
              SizedBox(height: 16.0),
              CupertinoButton.filled(
                child: Text('Recommend'),
                onPressed: () {
                  _recommendMovies();
                },
              ),
              SizedBox(height: 16.0),
              if (_recommendedMovieIds.isNotEmpty)
                Expanded(
                  child: FutureBuilder<List<MovieDetailModel>>(
                    future:
                        apiServices.getRecommendedMovies(_recommendedMovieIds),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(
                            'assets/animations/loading_animation.json', // Replace with your animation file path
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final movie = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailScreen(movieId: movie.id)),
                                );
                              },
                              child: MovieCard(
                                title: movie.title,
                                backdropPath: "$imageUrl${movie.backdropPath}",
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
