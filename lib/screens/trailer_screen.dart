import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flexify/common/utils.dart';
import 'package:flexify/screens/video_player_screen.dart';

class TrailerScreen extends StatefulWidget {
  final int movieId;
  TrailerScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late Future<List<Map<String, dynamic>>> _fetchTrailers;

  @override
  void initState() {
    super.initState();
    _fetchTrailers = fetchTrailers();
  }

  Future<List<Map<String, dynamic>>> fetchTrailers() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieId}/videos?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final results = jsonData['results'] as List<dynamic>;
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load trailers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.black, // Set the AppBar background color to black
        title: Text('Trailers',
            style: TextStyle(
                color: Colors.white)), // Set title text color to white
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchTrailers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/loading.json', // Replace with your animation file path
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final trailers = snapshot.data!;
              return ListView.builder(
                itemCount: trailers.length,
                itemBuilder: (context, index) {
                  final trailer = trailers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[800],
                      ),
                      child: ListTile(
                        title: Text(
                          trailer['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          final videoKey = trailer['key'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(videoKey),
                            ),
                          );
                        },
                        // Add hover animation
                        hoverColor: Colors.grey[700],
                        mouseCursor: MaterialStateMouseCursor.clickable,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
