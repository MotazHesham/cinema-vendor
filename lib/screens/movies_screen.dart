import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import '../Widgets/movie_item.dart';

class MoviesScreen extends StatefulWidget {
  static const routeName = 'category-movie';
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  var _isInit = false;
  var _isLoading = false;
  String categoryTitle;
  var categoryId;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
      setState(() {
        _isLoading = true;
      });
      Provider.of<Movies>(context, listen: false)
          .fetchMovies(categoryId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: Provider.of<Movies>(context, listen: false)
                  .fetchMovies(categoryId),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    return Center(
                      child: Text('An Error Ocurred!!'),
                    );
                  } else {
                    return Consumer<Movies>(
                      builder: (ctx, moviesData, chile) =>
                          moviesData.movies.length > 0
                              ? ListView.builder(
                                  itemCount: moviesData.movies.length,
                                  itemBuilder: (ctx, index) =>
                                      MovieItem(moviesData.movies[index]),
                                )
                              : Center(
                                  child: Text(
                                      'No Movies Found For This Category .....'),
                                ),
                    );
                  }
                }
              },
            ),
    );
  }
}
