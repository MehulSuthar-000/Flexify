import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexify/common/utils.dart';
import 'package:flexify/models/movie_series_model.dart';
import 'package:flexify/screens/movie_detail_screen.dart';

class CustomCarouselSlider extends StatelessWidget {
  final MovieSeriesModel data;
  const CustomCarouselSlider({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      width: size.width,
      child: CarouselSlider.builder(
        itemCount: data.results.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          var url = data.results[index].backdropPath.toString();
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                            movieId: data.results[index].id)));
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CachedNetworkImage(imageUrl: "$imageUrl$url"),
                  Text("${data.results[index].title}")
                ],
              ));
        },
        options: CarouselOptions(
          height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
          aspectRatio: 16 / 9,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          initialPage: 0,
        ),
      ),
    );
  }
}
