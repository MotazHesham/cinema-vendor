import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import '../screens/booking_screen.dart';
import '../models/movie.dart';

class MovieItem extends StatefulWidget {
  final Movie movie;

  MovieItem(this.movie);

  @override
  _MovieItemState createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  void selectMovie(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      BookingScreen.routeName,
      arguments: widget.movie.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.movie.cover,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black.withOpacity(0.75),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Center(
                      child: Text(
                        widget.movie.title,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(widget.movie.description),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () => selectMovie(context),
                            child: Text(
                              'Bookings',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: HexColor("#73C6B6"),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              try {
                                await Provider.of<Movies>(context,
                                        listen: false)
                                    .deleteProduct(widget.movie.id);
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text('Movie deleted!'),
                                  ),
                                );
                              } catch (error) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text('Deleteing faild!'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: HexColor("#D98880"),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
