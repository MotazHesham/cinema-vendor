import 'package:flutter/material.dart';

class MovieSlot extends StatefulWidget {
  final Color color;
  final String text;
  final int value;
  final String movieId;
  final List<int> seats;

  MovieSlot({this.color, this.text, this.value, this.movieId, this.seats});

  @override
  _MovieSlotState createState() => _MovieSlotState();
}

class _MovieSlotState extends State<MovieSlot> {
  @override
  Widget build(BuildContext context) {
    final String tx = widget.text;
    Color newColor = widget.color;
    newColor =
        widget.seats.contains(widget.value) ? Colors.green : Colors.white;

    return InkWell(
      onTap: () {
        // setState(() {
        //   widget.color = Colors.green;
        // });
      },
      child: Card(
        color: newColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            tx,
          ),
        ),
      ),
    );
  }
}
