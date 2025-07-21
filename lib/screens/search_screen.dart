import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flexify/common/utils.dart';
import 'package:flexify/models/base_recommendation_movie.dart';
import 'package:flexify/models/search_movie_model.dart';
import 'package:flexify/screens/movie_detail_screen.dart';
import 'package:flexify/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  SearchModel? searchedModel;
  late Future<BaseRecommendationModel> popularMovies;

  void search(String query) {
    apiServices.getSearchMovie(query).then((results) {
      setState(() {
        searchedModel = results;
      });
    });
  }

  @override
  void initState() {
    popularMovies = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            CupertinoSearchTextField(
              controller: searchController,
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
              onChanged: (value) {
                if (value.isEmpty) {
                } else {
                  search(searchController.text);
                }
              },
            ),
            searchController.text.isEmpty
                ? FutureBuilder<BaseRecommendationModel>(
                    future: popularMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data?.results;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Top Searches",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // padding: const EdgeInsets.all(3),
                                scrollDirection: Axis.vertical,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                movieId: data[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Image.network(
                                                '$imageUrl${data[index].posterPath}',
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                "${data[index].originalTitle}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                },
                              )
                            ]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    })
                : searchedModel == null
                    ? Center(
                        child: Lottie.asset(
                          'assets/loading.json', // Replace with your animation file path
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: searchedModel?.results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 5,
                          childAspectRatio: 1.2 / 2,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(
                                          movieId: searchedModel!
                                              .results[index].id)));
                            },
                            child: Column(
                              children: [
                                searchedModel!.results[index].backdropPath ==
                                        null
                                    ? Image.asset(
                                        "assets/netflix.png",
                                        height: 170,
                                      )
                                    : CachedNetworkImage(
                                        height: 170,
                                        imageUrl:
                                            "$imageUrl${searchedModel!.results[index].backdropPath}",
                                      ),
                                Expanded(
                                  child: Text(
                                    "${searchedModel!.results[index].originalTitle}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
