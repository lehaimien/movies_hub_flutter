import 'package:flutter/material.dart';
import 'package:movies_hub_flutter/constants.dart';
import 'package:movies_hub_flutter/widgets/content_list.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List tvShows = [];

  @override
  void initState(){
    loadTrendingMovies();
    super.initState();
  }

  loadTrendingMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(kApiKey, kApiToken),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));

    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topRatedMoviesResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvShowsResult = await tmdbWithCustomLogs.v3.tv.getTopRated();

    setState(() {
      trendingMovies = trendingResult['results'];
      topRatedMovies = topRatedMoviesResult['results'];
      tvShows = tvShowsResult['results'];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('Movies Hub'),
        backgroundColor: kAppBar,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Movies',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
                ),

                SizedBox(height: 10,),

                ContentList(content: trendingMovies, pathName: 'title',),

                Text(
                  'Top Rated Movies',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
                ),
                SizedBox(height: 10,),
                ContentList(content: topRatedMovies, pathName: 'title',),

                Text(
                  'Popular TV Shows',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
                ),
                SizedBox(height: 10,),
                ContentList(content: tvShows, pathName: 'name',)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
